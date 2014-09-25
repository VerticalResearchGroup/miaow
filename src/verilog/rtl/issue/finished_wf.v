module finished_wf
  (/*AUTOARG*/
   // Outputs
   fetchwave_wf_done_en, fetchwave_wf_done_wf_id,
   max_instr_inflight_array,
   // Inputs
   clk, rst, f_decode_wfid, f_sgpr_alu_wr_done_wfid,
   f_vgpr_alu_wr_done_wfid, alu_wfid, f_salu_branch_wfid, f_decode_valid,
   f_decode_wf_halt, f_vgpr_alu_wr_done, f_sgpr_alu_wr_done, alu_valid,
   f_salu_branch_en, mem_wait_arry
   );

   input clk,rst;
   input [`WF_ID_LENGTH-1:0] f_decode_wfid, f_sgpr_alu_wr_done_wfid, 
			     f_vgpr_alu_wr_done_wfid, alu_wfid,
			     f_salu_branch_wfid;
   input 		     f_decode_valid, f_decode_wf_halt, f_vgpr_alu_wr_done, 
			     f_sgpr_alu_wr_done, alu_valid, f_salu_branch_en;
   input [`WF_PER_CU-1:0]    mem_wait_arry;   
   
   output 		     fetchwave_wf_done_en;
   output [`WF_ID_LENGTH-1:0] fetchwave_wf_done_wf_id;
   output [`WF_PER_CU-1:0]    max_instr_inflight_array;

   wire 		      decode_wf_halt_valid;
   wire [`WF_PER_CU-1:0]      decoded_retired_sgpr, decoded_retired_vgpr,
			      decoded_retired_branch;
   wire [`WF_PER_CU-1:0]      decoded_decode_wf_halt, decoded_decode_valid, 
			      decoded_wf_done, decoded_no_inflight_instr;
   wire [`WF_PER_CU-1:0]      done_wf_array;
   wire [`WF_PER_CU-1:0]      halted_reg_out, halted_reg_in, halted_reg_wr_en;

   wire [`WF_PER_CU-1:0]      decoded_alu_valid;


   // Decoder for the retired instructions
   decoder_6b_40b_en decoder_retired_sgpr
     (
      .addr_in(f_sgpr_alu_wr_done_wfid),
      .out(decoded_retired_sgpr),
      .en(f_sgpr_alu_wr_done)
      );

   decoder_6b_40b_en decoder_retired_vgpr
     (
      .addr_in(f_vgpr_alu_wr_done_wfid),
      .out(decoded_retired_vgpr),
      .en(f_vgpr_alu_wr_done)
      );

   decoder_6b_40b_en decoder_retired_branch
     (
      .addr_in(f_salu_branch_wfid),
      .out(decoded_retired_branch),
      .en(f_salu_branch_en)
      );

   // Decoder for the issued instructions
   decoder_6b_40b_en decoder_issued_inst
     (
      .addr_in(alu_wfid),
      .out(decoded_alu_valid),
      .en(alu_valid)
      );


   // Decoder for the halt signal
   decoder_6b_40b_en decode_wf_halt_decoder
     (
      .addr_in(f_decode_wfid),
      .out(decoded_decode_wf_halt),
      .en(decode_wf_halt_valid)
      );

   decoder_6b_40b_en decode_wf_halt_decoder_valid
     (
      .addr_in(f_decode_wfid),
      .out(decoded_decode_valid),
      .en(f_decode_valid)
      );

   // Decoder for the done wf signal
   decoder_6b_40b_en decode_finished_wf
     (
      .addr_in(fetchwave_wf_done_wf_id),
      .out(decoded_wf_done),
      .en(fetchwave_wf_done_en)
      );
   // Register to record witch registers had a halt signals
   dff_en halted_reg[`WF_PER_CU-1:0]
     (
      .q(halted_reg_out),
      .d(halted_reg_in),
      .en(halted_reg_wr_en),
      .clk(clk),
      .rst(rst)
      );

   // Arbiter to chose witch finished wf signal will be issued
   arbiter finished_arbiter
     (
      .issued_en(fetchwave_wf_done_en),
      .issued_wf_id(fetchwave_wf_done_wf_id),
      .input_arry(done_wf_array),
      .choosen_valid(fetchwave_wf_done_en),
      .choosen_wf_id(fetchwave_wf_done_wf_id),
      .clk(clk),
      .rst(rst)
      );

   // Counter for the inflight instructions
   inflight_instr_counter inflight_instr_counters[`WF_PER_CU-1:0]
     (
      .clk(clk),
      .rst(rst),
      // Input from retired instructions
      .retire_vgpr_1_en(decoded_retired_vgpr),
      .retire_branch_en(decoded_retired_branch),
      .retire_sgpr_en(decoded_retired_sgpr),
      // Input from issued instructions
      .issued_en(decoded_alu_valid),
      // Output
      .no_inflight_instr_flag(decoded_no_inflight_instr),
      .max_inflight_instr_flag(max_instr_inflight_array)
      );

   assign decode_wf_halt_valid = f_decode_valid && f_decode_wf_halt;

   assign done_wf_array = halted_reg_out & decoded_no_inflight_instr & ~mem_wait_arry;
   assign halted_reg_in = decoded_decode_wf_halt | (~decoded_wf_done & halted_reg_out);
   assign halted_reg_wr_en = decoded_decode_valid | decoded_wf_done;

endmodule
