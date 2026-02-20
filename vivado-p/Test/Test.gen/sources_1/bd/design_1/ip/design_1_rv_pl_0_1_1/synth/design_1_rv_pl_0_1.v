// (c) Copyright 1995-2026 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: user.org:user:rv_pl:1.0
// IP Revision: 4

(* X_CORE_INFO = "rv_pl,Vivado 2021.2" *)
(* CHECK_LICENSE_TYPE = "design_1_rv_pl_0_1,rv_pl,{}" *)
(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_rv_pl_0_1 (
  clk,
  rst_n,
  m_inst_axi_araddr,
  m_inst_axi_arvalid,
  m_inst_axi_arready,
  m_inst_axi_rdata,
  m_inst_axi_rresp,
  m_inst_axi_rvalid,
  m_inst_axi_rready,
  m_data_axi_awaddr,
  m_data_axi_awvalid,
  m_data_axi_awready,
  m_data_axi_wdata,
  m_data_axi_wstrb,
  m_data_axi_wvalid,
  m_data_axi_wready,
  m_data_axi_bresp,
  m_data_axi_bvalid,
  m_data_axi_bready,
  m_data_axi_araddr,
  m_data_axi_arvalid,
  m_data_axi_arready,
  m_data_axi_rdata,
  m_data_axi_rresp,
  m_data_axi_rvalid,
  m_data_axi_rready,
  done
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_BUSIF m_data_axi:m_inst_axi, FREQ_HZ 50000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *)
input wire rst_n;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_inst_axi ARADDR" *)
output wire [31 : 0] m_inst_axi_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_inst_axi ARVALID" *)
output wire m_inst_axi_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_inst_axi ARREADY" *)
input wire m_inst_axi_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_inst_axi RDATA" *)
input wire [31 : 0] m_inst_axi_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_inst_axi RRESP" *)
input wire [1 : 0] m_inst_axi_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_inst_axi RVALID" *)
input wire m_inst_axi_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_inst_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 50000000, ID_WIDTH 0, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_ONLY, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 0, HAS_BRESP 0, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREA\
DS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_inst_axi RREADY" *)
output wire m_inst_axi_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi AWADDR" *)
output wire [31 : 0] m_data_axi_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi AWVALID" *)
output wire m_data_axi_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi AWREADY" *)
input wire m_data_axi_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi WDATA" *)
output wire [31 : 0] m_data_axi_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi WSTRB" *)
output wire [3 : 0] m_data_axi_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi WVALID" *)
output wire m_data_axi_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi WREADY" *)
input wire m_data_axi_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi BRESP" *)
input wire [1 : 0] m_data_axi_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi BVALID" *)
input wire m_data_axi_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi BREADY" *)
output wire m_data_axi_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi ARADDR" *)
output wire [31 : 0] m_data_axi_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi ARVALID" *)
output wire m_data_axi_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi ARREADY" *)
input wire m_data_axi_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi RDATA" *)
input wire [31 : 0] m_data_axi_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi RRESP" *)
input wire [1 : 0] m_data_axi_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi RVALID" *)
input wire m_data_axi_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_data_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 50000000, ID_WIDTH 0, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, NUM_READ_THRE\
ADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_data_axi RREADY" *)
output wire m_data_axi_rready;
output wire done;

  rv_pl inst (
    .clk(clk),
    .rst_n(rst_n),
    .m_inst_axi_araddr(m_inst_axi_araddr),
    .m_inst_axi_arvalid(m_inst_axi_arvalid),
    .m_inst_axi_arready(m_inst_axi_arready),
    .m_inst_axi_rdata(m_inst_axi_rdata),
    .m_inst_axi_rresp(m_inst_axi_rresp),
    .m_inst_axi_rvalid(m_inst_axi_rvalid),
    .m_inst_axi_rready(m_inst_axi_rready),
    .m_data_axi_awaddr(m_data_axi_awaddr),
    .m_data_axi_awvalid(m_data_axi_awvalid),
    .m_data_axi_awready(m_data_axi_awready),
    .m_data_axi_wdata(m_data_axi_wdata),
    .m_data_axi_wstrb(m_data_axi_wstrb),
    .m_data_axi_wvalid(m_data_axi_wvalid),
    .m_data_axi_wready(m_data_axi_wready),
    .m_data_axi_bresp(m_data_axi_bresp),
    .m_data_axi_bvalid(m_data_axi_bvalid),
    .m_data_axi_bready(m_data_axi_bready),
    .m_data_axi_araddr(m_data_axi_araddr),
    .m_data_axi_arvalid(m_data_axi_arvalid),
    .m_data_axi_arready(m_data_axi_arready),
    .m_data_axi_rdata(m_data_axi_rdata),
    .m_data_axi_rresp(m_data_axi_rresp),
    .m_data_axi_rvalid(m_data_axi_rvalid),
    .m_data_axi_rready(m_data_axi_rready),
    .done(done)
  );
endmodule
