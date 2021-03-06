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
input                                          clk                  ,
input                                          rst_n                ,


//---- AXI bus interfaced with SNAP core ----
  // AXI write address channel
output    [C_M_AXI_HOST_MEM_ID_WIDTH - 1:0]     m_axi_snap_awid     ,
output    [C_M_AXI_HOST_MEM_ADDR_WIDTH - 1:0]   m_axi_snap_awaddr   ,
output    [0007:0]                              m_axi_snap_awlen    ,
output    [0002:0]                              m_axi_snap_awsize   ,
output    [0001:0]                              m_axi_snap_awburst  ,
output    [0003:0]                              m_axi_snap_awcache  ,
output    [0001:0]                              m_axi_snap_awlock   ,
output    [0002:0]                              m_axi_snap_awprot   ,
output    [0003:0]                              m_axi_snap_awqos    ,
output    [0003:0]                              m_axi_snap_awregion ,
output    [C_M_AXI_HOST_MEM_AWUSER_WIDTH - 1:0] m_axi_snap_awuser   ,
output                                          m_axi_snap_awvalid  ,
input                                           m_axi_snap_awready  ,
  // AXI write data channel
output    [C_M_AXI_HOST_MEM_DATA_WIDTH - 1:0]   m_axi_snap_wdata    ,
output    [(C_M_AXI_HOST_MEM_DATA_WIDTH/8) -1:0]m_axi_snap_wstrb    ,
output                                          m_axi_snap_wlast    ,
output                                          m_axi_snap_wvalid   ,
input                                           m_axi_snap_wready   ,
  // AXI write response channel
output                                          m_axi_snap_bready   ,
input     [C_M_AXI_HOST_MEM_ID_WIDTH - 1:0]     m_axi_snap_bid      ,
input     [0001:0]                              m_axi_snap_bresp    ,
input                                           m_axi_snap_bvalid   ,
  // AXI read address channel
output    [C_M_AXI_HOST_MEM_ID_WIDTH - 1:0]     m_axi_snap_arid     ,
output    [C_M_AXI_HOST_MEM_ADDR_WIDTH - 1:0]   m_axi_snap_araddr   ,
output    [0007:0]                              m_axi_snap_arlen    ,
output    [0002:0]                              m_axi_snap_arsize   ,
output    [0001:0]                              m_axi_snap_arburst  ,
output    [C_M_AXI_HOST_MEM_ARUSER_WIDTH - 1:0] m_axi_snap_aruser   ,
output    [0003:0]                              m_axi_snap_arcache  ,
output    [0001:0]                              m_axi_snap_arlock   ,
output    [0002:0]                              m_axi_snap_arprot   ,
output    [0003:0]                              m_axi_snap_arqos    ,
output    [0003:0]                              m_axi_snap_arregion ,
output                                          m_axi_snap_arvalid  ,
input                                           m_axi_snap_arready  ,
  // AXI  ead data channel
output                                          m_axi_snap_rready   ,
input     [C_M_AXI_HOST_MEM_ID_WIDTH - 1:0]     m_axi_snap_rid      ,
input     [C_M_AXI_HOST_MEM_DATA_WIDTH - 1:0]   m_axi_snap_rdata    ,
input     [0001:0]                              m_axi_snap_rresp    ,
input                                           m_axi_snap_rlast    ,
input                                           m_axi_snap_rvalid   ,


//---- AXI Lite bus interfaced with SNAP core ----
  // AXI write address channel
output                                          s_axi_snap_awready  ,
input     [C_S_AXI_CTRL_REG_ADDR_WIDTH - 1:0]   s_axi_snap_awaddr   ,
input                                           s_axi_snap_awvalid  ,
  // axi write data channel
output                                          s_axi_snap_wready   ,
input     [C_S_AXI_CTRL_REG_DATA_WIDTH - 1:0]   s_axi_snap_wdata    ,
input     [(C_S_AXI_CTRL_REG_DATA_WIDTH/8) -1:0]s_axi_snap_wstrb    ,
input                                           s_axi_snap_wvalid   ,
  // AXI response channel
output    [0001:0]                              s_axi_snap_bresp    ,
output                                          s_axi_snap_bvalid   ,
input                                           s_axi_snap_bready   ,
  // AXI read address channel
output                                          s_axi_snap_arready  ,
input                                           s_axi_snap_arvalid  ,
input     [C_S_AXI_CTRL_REG_ADDR_WIDTH - 1:0]   s_axi_snap_araddr   ,
  // AXI read data channel
output    [C_S_AXI_CTRL_REG_DATA_WIDTH - 1:0]   s_axi_snap_rdata    ,
output    [0001:0]                              s_axi_snap_rresp    ,
input                                           s_axi_snap_rready   ,
output                                          s_axi_snap_rvalid   ,

// Other signals
input      [31:0]                               i_action_type       ,
input      [31:0]                               i_action_version
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



  // Connect up TX and RX FIFOs to the data channels
  axis_data_fifo_data axis_tx_fifo (
  .s_axis_aresetn(rst_n),          // input wire s_axis_aresetn
  .s_axis_aclk(clk),                // input wire s_axis_aclk
  .s_axis_tvalid(m0_axis_mm2s_tvalid),            // input wire s_axis_tvalid
  .s_axis_tready(m0_axis_mm2s_tready),            // output wire s_axis_tready
  .s_axis_tdata(m0_axis_mm2s_tdata),              // input wire [255 : 0] s_axis_tdata
  .s_axis_tkeep(m0_axis_mm2s_tkeep),              // input wire [31 : 0] s_axis_tkeep
  .s_axis_tlast(m0_axis_mm2s_tlast),              // input wire s_axis_tlast
  .m_axis_tvalid(tx0_axis_tvalid),            // output wire m_axis_tvalid
  .m_axis_tready(tx0_axis_tready),            // input wire m_axis_tready
  .m_axis_tdata(tx0_axis_tdata),              // output wire [255 : 0] m_axis_tdata
  .m_axis_tkeep(tx0_axis_tkeep),              // output wire [31 : 0] m_axis_tkeep
  .m_axis_tlast(tx0_axis_tlast),              // output wire m_axis_tlast
  .axis_rd_data_count(tx0_rd_data_count)  // output wire [31 : 0] axis_rd_data_count
);

   axis_data_fifo_data axis_rx_fifo (
  .s_axis_aresetn(rst_n),          // input wire s_axis_aresetn
  .s_axis_aclk(clk),                // input wire s_axis_aclk
  .s_axis_tvalid(rx0_axis_tvalid),            // input wire s_axis_tvalid
  .s_axis_tready(rx0_axis_tready),            // output wire s_axis_tready
  .s_axis_tdata(rx0_axis_tdata),              // input wire [255 : 0] s_axis_tdata
  .s_axis_tkeep(rx0_axis_tkeep),              // input wire [31 : 0] s_axis_tkeep
  .s_axis_tlast(rx0_axis_tlast),              // input wire s_axis_tlast
  .m_axis_tvalid(s0_axis_s2mm_tvalid),            // output wire m_axis_tvalid
  .m_axis_tready(s0_axis_s2mm_tready),            // input wire m_axis_tready
  .m_axis_tdata(s0_axis_s2mm_tdata),              // output wire [255 : 0] m_axis_tdata
  .m_axis_tkeep(s0_axis_s2mm_tkeep),              // output wire [31 : 0] m_axis_tkeep
  .m_axis_tlast(s0_axis_s2mm_tlast),              // output wire m_axis_tlast
  .axis_rd_data_count(rx0_rd_data_count)  // output wire [31 : 0] axis_rd_data_count
);



   // Simply loop back TX to RX
   // Could add in an external connection IP or streaming accelerator IP in here


   assign rx0_axis_tdata = tx0_axis_tdata;
   assign tx0_axis_tready = rx0_axis_tready;
   assign rx0_axis_tvalid = tx0_axis_tvalid;
   assign rx0_axis_tkeep = tx0_axis_tkeep;
   assign rx0_axis_tlast = tx0_axis_tlast;
   

   
endmodule
