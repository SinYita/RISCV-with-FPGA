`include "define.v"

module rv_pl(
    // ============================================================
    // 0. 时钟与复位 
    // ============================================================
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF M_INST_AXI:M_DATA_AXI, ASSOCIATED_RESET rst_n" *)
    input  wire        clk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    input  wire        rst_n,

    // ============================================================
    // 1. AXI4-Lite Instruction Master (取指 - 只读)
    // ============================================================
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI ARADDR" *)  output wire [31:0] m_inst_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI ARVALID" *) output wire        m_inst_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI ARREADY" *) input  wire        m_inst_axi_arready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI RDATA" *)   input  wire [31:0] m_inst_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI RRESP" *)   input  wire [1:0]  m_inst_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI RVALID" *)  input  wire        m_inst_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI RREADY" *)  output wire        m_inst_axi_rready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI ARPROT" *)  output wire [2:0]  m_inst_axi_arprot,

    // ============================================================
    // 2. AXI4-Lite Data Master (访存 - 读写)
    // ============================================================
    // 写通道
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI AWADDR" *)  output wire [31:0] m_data_axi_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI AWVALID" *) output wire        m_data_axi_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI AWREADY" *) input  wire        m_data_axi_awready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI WDATA" *)   output wire [31:0] m_data_axi_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI WSTRB" *)   output wire [3:0]  m_data_axi_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI WVALID" *)  output wire        m_data_axi_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI WREADY" *)  input  wire        m_data_axi_wready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI BRESP" *)   input  wire [1:0]  m_data_axi_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI BVALID" *)  input  wire        m_data_axi_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI BREADY" *)  output wire        m_data_axi_bready,
    // 读通道
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI ARADDR" *)  output wire [31:0] m_data_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI ARVALID" *) output wire        m_data_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI ARREADY" *) input  wire        m_data_axi_arready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI RDATA" *)   input  wire [31:0] m_data_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI RRESP" *)   input  wire [1:0]  m_data_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI RVALID" *)  input  wire        m_data_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI RREADY" *)  output wire        m_data_axi_rready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI ARPROT" *)  output wire [2:0]  m_data_axi_arprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI AWPROT" *)  output wire [2:0]  m_data_axi_awprot,

    // ============================================================
    // 3. 物理引脚信号
    // ============================================================
    output reg         done
);

    // --- 内部流水线信号 ---
    wire [31:0] F_pc, F_instr, D_instr, D_rf_rd1, D_rf_rd2, W_result, M_alu_o, M_rf_wd, M_dm_rd;
    wire [4:0]  D_rf_a1, D_rf_a2, E_rf_a1, E_rf_a2, E_rf_a3, M_rf_a3, W_rf_a3;
    wire [3:0]  E_alu_control;
    wire [2:0]  D_sel_ext;
    wire [1:0]  E_sel_result, M_sel_result, W_sel_result, E_fd_A, E_fd_B;
    wire        E_pcsrc, E_sel_alu_src_b, E_we_rf, M_we_rf, M_we_dm, W_we_rf, ZeroE;
    wire        F_stall, D_flush, D_stall, E_flush;

    // ============================================================
    // 4. AXI4-Lite 状态机与握手逻辑
    // ============================================================
    wire axi_stall; 

    // ------------------------------------------------------------
    // 4.1 取指 (Instruction Fetch) 状态机
    // ------------------------------------------------------------
    localparam IF_REQ   = 2'd0;
    localparam IF_WAIT  = 2'd1;
    localparam IF_DONE  = 2'd2; 
    
    reg [1:0] if_state;
    reg [31:0] inst_latch; 

    wire data_waiting; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            if_state   <= IF_REQ;
            inst_latch <= 32'h00000013; // NOP
        end else begin
            case (if_state)
                IF_REQ: begin
                    if (m_inst_axi_arready && !data_waiting) begin
                        if_state <= IF_WAIT;
                    end
                end
                IF_WAIT: begin
                    if (m_inst_axi_rvalid) begin
                        inst_latch <= m_inst_axi_rdata; 
                        if (axi_stall) begin
                            if_state <= IF_DONE;
                        end else begin
                            if_state <= IF_REQ; 
                        end
                    end
                end
                IF_DONE: begin
                    if (!axi_stall) begin
                        if_state <= IF_REQ;
                    end
                end
                default: if_state <= IF_REQ;
            endcase
        end
    end

   assign m_inst_axi_arvalid = rst_n && (if_state == IF_REQ) && !data_waiting;
    assign m_inst_axi_araddr  = F_pc + 32'h4000_0000; // 让 CPU 透明访问 0x4000_0000
    assign m_inst_axi_arprot  = 3'b000;
    assign m_inst_axi_rready  = rst_n && (if_state == IF_WAIT);

    wire inst_waiting = (if_state == IF_REQ) || (if_state == IF_WAIT && !m_inst_axi_rvalid);
    assign F_instr = (if_state == IF_WAIT && m_inst_axi_rvalid) ? m_inst_axi_rdata : inst_latch;

    // ------------------------------------------------------------
    // 4.2 访存 (Data Memory) 状态机
    // ------------------------------------------------------------
    localparam MEM_IDLE  = 3'd0;
    localparam MEM_WADDR = 3'd1;
    localparam MEM_WDATA = 3'd2;
    localparam MEM_WRESP = 3'd3;
    localparam MEM_RADDR = 3'd4;
    localparam MEM_RDATA = 3'd5;
    localparam MEM_DONE  = 3'd6; 

    reg [2:0] mem_state;
    reg [31:0] data_latch;

    wire is_load  = (M_sel_result == 2'b01);
    wire is_store = M_we_dm;
    wire mem_req  = is_load || is_store;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem_state  <= MEM_IDLE;
            data_latch <= 32'd0;
        end else begin
            case (mem_state)
                MEM_IDLE: begin
                    if (mem_req) begin
                        mem_state <= is_store ? MEM_WADDR : MEM_RADDR;
                    end
                end
                MEM_WADDR: if (m_data_axi_awready) mem_state <= MEM_WDATA;
                MEM_WDATA: if (m_data_axi_wready)  mem_state <= MEM_WRESP;
                MEM_WRESP: begin
                    if (m_data_axi_bvalid) begin
                        if (axi_stall) mem_state <= MEM_DONE;
                        else mem_state <= MEM_IDLE;
                    end
                end
                MEM_RADDR: if (m_data_axi_arready) mem_state <= MEM_RDATA;
                MEM_RDATA: begin
                    if (m_data_axi_rvalid) begin
                        data_latch <= m_data_axi_rdata;
                        if (axi_stall) mem_state <= MEM_DONE;
                        else mem_state <= MEM_IDLE;
                    end
                end
                MEM_DONE: begin
                    if (!axi_stall) mem_state <= MEM_IDLE;
                end
                default: mem_state <= MEM_IDLE;
            endcase
        end
    end

    assign m_data_axi_awvalid = rst_n && (mem_state == MEM_WADDR);
    assign m_data_axi_awaddr  = M_alu_o;
    assign m_data_axi_awprot  = 3'b000;
    assign m_data_axi_wvalid  = rst_n && (mem_state == MEM_WDATA);
    assign m_data_axi_wdata   = M_rf_wd;
    assign m_data_axi_wstrb   = 4'b1111;
    assign m_data_axi_bready  = rst_n && (mem_state == MEM_WRESP);

    assign m_data_axi_arvalid = rst_n && (mem_state == MEM_RADDR);
    assign m_data_axi_araddr  = M_alu_o;
    assign m_data_axi_arprot  = 3'b000;
    assign m_data_axi_rready  = rst_n && (mem_state == MEM_RDATA);

    assign data_waiting = mem_req && !(mem_state == MEM_DONE || 
                                      (mem_state == MEM_RDATA && m_data_axi_rvalid) || 
                                      (mem_state == MEM_WRESP && m_data_axi_bvalid) );
    
    assign M_dm_rd = (mem_state == MEM_RDATA && m_data_axi_rvalid) ? m_data_axi_rdata : data_latch;

    // ------------------------------------------------------------
    // 4.3 综合全局 AXI 停顿信号
    // ------------------------------------------------------------
    assign axi_stall = inst_waiting || data_waiting;

    // ============================================================
    // 5. 核心逻辑判定 (Done Flag)
    // ============================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 1'b0;
        end else if (mem_state == MEM_WRESP && m_data_axi_bvalid) begin
            if (M_alu_o == 32'h42001FFC && M_rf_wd == 32'hDEADBEEF)
                done <= 1'b1;
        end
    end

    // ============================================================
    // 6. 核心数据通路实例化
    // ============================================================
    Register_File RF (
        .clk(clk),            
        .rst_n(rst_n), 
        .WE(W_we_rf), .A1(D_rf_a1), .A2(D_rf_a2), .A3(W_rf_a3), 
        .WD(W_result), .RD1(D_rf_rd1), .RD2(D_rf_rd2)
    );
    
    Datapath datapath_inst ( 
        .clk(clk), .rst_n(rst_n), 
        .axi_stall(axi_stall), 
        .F_pc(F_pc), .F_instr(F_instr), .D_instr(D_instr), 
        .D_rf_a1(D_rf_a1), .D_rf_a2(D_rf_a2), .D_sel_ext(D_sel_ext), 
        .E_pcsrc(E_pcsrc), .E_sel_alu_src_b(E_sel_alu_src_b), .E_alu_control(E_alu_control), 
        .E_rf_a1(E_rf_a1), .E_rf_a2(E_rf_a2), .E_rf_a3(E_rf_a3), 
        .E_fd_A(E_fd_A), .E_fd_B(E_fd_B), .ZeroE(ZeroE), 
        .M_alu_o(M_alu_o), .M_rf_wd(M_rf_wd), .M_dm_rd(M_dm_rd), .M_rf_a3(M_rf_a3), 
        .W_we_rf(W_we_rf), .W_sel_result(W_sel_result), .W_rf_a3(W_rf_a3), 
        .D_rf_rd1(D_rf_rd1), .D_rf_rd2(D_rf_rd2), .W_result(W_result), 
        .F_stall(F_stall), .D_flush(D_flush), .D_stall(D_stall), .E_flush(E_flush)
    );
    
    Controller controller_inst ( 
        .clk(clk), .rst_n(rst_n), 
        .axi_stall(axi_stall), 
        .op(D_instr[6:0]), .funct3(D_instr[14:12]), .funct7(D_instr[31:25]), 
        .D_sel_ext(D_sel_ext), .E_flush(E_flush), .ZeroE(ZeroE), .E_pcsrc(E_pcsrc), 
        .E_sel_result(E_sel_result), .M_sel_result(M_sel_result), 
        .E_alu_control(E_alu_control), .E_sel_alu_src_b(E_sel_alu_src_b), 
        .E_we_rf(E_we_rf), .M_we_rf(M_we_rf), .M_we_dm(M_we_dm), 
        .W_we_rf(W_we_rf), .W_sel_result(W_sel_result)
    );
    
    Hazard_Unit hazard_inst ( 
        .D_rf_a1(D_rf_a1), .D_rf_a2(D_rf_a2), .E_rf_a1(E_rf_a1), .E_rf_a2(E_rf_a2), 
        .E_rf_a3(E_rf_a3), .E_pcsrc(E_pcsrc), .E_sel_result0(E_sel_result[0]), 
        .M_rf_a3(M_rf_a3), .M_we_rf(M_we_rf), .W_rf_a3(W_rf_a3), .W_we_rf(W_we_rf), 
        .F_stall(F_stall), .D_flush(D_flush), .D_stall(D_stall), .E_flush(E_flush), 
        .E_fd_A(E_fd_A), .E_fd_B(E_fd_B)
    );

endmodule