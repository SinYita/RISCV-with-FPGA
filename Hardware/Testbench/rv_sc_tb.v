`timescale 1ns / 1ps

module tb_rv_single_axi();

    // =========================================================
    // 1. 信号定义
    // =========================================================
    reg clk;
    reg rst_n;
    wire done;

    // AXI Instruction Master 信号
    wire [31:0] m_inst_axi_araddr;
    wire        m_inst_axi_arvalid;
    reg         m_inst_axi_arready;
    reg  [31:0] m_inst_axi_rdata;
    reg  [1:0]  m_inst_axi_rresp;
    reg         m_inst_axi_rvalid;
    wire        m_inst_axi_rready;
    wire [2:0]  m_inst_axi_arprot;

    // AXI Data Master 信号
    wire [31:0] m_data_axi_awaddr;
    wire        m_data_axi_awvalid;
    reg         m_data_axi_awready;
    wire [31:0] m_data_axi_wdata;
    wire [3:0]  m_data_axi_wstrb;
    wire        m_data_axi_wvalid;
    reg         m_data_axi_wready;
    reg  [1:0]  m_data_axi_bresp;
    reg         m_data_axi_bvalid;
    wire        m_data_axi_bready;

    wire [31:0] m_data_axi_araddr;
    wire        m_data_axi_arvalid;
    reg         m_data_axi_arready;
    reg  [31:0] m_data_axi_rdata;
    reg  [1:0]  m_data_axi_rresp;
    reg         m_data_axi_rvalid;
    wire        m_data_axi_rready;
    wire [2:0]  m_data_axi_arprot;
    wire [2:0]  m_data_axi_awprot;

    // =========================================================
    // 2. 模拟内存阵列
    // =========================================================
    localparam IMEM_WORDS = 1024;
    localparam DMEM_WORDS = 1024;
    reg [31:0] imem [0:IMEM_WORDS-1];
    reg [31:0] dmem [0:DMEM_WORDS-1];

    // =========================================================
    // 3. 例化待测单周期 CPU
    // =========================================================
    rv_single_axi uut (
        .clk(clk),
        .rst_n(rst_n),
        .done(done),

        .m_inst_axi_araddr(m_inst_axi_araddr), .m_inst_axi_arvalid(m_inst_axi_arvalid), .m_inst_axi_arready(m_inst_axi_arready),
        .m_inst_axi_rdata(m_inst_axi_rdata),   .m_inst_axi_rresp(m_inst_axi_rresp),     .m_inst_axi_rvalid(m_inst_axi_rvalid),
        .m_inst_axi_rready(m_inst_axi_rready), .m_inst_axi_arprot(m_inst_axi_arprot),

        .m_data_axi_awaddr(m_data_axi_awaddr), .m_data_axi_awvalid(m_data_axi_awvalid), .m_data_axi_awready(m_data_axi_awready),
        .m_data_axi_wdata(m_data_axi_wdata),   .m_data_axi_wstrb(m_data_axi_wstrb),     .m_data_axi_wvalid(m_data_axi_wvalid),
        .m_data_axi_wready(m_data_axi_wready), .m_data_axi_bresp(m_data_axi_bresp),     .m_data_axi_bvalid(m_data_axi_bvalid),
        .m_data_axi_bready(m_data_axi_bready),

        .m_data_axi_araddr(m_data_axi_araddr), .m_data_axi_arvalid(m_data_axi_arvalid), .m_data_axi_arready(m_data_axi_arready),
        .m_data_axi_rdata(m_data_axi_rdata),   .m_data_axi_rresp(m_data_axi_rresp),     .m_data_axi_rvalid(m_data_axi_rvalid),
        .m_data_axi_rready(m_data_axi_rready), .m_data_axi_arprot(m_data_axi_arprot),   .m_data_axi_awprot(m_data_axi_awprot)
    );

    // =========================================================
    // 4. 时钟与复位生成
    // =========================================================
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50MHz 时钟
    end

    // =========================================================
    // 5. AXI Slave 模拟逻辑 (带有 1 周期握手延迟)
    // =========================================================
    // --- 5.1 指令内存 (只读) ---
    reg [1:0] i_state;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i_state <= 0;
            m_inst_axi_arready <= 0;
            m_inst_axi_rvalid <= 0;
        end else begin
            case (i_state)
                0: if (m_inst_axi_arvalid) begin
                       m_inst_axi_arready <= 1; // 接收地址
                       i_state <= 1;
                   end
                1: begin
                       m_inst_axi_arready <= 0;
                       m_inst_axi_rvalid <= 1;
                       // 【关键映射】：减去 0x4000_0000 基地址
                       m_inst_axi_rdata <= imem[(m_inst_axi_araddr - 32'h4000_0000) >> 2];
                       i_state <= 2;
                   end
                2: if (m_inst_axi_rready) begin
                       m_inst_axi_rvalid <= 0; // 握手完成
                       i_state <= 0;
                   end
            endcase
        end
    end

    // --- 5.2 数据内存 (读通道) ---
    reg [1:0] dr_state;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dr_state <= 0; m_data_axi_arready <= 0; m_data_axi_rvalid <= 0;
        end else begin
            case (dr_state)
                0: if (m_data_axi_arvalid) begin m_data_axi_arready <= 1; dr_state <= 1; end
                1: begin
                       m_data_axi_arready <= 0; m_data_axi_rvalid <= 1;
                       // 【关键映射】：减去 0x4200_0000 基地址
                       m_data_axi_rdata <= dmem[(m_data_axi_araddr - 32'h4200_0000) >> 2];
                       dr_state <= 2;
                   end
                2: if (m_data_axi_rready) begin m_data_axi_rvalid <= 0; dr_state <= 0; end
            endcase
        end
    end

    // --- 5.3 数据内存 (写通道) ---
    reg [1:0] dw_state;
    reg [31:0] waddr_latch;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dw_state <= 0; m_data_axi_awready <= 0; m_data_axi_wready <= 0; m_data_axi_bvalid <= 0;
        end else begin
            case (dw_state)
                0: if (m_data_axi_awvalid) begin
                       m_data_axi_awready <= 1;
                       waddr_latch <= m_data_axi_awaddr; // 锁存地址
                       dw_state <= 1;
                   end
                1: begin
                       m_data_axi_awready <= 0;
                       if (m_data_axi_wvalid) begin
                           m_data_axi_wready <= 1;
                           // 【关键映射】：减去 0x4200_0000 基地址写入
                           dmem[(waddr_latch - 32'h4200_0000) >> 2] <= m_data_axi_wdata;
                           dw_state <= 2;
                       end
                   end
                2: begin
                       m_data_axi_wready <= 0;
                       m_data_axi_bvalid <= 1;
                       m_data_axi_bresp  <= 2'b00; // 返回 OKAY 响应
                       dw_state <= 3;
                   end
                3: if (m_data_axi_bready) begin
                       m_data_axi_bvalid <= 0; // 握手完成
                       dw_state <= 0;
                   end
            endcase
        end
    end

    // =========================================================
    // 6. 测试激励与数据验证 (模拟 Python 脚本的行为)
    // =========================================================
    integer i;
    initial begin
        // 6.1 初始化内存为 0
        for (i = 0; i < IMEM_WORDS; i = i + 1) imem[i] = 32'd0;
        for (i = 0; i < DMEM_WORDS; i = i + 1) dmem[i] = 32'd0;

        // 6.2 灌入冒泡排序机器码
        imem[0] = 32'h42000437; imem[1] = 32'h00700293; imem[2] = 32'h00542023; imem[3] = 32'h00300293;
        imem[4] = 32'h00542223; imem[5] = 32'h00500293; imem[6] = 32'h00542423; imem[7] = 32'h00200293;
        imem[8] = 32'h00542623; imem[9] = 32'h00900293; imem[10]= 32'h00542823; imem[11]= 32'h00100293;
        imem[12]= 32'h00542A23; imem[13]= 32'h00800293; imem[14]= 32'h00542C23; imem[15]= 32'h00400293;
        imem[16]= 32'h00542E23; imem[17]= 32'h00700493; imem[18]= 32'h02048E63; imem[19]= 32'h00900933;
        imem[20]= 32'h008009B3; imem[21]= 32'h02090463; imem[22]= 32'h0009A283; imem[23]= 32'h0049A303;
        imem[24]= 32'h005323B3; imem[25]= 32'h00038663; imem[26]= 32'h0069A023; imem[27]= 32'h0059A223;
        imem[28]= 32'h00498993; imem[29]= 32'hFFF90913; imem[30]= 32'hFDDFF06F; imem[31]= 32'hFFF48493;
        imem[32]= 32'hFC9FF06F; imem[33]= 32'h42002E37; imem[34]= 32'hFFCE0E13; imem[35]= 32'hDEADCEB7;
        imem[36]= 32'hEEFE8E93; imem[37]= 32'h01DE2023; imem[38]= 32'h0000006F;

        // 初始化待排序数据 (假设 Python 脚本写入了这 8 个无序数字)
        dmem[0] = 32'd9; dmem[1] = 32'd2; dmem[2] = 32'd7; dmem[3] = 32'd4;
        dmem[4] = 32'd5; dmem[5] = 32'd1; dmem[6] = 32'd8; dmem[7] = 32'd3;

        // 6.3 施加复位信号，启动 CPU
        $display("Starting CPU Simulation...");
        rst_n = 0;
        #100;
        rst_n = 1; 

        // 6.4 等待 done 信号拉高 (设置一个超时机制防死锁)
       begin : WAIT_BLOCK
            fork
                begin
                    wait(done == 1'b1);
                    $display("\n[SUCCESS] CPU asserts DONE flag at time %0t", $time);
                    disable WAIT_BLOCK; // 成功后立刻跳出并杀掉整个 WAIT_BLOCK（包括超时分支）
                end
                begin
                    #500000; // 如果跑了很久都没完，强制结束
                    $display("\n[ERROR] Simulation Timeout! CPU might be deadlocked.");
                    $finish;
                end
            join
        end

        #50;

        // 6.5 打印最终排序结果
        $display("===========================================");
        $display(" Bubble Sort Verification (Single-Cycle)   ");
        $display("===========================================");
        for (i = 0; i < 8; i = i + 1) begin
            $display(" DMEM[0x%0h] = %0d", 32'h4200_0000 + (i*4), dmem[i]);
        end
        $display("===========================================");
        $finish;
    end

endmodule