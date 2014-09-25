module spr_dependency_table
(/*AUTOARG*/
   // Outputs
   ready_arry_spr,
   // Inputs
   f_decode_wfid, f_exec_salu_wr_wfid, f_exec_valu_wr_vcc_wfid,
   issued_wfid, f_decode_valid, f_decode_vcc_wr, f_decode_vcc_rd,
   f_decode_scc_wr, f_decode_scc_rd, f_decode_exec_rd,
   f_decode_exec_wr, f_decode_m0_rd, f_decode_m0_wr,
   f_exec_salu_wr_vcc_en, f_exec_salu_wr_exec_en,
   f_exec_salu_wr_scc_en, f_exec_salu_wr_m0_en, f_exec_valu_wr_vcc_en,
   alu_valid, lsu_valid, issued_valid, issue_lsu_vcc_wr,
   issue_lsu_scc_wr, issue_lsu_exec_wr, issue_lsu_m0_wr,
   issue_alu_vcc_wr, issue_alu_scc_wr, issue_alu_exec_wr,
   issue_alu_m0_wr, clk, rst
   );

   input[`WF_ID_LENGTH-1:0] f_decode_wfid, f_exec_salu_wr_wfid, f_exec_valu_wr_vcc_wfid,
			   issued_wfid;
   
   input 		   f_decode_valid,
			   f_decode_vcc_wr, f_decode_vcc_rd, f_decode_scc_wr, 
			   f_decode_scc_rd, f_decode_exec_rd, f_decode_exec_wr, 
			   f_decode_m0_rd, f_decode_m0_wr, 
			   f_exec_salu_wr_vcc_en, f_exec_salu_wr_exec_en, 
			   f_exec_salu_wr_scc_en, f_exec_salu_wr_m0_en, 
			   f_exec_valu_wr_vcc_en;
 
   input 		   alu_valid, lsu_valid,
			   issued_valid, issue_lsu_vcc_wr, issue_lsu_scc_wr, 
			   issue_lsu_exec_wr, issue_lsu_m0_wr, 
			   issue_alu_vcc_wr, issue_alu_scc_wr, 
			   issue_alu_exec_wr, issue_alu_m0_wr;
 
   input 		   clk, rst;

   output [`WF_PER_CU-1:0]  ready_arry_spr;
   
   
   /**
    * Ready bits:
    * Incomming instructions:
    * If reads or writes spr and spr is busy, then mark as not ready
    * When instructions retires, set ready bits
    * 
    * Busy bits:
    * Set when instruction issue, clear when retires.
    **/
   wire[`WF_PER_CU-1:0] decode_wfid_decoded;

   decoder_6b_40b_en decode_wfid_decoder(
					    .addr_in(f_decode_wfid),
					    .en(f_decode_valid),
					    .out(decode_wfid_decoded)
					    );
   
   
   /*********************************************************************
    * EXEC dependency table                                             *
    *********************************************************************/
   wire[`WF_PER_CU-1:0] exec_ready_bits, next_exec_ready_bits,
		       exec_busy_bits, next_exec_busy_bits;

   wire [`WF_PER_CU-1:0] exec_issued_decoded;

   wire 		exec_issued_decoder_en;
   wire [`WF_PER_CU-1:0] exec_retired_salu_decoded;

   wire 		exec_decoded_instr_depends;
   
   wire [`WF_PER_CU-1:0] exec_decoded_instr_depends_decoded;
   
   decoder_6b_40b_en exec_retired_salu_decoder(
						  .addr_in(f_exec_salu_wr_wfid),
						  .en(f_exec_salu_wr_exec_en),
						  .out(exec_retired_salu_decoded)
						  );
   
   // Busy bits logic  
   dff exec_busy_bits_reg[`WF_PER_CU-1:0](
					 .q(exec_busy_bits),
					 .d(next_exec_busy_bits),
					 .clk(clk),
					 .rst(rst)
					 );

   decoder_6b_40b_en exec_issued_decoder(
					     .addr_in(issued_wfid),
					     .en(exec_issued_decoder_en),
					     .out(exec_issued_decoded)
					     );

   assign exec_issued_decoder_en = (issue_alu_exec_wr && alu_valid) | 
				       (issue_lsu_exec_wr && lsu_valid);
   
   assign next_exec_busy_bits = (  exec_busy_bits | 
				   (exec_issued_decoded)  ) & ( ~exec_retired_salu_decoded );
   
   // Ready bits logic
   dff exec_ready_bits_reg[`WF_PER_CU-1:0](
					     .q(exec_ready_bits),
					     .d(next_exec_ready_bits),
					     .clk(clk),
					     .rst(rst)
					     );

   decoder_6b_40b_en exec_decoded_instr_depends_decoder(
				 .addr_in(f_decode_wfid),
				 .en(exec_decoded_instr_depends),
				 .out(exec_decoded_instr_depends_decoded)
					     );
   
   assign exec_decoded_instr_depends = f_decode_exec_rd | f_decode_exec_wr;
   assign next_exec_ready_bits = (   decode_wfid_decoded  & ~(exec_decoded_instr_depends_decoded & next_exec_busy_bits)   ) | 
				 (   ~decode_wfid_decoded & (exec_ready_bits | exec_retired_salu_decoded)    );

   /*********************************************************************
    * M0 dependency table                                             *
    *********************************************************************/
   wire[`WF_PER_CU-1:0] m0_ready_bits, next_m0_ready_bits,
		       m0_busy_bits, next_m0_busy_bits;

   wire [`WF_PER_CU-1:0] m0_issued_decoded;

   wire 		m0_issued_decoder_en;
   wire [`WF_PER_CU-1:0] m0_retired_salu_decoded;

   wire 		m0_decoded_instr_depends;
   
   wire [`WF_PER_CU-1:0] m0_decoded_instr_depends_decoded;
   
   decoder_6b_40b_en m0_retired_salu_decoder(
						  .addr_in(f_exec_salu_wr_wfid),
						  .en(f_exec_salu_wr_m0_en),
						  .out(m0_retired_salu_decoded)
						  );
   
   // Busy bits logic  
   dff m0_busy_bits_reg[`WF_PER_CU-1:0](
					 .q(m0_busy_bits),
					 .d(next_m0_busy_bits),
					 .clk(clk),
					 .rst(rst)
					 );

   decoder_6b_40b_en m0_issued_decoder(
					     .addr_in(issued_wfid),
					     .en(m0_issued_decoder_en),
					     .out(m0_issued_decoded)
					     );

   assign m0_issued_decoder_en = (issue_alu_m0_wr && alu_valid) |
				     (issue_lsu_m0_wr && lsu_valid);
   
   assign next_m0_busy_bits = (  m0_busy_bits | 
				 (m0_issued_decoded) ) & ( ~m0_retired_salu_decoded );
   
   // Ready bits logic
   dff m0_ready_bits_reg[`WF_PER_CU-1:0](
					     .q(m0_ready_bits),
					     .d(next_m0_ready_bits),
					     .clk(clk),
					     .rst(rst)
					     );

   decoder_6b_40b_en m0_decoded_instr_depends_decoder(
				 .addr_in(f_decode_wfid),
				 .en(m0_decoded_instr_depends),
				 .out(m0_decoded_instr_depends_decoded)
					     );
   
   assign m0_decoded_instr_depends = f_decode_m0_rd | f_decode_m0_wr;
   assign next_m0_ready_bits = (   decode_wfid_decoded  & ~(m0_decoded_instr_depends_decoded & next_m0_busy_bits)   ) | 
				 (   ~decode_wfid_decoded & (m0_ready_bits | m0_retired_salu_decoded)    );

   /*********************************************************************
    * SCC dependency table                                             *
    *********************************************************************/
   wire[`WF_PER_CU-1:0] scc_ready_bits, next_scc_ready_bits,
		       scc_busy_bits, next_scc_busy_bits;

   wire [`WF_PER_CU-1:0] scc_issued_decoded;

   wire 		scc_issued_decoder_en;
   wire [`WF_PER_CU-1:0] scc_retired_salu_decoded;

   wire 		scc_decoded_instr_depends;
   
   wire [`WF_PER_CU-1:0] scc_decoded_instr_depends_decoded;
   
   decoder_6b_40b_en scc_retired_salu_decoder(
						  .addr_in(f_exec_salu_wr_wfid),
						  .en(f_exec_salu_wr_scc_en),
						  .out(scc_retired_salu_decoded)
						  );
   
   // Busy bits logic  
   dff scc_busy_bits_reg[`WF_PER_CU-1:0](
					 .q(scc_busy_bits),
					 .d(next_scc_busy_bits),
					 .clk(clk),
					 .rst(rst)
					 );

   decoder_6b_40b_en scc_issued_decoder(
					     .addr_in(issued_wfid),
					     .en(scc_issued_decoder_en),
					     .out(scc_issued_decoded)
					     );

   assign scc_issued_decoder_en = (issue_alu_scc_wr && alu_valid) |
				      (issue_lsu_scc_wr && lsu_valid);
   
   assign next_scc_busy_bits = (  scc_busy_bits | 
				  (scc_issued_decoded) ) & ( ~scc_retired_salu_decoded );
   
   // Ready bits logic
   dff scc_ready_bits_reg[`WF_PER_CU-1:0](
					     .q(scc_ready_bits),
					     .d(next_scc_ready_bits),
					     .clk(clk),
					     .rst(rst)
					     );

   decoder_6b_40b_en scc_decoded_instr_depends_decoder(
				 .addr_in(f_decode_wfid),
				 .en(scc_decoded_instr_depends),
				 .out(scc_decoded_instr_depends_decoded)
					     );
   
   assign scc_decoded_instr_depends = f_decode_scc_rd | f_decode_scc_wr;
   assign next_scc_ready_bits = (   decode_wfid_decoded  & ~(scc_decoded_instr_depends_decoded & next_scc_busy_bits)   ) | 
				 (   ~decode_wfid_decoded & (scc_ready_bits | scc_retired_salu_decoded)    );

 
    /*********************************************************************
    * VCC dependency table                                             *
    *********************************************************************/
   wire[`WF_PER_CU-1:0] vcc_ready_bits, next_vcc_ready_bits,
		       vcc_busy_bits, next_vcc_busy_bits;

   wire [`WF_PER_CU-1:0] vcc_issued_decoded;

   wire 		vcc_issued_decoder_en;
   wire [`WF_PER_CU-1:0] vcc_retired_salu_decoded, vcc_retired_valu_decoded;

   wire 		vcc_decoded_instr_depends;
   
   wire [`WF_PER_CU-1:0] vcc_decoded_instr_depends_decoded;
   
   decoder_6b_40b_en vcc_retired_salu_decoder(
						  .addr_in(f_exec_salu_wr_wfid),
						  .en(f_exec_salu_wr_vcc_en),
						  .out(vcc_retired_salu_decoded)
						  );

   decoder_6b_40b_en vcc_retired_valu_decoder(
						  .addr_in(f_exec_valu_wr_vcc_wfid),
						  .en(f_exec_valu_wr_vcc_en),
						  .out(vcc_retired_valu_decoded)
						  );
   
   // Busy bits logic  
   dff vcc_busy_bits_reg[`WF_PER_CU-1:0](
					 .q(vcc_busy_bits),
					 .d(next_vcc_busy_bits),
					 .clk(clk),
					 .rst(rst)
					 );

   decoder_6b_40b_en vcc_issued_decoder(
					.addr_in(issued_wfid),
					.en(vcc_issued_decoder_en),
					.out(vcc_issued_decoded)
					     );

   assign vcc_issued_decoder_en = (issue_alu_vcc_wr && alu_valid) |
				  (issue_lsu_vcc_wr && lsu_valid);
   
   assign next_vcc_busy_bits = (  vcc_busy_bits | 
				  (vcc_issued_decoded) ) & ( ~vcc_retired_salu_decoded & ~vcc_retired_valu_decoded );
   
   // Ready bits logic
   dff vcc_ready_bits_reg[`WF_PER_CU-1:0](
					     .q(vcc_ready_bits),
					     .d(next_vcc_ready_bits),
					     .clk(clk),
					     .rst(rst)
					     );

   decoder_6b_40b_en vcc_decoded_instr_depends_decoder(
				 .addr_in(f_decode_wfid),
				 .en(vcc_decoded_instr_depends),
				 .out(vcc_decoded_instr_depends_decoded)
					     );
   
   assign vcc_decoded_instr_depends = f_decode_vcc_rd | f_decode_vcc_wr;
   assign next_vcc_ready_bits = (   decode_wfid_decoded  & ~(vcc_decoded_instr_depends_decoded & next_vcc_busy_bits)   ) | 
				 (   ~decode_wfid_decoded & (vcc_ready_bits | vcc_retired_salu_decoded | vcc_retired_valu_decoded)    );

   assign ready_arry_spr = vcc_ready_bits & scc_ready_bits & exec_ready_bits & m0_ready_bits;
   
endmodule
