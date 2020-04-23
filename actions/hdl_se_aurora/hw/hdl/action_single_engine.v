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
   wire [255:0]  m0_axis_mm2s_tdata;
   wire [31:0] 	 m0_axis_mm2s_tkeep;
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
   wire [255:0]  s0_axis_s2mm_tdata;
   wire [31:0] 	 s0_axis_s2mm_tkeep;
   wire 	 s0_axis_s2mm_tlast;
   wire 	 s0_axis_s2mm_tvalid;
   wire 	 s0_axis_s2mm_tready;
   
   wire [3:0] 	m0_axi_s2mm_awregion = 4'b0;
   wire [3:0] 	m0_axi_mm2s_arregion = 4'b0;
   wire [1:0] 	m0_axi_s2mm_awlock = 2'b0;
   wire [1:0] 	m0_axi_mm2s_arlock = 2'b0;
   wire [3:0] 	m0_axi_s2mm_awqos = 4'b0;
   wire [3:0] 	m0_axi_mm2s_arqos = 4'b0;

   wire [255:0]  tx0_axis_tdata;
   wire [31:0] 	 tx0_axis_tkeep;
   wire 	 tx0_axis_tlast;
   wire 	 tx0_axis_tvalid;
   wire 	 tx0_axis_tready;
   wire [255:0]  rx0_axis_tdata;
   wire [31:0] 	 rx0_axis_tkeep;
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


   
wire reset_pb;
wire power_down;
wire pma_init;
wire [2 : 0] loopback;
 wire [0 : 3] txp;
 wire [0 : 3] txn;
 wire hard_err;
 wire soft_err;
 wire channel_up;
 wire [0 : 3] lane_up;
 wire tx_out_clk;
 wire gt_pll_lock;

 wire mmcm_not_locked_out;
wire [9 : 0] gt0_drpaddr;
wire [9 : 0] gt1_drpaddr;
wire [9 : 0] gt2_drpaddr;
wire [9 : 0] gt3_drpaddr;
wire [15 : 0] gt0_drpdi;
wire [15 : 0] gt1_drpdi;
wire [15 : 0] gt2_drpdi;
wire [15 : 0] gt3_drpdi;
 wire gt0_drprdy;
 wire gt1_drprdy;
 wire gt2_drprdy;
 wire gt3_drprdy;
wire gt0_drpwe;
wire gt1_drpwe;
wire gt2_drpwe;
wire gt3_drpwe;
wire gt0_drpen;
wire gt1_drpen;
wire gt2_drpen;
wire gt3_drpen;
 wire [15 : 0] gt0_drpdo;
 wire [15 : 0] gt1_drpdo;
 wire [15 : 0] gt2_drpdo;
 wire [15 : 0] gt3_drpdo;

   wire link_reset_out;	     
  wire gt_refclk1_p;
   wire gt_refclk1_n;	      
 wire user_clk_out;
 wire sync_clk_out;
 wire gt_qpllclk_quad1_out;
 wire gt_qpllrefclk_quad1_out;
 wire gt_qpllrefclklost_quad1_out;
 wire gt_qplllock_quad1_out;
wire gt_rxcdrovrden_in=0;
 wire sys_reset_out;
 wire gt_reset_out;
 wire gt_refclk1_out;
 wire [3 : 0] gt_powergood;

   wire [31:0] aurora_status;
   wire [31:0] aurora_ctrl;
   wire [31:0] aurora_drp_status;
   wire [31:0] aurora_drp_ctrl;
   wire        aurora_drp_en;
   wire        aurora_drp_we;

   reg [15:0]  ocr_count=0;
   reg [15:0]  ocw_count=0;
   reg [15:0]  dmt_count=0;
   reg [15:0]  dmr_count=0;
   reg [15:0]  aut_count=0;
   reg [15:0]  aur_count=0;
   
   
   
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
.aurora_status(aurora_status),
.aurora_ctrl(aurora_ctrl),
.aurora_drp_status(aurora_drp_status),
.aurora_drp_ctrl(aurora_drp_ctrl),
.aurora_drp_en(aurora_drp_en),
.aurora_drp_we(aurora_drp_we),
		    
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
   assign user_clk = user_clk_out;

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
  .m_axis_tready(tx0_axis_tready),            // input wire m_axis_tready
  .m_axis_tdata(tx0_axis_tdata),              // output wire [255 : 0] m_axis_tdata
  .m_axis_tkeep(tx0_axis_tkeep),              // output wire [31 : 0] m_axis_tkeep
  .m_axis_tlast(tx0_axis_tlast),              // output wire m_axis_tlast
  .axis_rd_data_count(tx0_rd_data_count)  // output wire [31 : 0] axis_rd_data_count
);

  
 
   
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




   assign reset_pb = ~rst_n | aurora_ctrl[0];
   assign power_down = aurora_ctrl[1];
   assign pma_init = aurora_ctrl[2];
   assign loopback = aurora_ctrl[5:3];

   assign aurora_status = {gt_powergood,gt_reset_out,sys_reset_out,link_reset_out,mmcm_not_locked_out,lane_up[3],lane_up[2],lane_up[1],lane_up[0],gt_pll_lock,channel_up,soft_err,hard_err};
   assign gt0_drpaddr = aurora_drp_ctrl[15:6];
   assign gt1_drpaddr = aurora_drp_ctrl[15:6];
   assign gt2_drpaddr = aurora_drp_ctrl[15:6];
   assign gt3_drpaddr = aurora_drp_ctrl[15:6];
   assign gt0_drpdi = aurora_drp_ctrl[31:16];
   assign gt1_drpdi = aurora_drp_ctrl[31:16];
   assign gt2_drpdi = aurora_drp_ctrl[31:16];
   assign gt3_drpdi = aurora_drp_ctrl[31:16];
   assign gt0_drpwe = aurora_drp_we & aurora_drp_ctrl[0];
   assign gt1_drpwe = aurora_drp_we & aurora_drp_ctrl[1];
   assign gt2_drpwe = aurora_drp_we & aurora_drp_ctrl[2];
   assign gt3_drpwe = aurora_drp_we & aurora_drp_ctrl[3];
   assign gt0_drpen = aurora_drp_en & aurora_drp_ctrl[0];
   assign gt1_drpen = aurora_drp_en & aurora_drp_ctrl[1];
   assign gt2_drpen = aurora_drp_en & aurora_drp_ctrl[2];
   assign gt3_drpen = aurora_drp_en & aurora_drp_ctrl[3];
   assign aurora_drp_status = (aurora_drp_ctrl[0]) ? {gt0_drprdy,gt0_drpdo} : (aurora_drp_ctrl[1]) ? {gt1_drprdy,gt1_drpdo} :(aurora_drp_ctrl[2]) ? {gt2_drprdy,gt2_drpdo} : {gt3_drprdy,gt3_drpdo};
 
   
   aurora_64b66b_1 aurora_core0 (
  .rxp(rxp),                                                  // input wire [0 : 3] rxp
  .rxn(rxn),                                                  // input wire [0 : 3] rxn
  .reset_pb(reset_pb),                                        // input wire reset_pb
  .power_down(power_down),                                    // input wire power_down
  .pma_init(pma_init),                                        // input wire pma_init
  .loopback(loopback),                                        // input wire [2 : 0] loopback
  .txp(txp),                                                  // output wire [0 : 3] txp
  .txn(txn),                                                  // output wire [0 : 3] txn
  .hard_err(hard_err),                                        // output wire hard_err
  .soft_err(soft_err),                                        // output wire soft_err
  .channel_up(channel_up),                                    // output wire channel_up
  .lane_up(lane_up),                                          // output wire [0 : 3] lane_up
  .tx_out_clk(tx_out_clk),                                    // output wire tx_out_clk
  .gt_pll_lock(gt_pll_lock),                                  // output wire gt_pll_lock
  .s_axi_tx_tdata(tx0_axis_tdata),                            // input wire [0 : 255] s_axi_tx_tdata
  .s_axi_tx_tkeep(tx0_axis_tkeep),                            // input wire [0 : 31] s_axi_tx_tkeep
  .s_axi_tx_tlast(tx0_axis_tlast),                            // input wire s_axi_tx_tlast
  .s_axi_tx_tvalid(tx0_axis_tvalid),                          // input wire s_axi_tx_tvalid
  .s_axi_tx_tready(tx0_axis_tready),                          // output wire s_axi_tx_tready
  .m_axi_rx_tdata(rx0_axis_tdata),                            // output wire [0 : 255] m_axi_rx_tdata
  .m_axi_rx_tkeep(rx0_axis_tkeep),                            // output wire [0 : 31] m_axi_rx_tkeep
  .m_axi_rx_tlast(rx0_axis_tlast),                            // output wire m_axi_rx_tlast
  .m_axi_rx_tvalid(rx0_axis_tvalid),                          // output wire m_axi_rx_tvalid
  .mmcm_not_locked_out(mmcm_not_locked_out),                  // output wire mmcm_not_locked_out
  .gt0_drpaddr(gt0_drpaddr),                                  // input wire [9 : 0] gt0_drpaddr
  .gt1_drpaddr(gt1_drpaddr),                                  // input wire [9 : 0] gt1_drpaddr
  .gt2_drpaddr(gt2_drpaddr),                                  // input wire [9 : 0] gt2_drpaddr
  .gt3_drpaddr(gt3_drpaddr),                                  // input wire [9 : 0] gt3_drpaddr
  .gt0_drpdi(gt0_drpdi),                                      // input wire [15 : 0] gt0_drpdi
  .gt1_drpdi(gt1_drpdi),                                      // input wire [15 : 0] gt1_drpdi
  .gt2_drpdi(gt2_drpdi),                                      // input wire [15 : 0] gt2_drpdi
  .gt3_drpdi(gt3_drpdi),                                      // input wire [15 : 0] gt3_drpdi
  .gt0_drprdy(gt0_drprdy),                                    // output wire gt0_drprdy
  .gt1_drprdy(gt1_drprdy),                                    // output wire gt1_drprdy
  .gt2_drprdy(gt2_drprdy),                                    // output wire gt2_drprdy
  .gt3_drprdy(gt3_drprdy),                                    // output wire gt3_drprdy
  .gt0_drpwe(gt0_drpwe),                                      // input wire gt0_drpwe
  .gt1_drpwe(gt1_drpwe),                                      // input wire gt1_drpwe
  .gt2_drpwe(gt2_drpwe),                                      // input wire gt2_drpwe
  .gt3_drpwe(gt3_drpwe),                                      // input wire gt3_drpwe
  .gt0_drpen(gt0_drpen),                                      // input wire gt0_drpen
  .gt1_drpen(gt1_drpen),                                      // input wire gt1_drpen
  .gt2_drpen(gt2_drpen),                                      // input wire gt2_drpen
  .gt3_drpen(gt3_drpen),                                      // input wire gt3_drpen
  .gt0_drpdo(gt0_drpdo),                                      // output wire [15 : 0] gt0_drpdo
  .gt1_drpdo(gt1_drpdo),                                      // output wire [15 : 0] gt1_drpdo
  .gt2_drpdo(gt2_drpdo),                                      // output wire [15 : 0] gt2_drpdo
  .gt3_drpdo(gt3_drpdo),                                      // output wire [15 : 0] gt3_drpdo
  .init_clk(clk),                                        // input wire init_clk
  .link_reset_out(link_reset_out),                            // output wire link_reset_out
  .gt_refclk1_p(gt_refclk1_p),                                // input wire gt_refclk1_p
  .gt_refclk1_n(gt_refclk1_n),                                // input wire gt_refclk1_n
  .user_clk_out(user_clk_out),                                // output wire user_clk_out
  .sync_clk_out(sync_clk_out),                                // output wire sync_clk_out
  .gt_qpllclk_quad1_out(gt_qpllclk_quad1_out),                // output wire gt_qpllclk_quad1_out
  .gt_qpllrefclk_quad1_out(gt_qpllrefclk_quad1_out),          // output wire gt_qpllrefclk_quad1_out
  .gt_qpllrefclklost_quad1_out(gt_qpllrefclklost_quad1_out),  // output wire gt_qpllrefclklost_quad1_out
  .gt_qplllock_quad1_out(gt_qplllock_quad1_out),              // output wire gt_qplllock_quad1_out
  .gt_rxcdrovrden_in(gt_rxcdrovrden_in),                      // input wire gt_rxcdrovrden_in
  .sys_reset_out(sys_reset_out),                              // output wire sys_reset_out
  .gt_reset_out(gt_reset_out),                                // output wire gt_reset_out
  .gt_refclk1_out(gt_refclk1_out),                            // output wire gt_refclk1_out
  .gt_powergood(gt_powergood)                                // output wire [3 : 0] gt_powergood
);



   

   assign rxp = qsfp_rxp[3:0];
   
   assign rxn = qsfp_rxn[3:0];

   assign qsfp_txn[3:0] = txn;
   assign qsfp_txp[3:0] = txp;
   
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
       
       
       
    end
end // always @ (posedge clk or negedge rst_n)

   always @(posedge user_clk or negedge rst_n) begin
    if (~rst_n) begin
       aut_count <=0;
      
       
       
    end
    else begin
       if (tx0_axis_tvalid & tx0_axis_tready)
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
