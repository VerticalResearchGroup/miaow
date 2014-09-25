module valid_entry
  (/*AUTOARG*/
   // Outputs
   valid_entry_out,
   // Inputs
   clk, rst, f_decode_valid, f_decode_wf_halt, f_decode_barrier,
   f_salu_branch_en, f_salu_branch_taken, issued_valid,
   f_decode_waitcnt, f_decode_wfid, issued_wfid, f_salu_branch_wfid
   );

   // Valid entry is set at decode and cleared at issue

   input clk,rst;
   input f_decode_valid, f_decode_wf_halt, f_decode_barrier, 
	 f_salu_branch_en, f_salu_branch_taken, issued_valid,
	 f_decode_waitcnt;
   input [`WF_ID_LENGTH-1:0] f_decode_wfid, issued_wfid, 
			     f_salu_branch_wfid;
   
   wire 		     decode_init_en;
   wire [`WF_PER_CU-1:0]     decoded_init_instr, decoded_issued,
			     decoded_branch_taken,
			     next_valid_entry;

   output [`WF_PER_CU-1:0]   valid_entry_out;

   decoder_6b_40b_en init_instr_decoder(
					.addr_in(f_decode_wfid),
					.out(decoded_init_instr),
					.en(decode_init_en)
					);

   decoder_6b_40b_en instr_issued_decoder(
				       .addr_in(issued_wfid),
				       .out(decoded_issued),
				       .en(issued_valid)
				       );

   decoder_6b_40b_en branch_taken_decoder(
				       .addr_in(f_salu_branch_wfid),
				       .out(decoded_branch_taken),
				       .en((f_salu_branch_en & f_salu_branch_taken))
				       );

   dff valid_reg[`WF_PER_CU-1:0] 
     (
      .q(valid_entry_out),
      .d(next_valid_entry),
      .clk(clk),
      .rst(rst)
      );

   assign decode_init_en = f_decode_valid & ~f_decode_wf_halt & ~f_decode_barrier & ~f_decode_waitcnt;
   
   assign next_valid_entry = (valid_entry_out | (decoded_init_instr)) & 
			     ~(decoded_issued | decoded_branch_taken);
   
   
endmodule
