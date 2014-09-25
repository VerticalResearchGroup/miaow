module mem_wait
  (/*AUTOARG*/
   // Outputs
   mem_wait_arry,
   // Inputs
   clk, rst, lsu_valid, f_sgpr_lsu_instr_done, f_vgpr_lsu_wr_done,
   lsu_wfid, f_sgpr_lsu_instr_done_wfid, f_vgpr_lsu_wr_done_wfid
   );

   input clk,rst;
   input lsu_valid, f_sgpr_lsu_instr_done, f_vgpr_lsu_wr_done;
   input [5:0] lsu_wfid, f_sgpr_lsu_instr_done_wfid, f_vgpr_lsu_wr_done_wfid;

   output [`WF_PER_CU-1:0] mem_wait_arry;

   wire [`WF_PER_CU-1:0] 	 decoded_issue_value, decoded_sgpr_retire_value,
				 decoded_vgpr_retire_value,
				 mem_wait_reg_wr_en, mem_waiting_wf;

   decoder_6b_40b_en issue_value_decoder
     (
      .addr_in(lsu_wfid),
      .out(decoded_issue_value),
      .en(lsu_valid)
      );


   decoder_6b_40b_en retire_sgpr_value_decoder
     (
      .addr_in(f_sgpr_lsu_instr_done_wfid),
      .out(decoded_sgpr_retire_value),
      .en(f_sgpr_lsu_instr_done)
      );

   decoder_6b_40b_en retire_vgpr_value_decoder
     (
      .addr_in(f_vgpr_lsu_wr_done_wfid),
      .out(decoded_vgpr_retire_value),
      .en(f_vgpr_lsu_wr_done)
      );

   dff_set_en_rst mem_wait[`WF_PER_CU-1:0]
     (
      .q(mem_waiting_wf),
      .d(40'b0),
      .en(mem_wait_reg_wr_en),
      .clk(clk),
      .set(decoded_issue_value),
      .rst(rst)
      );

   assign mem_wait_reg_wr_en = decoded_vgpr_retire_value | decoded_sgpr_retire_value | decoded_issue_value;

   assign mem_wait_arry = mem_waiting_wf;
endmodule
