set_property SRC_FILE_INFO {cfile:/u/halle/dwe/home_at/Desktop/Test/Test.srcs/constrs_1/imports/HDL_WS2526/template_PYNQ-Z2_ref.xdc rfile:../../../Test.srcs/constrs_1/imports/HDL_WS2526/template_PYNQ-Z2_ref.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:26 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN M14    IOSTANDARD LVCMOS33 } [get_ports { done_0 }]; # Sch=led[3] (LD0)
set_property src_info {type:XDC file:1 line:31 export:INPUT save:INPUT read:READ} [current_design]
set_output_delay -clock [get_clocks clk_fpga_0] 2.000 [get_ports { done_0 }]
