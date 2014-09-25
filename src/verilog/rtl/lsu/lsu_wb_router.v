module lsu_wb_router 
(/*AUTOARG*/
   // Outputs
   out_sgpr_dest_addr, out_sgpr_dest_data, out_sgpr_dest_wr_en,
   out_sgpr_instr_done, out_sgpr_instr_done_wfid, out_vgpr_dest_addr,
   out_vgpr_dest_data, out_vgpr_dest_wr_en, out_vgpr_dest_wr_mask,
   out_vgpr_instr_done, out_vgpr_instr_done_wfid,
   out_tracemon_retire_pc, out_gm_or_lds, out_rfa_dest_wr_req,
   // Inputs
   in_rd_data, in_wftag_resp, in_ack, in_exec_value,
   in_lddst_stsrc_addr, in_reg_wr_en, in_instr_pc, in_gm_or_lds
   );

input [8191:0] in_rd_data;
input [6:0] in_wftag_resp;
input in_ack;
input [63:0] in_exec_value;
input [11:0] in_lddst_stsrc_addr;
input [3:0] in_reg_wr_en;
input [31:0] in_instr_pc;
input in_gm_or_lds;

output [8:0] out_sgpr_dest_addr;
output [127:0] out_sgpr_dest_data;
output [3:0] out_sgpr_dest_wr_en;
output out_sgpr_instr_done;
output [5:0] out_sgpr_instr_done_wfid;

output [9:0] out_vgpr_dest_addr;
output [8191:0] out_vgpr_dest_data;
output [3:0] out_vgpr_dest_wr_en;
output [63:0] out_vgpr_dest_wr_mask;
output out_vgpr_instr_done;
output [5:0] out_vgpr_instr_done_wfid;

output [31:0] out_tracemon_retire_pc;
output out_gm_or_lds;
   output 	  out_rfa_dest_wr_req;

reg [3:0] out_sgpr_dest_wr_en;
reg [3:0] out_vgpr_dest_wr_en;
   
reg out_sgpr_instr_done;
reg out_vgpr_instr_done;

assign out_sgpr_dest_addr = in_lddst_stsrc_addr[8:0];
assign out_sgpr_dest_data = in_rd_data[127:0];
assign out_sgpr_instr_done_wfid = in_wftag_resp[6:1];

assign out_vgpr_dest_addr = in_lddst_stsrc_addr[9:0];
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
         out_vgpr_dest_wr_en <= in_reg_wr_en;
         out_sgpr_instr_done <= 1'b0;
         out_vgpr_instr_done <= 1'b1;
      end
   4'b1_1_11:
      begin
         out_sgpr_dest_wr_en <= in_reg_wr_en;
         out_vgpr_dest_wr_en <= 4'b0;
         out_sgpr_instr_done <= 1'b1;
         out_vgpr_instr_done <= 1'b0;
      end
   4'b1_0_10:
      begin
         out_sgpr_dest_wr_en <= 4'b0;
         out_vgpr_dest_wr_en <= 4'b0;
         out_sgpr_instr_done <= 1'b0;
         out_vgpr_instr_done <= 1'b1;
      end
   4'b1_0_11:
      begin
         out_sgpr_dest_wr_en <= 4'b0;
         out_vgpr_dest_wr_en <= 4'b0;
         out_sgpr_instr_done <= 1'b1;
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
