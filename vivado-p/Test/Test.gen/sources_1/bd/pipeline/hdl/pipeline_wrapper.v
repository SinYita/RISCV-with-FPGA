//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
//Date        : Fri Feb 20 02:05:03 2026
//Host        : MSI running 64-bit major release  (build 9200)
//Command     : generate_target pipeline_wrapper.bd
//Design      : pipeline_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module pipeline_wrapper
   (clk_100MHz,
    reset_rtl_0);
  input clk_100MHz;
  input reset_rtl_0;

  wire clk_100MHz;
  wire reset_rtl_0;

  pipeline pipeline_i
       (.clk_100MHz(clk_100MHz),
        .reset_rtl_0(reset_rtl_0));
endmodule
