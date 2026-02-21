`include "define.v"

module rv_pl(
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF M_INST_AXI:M_DATA_AXI, ASSOCIATED_RESET rst_n" *)
    input  wire        clk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    input  wire        rst_n,

    // -------------------------
    // AXI4-Lite Instruction Master (read-only)
    // -------------------------
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI ARADDR" *)  output wire [31:0] m_inst_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI ARVALID" *) output wire        m_inst_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI ARREADY" *) input  wire        m_inst_axi_arready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI RDATA" *)   input  wire [31:0] m_inst_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI RRESP" *)   input  wire [1:0]  m_inst_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI RVALID" *)  input  wire        m_inst_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI RREADY" *)  output wire        m_inst_axi_rready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_INST_AXI ARPROT" *)  output wire [2:0]  m_inst_axi_arprot,

    // -------------------------
    // AXI4-Lite Data Master (read/write)
    // -------------------------
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

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI ARADDR" *)  output wire [31:0] m_data_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI ARVALID" *) output wire        m_data_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI ARREADY" *) input  wire        m_data_axi_arready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI RDATA" *)   input  wire [31:0] m_data_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI RRESP" *)   input  wire [1:0]  m_data_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI RVALID" *)  input  wire        m_data_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI RREADY" *)  output wire        m_data_axi_rready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI ARPROT" *)  output wire [2:0]  m_data_axi_arprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DATA_AXI AWPROT" *)  output wire [2:0]  m_data_axi_awprot,

    output reg done
  );

  // -------------------------
  // Internal pipeline signals (unchanged)
  // -------------------------
  wire [31:0] F_pc, F_instr, D_instr, D_rf_rd1, D_rf_rd2, W_result, M_alu_o, M_rf_wd, M_dm_rd;
  wire [4:0]  D_rf_a1, D_rf_a2, E_rf_a1, E_rf_a2, E_rf_a3, M_rf_a3, W_rf_a3;
  wire [3:0]  E_alu_control;
  wire [2:0]  D_sel_ext;
  wire [1:0]  E_sel_result, M_sel_result, W_sel_result;
  wire        E_pcsrc, E_sel_alu_src_b, E_we_rf, M_we_rf, M_we_dm, W_we_rf, ZeroE;

  // hazard outputs (from unit)
  wire        F_stall_hz, D_stall_hz;
  wire        D_flush_hz, E_flush_hz;
  wire [1:0]  E_fd_A_hz, E_fd_B_hz;

  // final signals to datapath (stall combined with AXI)
  wire        F_stall, D_stall, D_flush, E_flush;
  wire [1:0]  E_fd_A, E_fd_B;

  // -------------------------
  // AXI-Lite write FSM (store path)
  // -------------------------
  reg        w_busy;
  reg        aw_done, w_done;
  reg [31:0] awaddr_q;
  reg [31:0] wdata_q;
  reg [3:0]  wstrb_q;

  // pipeline store request
  wire        we_req    = M_we_dm;
  wire [31:0] addr_req  = M_alu_o;
  wire [31:0] data_req  = M_rf_wd;

  // stall whole pipeline during an outstanding write
  wire axi_wr_stall = w_busy;

  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
    begin
      w_busy   <= 1'b0;
      aw_done  <= 1'b0;
      w_done   <= 1'b0;
      awaddr_q <= 32'b0;
      wdata_q  <= 32'b0;
      wstrb_q  <= 4'b0;
    end
    else
    begin
      // launch a write when idle
      if (!w_busy && we_req)
      begin
        w_busy   <= 1'b1;
        aw_done  <= 1'b0;
        w_done   <= 1'b0;
        awaddr_q <= addr_req;
        wdata_q  <= data_req;
        wstrb_q  <= 4'b1111;
      end

      // AW handshake
      if (w_busy && !aw_done && m_data_axi_awvalid && m_data_axi_awready)
        aw_done <= 1'b1;

      // W handshake
      if (w_busy && !w_done && m_data_axi_wvalid && m_data_axi_wready)
        w_done <= 1'b1;

      // B handshake completes transaction
      if (w_busy && aw_done && w_done && m_data_axi_bvalid && m_data_axi_bready)
        w_busy <= 1'b0;
    end
  end

  // -------------------------
  // Instruction AXI (still simple; later we should handshake + latch)
  // -------------------------
  assign m_inst_axi_araddr  = F_pc;
  assign m_inst_axi_arvalid = rst_n;          // simplistic
  assign m_inst_axi_rready  = !F_stall;       // accept when not stalled
  assign m_inst_axi_arprot  = 3'b000;
  assign F_instr            = m_inst_axi_rdata;

  // -------------------------
  // Data AXI: required PROT
  // -------------------------
  assign m_data_axi_arprot  = 3'b000;
  assign m_data_axi_awprot  = 3'b000;

  // -------------------------
  // Data AXI write channel driven by FSM
  // -------------------------
  assign m_data_axi_awaddr  = awaddr_q;
  assign m_data_axi_wdata   = wdata_q;
  assign m_data_axi_wstrb   = wstrb_q;

  assign m_data_axi_awvalid = w_busy && !aw_done;
  assign m_data_axi_wvalid  = w_busy && !w_done;
  assign m_data_axi_bready  = 1'b1;

  // -------------------------
  // Data AXI read path (unchanged for now; later must stall+latch)
  // -------------------------
  assign m_data_axi_araddr  = M_alu_o;
  assign m_data_axi_arvalid = (M_sel_result == 2'b01);
  assign m_data_axi_rready  = 1'b1;
  assign M_dm_rd            = m_data_axi_rdata;

  // -------------------------
  // Done flag: check actual completed write (safer than M_* signals)
  // -------------------------
  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
    begin
      done <= 1'b0;
    end
    else
    begin
      // When the write completes (BVALID handshake), the latched addr/data are the committed ones
      if (w_busy && aw_done && w_done && m_data_axi_bvalid && m_data_axi_bready)
      begin
        if (awaddr_q == 32'h4200_1FFC && wdata_q == 32'hDEAD_BEEF)
          done <= 1'b1;
      end
    end
  end

  // -------------------------
  // Hazard unit (single instance) -> get hz stalls/flush/forward
  // -------------------------
  Hazard_Unit hazard_inst (
                .D_rf_a1(D_rf_a1),
                .D_rf_a2(D_rf_a2),
                .E_rf_a1(E_rf_a1),
                .E_rf_a2(E_rf_a2),
                .E_rf_a3(E_rf_a3),
                .E_pcsrc(E_pcsrc),
                .E_sel_result0(E_sel_result[0]),
                .M_rf_a3(M_rf_a3),
                .M_we_rf(M_we_rf),
                .W_rf_a3(W_rf_a3),
                .W_we_rf(W_we_rf),
                .F_stall(F_stall_hz),
                .D_flush(D_flush_hz),
                .D_stall(D_stall_hz),
                .E_flush(E_flush_hz),
                .E_fd_A(E_fd_A_hz),
                .E_fd_B(E_fd_B_hz)
              );

  // Combine hazard stall with AXI write stall
  assign F_stall = F_stall_hz | axi_wr_stall;
  assign D_stall = D_stall_hz | axi_wr_stall;
  assign D_flush = D_flush_hz;
  assign E_flush = E_flush_hz;
  assign E_fd_A  = E_fd_A_hz;
  assign E_fd_B  = E_fd_B_hz;

  // -------------------------
  // Core instances (unchanged)
  // -------------------------
  Register_File RF (
                  .clk(~clk),
                  .rst_n(rst_n),
                  .WE(W_we_rf),
                  .A1(D_rf_a1),
                  .A2(D_rf_a2),
                  .A3(W_rf_a3),
                  .WD(W_result),
                  .RD1(D_rf_rd1),
                  .RD2(D_rf_rd2)
                );

  Datapath datapath_inst (
             .clk(clk),
             .rst_n(rst_n),
             .F_pc(F_pc),
             .F_instr(F_instr),
             .D_instr(D_instr),
             .D_rf_a1(D_rf_a1),
             .D_rf_a2(D_rf_a2),
             .D_sel_ext(D_sel_ext),
             .E_pcsrc(E_pcsrc),
             .E_sel_alu_src_b(E_sel_alu_src_b),
             .E_alu_control(E_alu_control),
             .E_rf_a1(E_rf_a1),
             .E_rf_a2(E_rf_a2),
             .E_rf_a3(E_rf_a3),
             .E_fd_A(E_fd_A),
             .E_fd_B(E_fd_B),
             .ZeroE(ZeroE),
             .M_alu_o(M_alu_o),
             .M_rf_wd(M_rf_wd),
             .M_dm_rd(M_dm_rd),
             .M_rf_a3(M_rf_a3),
             .W_we_rf(W_we_rf),
             .W_sel_result(W_sel_result),
             .W_rf_a3(W_rf_a3),
             .D_rf_rd1(D_rf_rd1),
             .D_rf_rd2(D_rf_rd2),
             .W_result(W_result),
             .F_stall(F_stall),
             .D_flush(D_flush),
             .D_stall(D_stall),
             .E_flush(E_flush)
           );

  Controller controller_inst (
               .clk(clk),
               .rst_n(rst_n),
               .op(D_instr[6:0]),
               .funct3(D_instr[14:12]),
               .funct7(D_instr[31:25]),
               .D_sel_ext(D_sel_ext),
               .E_flush(E_flush),
               .ZeroE(ZeroE),
               .E_pcsrc(E_pcsrc),
               .E_sel_result(E_sel_result),
               .E_alu_control(E_alu_control),
               .E_sel_alu_src_b(E_sel_alu_src_b),
               .E_we_rf(E_we_rf),
               .M_we_rf(M_we_rf),
               .M_we_dm(M_we_dm),
               .W_we_rf(W_we_rf),
               .W_sel_result(W_sel_result)
             );

endmodule
