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

module axi_lite_slave #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
)(
                      input 			    clk ,
                      input 			    rst_n ,

                      //---- AXI Lite bus----
                        // AXI write address channel
                      output reg 		    s_axi_awready ,
                      input [ADDR_WIDTH - 1:0] 	    s_axi_awaddr ,
                      input 			    s_axi_awvalid ,
                        // axi write data channel
                      output reg 		    s_axi_wready ,
                      input [DATA_WIDTH - 1:0] 	    s_axi_wdata ,
                      input [(DATA_WIDTH/8) - 1:0]  s_axi_wstrb ,
                      input 			    s_axi_wvalid ,
                        // AXI response channel
                      output [01:0] 		    s_axi_bresp ,
                      output reg 		    s_axi_bvalid ,
                      input 			    s_axi_bready ,
                        // AXI read address channel
                      output reg 		    s_axi_arready ,
                      input 			    s_axi_arvalid ,
                      input [ADDR_WIDTH - 1:0] 	    s_axi_araddr ,
                        // AXI read data channel
                      output reg [DATA_WIDTH - 1:0] s_axi_rdata ,
                      output [01:0] 		    s_axi_rresp ,
                      input 			    s_axi_rready ,
                      output reg 		    s_axi_rvalid ,

                      //---- local control and status ----
		      input [31:0] 		    tx0_rd_data_count,
		      input [31:0] 		    rx0_rd_data_count,
   
		      output reg 		    tx0_cmd_tvalid,
		      input 			    tx0_cmd_tready,
		      output reg [103:0] 	    tx0_cmd_tdata,
		      input 			    tx0_cmd_prog_full, 
		      output reg 		    rx0_cmd_tvalid,
		      input 			    rx0_cmd_tready,
		      output reg [103:0] 	    rx0_cmd_tdata,
		      input 			    rx0_cmd_prog_full,

		      input 			    tx0_sts_tvalid,
		      output reg 		    tx0_sts_tready,
		      input [7:0] 		    tx0_sts_tdata,
		      input [0:0] 		    tx0_sts_tkeep,
		      input 			    tx0_sts_prog_full, 
		      input 			    rx0_sts_tvalid,
		      output reg 		    rx0_sts_tready,
		      input [31:0] 		    rx0_sts_tdata,
		      input [3:0] 		    rx0_sts_tkeep,
		      input 			    rx0_sts_prog_full,
                    
   input [1023:0] cmac_status,
   output [511:0] cmac_ctrl,
   input [31:0] cmac_drp_status,
   output [31:0] cmac_drp_ctrl,
   output        cmac_drp_en,
   output        cmac_drp_we,
                      //---- snap status ----
                      input [31:0] 		    i_action_type ,
                      input [31:0] 		    i_action_version ,
                      output [31:0] 		    o_snap_context
                      );
            

//---- declarations ----
 wire[31:0] REG_snap_control_rd;
 

 wire[31:0] regw_tx0_control;
 wire [31:0] regw_tx0_cmd0;
 wire [31:0] regw_tx0_cmd1;
 wire [31:0] regw_tx0_cmd2;
 wire [31:0] regw_tx0_cmd3;  
wire[31:0] regw_rx0_control;
 wire [31:0] regw_rx0_cmd0;
 wire [31:0] regw_rx0_cmd1;
 wire [31:0] regw_rx0_cmd2;
 wire [31:0] regw_rx0_cmd3;
    wire [511:0] regw_cmac0_ctrl;
    wire [31:0] regw_cmac0_drp_ctrl;  

 reg [31:0] write_address;
 wire[31:0] wr_mask;
 reg [31:0] current_cycle_L;
 reg [15:0] current_cycle_H;

   reg 	    drp_en_r1,drp_en_r2;
   reg      drp_we_r1,drp_we_r2;
   
   
 ///////////////////////////////////////////////////
 //***********************************************//
 //>                REGISTERS                    <//
 //***********************************************//
 //                                               //
 /**/   reg [31:0] REG_snap_control          ;  /**/
 /**/   reg [31:0] REG_snap_int_enable       ;  /**/
 /**/   reg [31:0] REG_snap_context          ;  /**/
 /*-----------------------------------------------*/
 /**/   reg [63:0] REG_error_info            ;  /*RO*/

 /**/   reg [31:0] REG_tx0_status          ;  /*RO*/
 /**/   reg [31:0] REG_tx0_control          ;  /*RW*/
 /**/   reg [127:0] REG_tx0_cmd             ;  /*RW*/
 /**/   reg [31:0] REG_tx0_status_data          ;  /*RO*/
 /**/   reg [31:0] REG_rx0_status          ;  /*RO*/
 /**/   reg [31:0] REG_rx0_control          ;  /*RW*/
 /**/   reg [127:0] REG_rx0_cmd             ;  /*RW*/
 /**/   reg [31:0] REG_rx0_status_data          ;  /*RO*/
 /**/   reg [1023:0] REG_cmac0_status          ;  /*RO*/
 /**/   reg [511:0] REG_cmac0_ctrl          ;  /*RW*/
 /**/   reg [31:0] REG_cmac0_drp_status          ;  /*RO*/
 /**/   reg [31:0] REG_cmac0_drp_ctrl          ;  /*RW*/
 //                                               //
 //-----------------------------------------------//
 //                                               //
 ///////////////////////////////////////////////////


//---- parameters ----
 // Register addresses arrangement
 parameter ADDR_SNAP_CONTROL        = 32'h00,
           ADDR_SNAP_INT_ENABLE     = 32'h04,
           ADDR_SNAP_ACTION_TYPE    = 32'h10,
           ADDR_SNAP_ACTION_VERSION = 32'h14,
           ADDR_SNAP_CONTEXT        = 32'h20,
           // User defined below
           ADDR_TX0_STATUS          = 32'h30,
           ADDR_TX0_CONTROL         = 32'h34,
           ADDR_TX0_CMD_DATA0       = 32'h38,
           ADDR_TX0_CMD_DATA1       = 32'h3C,
           ADDR_TX0_CMD_DATA2       = 32'h40,
           ADDR_TX0_CMD_DATA3       = 32'h44,
           ADDR_TX0_STS_DATA        = 32'h48,
           ADDR_TX0_DATA_COUNT      = 32'h4C,
   
           ADDR_RX0_STATUS          = 32'h50,
           ADDR_RX0_CONTROL         = 32'h54,
           ADDR_RX0_CMD_DATA0       = 32'h58,
           ADDR_RX0_CMD_DATA1       = 32'h5C,
           ADDR_RX0_CMD_DATA2       = 32'h60,
           ADDR_RX0_CMD_DATA3       = 32'h64,
           ADDR_RX0_STS_DATA        = 32'h68,
           ADDR_RX0_DATA_COUNT      = 32'h6C,

           
           ADDR_CMAC0_DRP_STATUS  = 32'h70,
           ADDR_CMAC0_DRP_CTRL    = 32'h74,
           
           ADDR_CMAC0_CTRL        = 32'h80,
   ADDR_CMAC0_STATUS      = 32'h100;
   
   
   

   reg [7:0] tx0_req_count;
   reg [7:0] rx0_req_count;
 

//---- local controlling signals assignments ----
 
 assign o_snap_context = REG_snap_context;


/***********************************************************************
*                          writing registers                           *
***********************************************************************/

//---- write address capture ----
 always@(posedge clk or negedge rst_n)
   if(~rst_n)
     write_address <= 32'd0;
   else if(s_axi_awvalid & s_axi_awready)
     write_address <= s_axi_awaddr;

//---- write address ready ----
 always@(posedge clk or negedge rst_n)
   if(~rst_n)
     s_axi_awready <= 1'b0;
   else if(s_axi_awvalid)
     s_axi_awready <= 1'b1;
   else if(s_axi_wvalid & s_axi_wready)
     s_axi_awready <= 1'b0;

//---- write data ready ----
 always@(posedge clk or negedge rst_n)
   if(~rst_n)
     s_axi_wready <= 1'b0;
   else if(s_axi_awvalid & s_axi_awready)
     s_axi_wready <= 1'b1;
   else if(s_axi_wvalid)
     s_axi_wready <= 1'b0;

//---- handle write data strobe ----
 assign wr_mask = {{8{s_axi_wstrb[3]}},{8{s_axi_wstrb[2]}},{8{s_axi_wstrb[1]}},{8{s_axi_wstrb[0]}}};

 assign regw_snap_status     = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_snap_control)};
 assign regw_snap_int_enable = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_snap_int_enable)};






 assign regw_snap_context    = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_snap_context)};
 assign regw_tx0_control         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_tx0_control)};
 assign regw_tx0_cmd0         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_tx0_cmd[31:0])};
 assign regw_tx0_cmd1         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_tx0_cmd[63:32])};
 assign regw_tx0_cmd2         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_tx0_cmd[95:64])};
 assign regw_tx0_cmd3         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_tx0_cmd[127:96])};
 assign regw_rx0_control         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_rx0_control)};
 assign regw_rx0_cmd0         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_rx0_cmd[31:0])};
 assign regw_rx0_cmd1         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_rx0_cmd[63:32])};
 assign regw_rx0_cmd2         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_rx0_cmd[95:64])};
 assign regw_rx0_cmd3         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_rx0_cmd[127:96])};
 assign regw_cmac0_ctrl[31:0]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[31:0])};
 assign regw_cmac0_ctrl[63:32]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[63:32])};
 assign regw_cmac0_ctrl[95:64]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[95:64])};
 assign regw_cmac0_ctrl[127:96]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[127:96])};
 assign regw_cmac0_ctrl[159:128]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[159:128])};
 assign regw_cmac0_ctrl[191:160]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[191:160])};
 assign regw_cmac0_ctrl[223:192]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[223:192])};
 assign regw_cmac0_ctrl[255:224]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[255:224])};
 assign regw_cmac0_ctrl[287:256]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[287:256])};
 assign regw_cmac0_ctrl[319:288]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[319:288])};
 assign regw_cmac0_ctrl[351:320]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[351:320])};
 assign regw_cmac0_ctrl[383:352]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[383:352])};
 assign regw_cmac0_ctrl[415:384]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[415:384])};
 assign regw_cmac0_ctrl[447:416]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[447:416])};
 assign regw_cmac0_ctrl[479:448]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[479:448])};
 assign regw_cmac0_ctrl[511:480]         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_ctrl[511:480])};
   
 assign regw_cmac0_drp_ctrl         = {(s_axi_wdata&wr_mask)|(~wr_mask&REG_cmac0_drp_ctrl)};

//---- write registers ----
 always@(posedge clk or negedge rst_n)
   if(~rst_n)
     begin
       REG_snap_control    <= 32'd0;
       REG_snap_int_enable <= 32'd0;
       REG_snap_context    <= 32'd0;
       REG_tx0_control    <= 32'd0;
       REG_tx0_cmd    <= 128'd0;
       REG_rx0_control    <= 32'd0;
       REG_rx0_cmd    <= 128'd0;
	REG_cmac0_ctrl <= 512'd0;
	REG_cmac0_drp_ctrl <= 32'd0;
	
       
     end
    else if(s_axi_wvalid & s_axi_wready)
     case(write_address)
       ADDR_SNAP_CONTROL    : REG_snap_control    <= regw_snap_status;
       ADDR_SNAP_INT_ENABLE : REG_snap_int_enable <= regw_snap_int_enable;
       ADDR_SNAP_CONTEXT    : REG_snap_context    <= regw_snap_context;

       ADDR_TX0_CONTROL    : REG_tx0_control    <= regw_tx0_control;
       ADDR_TX0_CMD_DATA0    : REG_tx0_cmd[31:0]    <= regw_tx0_cmd0;
       ADDR_TX0_CMD_DATA1    : REG_tx0_cmd[63:32]    <= regw_tx0_cmd1;
       ADDR_TX0_CMD_DATA2    : REG_tx0_cmd[95:64]    <= regw_tx0_cmd2;
       ADDR_TX0_CMD_DATA3    : REG_tx0_cmd[127:96]    <= regw_tx0_cmd3;

       ADDR_RX0_CONTROL    : REG_rx0_control    <= regw_rx0_control;
       ADDR_RX0_CMD_DATA0    : REG_rx0_cmd[31:0]    <= regw_rx0_cmd0;
       ADDR_RX0_CMD_DATA1    : REG_rx0_cmd[63:32]    <= regw_rx0_cmd1;
       ADDR_RX0_CMD_DATA2    : REG_rx0_cmd[95:64]    <= regw_rx0_cmd2;
       ADDR_RX0_CMD_DATA3    : REG_rx0_cmd[127:96]    <= regw_rx0_cmd3;

       ADDR_CMAC0_CTRL     : REG_cmac0_ctrl[31:0] <= regw_cmac0_ctrl[31:0];
       (ADDR_CMAC0_CTRL+4)     : REG_cmac0_ctrl[63:32] <= regw_cmac0_ctrl[63:32];
       (ADDR_CMAC0_CTRL+8)     : REG_cmac0_ctrl[95:64] <= regw_cmac0_ctrl[95:64];
       (ADDR_CMAC0_CTRL+12)     : REG_cmac0_ctrl[127:96] <= regw_cmac0_ctrl[127:96];
       (ADDR_CMAC0_CTRL+16)     : REG_cmac0_ctrl[159:128] <= regw_cmac0_ctrl[159:128];
       (ADDR_CMAC0_CTRL+20)     : REG_cmac0_ctrl[191:160] <= regw_cmac0_ctrl[191:160];
       (ADDR_CMAC0_CTRL+24)     : REG_cmac0_ctrl[223:192] <= regw_cmac0_ctrl[223:192];
       (ADDR_CMAC0_CTRL+28)     : REG_cmac0_ctrl[255:224] <= regw_cmac0_ctrl[255:224];
       (ADDR_CMAC0_CTRL+32)     : REG_cmac0_ctrl[287:256] <= regw_cmac0_ctrl[287:256];
       (ADDR_CMAC0_CTRL+36)     : REG_cmac0_ctrl[319:288] <= regw_cmac0_ctrl[319:288];
       (ADDR_CMAC0_CTRL+40)     : REG_cmac0_ctrl[351:320] <= regw_cmac0_ctrl[351:320];
       (ADDR_CMAC0_CTRL+44)     : REG_cmac0_ctrl[383:352] <= regw_cmac0_ctrl[383:352];
       (ADDR_CMAC0_CTRL+48)     : REG_cmac0_ctrl[415:384] <= regw_cmac0_ctrl[415:384];
       (ADDR_CMAC0_CTRL+52)     : REG_cmac0_ctrl[447:416] <= regw_cmac0_ctrl[351:320];
       (ADDR_CMAC0_CTRL+56)     : REG_cmac0_ctrl[479:448] <= regw_cmac0_ctrl[383:352];
       (ADDR_CMAC0_CTRL+60)     : REG_cmac0_ctrl[511:480] <= regw_cmac0_ctrl[415:384];
       
       
       ADDR_CMAC0_DRP_CTRL : REG_cmac0_drp_ctrl <= regw_cmac0_drp_ctrl;
       

       default :;
     endcase



wire snap_start_pulse;

reg snap_start_q;
reg snap_idle_q;



always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        snap_start_q <= 0;
        
    end
    else begin
        snap_start_q <= REG_snap_control[0];
       
    end
end

assign snap_start_pulse = REG_snap_control[0] & ~snap_start_q;


always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
       snap_idle_q <= 0;
    end
    else if ((tx0_req_count == 0) && (rx0_req_count == 0)) begin   //finish_dump
       snap_idle_q <= 1;
    end
    else begin
       snap_idle_q <= 0;
       
    end
   
end
 
assign REG_snap_control_rd = {REG_snap_control[31:4], 1'b1, snap_idle_q, 1'b0, snap_start_q};


/***********************************************************************
* FIFO Interface control                                               *
***********************************************************************/

   // TX0
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
       REG_tx0_status <= 0;
       REG_tx0_status_data <= 0;
       tx0_cmd_tvalid <= 1'b0;
       tx0_sts_tready <= 1'b1;  
       tx0_cmd_tdata <= 0;
       tx0_req_count <= 0;
       
       
    end
    else begin
       // COMMAND FIFO CONTROL
       // Bit 0, write to push command into FIFO
       if (REG_tx0_control[0] & ~REG_tx0_status[0]) begin
	 REG_tx0_status[0] <= 1'b1;
	 tx0_cmd_tvalid <= 1'b1; 
       end
       // Bit 0 must be cleared before next push
       if (~REG_tx0_control[0] & REG_tx0_status[0]) begin
	 REG_tx0_status[0] <= 1'b0;
       end 
       REG_tx0_status[1] <= tx0_cmd_tvalid;
       REG_tx0_status[2] <= tx0_cmd_tready;
       if (tx0_cmd_tvalid & tx0_cmd_tready)
	 tx0_cmd_tvalid <= 1'b0;
       REG_tx0_status[3] <= tx0_cmd_prog_full;
       tx0_cmd_tdata <= REG_tx0_cmd[103:0];

       // STATUS FIFO CONTROL
       if (tx0_sts_tready & tx0_sts_tvalid) begin
	  tx0_sts_tready <= 1'b0;
	  REG_tx0_status_data[7:0] <= tx0_sts_tdata; 
	  REG_tx0_status[9] <= 1'b1;
       end 
       // Bit 8, write to push command into FIFO
       if (REG_tx0_control[8] & ~REG_tx0_status[8]) begin
	 REG_tx0_status[8] <= 1'b1;
	 REG_tx0_status[9] <= 1'b0;
	 tx0_sts_tready <= 1'b1; 
       end
       // Bit 8 must be cleared before next push
       if (~REG_tx0_control[8] & REG_tx0_status[8]) begin
	 REG_tx0_status[8] <= 1'b0;
       end
       REG_tx0_status[11] <= tx0_sts_prog_full;

       if ((REG_tx0_control[0] & ~REG_tx0_status[0]) && ~(tx0_sts_tready & tx0_sts_tvalid)) begin
	  tx0_req_count <= tx0_req_count+1;
       end
       else if (~(REG_tx0_control[0] & ~REG_tx0_status[0]) && (tx0_sts_tready & tx0_sts_tvalid)) begin
          tx0_req_count <= tx0_req_count-1;
       end	  
       REG_tx0_status[23:16] <= tx0_req_count;
       
 
    end
end




   // RX0
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
       REG_rx0_status <= 0;
       REG_rx0_status_data <= 0;
       rx0_cmd_tvalid <= 1'b0;
       rx0_sts_tready <= 1'b1;  
       rx0_cmd_tdata <= 0;
       rx0_req_count <= 0;
   
    end
    else begin
       // COMMAND FIFO CONTROL
       // Bit 0, write to push command into FIFO
       if (REG_rx0_control[0] & ~REG_rx0_status[0]) begin
	 REG_rx0_status[0] <= 1'b1;
	 rx0_cmd_tvalid <= 1'b1; 
       end
       // Bit 0 must be cleared before next push
       if (~REG_rx0_control[0] & REG_rx0_status[0]) begin
	 REG_rx0_status[0] <= 1'b0;
       end 
       REG_rx0_status[1] <= rx0_cmd_tvalid;
       REG_rx0_status[2] <= rx0_cmd_tready;
       if (rx0_cmd_tvalid & rx0_cmd_tready)
	 rx0_cmd_tvalid <= 1'b0;
       REG_rx0_status[3] <= rx0_cmd_prog_full;
       rx0_cmd_tdata <= REG_rx0_cmd[103:0];

       // STATUS FIFO CONTROL
       if (rx0_sts_tready & rx0_sts_tvalid) begin
	  rx0_sts_tready <= 1'b0;
	  REG_rx0_status_data <= rx0_sts_tdata; 
	  REG_rx0_status[9] <= 1'b1;
       end 
       // Bit 8, write to push command into FIFO
       if (REG_rx0_control[8] & ~REG_rx0_status[8]) begin
	 REG_rx0_status[8] <= 1'b1;
	 REG_rx0_status[9] <= 1'b0;
	 rx0_sts_tready <= 1'b1; 
       end
       // Bit 8 must be cleared before next push
       if (~REG_rx0_control[8] & REG_rx0_status[8]) begin
	 REG_rx0_status[8] <= 1'b0;
       end
       REG_rx0_status[11] <= rx0_sts_prog_full;
       if ((REG_rx0_control[0] & ~REG_rx0_status[0]) && ~(rx0_sts_tready & rx0_sts_tvalid)) begin
	  rx0_req_count <= rx0_req_count+1;
       end
       else if (~(REG_rx0_control[0] & ~REG_rx0_status[0]) && (rx0_sts_tready & rx0_sts_tvalid)) begin
          rx0_req_count <= rx0_req_count-1;
       end	  
       REG_rx0_status[23:16] <= rx0_req_count;
 
    end
end // always @ (posedge clk or negedge rst_n)


always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
   
       REG_cmac0_status <= 0;
       REG_cmac0_drp_status <= 0;
       drp_en_r1 <= 1'b0;
       drp_en_r2 <= 1'b0;
       drp_we_r1 <= 1'b0;
       drp_we_r2 <= 1'b0;
       
       
       
    end
    else begin
       REG_cmac0_status <= cmac_status;
       REG_cmac0_drp_status <= cmac_drp_status;
       drp_en_r1 <= REG_cmac0_drp_ctrl[4];
       drp_en_r2 <= drp_en_r1;
       drp_we_r1 <= REG_cmac0_drp_ctrl[5];
       drp_we_r2 <= drp_we_r1;
       
       
    end
end // always @ (posedge clk or negedge rst_n)

   assign cmac_ctrl = REG_cmac0_ctrl;
   assign cmac_drp_ctrl = REG_cmac0_drp_ctrl;
   assign cmac_drp_en = drp_en_r1 & ~drp_en_r2;
   assign cmac_drp_we = drp_we_r1 & ~drp_we_r2;
   
   
   
//Address: 0x000
//  31..8  RO: Reserved
//      7  RW: auto restart
//   6..4  RO: Reserved
//      3  RO: Ready     (not used)
//      2  RO: Idle      (in use)
//      1  RC: Done      (not used)
//      0  RW: Start     (in use)
/***********************************************************************
*                       reading registers                              *
***********************************************************************/


//---- read registers ----
 always@(posedge clk or negedge rst_n)
   if(~rst_n)
     s_axi_rdata <= 32'd0;
   else if(s_axi_arvalid & s_axi_arready)
     case(s_axi_araddr)
       ADDR_SNAP_CONTROL        : s_axi_rdata <= REG_snap_control_rd;
       ADDR_SNAP_INT_ENABLE     : s_axi_rdata <= REG_snap_int_enable[31 : 0];
       ADDR_SNAP_ACTION_TYPE    : s_axi_rdata <= i_action_type;
       ADDR_SNAP_ACTION_VERSION : s_axi_rdata <= i_action_version;
       ADDR_SNAP_CONTEXT        : s_axi_rdata <= REG_snap_context[31    : 0];

       ADDR_TX0_STATUS          : s_axi_rdata <= REG_tx0_status;
       ADDR_TX0_CONTROL         : s_axi_rdata <= REG_tx0_control;
       ADDR_TX0_CMD_DATA0       : s_axi_rdata <= REG_tx0_cmd[31:0];
       ADDR_TX0_CMD_DATA1       : s_axi_rdata <= REG_tx0_cmd[31:0];
       ADDR_TX0_CMD_DATA2       : s_axi_rdata <= REG_tx0_cmd[31:0];
       ADDR_TX0_CMD_DATA3       : s_axi_rdata <= REG_tx0_cmd[31:0];
       ADDR_TX0_STS_DATA        : s_axi_rdata <= REG_tx0_status_data;
       ADDR_TX0_DATA_COUNT      : s_axi_rdata <= tx0_rd_data_count;
       ADDR_RX0_STATUS          : s_axi_rdata <= REG_rx0_status;
       ADDR_RX0_CONTROL         : s_axi_rdata <= REG_rx0_control;
       ADDR_RX0_CMD_DATA0       : s_axi_rdata <= REG_rx0_cmd[31:0];
       ADDR_RX0_CMD_DATA1       : s_axi_rdata <= REG_rx0_cmd[31:0];
       ADDR_RX0_CMD_DATA2       : s_axi_rdata <= REG_rx0_cmd[31:0];
       ADDR_RX0_CMD_DATA3       : s_axi_rdata <= REG_rx0_cmd[31:0];
       ADDR_RX0_STS_DATA        : s_axi_rdata <= REG_rx0_status_data;
       ADDR_RX0_DATA_COUNT      : s_axi_rdata <= rx0_rd_data_count;
       
       ADDR_CMAC0_DRP_STATUS          : s_axi_rdata <= REG_cmac0_drp_status;
       ADDR_CMAC0_DRP_CTRL         : s_axi_rdata <= REG_cmac0_drp_ctrl;
       ADDR_CMAC0_CTRL         : s_axi_rdata <= REG_cmac0_ctrl[31:0];
       (ADDR_CMAC0_CTRL+4)         : s_axi_rdata <= REG_cmac0_ctrl[63:32];
       (ADDR_CMAC0_CTRL+8)         : s_axi_rdata <= REG_cmac0_ctrl[95:64];
       (ADDR_CMAC0_CTRL+12)         : s_axi_rdata <= REG_cmac0_ctrl[127:96];
       (ADDR_CMAC0_CTRL+16)         : s_axi_rdata <= REG_cmac0_ctrl[159:128];
       (ADDR_CMAC0_CTRL+20)         : s_axi_rdata <= REG_cmac0_ctrl[191:160];
       (ADDR_CMAC0_CTRL+24)         : s_axi_rdata <= REG_cmac0_ctrl[223:192];
       (ADDR_CMAC0_CTRL+28)         : s_axi_rdata <= REG_cmac0_ctrl[255:224];
       (ADDR_CMAC0_CTRL+32)         : s_axi_rdata <= REG_cmac0_ctrl[287:256];
       (ADDR_CMAC0_CTRL+36)         : s_axi_rdata <= REG_cmac0_ctrl[319:288];
       (ADDR_CMAC0_CTRL+40)         : s_axi_rdata <= REG_cmac0_ctrl[351:320];
       (ADDR_CMAC0_CTRL+44)         : s_axi_rdata <= REG_cmac0_ctrl[383:352];
       (ADDR_CMAC0_CTRL+48)         : s_axi_rdata <= REG_cmac0_ctrl[415:384];
       (ADDR_CMAC0_CTRL+52)         : s_axi_rdata <= REG_cmac0_ctrl[447:416];
       (ADDR_CMAC0_CTRL+56)         : s_axi_rdata <= REG_cmac0_ctrl[479:448];
       (ADDR_CMAC0_CTRL+60)         : s_axi_rdata <= REG_cmac0_ctrl[511:480];
       
       ADDR_CMAC0_STATUS          : s_axi_rdata <= REG_cmac0_status[31:0];
       (ADDR_CMAC0_STATUS+4)         : s_axi_rdata <= REG_cmac0_status[63:32];
       (ADDR_CMAC0_STATUS+8)         : s_axi_rdata <= REG_cmac0_status[95:64];
       (ADDR_CMAC0_STATUS+12)         : s_axi_rdata <= REG_cmac0_status[127:96];
       (ADDR_CMAC0_STATUS+16)         : s_axi_rdata <= REG_cmac0_status[159:128];
       (ADDR_CMAC0_STATUS+20)         : s_axi_rdata <= REG_cmac0_status[191:160];
       (ADDR_CMAC0_STATUS+24)         : s_axi_rdata <= REG_cmac0_status[223:192];
       (ADDR_CMAC0_STATUS+28)         : s_axi_rdata <= REG_cmac0_status[255:224];
       (ADDR_CMAC0_STATUS+32)         : s_axi_rdata <= REG_cmac0_status[287:256];
       (ADDR_CMAC0_STATUS+36)         : s_axi_rdata <= REG_cmac0_status[319:288];
       (ADDR_CMAC0_STATUS+40)         : s_axi_rdata <= REG_cmac0_status[351:320];
       (ADDR_CMAC0_STATUS+44)         : s_axi_rdata <= REG_cmac0_status[383:352];
       (ADDR_CMAC0_STATUS+48)         : s_axi_rdata <= REG_cmac0_status[415:384];
       (ADDR_CMAC0_STATUS+52)         : s_axi_rdata <= REG_cmac0_status[447:416];
       (ADDR_CMAC0_STATUS+56)         : s_axi_rdata <= REG_cmac0_status[479:448];
       (ADDR_CMAC0_STATUS+60)         : s_axi_rdata <= REG_cmac0_status[511:480];
       (ADDR_CMAC0_STATUS+64)          : s_axi_rdata <= REG_cmac0_status[543:512];
       (ADDR_CMAC0_STATUS+68)         : s_axi_rdata <= REG_cmac0_status[575:544];
       (ADDR_CMAC0_STATUS+72)         : s_axi_rdata <= REG_cmac0_status[607:576];
       (ADDR_CMAC0_STATUS+76)         : s_axi_rdata <= REG_cmac0_status[639:608];
       (ADDR_CMAC0_STATUS+80)         : s_axi_rdata <= REG_cmac0_status[671:640];
       (ADDR_CMAC0_STATUS+84)         : s_axi_rdata <= REG_cmac0_status[703:672];
       (ADDR_CMAC0_STATUS+88)         : s_axi_rdata <= REG_cmac0_status[735:704];
       (ADDR_CMAC0_STATUS+92)         : s_axi_rdata <= REG_cmac0_status[767:736];
       (ADDR_CMAC0_STATUS+96)         : s_axi_rdata <= REG_cmac0_status[799:768];
       (ADDR_CMAC0_STATUS+100)         : s_axi_rdata <= REG_cmac0_status[831:800];
       (ADDR_CMAC0_STATUS+104)         : s_axi_rdata <= REG_cmac0_status[863:832];
       (ADDR_CMAC0_STATUS+108)         : s_axi_rdata <= REG_cmac0_status[895:864];
       (ADDR_CMAC0_STATUS+112)         : s_axi_rdata <= REG_cmac0_status[927:896];
       (ADDR_CMAC0_STATUS+116)         : s_axi_rdata <= REG_cmac0_status[959:928];
       (ADDR_CMAC0_STATUS+120)         : s_axi_rdata <= REG_cmac0_status[991:960];
       (ADDR_CMAC0_STATUS+124)         : s_axi_rdata <= REG_cmac0_status[1023:992];
       
       default                  : s_axi_rdata <= 32'h5a5aa5a5;
     endcase

//---- address ready: deasserts once arvalid is seen; reasserts when current read is done ----
 always@(posedge clk or negedge rst_n)
   if(~rst_n)
     s_axi_arready <= 1'b1;
   else if(s_axi_arvalid)
     s_axi_arready <= 1'b0;
   else if(s_axi_rvalid & s_axi_rready)
     s_axi_arready <= 1'b1;

//---- data ready: deasserts once rvalid is seen; reasserts when new address has come ----
 always@(posedge clk or negedge rst_n)
   if(~rst_n)
     s_axi_rvalid <= 1'b0;
   else if (s_axi_arvalid & s_axi_arready)
     s_axi_rvalid <= 1'b1;
   else if (s_axi_rready)
     s_axi_rvalid <= 1'b0;




/***********************************************************************
*                        status reporting                              *
***********************************************************************/

//---- axi write response ----
 always@(posedge clk or negedge rst_n)
   if(~rst_n) 
     s_axi_bvalid <= 1'b0;
   else if(s_axi_wvalid & s_axi_wready)
     s_axi_bvalid <= 1'b1;
   else if(s_axi_bready)
     s_axi_bvalid <= 1'b0;

 assign s_axi_bresp = 2'd0;

//---- axi read response ----
 assign s_axi_rresp = 2'd0;



endmodule

