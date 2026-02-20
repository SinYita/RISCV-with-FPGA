`timescale 1ns/1ps

module tb_rv_pl;

  // --- 时钟与复位 ---
  reg clk = 0;
  reg rst_n = 0;

  // --- DUT 端口连接线 ---
  wire [31:0] imem_addr;
  wire [31:0] imem_rdata; // 这里的引脚改回 wire，由 TB 的内存模型驱动
  wire        dmem_we;
  wire [31:0] dmem_addr;
  wire [31:0] dmem_wdata;
  wire [31:0] dmem_rdata; // 这里的引脚改回 wire
  wire        done;

  // --- 内部寄存器用于模拟存储器行为 ---
  reg [31:0] imem_rdata_reg;
  reg [31:0] dmem_rdata_reg;
  assign imem_rdata = imem_rdata_reg;
  assign dmem_rdata = dmem_rdata_reg;

  // --- 实例化 DUT ---
  rv_pl dut (
    .clk(clk),
    .rst_n(rst_n),
    .inst_addr(imem_addr),
    .inst_rdata(imem_rdata),
    .data_addr(dmem_addr),
    .data_wdata(dmem_wdata),
    .data_rdata(dmem_rdata),
    .data_we(dmem_we),
    .done(done)
  );

  // 时钟：100MHz (10ns 周期)
  always #5 clk = ~clk;

  // --- 存储器模型定义 ---
  localparam IMEM_WORDS = 4096;
  localparam DMEM_WORDS = 4096;
  reg [31:0] imem [0:IMEM_WORDS-1];
  reg [31:0] dmem [0:DMEM_WORDS-1];

  // 地址转索引 (字节地址 >> 2)
  wire [31:0] imem_widx = imem_addr >> 2;
  wire [31:0] dmem_widx = dmem_addr >> 2;

  // --- 同步读取逻辑 (模拟 FPGA BRAM: 1-cycle latency) ---
  always @(posedge clk) begin
    // 指令内存读取
    if (imem_widx < IMEM_WORDS)
      imem_rdata_reg <= imem[imem_widx];
    else
      imem_rdata_reg <= 32'h00000013; // NOP (addi x0, x0, 0)

    // 数据内存读取
    if (dmem_widx < DMEM_WORDS)
      dmem_rdata_reg <= dmem[dmem_widx];
    else
      dmem_rdata_reg <= 32'h0;
  end

  // --- 数据内存写入逻辑 ---
  always @(posedge clk) begin
    if (dmem_we) begin
      if (dmem_widx < DMEM_WORDS)
        dmem[dmem_widx] <= dmem_wdata;
    end
  end

  // --- 核心修改：使用 done 信号结束仿真 ---
  always @(posedge clk) begin
    if (rst_n && done) begin
      $display("\n==================================================");
      $display("[PASS] DONE Signal Detected!");
      $display("Time      : %0t", $time);
      $display("Final Write: Addr=%h, Data=%h", dmem_addr, dmem_wdata);
      $display("==================================================\n");
      $finish;
    end
  end

  // --- 初始化与加载 ---
  task load_imem_hex(input [1023:0] filename);
    begin
      $display("Loading IMEM from %0s ...", filename);
      $readmemh(filename, imem);
    end
  endtask

  initial begin
    // 1. 初始化内存
    for (integer j = 0; j < IMEM_WORDS; j = j + 1) imem[j] = 32'h00000013;
    for (integer j = 0; j < DMEM_WORDS; j = j + 1) dmem[j] = 32'h0;

    // 2. 波形 dump
    $dumpfile("tb_rv_pl.vcd");
    $dumpvars(0, tb_rv_pl);

    // 3. 加载程序
    load_imem_hex("smoke_done.hex");

    // 4. 执行复位
    rst_n = 0;
    repeat (10) @(posedge clk);
    rst_n = 1;
    $display("CPU Reset Released. Running...");

    // 5. 超时监控
    repeat (1000) @(posedge clk); // smoke test 不需要 20000 这么久
    $display("\n[FAIL] Timeout: DONE signal not asserted.");
    $finish;
  end

endmodule