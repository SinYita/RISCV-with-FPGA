-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
-- Date        : Fri Feb 20 05:34:57 2026
-- Host        : halle.cli.ito.cit.tum.de running 64-bit Ubuntu 24.04.2 LTS
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_rv_pl_0_1_stub.vhdl
-- Design      : design_1_rv_pl_0_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    m_inst_axi_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_inst_axi_arvalid : out STD_LOGIC;
    m_inst_axi_arready : in STD_LOGIC;
    m_inst_axi_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_inst_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_inst_axi_rvalid : in STD_LOGIC;
    m_inst_axi_rready : out STD_LOGIC;
    m_data_axi_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_data_axi_awvalid : out STD_LOGIC;
    m_data_axi_awready : in STD_LOGIC;
    m_data_axi_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_data_axi_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_data_axi_wvalid : out STD_LOGIC;
    m_data_axi_wready : in STD_LOGIC;
    m_data_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_data_axi_bvalid : in STD_LOGIC;
    m_data_axi_bready : out STD_LOGIC;
    m_data_axi_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_data_axi_arvalid : out STD_LOGIC;
    m_data_axi_arready : in STD_LOGIC;
    m_data_axi_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_data_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_data_axi_rvalid : in STD_LOGIC;
    m_data_axi_rready : out STD_LOGIC;
    done : out STD_LOGIC
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,rst_n,m_inst_axi_araddr[31:0],m_inst_axi_arvalid,m_inst_axi_arready,m_inst_axi_rdata[31:0],m_inst_axi_rresp[1:0],m_inst_axi_rvalid,m_inst_axi_rready,m_data_axi_awaddr[31:0],m_data_axi_awvalid,m_data_axi_awready,m_data_axi_wdata[31:0],m_data_axi_wstrb[3:0],m_data_axi_wvalid,m_data_axi_wready,m_data_axi_bresp[1:0],m_data_axi_bvalid,m_data_axi_bready,m_data_axi_araddr[31:0],m_data_axi_arvalid,m_data_axi_arready,m_data_axi_rdata[31:0],m_data_axi_rresp[1:0],m_data_axi_rvalid,m_data_axi_rready,done";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "rv_pl,Vivado 2021.2";
begin
end;
