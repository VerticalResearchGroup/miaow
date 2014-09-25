module scoreboard
  (/*AUTOARG*/
   // Outputs
   lsu_source_reg1, lsu_source_reg2, lsu_source_reg3, lsu_dest_reg,
   lsu_mem_sgpr, alu_source_reg1, alu_source_reg2, alu_source_reg3,
   alu_dest_reg1, alu_dest_reg2, lsu_imm_value0, alu_imm_value0,
   lsu_lds_base, lsu_imm_value1, lsu_opcode, alu_imm_value1,
   alu_opcode, alu_instr_pc, lsu_instr_pc,
   ready_array_data_dependencies, alu_branch,
   // Inputs
   clk, rst, f_decode_source_reg2, f_decode_source_reg3,
   f_decode_dest_reg2, f_decode_source_reg1, f_decode_source_reg4,
   f_decode_dest_reg1, f_decode_imm_value0, f_decode_lds_base,
   f_decode_instr_pc, f_decode_opcode, f_decode_imm_value1,
   f_decode_vcc_wr, f_decode_vcc_rd, f_decode_scc_wr, f_decode_scc_rd,
   f_decode_exec_rd, f_decode_exec_wr, f_decode_m0_rd, f_decode_m0_wr,
   f_decode_branch, f_decode_valid, issued_wfid, f_decode_wfid,
   f_vgpr_alu_wr_done_wfid, f_vgpr_lsu_wr_done_wfid,
   f_sgpr_alu_wr_done_wfid, f_sgpr_lsu_instr_done_wfid,
   f_exec_salu_wr_wfid, f_exec_valu_wr_vcc_wfid,
   f_exec_salu_wr_vcc_en, f_exec_salu_wr_exec_en,
   f_exec_salu_wr_scc_en, f_exec_salu_wr_m0_en, f_exec_valu_wr_vcc_en,
   f_sgpr_alu_dest_reg_addr, f_sgpr_lsu_dest_reg_addr,
   f_sgpr_valu_dest_addr, f_vgpr_alu_dest_reg_addr,
   f_vgpr_lsu_dest_reg_addr, f_vgpr_lsu_dest_reg_valid,
   f_sgpr_lsu_dest_reg_valid, f_sgpr_alu_dest_reg_valid,
   f_vgpr_alu_dest_reg_valid, f_sgpr_valu_dest_reg_valid, alu_valid,
   lsu_valid, issued_valid
   );

   input clk, rst;
   
   input[`OPERAND_LENGTH_2WORD-1:0] f_decode_source_reg2, f_decode_source_reg3, 
				   f_decode_dest_reg2;
   input [`OPERAND_LENGTH_4WORD-1:0] f_decode_source_reg1, f_decode_source_reg4, 
				    f_decode_dest_reg1;
   input [15:0] 		    f_decode_imm_value0, f_decode_lds_base;
   input [31:0] 		    f_decode_instr_pc, f_decode_opcode, f_decode_imm_value1;
   input 			    f_decode_vcc_wr, f_decode_vcc_rd, f_decode_scc_wr,
				    f_decode_scc_rd, f_decode_exec_rd, f_decode_exec_wr, 
				    f_decode_m0_rd, f_decode_m0_wr, 
				    f_decode_branch, f_decode_valid;
   input [`WF_ID_LENGTH-1:0] 	    issued_wfid;	    

   input [`WF_ID_LENGTH-1:0] 	    f_decode_wfid, f_vgpr_alu_wr_done_wfid, 
				    f_vgpr_lsu_wr_done_wfid, f_sgpr_alu_wr_done_wfid, 
				    f_sgpr_lsu_instr_done_wfid, f_exec_salu_wr_wfid, 
				    f_exec_valu_wr_vcc_wfid;

   input 			    f_exec_salu_wr_vcc_en, f_exec_salu_wr_exec_en, f_exec_salu_wr_scc_en, 
				    f_exec_salu_wr_m0_en, f_exec_valu_wr_vcc_en;
   
   input [`SGPR_ADDR_LENGTH-1:0]     f_sgpr_alu_dest_reg_addr, f_sgpr_lsu_dest_reg_addr,
				     f_sgpr_valu_dest_addr;
   input [`VGPR_ADDR_LENGTH-1:0]     f_vgpr_alu_dest_reg_addr, f_vgpr_lsu_dest_reg_addr;
   input [3:0] 			     f_vgpr_lsu_dest_reg_valid, f_sgpr_lsu_dest_reg_valid;
   input [1:0] 			     f_sgpr_alu_dest_reg_valid;
   input 			     f_vgpr_alu_dest_reg_valid, f_sgpr_valu_dest_reg_valid;
			     
   
   input 			    alu_valid, lsu_valid, issued_valid;
			    
   output [11:0] 		    lsu_source_reg1, lsu_source_reg2, lsu_source_reg3, 
				    lsu_dest_reg, lsu_mem_sgpr, 
				    alu_source_reg1, alu_source_reg2, alu_source_reg3, 
				    alu_dest_reg1, alu_dest_reg2;
   output [15:0] 		    lsu_imm_value0, alu_imm_value0, lsu_lds_base;
   output [31:0] 		    lsu_imm_value1, lsu_opcode, alu_imm_value1, alu_opcode,
				    alu_instr_pc, lsu_instr_pc;
   output [`WF_PER_CU-1:0] 	    ready_array_data_dependencies;  
   output 			    alu_branch;
   

   wire [`ISSUE_INSTR_INFO_LENGTH-1:0] sgpr_alu_rd_data, sgpr_lsu_rd_data,
				       vgpr_alu_rd_data, vgpr_lsu_rd_data;

   wire [`ISSUE_INSTR_INFO_LENGTH-1:0] issued_rd_data;
   wire [`WF_PER_CU-1:0] 	      ready_arry_gpr, ready_arry_spr;

   wire [3:0] 			      decode_dest_reg1_busy_bits, 
				      decode_source_reg1_busy_bits,
				      decode_source_reg4_busy_bits;
   
   wire [1:0] 			      decode_dest_reg2_busy_bits, 
				      decode_source_reg2_busy_bits,
				      decode_source_reg3_busy_bits;
  
   wire [`ISSUE_GPR_RD_BITS_LENGTH-1:0] sgpr_valu_set_data,
					sgpr_alu_set_data, sgpr_lsu_set_data,
					vgpr_alu_set_data, vgpr_lsu_set_data;

   wire 			      issue_alu_exec_wr, issue_alu_m0_wr, 
				      issue_alu_scc_wr, issue_alu_vcc_wr, 
				      issue_lsu_exec_wr, issue_lsu_m0_wr,
				      issue_lsu_scc_wr, issue_lsu_vcc_wr;
   
   wire [`ISSUE_INSTR_INFO_LENGTH-1:0] decode_wr_data;
   wire [`ISSUE_GPR_RD_BITS_LENGTH-1:0] decode_instr_data;
   wire [11:0] 			       lsu_source_reg1, lsu_source_reg2, lsu_source_reg3, 
				      lsu_dest_reg, lsu_mem_sgpr, 
				      alu_source_reg1, alu_source_reg2, alu_source_reg3, 
				      alu_dest_reg1, alu_dest_reg2;
   wire [15:0] 			      lsu_imm_value0, alu_imm_value0;
   wire [31:0] 			      lsu_imm_value1, lsu_opcode, alu_imm_value1, alu_opcode,
				      alu_instr_pc, lsu_instr_pc;
   wire [1:0] 			      lsu_dest_reg_size;
   wire 			      alu_dest_reg1_size, alu_dest_reg2_size;
   
   instr_info_table iit
     (/*AUTOINST*/
      // Outputs
      .vgpr_alu_rd_data			(vgpr_alu_rd_data[`ISSUE_INSTR_INFO_LENGTH-1:0]),
      .vgpr_lsu_rd_data			(vgpr_lsu_rd_data[`ISSUE_INSTR_INFO_LENGTH-1:0]),
      .sgpr_alu_rd_data			(sgpr_alu_rd_data[`ISSUE_INSTR_INFO_LENGTH-1:0]),
      .sgpr_lsu_rd_data			(sgpr_lsu_rd_data[`ISSUE_INSTR_INFO_LENGTH-1:0]),
      .issued_rd_data			(issued_rd_data[`ISSUE_INSTR_INFO_LENGTH-1:0]),
      // Inputs
      .f_decode_valid			(f_decode_valid),
      .clk				(clk),
      .rst				(rst),
      .f_decode_wfid			(f_decode_wfid[`WF_ID_LENGTH-1:0]),
      .decode_wr_data			(decode_wr_data[`ISSUE_INSTR_INFO_LENGTH-1:0]),
      .f_vgpr_alu_wr_done_wfid		(f_vgpr_alu_wr_done_wfid[`WF_ID_LENGTH-1:0]),
      .f_vgpr_lsu_wr_done_wfid		(f_vgpr_lsu_wr_done_wfid[`WF_ID_LENGTH-1:0]),
      .f_sgpr_alu_wr_done_wfid		(f_sgpr_alu_wr_done_wfid[`WF_ID_LENGTH-1:0]),
      .f_sgpr_lsu_instr_done_wfid	(f_sgpr_lsu_instr_done_wfid[`WF_ID_LENGTH-1:0]),
      .issued_wfid			(issued_wfid[`WF_ID_LENGTH-1:0]));

   assign decode_wr_data
     = {f_decode_lds_base, f_decode_branch,
	f_decode_vcc_wr,f_decode_scc_wr,
	f_decode_exec_wr,f_decode_m0_wr,
	f_decode_instr_pc,f_decode_opcode,
	f_decode_imm_value0,f_decode_imm_value1,
	f_decode_source_reg1,f_decode_source_reg2,
	f_decode_source_reg3,f_decode_source_reg4,
	f_decode_dest_reg1,f_decode_dest_reg2};
	
   assign lsu_lds_base = issued_rd_data[`ISSUE_LDS_BASE_H:`ISSUE_LDS_BASE_L];
   assign lsu_opcode = issued_rd_data[`ISSUE_OP_H:`ISSUE_OP_L];
   assign lsu_instr_pc  = issued_rd_data[`ISSUE_PC_H:`ISSUE_PC_L];
   assign lsu_imm_value0  = issued_rd_data[`ISSUE_IM0_H:`ISSUE_IM0_L];
   assign lsu_imm_value1  = issued_rd_data[`ISSUE_IM1_H:`ISSUE_IM1_L];
   assign lsu_source_reg1  = issued_rd_data[`ISSUE_SRC1_H-2:`ISSUE_SRC1_L];
   assign lsu_source_reg2  = issued_rd_data[`ISSUE_SRC2_H-1:`ISSUE_SRC2_L];
   assign lsu_source_reg3  = issued_rd_data[`ISSUE_SRC3_H-1:`ISSUE_SRC3_L];
   assign lsu_dest_reg_size = issued_rd_data[`ISSUE_DST1_H:`ISSUE_DST1_H-1];
   assign lsu_dest_reg  = issued_rd_data[`ISSUE_DST1_H-2:`ISSUE_DST1_L];
   assign lsu_mem_sgpr  = issued_rd_data[`ISSUE_SRC4_H-2:`ISSUE_SRC4_L];
   assign issue_lsu_vcc_wr = issued_rd_data[`ISSUE_VCC_WR];
   assign issue_lsu_scc_wr = issued_rd_data[`ISSUE_SCC_WR];
   assign issue_lsu_m0_wr = issued_rd_data[`ISSUE_M0_WR];
   assign issue_lsu_exec_wr = issued_rd_data[`ISSUE_EXEC_WR];
   
   assign alu_opcode  = issued_rd_data[`ISSUE_OP_H:`ISSUE_OP_L];
   assign alu_instr_pc  = issued_rd_data[`ISSUE_PC_H:`ISSUE_PC_L];
   assign alu_imm_value0  = issued_rd_data[`ISSUE_IM0_H:`ISSUE_IM0_L];
   assign alu_imm_value1  = issued_rd_data[`ISSUE_IM1_H:`ISSUE_IM1_L];
   assign alu_source_reg1  = issued_rd_data[`ISSUE_SRC1_H-2:`ISSUE_SRC1_L];
   assign alu_source_reg2  = issued_rd_data[`ISSUE_SRC2_H-1:`ISSUE_SRC2_L];
   assign alu_source_reg3  = issued_rd_data[`ISSUE_SRC3_H-1:`ISSUE_SRC3_L];
   assign alu_dest_reg1_size = issued_rd_data[`ISSUE_DST1_H-1];
   assign alu_dest_reg1  = issued_rd_data[`ISSUE_DST1_H-2:`ISSUE_DST1_L];
   assign alu_dest_reg2_size = issued_rd_data[`ISSUE_DST2_H];
   assign alu_dest_reg2  = issued_rd_data[`ISSUE_DST2_H-1:`ISSUE_DST2_L];
   assign issue_alu_vcc_wr = issued_rd_data[`ISSUE_VCC_WR];
   assign issue_alu_scc_wr = issued_rd_data[`ISSUE_SCC_WR];
   assign issue_alu_m0_wr = issued_rd_data[`ISSUE_M0_WR];
   assign issue_alu_exec_wr = issued_rd_data[`ISSUE_EXEC_WR];
   assign alu_branch = issued_rd_data[`ISSUE_BRANCH];
   

   busy_gpr_table bgt
     (/*AUTOINST*/
      // Outputs
      .decode_dest_reg1_busy_bits	(decode_dest_reg1_busy_bits[3:0]),
      .decode_source_reg1_busy_bits	(decode_source_reg1_busy_bits[3:0]),
      .decode_source_reg4_busy_bits	(decode_source_reg4_busy_bits[3:0]),
      .decode_source_reg2_busy_bits	(decode_source_reg2_busy_bits[1:0]),
      .decode_source_reg3_busy_bits	(decode_source_reg3_busy_bits[1:0]),
      .decode_dest_reg2_busy_bits	(decode_dest_reg2_busy_bits[1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .alu_valid			(alu_valid),
      .lsu_valid			(lsu_valid),
      .f_decode_source_reg2		(f_decode_source_reg2[`OPERAND_LENGTH_2WORD-1:0]),
      .f_decode_source_reg3		(f_decode_source_reg3[`OPERAND_LENGTH_2WORD-1:0]),
      .f_decode_dest_reg2		(f_decode_dest_reg2[`OPERAND_LENGTH_2WORD-1:0]),
      .f_decode_dest_reg1		(f_decode_dest_reg1[`OPERAND_LENGTH_4WORD-1:0]),
      .f_decode_source_reg1		(f_decode_source_reg1[`OPERAND_LENGTH_4WORD-1:0]),
      .f_decode_source_reg4		(f_decode_source_reg4[`OPERAND_LENGTH_4WORD-1:0]),
      .alu_dest_reg1			(alu_dest_reg1[11:0]),
      .lsu_dest_reg			(lsu_dest_reg[11:0]),
      .lsu_dest_reg_size		(lsu_dest_reg_size[1:0]),
      .alu_dest_reg1_size		(alu_dest_reg1_size),
      .alu_dest_reg2			(alu_dest_reg2[11:0]),
      .alu_dest_reg2_size		(alu_dest_reg2_size),
      .f_vgpr_alu_dest_reg_addr		(f_vgpr_alu_dest_reg_addr[`VGPR_ADDR_LENGTH-1:0]),
      .f_vgpr_lsu_dest_reg_addr		(f_vgpr_lsu_dest_reg_addr[`VGPR_ADDR_LENGTH-1:0]),
      .f_vgpr_lsu_dest_reg_valid	(f_vgpr_lsu_dest_reg_valid[3:0]),
      .f_vgpr_alu_dest_reg_valid	(f_vgpr_alu_dest_reg_valid),
      .f_sgpr_valu_dest_addr		(f_sgpr_valu_dest_addr[`SGPR_ADDR_LENGTH-1:0]),
      .f_sgpr_alu_dest_reg_addr		(f_sgpr_alu_dest_reg_addr[`SGPR_ADDR_LENGTH-1:0]),
      .f_sgpr_lsu_dest_reg_addr		(f_sgpr_lsu_dest_reg_addr[`SGPR_ADDR_LENGTH-1:0]),
      .f_sgpr_lsu_dest_reg_valid	(f_sgpr_lsu_dest_reg_valid[3:0]),
      .f_sgpr_alu_dest_reg_valid	(f_sgpr_alu_dest_reg_valid[1:0]),
      .f_sgpr_valu_dest_reg_valid	(f_sgpr_valu_dest_reg_valid));
   
   

   
   /*******************************************************************
    * GPR comparators to fill the dependency table                    *
    *******************************************************************/
   
   vgpr_comparator vgpr_alu_cmp
     (
      // Outputs
      .result				(vgpr_alu_set_data),
      // Inputs
      .retired_operand_mask		({3'b0,f_vgpr_alu_dest_reg_valid}),
      .retired_operand_addr		(f_vgpr_alu_dest_reg_addr),
      .src1_gpr_info			(vgpr_alu_rd_data[`ISSUE_SRC1_H:`ISSUE_SRC1_L]),
      .src4_gpr_info			(vgpr_alu_rd_data[`ISSUE_SRC4_H:`ISSUE_SRC4_L]),
      .dst1_gpr_info			(vgpr_alu_rd_data[`ISSUE_DST1_H:`ISSUE_DST1_L]),
      .src2_gpr_info			(vgpr_alu_rd_data[`ISSUE_SRC2_H:`ISSUE_SRC2_L]),
      .src3_gpr_info			(vgpr_alu_rd_data[`ISSUE_SRC3_H:`ISSUE_SRC3_L]),
      .dst2_gpr_info			(vgpr_alu_rd_data[`ISSUE_DST2_H:`ISSUE_DST2_L]));

   vgpr_comparator vgpr_lsu_cmp
     (
      // Outputs
      .result				(vgpr_lsu_set_data),
      // Inputs
      .retired_operand_mask		(f_vgpr_lsu_dest_reg_valid),
      .retired_operand_addr		(f_vgpr_lsu_dest_reg_addr),
      .src1_gpr_info			(vgpr_lsu_rd_data[`ISSUE_SRC1_H:`ISSUE_SRC1_L]),
      .src4_gpr_info			(vgpr_lsu_rd_data[`ISSUE_SRC4_H:`ISSUE_SRC4_L]),
      .dst1_gpr_info			(vgpr_lsu_rd_data[`ISSUE_DST1_H:`ISSUE_DST1_L]),
      .src2_gpr_info			(vgpr_lsu_rd_data[`ISSUE_SRC2_H:`ISSUE_SRC2_L]),
      .src3_gpr_info			(vgpr_lsu_rd_data[`ISSUE_SRC3_H:`ISSUE_SRC3_L]),
      .dst2_gpr_info			(vgpr_lsu_rd_data[`ISSUE_DST2_H:`ISSUE_DST2_L]));

   sgpr_comparator sgpr_alu_cmp
     (
      // Outputs
      .result				(sgpr_alu_set_data),
      // Inputs
      .retired_operand_mask		({2'b0,f_sgpr_alu_dest_reg_valid}),
      .retired_operand_addr		(f_sgpr_alu_dest_reg_addr),
      .src1_gpr_info			(sgpr_alu_rd_data[`ISSUE_SRC1_H:`ISSUE_SRC1_L]),
      .src4_gpr_info			(sgpr_alu_rd_data[`ISSUE_SRC4_H:`ISSUE_SRC4_L]),
      .dst1_gpr_info			(sgpr_alu_rd_data[`ISSUE_DST1_H:`ISSUE_DST1_L]),
      .src2_gpr_info			(sgpr_alu_rd_data[`ISSUE_SRC2_H:`ISSUE_SRC2_L]),
      .src3_gpr_info			(sgpr_alu_rd_data[`ISSUE_SRC3_H:`ISSUE_SRC3_L]),
      .dst2_gpr_info			(sgpr_alu_rd_data[`ISSUE_DST2_H:`ISSUE_DST2_L]));

   // This comparator uses the same WFID as the valu one, so it also uses the
   // same data read from the instruction info table
   sgpr_comparator sgpr_valu_cmp
     (
      // Outputs
      .result				(sgpr_valu_set_data),
      // Inputs
      .retired_operand_mask		({2'b0,f_sgpr_valu_dest_reg_valid, f_sgpr_valu_dest_reg_valid}),
      .retired_operand_addr		(f_sgpr_valu_dest_addr),
      .src1_gpr_info			(vgpr_alu_rd_data[`ISSUE_SRC1_H:`ISSUE_SRC1_L]),
      .src4_gpr_info			(vgpr_alu_rd_data[`ISSUE_SRC4_H:`ISSUE_SRC4_L]),
      .dst1_gpr_info			(vgpr_alu_rd_data[`ISSUE_DST1_H:`ISSUE_DST1_L]),
      .src2_gpr_info			(vgpr_alu_rd_data[`ISSUE_SRC2_H:`ISSUE_SRC2_L]),
      .src3_gpr_info			(vgpr_alu_rd_data[`ISSUE_SRC3_H:`ISSUE_SRC3_L]),
      .dst2_gpr_info			(vgpr_alu_rd_data[`ISSUE_DST2_H:`ISSUE_DST2_L]));

   sgpr_comparator sgpr_lsu_cmp
     (
      // Outputs
      .result				(sgpr_lsu_set_data),
      // Inputs
      .retired_operand_mask		(f_sgpr_lsu_dest_reg_valid),
      .retired_operand_addr		(f_sgpr_lsu_dest_reg_addr),
      .src1_gpr_info			(sgpr_lsu_rd_data[`ISSUE_SRC1_H:`ISSUE_SRC1_L]),
      .src4_gpr_info			(sgpr_lsu_rd_data[`ISSUE_SRC4_H:`ISSUE_SRC4_L]),
      .dst1_gpr_info			(sgpr_lsu_rd_data[`ISSUE_DST1_H:`ISSUE_DST1_L]),
      .src2_gpr_info			(sgpr_lsu_rd_data[`ISSUE_SRC2_H:`ISSUE_SRC2_L]),
      .src3_gpr_info			(sgpr_lsu_rd_data[`ISSUE_SRC3_H:`ISSUE_SRC3_L]),
      .dst2_gpr_info			(sgpr_lsu_rd_data[`ISSUE_DST2_H:`ISSUE_DST2_L]));
   
   /**********************************************************************
    * GPR dependency table                                               *
    **********************************************************************/    
  gpr_dependency_table gdt
     (/*AUTOINST*/
      // Outputs
      .ready_arry_gpr			(ready_arry_gpr[`WF_PER_CU-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .vgpr_alu_set_data		(vgpr_alu_set_data[`ISSUE_GPR_RD_BITS_LENGTH-1:0]),
      .vgpr_lsu_set_data		(vgpr_lsu_set_data[`ISSUE_GPR_RD_BITS_LENGTH-1:0]),
      .sgpr_alu_set_data		(sgpr_alu_set_data[`ISSUE_GPR_RD_BITS_LENGTH-1:0]),
      .sgpr_lsu_set_data		(sgpr_lsu_set_data[`ISSUE_GPR_RD_BITS_LENGTH-1:0]),
      .sgpr_valu_set_data		(sgpr_valu_set_data[`ISSUE_GPR_RD_BITS_LENGTH-1:0]),
      .decode_instr_data		(decode_instr_data[`ISSUE_GPR_RD_BITS_LENGTH-1:0]),
      .f_vgpr_alu_wr_done_wfid		(f_vgpr_alu_wr_done_wfid[`WF_ID_LENGTH-1:0]),
      .f_vgpr_lsu_wr_done_wfid		(f_vgpr_lsu_wr_done_wfid[`WF_ID_LENGTH-1:0]),
      .f_sgpr_alu_wr_done_wfid		(f_sgpr_alu_wr_done_wfid[`WF_ID_LENGTH-1:0]),
      .f_sgpr_lsu_instr_done_wfid	(f_sgpr_lsu_instr_done_wfid[`WF_ID_LENGTH-1:0]),
      .f_decode_wfid			(f_decode_wfid[`WF_ID_LENGTH-1:0]),
      .f_decode_valid			(f_decode_valid));
   
   assign decode_instr_data = {decode_source_reg1_busy_bits, decode_source_reg2_busy_bits[1:0], 
			decode_source_reg3_busy_bits[1:0], decode_source_reg4_busy_bits, 
			decode_dest_reg1_busy_bits, decode_dest_reg2_busy_bits[1:0]};
   

   /**********************************************************************
    * SPR dependency table                                               *
    **********************************************************************/
   spr_dependency_table sdt
     (/*AUTOINST*/
      // Outputs
      .ready_arry_spr			(ready_arry_spr[`WF_PER_CU-1:0]),
      // Inputs
      .f_decode_wfid			(f_decode_wfid[`WF_ID_LENGTH-1:0]),
      .f_exec_salu_wr_wfid		(f_exec_salu_wr_wfid[`WF_ID_LENGTH-1:0]),
      .f_exec_valu_wr_vcc_wfid		(f_exec_valu_wr_vcc_wfid[`WF_ID_LENGTH-1:0]),
      .issued_wfid			(issued_wfid[`WF_ID_LENGTH-1:0]),
      .f_decode_valid			(f_decode_valid),
      .f_decode_vcc_wr			(f_decode_vcc_wr),
      .f_decode_vcc_rd			(f_decode_vcc_rd),
      .f_decode_scc_wr			(f_decode_scc_wr),
      .f_decode_scc_rd			(f_decode_scc_rd),
      .f_decode_exec_rd			(f_decode_exec_rd),
      .f_decode_exec_wr			(f_decode_exec_wr),
      .f_decode_m0_rd			(f_decode_m0_rd),
      .f_decode_m0_wr			(f_decode_m0_wr),
      .f_exec_salu_wr_vcc_en		(f_exec_salu_wr_vcc_en),
      .f_exec_salu_wr_exec_en		(f_exec_salu_wr_exec_en),
      .f_exec_salu_wr_scc_en		(f_exec_salu_wr_scc_en),
      .f_exec_salu_wr_m0_en		(f_exec_salu_wr_m0_en),
      .f_exec_valu_wr_vcc_en		(f_exec_valu_wr_vcc_en),
      .alu_valid			(alu_valid),
      .lsu_valid			(lsu_valid),
      .issued_valid			(issued_valid),
      .issue_lsu_vcc_wr			(issue_lsu_vcc_wr),
      .issue_lsu_scc_wr			(issue_lsu_scc_wr),
      .issue_lsu_exec_wr		(issue_lsu_exec_wr),
      .issue_lsu_m0_wr			(issue_lsu_m0_wr),
      .issue_alu_vcc_wr			(issue_alu_vcc_wr),
      .issue_alu_scc_wr			(issue_alu_scc_wr),
      .issue_alu_exec_wr		(issue_alu_exec_wr),
      .issue_alu_m0_wr			(issue_alu_m0_wr),
      .clk				(clk),
      .rst				(rst));
   
   assign ready_array_data_dependencies = ready_arry_spr & ready_arry_gpr;
 
endmodule
   
