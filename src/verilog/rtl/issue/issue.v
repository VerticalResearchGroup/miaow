module issue
(/*AUTOARG*/
    // Outputs
    salu_alu_select, simd0_alu_select, simd1_alu_select,
    simd2_alu_select, simd3_alu_select, simf0_alu_select,
    simf1_alu_select, simf2_alu_select, simf3_alu_select,
    lsu_lsu_select, fetchwave_wf_done_en, tracemon_barrier_retire_en,
    tracemon_waitcnt_retire_en, lsu_wfid, alu_wfid,
    fetchwave_wf_done_wf_id, fetch_wg_wfid,
    tracemon_waitcnt_retire_wfid, lsu_source_reg1, lsu_source_reg2,
    lsu_source_reg3, lsu_dest_reg, lsu_mem_sgpr, alu_source_reg1,
    alu_source_reg2, alu_source_reg3, alu_dest_reg1, alu_dest_reg2,
    lsu_imm_value0, alu_imm_value0, lsu_lds_base, lsu_imm_value1,
    lsu_opcode, alu_imm_value1, alu_opcode, alu_instr_pc, lsu_instr_pc,
    tracemon_waitcnt_retire_pc, tracemon_barrier_retire_pc,
    wave_valid_entries, tracemon_barrier_retire_wf_bitmap,
    // Inputs
    clk, rst, decode_branch, decode_barrier, decode_vcc_wr,
    decode_vcc_rd, decode_scc_wr, decode_scc_rd, decode_exec_rd,
    decode_exec_wr, decode_m0_rd, decode_m0_wr, decode_wf_halt,
    decode_valid, decode_waitcnt, vgpr_alu_wr_done,
    vgpr_alu_dest_reg_valid, vgpr_lsu_wr_done, sgpr_alu_wr_done,
    sgpr_lsu_instr_done, sgpr_valu_dest_reg_valid, simd0_alu_ready,
    simd1_alu_ready, simd2_alu_ready, simd3_alu_ready, simf0_alu_ready,
    simf1_alu_ready, simf2_alu_ready, simf3_alu_ready, salu_alu_ready,
    lsu_ready, exec_salu_wr_vcc_en, exec_salu_wr_exec_en,
    exec_salu_wr_scc_en, exec_salu_wr_m0_en, exec_valu_wr_vcc_en,
    salu_branch_en, salu_branch_taken, decode_fu,
    sgpr_alu_dest_reg_valid, vgpr_lsu_dest_reg_valid,
    sgpr_lsu_dest_reg_valid, fetch_wg_wf_count, decode_wfid,
    vgpr_alu_wr_done_wfid, vgpr_lsu_wr_done_wfid,
    sgpr_alu_wr_done_wfid, sgpr_lsu_instr_done_wfid, exec_salu_wr_wfid,
    exec_valu_wr_vcc_wfid, fetch_wg_wgid, salu_branch_wfid,
    sgpr_alu_dest_reg_addr, sgpr_lsu_dest_reg_addr,
    sgpr_valu_dest_addr, vgpr_alu_dest_reg_addr,
    vgpr_lsu_dest_reg_addr, decode_source_reg2, decode_source_reg3,
    lsu_done, lsu_done_wfid,
    decode_dest_reg2, decode_source_reg1, decode_source_reg4,
    decode_dest_reg1, decode_imm_value0, decode_lds_base,
    decode_instr_pc, decode_opcode, decode_imm_value1
);

input clk;

input rst;

input   decode_branch, decode_barrier, decode_vcc_wr, decode_vcc_rd, decode_scc_wr,
        decode_scc_rd, decode_exec_rd, decode_exec_wr, decode_m0_rd, decode_m0_wr,
        decode_wf_halt, decode_valid, decode_waitcnt, 
        vgpr_alu_wr_done, vgpr_alu_dest_reg_valid,
        vgpr_lsu_wr_done, sgpr_alu_wr_done, sgpr_lsu_instr_done, sgpr_valu_dest_reg_valid,
        simd0_alu_ready, simd1_alu_ready, simd2_alu_ready, simd3_alu_ready, 
        simf0_alu_ready, simf1_alu_ready, simf2_alu_ready, simf3_alu_ready, 
        salu_alu_ready, lsu_ready,
        exec_salu_wr_vcc_en, exec_salu_wr_exec_en, exec_salu_wr_scc_en, exec_salu_wr_m0_en,
        exec_valu_wr_vcc_en, salu_branch_en, salu_branch_taken,
        lsu_done;
input [1:0] decode_fu, sgpr_alu_dest_reg_valid;
input [3:0] vgpr_lsu_dest_reg_valid, sgpr_lsu_dest_reg_valid, fetch_wg_wf_count;
input [5:0] decode_wfid, vgpr_alu_wr_done_wfid, vgpr_lsu_wr_done_wfid,
            sgpr_alu_wr_done_wfid, sgpr_lsu_instr_done_wfid, exec_salu_wr_wfid,
            exec_valu_wr_vcc_wfid, fetch_wg_wgid, salu_branch_wfid,
            lsu_done_wfid;
input [8:0] sgpr_alu_dest_reg_addr, sgpr_lsu_dest_reg_addr, sgpr_valu_dest_addr;
input [9:0] vgpr_alu_dest_reg_addr, vgpr_lsu_dest_reg_addr;
input [12:0] decode_source_reg2, decode_source_reg3, decode_dest_reg2;
input [13:0] decode_source_reg1, decode_source_reg4, decode_dest_reg1;
input [15:0] decode_imm_value0, decode_lds_base;
input [31:0] decode_instr_pc, decode_opcode, decode_imm_value1;

output 	salu_alu_select, simd0_alu_select, simd1_alu_select, simd2_alu_select,
simd3_alu_select, simf0_alu_select, simf1_alu_select, simf2_alu_select,
simf3_alu_select, lsu_lsu_select, fetchwave_wf_done_en, tracemon_barrier_retire_en,
tracemon_waitcnt_retire_en;
output [5:0] lsu_wfid, alu_wfid, fetchwave_wf_done_wf_id, fetch_wg_wfid,
tracemon_waitcnt_retire_wfid;
output [11:0] lsu_source_reg1, lsu_source_reg2, lsu_source_reg3, lsu_dest_reg,
lsu_mem_sgpr, alu_source_reg1, alu_source_reg2, alu_source_reg3, alu_dest_reg1,
alu_dest_reg2;
output [15:0] lsu_imm_value0, alu_imm_value0, lsu_lds_base;
output [31:0] lsu_imm_value1, lsu_opcode, alu_imm_value1, alu_opcode,
alu_instr_pc, lsu_instr_pc, tracemon_waitcnt_retire_pc, tracemon_barrier_retire_pc;
output [39:0] wave_valid_entries;

output [39:0] tracemon_barrier_retire_wf_bitmap;

   // Flopped inputs
   wire 	 f_decode_branch, f_decode_barrier, f_decode_vcc_wr, 
		 f_decode_vcc_rd, f_decode_scc_wr, f_decode_scc_rd, 
		 f_decode_exec_rd, f_decode_exec_wr, f_decode_m0_rd, 
		 f_decode_m0_wr, f_decode_wf_halt, f_decode_valid, 
		 f_decode_waitcnt, f_vgpr_alu_wr_done, f_vgpr_alu_dest_reg_valid,
		 f_vgpr_lsu_wr_done, f_sgpr_alu_wr_done, f_sgpr_lsu_instr_done, 
		 f_sgpr_valu_dest_reg_valid,
		 f_exec_salu_wr_vcc_en, f_exec_salu_wr_exec_en, 
		 f_exec_salu_wr_scc_en, f_exec_salu_wr_m0_en,
		 f_exec_valu_wr_vcc_en, f_salu_branch_en, f_salu_branch_taken; //26
   
   wire [1:0] 	 f_decode_fu, f_sgpr_alu_dest_reg_valid; //2
   wire [3:0] 	 f_vgpr_lsu_dest_reg_valid, f_sgpr_lsu_dest_reg_valid; //2
   wire [5:0] 	 f_decode_wfid, f_vgpr_alu_wr_done_wfid, f_vgpr_lsu_wr_done_wfid,
		 f_sgpr_alu_wr_done_wfid, f_sgpr_lsu_instr_done_wfid, 
		 f_exec_salu_wr_wfid, f_exec_valu_wr_vcc_wfid, f_salu_branch_wfid; //8
   wire [8:0] 	 f_sgpr_alu_dest_reg_addr, f_sgpr_lsu_dest_reg_addr, 
		 f_sgpr_valu_dest_addr; //3

   wire [9:0] 	 f_vgpr_alu_dest_reg_addr, f_vgpr_lsu_dest_reg_addr; // 2
   wire [12:0] 	 f_decode_source_reg2, f_decode_source_reg3, f_decode_dest_reg2; //3
   wire [13:0] 	 f_decode_source_reg1, f_decode_source_reg4, f_decode_dest_reg1; //3
   wire [15:0] 	 f_decode_imm_value0, f_decode_lds_base; //2
   wire [31:0] 	 f_decode_instr_pc, f_decode_opcode, f_decode_imm_value1; //3

   
   // Other signals
   wire 	 alu_valid, lsu_valid;
   wire 	 issued_valid;
   wire [`WF_ID_LENGTH-1:0] issued_wfid;
 
   wire [`WF_ID_LENGTH-1:0] alu_wfid, lsu_wfid;
   wire [`WF_PER_CU-1:0]    ready_array_data_dependencies;
   wire [`WF_PER_CU-1:0]    fu_lsu, fu_salu, fu_simd, fu_simf;
   wire [`WF_PER_CU-1:0]    lsu_ready_to_issue, salu_ready_to_issue, 
			    simd_ready_to_issue, simf_ready_to_issue;
   
   wire [`WF_PER_CU-1:0]    mem_wait_arry, pending_branches_arry, 
			    barrier_wait_arry, max_instr_inflight_array;
   wire [`WF_PER_CU-1:0]    valid_entry_out;
   wire 		    alu_branch;

   dff input_flops[26 + 2*2 + 4*2 + 6*8 + 9*3 + 10*2 + 13*3 + 14*3 + 16*2 + 32*3 - 1 : 0]
     (
      .d({decode_barrier, decode_branch, decode_dest_reg1, decode_dest_reg2, 
	  decode_exec_rd, decode_exec_wr, decode_fu, decode_imm_value0, 
	  decode_imm_value1, decode_instr_pc, decode_lds_base, decode_m0_rd, 
	  decode_m0_wr, decode_opcode, decode_scc_rd, decode_scc_wr, 
	  decode_source_reg1, decode_source_reg2, decode_source_reg3, 
	  decode_source_reg4, decode_valid, decode_vcc_rd, decode_vcc_wr, 
	  decode_waitcnt, decode_wf_halt, decode_wfid, exec_salu_wr_exec_en, 
	  exec_salu_wr_m0_en, exec_salu_wr_scc_en, exec_salu_wr_vcc_en, 
	  exec_salu_wr_wfid, exec_valu_wr_vcc_en, exec_valu_wr_vcc_wfid, 
	  salu_branch_en, salu_branch_taken, salu_branch_wfid, 
	  sgpr_alu_dest_reg_addr, sgpr_alu_dest_reg_valid, sgpr_alu_wr_done, 
	  sgpr_alu_wr_done_wfid, sgpr_lsu_dest_reg_addr, sgpr_lsu_dest_reg_valid, 
	  sgpr_lsu_instr_done, sgpr_lsu_instr_done_wfid, sgpr_valu_dest_addr, 
	  sgpr_valu_dest_reg_valid, vgpr_alu_dest_reg_addr, vgpr_alu_dest_reg_valid, 
	  vgpr_alu_wr_done, vgpr_alu_wr_done_wfid, vgpr_lsu_dest_reg_addr, 
	  vgpr_lsu_dest_reg_valid, vgpr_lsu_wr_done, vgpr_lsu_wr_done_wfid}
	 ),
      .q({f_decode_barrier, f_decode_branch, f_decode_dest_reg1, 
	  f_decode_dest_reg2, f_decode_exec_rd, f_decode_exec_wr, 
	  f_decode_fu, f_decode_imm_value0, f_decode_imm_value1, 
	  f_decode_instr_pc, f_decode_lds_base, f_decode_m0_rd, 
	  f_decode_m0_wr, f_decode_opcode, f_decode_scc_rd, f_decode_scc_wr, 
	  f_decode_source_reg1, f_decode_source_reg2, f_decode_source_reg3, 
	  f_decode_source_reg4, f_decode_valid, f_decode_vcc_rd, f_decode_vcc_wr, 
	  f_decode_waitcnt, f_decode_wf_halt, f_decode_wfid, f_exec_salu_wr_exec_en,
	  f_exec_salu_wr_m0_en, f_exec_salu_wr_scc_en, f_exec_salu_wr_vcc_en, 
	  f_exec_salu_wr_wfid, f_exec_valu_wr_vcc_en, f_exec_valu_wr_vcc_wfid, 
	  f_salu_branch_en, f_salu_branch_taken, f_salu_branch_wfid, 
	  f_sgpr_alu_dest_reg_addr, f_sgpr_alu_dest_reg_valid, f_sgpr_alu_wr_done, 
	  f_sgpr_alu_wr_done_wfid, f_sgpr_lsu_dest_reg_addr, 
	  f_sgpr_lsu_dest_reg_valid, f_sgpr_lsu_instr_done, 
	  f_sgpr_lsu_instr_done_wfid, f_sgpr_valu_dest_addr, 
	  f_sgpr_valu_dest_reg_valid, f_vgpr_alu_dest_reg_addr, 
	  f_vgpr_alu_dest_reg_valid, f_vgpr_alu_wr_done, f_vgpr_alu_wr_done_wfid, 
	  f_vgpr_lsu_dest_reg_addr, f_vgpr_lsu_dest_reg_valid, f_vgpr_lsu_wr_done, 
	  f_vgpr_lsu_wr_done_wfid}
	 ),
      .clk(clk),
      .rst(rst));
   
   // Assign wait cnt values
   assign tracemon_waitcnt_retire_en = f_decode_valid & f_decode_waitcnt;
   assign tracemon_waitcnt_retire_wfid = f_decode_wfid;
   assign tracemon_waitcnt_retire_pc = f_decode_instr_pc;
   

   valid_entry valid_entry
     (/*AUTOINST*/
      // Outputs
      .valid_entry_out			(valid_entry_out[`WF_PER_CU-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .f_decode_valid			(f_decode_valid),
      .f_decode_wf_halt			(f_decode_wf_halt),
      .f_decode_barrier			(f_decode_barrier),
      .f_salu_branch_en			(f_salu_branch_en),
      .f_salu_branch_taken		(f_salu_branch_taken),
      .issued_valid			(issued_valid),
      .f_decode_waitcnt			(f_decode_waitcnt),
      .f_decode_wfid			(f_decode_wfid[`WF_ID_LENGTH-1:0]),
      .issued_wfid			(issued_wfid[`WF_ID_LENGTH-1:0]),
      .f_salu_branch_wfid		(f_salu_branch_wfid[`WF_ID_LENGTH-1:0]));


   functional_unit_reg_bank fu_table
     (/*AUTOINST*/
      // Outputs
      .fu_simd				(fu_simd[`WF_PER_CU-1:0]),
      .fu_salu				(fu_salu[`WF_PER_CU-1:0]),
      .fu_lsu				(fu_lsu[`WF_PER_CU-1:0]),
      .fu_simf				(fu_simf[`WF_PER_CU-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .f_decode_valid			(f_decode_valid),
      .f_decode_fu			(f_decode_fu[1:0]),
      .f_decode_wfid			(f_decode_wfid[`WF_ID_LENGTH-1:0]));

   issue_flow_control issue_flow_control
     (/*AUTOINST*/
      // Outputs
      .wave_valid_entries		(wave_valid_entries[`WF_PER_CU-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .tracemon_barrier_retire_en	(tracemon_barrier_retire_en),
      .valid_entry_out			(valid_entry_out[`WF_PER_CU-1:0]),
      .tracemon_barrier_retire_wf_bitmap(tracemon_barrier_retire_wf_bitmap[`WF_PER_CU-1:0]),
      .f_decode_wfid			(f_decode_wfid[`WF_ID_LENGTH-1:0]),
      .f_salu_branch_wfid		(f_salu_branch_wfid[`WF_ID_LENGTH-1:0]),
      .alu_wfid				(alu_wfid[`WF_ID_LENGTH-1:0]),
      .f_decode_valid			(f_decode_valid),
      .f_decode_waitcnt			(f_decode_waitcnt),
      .f_salu_branch_en			(f_salu_branch_en),
      .alu_valid			(alu_valid),
      .alu_branch			(alu_branch));
   
   scoreboard scoreboard
     (/*AUTOINST*/
      // Outputs
      .lsu_source_reg1			(lsu_source_reg1[11:0]),
      .lsu_source_reg2			(lsu_source_reg2[11:0]),
      .lsu_source_reg3			(lsu_source_reg3[11:0]),
      .lsu_dest_reg			(lsu_dest_reg[11:0]),
      .lsu_mem_sgpr			(lsu_mem_sgpr[11:0]),
      .alu_source_reg1			(alu_source_reg1[11:0]),
      .alu_source_reg2			(alu_source_reg2[11:0]),
      .alu_source_reg3			(alu_source_reg3[11:0]),
      .alu_dest_reg1			(alu_dest_reg1[11:0]),
      .alu_dest_reg2			(alu_dest_reg2[11:0]),
      .lsu_imm_value0			(lsu_imm_value0[15:0]),
      .alu_imm_value0			(alu_imm_value0[15:0]),
      .lsu_lds_base			(lsu_lds_base[15:0]),
      .lsu_imm_value1			(lsu_imm_value1[31:0]),
      .lsu_opcode			(lsu_opcode[31:0]),
      .alu_imm_value1			(alu_imm_value1[31:0]),
      .alu_opcode			(alu_opcode[31:0]),
      .alu_instr_pc			(alu_instr_pc[31:0]),
      .lsu_instr_pc			(lsu_instr_pc[31:0]),
      .ready_array_data_dependencies	(ready_array_data_dependencies[`WF_PER_CU-1:0]),
      .alu_branch			(alu_branch),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .f_decode_source_reg2		(f_decode_source_reg2[`OPERAND_LENGTH_2WORD-1:0]),
      .f_decode_source_reg3		(f_decode_source_reg3[`OPERAND_LENGTH_2WORD-1:0]),
      .f_decode_dest_reg2		(f_decode_dest_reg2[`OPERAND_LENGTH_2WORD-1:0]),
      .f_decode_source_reg1		(f_decode_source_reg1[`OPERAND_LENGTH_4WORD-1:0]),
      .f_decode_source_reg4		(f_decode_source_reg4[`OPERAND_LENGTH_4WORD-1:0]),
      .f_decode_dest_reg1		(f_decode_dest_reg1[`OPERAND_LENGTH_4WORD-1:0]),
      .f_decode_imm_value0		(f_decode_imm_value0[15:0]),
      .f_decode_lds_base		(f_decode_lds_base[15:0]),
      .f_decode_instr_pc		(f_decode_instr_pc[31:0]),
      .f_decode_opcode			(f_decode_opcode[31:0]),
      .f_decode_imm_value1		(f_decode_imm_value1[31:0]),
      .f_decode_vcc_wr			(f_decode_vcc_wr),
      .f_decode_vcc_rd			(f_decode_vcc_rd),
      .f_decode_scc_wr			(f_decode_scc_wr),
      .f_decode_scc_rd			(f_decode_scc_rd),
      .f_decode_exec_rd			(f_decode_exec_rd),
      .f_decode_exec_wr			(f_decode_exec_wr),
      .f_decode_m0_rd			(f_decode_m0_rd),
      .f_decode_m0_wr			(f_decode_m0_wr),
      .f_decode_branch			(f_decode_branch),
      .f_decode_valid			(f_decode_valid),
      .issued_wfid			(issued_wfid[`WF_ID_LENGTH-1:0]),
      .f_decode_wfid			(f_decode_wfid[`WF_ID_LENGTH-1:0]),
      .f_vgpr_alu_wr_done_wfid		(f_vgpr_alu_wr_done_wfid[`WF_ID_LENGTH-1:0]),
      .f_vgpr_lsu_wr_done_wfid		(f_vgpr_lsu_wr_done_wfid[`WF_ID_LENGTH-1:0]),
      .f_sgpr_alu_wr_done_wfid		(f_sgpr_alu_wr_done_wfid[`WF_ID_LENGTH-1:0]),
      .f_sgpr_lsu_instr_done_wfid	(f_sgpr_lsu_instr_done_wfid[`WF_ID_LENGTH-1:0]),
      .f_exec_salu_wr_wfid		(f_exec_salu_wr_wfid[`WF_ID_LENGTH-1:0]),
      .f_exec_valu_wr_vcc_wfid		(f_exec_valu_wr_vcc_wfid[`WF_ID_LENGTH-1:0]),
      .f_exec_salu_wr_vcc_en		(f_exec_salu_wr_vcc_en),
      .f_exec_salu_wr_exec_en		(f_exec_salu_wr_exec_en),
      .f_exec_salu_wr_scc_en		(f_exec_salu_wr_scc_en),
      .f_exec_salu_wr_m0_en		(f_exec_salu_wr_m0_en),
      .f_exec_valu_wr_vcc_en		(f_exec_valu_wr_vcc_en),
      .f_sgpr_alu_dest_reg_addr		(f_sgpr_alu_dest_reg_addr[`SGPR_ADDR_LENGTH-1:0]),
      .f_sgpr_lsu_dest_reg_addr		(f_sgpr_lsu_dest_reg_addr[`SGPR_ADDR_LENGTH-1:0]),
      .f_sgpr_valu_dest_addr		(f_sgpr_valu_dest_addr[`SGPR_ADDR_LENGTH-1:0]),
      .f_vgpr_alu_dest_reg_addr		(f_vgpr_alu_dest_reg_addr[`VGPR_ADDR_LENGTH-1:0]),
      .f_vgpr_lsu_dest_reg_addr		(f_vgpr_lsu_dest_reg_addr[`VGPR_ADDR_LENGTH-1:0]),
      .f_vgpr_lsu_dest_reg_valid	(f_vgpr_lsu_dest_reg_valid[3:0]),
      .f_sgpr_lsu_dest_reg_valid	(f_sgpr_lsu_dest_reg_valid[3:0]),
      .f_sgpr_alu_dest_reg_valid	(f_sgpr_alu_dest_reg_valid[1:0]),
      .f_vgpr_alu_dest_reg_valid	(f_vgpr_alu_dest_reg_valid),
      .f_sgpr_valu_dest_reg_valid	(f_sgpr_valu_dest_reg_valid),
      .alu_valid			(alu_valid),
      .lsu_valid			(lsu_valid),
      .issued_valid			(issued_valid));

   assign salu_ready_to_issue = fu_salu & valid_entry_out &
				ready_array_data_dependencies &
				~max_instr_inflight_array & 
				~pending_branches_arry & ~barrier_wait_arry;
   
   assign simd_ready_to_issue = fu_simd & valid_entry_out &
				ready_array_data_dependencies &
				~max_instr_inflight_array &
				~pending_branches_arry & ~barrier_wait_arry;

   assign simf_ready_to_issue = fu_simf & valid_entry_out &
				ready_array_data_dependencies &
				~max_instr_inflight_array &
   				~pending_branches_arry & ~barrier_wait_arry;
   
   assign lsu_ready_to_issue = fu_lsu & valid_entry_out &
			       ready_array_data_dependencies & 
			       ~max_instr_inflight_array &
			       ~mem_wait_arry & 
			       ~pending_branches_arry & ~barrier_wait_arry;
   

   instruction_arbiter instruction_arbiter
     (/*AUTOINST*/
      // Outputs
      .simd0_alu_select			(simd0_alu_select),
      .simd1_alu_select			(simd1_alu_select),
      .simd2_alu_select			(simd2_alu_select),
      .simd3_alu_select			(simd3_alu_select),
      .simf0_alu_select			(simf0_alu_select),
      .simf1_alu_select			(simf1_alu_select),
      .simf2_alu_select			(simf2_alu_select),
      .simf3_alu_select			(simf3_alu_select),
      .lsu_lsu_select			(lsu_lsu_select),
      .salu_alu_select			(salu_alu_select),
      .lsu_wfid				(lsu_wfid[`WF_ID_LENGTH-1:0]),
      .alu_wfid				(alu_wfid[`WF_ID_LENGTH-1:0]),
      .issued_wfid			(issued_wfid[`WF_ID_LENGTH-1:0]),
      .alu_valid			(alu_valid),
      .lsu_valid			(lsu_valid),
      .issued_valid			(issued_valid),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .salu_ready_to_issue		(salu_ready_to_issue[`WF_PER_CU-1:0]),
      .simd_ready_to_issue		(simd_ready_to_issue[`WF_PER_CU-1:0]),
      .simf_ready_to_issue		(simf_ready_to_issue[`WF_PER_CU-1:0]),
      .lsu_ready_to_issue		(lsu_ready_to_issue[`WF_PER_CU-1:0]),
      .simd0_alu_ready			(simd0_alu_ready),
      .simd1_alu_ready			(simd1_alu_ready),
      .simd2_alu_ready			(simd2_alu_ready),
      .simd3_alu_ready			(simd3_alu_ready),
      .simf0_alu_ready			(simf0_alu_ready),
      .simf1_alu_ready			(simf1_alu_ready),
      .simf2_alu_ready			(simf2_alu_ready),
      .simf3_alu_ready			(simf3_alu_ready),
      .salu_alu_ready			(salu_alu_ready),
      .lsu_ready			(lsu_ready));
   
    mem_wait mem_wait
    (/*AUTOINST*/
        // Outputs
        .mem_wait_arry			(mem_wait_arry[`WF_PER_CU-1:0]),
        // Inputs
        .clk        (clk),
        .rst        (rst),
        .lsu_valid  (lsu_valid),
        .lsu_wfid   (lsu_wfid[5:0]),
        .lsu_done(lsu_done),
        .lsu_done_wfid(lsu_done_wfid)
    );
   
   branch_wait branch_wait
     (/*AUTOINST*/
      // Outputs
      .pending_branches_arry		(pending_branches_arry[`WF_PER_CU-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .alu_valid			(alu_valid),
      .alu_branch			(alu_branch),
      .alu_wfid				(alu_wfid[`WF_ID_LENGTH-1:0]),
      .f_salu_branch_en			(f_salu_branch_en),
      .f_salu_branch_wfid		(f_salu_branch_wfid[`WF_ID_LENGTH-1:0]));

   barrier_wait barrier_wait
     (/*AUTOINST*/
      // Outputs
      .tracemon_barrier_retire_en	(tracemon_barrier_retire_en),
      .fetch_wg_wfid			(fetch_wg_wfid[`WF_ID_LENGTH-1:0]),
      .barrier_wait_arry		(barrier_wait_arry[`WF_PER_CU-1:0]),
      .tracemon_barrier_retire_wf_bitmap(tracemon_barrier_retire_wf_bitmap[`WF_PER_CU-1:0]),
      .tracemon_barrier_retire_pc	(tracemon_barrier_retire_pc[31:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .f_decode_valid			(f_decode_valid),
      .f_decode_barrier			(f_decode_barrier),
      .f_decode_wfid			(f_decode_wfid[`WF_ID_LENGTH-1:0]),
      .f_decode_instr_pc		(f_decode_instr_pc[31:0]),
      .fetch_wg_wgid			(fetch_wg_wgid[`WF_ID_LENGTH-1:0]),
      .fetch_wg_wf_count		(fetch_wg_wf_count[3:0]));
   
   finished_wf finished_wf
     (/*AUTOINST*/
      // Outputs
      .fetchwave_wf_done_en		(fetchwave_wf_done_en),
      .fetchwave_wf_done_wf_id		(fetchwave_wf_done_wf_id[`WF_ID_LENGTH-1:0]),
      .max_instr_inflight_array		(max_instr_inflight_array[`WF_PER_CU-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .f_decode_wfid			(f_decode_wfid[`WF_ID_LENGTH-1:0]),
      .f_sgpr_alu_wr_done_wfid		(f_sgpr_alu_wr_done_wfid[`WF_ID_LENGTH-1:0]),
      .f_vgpr_alu_wr_done_wfid		(f_vgpr_alu_wr_done_wfid[`WF_ID_LENGTH-1:0]),
      .alu_wfid				(alu_wfid[`WF_ID_LENGTH-1:0]),
      .f_salu_branch_wfid		(f_salu_branch_wfid[`WF_ID_LENGTH-1:0]),
      .f_decode_valid			(f_decode_valid),
      .f_decode_wf_halt			(f_decode_wf_halt),
      .f_vgpr_alu_wr_done		(f_vgpr_alu_wr_done),
      .f_sgpr_alu_wr_done		(f_sgpr_alu_wr_done),
      .alu_valid			(alu_valid),
      .f_salu_branch_en			(f_salu_branch_en),
      .mem_wait_arry			(mem_wait_arry[`WF_PER_CU-1:0]));

   
endmodule
