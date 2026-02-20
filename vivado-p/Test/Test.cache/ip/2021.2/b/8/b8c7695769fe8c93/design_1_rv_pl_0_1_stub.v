// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Fri Feb 20 17:43:19 2026
// Host        : halle.cli.ito.cit.tum.de running 64-bit Ubuntu 24.04.2 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_rv_pl_0_1_stub.v
// Design      : design_1_rv_pl_0_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "rv_pl,Vivado 2021.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk, rst_n, m_inst_axi_araddr, 
  m_inst_axi_arvalid, m_inst_axi_arready, m_inst_axi_rdata, m_inst_axi_rresp, 
  m_inst_axi_rvalid, m_inst_axi_rready, m_data_axi_awaddr, m_data_axi_awvalid, 
  m_data_axi_awready, m_data_axi_wdata, m_data_axi_wstrb, m_data_axi_wvalid, 
  m_data_axi_wready, m_data_axi_bresp, m_data_axi_bvalid, m_data_axi_bready, 
  m_data_axi_araddr, m_data_axi_arvalid, m_data_axi_arready, m_data_axi_rdata, 
  m_data_axi_rresp, m_data_axi_rvalid, m_data_axi_rready, done)
/* synthesis syn_black_box black_box_pad_pin="clk,rst_n,m_inst_axi_araddr[31:0],m_inst_axi_arvalid,m_inst_axi_arready,m_inst_axi_rdata[31:0],m_inst_axi_rresp[1:0],m_inst_axi_rvalid,m_inst_axi_rready,m_data_axi_awaddr[31:0],m_data_axi_awvalid,m_data_axi_awready,m_data_axi_wdata[31:0],m_data_axi_wstrb[3:0],m_data_axi_wvalid,m_data_axi_wready,m_data_axi_bresp[1:0],m_data_axi_bvalid,m_data_axi_bready,m_data_axi_araddr[31:0],m_data_axi_arvalid,m_data_axi_arready,m_data_axi_rdata[31:0],m_data_axi_rresp[1:0],m_data_axi_rvalid,m_data_axi_rready,done" */;
  input clk;
  input rst_n;
  output [31:0]m_inst_axi_araddr;
  output m_inst_axi_arvalid;
  input m_inst_axi_arready;
  input [31:0]m_inst_axi_rdata;
  input [1:0]m_inst_axi_rresp;
  input m_inst_axi_rvalid;
  output m_inst_axi_rready;
  output [31:0]m_data_axi_awaddr;
  output m_data_axi_awvalid;
  input m_data_axi_awready;
  output [31:0]m_data_axi_wdata;
  output [3:0]m_data_axi_wstrb;
  output m_data_axi_wvalid;
  input m_data_axi_wready;
  input [1:0]m_data_axi_bresp;
  input m_data_axi_bvalid;
  output m_data_axi_bready;
  output [31:0]m_data_axi_araddr;
  output m_data_axi_arvalid;
  input m_data_axi_arready;
  input [31:0]m_data_axi_rdata;
  input [1:0]m_data_axi_rresp;
  input m_data_axi_rvalid;
  output m_data_axi_rready;
  output done;
endmodule
