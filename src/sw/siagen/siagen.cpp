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

#include <vector>
#ifdef WIN32
#include <Windows.h>
#include <strsafe.h>
#endif

extern operandValues opvals;
extern configValues configs;

std::vector<Instr> sopp_ops = {
  { 0x02, "branch", {true, NO_REG} },
  { 0x04, "cbranch_scc0", {true, REG_SCC} },
  { 0x05, "cbranch_scc1", {true, REG_SCC} },
  { 0x06, "cbranch_vccz", {true, REG_VCCZ} },
  { 0x08, "cbranch_execz", {true, REG_EXECZ} },
  { 0x0A, "barrier", {false, NO_REG} },
  { 0x0C, "waitcnt", {false, NO_REG} }
};

std::vector<Instr> sop1_ops = {
  { 0x03, "mov_b32", {false, NO_REG} },
  { 0x04, "mov_b64", {false, NO_REG} },
  { 0x05, "cmov_b32", {false, REG_SCC} },
  { 0x07, "not_b32", {false, NO_REG} },
  { 0x0B, "brev_b32",{ false, NO_REG } },
  { 0x19, "sext_i32_i8",{ false, NO_REG } },
  { 0x24, "and_saveexec_b64", {false, NO_REG} }
};

std::vector<Instr> sop2_ops = {
  { 0x00, "add_u32", {false, NO_REG} },
  { 0x02, "add_i32", {false, NO_REG} },
  { 0x03, "sub_i32", {false, NO_REG} },
  { 0x07, "min_u32", {false, NO_REG} },
  { 0x09, "max_u32", {false, NO_REG} },
  { 0x0A, "cselect_b32",{ false, REG_SCC } },
  { 0x0E, "and_b32", {false, NO_REG} },
  { 0x0F, "and_b64", {false, NO_REG} },
  { 0x10, "or_b32", {false, NO_REG} },
  { 0x15, "andn2_b64", {false, NO_REG} },
  { 0x1E, "lshl_b32", {false, NO_REG} },
  { 0x20, "lshr_b32", {false, NO_REG} },
  { 0x22, "ashr_i32", {false, NO_REG} },
  { 0x26, "mul_i32", {false, NO_REG} }
};

std::vector<Instr> sopk_ops = {
  { 0x00, "movk_i32", {false, NO_REG} },
  { 0x0F, "addk_i32", {false, NO_REG} },
  { 0x10, "mulk_i32", {false, NO_REG} }
};

std::vector<Instr> sopc_ops = {
  { 0x00, "cmp_eq_i32", {false, NO_REG} },
  { 0x05, "cmp_le_i32", {false, NO_REG} },
  { 0x09, "cmp_ge_u32", {false, NO_REG} },
  { 0x0B, "cmp_le_u32", {false, NO_REG} }
};

std::vector<Instr> vop1_ops = {
  { 0x01, "mov_b32", {false, NO_REG} }//,
  //{ 0x06, "cvt_f32_u32", {false, NO_REG} },
  //{ 0x07, "cvt_u32_f32", {false, NO_REG} },
  //{ 0x2A, "rcp_f32", {false, NO_REG} },
  //{ 0x33, "sqrt_f32", {false, NO_REG} }
};

std::vector<Instr> vop2_ops = {
  { 0x00, "cndmask_b32", {false, NO_REG} },
  { 0x03, "add_f32", {false, NO_REG} },
  { 0x04, "sub_f32", {false, NO_REG} },
  { 0x05, "subrev_f32", {false, NO_REG} },
  { 0x08, "mul_f32", {false, NO_REG} },
  { 0x09, "mul_i32_i24", {false, NO_REG} },
  { 0x16, "lshrrev_b32", {false, NO_REG} },
  { 0x1A, "lshlrev_b32", {false, NO_REG} },
  { 0x1B, "and_b32", {false, NO_REG} },
  { 0x1C, "or_b32", {false, NO_REG} },
  //{ 0x1F, "mac_f32", {false, NO_REG} },
  { 0x25, "add_i32", {false, NO_REG} },
  { 0x26, "sub_i32", {false, NO_REG} }
};

std::vector<Instr> vopc_ops = {
  { 0x04, "cmp_gt_f32", {false, NO_REG} },
  { 0x82, "cmp_eq_i32", {false, NO_REG} },
  { 0x84, "cmp_gt_i32", {false, NO_REG} },
  { 0x85, "cmp_ne_i32", {false, NO_REG} },
  { 0xC3, "cmp_le_u32", {false, NO_REG} },
  { 0xC4, "cmp_gt_u32", {false, NO_REG} }
};

std::vector<Instr> vop3a_ops = {
  { 0x04, "cmp_gt_f32_3a", {false, NO_REG} },
  { 0x82, "cmp_eq_i32_3a", {false, NO_REG} },
  { 0x84, "cmp_gt_i32_3a", {false, NO_REG} },
  { 0x85, "cmp_ne_i32_3a", {false, NO_REG} },
  { 0xC3, "cmp_le_u32_3a", {false, NO_REG} },
  { 0xC4, "cmp_gt_u32_3a", {false, NO_REG} },
  { 0xC6, "cmp_ge_u32_3a", {false, NO_REG} },
  { 0x169, "mul_lo_u32_3a", {false, NO_REG} },
  { 0x16A, "mul_hi_u32_3a", {false, NO_REG} },
  { 0x16B, "mul_lo_i32_3a", {false, NO_REG} }
};

std::vector<Instr> vop3b_ops = {
  { 0, "", {false, NO_REG} }
};

std::vector<Instr> smrd_ops = {
  { 0x02, "ld_dwx4", {false, NO_REG} },
  { 0x08, "buff_ld_dw", {false, NO_REG} },
  { 0x09, "buff_ld_dwx2", {false, NO_REG} }
};

std::vector<Instr> mtbuf_ops = {
  { 0x00, "tbuff_ld_fmt_x", {false, NO_REG} },
  { 0x03, "tbuff_ld_fmt_xyzw", {false, NO_REG} },
  { 0x04, "tbuff_st_fmt_x", {false, NO_REG} },
  { 0x07, "tbuff_st_fmt_xyzw", {false, NO_REG} }
};

std::vector<Instr> mubuf_ops = {
  { 0, "", {false, NO_REG}}
};

std::vector<Instr> ds_ops = {
  { 0x0D, "ds_wr_b32", {false, NO_REG} },
  { 0x36, "ds_rd_b32", {false, NO_REG} }
};

void InitializeOps(si_fmt_enum instr_type, instr_function instr_func, std::vector<Instr> &instr_ops, std::vector<Instr_Sel> &instr_sel_ops)
{
    for (std::vector<Instr>::iterator itr = instr_ops.begin(); itr != instr_ops.end(); ++itr)
    {
        Instr_Sel instr_sel_op;
        instr_sel_op.instr_type = instr_type;
        instr_sel_op.instr = *itr;
        instr_sel_op.instr_func = instr_func;
        instr_sel_ops.push_back(instr_sel_op);
    }
}

int InitializeScalarAluOps(std::vector<Instr_Sel> &instr_sel_ops)
{
    InitializeOps(SI_FMT_SOPP, instruction_sopp, sopp_ops, instr_sel_ops);
    InitializeOps(SI_FMT_SOP1, instruction_sop1, sop1_ops, instr_sel_ops);
    InitializeOps(SI_FMT_SOP2, instruction_sop2, sop2_ops, instr_sel_ops);
    InitializeOps(SI_FMT_SOPK, instruction_sopk, sopk_ops, instr_sel_ops);
    InitializeOps(SI_FMT_SOPC, instruction_sopc, sopc_ops, instr_sel_ops);

    return instr_sel_ops.size();
}

int InitializeVectorAluOps(std::vector<Instr_Sel> &instr_sel_ops)
{
    InitializeOps(SI_FMT_VOP1, instruction_vop1, vop1_ops, instr_sel_ops);
    InitializeOps(SI_FMT_VOP2, instruction_vop2, vop2_ops, instr_sel_ops);
    InitializeOps(SI_FMT_VOPC, instruction_vopc, vopc_ops, instr_sel_ops);
    InitializeOps(SI_FMT_VOP3a, instruction_vop3a, vop3a_ops, instr_sel_ops);
    //InitializeOps(SI_FMT_VOP3b, instruction_vop3b, vop3b_ops, instr_sel_ops); // Not supported yet

    return instr_sel_ops.size();
}

int InitializeScalarMemOps(std::vector<Instr_Sel> &instr_sel_ops)
{
    InitializeOps(SI_FMT_SMRD, instruction_smrd, smrd_ops, instr_sel_ops);

    return instr_sel_ops.size();
}

int InitializeVectorMemOps(std::vector<Instr_Sel> &instr_sel_ops)
{
    InitializeOps(SI_FMT_MTBUF, instruction_mtbuf, mtbuf_ops, instr_sel_ops);
    //InitializeOps(SI_FMT_MUBUF, instruction_mubuf, mubuf_ops, instr_sel_ops); // Not supported yet
    InitializeOps(SI_FMT_DS, instruction_ds, ds_ops, instr_sel_ops);

    return instr_sel_ops.size();
}

void printInstrsInArray(int arr[MAX_INSTR])
{
    std::vector<Instr_Sel> salu_ops;
    std::vector<Instr_Sel> valu_ops;
    std::vector<Instr_Sel> smem_ops;
    std::vector<Instr_Sel> vmem_ops;

    int sa_cnt = InitializeScalarAluOps(salu_ops);
    int va_cnt = InitializeVectorAluOps(valu_ops);
    int sm_cnt = InitializeScalarMemOps(smem_ops);
    int vm_cnt = InitializeVectorMemOps(vmem_ops);

    int i, r, id;
    //Operand_Vals opvals;

    for (i = 0; i < configs.instr_count; i++) {
        randomizeOperand();
        r = rand();

        switch (arr[i])
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

void printOpSpecificUT(int type, std::vector<Instr_Sel> &ops, int cnt)
{
    int i;
#ifdef WIN32
    wchar_t folName[MAX_PATH];
    BOOL status;
#else
    char folName[40];
#endif

    for (i = 0; i < cnt; i++) {
        // create folder
#ifdef WIN32
        StringCbPrintf(folName, MAX_PATH, L"test_%d%02d_%S", type, i, ops[i].instr.op_str);
        status = CreateDirectory(folName, nullptr);
        status = SetCurrentDirectory(folName);
#else
        sprintf(folName, "test_%d%02d_%s", type, i, ops[i].instr.op_str.c_str());
        mkdir(folName, S_IRWXU | S_IRGRP | S_IXGRP);
        chdir(folName);
#endif

        // open output files
        openOutputFiles();

		if (ops[i].instr.instr_dep.branch_flg)
		{

			switch (ops[i].instr.instr_dep.cond_reg)
			{
			case NO_REG:

				//set target to conditional instruction after fillers
				opvals.imm16 = 5;
				ops[i].instr_func(ops[i].instr.opcode);

				//add 5 filler instructions
				add5scalarinstrs();

				break;
			case REG_VCCZ:
				break;
			case REG_EXECZ:
				break;
			case REG_SCC:

				//generate condition scc = 1
				generate_scc(true);

				//set target to conditional instruction after fillers
				opvals.imm16 = 5;
				ops[i].instr_func(ops[i].instr.opcode);

				//add 5 filler instructions
				add5scalarinstrs();

				//generate condition scc = 0
				generate_scc(false);

				//set target to endpgm
				opvals.imm16 = 5;
				ops[i].instr_func(ops[i].instr.opcode);

				//add fillers
				add5scalarinstrs();
				
				break;
			default:
				break;
			}

		}
		else if (!ops[i].instr.instr_dep.branch_flg)
		{
			switch (ops[i].instr.instr_dep.cond_reg)
			{
			case NO_REG:

				randomizeOperand();
				ops[i].instr_func(ops[i].instr.opcode);

				break;
			case REG_VCCZ:
				break;
			case REG_EXECZ:
				break;
			case REG_SCC:

				//generate condition scc = 1
				generate_scc(true);

				randomizeOperand();
				ops[i].instr_func(ops[i].instr.opcode);

				//generate condition scc = 0
				generate_scc(false);

				randomizeOperand();
				ops[i].instr_func(ops[i].instr.opcode);

				break;
			default:
				break;
			}
		}
		else
		{
			// write other instructions
			randomizeOperand();
			ops[i].instr_func(ops[i].instr.opcode);
			
		}
        
		//write endpgm
		instruction_sopp_endpgm();

        // write config and data.mem
        writeConfigFile();
        writeDataMemFile();

        // close output files
        closeOutputFiles();

        // go to parent folder
#ifdef WIN32
        status = SetCurrentDirectory(L"..\\");
#else
        chdir("..");
#endif
    }
}

void printAllUnitTests()
{
    std::vector<Instr_Sel> salu_ops;
    std::vector<Instr_Sel> valu_ops;
    std::vector<Instr_Sel> smem_ops;
    std::vector<Instr_Sel> vmem_ops;

    int sa_cnt = InitializeScalarAluOps(salu_ops);
    int va_cnt = InitializeVectorAluOps(valu_ops);
    int sm_cnt = InitializeScalarMemOps(smem_ops);
    int vm_cnt = InitializeVectorMemOps(vmem_ops);

    printOpSpecificUT(0, salu_ops, sa_cnt);
    printOpSpecificUT(1, valu_ops, va_cnt);
    printOpSpecificUT(2, smem_ops, sm_cnt);
    printOpSpecificUT(3, vmem_ops, vm_cnt);
}

void initializeInstrArr(int *arr, int array_size)
{
    int i;

    int tot = configs.scalar_alu + configs.vector_alu +
        configs.scalar_mem + configs.vector_mem;

    int rec_cnt = configs.scalar_alu;
    int loop_cnt = (rec_cnt * configs.instr_count) / tot;

    for (i = 0; i < loop_cnt; i++) {
        arr[i] = SCALAR_ALU;
    }

    rec_cnt = rec_cnt + configs.vector_alu;
    loop_cnt = (rec_cnt * configs.instr_count) / tot;

    for (; i < loop_cnt; i++) {
        arr[i] = VECTOR_ALU;
    }

    rec_cnt = rec_cnt + configs.scalar_mem;
    loop_cnt = (rec_cnt * configs.instr_count) / tot;

    for (; i < loop_cnt; i++) {
        arr[i] = SCALAR_MEM;
    }

    rec_cnt = rec_cnt + configs.vector_mem;
    loop_cnt = (rec_cnt * configs.instr_count) / tot;

    for (; i < loop_cnt; i++) {
        arr[i] = VECTOR_MEM;
    }
}
