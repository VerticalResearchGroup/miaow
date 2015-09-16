// module lsu_wb_router 
// (/*AUTOARG*/
//    // Outputs
//    out_sgpr_dest_addr, out_sgpr_dest_data, out_sgpr_dest_wr_en_mod,
//    out_sgpr_instr_done, out_sgpr_instr_done_wfid, out_vgpr_dest_addr,
//    out_vgpr_dest_data, out_vgpr_dest_wr_en_mod, out_vgpr_dest_wr_mask,
//    out_vgpr_instr_done, out_vgpr_instr_done_wfid,
//    out_tracemon_retire_pc, out_gm_or_lds, out_rfa_dest_wr_req,
//    wb_ack,
//    // Inputs
//    in_rd_data, in_wftag_resp, in_ack, in_exec_value,
//    in_lddst_stsrc_addr, in_reg_wr_en, in_instr_pc, in_gm_or_lds,
//    clk, rst, increAddr, wb_en
//    );

// parameter MEM_BUS_WIDTH = 32;
// // SX
// // change the memory data in bus-width to
// // new memory bus width.
// //input [8191:0] in_rd_data;
// input [2047:0] in_rd_data;

// input [6:0] in_wftag_resp;
// input in_ack;
// input [63:0] in_exec_value;
// input [11:0] in_lddst_stsrc_addr;
// input [3:0] in_reg_wr_en;
// input [31:0] in_instr_pc;
// input in_gm_or_lds;
// input [1:0] increAddr;
// input clk,rst;
// input wb_en;

// output [8:0] out_sgpr_dest_addr;
// output [127:0] out_sgpr_dest_data;
// output [3:0] out_sgpr_dest_wr_en_mod;
// output out_sgpr_instr_done;
// output [5:0] out_sgpr_instr_done_wfid;

// output [9:0] out_vgpr_dest_addr;
// // SX
// // change the 8k output bus to VGPR
// // to 2k due to the change made in
// // VGPR bank configuration.
// // output [8191:0] out_vgpr_dest_data;
// output [2047:0] out_vgpr_dest_data;

// output out_vgpr_dest_wr_en_mod;
// output [63:0] out_vgpr_dest_wr_mask;
// output out_vgpr_instr_done;
// output [5:0] out_vgpr_instr_done_wfid;

// output [31:0] out_tracemon_retire_pc;
// output out_gm_or_lds;
// output    out_rfa_dest_wr_req;
// reg [3:0] out_sgpr_dest_wr_en;
// reg [3:0] out_vgpr_dest_wr_en;
// output reg wb_ack;
// assign out_sgpr_dest_wr_en_mod = out_sgpr_dest_wr_en & {4{wb_en}};
// assign out_vgpr_dest_wr_en_mod = out_vgpr_dest_wr_en & {4{wb_en}};

   
// reg out_sgpr_instr_done;
// reg out_vgpr_instr_done;

// assign out_sgpr_dest_addr = in_lddst_stsrc_addr[8:0]+increAddr;
// //reg out_sgpr_dest_addr;

// assign out_sgpr_dest_data = in_rd_data[127:0];
// assign out_sgpr_instr_done_wfid = in_wftag_resp[6:1];

// // SX
// // disable the direct assignment of VGPR address
// // because we need to increment it several times
// // during the writing phase.
// //assign out_vgpr_dest_addr = in_lddst_stsrc_addr[9:0];
// reg [9:0] out_vgpr_dest_addr;

// // SX
// // change the assignment of ouput vgpr dest data
// // into a concatenate of 64 32-bit subwords from 
// // 8k buffer.

// //assign out_vgpr_dest_data = in_rd_data;

// assign out_vgpr_dest_wr_mask = in_exec_value;
// assign out_vgpr_instr_done_wfid = in_wftag_resp[6:1];

// assign out_tracemon_retire_pc = in_instr_pc;
// assign out_gm_or_lds = in_gm_or_lds;

// // // create an 64 entries, 128-bit wide shift registers;
// // // parameter MEM_BUS_WIDTH = 32;
// // // send ack signal when all data received
// // reg in_ack_all;
// // reg rd_shift, wr_shift;
// // reg [8:0] recv_cntr;
// // reg increment;
// // reg clr_cntr;
// // // buffer for holding 128x64 words
// // reg [2047:0] wb_buffer;
// // ////////////////////////////////////////////////////////////////////////mem_data, clk, rst, stall undefined
// // // infer the shift reg
// // always @(posedge clk) begin
// //    if(rd_shift) begin
// //       wb_buffer[8150:0] <= wb_buffer[8191:32];
// //       wb_buffer[8191:8160] <= in_rd_data;
// //    end
// // end
// // // infer receive counter
// // always @(posedge clk, posedge rst) begin
// //    if(rst) begin
// //       recv_cntr <= 0; 
// //    end
// //    else if(clr_cntr) begin
// //       recv_cntr <= 0;
// //    end
// //    else if(increment) begin
// //       recv_cntr <= recv_cntr + 1;
// //    end
// // end
// // // define the FSM
// // localparam IDLE = 3'b000;
// // localparam VGPR_RECV = 3'b001;
// // localparam SGPR_RECV = 3'b010;
// // localparam VGPR_WRT = 3'b011;
// // localparam SGPR_WRT = 3'b100;
// // localparam VGPR_WRT_1 = 3'b101;
// // localparam VGPR_WRT_2 = 3'b110;
// // localparam VGPR_WRT_3 = 3'b111;
// // assign out_vgpr_dest_data = wb_buffer;
// // reg lsu_rdy; // signal that stalls pipeline during memory read
// // reg [2:0] state, nxtState;
// // always @(posedge clk, posedge rst) begin
// //    if(rst) begin
// //       state <= 0;
// //    end
// //    else begin
// //       state <= nxtState;
// //    end
// // end
// // reg out_rfa_dest_wr_req;
// // always @(*) begin
// //    nxtState = IDLE;
// //    lsu_rdy = 1;
// //    in_ack_all = 0;
// //    clr_cntr = 0;
// //    out_vgpr_dest_addr = 9'bx;
// //    out_vgpr_dest_wr_en = 0;
// //    out_sgpr_dest_wr_en = 0;
// //    wr_shift = 0;
// //    rd_shift = 0;
// //    wb_ack = 0;
// //    out_rfa_dest_wr_req = 0;
// //    case(state)
// //       IDLE: begin
// //          if(in_ack) begin
// //             if(in_wftag_resp[0] == 0) begin
// //                nxtState = IDLE;
// //             end
// //             else if(in_lddst_stsrc_addr[11:10] == 2'b10) begin
// //                // VGPR case
// //                nxtState = VGPR_RECV;
// //                lsu_rdy = 0;
// //                clr_cntr = 1;
// //             end
// //             else if(in_lddst_stsrc_addr[11:10] == 2'b11) begin
// //                // SGPR case
// //                nxtState = SGPR_RECV;
// //                lsu_rdy = 0;
// //                clr_cntr = 1;
// //             end
// //          end
// //       end
// //       VGPR_RECV: begin
// //          lsu_rdy = 0;
// //          if(recv_cntr == (8192/32)-1) begin
// //             nxtState = VGPR_WRT;
// //          end
// //          else if(in_ack) begin
// //             increment = 1;
// //             nxtState = VGPR_RECV;
// //             rd_shift = 1;
// //          end
// //       end
// //       SGPR_RECV: begin
// //          lsu_rdy = 0;
// //          if(recv_cntr == 128/MEM_BUS_WIDTH) begin
// //             nxtState = SGPR_WRT;
// //          end
// //          if(in_ack) begin
// //             increment = 1;
// //             nxtState = SGPR_RECV;
// //          end
// //       end
// //       SGPR_WRT: begin
// //          lsu_rdy = 0;
// //          in_ack_all = 1;
// //          nxtState = IDLE;
// //          wb_ack = 1;
// //          out_rfa_dest_wr_req = 1;
// //          out_sgpr_dest_wr_en = 1;
// //       end
// //       VGPR_WRT: begin
// //          lsu_rdy = 0;
// //          out_vgpr_dest_wr_en = in_reg_wr_en;
// //          //in_ack_all = 1;
// //          out_vgpr_dest_addr = in_lddst_stsrc_addr[9:0]+increAddr;
// //          nxtState = IDLE;
// //          wb_ack = 1;
// //          out_rfa_dest_wr_req = 1;
// //       end
// //    endcase
// // end

// always @* begin
//    // in_ack_all signals the situation when all
//    // words have been received.

//    // in_wftag_resp is the concatenation of
//    // ex_wfid & ex_ld1_st0
//    // therefore, in_wf_tag_resp[0] refers to wr_en
//    casex({/*in_ack*/in_ack_all, in_wftag_resp[0], in_lddst_stsrc_addr[11:10]})
//    // out_*_instr_done is profiler signal
//    // ignore it for now.
//    // memory not ack, disable all writing
//    4'b0_?_??:
//       begin
//          //out_sgpr_dest_wr_en <= 4'b0;
//          //out_vgpr_dest_wr_en <= 4'b0;
//          out_sgpr_instr_done <= 1'b0;
//          out_vgpr_instr_done <= 1'b0;
//       end
//    // mem ack, in this case, enable the 
//    // vgpr write enable
//    4'b1_1_10:
//       begin
//          //out_sgpr_dest_wr_en <= 4'b0;
//          //out_vgpr_dest_wr_en <= in_reg_wr_en;
//          out_sgpr_instr_done <= 1'b0;
//          out_vgpr_instr_done <= 1'b1;
//       end
//    // mem ack, in this case, enable the 
//    // sgpr write enable.
//    4'b1_1_11:
//       begin
//          //out_sgpr_dest_wr_en <= in_reg_wr_en;
//          //out_vgpr_dest_wr_en <= 4'b0;
//          out_sgpr_instr_done <= 1'b1;
//          out_vgpr_instr_done <= 1'b0;
//       end
//    // handle the wr_en = 0 case
//    4'b1_0_10:
//       begin
//          //out_sgpr_dest_wr_en <= 4'b0;
//          //out_vgpr_dest_wr_en <= 4'b0;
//          out_sgpr_instr_done <= 1'b0;
//          out_vgpr_instr_done <= 1'b1;
//       end
//    // handle the wr_en = 0 case
//    4'b1_0_11:
//       begin
//          //out_sgpr_dest_wr_en <= 4'b0;
//          //out_vgpr_dest_wr_en <= 4'b0;
//          out_sgpr_instr_done <= 1'b1;
//          out_vgpr_instr_done <= 1'b0;
//       end
//    // this is an error case?
//    4'b1_?_0?:
//       begin
//          //out_sgpr_dest_wr_en <= 4'b0;
//          //out_vgpr_dest_wr_en <= 4'b0;
//          out_sgpr_instr_done <= 1'b0;
//          out_vgpr_instr_done <= 1'b0;
//       end
//    default:
//       begin
//          //out_sgpr_dest_wr_en <= 4'bx;
//          //out_vgpr_dest_wr_en <= 4'bx;
//          out_sgpr_instr_done <= 1'bx;
//          out_vgpr_instr_done <= 1'bx;
//       end
//    endcase
// end

   
//    //assign out_rfa_dest_wr_req = (|out_vgpr_dest_wr_en) | (|out_sgpr_dest_wr_en);

// endmodule
module lsu_wb_router 
(/*AUTOARG*/
   // Outputs
   out_sgpr_dest_addr, out_sgpr_dest_data, out_sgpr_dest_wr_en,
   out_sgpr_instr_done, out_sgpr_instr_done_wfid, out_vgpr_dest_addr,
   out_vgpr_dest_data, out_vgpr_dest_wr_en, out_vgpr_dest_wr_mask,
   out_vgpr_instr_done, out_vgpr_instr_done_wfid,
   out_tracemon_retire_pc, out_gm_or_lds, out_rfa_dest_wr_req, wb_en,
   // Inputs
   in_rd_data, in_wftag_resp, in_ack, in_exec_value,
   in_lddst_stsrc_addr, in_reg_wr_en, in_instr_pc, in_gm_or_lds, increAddr, retire
   );

input [2047:0] in_rd_data;
input [6:0] in_wftag_resp;
input in_ack;
input [63:0] in_exec_value;
input [11:0] in_lddst_stsrc_addr;
input [3:0] in_reg_wr_en;
input [31:0] in_instr_pc;
input in_gm_or_lds;
input wb_en;
input [1:0] increAddr;
input retire;

output [8:0] out_sgpr_dest_addr;
output [127:0] out_sgpr_dest_data;
output [3:0] out_sgpr_dest_wr_en;
output out_sgpr_instr_done;
output [5:0] out_sgpr_instr_done_wfid;

output [9:0] out_vgpr_dest_addr;
output [2047:0] out_vgpr_dest_data;
output out_vgpr_dest_wr_en;
output [63:0] out_vgpr_dest_wr_mask;
output out_vgpr_instr_done;
output [5:0] out_vgpr_instr_done_wfid;

output [31:0] out_tracemon_retire_pc;
output out_gm_or_lds;
   output     out_rfa_dest_wr_req;

reg [3:0] out_sgpr_dest_wr_en;
reg out_vgpr_dest_wr_en;
   
reg out_sgpr_instr_done;
reg out_vgpr_instr_done;

assign out_sgpr_dest_addr = in_lddst_stsrc_addr[8:0];
assign out_sgpr_dest_data = in_rd_data[127:0];
assign out_sgpr_instr_done_wfid = in_wftag_resp[6:1];

assign out_vgpr_dest_addr = in_lddst_stsrc_addr[9:0]+increAddr;
assign out_vgpr_dest_data = in_rd_data;
assign out_vgpr_dest_wr_mask = in_exec_value;
assign out_vgpr_instr_done_wfid = in_wftag_resp[6:1];

assign out_tracemon_retire_pc = in_instr_pc;
assign out_gm_or_lds = in_gm_or_lds;

always @* begin
   casex({in_ack, in_wftag_resp[0], in_lddst_stsrc_addr[11:10]})
   4'b0_?_??:
      begin
         out_sgpr_dest_wr_en <= 4'b0;
         out_vgpr_dest_wr_en <= 4'b0;
         out_sgpr_instr_done <= 1'b0;
         out_vgpr_instr_done <= 1'b0;
      end
   4'b1_1_10:
      begin
         out_sgpr_dest_wr_en <= 4'b0;
         out_vgpr_dest_wr_en <= |(in_reg_wr_en & wb_en);
         out_sgpr_instr_done <= 1'b0;
         out_vgpr_instr_done <= 1'b1 & retire;
      end
   4'b1_1_11:
      begin
         out_sgpr_dest_wr_en <= in_reg_wr_en & {4{wb_en}};
         out_vgpr_dest_wr_en <= 4'b0;
         out_sgpr_instr_done <= 1'b1 & retire;
         out_vgpr_instr_done <= 1'b0;
      end
   4'b1_0_10:
      begin
         out_sgpr_dest_wr_en <= 4'b0;
         out_vgpr_dest_wr_en <= 4'b0;
         out_sgpr_instr_done <= 1'b0;
         out_vgpr_instr_done <= 1'b1 & retire;
      end
   4'b1_0_11:
      begin
         out_sgpr_dest_wr_en <= 4'b0;
         out_vgpr_dest_wr_en <= 4'b0;
         out_sgpr_instr_done <= 1'b1 & retire;
         out_vgpr_instr_done <= 1'b0;
      end
   4'b1_?_0?:
      begin
         out_sgpr_dest_wr_en <= 4'b0;
         out_vgpr_dest_wr_en <= 4'b0;
         out_sgpr_instr_done <= 1'b0;
         out_vgpr_instr_done <= 1'b0;
      end
   default:
      begin
         out_sgpr_dest_wr_en <= 4'bx;
         out_vgpr_dest_wr_en <= 4'bx;
         out_sgpr_instr_done <= 1'bx;
         out_vgpr_instr_done <= 1'bx;
      end
   endcase
end

   assign out_rfa_dest_wr_req = (|out_vgpr_dest_wr_en) | (|out_sgpr_dest_wr_en);

endmodule
