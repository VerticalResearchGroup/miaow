/*
 * SIAGen: Random Program Generator
 * Currently supports [scalar | vector] - [alu | memory] ops
 * Only for a limitted set of opcodes
 *
 * To increase support for operations looks at the following fns:
 * 		initialize[scalar|vector][alu|mem]ops
 *
 * To increse the formats of operations supported (in above mentioned ops)
 * - create formatting functions: instruction_<type>(..)
 * - add an array and for-loop for the type in the initialize function 
 *   for the op
 *
 * To increase supported ops 
 * - create a #define
 * - increase INSTR_TYPES
 * - create a initialize function: initialize[op]()
 * - Add formats as mentioned above
 * - Edit initializeInstrArr
*/

#include "siagen.h"

int initializeScalarAluOps(Instr_Sel ops[MAX_OPS]) 
{
	int sopp_num = 7;
	Instr sopp_ops[7] = { 
		{ 0x02, "branch" },
		{ 0x04, "cbranch_scc0" },
		{ 0x05, "cbranch_scc1" },
		{ 0x06, "cbranch_vccz" },
		{ 0x08, "cbranch_execz" },
		{ 0x0A, "barrier" },
		{ 0x0C, "waitcnt" }
	};
	
	int sop1_num = 4;
	Instr sop1_ops[4] = { 
		{ 0x03, "mov_b32" }, 
		{ 0x04, "mov_b64" },
		{ 0x07, "not_b32" },
		{ 0x24, "and_saveexec_b64" }
	};

	int sop2_num = 13;
	Instr sop2_ops[13] = { 
		{ 0x00, "add_u32" },
		{ 0x02, "add_i32" },
		{ 0x03, "sub_i32" },
		{ 0x07, "min_u32" },
		{ 0x09, "max_u32" },
		{ 0x0E, "and_b32" },
		{ 0x0F, "and_b64" },
		{ 0x10, "or_b32" },
		{ 0x15, "andn2_b64" },
		{ 0x1E, "lshl_b32" },
		{ 0x20, "lshr_b32" },
		{ 0x22, "ashr_i32" },
		{ 0x26, "mul_i32" }
	};

	int sopk_num = 3;
	Instr sopk_ops[3] = { 
		{ 0x00, "movk_i32" },
		{ 0x0F, "addk_i32" },
		{ 0x10, "mulk_i32" }
	};

	int sopc_num = 4;
	Instr sopc_ops[4] = { 
		{ 0x00, "cmp_eq_i32" },
		{ 0x05, "cmp_le_i32" },
		{ 0x09, "cmp_ge_u32" },
		{ 0x0B, "cmp_le_u32" }
	};

	int i, j = 0;

	for(i = 0; i < sopp_num; i++, j++) {
		ops[j].instr_type = SI_FMT_SOPP;
		ops[j].instr = sopp_ops[i];
		ops[j].instr_func = instruction_sopp;
	}

	for(i = 0; i < sop1_num; i++, j++) {
		ops[j].instr_type = SI_FMT_SOP1;
		ops[j].instr = sop1_ops[i];
		ops[j].instr_func = instruction_sop1;
	}

	for(i = 0; i < sop2_num; i++, j++) {
		ops[j].instr_type = SI_FMT_SOP2;
		ops[j].instr = sop2_ops[i];
		ops[j].instr_func = instruction_sop2;
	}

	for(i = 0; i < sopk_num; i++, j++) {
		ops[j].instr_type = SI_FMT_SOPK;
		ops[j].instr = sopk_ops[i];
		ops[j].instr_func = instruction_sopk;
	}

	for(i = 0; i < sopc_num; i++, j++) {
		ops[j].instr_type = SI_FMT_SOPC;
		ops[j].instr = sopc_ops[i];
		ops[j].instr_func = instruction_sopc;
	}

	return j;
}

int initializeVectorAluOps(Instr_Sel ops[MAX_OPS]) 
{
	int vop1_num = 1;
	Instr vop1_ops[1] = { 
		{ 0x01, "mov_b32" }//,
		//{ 0x06, "cvt_f32_u32" },
		//{ 0x07, "cvt_u32_f32" },
		//{ 0x2A, "rcp_f32" },
		//{ 0x33, "sqrt_f32" }
	};

	int vop2_num = 12;
	Instr vop2_ops[12] = { 
		{ 0x00, "cndmask_b32" },
		{ 0x03, "add_f32" },
		{ 0x04, "sub_f32" },
		{ 0x05, "subrev_f32" },
		{ 0x08, "mul_f32" },
		{ 0x09, "mul_i32_i24" },
		{ 0x16, "lshrrev_b32" },
		{ 0x1A, "lshlrev_b32" },
		{ 0x1B, "and_b32" },
		{ 0x1C, "or_b32" },
		//{ 0x1F, "mac_f32" },
		{ 0x25, "add_i32" },
		{ 0x26, "sub_i32" }
	};

	int vopc_num = 6;
	Instr vopc_ops[6] = { 
		{ 0x04, "cmp_gt_f32" },
		{ 0x82, "cmp_eq_i32" },
		{ 0x84, "cmp_gt_i32" },
		{ 0x85, "cmp_ne_i32" },
		{ 0xC3, "cmp_le_u32" },
		{ 0xC4, "cmp_gt_u32" }
	};

	int vop3a_num = 10;
	Instr vop3a_ops[10] = { 
		{ 0x04, "cmp_gt_f32_3a" },
		{ 0x82, "cmp_eq_i32_3a" },
		{ 0x84, "cmp_gt_i32_3a" },
		{ 0x85, "cmp_ne_i32_3a" },
		{ 0xC3, "cmp_le_u32_3a" },
		{ 0xC4, "cmp_gt_u32_3a" },
		{ 0xC6, "cmp_ge_u32_3a" },
		{ 0x169, "mul_lo_u32_3a" },
		{ 0x16A, "mul_hi_u32_3a" },
		{ 0x16B, "mul_lo_i32_3a" }
	};

	int vop3b_num = 0;
	Instr vop3b_ops[1] = { { 0, "" } };

	int i, j = 0;

	for(i = 0; i < vop1_num; i++, j++) {
		ops[j].instr_type = SI_FMT_VOP1;
		ops[j].instr = vop1_ops[i];
		ops[j].instr_func = instruction_vop1;
	}

	for(i = 0; i < vop2_num; i++, j++) {
		ops[j].instr_type = SI_FMT_VOP2;
		ops[j].instr = vop2_ops[i];
		ops[j].instr_func = instruction_vop2;
	}

	for(i = 0; i < vopc_num; i++, j++) {
		ops[j].instr_type = SI_FMT_VOPC;
		ops[j].instr = vopc_ops[i];
		ops[j].instr_func = instruction_vopc;
	}

	for(i = 0; i < vop3a_num; i++, j++) {
		ops[j].instr_type = SI_FMT_VOP3a;
		ops[j].instr = vop3a_ops[i];
		ops[j].instr_func = instruction_vop3a;
	}

	for(i = 0; i < vop3b_num; i++, j++) {
		ops[j].instr_type = SI_FMT_VOP3b;
		ops[j].instr = vop3b_ops[i];
		//ops[j].instr_func = instruction_vop3b;
	}

	return j;
}

int initializeScalarMemOps(Instr_Sel ops[MAX_OPS]) 
{
	int smrd_num = 3;
	Instr smrd_ops[3] = { 
		{ 0x02, "ld_dwx4" },
		{ 0x08, "buff_ld_dw" },
		{ 0x09, "buff_ld_dwx2" }
	};

	int i, j = 0;

	for(i = 0; i < smrd_num; i++, j++) {
		ops[j].instr_type = SI_FMT_SMRD;
		ops[j].instr = smrd_ops[i];
		ops[j].instr_func = instruction_smrd;
	}

	return j;
}

int initializeVectorMemOps(Instr_Sel ops[MAX_OPS]) 
{
	int mtbuf_num = 4;
	Instr mtbuf_ops[4] = { 
		{ 0x00, "tbuff_ld_fmt_x" },
		{ 0x03, "tbuff_ld_fmt_xyzw" },
		{ 0x04, "tbuff_st_fmt_x" },
		{ 0x07, "tbuff_st_fmt_xyzw" }
	};

	int mubuf_num = 0;
	Instr mubuf_ops[1] = { { 0, "" } };

	int ds_num = 2;
	Instr ds_ops[2] = { 
		{ 0x0D, "ds_wr_b32" }, 
		{ 0x36, "ds_rd_b32" } 
	};

	int i, j = 0;

	for(i = 0; i < mtbuf_num; i++, j++) {
		ops[j].instr_type = SI_FMT_MTBUF;
		ops[j].instr = mtbuf_ops[i];
		ops[j].instr_func = instruction_mtbuf;
	}

	for(i = 0; i < mubuf_num; i++, j++) {
		ops[j].instr_type = SI_FMT_MUBUF;
		ops[j].instr = mubuf_ops[i];
		//ops[j].instr_func = instruction_mubuf;
	}

	for(i = 0; i < ds_num; i++, j++) {
		ops[j].instr_type = SI_FMT_DS;
		ops[j].instr = ds_ops[i];
		ops[j].instr_func = instruction_ds;
	}

	return j;
}

void printInstrsInArray(int arr[MAX_INSTR]) 
{
	Instr_Sel salu_ops[MAX_OPS];
	Instr_Sel valu_ops[MAX_OPS];
	Instr_Sel smem_ops[MAX_OPS];
	Instr_Sel vmem_ops[MAX_OPS];

	int sa_cnt = initializeScalarAluOps(salu_ops);
	int va_cnt = initializeVectorAluOps(valu_ops);
	int sm_cnt = initializeScalarMemOps(smem_ops);
	int vm_cnt = initializeVectorMemOps(vmem_ops);

	int i, r, id;
	//Operand_Vals opvals;

	for(i = 0; i < configs.instr_count; i++) {
		randomizeOperand();
		r = rand();

		switch(arr[i])
		{
			case SCALAR_ALU:
				id = r % sa_cnt;
				salu_ops[id].instr_func(salu_ops[id].instr.opcode);
				break;
			case VECTOR_ALU:
				id = r % va_cnt;
				valu_ops[id].instr_func(valu_ops[id].instr.opcode);
				break;
			case SCALAR_MEM:
				id = r % sm_cnt;
				smem_ops[id].instr_func(smem_ops[id].instr.opcode);
				break;
			case VECTOR_MEM:
				id = r % vm_cnt;
				vmem_ops[id].instr_func(vmem_ops[id].instr.opcode);
				break;
			default:
				fprintf(stderr, "Unknown instruction type encountered while printing instructions.\n");

		}
	}

	// print end program
	instruction_sopp_endpgm();
}

void printOpSpecificUT(int type, Instr_Sel ops[MAX_OPS], int cnt)
{
	int i;
	char folName[40];

	for(i = 0; i < cnt; i++) {
		// create folder
		sprintf(folName, "test_%d%02d_%s", type, i, ops[i].instr.op_str);
		mkdir(folName, S_IRWXU|S_IRGRP|S_IXGRP);
		chdir(folName);

		// open output files
		openOutputFiles();

		// write instruction and endpgm
		randomizeOperand();
		ops[i].instr_func(ops[i].instr.opcode);
		instruction_sopp_endpgm();

		// write config and data.mem
		writeConfigFile();
		writeDataMemFile();

		// close output files
		closeOutputFiles();

		// go to parent folder
		chdir("..");
	}
}

void printAllUnitTests() 
{
	Instr_Sel salu_ops[MAX_OPS];
	Instr_Sel valu_ops[MAX_OPS];
	Instr_Sel smem_ops[MAX_OPS];
	Instr_Sel vmem_ops[MAX_OPS];

	int sa_cnt = initializeScalarAluOps(salu_ops);
	int va_cnt = initializeVectorAluOps(valu_ops);
	int sm_cnt = initializeScalarMemOps(smem_ops);
	int vm_cnt = initializeVectorMemOps(vmem_ops);

	printOpSpecificUT(0, salu_ops, sa_cnt);
	printOpSpecificUT(1, valu_ops, va_cnt);
	printOpSpecificUT(2, smem_ops, sm_cnt);
	printOpSpecificUT(3, vmem_ops, vm_cnt);
}

void initializeInstrArr(int arr[MAX_INSTR]) 
{
	int i;

	int tot = configs.scalar_alu + configs.vector_alu + 
				configs.scalar_mem + configs.vector_mem;

	int rec_cnt = configs.scalar_alu;
	int loop_cnt = (rec_cnt * configs.instr_count)/tot;

	for(i = 0; i < loop_cnt; i++) {
		arr[i] = SCALAR_ALU;
	}

	rec_cnt = rec_cnt + configs.vector_alu;
	loop_cnt = (rec_cnt * configs.instr_count)/tot;

	for(; i < loop_cnt; i++) {
		arr[i] = VECTOR_ALU;
	}

	rec_cnt = rec_cnt + configs.scalar_mem;
	loop_cnt = (rec_cnt * configs.instr_count)/tot;

	for(; i < loop_cnt; i++) {
		arr[i] = SCALAR_MEM;
	}

	rec_cnt = rec_cnt + configs.vector_mem;
	loop_cnt = (rec_cnt * configs.instr_count)/tot;

	for(; i < loop_cnt; i++) {
		arr[i] = VECTOR_MEM;
	}
}

