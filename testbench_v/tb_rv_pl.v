`timescale 1ns/1ps

module tb_rv_pl;

  // clock/reset
  reg clk = 0;
  reg rst_n = 0;

  // DUT ports
  wire [31:0] imem_addr;
  reg  [31:0] imem_rdata;

  wire        dmem_we;
  wire [31:0] dmem_addr;
  wire [31:0] dmem_wdata;
  reg  [31:0] dmem_rdata;

  // Instantiate DUT
  rv_pl dut (
          .clk(clk),
          .rst_n(rst_n),
          .imem_addr(imem_addr),
          .imem_rdata(imem_rdata),
          .dmem_we(dmem_we),
          .dmem_addr(dmem_addr),
          .dmem_wdata(dmem_wdata),
          .dmem_rdata(dmem_rdata)
        );

  // clock 100MHz -> 10ns period
  always #5 clk = ~clk;

  // ---------------------------------------------------------------------------
  // Simple synchronous memory models (1-cycle read latency)
  // ---------------------------------------------------------------------------
  localparam IMEM_WORDS = 4096;  // 16KB
  localparam DMEM_WORDS = 4096;  // 16KB

  reg [31:0] imem [0:IMEM_WORDS-1];
  reg [31:0] dmem [0:DMEM_WORDS-1];

  // address to word index
  wire [31:0] imem_widx = imem_addr >> 2;
  wire [31:0] dmem_widx = dmem_addr >> 2;

  // 1-cycle read latency registers
  reg [31:0] imem_widx_q;
  reg [31:0] dmem_widx_q;

  // write monitor for DONE
  localparam DONE_ADDR  = 32'h00002000;
  localparam DONE_VALUE = 32'hCAFEBABE;

  integer i;

  // IMEM read: synchronous, 1-cycle latency
  always @(posedge clk)
  begin
    imem_widx_q <= imem_widx;
    if (imem_widx_q < IMEM_WORDS)
      imem_rdata <= imem[imem_widx_q];
    else
      imem_rdata <= 32'h00000013; // NOP (ADDI x0,x0,0)
  end

  // DMEM read/write: synchronous, 1-cycle read latency
  always @(posedge clk)
  begin
    dmem_widx_q <= dmem_widx;

    // read
    if (dmem_widx_q < DMEM_WORDS)
      dmem_rdata <= dmem[dmem_widx_q];
    else
      dmem_rdata <= 32'h0;

    // write (word store only)
    if (dmem_we)
    begin
      if (dmem_widx < DMEM_WORDS)
        dmem[dmem_widx] <= dmem_wdata;

      // DONE detection
      if (dmem_addr == DONE_ADDR && dmem_wdata == DONE_VALUE)
      begin
        $display("[PASS] DONE flag written: addr=%h data=%h time=%0t", dmem_addr, dmem_wdata, $time);
        // dump a few memory words if you want
        $finish;
      end
    end
  end

  // ---------------------------------------------------------------------------
  // Program loading
  // ---------------------------------------------------------------------------
  task load_imem_hex(input [1023:0] filename);
    begin
      $display("Loading IMEM from %s ...", filename);
      $readmemh(filename, imem);
    end
  endtask

  // Init memories
  task init_memories;
    begin
      for (i = 0; i < IMEM_WORDS; i = i + 1)
        imem[i] = 32'h00000013; // NOP
      for (i = 0; i < DMEM_WORDS; i = i + 1)
        dmem[i] = 32'h0;
    end
  endtask

  // ---------------------------------------------------------------------------
  // Test sequence
  // ---------------------------------------------------------------------------
  initial
  begin
    $dumpfile("tb_rv_pl.vcd");
    $dumpvars(0, tb_rv_pl);

    init_memories();

    //load test change here for other tests
    load_imem_hex("smoke_done.hex");

    // reset
    rst_n = 0;
    repeat (10) @(posedge clk);
    rst_n = 1;

    // timeout guard
    repeat (20000) @(posedge clk);
    $display("[FAIL] Timeout: DONE flag not written within cycle budget");
    $finish;
  end

endmodule
