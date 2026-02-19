`timescale 1ns/1ps

module tb_rv_pl_diagnostic;
    reg clk = 0;
    reg rst_n = 0;
    wire [31:0] inst_addr, data_addr, data_wdata;
    reg  [31:0] inst_rdata, data_rdata;
    wire        data_we, done;

    // 实例化 CPU
    rv_pl dut (
        .clk(clk), .rst_n(rst_n),
        .inst_addr(inst_addr), .inst_rdata(inst_rdata),
        .data_we(data_we), .data_addr(data_addr), 
        .data_wdata(data_wdata), .data_rdata(data_rdata),
        .done(done)
    );

    always #5 clk = ~clk;

    // 1k字指令存储器
    reg [31:0] imem [0:1023];
    always @(*) inst_rdata = imem[inst_addr[11:2]];

    // 1k字数据存储器
    reg [31:0] dmem [0:1023];
    always @(posedge clk) begin
        if (data_we) begin
            dmem[data_addr[11:2]] <= data_wdata;
            if (data_addr != 32'h00002000) // 不打印done标志写入
                $display("[DMEM_WRITE] Addr: 0x%h <= Data: 0x%h (%0d)", data_addr, data_wdata, data_wdata);
        end
    end
    always @(*) data_rdata = dmem[data_addr[11:2]];

    integer i;
    task display_sorted_array;
        begin
            $display("\n╔════════════════════════════════════════╗");
            $display("║     Sorted Array (Address 0x64-0x8B)  ║");
            $display("╠════════════════════════════════════════╣");
            for (i = 0; i < 10; i = i + 1) begin
                $display("║ arr[%0d] @ 0x%h = %3d (0x%h)       ║", 
                         i, 100 + i*4, dmem[(100 + i*4)/4], dmem[(100 + i*4)/4]);
            end
            $display("╚════════════════════════════════════════╝");
        end
    endtask

    initial begin
        // 初始化指令和数据内存
        $readmemh("sort.hex", imem);
        for (i = 0; i < 1024; i = i + 1) dmem[i] = 32'b0;
        
        // 复位序列
        rst_n = 0; #100; rst_n = 1;
        $display("\n╔═══════════════════════════════════════════════════════╗");
        $display("║  RISC-V Pipeline Bubble Sort Test - FPGA Version     ║");
        $display("║  Testing: JAL, BEQ, LW, SW, SLT, and Control Logic  ║");
        $display("╚═══════════════════════════════════════════════════════╝\n");
        $display("[INFO] Reset released. Starting bubble sort of 10 numbers...\n");

        fork
            // 1. 监控成功标志
            begin
                wait(done == 1'b1);
                #50; // 等待最后的写入完成
                $display("\n╔════════════════════════════════════════════════════════╗");
                $display("║               ✓ BUBBLE SORT COMPLETED!                ║");
                $display("╚════════════════════════════════════════════════════════╝");
                display_sorted_array();
                
                // 验证排序正确性
                if (dmem[25] == 11 && dmem[26] == 12 && dmem[27] == 22 && 
                    dmem[28] == 25 && dmem[29] == 34 && dmem[30] == 45 &&
                    dmem[31] == 56 && dmem[32] == 64 && dmem[33] == 78 && dmem[34] == 90) begin
                    $display("\n✓✓✓ PASS: Array is correctly sorted! ✓✓✓");
                    $display("✓✓✓ JAL and BEQ instructions working correctly! ✓✓✓\n");
                end else begin
                    $display("\n✗✗✗ FAIL: Array is NOT correctly sorted! ✗✗✗\n");
                end
                
                #100 $finish;
            end

            // 2. 核心诊断逻辑
            begin
                forever begin
                    @(posedge clk);
                    // 如果 PC 跑飞到非预期范围
                    if (inst_addr > 32'h0000_01FF && inst_addr !== 32'hX) begin
                        $display("\n[ERROR] PC Exploded to 0x%h!", inst_addr);
                        $display("--- EX Stage Data ---");
                        $display("E_PC       : 0x%h", dut.datapath_inst.E_pc);
                        $display("E_ImmExt   : 0x%h (signed: %0d)", 
                                 dut.datapath_inst.E_imm_ext, $signed(dut.datapath_inst.E_imm_ext));
                        $display("E_Target   : 0x%h", dut.datapath_inst.E_target_PC);
                        $display("E_PCSrc    : %b", dut.E_pcsrc);
                        $display("E_Branch   : %b", dut.controller_inst.E_branch);
                        $display("E_Jump     : %b", dut.controller_inst.E_jump);
                        $display("ZeroE      : %b", dut.datapath_inst.ZeroE);
                        $finish;
                    end
                    
                    // 打印跳转发生时的详细情况
                    if (dut.E_pcsrc === 1'b1) begin
                        $display("[JUMP_TAKEN] Time: %0t | From PC: 0x%h | Target: 0x%h | Branch:%b Jump:%b Zero:%b", 
                                 $time, dut.datapath_inst.E_pc, dut.datapath_inst.E_target_PC,
                                 dut.controller_inst.E_branch, dut.controller_inst.E_jump, dut.datapath_inst.ZeroE);
                    end
                end
            end

            // 3. 超时保护（冒泡排序需要更长时间）
            begin
                #50000;
                $display("\n[TIMEOUT] Test failed. Bubble sort did not complete in time.");
                $display("Last PC: 0x%h", inst_addr);
                $display("Partial array state:");
                display_sorted_array();
                $finish;
            end
        join
    end
    
    initial begin
        $dumpfile("rv_pl_fpga_sim.vcd");
        $dumpvars(0, tb_rv_pl_diagnostic);
    end
endmodule