`include "define.v"

module rv_pl(
    // ============================================================
    // 0. 时钟与复位 (添加属性让 Vivado 自动识别)
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
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI ARPROT" *)  output wire [2:0]  m_inst_axi_arprot, // 必选信号

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
    output reg          done
);

    // --- 内部流水线信号 (保持不变) ---
    wire [31:0] F_pc, F_instr, D_instr, D_rf_rd1, D_rf_rd2, W_result, M_alu_o, M_rf_wd, M_dm_rd;
    wire [4:0]  D_rf_a1, D_rf_a2, E_rf_a1, E_rf_a2, E_rf_a3, M_rf_a3, W_rf_a3;
    wire [3:0]  E_alu_control;
    wire [2:0]  D_sel_ext;
    wire [1:0]  E_sel_result, M_sel_result, W_sel_result, E_fd_A, E_fd_B;
    wire        E_pcsrc, E_sel_alu_src_b, E_we_rf, M_we_rf, M_we_dm, W_we_rf, ZeroE;
    wire        F_stall, D_flush, D_stall, E_flush;

    // ============================================================
    // 4. AXI 桥接转换逻辑 (增强稳定性)
    // ============================================================

    // --- 取指接口 (M_INST_AXI) ---
    assign m_inst_axi_araddr  = F_pc;
    assign m_inst_axi_arvalid = rst_n; // 只要不在复位状态，就请求取指
    assign m_inst_axi_rready  = !F_stall; // 如果流水线没停顿，就准备好接收
    assign m_inst_axi_arprot  = 3'b000;
    assign F_instr            = m_inst_axi_rdata;

    // --- 数据接口 (M_DATA_AXI) ---
    // AXI 必选信号补全
    assign m_data_axi_arprot  = 3'b000;
    assign m_data_axi_awprot  = 3'b000;

    // 写逻辑
    assign m_data_axi_awaddr  = M_alu_o;
    assign m_data_axi_wdata   = M_rf_wd;
    assign m_data_axi_awvalid = M_we_dm;
    assign m_data_axi_wvalid  = M_we_dm;
    assign m_data_axi_wstrb   = 4'b1111; 
    assign m_data_axi_bready  = 1'b1;

    // 读逻辑
    assign m_data_axi_araddr  = M_alu_o;
    assign m_data_axi_arvalid = (M_sel_result == 2'b01);
    assign m_data_axi_rready  = 1'b1;
    assign M_dm_rd            = m_data_axi_rdata;

    // ============================================================
    // 5. 核心逻辑判定 (Done Flag)
    // ============================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 1'b0;
        end else if (M_we_dm && (M_alu_o == 32'h00002000)) begin
            if (M_rf_wd == 32'hDEADBEAF)
                done <= 1'b1;
        end
    end

    // --- 模块实例化 (保持你原有的逻辑结构) ---
    Register_File RF (.clk(~clk), .rst_n(rst_n), .WE(W_we_rf), .A1(D_rf_a1), .A2(D_rf_a2), .A3(W_rf_a3), .WD(W_result), .RD1(D_rf_rd1), .RD2(D_rf_rd2));
    Datapath datapath_inst ( .clk(clk), .rst_n(rst_n), .F_pc(F_pc), .F_instr(F_instr), .D_instr(D_instr), .D_rf_a1(D_rf_a1), .D_rf_a2(D_rf_a2), .D_sel_ext(D_sel_ext), .E_pcsrc(E_pcsrc), .E_sel_alu_src_b(E_sel_alu_src_b), .E_alu_control(E_alu_control), .E_rf_a1(E_rf_a1), .E_rf_a2(E_rf_a2), .E_rf_a3(E_rf_a3), .E_fd_A(E_fd_A), .E_fd_B(E_fd_B), .ZeroE(ZeroE), .M_alu_o(M_alu_o), .M_rf_wd(M_rf_wd), .M_dm_rd(M_dm_rd), .M_rf_a3(M_rf_a3), .W_we_rf(W_we_rf), .W_sel_result(W_sel_result), .W_rf_a3(W_rf_a3), .D_rf_rd1(D_rf_rd1), .D_rf_rd2(D_rf_rd2), .W_result(W_result), .F_stall(F_stall), .D_flush(D_flush), .D_stall(D_stall), .E_flush(E_flush));
    Controller controller_inst ( .clk(clk), .rst_n(rst_n), .op(D_instr[6:0]), .funct3(D_instr[14:12]), .funct7(D_instr[31:25]), .D_sel_ext(D_sel_ext), .E_flush(E_flush), .ZeroE(ZeroE), .E_pcsrc(E_pcsrc), .E_sel_result(E_sel_result), .E_alu_control(E_alu_control), .E_sel_alu_src_b(E_sel_alu_src_b), .E_we_rf(E_we_rf), .M_we_rf(M_we_rf), .M_we_dm(M_we_dm), .W_we_rf(W_we_rf), .W_sel_result(W_sel_result));
    Hazard_Unit hazard_inst ( .D_rf_a1(D_rf_a1), .D_rf_a2(D_rf_a2), .E_rf_a1(E_rf_a1), .E_rf_a2(E_rf_a2), .E_rf_a3(E_rf_a3), .E_pcsrc(E_pcsrc), .E_sel_result0(E_sel_result[0]), .M_rf_a3(M_rf_a3), .M_we_rf(M_we_rf), .W_rf_a3(W_rf_a3), .W_we_rf(W_we_rf), .F_stall(F_stall), .D_flush(D_flush), .D_stall(D_stall), .E_flush(E_flush), .E_fd_A(E_fd_A), .E_fd_B(E_fd_B));

endmodule