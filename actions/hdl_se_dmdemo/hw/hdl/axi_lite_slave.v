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

 reg [31:0] write_address;
 wire[31:0] wr_mask;
 reg [31:0] current_cycle_L;
 reg [15:0] current_cycle_H;

 
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
           ADDR_RX0_DATA_COUNT      = 32'h6C;
   
   
   

 

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

       default :;
     endcase

/***********************************************************************
*                          Control Flow                                *
***********************************************************************/
// The build-in snap_action_start() and snap_action_completed functions 
// sets REG_snap_control bit "start" and reads bit "idle"
// The other things are managed by REG_user_control (user defined control register)
// Flow:
// ---------------------------------------------------------------------------------------------
// Software                                  Hardware REG                               Hardware signal & action
// ---------------------------------------------------------------------------------------------
// snap_action_start()                      |                                          |
//                                          | SNAP_CONTROL[snap_start]=1               |
// mmio_write(USER_CONTROL[address...])     |                                          | snap_start_pulse
// mmio_write(USER_CONTROL[pattern...])     |                                          | Spend 4096 cycles to clear tt_RAM
// mmio_write(USER_CONTROL[number...])      |                                          |
// wait(USER_CONTROL[engine_ready])==1      |                                          |
//                                          | USER_STATUS[engine_ready]=1              |
// mmio_write(USER_CONTROL[engine_start])=1 |                                          |
//                                          | CONTROL[engine_start]=1                  |
//                                          |                                          | engine_start_pulse
//                                          |                                          | Run Read requests and Write requests
//                                          |                                          | .
//                                          |                                          | .
//                                          |                                          | .
//                                          |                                          | rd_done or wr_done or rd_error
//                                          | USER_STATUS[rd_done/wr_done/rd_error]= 1 |
// wait(USER_STATUS)                        |                                          |
// Send 4096 MMIO reads for TT ...          |                                          |
// mmio_write(USER_CONTROL[finish_dump])=1  |                                          |
//                                          | USER_CONTROL[finish_dump]=1              |
//                                          | SNAP_CONTROL[snap_idle]=1                |
// snap_action_completed()                  |                                          |
//

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
    else if (1'b1) begin   //finish_dump
       snap_idle_q <= 1;
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
       
 
    end
end

   
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

