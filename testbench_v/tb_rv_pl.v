`timescale 1ns/1ps

module tb_rv_pl;
    reg clk = 0;
    reg rst_n = 0;
    wire [31:0] inst_addr, data_addr, data_wdata;
    reg  [31:0] inst_rdata, data_rdata;
    wire        data_we, done;

    // 实例化 CPU
    rv_pl dut (
        .clk(clk), .rst_n(rst_n),
        .inst_addr(inst_addr), .inst_rdata(inst_rdata),
        .data_we(data_we), .data_addr(data_addr), .data_wdata(data_wdata), .data_rdata(data_rdata),
        .done(done)
    );

    always #5 clk = ~clk;

    localparam IMEM_WORDS = 4096;
    localparam DMEM_WORDS = 4096;
    reg [31:0] imem [0:IMEM_WORDS-1];
    reg [31:0] dmem [0:DMEM_WORDS-1];

    // 内存逻辑：同步读取（1拍延迟）
    always @(posedge clk) begin
        inst_rdata <= imem[inst_addr >> 2];
        if (data_we) begin
            dmem[data_addr >> 2] <= data_wdata;
            // 监控写操作
            $display("[MEM_WRITE] Time: %0t | Addr: 0x%h | Data: 0x%h", $time, data_addr, data_wdata);
            if (data_addr == 32'h00002000)
                $display(">>> ALERT: Magic Number Write Attempted: 0x%h", data_wdata);
        end
        data_rdata <= dmem[data_addr >> 2];
    end

    integer i;
    initial begin
        // 1. 初始化内存
        for (i = 0; i < IMEM_WORDS; i = i + 1) imem[i] = 32'h00000013;
        for (i = 0; i < DMEM_WORDS; i = i + 1) dmem[i] = 32'h0;

        // 2. 写入待排序数据 (32, 31, ... 1) 到地址 0x0 开始的区域
        for (i = 0; i < 32; i = i + 1) dmem[i] = 32 - i;

        // 3. 加载机器码
        $readmemh("sort.hex", imem);
        
        // 4. 开始仿真
        rst_n = 0; #100 rst_n = 1;
        $display("[SYSTEM] CPU Reset Released. Sort started...");

        fork
            // 成功路径
            begin
                wait(done == 1'b1);
                $display("\n==================================================");
                $display("   SUCCESS: DONE SIGNAL DETECTED!   ");
                $display("   Time: %0t   ", $time);
                $display("==================================================");
                $display(" Index | Address | Value");
                for (i = 0; i < 32; i = i + 1) begin
                    $display("  #%02d  |  0x%h  |  %d", i, i*4, dmem[i]);
                end
                $display("==================================================\n");
                #100 $finish;
            end

            // 实时追踪核心寄存器 (s2=x18, t0=x5, t1=x6)
            begin
                forever begin
                    repeat (1000) @(posedge clk);
                    // 这里的 .RF.Register 是根据你的顶层例化名和内部数组名确定的
                    $display("[TRACE] PC: 0x%h | s2(addr_ptr): %d | t0: %d | t1: %d", 
                             inst_addr, 
                             dut.RF.Register[18], 
                             dut.RF.Register[5], 
                             dut.RF.Register[6]);
                end
            end

            // 超时限制 (10ms)
            begin
                #10_000_000; 
                $display("\n[FAIL] Timeout! Check if PC is stuck or Magic Number never written.");
                $display("[DEBUG] Last PC: 0x%h", inst_addr);
                $finish;
            end
        join
    end
endmodule