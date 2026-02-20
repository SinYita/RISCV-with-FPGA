// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Fri Feb 20 03:50:04 2026
// Host        : halle.cli.ito.cit.tum.de running 64-bit Ubuntu 24.04.2 LTS
// Command     : write_verilog -force -mode funcsim -rename_top design_1_blk_mem_gen_1_1 -prefix
//               design_1_blk_mem_gen_1_1_ design_1_blk_mem_gen_0_1_sim_netlist.v
// Design      : design_1_blk_mem_gen_0_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_blk_mem_gen_0_1,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module design_1_blk_mem_gen_1_1
   (clka,
    rsta,
    ena,
    wea,
    addra,
    dina,
    douta,
    clkb,
    rstb,
    enb,
    web,
    addrb,
    dinb,
    doutb,
    rsta_busy,
    rstb_busy);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE BRAM_CTRL, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *) input rsta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [3:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [31:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE BRAM_CTRL, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB RST" *) input rstb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [3:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [31:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [31:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;
  output rsta_busy;
  output rstb_busy;

  wire [31:0]addra;
  wire [31:0]addrb;
  wire clka;
  wire clkb;
  wire [31:0]dina;
  wire [31:0]dinb;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire ena;
  wire enb;
  wire rsta;
  wire rsta_busy;
  wire rstb;
  wire rstb_busy;
  wire [3:0]wea;
  wire [3:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "32" *) 
  (* C_ADDRB_WIDTH = "32" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "1" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     10.7492 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "1" *) 
  (* C_HAS_RSTB = "1" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "NONE" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "2048" *) 
  (* C_READ_DEPTH_B = "2048" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "1" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "4" *) 
  (* C_WEB_WIDTH = "4" *) 
  (* C_WRITE_DEPTH_A = "2048" *) 
  (* C_WRITE_DEPTH_B = "2048" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  design_1_blk_mem_gen_1_1_blk_mem_gen_v8_4_5 U0
       (.addra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,addra[12:2],1'b0,1'b0}),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,addrb[12:2],1'b0,1'b0}),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[31:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(rsta),
        .rsta_busy(rsta_busy),
        .rstb(rstb),
        .rstb_busy(rstb_busy),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[31:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2021.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
oESHD2Q5NORrmTVTCApB+YFZJwjA1ezq7U6VZh96by+ofPCvSFp06AIoCLvB4BhPvxfob6kIkBpR
xVCOLM7HsDk7nO1JVWiYIJ6okoWTA8hAlPj3sdGuMwRlZNSBKn/c6F+CW5Jl37TEGotkhycSB3Bg
B/uu1THUZwIG87RPahE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
RovEhaqHrFqzjckk+DIWG8LQeqg2Y/nACQDyXKKtSav7YHlgpKmgHZnsxwwNpqrqVRGyjTecSQ+e
6Mr/Pi9au3AgJVPL6VOgwNVE0yj2LpA4LPyWzxLN3+DiSDmsaCBNCBlVQi2MRKUabou8nLaXldbL
+7pv4pYhQdcyjDzuC2dx3HmzADqstdEiyXeU3ktJ29CDLDmGwDWdmsrl90s4YQSfBV2nj4/Vut3L
p/8dzphf1htPaNMujMxxgp3z4JzUEDJJokDL+gNutEEHiaWpI3URIA5v22vJu+NPD+eEraSioHfL
DPKAajZTwK5FHnonu4O2D0co8GWqWW5cUqZz9A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jBQ6Th9yy7jtKQD1h235YLT6qO6XiBaBKGJrV1Z8H9M9ePJ9R/fA8E1okt4LyBvoWjR7tmCbIg7A
0/vuKOogkLtDE/BtTlp4z1iurO8rQrAcdZy/e+7GATawyJxFY7kZhnXASu9zB8TiOBELSlapkpxe
WuAzXLde9FBMBkq4RSc=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
eucSNV2Zbm4zYc2tIGRlGmlVM8+WHY1NHe9drZdgDhGPOHz8PTqHapfnZ1kWuTLtPBLSMvcXNScn
UTvpULofBV6qD7WHLPg7UJcjpZVDL69lk88chgqrlc/RqaJXKNVv+Ubku53ZLU20uZK71bNymjSM
855RVWw5lvTHTCNC2MYIS94Fmrzuq8i0+tFh5qBKkHK2BC+fD7xVyyfuh4mZR2yr/hRs/emoI79E
IKoJnLiglVp6RXTsXFzZW4pIthbjWSuZlOQvoYkS2RMj8a0r9lyariphRQunoudc0bLO4Phk578c
40gusaaS/MI7idMT7k1Di96kvu5mHi23loRcZQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
E/syLaRG2Ss/xTTkuAkOKXzm53+rCptYO2DkVukWhvlLmEB2daHCPrXt4gKeuG+0hIGWedSwCiLJ
7KNtEAiTumJ/j+3p7s3oXN9ftCSRolXoACsCclEAmwYjVM0ubCXUx6JNFOGt0yDl2Jsd5+W10mSJ
bYEKvRKi7koXM/eYJqbhTrtsrHDwRJEY0JVUPh8EOkLLqaIKbnjb6ENEY6qZOamp5PaWsSS30gJM
N6fB8D1AmGKnFbfY+d5TexS55Z92aYcAHNX2XwHsKnm45az1vHeZ0rTEU/oONIaSZfikRni1iDBg
x2GOue6sLiwxTEHaVkTJsOVR4mx0VsfFxavwRg==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_01", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
dSHHpkQiOEzzKs4D71WVyDXLpkKuR9h9h3pBLtnCq2bXiwE/eQHmk5HeQb+qREg0Yv193OukqaQz
RZyuF5GQcqOpqFHMxO62HQ2pdjdpMT5CC7gHvmgiw9qBkJJrXpihIHER4X7OF2iNUfeqxJ8eiSz3
C0V20NlIwKG7Mxg8MVj++xmb32KMUqL7ptikkym20vVdhecVMNvpPoXp8uvaGT7991enWP9HGKUC
9kLY2DEYwRGE71UJJLGWo4n49R50ExFRj91xWnYfvp7uJsMNwnBp5l3GTZiMELX2RkRVSPOHr7l1
n2p5Vq7Uee2drny1IxZ/4c0hYY6y3QWSEqpESw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
HUtfqZ9dh5oZTOAt9a0ebo+wQbzg3izFQ0kVqZN81S4cBjQEF53WUiVlTKBDVjvLNUby4Se9WZjj
j86TQzuGJxLPDTohmbytErsg5JrlXHbHGwR4zGNGTbBs12X7PkxtS8wVCp+7b1rX6pOGOPqm6FoG
g6rZY/bTzVfGYF2CAOhjJUqUOXEAKnZRehspRyiBI28/ZZPSAUD/abKprW8PWCxMx2zPWztZz4No
R96jgvHezNzB1Ta8W7uRBFTMp+XVSToxTp2jzSXJZ0V5xJl+gdVjAMmf6+te2vqrK2wDWdMxk3Sf
iyLI4d0s25vCybcY2fZWacq5iO9pSlSaOQWgCA==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
vYYu2Kvhv3RZi0pFbjRTQ/BBwfilCrGpkMls+Dz6HBGTZvSaC/anWgymoDS0XnoSENGG3Pz3EBF0
19OqLbyna95IHFe2bA7f8RgU9SEUffZ8eXGigfOjAWpZCN07Q77RkhGUKal7okWe3Q6xHtZy83l2
kW8ma3kOYL7GzQjtpbP3lINHLMqpGEo0dzbOHiJ5r6W5U6DsILGsoLQOXcw+MwrevvNRB0KkSklj
QnL8K2AK8PIsJGM6F8dj5KwRYhSBYNb1opuVpiJWlbHgADoeM+dhiRxBLmnaDE8PWs1ReY6uMzzH
SvvO6UEyxQtvS/Smm/uogr1eUFedUaBHPMEXnYlTAv/SKrh942GeknsqfrjGkZxWTN2NEnvpRUwT
fS0pyd/Err0s94b0srmcTYyxZfJGRUct2T8MCphZFaScAlhn655pxW9RaHMfcvDJUHpW8Qa+KhRt
9CWYScPIH6YNDByLQbhKL5BTpAYMNYPF2W7vM2ZzDob2NB7m6GGeKRr3

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QSNmIeTT4pBji+CTjknWXN6sH9Wff8+t8KF+AC3fIoIw08jtLtShcB9ZGeEKG02RGCO4lNIUf5YB
2TVYk6EJ5XyCav12qDhc60n56UVrnpfo7drorY0NmOypuxECgO43h6SDWp9W7px3r4CJnQ4+X2Mj
943GdP30WfL5kbWHZJC1Dz9cBIqRa1EbNXvvAqBvRPS2+aXBXAPOC4rNVZGeIUspn/33IW3yJLSp
Jm5GIct87ZuSoz8+DXhUvsTj4hq8lgirVhfz1qhHm8SfODcE91FGUPw3vbpGWXsBX73t2zxFC1Hz
/6m4YqQJVxd+H5iGE4kbHxHyHnH7FIerqc8Phw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UhfxKxECbuHK/o9ZExa2zP/MIPmFXuDNZwgpiawuBmPeRI1nJsYB7vzbBGMPKny4yIHLT8mHrQRc
fs05atkjIAbLea4+WNoCdCeg7/0PzuodM1ol3it6BHQ6Yzq4mnZbzlk8Xtwmk8ACAbzOr2SYxYWX
ueuUlimUSRusIe4+NiPvzbfHMAOVPjdmSY7zaSyeJuhdAR+fUGeHy5B23Xe2X6cDPeJ75IqcBeul
ox3dTXi3L8r/s1bTKX3FhxRyPZuh/xCWuEajsF2fEYdwWHKtLX6IQniLBJ5ZnVSS8D7IYPsvV4t0
9rWJqto5O1n3rAM44OvKvc9pOYXJupuv7g3gWg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fmo66vhS7nigYtLDMjdj7hgUnDG/fnO+cIaY/3qHrcwT7u/paj5enLuWHovegu9O9WRq3pPNnjuN
6vZRpuCgz5p4VAV7dVg9fuzg99BAjThp1Q/+HIPfdQ2LM14ZpTh4FXxthHGkTyS5PJArvZ3/UMpW
zwfdYd5+k2/emJ4/nuqoJHQG8k+O5EjSprLTvNZ/wrE1cT/fW/Lu2pxI4msHqVVYAXz7sJ13cQ+C
7tKxCV8vTyf0rpStdE+kZXg+jrc7vFKuPJO0U9axMsC0nXyeYx2jzfAHptGWKvfQaPg/Eo9mgLyN
qSJfFS6aIycuxNmg7L82WK401aWhnUn7GNrudg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 59600)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
