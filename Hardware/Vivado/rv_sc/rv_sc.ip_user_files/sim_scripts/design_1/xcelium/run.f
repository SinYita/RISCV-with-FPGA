-makelib xcelium_lib/xilinx_vip -sv \
  "/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib xcelium_lib/xpm -sv \
  "/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
  "/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "/var/tmp/dwe_vivado_inst/Vivado/2021.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_processing_system7_0_0/design_1_processing_system7_0_0_sim_netlist.v" \
  "../../../bd/design_1/ip/design_1_axi_bram_ctrl_0_0/design_1_axi_bram_ctrl_0_0_sim_netlist.v" \
  "../../../bd/design_1/ip/design_1_axi_bram_ctrl_1_0/design_1_axi_bram_ctrl_1_0_sim_netlist.v" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_5 \
  "../../../../rv_sc.gen/sources_1/bd/design_1/ipshared/25a8/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_blk_mem_gen_0_0/sim/design_1_blk_mem_gen_0_0.v" \
  "../../../bd/design_1/ip/design_1_blk_mem_gen_1_0/sim/design_1_blk_mem_gen_1_0.v" \
  "../../../bd/design_1/ip/design_1_axi_gpio_0_0/design_1_axi_gpio_0_0_sim_netlist.v" \
  "../../../bd/design_1/ip/design_1_rst_ps7_0_50M_0/design_1_rst_ps7_0_50M_0_sim_netlist.v" \
  "../../../bd/design_1/ipshared/baed/rv_sc/ALU.v" \
  "../../../bd/design_1/ipshared/baed/rv_sc/ALU_Decoder.v" \
  "../../../bd/design_1/ipshared/baed/rv_sc/Controller.v" \
  "../../../bd/design_1/ipshared/baed/rv_sc/Mux.v" \
  "../../../bd/design_1/ipshared/baed/rv_sc/NPC.v" \
  "../../../bd/design_1/ipshared/baed/rv_sc/Op_Decoder.v" \
  "../../../bd/design_1/ipshared/baed/rv_sc/PC.v" \
  "../../../bd/design_1/ipshared/baed/rv_sc/Register_File.v" \
  "../../../bd/design_1/ipshared/baed/rv_sc/Sign_Extend.v" \
  "../../../bd/design_1/ipshared/baed/rv_sc/rv_sc.v" \
  "../../../bd/design_1/ip/design_1_rv_single_axi_0_0/sim/design_1_rv_single_axi_0_0.v" \
  "../../../bd/design_1/sim/design_1.v" \
  "../../../bd/design_1/ip/design_1_axi_smc_2/design_1_axi_smc_2_sim_netlist.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

