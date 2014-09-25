module branch_wait
  (/*AUTOARG*/
   // Outputs
   pending_branches_arry,
   // Inputs
   clk, rst, alu_valid, alu_branch, alu_wfid, f_salu_branch_en,
   f_salu_branch_wfid
   );
   input clk, rst;

   // Issued alu info
   input alu_valid, alu_branch;   
   input [`WF_ID_LENGTH-1:0] alu_wfid;

   // Salu signals with outcome of branch
   input 		    f_salu_branch_en;
   input [`WF_ID_LENGTH-1:0] f_salu_branch_wfid;

   // Output - list of pending branches
   output [`WF_PER_CU-1:0]   pending_branches_arry;
   
   /**
    * Branch wait is a reg that marks all wf with a pending branch.
    * Pending branches start when a branch instruction is issued
    * and end when salu signals the outcome of the branch
    **/

   wire 		    alu_branch_valid;
   wire [`WF_PER_CU-1:0]     alu_branch_decoded, 
			    salu_branch_decoded;

   wire [`WF_PER_CU-1:0]     pending_branch, next_pending_branch;

   assign pending_branches_arry = pending_branch;
   
   // Decoder for the issued branch
   decoder_6b_40b_en alu_brach_decoder
     (
      .addr_in(alu_wfid),
      .out(alu_branch_decoded),
      .en(alu_branch_valid)
      );

   // Decoder for the finished branch by fetch
   decoder_6b_40b_en issue_Value_decoder
     (
      .addr_in(f_salu_branch_wfid),
      .out(salu_branch_decoded),
      .en(f_salu_branch_en)
      );

   dff pending_branch_ff[`WF_PER_CU-1:0]
     (
      .q(pending_branch),
      .d(next_pending_branch),
      .clk(clk),
      .rst(rst)
      );
   
   assign alu_branch_valid = alu_valid && alu_branch; 
   assign next_pending_branch 
     = (  pending_branch | (alu_branch_decoded)  ) &
       ~(salu_branch_decoded);
   
endmodule
