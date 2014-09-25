#include "asm.h"

int setSregSrc() {
	int r = rand()%5;

	if(r < 3) {
		return rand() % configs.scalar_reg;
	}
	else {
		switch(rand()%7) {
			// vcc_hi or vcc_lo
			case 0: return (106 + rand()%2);
			// m0
			case 1: return 124;
			// exec_hi or exec_lo
			case 2: return (126 + rand()%2);
			// 0 to 65
			case 3: return (128 + rand()%65);
			// -1 to -16
			case 4: return (193 + rand()%16);
			// vccz, execz or scc
			case 5: return (251 + rand()%3);
			//lit_cnst
			case 6: return 255;
		}
	}

	return 0;
}

int setSregDest() {
	int r = rand()%5;

	if(r < 4) {
		return rand() % configs.scalar_reg;
	}
	else {
		switch(rand()%3) {
			// vcc_hi or vcc_lo
			case 0: return (106 + rand()%2);
			// m0
			case 1: return 124;
			// exec_hi or exec_lo
			case 2: return (126 + rand()%2);
		}
	}

	return 0;
}

void randomizeOperand() {
	int s_or_v1, s_or_v2, s_or_v3;	
	int minreg = configs.scalar_reg < configs.vector_reg ? 
					configs.scalar_reg : configs.vector_reg;

	opvals.imm = rand() % 2;
	opvals.offen = rand() % 2;

	opvals.imm16 = rand() % MAX_IMM_VAL;
	opvals.lit_cnst = rand() % MAX_IMM_VAL;
	opvals.sdest = setSregDest();
	opvals.ssrc0 = setSregSrc();
	opvals.ssrc1 = setSregSrc();
	opvals.vdest = rand() % configs.vector_reg;
	opvals.sbase = ((rand() % configs.scalar_reg)/2);
	opvals.sbase2 = ((rand() % configs.scalar_reg)/4);

	// conservative choice for use in smrd/mtbuf
	opvals.offset = rand() % configs.scalar_reg;
	opvals.offset12 = rand() % MAX_IMM_VAL;

	s_or_v1 = rand() % 2;
	if(s_or_v1 == 0) {
		opvals.src0 = setSregSrc();
	}
	else {
		opvals.src0 = 256 + (rand() % configs.vector_reg);
	}

	s_or_v2 = (s_or_v1 == 0) ? 1 : rand() % 2;
	if(s_or_v2 == 0) {
		opvals.src1 = setSregSrc();
	}
	else {
		opvals.src1 = 256 + (rand() % configs.vector_reg);
	}

	s_or_v3 = (s_or_v1 == 0 || s_or_v2 == 0) ? 1 : rand() % 2;
	if(s_or_v3 == 0) {
		opvals.src2 = setSregSrc();
	}
	else {
		opvals.src2 = 256 + (rand() % configs.vector_reg);
	}

	opvals.vsrc1 = rand() % configs.vector_reg;
	opvals.vsrc2 = rand() % configs.vector_reg;
	opvals.v3adt = rand() % minreg;
}

void add5scalarinstrs() {
	int i;
	
	// adding 5 mov instructions
	for(i = 0; i < 5; i++) {
		randomizeOperand();
		instruction_sop1(3);
	}
}

void instruction_sopp(int opcode) {
	union si_inst_microcode_t instr;

	instr.sopp.simm16 = (opcode == 1) ? 0 : (opvals.imm16%5);
	instr.sopp.op = opcode;
	instr.sopp.enc = 0x17F; // 1 0111 1111

	randomizeOperand();
	instruction_vop2(0x25);
	printInstruction32(&instr);
	add5scalarinstrs();
}

void instruction_sopp_endpgm() {
	union si_inst_microcode_t instr;

	instr.sopp.simm16 = 0;
	instr.sopp.op = 1;
	instr.sopp.enc = 0x17F; // 1 0111 1111

	printInstruction32(&instr);
}

void instruction_sop1(int opcode) {
	union si_inst_microcode_t instr;

	instr.sop1.ssrc0 = (opcode == 0x24 || opcode == 0x04) ? (rand()%configs.scalar_reg/2)*2 : opvals.ssrc0;
	instr.sop1.op = opcode;
	instr.sop1.sdst = (opcode == 0x24 || opcode == 0x04) ? (rand()%configs.scalar_reg/2)*2 : opvals.sdest;
	instr.sop1.enc = 0x17D; // 1 0111 1101
	instr.sop1.lit_cnst = opvals.lit_cnst;
	
	if(instr.sop1.ssrc0 == 255) printInstruction64(&instr); 
	else printInstruction32(&instr);
}

void instruction_sop2(int opcode) {
	union si_inst_microcode_t instr;

	instr.sop2.ssrc0 = (opcode == 0x15 || opcode == 0x0F) ? (rand()%configs.scalar_reg/2)*2 : opvals.ssrc0;
	instr.sop2.ssrc1 = (opcode == 0x15 || opcode == 0x0F) ? (rand()%configs.scalar_reg/2)*2 : opvals.ssrc1;
	instr.sop2.sdst = (opcode == 0x15 || opcode == 0x0F) ? (rand()%configs.scalar_reg/2)*2 : opvals.sdest;
	instr.sop2.op = opcode;
	instr.sop2.enc = 0x2; // 10
	instr.sop2.lit_cnst = opvals.lit_cnst;
	
	if(instr.sop2.ssrc0 == 255 || instr.sop2.ssrc1 == 255) 
		printInstruction64(&instr); 
	else printInstruction32(&instr);
}

void instruction_sopk(int opcode) {
	union si_inst_microcode_t instr;

	instr.sopk.simm16 = opvals.imm16;
    instr.sopk.sdst = opvals.sdest;
    instr.sopk.op = opcode;
    instr.sopk.enc = 0xB; // 1011
	
	printInstruction32(&instr);
}

void instruction_sopc(int opcode) {
	union si_inst_microcode_t instr;

	instr.sopc.ssrc0 = opvals.ssrc0;
    instr.sopc.ssrc1 = opvals.ssrc1;
    instr.sopc.op = opcode;
    instr.sopc.enc = 0x17E; // 1 0111 1110
    instr.sopc.lit_cnst = opvals.lit_cnst;
	
	if(instr.sopc.ssrc0 == 255 || instr.sopc.ssrc1 == 255) 
		printInstruction64(&instr); 
	else printInstruction32(&instr);
}

void instruction_vop1(int opcode) {
	union si_inst_microcode_t instr;

	instr.vop1.src0 = opvals.src0;
	instr.vop1.op = opcode;
	instr.vop1.vdst = opvals.vdest;
	instr.vop1.enc = 0x3F; // 011 1111
	instr.vop1.lit_cnst = opvals.lit_cnst;
	
	if(instr.vop1.src0 == 255) printInstruction64(&instr); 
	else printInstruction32(&instr);
}

void instruction_vop2(int opcode) {
	union si_inst_microcode_t instr;

	instr.vop2.src0 = opvals.src0;
	instr.vop2.vsrc1 = opvals.vsrc1;
	instr.vop2.vdst = opvals.vdest;
	instr.vop2.op = opcode;
	instr.vop2.enc = 0x0; // 0
	instr.vop2.lit_cnst = opvals.lit_cnst;
	
	if(instr.vop2.src0 == 255) printInstruction64(&instr); 
	else printInstruction32(&instr);
}

void instruction_vopc(int opcode) {
	union si_inst_microcode_t instr;

	instr.vopc.src0 = opvals.src0;
	instr.vopc.vsrc1 = opvals.vsrc1;
	instr.vopc.op = opcode;
	instr.vopc.enc = 0x3E; // 011 1110
	instr.vopc.lit_cnst = opvals.lit_cnst;
	
	if(instr.vopc.src0 == 255) printInstruction64(&instr); 
	else printInstruction32(&instr);
}

void instruction_vop3a(int opcode) {
	union si_inst_microcode_t instr;

	instr.vop3a.vdst = opvals.v3adt;
    instr.vop3a.abs = opvals.abs;
    instr.vop3a.clamp = 0;
    instr.vop3a.reserved = 0;
    instr.vop3a.op = opcode;
    instr.vop3a.enc = 0x34; // 11 0100
    instr.vop3a.src0 = opvals.src0;
    instr.vop3a.src1 = opvals.src1;
    instr.vop3a.src2 = opvals.src2;
    instr.vop3a.omod = 0;
    instr.vop3a.neg = opvals.neg;
	
	printInstruction64(&instr);
}

void instruction_smrd(int opcode) {
	union si_inst_microcode_t instr;

	instr.smrd.offset = opvals.offset;
	instr.smrd.imm = opvals.imm;
	instr.smrd.sbase = opvals.sbase;
	instr.smrd.sdst = opvals.sdest % configs.scalar_reg;
	instr.smrd.op = opcode;
	instr.smrd.enc = 0x18; // 1 1000

	// s_movk_i32 to sbase*2
	opvals.sdest = opvals.sbase*2;
	opvals.imm16 = 0;
	instruction_sopk(0);

	// s_mov_b32 with lit_cnst to sbase*2 + 1
	opvals.sdest = opvals.sbase*2 + 1;
	opvals.ssrc0 = 255;
	opvals.lit_cnst = (rand() % MAX_IMM_VAL) * 65536;
	instruction_sop1(3);

	// s_movk_i32 to offset (may refer sreg)
	opvals.sdest = opvals.offset;
	opvals.imm16 = rand() % MAX_IMM_VAL;
	instruction_sopk(0);

	printInstruction32(&instr);
}

void instruction_mtbuf(int opcode) {
	union si_inst_microcode_t instr;

	instr.mtbuf.offset = opvals.offset12;
    instr.mtbuf.offen = opvals.offen;
    instr.mtbuf.index = (opvals.offen==1) ? 0 : (rand() % 2);
    instr.mtbuf.glc = 0; // not handled
    instr.mtbuf.addr64 = 0; // not supported by M2S
    instr.mtbuf.op = opcode;
    instr.mtbuf.dfmt = (opcode == 0 || opcode == 4) ? 4 : 14; // hard coded
    instr.mtbuf.nfmt = 0; // hard coded
    instr.mtbuf.enc = 0x3A; // 11 1010
    instr.mtbuf.vaddr = opvals.vdest;
    instr.mtbuf.vdata = opvals.vsrc1;
    instr.mtbuf.srsrc = opvals.sbase2;
    instr.mtbuf.reserved = 0; // not used
    instr.mtbuf.slc = 0; // not handled
    instr.mtbuf.tfe = 0; // not handled
    instr.mtbuf.soffset = opvals.offset;

    // s_movk_i32 to sbase2*4
	opvals.sdest = opvals.sbase2*4;
	opvals.imm16 = 0;
	instruction_sopk(0);

	// s_mov_b32 to sbase2*4 + 1
	opvals.sdest = opvals.sbase2*4 + 1;
	opvals.imm16 = (rand() % MAX_IMM_VAL) * 4;
	instruction_sopk(0);

	// s_mov_b32 to sbase2*4 + 2
	opvals.sdest = opvals.sbase2*4 + 2;
	opvals.imm16 = 0;
	instruction_sopk(0);

	// s_mov_b32 to sbase2*4 + 3
	opvals.sdest = opvals.sbase2*4 + 3;
	opvals.imm16 = 0;
	instruction_sopk(0);

	// v_mov_b32 with lit_cnst to vaddr
	opvals.vdest = opvals.vdest;
	opvals.src0 = 255;
	opvals.lit_cnst = rand() % MAX_IMM_VAL;
	instruction_vop1(1);

	// s_movk_i32 to soffset (may refer sreg)
	opvals.sdest = opvals.offset;
	opvals.imm16 = rand() % MAX_IMM_VAL;
	instruction_sopk(0);

	printInstruction64(&instr);
}

void instruction_ds(int opcode) {
	union si_inst_microcode_t instr;

	instr.ds.offset0 = 0;
    instr.ds.offset1 = 0;
    instr.ds.reserved = 0;
	instr.ds.gds = 0;
	instr.ds.op = opcode;
	instr.ds.enc = 0x36; //11 0110
	instr.ds.addr = opvals.vsrc1;
	instr.ds.data0 = opvals.vsrc2;
	instr.ds.data1 = 0;
	instr.ds.vdst = opvals.vdest;

	printInstruction64(&instr);
}
