vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/blk_mem_gen_v8_4_5

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap blk_mem_gen_v8_4_5 modelsim_lib/msim/blk_mem_gen_v8_4_5

vlog -work xilinx_vip -64 -incr -mfcu -sv -L axi_vip_v1_1_11 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_13 -L xilinx_vip "+incdir+/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/include" \
"/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm -64 -incr -mfcu -sv -L axi_vip_v1_1_11 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_13 -L xilinx_vip "+incdir+../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/66be/hdl/verilog" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/5c02/sources_1/imports/riscv-single" "+incdir+/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/include" \
"/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu "+incdir+../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/66be/hdl/verilog" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/5c02/sources_1/imports/riscv-single" "+incdir+/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_processing_system7_0_0_1/design_1_processing_system7_0_0_sim_netlist.v" \
"../../../bd/design_1/ip/design_1_axi_bram_ctrl_0_0/design_1_axi_bram_ctrl_0_0_sim_netlist.v" \
"../../../bd/design_1/ip/design_1_axi_gpio_0_0_1/design_1_axi_gpio_0_0_sim_netlist.v" \
"../../../bd/design_1/ip/design_1_axi_bram_ctrl_1_0/design_1_axi_bram_ctrl_1_0_sim_netlist.v" \

vlog -work blk_mem_gen_v8_4_5 -64 -incr -mfcu "+incdir+../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/66be/hdl/verilog" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/5c02/sources_1/imports/riscv-single" "+incdir+/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../Test.gen/sources_1/bd/design_1/ipshared/25a8/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 -incr -mfcu "+incdir+../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/66be/hdl/verilog" "+incdir+../../../../Test.gen/sources_1/bd/design_1/ipshared/5c02/sources_1/imports/riscv-single" "+incdir+/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_blk_mem_gen_0_0_1/sim/design_1_blk_mem_gen_0_0.v" \
"../../../bd/design_1/ip/design_1_rst_ps7_0_50M_0_1/design_1_rst_ps7_0_50M_0_sim_netlist.v" \
"../../../bd/design_1/ip/design_1_axi_bram_ctrl_1_bram_0/sim/design_1_axi_bram_ctrl_1_bram_0.v" \
"../../../bd/design_1/ip/design_1_axi_smc_2/design_1_axi_smc_2_sim_netlist.v" \
"../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single/ALU.v" \
"../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single/ALU_Decoder.v" \
"../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single/Controller.v" \
"../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single/Datapath.v" \
"../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single/Hazard_Unit.v" \
"../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single/Mux.v" \
"../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single/Op_Decoder.v" \
"../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single/Register_File.v" \
"../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single/Sign_Extend.v" \
"../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single/flops.v" \
"../../../bd/design_1/ipshared/5c02/sources_1/imports/riscv-single/Pipeline_top.v" \
"../../../bd/design_1/ip/design_1_rv_pl_0_1_1/sim/design_1_rv_pl_0_1.v" \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

