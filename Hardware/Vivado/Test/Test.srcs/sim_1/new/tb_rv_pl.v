`timescale 1ns/1ps

module tb_rv_pl_axi;

    reg clk = 0;
    reg rst_n = 0;

    // -------------------------
    // DUT AXI ports (match rv_pl)
    // -------------------------
    wire [31:0] m_inst_axi_araddr;
    wire        m_inst_axi_arvalid;
    reg         m_inst_axi_arready;
    reg  [31:0] m_inst_axi_rdata;
    reg  [1:0]  m_inst_axi_rresp;
    reg         m_inst_axi_rvalid;
    wire        m_inst_axi_rready;
    wire [2:0]  m_inst_axi_arprot;

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

    wire done;

    // -------------------------
    // Instantiate DUT
    // -------------------------
    rv_pl dut (
        .clk(clk),
        .rst_n(rst_n),

        .m_inst_axi_araddr (m_inst_axi_araddr),
        .m_inst_axi_arvalid(m_inst_axi_arvalid),
        .m_inst_axi_arready(m_inst_axi_arready),
        .m_inst_axi_rdata  (m_inst_axi_rdata),
        .m_inst_axi_rresp  (m_inst_axi_rresp),
        .m_inst_axi_rvalid (m_inst_axi_rvalid),
        .m_inst_axi_rready (m_inst_axi_rready),
        .m_inst_axi_arprot (m_inst_axi_arprot),

        .m_data_axi_awaddr (m_data_axi_awaddr),
        .m_data_axi_awvalid(m_data_axi_awvalid),
        .m_data_axi_awready(m_data_axi_awready),
        .m_data_axi_wdata  (m_data_axi_wdata),
        .m_data_axi_wstrb  (m_data_axi_wstrb),
        .m_data_axi_wvalid (m_data_axi_wvalid),
        .m_data_axi_wready (m_data_axi_wready),
        .m_data_axi_bresp  (m_data_axi_bresp),
        .m_data_axi_bvalid (m_data_axi_bvalid),
        .m_data_axi_bready (m_data_axi_bready),

        .m_data_axi_araddr (m_data_axi_araddr),
        .m_data_axi_arvalid(m_data_axi_arvalid),
        .m_data_axi_arready(m_data_axi_arready),
        .m_data_axi_rdata  (m_data_axi_rdata),
        .m_data_axi_rresp  (m_data_axi_rresp),
        .m_data_axi_rvalid (m_data_axi_rvalid),
        .m_data_axi_rready (m_data_axi_rready),
        .m_data_axi_arprot (m_data_axi_arprot),
        .m_data_axi_awprot (m_data_axi_awprot),

        .done(done)
    );

    // clock 100MHz
    always #5 clk = ~clk;

    // -------------------------
    // Memory models
    // -------------------------
    localparam IMEM_WORDS = 4096;
    localparam DMEM_WORDS = 4096;
    localparam DMEM_BASE  = 32'h4200_0000;
    localparam DONE_ADDR  = 32'h4200_1FFC;
    
    // 模拟真实的内存延迟 (可以把这里改成 3, 5, 10 等等来压力测试流水线)
    localparam MEM_LATENCY = 2; 

    reg [31:0] imem [0:IMEM_WORDS-1];
    reg [31:0] dmem [0:DMEM_WORDS-1];

    // ---------------------------------------------------------
    // 真实的 AXI-Lite Slave 模型 (带延迟状态机)
    // ---------------------------------------------------------
    
    // 1. Instruction Memory (Read Only) 状态机
    integer i_cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            m_inst_axi_arready <= 0;
            m_inst_axi_rvalid  <= 0;
            m_inst_axi_rdata   <= 0;
            m_inst_axi_rresp   <= 0;
            i_cnt              <= 0;
        end else begin
            // 握手结束，撤销 RVALID
            if (m_inst_axi_rvalid && m_inst_axi_rready) begin
                m_inst_axi_rvalid <= 0;
            end
            
            // 接收请求并拉高 READY
            if (m_inst_axi_arvalid && !m_inst_axi_arready && !m_inst_axi_rvalid && i_cnt == 0) begin
                m_inst_axi_arready <= 1;
                i_cnt <= MEM_LATENCY; // 启动延迟计数器
            end else if (m_inst_axi_arready) begin
                m_inst_axi_arready <= 0; // READY 只能维持一拍
            end
            
         // 延迟计数
            if (i_cnt > 0) begin
                i_cnt <= i_cnt - 1;
                if (i_cnt == 1) begin
                    m_inst_axi_rvalid <= 1;
                    // 【核心修改】减去 0x4000_0000 基地址，再映射到 imem 数组
                    if (((m_inst_axi_araddr - 32'h4000_0000) >> 2) < IMEM_WORDS)
                        m_inst_axi_rdata <= imem[(m_inst_axi_araddr - 32'h4000_0000) >> 2];
                    else
                        m_inst_axi_rdata <= 32'h00000013; // NOP
                end
            end
        end
    end

    // 2. Data Memory 状态机
    integer d_r_cnt, d_b_cnt;
    reg [31:0] awaddr_latch;
    reg aw_done, w_done;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            m_data_axi_arready <= 0;
            m_data_axi_rvalid  <= 0;
            m_data_axi_rdata   <= 0;
            m_data_axi_rresp   <= 0;
            m_data_axi_awready <= 0;
            m_data_axi_wready  <= 0;
            m_data_axi_bvalid  <= 0;
            m_data_axi_bresp   <= 0;
            d_r_cnt <= 0;
            d_b_cnt <= 0;
            aw_done <= 0;
            w_done  <= 0;
        end else begin
            // --- 读通道 (保持不变) ---
            if (m_data_axi_rvalid && m_data_axi_rready) m_data_axi_rvalid <= 0;
            if (m_data_axi_arvalid && !m_data_axi_arready && !m_data_axi_rvalid && d_r_cnt == 0) begin
                m_data_axi_arready <= 1;
                d_r_cnt <= MEM_LATENCY;
            end else if (m_data_axi_arready) begin
                m_data_axi_arready <= 0;
            end
            if (d_r_cnt > 0) begin
                d_r_cnt <= d_r_cnt - 1;
                if (d_r_cnt == 1) begin
                    m_data_axi_rvalid <= 1;
                    if (((m_data_axi_araddr - DMEM_BASE) >> 2) < DMEM_WORDS)
                        m_data_axi_rdata <= dmem[(m_data_axi_araddr - DMEM_BASE) >> 2];
                    else
                        m_data_axi_rdata <= 32'h0;
                end
            end

            // --- 写通道 (全新重构，解耦 AW 和 W 通道) ---
            if (m_data_axi_bvalid && m_data_axi_bready) m_data_axi_bvalid <= 0;
            
            // 独立接收地址 (AW Channel)
            if (m_data_axi_awvalid && !m_data_axi_awready && !aw_done) begin
                m_data_axi_awready <= 1;
                awaddr_latch <= m_data_axi_awaddr;
            end else if (m_data_axi_awready) begin
                m_data_axi_awready <= 0;
                aw_done <= 1;
            end

            // 独立接收数据 (W Channel) 并执行写入
            if (m_data_axi_wvalid && !m_data_axi_wready && !w_done) begin
                m_data_axi_wready <= 1;
                // 确保地址落在 DMEM 范围内才执行写入
                if (((aw_done ? awaddr_latch : m_data_axi_awaddr) - DMEM_BASE) >> 2 < DMEM_WORDS) begin
                     dmem[((aw_done ? awaddr_latch : m_data_axi_awaddr) - DMEM_BASE) >> 2] <= m_data_axi_wdata;
                end
            end else if (m_data_axi_wready) begin
                m_data_axi_wready <= 0;
                w_done <= 1;
            end

            // 生成 B 响应 (等到地址和数据都收到后)
            if (aw_done && w_done && d_b_cnt == 0 && !m_data_axi_bvalid) begin
                d_b_cnt <= MEM_LATENCY; // 模拟写响应延迟
            end
            
            if (d_b_cnt > 0) begin
                d_b_cnt <= d_b_cnt - 1;
                if (d_b_cnt == 1) begin
                    m_data_axi_bvalid <= 1;
                    aw_done <= 0; // 重置状态，准备下一次握手
                    w_done  <= 0;
                end
            end
        end
    end
    // -------------------------
    // Bubble sort result check
    // -------------------------
    localparam DATA_BASE = 32'h4200_0000; 
    reg [31:0] expected [0:7];
    integer k;
    reg pass;

    initial begin
        expected[0]=32'd1;
        expected[1]=32'd2;
        expected[2]=32'd3;
        expected[3]=32'd4;
        expected[4]=32'd5;
        expected[5]=32'd7;
        expected[6]=32'd8;
        expected[7]=32'd9;
    end

    task check_sorted;
        reg [31:0] val;
        integer idx;
        begin
            pass = 1;
            for (k=0; k<8; k=k+1) begin
                idx = ((DATA_BASE - DMEM_BASE) >> 2) + k;
                if (idx < 0 || idx >= DMEM_WORDS) begin
                    $display("[FAIL] TB mapping error: idx out of range (%0d)", idx);
                    pass = 0;
                end else begin
                    val = dmem[idx];
                    if (val !== expected[k]) begin
                        $display("[FAIL] bubble sort mismatch at idx=%0d addr=%h got=%h expect=%h",
                                 k, DATA_BASE + (k<<2), val, expected[k]);
                        pass = 0;
                    end
                end
            end
            if (pass) begin
                $display("[PASS] bubble sort OK: array sorted correctly.");
            end else begin
                $display("[FAIL] bubble sort FAILED: array not sorted.");
            end
        end
    endtask

    // -------------------------
    // Instrumentation
    // -------------------------
    always @(posedge clk) begin
        // 这里需要加上 m_data_axi_awready 判断，因为写握手在 ready 阶段才真正发生
        if (m_data_axi_awvalid && m_data_axi_wvalid && m_data_axi_awready) begin
            if (m_data_axi_awaddr == DONE_ADDR) begin
                $display("[TB] STORE to DONE_ADDR: data=%h time=%0t", m_data_axi_wdata, $time);
            end
        end
    end

    always @(posedge clk) begin
        if (rst_n && done) begin
            $display("[PASS] done asserted at t=%0t", $time);
            $display("[TB] checking bubble sort result...");
            check_sorted();
            $finish;
        end
    end

    // -------------------------
    // Program load / reset / timeout
    // -------------------------
    integer i;
    initial begin
        for (i=0;i<IMEM_WORDS;i=i+1) imem[i] = 32'h00000013;
        for (i=0;i<DMEM_WORDS;i=i+1) dmem[i] = 32'h0;

        // 【请确保此处路径正确】
        $readmemh("bubble_sort.hex", imem);

        rst_n = 0;
        repeat(10) @(posedge clk);
        rst_n = 1;

        // timeout 放宽一点，因为加入了 AXI 延迟，执行周期会变长
        repeat(100000) @(posedge clk);
        $display("[FAIL] timeout, done not asserted");
        $finish;
    end

endmodule