
## Env Variables

set action_root [lindex $argv 0]
set fpga_part  	[lindex $argv 1]
#set fpga_part    xcvu9p-flgb2104-2l-e
#set action_root ../

set aip_dir 	$action_root/ip
set log_dir     $action_root/../../hardware/logs
set log_file    $log_dir/create_action_ip.log
set src_dir 	$aip_dir/action_ip_prj/action_ip_prj.srcs/sources_1/ip

# Create a new Vivado IP Project
puts "\[CREATE_ACTION_IPs..........\] start [clock format [clock seconds] -format {%T %a %b %d/ %Y}]"
puts "                        FPGACHIP = $fpga_part"
puts "                        ACTION_ROOT = $action_root"
puts "                        Creating IP in $src_dir"
create_project action_ip_prj $aip_dir/action_ip_prj -force -part $fpga_part -ip >> $log_file

## Project IP Settings
## General
#   create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ila_p157 -dir $src_dir >> $log_file
#   set_property -dict [list CONFIG.C_PROBE0_WIDTH 157 CONFIG.C_DATA_DEPTH 2048 CONFIG.C_TRIGOUT_EN {false} CONFIG.C_TRIGIN_EN {false}] [get_ips ila_p157]
#    set_property generate_synth_checkpoint false [get_files $src_dir/ila_p157/ila_p157.xci]
#    generate_target {instantiation_template}     [get_files $src_dir/ila_p157/ila_p157.xci] >> $log_file
#    generate_target all                          [get_files $src_dir/ila_p157/ila_p157.xci] >> $log_file

create_ip -name axi_datamover -vendor xilinx.com -library ip -version 5.1 -module_name axi_datamover_0 -dir $src_dir >> $log_file
set_property -dict [list CONFIG.c_m_axi_mm2s_data_width {1024} CONFIG.c_m_axis_mm2s_tdata_width {256} CONFIG.c_mm2s_burst_size {2} CONFIG.c_m_axi_s2mm_data_width {1024} CONFIG.c_s_axis_s2mm_tdata_width {256} CONFIG.c_s2mm_burst_size {2} CONFIG.c_s2mm_support_indet_btt {true} CONFIG.c_s2mm_include_sf {false} CONFIG.c_enable_cache_user {false} CONFIG.c_enable_mm2s_adv_sig {0} CONFIG.c_enable_s2mm_adv_sig {0} CONFIG.c_addr_width {64}] [get_ips axi_datamover_0]
generate_target {instantiation_template} [get_files $src_dir/axi_datamover_0/axi_datamover_0.xci] >> $log_file
generate_target {all} [get_files $src_dir/axi_datamover_0/axi_datamover_0.xci] >> $log_file

#create_ip -name axi_crossbar -vendor xilinx.com -library ip -version 2.1 -module_name axi_crossbar_0 -dir $src_dir >> $log_file
#set_property -dict [list CONFIG.NUM_SI {4} CONFIG.NUM_MI {1} CONFIG.ADDR_WIDTH {64} CONFIG.DATA_WIDTH {1024} CONFIG.ID_WIDTH {4} CONFIG.M00_S01_READ_CONNECTIVITY {0} CONFIG.M00_S03_READ_CONNECTIVITY {0} CONFIG.M00_S00_WRITE_CONNECTIVITY {0} CONFIG.M00_S02_WRITE_CONNECTIVITY {0} CONFIG.S00_THREAD_ID_WIDTH {2} CONFIG.S01_THREAD_ID_WIDTH {2} CONFIG.S02_THREAD_ID_WIDTH {2} CONFIG.S03_THREAD_ID_WIDTH {2} CONFIG.S04_THREAD_ID_WIDTH {2} CONFIG.S05_THREAD_ID_WIDTH {2} CONFIG.S06_THREAD_ID_WIDTH {2} CONFIG.S07_THREAD_ID_WIDTH {2} CONFIG.S08_THREAD_ID_WIDTH {2} CONFIG.S09_THREAD_ID_WIDTH {2} CONFIG.S10_THREAD_ID_WIDTH {2} CONFIG.S11_THREAD_ID_WIDTH {2} CONFIG.S12_THREAD_ID_WIDTH {2} CONFIG.S13_THREAD_ID_WIDTH {2} CONFIG.S14_THREAD_ID_WIDTH {2} CONFIG.S15_THREAD_ID_WIDTH {2} CONFIG.S01_BASE_ID {0x00000004} CONFIG.S02_BASE_ID {0x00000008} CONFIG.S03_BASE_ID {0x0000000c} CONFIG.S04_BASE_ID {0x00000010} CONFIG.S05_BASE_ID {0x00000014} CONFIG.S06_BASE_ID {0x00000018} CONFIG.S07_BASE_ID {0x0000001c} CONFIG.S08_BASE_ID {0x00000020} CONFIG.S09_BASE_ID {0x00000024} CONFIG.S10_BASE_ID {0x00000028} CONFIG.S11_BASE_ID {0x0000002c} CONFIG.S12_BASE_ID {0x00000030} CONFIG.S13_BASE_ID {0x00000034} CONFIG.S14_BASE_ID {0x00000038} CONFIG.S15_BASE_ID {0x0000003c} CONFIG.M00_A00_ADDR_WIDTH {64}] [get_ips axi_crossbar_0]
#generate_target {instantiation_template} [get_files $src_dir/axi_crossbar_0_1/axi_crossbar_0.xci] >> $log_file
#generate_target all [get_files $src_dir/axi_crossbar_0_1/axi_crossbar_0.xci] >> $log_file

create_ip -name axis_data_fifo -vendor xilinx.com -library ip -version 2.0 -module_name axis_data_fifo_data -dir $src_dir >> $log_file
set_property -dict [list CONFIG.TDATA_NUM_BYTES {32} CONFIG.FIFO_DEPTH {8192} CONFIG.HAS_TLAST {1} CONFIG.HAS_TKEEP {1} CONFIG.HAS_RD_DATA_COUNT {1} CONFIG.IS_ACLK_ASYNC {1}] [get_ips axis_data_fifo_data]
generate_target {instantiation_template} [get_files $src_dir/axis_data_fifo_1/axis_data_fifo_data.xci]  >> $log_file
generate_target all [get_files $src_dir/axis_data_fifo_data/axis_data_fifo_data.xci]  >> $log_file


create_ip -name axis_data_fifo -vendor xilinx.com -library ip -version 2.0 -module_name axis_data_fifo_cmd -dir $src_dir >> $log_file
set_property -dict [list CONFIG.TDATA_NUM_BYTES {13} CONFIG.FIFO_DEPTH {64} CONFIG.HAS_PROG_FULL {1} ] [get_ips axis_data_fifo_cmd]
generate_target {instantiation_template} [get_files $src_dir/axis_data_fifo_cmd/axis_data_fifo_cmd.xci]  >> $log_file
generate_target all [get_files $src_dir/axis_data_fifo_cmd/axis_data_fifo_cmd.xci]  >> $log_file

create_ip -name axis_data_fifo -vendor xilinx.com -library ip -version 2.0 -module_name axis_data_fifo_sts_mm2s -dir $src_dir >> $log_file
set_property -dict [list CONFIG.TDATA_NUM_BYTES {1} CONFIG.FIFO_DEPTH {64} CONFIG.HAS_TKEEP {1} CONFIG.HAS_PROG_FULL {1} ] [get_ips axis_data_fifo_sts_mm2s]
generate_target {instantiation_template} [get_files $src_dir/axis_data_fifo_sts_mm2s/axis_data_fifo_sts_mm2s.xci]  >> $log_file
generate_target all [get_files $src_dir/axis_data_fifo_sts_mm2s/axis_data_fifo_sts_mm2s.xci]  >> $log_file

create_ip -name axis_data_fifo -vendor xilinx.com -library ip -version 2.0 -module_name axis_data_fifo_sts_s2mm -dir $src_dir >> $log_file
set_property -dict [list CONFIG.TDATA_NUM_BYTES {4} CONFIG.FIFO_DEPTH {64} CONFIG.HAS_TKEEP {1} CONFIG.HAS_PROG_FULL {1}] [get_ips axis_data_fifo_sts_s2mm]
generate_target {instantiation_template} [get_files $src_dir/axis_data_fifo_sts_s2mm/axis_data_fifo_sts_mm2s.xci]  >> $log_file
generate_target all [get_files $src_dir/axis_data_fifo_sts_s2mm/axis_data_fifo_sts_s2mm.xci]  >> $log_file

create_ip -name aurora_64b66b -vendor xilinx.com -library ip -version 12.0 -module_name aurora_64b66b_1 -dir $src_dir >> $log_file
set_property -dict [list CONFIG.CHANNEL_ENABLE {X0Y16 X0Y17 X0Y18 X0Y19} CONFIG.C_UCOLUMN_USED {left} CONFIG.C_START_QUAD {Quad_X0Y4} CONFIG.C_START_LANE {X0Y16} CONFIG.C_REFCLK_SOURCE {MGTREFCLK0_of_Quad_X0Y4} CONFIG.C_AURORA_LANES {4} CONFIG.C_LINE_RATE {16.1132} CONFIG.C_REFCLK_FREQUENCY {161.132} CONFIG.C_INIT_CLK {250} CONFIG.interface_mode {Framing} CONFIG.C_GT_LOC_4 {4} CONFIG.C_GT_LOC_3 {3} CONFIG.C_GT_LOC_2 {2} CONFIG.drp_mode {Native} CONFIG.SupportLevel {1}] [get_ips aurora_64b66b_1]
generate_target {instantiation_template} [get_files $src_dir/aurora_64b66b_1/aurora_64b66b_1.xci]  >> $log_file
generate_target all [get_files $src_dir/aurora_64b66b_1/aurora_64b66b_1.xci]  >> $log_file


close_project
puts "\[CREATE_ACTION_IPs..........\] done  [clock format [clock seconds] -format {%T %a %b %d %Y}]"
