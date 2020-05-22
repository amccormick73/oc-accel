/*
 * Copyright 2019 International Business Machines
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

`timescale 1ns/1ps

module action_single_engine # (
           // Parameters of Axi Slave Bus Interface AXI_CTRL_REG
           parameter C_S_AXI_CTRL_REG_DATA_WIDTH    = 32,
           parameter C_S_AXI_CTRL_REG_ADDR_WIDTH    = 32,
       
           // Parameters of Axi Master Bus Interface AXI_HOST_MEM ; to Host memory
           parameter C_M_AXI_HOST_MEM_ID_WIDTH      = 2,
           parameter C_M_AXI_HOST_MEM_ADDR_WIDTH    = 64,
           parameter C_M_AXI_HOST_MEM_DATA_WIDTH    = 1024,
           parameter C_M_AXI_HOST_MEM_AWUSER_WIDTH  = 8,
           parameter C_M_AXI_HOST_MEM_ARUSER_WIDTH  = 8,
           parameter C_M_AXI_HOST_MEM_WUSER_WIDTH   = 1,
           parameter C_M_AXI_HOST_MEM_RUSER_WIDTH   = 1,
           parameter C_M_AXI_HOST_MEM_BUSER_WIDTH   = 1
)
(
 input 					       clk ,
 input 					       rst_n ,

   output [3:0]           qsfp_txp
   ,output [3:0]           qsfp_txn		    
   ,input  [3:0]           qsfp_rxp
   ,input  [3:0]           qsfp_rxn
   ,input  [0:0]           qsfp_ckp
   ,input  [0:0]           qsfp_ckn,

//---- AXI bus interfaced with SNAP core ----
  // AXI write address channel
 output [C_M_AXI_HOST_MEM_ID_WIDTH - 1:0]      m_axi_snap_awid ,
 output [C_M_AXI_HOST_MEM_ADDR_WIDTH - 1:0]    m_axi_snap_awaddr ,
 output [0007:0] 			       m_axi_snap_awlen ,
 output [0002:0] 			       m_axi_snap_awsize ,
 output [0001:0] 			       m_axi_snap_awburst ,
 output [0003:0] 			       m_axi_snap_awcache ,
 output [0001:0] 			       m_axi_snap_awlock ,
 output [0002:0] 			       m_axi_snap_awprot ,
 output [0003:0] 			       m_axi_snap_awqos ,
 output [0003:0] 			       m_axi_snap_awregion ,
 output [C_M_AXI_HOST_MEM_AWUSER_WIDTH - 1:0]  m_axi_snap_awuser ,
 output 				       m_axi_snap_awvalid ,
 input 					       m_axi_snap_awready ,
  // AXI write data channel
 output [C_M_AXI_HOST_MEM_DATA_WIDTH - 1:0]    m_axi_snap_wdata ,
 output [(C_M_AXI_HOST_MEM_DATA_WIDTH/8) -1:0] m_axi_snap_wstrb ,
 output 				       m_axi_snap_wlast ,
 output 				       m_axi_snap_wvalid ,
 input 					       m_axi_snap_wready ,
  // AXI write response channel
 output 				       m_axi_snap_bready ,
 input [C_M_AXI_HOST_MEM_ID_WIDTH - 1:0]       m_axi_snap_bid ,
 input [0001:0] 			       m_axi_snap_bresp ,
 input 					       m_axi_snap_bvalid ,
  // AXI read address channel
 output [C_M_AXI_HOST_MEM_ID_WIDTH - 1:0]      m_axi_snap_arid ,
 output [C_M_AXI_HOST_MEM_ADDR_WIDTH - 1:0]    m_axi_snap_araddr ,
 output [0007:0] 			       m_axi_snap_arlen ,
 output [0002:0] 			       m_axi_snap_arsize ,
 output [0001:0] 			       m_axi_snap_arburst ,
 output [C_M_AXI_HOST_MEM_ARUSER_WIDTH - 1:0]  m_axi_snap_aruser ,
 output [0003:0] 			       m_axi_snap_arcache ,
 output [0001:0] 			       m_axi_snap_arlock ,
 output [0002:0] 			       m_axi_snap_arprot ,
 output [0003:0] 			       m_axi_snap_arqos ,
 output [0003:0] 			       m_axi_snap_arregion ,
 output 				       m_axi_snap_arvalid ,
 input 					       m_axi_snap_arready ,
  // AXI  ead data channel
 output 				       m_axi_snap_rready ,
 input [C_M_AXI_HOST_MEM_ID_WIDTH - 1:0]       m_axi_snap_rid ,
 input [C_M_AXI_HOST_MEM_DATA_WIDTH - 1:0]     m_axi_snap_rdata ,
 input [0001:0] 			       m_axi_snap_rresp ,
 input 					       m_axi_snap_rlast ,
 input 					       m_axi_snap_rvalid ,


//---- AXI Lite bus interfaced with SNAP core ----
  // AXI write address channel
 output 				       s_axi_snap_awready ,
 input [C_S_AXI_CTRL_REG_ADDR_WIDTH - 1:0]     s_axi_snap_awaddr ,
 input 					       s_axi_snap_awvalid ,
  // axi write data channel
 output 				       s_axi_snap_wready ,
 input [C_S_AXI_CTRL_REG_DATA_WIDTH - 1:0]     s_axi_snap_wdata ,
 input [(C_S_AXI_CTRL_REG_DATA_WIDTH/8) -1:0]  s_axi_snap_wstrb ,
 input 					       s_axi_snap_wvalid ,
  // AXI response channel
 output [0001:0] 			       s_axi_snap_bresp ,
 output 				       s_axi_snap_bvalid ,
 input 					       s_axi_snap_bready ,
  // AXI read address channel
 output 				       s_axi_snap_arready ,
 input 					       s_axi_snap_arvalid ,
 input [C_S_AXI_CTRL_REG_ADDR_WIDTH - 1:0]     s_axi_snap_araddr ,
  // AXI read data channel
 output [C_S_AXI_CTRL_REG_DATA_WIDTH - 1:0]    s_axi_snap_rdata ,
 output [0001:0] 			       s_axi_snap_rresp ,
 input 					       s_axi_snap_rready ,
 output 				       s_axi_snap_rvalid ,

// Other signals
 input [31:0] 				       i_action_type ,
 input [31:0] 				       i_action_version
);

 

wire  [31:0]    snap_context       ;



  wire 	mm2s_err0;
   wire 	s0_axis_mm2s_cmd_tvalid;
   wire 	s0_axis_mm2s_cmd_tready;
   wire [103:0]	s0_axis_mm2s_cmd_tdata;
   wire 	m0_axis_mm2s_sts_tvalid;
   wire 	m0_axis_mm2s_sts_tready;
   wire [7:0] 	m0_axis_mm2s_sts_tdata;
   wire [0:0] 	m0_axis_mm2s_sts_tkeep;
   wire 	m0_axis_mm2s_sts_tlast;
   wire [3:0] 	m0_axi_mm2s_arid;
   wire [63:0] 	m0_axi_mm2s_araddr;
   wire [7:0] 	m0_axi_mm2s_arlen;
   wire [2:0] 	m0_axi_mm2s_arsize;
   wire [1:0] 	m0_axi_mm2s_arburst;
   wire [2:0] 	m0_axi_mm2s_arprot;
   wire [3:0] 	m0_axi_mm2s_arcache;
   wire [3:0] 	m0_axi_mm2s_aruser;
   wire 	m0_axi_mm2s_arvalid;
   wire 	m0_axi_mm2s_arready;
   wire [1023:0] m0_axi_mm2s_rdata;
   wire [1:0] 	 m0_axi_mm2s_rresp;
   wire 	 m0_axi_mm2s_rlast;
   wire 	 m0_axi_mm2s_rvalid;
   wire 	 m0_axi_mm2s_rready;
   wire [511:0]  m0_axis_mm2s_tdata;
   wire [63:0] 	 m0_axis_mm2s_tkeep;
   wire 	 m0_axis_mm2s_tlast;
   wire 	 m0_axis_mm2s_tvalid;
   wire 	 m0_axis_mm2s_tready;
   wire 	 s2mm_err0;
   wire 	s0_axis_s2mm_cmd_tvalid;
   wire 	s0_axis_s2mm_cmd_tready;
   wire [103:0]	s0_axis_s2mm_cmd_tdata;
   wire 	m0_axis_s2mm_sts_tvalid;
   wire 	m0_axis_s2mm_sts_tready;
   wire [31:0] 	m0_axis_s2mm_sts_tdata;
   wire [3:0] 	m0_axis_s2mm_sts_tkeep;
   wire 	m0_axis_s2mm_sts_tlast;
   wire [3:0] 	m0_axi_s2mm_awid;
   wire [63:0] 	m0_axi_s2mm_awaddr;
   wire [7:0] 	m0_axi_s2mm_awlen;
   wire [2:0] 	m0_axi_s2mm_awsize;
   wire [1:0] 	m0_axi_s2mm_awburst;
   wire [2:0] 	m0_axi_s2mm_awprot;
   wire [3:0] 	m0_axi_s2mm_awcache;
   wire [3:0] 	m0_axi_s2mm_awuser;
   wire 	m0_axi_s2mm_awvalid;
   wire 	m0_axi_s2mm_awready;
   wire [1023:0] m0_axi_s2mm_wdata;
   wire [127:0]  m0_axi_s2mm_wstrb;
   wire 	 m0_axi_s2mm_wlast;
   wire 	 m0_axi_s2mm_wvalid;
   wire 	 m0_axi_s2mm_wready;
   wire [1:0] 	 m0_axi_s2mm_bresp;
   wire 	 m0_axi_s2mm_bvalid;
   wire 	 m0_axi_s2mm_bready;
   wire [511:0]  s0_axis_s2mm_tdata;
   wire [63:0] 	 s0_axis_s2mm_tkeep;
   wire 	 s0_axis_s2mm_tlast;
   wire 	 s0_axis_s2mm_tvalid;
   wire 	 s0_axis_s2mm_tready;
   
   wire [3:0] 	m0_axi_s2mm_awregion = 4'b0;
   wire [3:0] 	m0_axi_mm2s_arregion = 4'b0;
   wire [1:0] 	m0_axi_s2mm_awlock = 2'b0;
   wire [1:0] 	m0_axi_mm2s_arlock = 2'b0;
   wire [3:0] 	m0_axi_s2mm_awqos = 4'b0;
   wire [3:0] 	m0_axi_mm2s_arqos = 4'b0;

   wire [511:0]  tx0_axis_tdata;
   wire [63:0] 	 tx0_axis_tkeep;
   wire 	 tx0_axis_tlast;
   wire 	 tx0_axis_tvalid;
   wire 	 tx0_axis_tready;
   wire [511:0]  rx0_axis_tdata;
   wire [63:0] 	 rx0_axis_tkeep;
   wire 	 rx0_axis_tlast;
   wire 	 rx0_axis_tvalid;
   wire 	 rx0_axis_tready;

   wire [31:0] 	 tx0_rd_data_count;

   wire [31:0] 	 rx0_rd_data_count;
   
   wire 	 tx0_cmd_tvalid;
   wire 	 tx0_cmd_tready;
   wire [103:0]  tx0_cmd_tdata;
   wire 	 tx0_cmd_prog_full;  
   wire 	 rx0_cmd_tvalid;
   wire 	 rx0_cmd_tready;
   wire [103:0]  rx0_cmd_tdata;
   wire 	 rx0_cmd_prog_full;

   wire 	 tx0_sts_tvalid;
   wire 	 tx0_sts_tready;
   wire [7:0]  tx0_sts_tdata;
   wire [0:0]  tx0_sts_tkeep;
   wire 	 tx0_sts_prog_full;  
   wire 	 rx0_sts_tvalid;
   wire 	 rx0_sts_tready;
   wire [31:0]  rx0_sts_tdata;
   wire [3:0]  rx0_sts_tkeep;
   wire 	 rx0_sts_prog_full;

   


   wire [0 : 3]  rxp;
   
wire [0 : 3] rxn;


   

      
  wire gt_refclk1_p;
   wire gt_refclk1_n;	      
 
 wire gt_qpllclk_quad1_out;
 wire gt_qpllrefclk_quad1_out;
 wire gt_qpllrefclklost_quad1_out;
 wire gt_qplllock_quad1_out;
wire gt_rxcdrovrden_in=0;
 wire sys_reset_out;
 wire gt_reset_out;
 wire gt_refclk1_out;
 wire [3 : 0] gt_powergood;

   wire [1023:0] cmac_status;
   reg [1023:0] cmac_status_r1;
   reg [1023:0] cmac_status_r2;
   wire [511:0] cmac_ctrl;
   wire [31:0] cmac_drp_status;
   wire [31:0] cmac_drp_ctrl;
   wire        cmac_drp_en;
   wire        cmac_drp_we;

   reg [15:0]  ocr_count=0;
   reg [15:0]  ocw_count=0;
   reg [15:0]  dmt_count=0;
   reg [15:0]  dmr_count=0;
   reg [15:0]  aut_count=0;
   reg [15:0]  aur_count=0;
   


   wire gt_txusrclk2;		// 
   wire [11 : 0] gt_loopback_in; // 
   wire gt_ref_clk_out;		 // 
   wire [3 : 0] gt_rxrecclkout;	 // 
   wire [3 : 0] gt_powergoodout; // 
   wire 	gtwiz_reset_tx_datapath; // 
   wire 	gtwiz_reset_rx_datapath; // 
   wire 	sys_reset;		 // 
                                                                                               
   wire [7 : 0] rx_otn_bip8_0;	// 
   wire [7 : 0] rx_otn_bip8_1;	// 
   wire [7 : 0] rx_otn_bip8_2;	// 
     wire [7 : 0] rx_otn_bip8_3; // 
   wire [7 : 0] rx_otn_bip8_4;	 // 
   wire [65 : 0] rx_otn_data_0;	 // 
   wire [65 : 0] rx_otn_data_1;	 // 
   wire [65 : 0] rx_otn_data_2;	 // 
   wire [65 : 0] rx_otn_data_3;	 // 
   wire [65 : 0] rx_otn_data_4;	 // 
   wire [55 : 0] rx_preambleout; // 
   wire usr_rx_reset;		 // 
   wire gt_rxusrclk2;		 //

   wire stat_rx_received_local_fault;
   wire stat_rx_remote_fault;
   wire stat_rx_status;
   
   
   wire [2 : 0] stat_rx_bad_code; // 
   wire [2 : 0] stat_rx_bad_fcs;  // 
   wire [19 : 0] stat_rx_block_lock; // 
   wire [2 : 0] stat_rx_fragment;    // 
   wire [1 : 0] stat_rx_framing_err_0; // 
   wire [1 : 0] stat_rx_framing_err_1; // 
   wire [1 : 0] stat_rx_framing_err_10;	// 
   wire [1 : 0] stat_rx_framing_err_11;	// 
   wire [1 : 0] stat_rx_framing_err_12;	// 
   wire [1 : 0] stat_rx_framing_err_13;        
   wire [1 : 0] stat_rx_framing_err_14;	// 
   wire [1 : 0] stat_rx_framing_err_15;	// 
   wire [1 : 0] stat_rx_framing_err_16;	// 
   wire [1 : 0] stat_rx_framing_err_17;	// 
   wire [1 : 0] stat_rx_framing_err_18;	// 
   wire [1 : 0] stat_rx_framing_err_19;	// 
   wire [1 : 0] stat_rx_framing_err_2;	// 
   wire [1 : 0] stat_rx_framing_err_3;	// 
   wire [1 : 0] stat_rx_framing_err_4;	// 
   wire [1 : 0] stat_rx_framing_err_5;	// 
   wire [1 : 0] stat_rx_framing_err_6;	// 
   wire [1 : 0] stat_rx_framing_err_7;	// 
   wire [1 : 0] stat_rx_framing_err_8;	// 
   wire [1 : 0] stat_rx_framing_err_9;	// 
   wire [19 : 0] stat_rx_mf_err;	// 
   wire [19 : 0] stat_rx_mf_len_err;	// 
   wire [19 : 0] stat_rx_mf_repeat_err;	// 
   wire [2 : 0] stat_rx_packet_small;	// 
   wire stat_rx_pause;			// 
   wire [15 : 0] stat_rx_pause_quanta0;	// 
   wire [15 : 0] stat_rx_pause_quanta1;	// 
   wire [15 : 0] stat_rx_pause_quanta2;	// 
   wire [15 : 0] stat_rx_pause_quanta3;	// 
   wire [15 : 0] stat_rx_pause_quanta4;	// 
   wire [15 : 0] stat_rx_pause_quanta5;	// 
   wire [15 : 0] stat_rx_pause_quanta6;	// 
   wire [15 : 0] stat_rx_pause_quanta7;	// 
   wire [15 : 0] stat_rx_pause_quanta8;	// 
   wire [8 : 0] stat_rx_pause_req;	// 
   wire [8 : 0] stat_rx_pause_valid;	// 
   wire stat_rx_user_pause;		// 
   wire ctl_rx_check_etype_gcp;		// 
   wire ctl_rx_check_etype_gpp;		// 
   wire ctl_rx_check_etype_pcp;		// 
   wire ctl_rx_check_etype_ppp;		// 
   wire ctl_rx_check_mcast_gcp;		// 
   wire ctl_rx_check_mcast_gpp;		// 
   wire ctl_rx_check_mcast_pcp;		// 
   wire ctl_rx_check_mcast_ppp;		// 
   wire ctl_rx_check_opcode_gcp;	// 
   wire ctl_rx_check_opcode_gpp;	// 
   wire ctl_rx_check_opcode_pcp;	// 
   wire ctl_rx_check_opcode_ppp;	// 
   wire ctl_rx_check_sa_gcp;		// 
   wire ctl_rx_check_sa_gpp;		// 
   wire ctl_rx_check_sa_pcp;		// 
   wire ctl_rx_check_sa_ppp;		// 
   wire ctl_rx_check_ucast_gcp;		// 
   wire ctl_rx_check_ucast_gpp;		// 
   wire ctl_rx_check_ucast_pcp;		// 
   wire ctl_rx_check_ucast_ppp;		// 
   wire ctl_rx_enable_gcp;		// 
   wire ctl_rx_enable_gpp;		// 
   wire ctl_rx_enable_pcp;		// 
   wire ctl_rx_enable_ppp;		// 
   wire [8 : 0] ctl_rx_pause_ack;	// 
   wire [8 : 0] ctl_rx_pause_enable;	// 
   wire 	ctl_rx_enable;		// 
   wire 	ctl_rx_force_resync;	// 
   wire 	ctl_rx_test_pattern;	// 
   wire 	core_rx_reset;		// 
   wire 	rx_clk;			// 
   wire [2 : 0] stat_rx_stomped_fcs;	// 
   wire [19 : 0] stat_rx_synced;	// 
   wire [19 : 0] stat_rx_synced_err;	// 
   wire [2 : 0] stat_rx_test_pattern_mismatch; // 
   wire [6 : 0] stat_rx_total_bytes;           // 
   wire [13 : 0] stat_rx_total_good_bytes;     // 
   wire [2 : 0] stat_rx_total_packets;         // 
   wire [2 : 0] stat_rx_undersize;             // 
   wire [19 : 0] stat_rx_pcsl_demuxed;         // 
   wire [4 : 0] stat_rx_pcsl_number_0;         // 
   wire [4 : 0] stat_rx_pcsl_number_1;         // 
   wire [4 : 0] stat_rx_pcsl_number_10;        // 
   wire [4 : 0] stat_rx_pcsl_number_11;        // 
   wire [4 : 0] stat_rx_pcsl_number_12;        // 
   wire [4 : 0] stat_rx_pcsl_number_13;        // 
   wire [4 : 0] stat_rx_pcsl_number_14;        // 
   wire [4 : 0] stat_rx_pcsl_number_15;        // 
   wire [4 : 0] stat_rx_pcsl_number_16;        // 
   wire [4 : 0] stat_rx_pcsl_number_17;        // 
   wire [4 : 0] stat_rx_pcsl_number_18;        // 
   wire [4 : 0] stat_rx_pcsl_number_19;        // 
   wire [4 : 0] stat_rx_pcsl_number_2;         // 
   wire [4 : 0] stat_rx_pcsl_number_3;         // 
   wire [4 : 0] stat_rx_pcsl_number_4;         // 
   wire [4 : 0] stat_rx_pcsl_number_5;         // 
   wire [4 : 0] stat_rx_pcsl_number_6;         // 
   wire [4 : 0] stat_rx_pcsl_number_7;         // 
   wire [4 : 0] stat_rx_pcsl_number_8;         // 
   wire [4 : 0] stat_rx_pcsl_number_9;         // 
   wire stat_tx_bad_fcs;                       // 
   wire stat_tx_broadcast;                     // 
   wire stat_tx_frame_error;                   // 
   wire stat_tx_local_fault;                   // 
   wire stat_tx_multicast;                     // 
   wire stat_tx_packet_1024_1518_bytes;        // 
   wire stat_tx_packet_128_255_bytes;          // 
   wire stat_tx_packet_1519_1522_bytes;        // 
   wire stat_tx_packet_1523_1548_bytes;        // 
   wire stat_tx_packet_1549_2047_bytes;        // 
   wire stat_tx_packet_2048_4095_bytes;        // 
   wire stat_tx_packet_256_511_bytes;          // 
   wire stat_tx_packet_4096_8191_bytes;        // 
   wire stat_tx_packet_512_1023_bytes;         // 
   wire stat_tx_packet_64_bytes;               // 
   wire stat_tx_packet_65_127_bytes;           // 
   wire stat_tx_packet_8192_9215_bytes;        // 
   wire stat_tx_packet_large;                  // 
   wire stat_tx_packet_small;                  // 
      wire [5 : 0] stat_tx_total_bytes;	// 
   wire [13 : 0] stat_tx_total_good_bytes; // 
   wire stat_tx_total_good_packets;	   // 
   wire stat_tx_total_packets;		   // 
   wire stat_tx_unicast;		   // 
   wire stat_tx_vlan;			   // 
   wire ctl_tx_enable;			   // 
   wire ctl_tx_send_idle;		   // 
   wire ctl_tx_send_rfi;		   // 
   wire ctl_tx_send_lfi;		   // 
   wire ctl_tx_test_pattern;		   // 
   wire core_tx_reset;			   // 
   wire [8 : 0] stat_tx_pause_valid;	   // 
   wire stat_tx_pause;			   // 
   wire stat_tx_user_pause;		   // 
   wire [8 : 0] ctl_tx_pause_enable;	   //
   wire [15 : 0] ctl_tx_pause_quanta0;	   // 
   wire [15 : 0] ctl_tx_pause_quanta1;	   // 
   wire [15 : 0] ctl_tx_pause_quanta2;	   // 
   wire [15 : 0] ctl_tx_pause_quanta3;	   // 
   wire [15 : 0] ctl_tx_pause_quanta4;	   // 
   wire [15 : 0] ctl_tx_pause_quanta5;	   // 
   wire [15 : 0] ctl_tx_pause_quanta6;	   // 
   wire [15 : 0] ctl_tx_pause_quanta7;	   // 
   wire [15 : 0] ctl_tx_pause_quanta8;	   // 
   wire [15 : 0] ctl_tx_pause_refresh_timer0; // 
   wire [15 : 0] ctl_tx_pause_refresh_timer1; // 
     wire [15 : 0] ctl_tx_pause_refresh_timer2;	// 
   wire [15 : 0]   ctl_tx_pause_refresh_timer3;	// 
   wire [15 : 0]   ctl_tx_pause_refresh_timer4;	// 
   wire [15 : 0]   ctl_tx_pause_refresh_timer5;	// 
   wire [15 : 0]   ctl_tx_pause_refresh_timer6;	// 
   wire [15 : 0]   ctl_tx_pause_refresh_timer7;	// 
   wire [15 : 0]   ctl_tx_pause_refresh_timer8;	// 
   wire [8 : 0]    ctl_tx_pause_req;		// 
   wire 	   ctl_tx_resend_pause;		// 
                        
   wire tx_ovfout;		// 
   wire tx_unfout;		// 
   wire [55 : 0] tx_preamblein;	// 
   wire usr_tx_reset;		// 
   wire core_drp_reset;		// 



   wire [9 : 0] drp_addr;    	// 
   wire [15 : 0] drp_di;     	// 
   wire drp_en;              	// 
   wire [15 : 0] drp_do;    	// 
   wire drp_rdy;            	// 
   wire drp_we;               	// 






   
   
//---- registers hub for AXI Lite interface ----
 axi_lite_slave #(
           .DATA_WIDTH   (C_S_AXI_CTRL_REG_DATA_WIDTH   ),
           .ADDR_WIDTH   (C_S_AXI_CTRL_REG_ADDR_WIDTH   )
 ) maxi_lite_slave (
                      .clk                ( clk                ) ,
                      .rst_n              ( rst_n              ) ,
                      .s_axi_awready      ( s_axi_snap_awready ) ,
                      .s_axi_awaddr       ( s_axi_snap_awaddr  ) ,//32b
                      .s_axi_awvalid      ( s_axi_snap_awvalid ) ,
                      .s_axi_wready       ( s_axi_snap_wready  ) ,
                      .s_axi_wdata        ( s_axi_snap_wdata   ) ,//32b
                      .s_axi_wstrb        ( s_axi_snap_wstrb   ) ,//4b
                      .s_axi_wvalid       ( s_axi_snap_wvalid  ) ,
                      .s_axi_bresp        ( s_axi_snap_bresp   ) ,//2b
                      .s_axi_bvalid       ( s_axi_snap_bvalid  ) ,
                      .s_axi_bready       ( s_axi_snap_bready  ) ,
                      .s_axi_arready      ( s_axi_snap_arready ) ,
                      .s_axi_arvalid      ( s_axi_snap_arvalid ) ,
                      .s_axi_araddr       ( s_axi_snap_araddr  ) ,//32b
                      .s_axi_rdata        ( s_axi_snap_rdata   ) ,//32b
                      .s_axi_rresp        ( s_axi_snap_rresp   ) ,//2b
                      .s_axi_rready       ( s_axi_snap_rready  ) ,
                      .s_axi_rvalid       ( s_axi_snap_rvalid  ) ,

                      
		      .tx0_rd_data_count(tx0_rd_data_count),
                      .rx0_rd_data_count(rx0_rd_data_count),
   
   	              .tx0_cmd_tvalid(tx0_cmd_tvalid),
                      .tx0_cmd_tready(tx0_cmd_tready),
                      .tx0_cmd_tdata(tx0_cmd_tdata),
                      .tx0_cmd_prog_full(tx0_cmd_prog_full),  
                      .rx0_cmd_tvalid(rx0_cmd_tvalid),
                      .rx0_cmd_tready(rx0_cmd_tready),
                      .rx0_cmd_tdata(rx0_cmd_tdata),
                      .rx0_cmd_prog_full(rx0_cmd_prog_full),

                      .tx0_sts_tvalid(tx0_sts_tvalid),
                      .tx0_sts_tready(tx0_sts_tready),
                      .tx0_sts_tdata(tx0_sts_tdata),
                      .tx0_sts_tkeep(tx0_sts_tkeep),
                      .tx0_sts_prog_full(tx0_sts_prog_full),  
                      .rx0_sts_tvalid(rx0_sts_tvalid),
                      .rx0_sts_tready(rx0_sts_tready),
                      .rx0_sts_tdata(rx0_sts_tdata),
                      .rx0_sts_tkeep(rx0_sts_tkeep),
                      .rx0_sts_prog_full(rx0_sts_prog_full),  
.cmac_status(cmac_status_r2),
.cmac_ctrl(cmac_ctrl),
.cmac_drp_status(cmac_drp_status),
.cmac_drp_ctrl(cmac_drp_ctrl),
.cmac_drp_en(cmac_drp_en),
.cmac_drp_we(cmac_drp_we),
		    
                      .i_action_type      ( i_action_type      ) ,
                      .i_action_version   ( i_action_version   ) ,
                      .o_snap_context     ( snap_context       )
           );
 
  


 axis_data_fifo_cmd tx0_cmd_fifo (
  .s_axis_aresetn(rst_n),  // input wire s_axis_aresetn
  .s_axis_aclk(clk),        // input wire s_axis_aclk
  .s_axis_tvalid(tx0_cmd_tvalid),    // input wire s_axis_tvalid
  .s_axis_tready(tx0_cmd_tready),    // output wire s_axis_tready
  .s_axis_tdata(tx0_cmd_tdata),      // input wire [103 : 0] s_axis_tdata
  .m_axis_tvalid(s0_axis_mm2s_cmd_tvalid),    // output wire m_axis_tvalid
  .m_axis_tready(s0_axis_mm2s_cmd_tready),    // input wire m_axis_tready
  .m_axis_tdata(s0_axis_mm2s_cmd_tdata),      // output wire [103 : 0] m_axis_tdata
  .prog_full(tx0_cmd_prog_full)            // output wire prog_full
);

axis_data_fifo_sts_mm2s tx0_sts_fifo (
  .s_axis_aresetn(rst_n),  // input wire s_axis_aresetn
  .s_axis_aclk(clk),        // input wire s_axis_aclk
  .s_axis_tvalid(m0_axis_mm2s_sts_tvalid),    // input wire s_axis_tvalid
  .s_axis_tready(m0_axis_mm2s_sts_tready),    // output wire s_axis_tready
  .s_axis_tdata(m0_axis_mm2s_sts_tdata),      // input wire [7 : 0] s_axis_tdata
  .s_axis_tkeep(m0_axis_mm2s_sts_tkeep),      // input wire [0 : 0] s_axis_tkeep
  .m_axis_tvalid(tx0_sts_tvalid),    // output wire m_axis_tvalid
  .m_axis_tready(tx0_sts_tready),    // input wire m_axis_tready
  .m_axis_tdata(tx0_sts_tdata),      // output wire [7 : 0] m_axis_tdata
  .m_axis_tkeep(tx0_sts_tkeep),      // output wire [0 : 0] m_axis_tkeep
  .prog_full(tx0_sts_prog_full)            // output wire prog_full
);
   
   axis_data_fifo_cmd rx0_cmd_fifo (
  .s_axis_aresetn(rst_n),  // input wire s_axis_aresetn
  .s_axis_aclk(clk),        // input wire s_axis_aclk
  .s_axis_tvalid(rx0_cmd_tvalid),    // input wire s_axis_tvalid
  .s_axis_tready(rx0_cmd_tready),    // output wire s_axis_tready
  .s_axis_tdata(rx0_cmd_tdata),      // input wire [103 : 0] s_axis_tdata
  .m_axis_tvalid(s0_axis_s2mm_cmd_tvalid),    // output wire m_axis_tvalid
  .m_axis_tready(s0_axis_s2mm_cmd_tready),    // input wire m_axis_tready
  .m_axis_tdata(s0_axis_s2mm_cmd_tdata),      // output wire [103 : 0] m_axis_tdata
  .prog_full(rx0_cmd_prog_full)            // output wire prog_full
);

axis_data_fifo_sts_s2mm rx0_sts_fifo (
  .s_axis_aresetn(rst_n),  // input wire s_axis_aresetn
  .s_axis_aclk(clk),        // input wire s_axis_aclk
  .s_axis_tvalid(m0_axis_s2mm_sts_tvalid),    // input wire s_axis_tvalid
  .s_axis_tready(m0_axis_s2mm_sts_tready),    // output wire s_axis_tready
  .s_axis_tdata(m0_axis_s2mm_sts_tdata),      // input wire [31 : 0] s_axis_tdata
  .s_axis_tkeep(m0_axis_s2mm_sts_tkeep),      // input wire [3 : 0] s_axis_tkeep
  .m_axis_tvalid(rx0_sts_tvalid),    // output wire m_axis_tvalid
  .m_axis_tready(rx0_sts_tready),    // input wire m_axis_tready
  .m_axis_tdata(rx0_sts_tdata),      // output wire [31 : 0] m_axis_tdata
  .m_axis_tkeep(rx0_sts_tkeep),      // output wire [3 : 0] m_axis_tkeep
  .prog_full(rx0_sts_prog_full)            // output wire prog_full
);


   
axi_datamover_0 dm_unit_ch0 (
  .m_axi_mm2s_aclk(clk),                        // input wire m_axi_mm2s_aclk
  .m_axi_mm2s_aresetn(rst_n),                  // input wire m_axi_mm2s_aresetn
  .mm2s_err(mm2s_err0),                                      // output wire mm2s_err
  .m_axis_mm2s_cmdsts_aclk(clk),        // input wire m_axis_mm2s_cmdsts_aclk
  .m_axis_mm2s_cmdsts_aresetn(rst_n),  // input wire m_axis_mm2s_cmdsts_aresetn
  .s_axis_mm2s_cmd_tvalid(s0_axis_mm2s_cmd_tvalid),          // input wire s_axis_mm2s_cmd_tvalid
  .s_axis_mm2s_cmd_tready(s0_axis_mm2s_cmd_tready),          // output wire s_axis_mm2s_cmd_tready
  .s_axis_mm2s_cmd_tdata(s0_axis_mm2s_cmd_tdata),            // input wire [103 : 0] s_axis_mm2s_cmd_tdata
  .m_axis_mm2s_sts_tvalid(m0_axis_mm2s_sts_tvalid),          // output wire m_axis_mm2s_sts_tvalid
  .m_axis_mm2s_sts_tready(m0_axis_mm2s_sts_tready),          // input wire m_axis_mm2s_sts_tready
  .m_axis_mm2s_sts_tdata(m0_axis_mm2s_sts_tdata),            // output wire [7 : 0] m_axis_mm2s_sts_tdata
  .m_axis_mm2s_sts_tkeep(m0_axis_mm2s_sts_tkeep),            // output wire [0 : 0] m_axis_mm2s_sts_tkeep
  .m_axis_mm2s_sts_tlast(m0_axis_mm2s_sts_tlast),            // output wire m_axis_mm2s_sts_tlast
  .m_axi_mm2s_arid(m0_axi_mm2s_arid),                        // output wire [3 : 0] m_axi_mm2s_arid
  .m_axi_mm2s_araddr(m0_axi_mm2s_araddr),                    // output wire [63 : 0] m_axi_mm2s_araddr
  .m_axi_mm2s_arlen(m0_axi_mm2s_arlen),                      // output wire [7 : 0] m_axi_mm2s_arlen
  .m_axi_mm2s_arsize(m0_axi_mm2s_arsize),                    // output wire [2 : 0] m_axi_mm2s_arsize
  .m_axi_mm2s_arburst(m0_axi_mm2s_arburst),                  // output wire [1 : 0] m_axi_mm2s_arburst
  .m_axi_mm2s_arprot(m0_axi_mm2s_arprot),                    // output wire [2 : 0] m_axi_mm2s_arprot
  .m_axi_mm2s_arcache(m0_axi_mm2s_arcache),                  // output wire [3 : 0] m_axi_mm2s_arcache
  .m_axi_mm2s_aruser(m0_axi_mm2s_aruser),                    // output wire [3 : 0] m_axi_mm2s_aruser
  .m_axi_mm2s_arvalid(m0_axi_mm2s_arvalid),                  // output wire m_axi_mm2s_arvalid
  .m_axi_mm2s_arready(m0_axi_mm2s_arready),                  // input wire m_axi_mm2s_arready
  .m_axi_mm2s_rdata(m0_axi_mm2s_rdata),                      // input wire [1023 : 0] m_axi_mm2s_rdata
  .m_axi_mm2s_rresp(m0_axi_mm2s_rresp),                      // input wire [1 : 0] m_axi_mm2s_rresp
  .m_axi_mm2s_rlast(m0_axi_mm2s_rlast),                      // input wire m_axi_mm2s_rlast
  .m_axi_mm2s_rvalid(m0_axi_mm2s_rvalid),                    // input wire m_axi_mm2s_rvalid
  .m_axi_mm2s_rready(m0_axi_mm2s_rready),                    // output wire m_axi_mm2s_rready
  .m_axis_mm2s_tdata(m0_axis_mm2s_tdata),                    // output wire [255 : 0] m_axis_mm2s_tdata
  .m_axis_mm2s_tkeep(m0_axis_mm2s_tkeep),                    // output wire [31 : 0] m_axis_mm2s_tkeep
  .m_axis_mm2s_tlast(m0_axis_mm2s_tlast),                    // output wire m_axis_mm2s_tlast
  .m_axis_mm2s_tvalid(m0_axis_mm2s_tvalid),                  // output wire m_axis_mm2s_tvalid
  .m_axis_mm2s_tready(m0_axis_mm2s_tready),                  // input wire m_axis_mm2s_tready
  .m_axi_s2mm_aclk(clk),                        // input wire m_axi_s2mm_aclk
  .m_axi_s2mm_aresetn(rst_n),                  // input wire m_axi_s2mm_aresetn
  .s2mm_err(s2mm_err0),                                      // output wire s2mm_err
  .m_axis_s2mm_cmdsts_awclk(clk),      // input wire m_axis_s2mm_cmdsts_awclk
  .m_axis_s2mm_cmdsts_aresetn(rst_n),  // input wire m_axis_s2mm_cmdsts_aresetn
  .s_axis_s2mm_cmd_tvalid(s0_axis_s2mm_cmd_tvalid),          // input wire s_axis_s2mm_cmd_tvalid
  .s_axis_s2mm_cmd_tready(s0_axis_s2mm_cmd_tready),          // output wire s_axis_s2mm_cmd_tready
  .s_axis_s2mm_cmd_tdata(s0_axis_s2mm_cmd_tdata),            // input wire [103 : 0] s_axis_s2mm_cmd_tdata
  .m_axis_s2mm_sts_tvalid(m0_axis_s2mm_sts_tvalid),          // output wire m_axis_s2mm_sts_tvalid
  .m_axis_s2mm_sts_tready(m0_axis_s2mm_sts_tready),          // input wire m_axis_s2mm_sts_tready
  .m_axis_s2mm_sts_tdata(m0_axis_s2mm_sts_tdata),            // output wire [31 : 0] m_axis_s2mm_sts_tdata
  .m_axis_s2mm_sts_tkeep(m0_axis_s2mm_sts_tkeep),            // output wire [3 : 0] m_axis_s2mm_sts_tkeep
  .m_axis_s2mm_sts_tlast(m0_axis_s2mm_sts_tlast),            // output wire m_axis_s2mm_sts_tlast
  .m_axi_s2mm_awid(m0_axi_s2mm_awid),                        // output wire [3 : 0] m_axi_s2mm_awid
  .m_axi_s2mm_awaddr(m0_axi_s2mm_awaddr),                    // output wire [63 : 0] m_axi_s2mm_awaddr
  .m_axi_s2mm_awlen(m0_axi_s2mm_awlen),                      // output wire [7 : 0] m_axi_s2mm_awlen
  .m_axi_s2mm_awsize(m0_axi_s2mm_awsize),                    // output wire [2 : 0] m_axi_s2mm_awsize
  .m_axi_s2mm_awburst(m0_axi_s2mm_awburst),                  // output wire [1 : 0] m_axi_s2mm_awburst
  .m_axi_s2mm_awprot(m0_axi_s2mm_awprot),                    // output wire [2 : 0] m_axi_s2mm_awprot
  .m_axi_s2mm_awcache(m0_axi_s2mm_awcache),                  // output wire [3 : 0] m_axi_s2mm_awcache
  .m_axi_s2mm_awuser(m0_axi_s2mm_awuser),                    // output wire [3 : 0] m_axi_s2mm_awuser
  .m_axi_s2mm_awvalid(m0_axi_s2mm_awvalid),                  // output wire m_axi_s2mm_awvalid
  .m_axi_s2mm_awready(m0_axi_s2mm_awready),                  // input wire m_axi_s2mm_awready
  .m_axi_s2mm_wdata(m0_axi_s2mm_wdata),                      // output wire [1023 : 0] m_axi_s2mm_wdata
  .m_axi_s2mm_wstrb(m0_axi_s2mm_wstrb),                      // output wire [127 : 0] m_axi_s2mm_wstrb
  .m_axi_s2mm_wlast(m0_axi_s2mm_wlast),                      // output wire m_axi_s2mm_wlast
  .m_axi_s2mm_wvalid(m0_axi_s2mm_wvalid),                    // output wire m_axi_s2mm_wvalid
  .m_axi_s2mm_wready(m0_axi_s2mm_wready),                    // input wire m_axi_s2mm_wready
  .m_axi_s2mm_bresp(m0_axi_s2mm_bresp),                      // input wire [1 : 0] m_axi_s2mm_bresp
  .m_axi_s2mm_bvalid(m0_axi_s2mm_bvalid),                    // input wire m_axi_s2mm_bvalid
  .m_axi_s2mm_bready(m0_axi_s2mm_bready),                    // output wire m_axi_s2mm_bready
  .s_axis_s2mm_tdata(s0_axis_s2mm_tdata),                    // input wire [255 : 0] s_axis_s2mm_tdata
  .s_axis_s2mm_tkeep(s0_axis_s2mm_tkeep),                    // input wire [31 : 0] s_axis_s2mm_tkeep
  .s_axis_s2mm_tlast(s0_axis_s2mm_tlast),                    // input wire s_axis_s2mm_tlast
  .s_axis_s2mm_tvalid(s0_axis_s2mm_tvalid),                  // input wire s_axis_s2mm_tvalid
  .s_axis_s2mm_tready(s0_axis_s2mm_tready)                  // output wire s_axis_s2mm_tready
);


// Connect m0_axi_ direct to m_axi_snap_
   assign m_axi_snap_arid = m0_axi_mm2s_arid;
   assign m_axi_snap_araddr = m0_axi_mm2s_araddr;
   assign m_axi_snap_arlen = m0_axi_mm2s_arlen;
   assign m_axi_snap_arsize = m0_axi_mm2s_arsize;
   assign m_axi_snap_arburst = m0_axi_mm2s_arburst;
   assign m_axi_snap_aruser = m0_axi_mm2s_aruser;
   assign m_axi_snap_arcache = m0_axi_mm2s_arcache;
   assign m_axi_snap_arlock = m0_axi_mm2s_arlock;
   assign m_axi_snap_arprot = m0_axi_mm2s_arprot;
   assign m_axi_snap_arqos = m0_axi_mm2s_arqos;
   assign m_axi_snap_arregion = m0_axi_mm2s_arregion;
   assign m_axi_snap_arvalid = m0_axi_mm2s_arvalid;
   assign m0_axi_mm2s_arready = m_axi_snap_arready;
   assign m_axi_snap_rready = m0_axi_mm2s_rready;
   assign m0_axi_mm2s_rid = m_axi_snap_rid;
   assign m0_axi_mm2s_rdata = m_axi_snap_rdata;
   assign m0_axi_mm2s_rresp = m_axi_snap_rresp;
   assign m0_axi_mm2s_rlast = m_axi_snap_rlast;
   assign m0_axi_mm2s_rvalid = m_axi_snap_rvalid;
   assign m_axi_snap_awid = m0_axi_s2mm_awid;
   assign m_axi_snap_awaddr = m0_axi_s2mm_awaddr;
   assign m_axi_snap_awlen = m0_axi_s2mm_awlen;
   assign m_axi_snap_awsize = m0_axi_s2mm_awsize;
   assign m_axi_snap_awburst = m0_axi_s2mm_awburst;
   assign m_axi_snap_awuser = m0_axi_s2mm_awuser;
   assign m_axi_snap_awcache = m0_axi_s2mm_awcache;
   assign m_axi_snap_awlock = m0_axi_s2mm_awlock;
   assign m_axi_snap_awprot = m0_axi_s2mm_awprot;
   assign m_axi_snap_awqos = m0_axi_s2mm_awqos;
   assign m_axi_snap_awregion = m0_axi_s2mm_awregion;
   assign m_axi_snap_awvalid = m0_axi_s2mm_awvalid;
   assign m0_axi_s2mm_awready = m_axi_snap_awready;
   assign m_axi_snap_wdata = m0_axi_s2mm_wdata;
   assign m_axi_snap_wstrb = m0_axi_s2mm_wstrb;
   assign m_axi_snap_wlast = m0_axi_s2mm_wlast;
   assign m_axi_snap_wvalid = m0_axi_s2mm_wvalid;
   assign m0_axi_s2mm_wready = m_axi_snap_wready;
   assign m_axi_snap_bready = m0_axi_s2mm_bready;
   assign m0_axi_s2mm_bid = m_axi_snap_bid;
   assign m0_axi_s2mm_bresp = m_axi_snap_bresp;
   assign m0_axi_s2mm_bvalid = m_axi_snap_bvalid;

 wire        user_clk;
   assign user_clk = gt_txusrclk2;
 wire      tx0_axis_tvalid_q;
   wire      tx0_axis_tready_q;

   reg 	     tx0_axis_burst_enable = 1'b0;
   
  // Connect up TX and RX FIFOs to the data channels
  axis_data_fifo_data axis_tx_fifo (
  .s_axis_aresetn(rst_n),          // input wire s_axis_aresetn
  .s_axis_aclk(clk),                // input wire s_axis_aclk
  .s_axis_tvalid(m0_axis_mm2s_tvalid),            // input wire s_axis_tvalid
  .s_axis_tready(m0_axis_mm2s_tready),            // output wire s_axis_tready
  .s_axis_tdata(m0_axis_mm2s_tdata),              // input wire [255 : 0] s_axis_tdata
  .s_axis_tkeep(m0_axis_mm2s_tkeep),              // input wire [31 : 0] s_axis_tkeep
  .s_axis_tlast(m0_axis_mm2s_tlast),              // input wire s_axis_tlast
  .m_axis_aclk(user_clk),				    
  .m_axis_tvalid(tx0_axis_tvalid),            // output wire m_axis_tvalid
  .m_axis_tready(tx0_axis_tready_q),            // input wire m_axis_tready
  .m_axis_tdata(tx0_axis_tdata),              // output wire [255 : 0] m_axis_tdata
  .m_axis_tkeep(tx0_axis_tkeep),              // output wire [31 : 0] m_axis_tkeep
  .m_axis_tlast(tx0_axis_tlast),              // output wire m_axis_tlast
  .axis_rd_data_count(tx0_rd_data_count)  // output wire [31 : 0] axis_rd_data_count
);


  
   
   assign tx0_axis_tvalid_q = tx0_axis_burst_enable & tx0_axis_tvalid;
   assign tx0_axis_tready_q = tx0_axis_burst_enable & tx0_axis_tready;
   
   
   always @(posedge user_clk or negedge rst_n) begin
    if (~rst_n) begin
       tx0_axis_burst_enable <= 1'b0;
      
    end
    else begin
       if (tx0_axis_burst_enable) begin
	  if (tx0_axis_tlast & tx0_axis_tvalid & tx0_axis_tready)
	    tx0_axis_burst_enable <= 1'b0;
       end 
       else
	 if (tx0_rd_data_count > 9)
	   tx0_axis_burst_enable <= 1'b1;
       
	   
	       
    end
end 
 
   
   axis_data_fifo_data axis_rx_fifo (
  .s_axis_aresetn(rst_n),          // input wire s_axis_aresetn
  .s_axis_aclk(user_clk),                // input wire s_axis_aclk
  .s_axis_tvalid(rx0_axis_tvalid),            // input wire s_axis_tvalid
  .s_axis_tready(rx0_axis_tready),            // output wire s_axis_tready
  .s_axis_tdata(rx0_axis_tdata),              // input wire [255 : 0] s_axis_tdata
  .s_axis_tkeep(rx0_axis_tkeep),              // input wire [31 : 0] s_axis_tkeep
  .s_axis_tlast(rx0_axis_tlast),              // input wire s_axis_tlast
  .m_axis_aclk(clk),
  .m_axis_tvalid(s0_axis_s2mm_tvalid),            // output wire m_axis_tvalid
  .m_axis_tready(s0_axis_s2mm_tready),            // input wire m_axis_tready
  .m_axis_tdata(s0_axis_s2mm_tdata),              // output wire [255 : 0] m_axis_tdata
  .m_axis_tkeep(s0_axis_s2mm_tkeep),              // output wire [31 : 0] m_axis_tkeep
  .m_axis_tlast(s0_axis_s2mm_tlast),              // output wire m_axis_tlast
  .axis_rd_data_count(rx0_rd_data_count)  // output wire [31 : 0] axis_rd_data_count
);




   assign sys_reset = ~rst_n | cmac_ctrl[0];
   assign gtwiz_reset_tx_datapath = cmac_ctrl[1];
   assign gtwiz_reset_rx_datapath = cmac_ctrl[2];
   assign core_rx_reset = cmac_ctrl[3];
   assign core_tx_reset = cmac_ctrl[4];

   assign gt_loopback_in = {cmac_ctrl[7:5],cmac_ctrl[7:5],cmac_ctrl[7:5],cmac_ctrl[7:5]};

   assign rx_clk = user_clk;
   assign tx_clk = user_clk;
   
   assign core_drp_reset = cmac_drp_ctrl[0];
   
   assign drp_addr = cmac_drp_ctrl[15:6];
  
   assign drp_di = cmac_drp_ctrl[31:16];
   assign drp_we = cmac_drp_we;
   assign drp_en = cmac_drp_en;
   assign cmac_drp_status = {drp_rdy,drp_do};
   
 

cmac_usplus_0 cmac0(
  .gt0_rxp_in(qsfp_rxp[0]),                                          // input wire gt0_rxp_in
  .gt0_rxn_in(qsfp_rxn[0]),                                          // input wire gt0_rxn_in
  .gt1_rxp_in(qsfp_rxp[1]),                                          // input wire gt1_rxp_in
  .gt1_rxn_in(qsfp_rxn[1]),                                          // input wire gt1_rxn_in
  .gt2_rxp_in(qsfp_rxp[2]),                                          // input wire gt2_rxp_in
  .gt2_rxn_in(qsfp_rxn[2]),                                          // input wire gt2_rxn_in
  .gt3_rxp_in(qsfp_rxp[3]),                                          // input wire gt3_rxp_in
  .gt3_rxn_in(qsfp_rxn[3]),                                          // input wire gt3_rxn_in
  .gt0_txp_out(qsfp_txp[0]),                                        // output wire gt0_txp_out
  .gt0_txn_out(qsfp_txn[0]),                                        // output wire gt0_txn_out
  .gt1_txp_out(qsfp_txp[1]),                                        // output wire gt1_txp_out
  .gt1_txn_out(qsfp_txn[1]),                                        // output wire gt1_txn_out
  .gt2_txp_out(qsfp_txp[2]),                                        // output wire gt2_txp_out
  .gt2_txn_out(qsfp_txn[2]),                                        // output wire gt2_txn_out
  .gt3_txp_out(qsfp_txp[3]),                                        // output wire gt3_txp_out
  .gt3_txn_out(qsfp_txn[3]),                                        // output wire gt3_txn_out
  .gt_txusrclk2(gt_txusrclk2),                                      // output wire gt_txusrclk2
  .gt_loopback_in(gt_loopback_in),                                  // input wire [11 : 0] gt_loopback_in
  .gt_ref_clk_out(gt_ref_clk_out),                                  // output wire gt_ref_clk_out
  .gt_rxrecclkout(gt_rxrecclkout),                                  // output wire [3 : 0] gt_rxrecclkout
  .gt_powergoodout(gt_powergoodout),                                // output wire [3 : 0] gt_powergoodout
  .gtwiz_reset_tx_datapath(gtwiz_reset_tx_datapath),                // input wire gtwiz_reset_tx_datapath
  .gtwiz_reset_rx_datapath(gtwiz_reset_rx_datapath),                // input wire gtwiz_reset_rx_datapath
  .sys_reset(sys_reset),                                            // input wire sys_reset
  .gt_ref_clk_p(gt_refclk1_p),                                      // input wire gt_ref_clk_p
  .gt_ref_clk_n(gt_refclk1_n),                                      // input wire gt_ref_clk_n
  .init_clk(clk),                                              // input wire init_clk
  .rx_axis_tvalid(rx0_axis_tvalid),                                  // output wire rx_axis_tvalid
  .rx_axis_tdata(rx0_axis_tdata),                                    // output wire [511 : 0] rx_axis_tdata
  .rx_axis_tlast(rx0_axis_tlast),                                    // output wire rx_axis_tlast
  .rx_axis_tkeep(rx0_axis_tkeep),                                    // output wire [63 : 0] rx_axis_tkeep
  .rx_axis_tuser(rx0_axis_tuser),                                    // output wire rx_axis_tuser
  .rx_otn_bip8_0(rx_otn_bip8_0),                                    // output wire [7 : 0] rx_otn_bip8_0
  .rx_otn_bip8_1(rx_otn_bip8_1),                                    // output wire [7 : 0] rx_otn_bip8_1
  .rx_otn_bip8_2(rx_otn_bip8_2),                                    // output wire [7 : 0] rx_otn_bip8_2
  .rx_otn_bip8_3(rx_otn_bip8_3),                                    // output wire [7 : 0] rx_otn_bip8_3
  .rx_otn_bip8_4(rx_otn_bip8_4),                                    // output wire [7 : 0] rx_otn_bip8_4
  .rx_otn_data_0(rx_otn_data_0),                                    // output wire [65 : 0] rx_otn_data_0
  .rx_otn_data_1(rx_otn_data_1),                                    // output wire [65 : 0] rx_otn_data_1
  .rx_otn_data_2(rx_otn_data_2),                                    // output wire [65 : 0] rx_otn_data_2
  .rx_otn_data_3(rx_otn_data_3),                                    // output wire [65 : 0] rx_otn_data_3
  .rx_otn_data_4(rx_otn_data_4),                                    // output wire [65 : 0] rx_otn_data_4
  .rx_preambleout(rx_preambleout),                                  // output wire [55 : 0] rx_preambleout
  .usr_rx_reset(usr_rx_reset),                                      // output wire usr_rx_reset
  .gt_rxusrclk2(gt_rxusrclk2),                                      // output wire gt_rxusrclk2
  .stat_rx_bad_code(stat_rx_bad_code),                              // output wire [2 : 0] stat_rx_bad_code
  .stat_rx_bad_fcs(stat_rx_bad_fcs),                                // output wire [2 : 0] stat_rx_bad_fcs
  .stat_rx_block_lock(stat_rx_block_lock),                          // output wire [19 : 0] stat_rx_block_lock
  .stat_rx_fragment(stat_rx_fragment),                              // output wire [2 : 0] stat_rx_fragment
  .stat_rx_framing_err_0(stat_rx_framing_err_0),                    // output wire [1 : 0] stat_rx_framing_err_0
  .stat_rx_framing_err_1(stat_rx_framing_err_1),                    // output wire [1 : 0] stat_rx_framing_err_1
  .stat_rx_framing_err_10(stat_rx_framing_err_10),                  // output wire [1 : 0] stat_rx_framing_err_10
  .stat_rx_framing_err_11(stat_rx_framing_err_11),                  // output wire [1 : 0] stat_rx_framing_err_11
  .stat_rx_framing_err_12(stat_rx_framing_err_12),                  // output wire [1 : 0] stat_rx_framing_err_12
  .stat_rx_framing_err_13(stat_rx_framing_err_13),                  // output wire [1 : 0] stat_rx_framing_err_13
  .stat_rx_framing_err_14(stat_rx_framing_err_14),                  // output wire [1 : 0] stat_rx_framing_err_14
  .stat_rx_framing_err_15(stat_rx_framing_err_15),                  // output wire [1 : 0] stat_rx_framing_err_15
  .stat_rx_framing_err_16(stat_rx_framing_err_16),                  // output wire [1 : 0] stat_rx_framing_err_16
  .stat_rx_framing_err_17(stat_rx_framing_err_17),                  // output wire [1 : 0] stat_rx_framing_err_17
  .stat_rx_framing_err_18(stat_rx_framing_err_18),                  // output wire [1 : 0] stat_rx_framing_err_18
  .stat_rx_framing_err_19(stat_rx_framing_err_19),                  // output wire [1 : 0] stat_rx_framing_err_19
  .stat_rx_framing_err_2(stat_rx_framing_err_2),                    // output wire [1 : 0] stat_rx_framing_err_2
  .stat_rx_framing_err_3(stat_rx_framing_err_3),                    // output wire [1 : 0] stat_rx_framing_err_3
  .stat_rx_framing_err_4(stat_rx_framing_err_4),                    // output wire [1 : 0] stat_rx_framing_err_4
  .stat_rx_framing_err_5(stat_rx_framing_err_5),                    // output wire [1 : 0] stat_rx_framing_err_5
  .stat_rx_framing_err_6(stat_rx_framing_err_6),                    // output wire [1 : 0] stat_rx_framing_err_6
  .stat_rx_framing_err_7(stat_rx_framing_err_7),                    // output wire [1 : 0] stat_rx_framing_err_7
  .stat_rx_framing_err_8(stat_rx_framing_err_8),                    // output wire [1 : 0] stat_rx_framing_err_8
  .stat_rx_framing_err_9(stat_rx_framing_err_9),                    // output wire [1 : 0] stat_rx_framing_err_9
  .stat_rx_mf_err(stat_rx_mf_err),                                  // output wire [19 : 0] stat_rx_mf_err
  .stat_rx_mf_len_err(stat_rx_mf_len_err),                          // output wire [19 : 0] stat_rx_mf_len_err
  .stat_rx_mf_repeat_err(stat_rx_mf_repeat_err),                    // output wire [19 : 0] stat_rx_mf_repeat_err
  .stat_rx_packet_small(stat_rx_packet_small),                      // output wire [2 : 0] stat_rx_packet_small
  .stat_rx_pause(stat_rx_pause),                                    // output wire stat_rx_pause
  .stat_rx_pause_quanta0(stat_rx_pause_quanta0),                    // output wire [15 : 0] stat_rx_pause_quanta0
  .stat_rx_pause_quanta1(stat_rx_pause_quanta1),                    // output wire [15 : 0] stat_rx_pause_quanta1
  .stat_rx_pause_quanta2(stat_rx_pause_quanta2),                    // output wire [15 : 0] stat_rx_pause_quanta2
  .stat_rx_pause_quanta3(stat_rx_pause_quanta3),                    // output wire [15 : 0] stat_rx_pause_quanta3
  .stat_rx_pause_quanta4(stat_rx_pause_quanta4),                    // output wire [15 : 0] stat_rx_pause_quanta4
  .stat_rx_pause_quanta5(stat_rx_pause_quanta5),                    // output wire [15 : 0] stat_rx_pause_quanta5
  .stat_rx_pause_quanta6(stat_rx_pause_quanta6),                    // output wire [15 : 0] stat_rx_pause_quanta6
  .stat_rx_pause_quanta7(stat_rx_pause_quanta7),                    // output wire [15 : 0] stat_rx_pause_quanta7
  .stat_rx_pause_quanta8(stat_rx_pause_quanta8),                    // output wire [15 : 0] stat_rx_pause_quanta8
  .stat_rx_pause_req(stat_rx_pause_req),                            // output wire [8 : 0] stat_rx_pause_req
  .stat_rx_pause_valid(stat_rx_pause_valid),                        // output wire [8 : 0] stat_rx_pause_valid
  .stat_rx_user_pause(stat_rx_user_pause),                          // output wire stat_rx_user_pause
  .ctl_rx_check_etype_gcp(ctl_rx_check_etype_gcp),                  // input wire ctl_rx_check_etype_gcp
  .ctl_rx_check_etype_gpp(ctl_rx_check_etype_gpp),                  // input wire ctl_rx_check_etype_gpp
  .ctl_rx_check_etype_pcp(ctl_rx_check_etype_pcp),                  // input wire ctl_rx_check_etype_pcp
  .ctl_rx_check_etype_ppp(ctl_rx_check_etype_ppp),                  // input wire ctl_rx_check_etype_ppp
  .ctl_rx_check_mcast_gcp(ctl_rx_check_mcast_gcp),                  // input wire ctl_rx_check_mcast_gcp
  .ctl_rx_check_mcast_gpp(ctl_rx_check_mcast_gpp),                  // input wire ctl_rx_check_mcast_gpp
  .ctl_rx_check_mcast_pcp(ctl_rx_check_mcast_pcp),                  // input wire ctl_rx_check_mcast_pcp
  .ctl_rx_check_mcast_ppp(ctl_rx_check_mcast_ppp),                  // input wire ctl_rx_check_mcast_ppp
  .ctl_rx_check_opcode_gcp(ctl_rx_check_opcode_gcp),                // input wire ctl_rx_check_opcode_gcp
  .ctl_rx_check_opcode_gpp(ctl_rx_check_opcode_gpp),                // input wire ctl_rx_check_opcode_gpp
  .ctl_rx_check_opcode_pcp(ctl_rx_check_opcode_pcp),                // input wire ctl_rx_check_opcode_pcp
  .ctl_rx_check_opcode_ppp(ctl_rx_check_opcode_ppp),                // input wire ctl_rx_check_opcode_ppp
  .ctl_rx_check_sa_gcp(ctl_rx_check_sa_gcp),                        // input wire ctl_rx_check_sa_gcp
  .ctl_rx_check_sa_gpp(ctl_rx_check_sa_gpp),                        // input wire ctl_rx_check_sa_gpp
  .ctl_rx_check_sa_pcp(ctl_rx_check_sa_pcp),                        // input wire ctl_rx_check_sa_pcp
  .ctl_rx_check_sa_ppp(ctl_rx_check_sa_ppp),                        // input wire ctl_rx_check_sa_ppp
  .ctl_rx_check_ucast_gcp(ctl_rx_check_ucast_gcp),                  // input wire ctl_rx_check_ucast_gcp
  .ctl_rx_check_ucast_gpp(ctl_rx_check_ucast_gpp),                  // input wire ctl_rx_check_ucast_gpp
  .ctl_rx_check_ucast_pcp(ctl_rx_check_ucast_pcp),                  // input wire ctl_rx_check_ucast_pcp
  .ctl_rx_check_ucast_ppp(ctl_rx_check_ucast_ppp),                  // input wire ctl_rx_check_ucast_ppp
  .ctl_rx_enable_gcp(ctl_rx_enable_gcp),                            // input wire ctl_rx_enable_gcp
  .ctl_rx_enable_gpp(ctl_rx_enable_gpp),                            // input wire ctl_rx_enable_gpp
  .ctl_rx_enable_pcp(ctl_rx_enable_pcp),                            // input wire ctl_rx_enable_pcp
  .ctl_rx_enable_ppp(ctl_rx_enable_ppp),                            // input wire ctl_rx_enable_ppp
  .ctl_rx_pause_ack(ctl_rx_pause_ack),                              // input wire [8 : 0] ctl_rx_pause_ack
  .ctl_rx_pause_enable(ctl_rx_pause_enable),                        // input wire [8 : 0] ctl_rx_pause_enable
  .ctl_rx_enable(ctl_rx_enable),                                    // input wire ctl_rx_enable
  .ctl_rx_force_resync(ctl_rx_force_resync),                        // input wire ctl_rx_force_resync
  .ctl_rx_test_pattern(ctl_rx_test_pattern),                        // input wire ctl_rx_test_pattern
  .core_rx_reset(core_rx_reset),                                    // input wire core_rx_reset
  .rx_clk(rx_clk),                                                  // input wire rx_clk
  .stat_rx_received_local_fault(stat_rx_received_local_fault),
  .stat_rx_remote_fault(stat_rx_remote_fault),
  .stat_rx_status(stat_rx_status),
  .stat_rx_stomped_fcs(stat_rx_stomped_fcs),                        // output wire [2 : 0] stat_rx_stomped_fcs
  .stat_rx_synced(stat_rx_synced),                                  // output wire [19 : 0] stat_rx_synced
  .stat_rx_synced_err(stat_rx_synced_err),                          // output wire [19 : 0] stat_rx_synced_err
  .stat_rx_test_pattern_mismatch(stat_rx_test_pattern_mismatch),    // output wire [2 : 0] stat_rx_test_pattern_mismatch
  .stat_rx_total_bytes(stat_rx_total_bytes),                        // output wire [6 : 0] stat_rx_total_bytes
  .stat_rx_total_good_bytes(stat_rx_total_good_bytes),              // output wire [13 : 0] stat_rx_total_good_bytes
  .stat_rx_total_packets(stat_rx_total_packets),                    // output wire [2 : 0] stat_rx_total_packets
  .stat_rx_undersize(stat_rx_undersize),                            // output wire [2 : 0] stat_rx_undersize
  .stat_rx_pcsl_demuxed(stat_rx_pcsl_demuxed),                      // output wire [19 : 0] stat_rx_pcsl_demuxed
  .stat_rx_pcsl_number_0(stat_rx_pcsl_number_0),                    // output wire [4 : 0] stat_rx_pcsl_number_0
  .stat_rx_pcsl_number_1(stat_rx_pcsl_number_1),                    // output wire [4 : 0] stat_rx_pcsl_number_1
  .stat_rx_pcsl_number_10(stat_rx_pcsl_number_10),                  // output wire [4 : 0] stat_rx_pcsl_number_10
  .stat_rx_pcsl_number_11(stat_rx_pcsl_number_11),                  // output wire [4 : 0] stat_rx_pcsl_number_11
  .stat_rx_pcsl_number_12(stat_rx_pcsl_number_12),                  // output wire [4 : 0] stat_rx_pcsl_number_12
  .stat_rx_pcsl_number_13(stat_rx_pcsl_number_13),                  // output wire [4 : 0] stat_rx_pcsl_number_13
  .stat_rx_pcsl_number_14(stat_rx_pcsl_number_14),                  // output wire [4 : 0] stat_rx_pcsl_number_14
  .stat_rx_pcsl_number_15(stat_rx_pcsl_number_15),                  // output wire [4 : 0] stat_rx_pcsl_number_15
  .stat_rx_pcsl_number_16(stat_rx_pcsl_number_16),                  // output wire [4 : 0] stat_rx_pcsl_number_16
  .stat_rx_pcsl_number_17(stat_rx_pcsl_number_17),                  // output wire [4 : 0] stat_rx_pcsl_number_17
  .stat_rx_pcsl_number_18(stat_rx_pcsl_number_18),                  // output wire [4 : 0] stat_rx_pcsl_number_18
  .stat_rx_pcsl_number_19(stat_rx_pcsl_number_19),                  // output wire [4 : 0] stat_rx_pcsl_number_19
  .stat_rx_pcsl_number_2(stat_rx_pcsl_number_2),                    // output wire [4 : 0] stat_rx_pcsl_number_2
  .stat_rx_pcsl_number_3(stat_rx_pcsl_number_3),                    // output wire [4 : 0] stat_rx_pcsl_number_3
  .stat_rx_pcsl_number_4(stat_rx_pcsl_number_4),                    // output wire [4 : 0] stat_rx_pcsl_number_4
  .stat_rx_pcsl_number_5(stat_rx_pcsl_number_5),                    // output wire [4 : 0] stat_rx_pcsl_number_5
  .stat_rx_pcsl_number_6(stat_rx_pcsl_number_6),                    // output wire [4 : 0] stat_rx_pcsl_number_6
  .stat_rx_pcsl_number_7(stat_rx_pcsl_number_7),                    // output wire [4 : 0] stat_rx_pcsl_number_7
  .stat_rx_pcsl_number_8(stat_rx_pcsl_number_8),                    // output wire [4 : 0] stat_rx_pcsl_number_8
  .stat_rx_pcsl_number_9(stat_rx_pcsl_number_9),                    // output wire [4 : 0] stat_rx_pcsl_number_9
  .stat_tx_bad_fcs(stat_tx_bad_fcs),                                // output wire stat_tx_bad_fcs
  .stat_tx_broadcast(stat_tx_broadcast),                            // output wire stat_tx_broadcast
  .stat_tx_frame_error(stat_tx_frame_error),                        // output wire stat_tx_frame_error
  .stat_tx_local_fault(stat_tx_local_fault),                        // output wire stat_tx_local_fault
  .stat_tx_multicast(stat_tx_multicast),                            // output wire stat_tx_multicast
  .stat_tx_packet_1024_1518_bytes(stat_tx_packet_1024_1518_bytes),  // output wire stat_tx_packet_1024_1518_bytes
  .stat_tx_packet_128_255_bytes(stat_tx_packet_128_255_bytes),      // output wire stat_tx_packet_128_255_bytes
  .stat_tx_packet_1519_1522_bytes(stat_tx_packet_1519_1522_bytes),  // output wire stat_tx_packet_1519_1522_bytes
  .stat_tx_packet_1523_1548_bytes(stat_tx_packet_1523_1548_bytes),  // output wire stat_tx_packet_1523_1548_bytes
  .stat_tx_packet_1549_2047_bytes(stat_tx_packet_1549_2047_bytes),  // output wire stat_tx_packet_1549_2047_bytes
  .stat_tx_packet_2048_4095_bytes(stat_tx_packet_2048_4095_bytes),  // output wire stat_tx_packet_2048_4095_bytes
  .stat_tx_packet_256_511_bytes(stat_tx_packet_256_511_bytes),      // output wire stat_tx_packet_256_511_bytes
  .stat_tx_packet_4096_8191_bytes(stat_tx_packet_4096_8191_bytes),  // output wire stat_tx_packet_4096_8191_bytes
  .stat_tx_packet_512_1023_bytes(stat_tx_packet_512_1023_bytes),    // output wire stat_tx_packet_512_1023_bytes
  .stat_tx_packet_64_bytes(stat_tx_packet_64_bytes),                // output wire stat_tx_packet_64_bytes
  .stat_tx_packet_65_127_bytes(stat_tx_packet_65_127_bytes),        // output wire stat_tx_packet_65_127_bytes
  .stat_tx_packet_8192_9215_bytes(stat_tx_packet_8192_9215_bytes),  // output wire stat_tx_packet_8192_9215_bytes
  .stat_tx_packet_large(stat_tx_packet_large),                      // output wire stat_tx_packet_large
  .stat_tx_packet_small(stat_tx_packet_small),                      // output wire stat_tx_packet_small
  .stat_tx_total_bytes(stat_tx_total_bytes),                        // output wire [5 : 0] stat_tx_total_bytes
  .stat_tx_total_good_bytes(stat_tx_total_good_bytes),              // output wire [13 : 0] stat_tx_total_good_bytes
  .stat_tx_total_good_packets(stat_tx_total_good_packets),          // output wire stat_tx_total_good_packets
  .stat_tx_total_packets(stat_tx_total_packets),                    // output wire stat_tx_total_packets
  .stat_tx_unicast(stat_tx_unicast),                                // output wire stat_tx_unicast
  .stat_tx_vlan(stat_tx_vlan),                                      // output wire stat_tx_vlan
  .ctl_tx_enable(ctl_tx_enable),                                    // input wire ctl_tx_enable
  .ctl_tx_send_idle(ctl_tx_send_idle),                              // input wire ctl_tx_send_idle
  .ctl_tx_send_rfi(ctl_tx_send_rfi),                                // input wire ctl_tx_send_rfi
  .ctl_tx_send_lfi(ctl_tx_send_lfi),                                // input wire ctl_tx_send_lfi
  .ctl_tx_test_pattern(ctl_tx_test_pattern),                        // input wire ctl_tx_test_pattern
  .core_tx_reset(core_tx_reset),                                    // input wire core_tx_reset
  .stat_tx_pause_valid(stat_tx_pause_valid),                        // output wire [8 : 0] stat_tx_pause_valid
  .stat_tx_pause(stat_tx_pause),                                    // output wire stat_tx_pause
  .stat_tx_user_pause(stat_tx_user_pause),                          // output wire stat_tx_user_pause
  .ctl_tx_pause_enable(ctl_tx_pause_enable),                        // input wire [8 : 0] ctl_tx_pause_enable
  .ctl_tx_pause_quanta0(ctl_tx_pause_quanta0),                      // input wire [15 : 0] ctl_tx_pause_quanta0
  .ctl_tx_pause_quanta1(ctl_tx_pause_quanta1),                      // input wire [15 : 0] ctl_tx_pause_quanta1
  .ctl_tx_pause_quanta2(ctl_tx_pause_quanta2),                      // input wire [15 : 0] ctl_tx_pause_quanta2
  .ctl_tx_pause_quanta3(ctl_tx_pause_quanta3),                      // input wire [15 : 0] ctl_tx_pause_quanta3
  .ctl_tx_pause_quanta4(ctl_tx_pause_quanta4),                      // input wire [15 : 0] ctl_tx_pause_quanta4
  .ctl_tx_pause_quanta5(ctl_tx_pause_quanta5),                      // input wire [15 : 0] ctl_tx_pause_quanta5
  .ctl_tx_pause_quanta6(ctl_tx_pause_quanta6),                      // input wire [15 : 0] ctl_tx_pause_quanta6
  .ctl_tx_pause_quanta7(ctl_tx_pause_quanta7),                      // input wire [15 : 0] ctl_tx_pause_quanta7
  .ctl_tx_pause_quanta8(ctl_tx_pause_quanta8),                      // input wire [15 : 0] ctl_tx_pause_quanta8
  .ctl_tx_pause_refresh_timer0(ctl_tx_pause_refresh_timer0),        // input wire [15 : 0] ctl_tx_pause_refresh_timer0
  .ctl_tx_pause_refresh_timer1(ctl_tx_pause_refresh_timer1),        // input wire [15 : 0] ctl_tx_pause_refresh_timer1
  .ctl_tx_pause_refresh_timer2(ctl_tx_pause_refresh_timer2),        // input wire [15 : 0] ctl_tx_pause_refresh_timer2
  .ctl_tx_pause_refresh_timer3(ctl_tx_pause_refresh_timer3),        // input wire [15 : 0] ctl_tx_pause_refresh_timer3
  .ctl_tx_pause_refresh_timer4(ctl_tx_pause_refresh_timer4),        // input wire [15 : 0] ctl_tx_pause_refresh_timer4
  .ctl_tx_pause_refresh_timer5(ctl_tx_pause_refresh_timer5),        // input wire [15 : 0] ctl_tx_pause_refresh_timer5
  .ctl_tx_pause_refresh_timer6(ctl_tx_pause_refresh_timer6),        // input wire [15 : 0] ctl_tx_pause_refresh_timer6
  .ctl_tx_pause_refresh_timer7(ctl_tx_pause_refresh_timer7),        // input wire [15 : 0] ctl_tx_pause_refresh_timer7
  .ctl_tx_pause_refresh_timer8(ctl_tx_pause_refresh_timer8),        // input wire [15 : 0] ctl_tx_pause_refresh_timer8
  .ctl_tx_pause_req(ctl_tx_pause_req),                              // input wire [8 : 0] ctl_tx_pause_req
  .ctl_tx_resend_pause(ctl_tx_resend_pause),                        // input wire ctl_tx_resend_pause
  .tx_axis_tready(tx0_axis_tready),                                  // output wire tx_axis_tready
  .tx_axis_tvalid(tx0_axis_tvalid_q),                                  // input wire tx_axis_tvalid
  .tx_axis_tdata(tx0_axis_tdata),                                    // input wire [511 : 0] tx_axis_tdata
  .tx_axis_tlast(tx0_axis_tlast),                                    // input wire tx_axis_tlast
  .tx_axis_tkeep(tx0_axis_tkeep),                                    // input wire [63 : 0] tx_axis_tkeep
  .tx_axis_tuser(1'b0),                                    // input wire tx_axis_tuser
  .tx_ovfout(tx_ovfout),                                            // output wire tx_ovfout
  .tx_unfout(tx_unfout),                                            // output wire tx_unfout
  .tx_preamblein(tx_preamblein),                                    // input wire [55 : 0] tx_preamblein
  .usr_tx_reset(usr_tx_reset),                                      // output wire usr_tx_reset
  .core_drp_reset(core_drp_reset),                                  // input wire core_drp_reset                         
  .drp_clk(clk),                                                // input wire drp_clk
  .drp_addr(drp_addr),                                              // input wire [9 : 0] drp_addr
  .drp_di(drp_di),                                                  // input wire [15 : 0] drp_di
  .drp_en(drp_en),                                                  // input wire drp_en
  .drp_do(drp_do),                                                  // output wire [15 : 0] drp_do
  .drp_rdy(drp_rdy),                                                // output wire drp_rdy
  .drp_we(drp_we)                                                  // input wire drp_we                 
);
   
   assign {ctl_tx_test_pattern,ctl_tx_send_lfi,ctl_tx_send_rfi,ctl_tx_send_idle,ctl_tx_enable} = cmac_ctrl[20:16];
   

   assign { ctl_rx_check_mcast_ppp,ctl_rx_check_mcast_pcp,ctl_rx_check_mcast_gpp,ctl_rx_check_mcast_gcp,ctl_rx_check_etype_ppp, ctl_rx_check_etype_pcp, ctl_rx_check_etype_gpp, ctl_rx_check_etype_gcp} = cmac_ctrl[39:32];
   
   assign { ctl_rx_check_sa_gcp,ctl_rx_check_sa_gpp,ctl_rx_check_sa_pcp,ctl_rx_check_sa_ppp,ctl_rx_check_opcode_ppp,ctl_rx_check_opcode_pcp,ctl_rx_check_opcode_gpp,ctl_rx_check_opcode_gcp} = cmac_ctrl[47:40];

   assign { ctl_rx_enable_gcp,ctl_rx_enable_gpp,ctl_rx_enable_pcp,ctl_rx_enable_ppp,ctl_rx_check_ucast_gcp,ctl_rx_check_ucast_gpp,ctl_rx_check_ucast_pcp,ctl_rx_check_ucast_ppp } = cmac_ctrl[55:48];
   
   assign { ctl_rx_pause_ack, ctl_rx_pause_enable, ctl_rx_enable, ctl_rx_force_resync, ctl_rx_test_pattern} = cmac_ctrl[84:64];

   assign { ctl_tx_resend_pause,ctl_tx_pause_req,ctl_tx_pause_enable,ctl_tx_pause_refresh_timer8,ctl_tx_pause_refresh_timer7,ctl_tx_pause_refresh_timer6,ctl_tx_pause_refresh_timer5,ctl_tx_pause_refresh_timer4,ctl_tx_pause_refresh_timer3,ctl_tx_pause_refresh_timer2,ctl_tx_pause_refresh_timer1,ctl_tx_pause_refresh_timer0,ctl_tx_pause_quanta8,ctl_tx_pause_quanta7,ctl_tx_pause_quanta6,ctl_tx_pause_quanta5,ctl_tx_pause_quanta4,ctl_tx_pause_quanta3,ctl_tx_pause_quanta2,ctl_tx_pause_quanta1,ctl_tx_pause_quanta0} = cmac_ctrl[96+18*16+18:96];
   assign tx_preamblein = cmac_ctrl[503:448];
   assign cmac_status[31:0] = {stat_rx_received_local_fault,stat_rx_remote_fault,stat_rx_status,usr_tx_reset,usr_rx_reset,gt_powergoodout};  
   //assign cmac_status[63:32] = {rx_otn_bip8_4,rx_otn_bip8_3,rx_otn_bip8_2,rx_otn_bip8_1,rx_otn_bip8_0};
   //assign cmac_status[393:64] = {rx_otn_data_4,rx_otn_data_3,rx_otn_data_2,rx_otn_data_1,rx_otn_data_0};
   //assign cmac_status[471:416] = rx_preambleout;

   assign cmac_status[1023:32] = {stat_rx_bad_code,stat_rx_bad_fcs,stat_rx_block_lock,stat_rx_fragment,stat_rx_framing_err_19,stat_rx_framing_err_18,stat_rx_framing_err_17,stat_rx_framing_err_17,stat_rx_framing_err_16,stat_rx_framing_err_15,stat_rx_framing_err_14,stat_rx_framing_err_13,stat_rx_framing_err_12,stat_rx_framing_err_11,stat_rx_framing_err_10,stat_rx_framing_err_9,stat_rx_framing_err_8,stat_rx_framing_err_7,stat_rx_framing_err_6,stat_rx_framing_err_5,stat_rx_framing_err_4,stat_rx_framing_err_3,stat_rx_framing_err_2,stat_rx_framing_err_1,stat_rx_framing_err_0,stat_rx_mf_err,stat_rx_mf_len_err,stat_rx_mf_repeat_err,stat_rx_packet_small,stat_rx_pause,stat_rx_pause_quanta8,stat_rx_pause_quanta7,stat_rx_pause_quanta6,stat_rx_pause_quanta5,stat_rx_pause_quanta4,stat_rx_pause_quanta3,stat_rx_pause_quanta2,stat_rx_pause_quanta1,stat_rx_pause_quanta0,stat_rx_pause_req,stat_rx_pause_valid,stat_rx_user_pause, stat_rx_stomped_fcs, stat_rx_synced, stat_rx_synced_err, stat_rx_test_pattern_mismatch, stat_rx_total_bytes, stat_rx_total_good_bytes, stat_rx_total_packets, stat_rx_undersize, stat_rx_pcsl_demuxed, stat_rx_pcsl_number_19,stat_rx_pcsl_number_18,stat_rx_pcsl_number_17,stat_rx_pcsl_number_16,stat_rx_pcsl_number_15,stat_rx_pcsl_number_14,stat_rx_pcsl_number_13,stat_rx_pcsl_number_12,stat_rx_pcsl_number_11,stat_rx_pcsl_number_10,stat_rx_pcsl_number_9,stat_rx_pcsl_number_8,stat_rx_pcsl_number_7,stat_rx_pcsl_number_6,stat_rx_pcsl_number_5,stat_rx_pcsl_number_4,stat_rx_pcsl_number_3,stat_rx_pcsl_number_2,stat_rx_pcsl_number_1,stat_rx_pcsl_number_0,stat_tx_bad_fcs,stat_tx_broadcast,stat_tx_frame_error,stat_tx_local_fault,stat_tx_multicast, stat_tx_packet_1024_1518_bytes,stat_tx_packet_128_255_bytes,stat_tx_packet_1519_1522_bytes,stat_tx_packet_1523_1548_bytes,stat_tx_packet_1549_2047_bytes,stat_tx_packet_2048_4095_bytes,stat_tx_packet_256_511_bytes,stat_tx_packet_4096_8191_bytes,stat_tx_packet_512_1023_bytes,stat_tx_packet_64_bytes,stat_tx_packet_65_127_bytes,stat_tx_packet_8192_9215_bytes,stat_tx_packet_large,stat_tx_packet_small,stat_tx_total_bytes,stat_tx_total_good_bytes,stat_tx_total_good_packets,stat_tx_total_packets,stat_tx_unicast,stat_tx_vlan,stat_tx_pause_valid,stat_tx_pause,stat_tx_user_pause};

   
   

 //  assign rxp = qsfp_rxp[3:0];
   
 //  assign rxn = qsfp_rxn[3:0];

 //  assign qsfp_txn[3:0] = txn;
 //  assign qsfp_txp[3:0] = txp;
   
   assign gt_refclk1_n = qsfp_ckn[0];

   assign gt_refclk1_p = qsfp_ckp[0];

   
   //assign gt_refclk1_n = ~gt_refclk1_p;
   
   //always
  //   #3.1 gt_refclk1_p = ~gt_refclk1_p;
   
   always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
       ocr_count <=0;
       ocw_count <=0;
       dmt_count <=0;
       dmr_count <=0;
    end
    else begin
      if (m0_axi_mm2s_rvalid & m0_axi_mm2s_rready)
	ocr_count <= ocr_count+1;
       if (m0_axi_s2mm_wvalid & m0_axi_s2mm_wready)
	 ocw_count <= ocw_count+1;
       if (m0_axis_mm2s_tvalid & m0_axis_mm2s_tready)
	 dmt_count <= dmt_count+1;
       if (s0_axis_s2mm_tvalid & s0_axis_s2mm_tready)
	 dmr_count <= dmr_count+1;
       
       
       cmac_status_r1 <= cmac_status;
       cmac_status_r2 <= cmac_status_r1;
       
    end
end // always @ (posedge clk or negedge rst_n)

   always @(posedge user_clk or negedge rst_n) begin
    if (~rst_n) begin
       aut_count <=0;
      
       
       
    end
    else begin
       if (tx0_axis_tvalid_q & tx0_axis_tready_q)
	 aut_count <= aut_count+1;
   
       
       
    end
end 


    always @(posedge user_clk or negedge rst_n) begin
    if (~rst_n) begin
      
       aur_count <=0;
       
       
    end
    else begin
      
       if (rx0_axis_tvalid & rx0_axis_tready)
	 aur_count <= aur_count+1;
       
       
       
    end
end 

   
endmodule
