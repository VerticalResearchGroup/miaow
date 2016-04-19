module flag_generator(
  opcode,
  fu,
  wf_halt,
  wf_barrier,
  wf_branch,
  wf_waitcnt,
  scc_write,
  scc_read,
  vcc_write,
  vcc_read,
  exec_write,
  exec_read,
  M0_write,
  M0_read,
  s1_width,
  s2_width,
  s3_width,
  s4_width,
  dest1_width,
  dest2_width,
  fp_instr,
  copy_d1_to_s4,
  copy_d1_to_s3,
  copy_d1_to_s1,
  ext_literal_s3,
  d1_vdst_to_sdst
);

input [31:0] opcode;
input [1:0] fu;

output wf_halt;
output wf_barrier;
output wf_branch;
output wf_waitcnt;
output scc_write;
output scc_read;
output vcc_write;
output vcc_read;
output exec_write;
output exec_read;
output M0_write;
output M0_read;
output [2:0] s1_width;
output [2:0] s2_width;
output [2:0] s3_width;
output [2:0] s4_width;
output [2:0] dest1_width;
output [2:0] dest2_width;
output fp_instr;
output copy_d1_to_s4;
output copy_d1_to_s3;
output copy_d1_to_s1;
output ext_literal_s3;
output d1_vdst_to_sdst;

reg wf_halt;
reg wf_barrier;
reg wf_branch;
reg wf_waitcnt;
reg scc_write;
reg scc_read;
reg vcc_write;
reg vcc_read;
reg exec_write;
reg exec_read;
reg M0_write;
reg M0_read;
reg [2:0] s1_width;
reg [2:0] s2_width;
reg [2:0] s3_width;
reg [2:0] s4_width;
reg [2:0] dest1_width;
reg [2:0] dest2_width;
reg fp_instr;
reg copy_d1_to_s4;
reg copy_d1_to_s3;
reg copy_d1_to_s1;
reg ext_literal_s3;
reg d1_vdst_to_sdst;

wire [33:0] instruction_id;

//Opcode
//Bits 31:24 should be retained
//Out of 23:0, atleast 13 higher bits should be masked
//             (MTBUF with 13 flag bits)
//Out of 23:0, atleast 9 bits should be retained
//             (longest operand is 9 bits)
//Current choice: Retain only 9 bits!!
assign instruction_id = {fu,opcode} & {2'b11,8'hff,15'b0,{9{1'b1}}};

always @(*)
begin
  wf_halt <= 1'b0;
  wf_barrier <= 1'b0;
  wf_branch <= 1'b0;
  wf_waitcnt <= 1'b0;
  scc_write <= 1'b0;
  scc_read <= 1'b0;
  vcc_write <= 1'b0;
  vcc_read <= 1'b0;
  exec_write <= 1'b0;
  exec_read <= 1'b0;
  M0_write <= 1'b0;
  M0_read <= 1'b0;
  s1_width <= `DECODE_BIT0;
  s2_width <= `DECODE_BIT0;
  s3_width <= `DECODE_BIT0;
  s4_width <= `DECODE_BIT0;
  dest1_width <= `DECODE_BIT0;
  dest2_width <= `DECODE_BIT0;
  fp_instr <= 1'b0;
  copy_d1_to_s4 <= 1'b0;
  copy_d1_to_s3 <= 1'b0;
  copy_d1_to_s1 <= 1'b0;
  d1_vdst_to_sdst <= 1'b0;
  ext_literal_s3 <= 1'b0;
  casex(instruction_id)
    //SOPP --------------------------------------------
    //SOPP: S_NOP
    {2'b10,8'd1,24'h0}:
      begin
      end
    //SOPP: S_ENDPGM
    {2'b10,8'd1,24'h1}:
      begin
        wf_halt <= 1'b1;
      end
    //SOPP: S_BRANCH
    {2'b10,8'd1,24'h2}:
      begin
        wf_branch <= 1'b1;
      end
    //SOPP: S_CBRANCH_SCC0
    {2'b10,8'd1,24'h4}:
      begin
        wf_branch <= 1'b1;
        scc_read <= 1'b1;
      end
    //SOPP: S_CBRANCH_SCC1
    {2'b10,8'd1,24'h5}:
      begin
        wf_branch <= 1'b1;
        scc_read <= 1'b1;
      end
    //SOPP: S_CBRANCH_VCCZ
    {2'b10,8'd1,24'h6}:
      begin
        wf_branch <= 1'b1;
        vcc_read <= 1'b1;
      end
    //SOPP: S_CBRANCH_VCCNZ
    {2'b10,8'd1,24'h7}:
      begin
        wf_branch <= 1'b1;
        vcc_read <= 1'b1;
      end
    //SOPP: S_CBRANCH_EXECZ
    {2'b10,8'd1,24'h8}:
      begin
        wf_branch <= 1'b1;
        exec_read <= 1'b1;
      end
    //SOPP: S_CBRANCH_EXECNZ
    {2'b10,8'd1,24'h9}:
      begin
        wf_branch <= 1'b1;
        exec_read <= 1'b1;
      end
    //SOPP: S_BARRIER
    {2'b10,8'd1,24'ha}:
      begin
        wf_barrier <= 1'b1;
      end
    //SOPP: S_WAITCNT
    {2'b10,8'd1,24'hc}:
      begin
        wf_waitcnt <= 1'b1;
      end
    //SOP1 --------------------------------------------
    //SOP1: S_MOV_B32
    {2'b10,8'd2,24'h3}:
      begin
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP1: S_MOV_B64
    {2'b10,8'd2,24'h4}:
      begin
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP1: S_CMOV_B32
    {2'b10,8'd2,24'h5}:
      begin
       scc_read <= 1'b1;
       s1_width <= `DECODE_BIT32;
       dest1_width <= `DECODE_BIT32;
      end
    //SOP1: S_NOT_B32
    {2'b10,8'd2,24'h7}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP1: S_NOT_B64
    {2'b10,8'd2,24'h8}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP1: S_BREV_B32
    {2'b10,8'd2,24'hB}:
      begin
        scc_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP1: S_SEXT_I32_I8
    {2'b10,8'd2,24'h19}:
      begin
        scc_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
	dest1_width <= `DECODE_BIT32;
      end
    //SOP1: S_AND_SAVEEXEC_B64
    {2'b10,8'd2,24'h24}:
      begin
        scc_write <= 1'b1;
        exec_write <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP1: S_OR_SAVEEXEC_B64
    {2'b10,8'd2,24'h25}:
      begin
        scc_write <= 1'b1;
        exec_write <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP1: S_XOR_SAVEEXEC_B64
    {2'b10,8'd2,24'h26}:
      begin
        scc_write <= 1'b1;
        exec_write <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP1: S_ANDN2_SAVEEXEC_B64
    {2'b10,8'd2,24'h27}:
      begin
        scc_write <= 1'b1;
        exec_write <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP1: S_ORN2_SAVEEXEC_B64
    {2'b10,8'd2,24'h28}:
      begin
        scc_write <= 1'b1;
        exec_write <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP1: S_NAND_SAVEEXEC_B64
    {2'b10,8'd2,24'h29}:
      begin
        scc_write <= 1'b1;
        exec_write <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP1: S_NOR_SAVEEXEC_B64
    {2'b10,8'd2,24'h2a}:
      begin
        scc_write <= 1'b1;
        exec_write <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP1: S_XNOR_SAVEEXEC_B64
    {2'b10,8'd2,24'h2b}:
      begin
        scc_write <= 1'b1;
        exec_write <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOPC --------------------------------------------
    //SOPC: S_CMP_EQ_I32
    {2'b10,8'd4,24'h0}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
      end
    //SOPC: S_CMP_LG_I32
    {2'b10,8'd4,24'h1}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
      end
    //SOPC: S_CMP_GT_I32
    {2'b10,8'd4,24'h2}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
      end
    //SOPC: S_CMP_GE_I32
    {2'b10,8'd4,24'h3}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
      end
    //SOPC: S_CMP_LT_I32
    {2'b10,8'd4,24'h4}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
      end
    //SOPC: S_CMP_LE_I32
    {2'b10,8'd4,24'h5}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
      end
    //SOPC: S_CMP_EQ_U32
    {2'b10,8'd4,24'h6}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
      end
    //SOPC: S_CMP_LG_U32
    {2'b10,8'd4,24'h7}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
      end
    //SOPC: S_CMP_GT_U32
    {2'b10,8'd4,24'h8}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
      end
    //SOPC: S_CMP_GE_U32
    {2'b10,8'd4,24'h9}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
      end
    //SOPC: S_CMP_LT_U32
    {2'b10,8'd4,24'ha}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
      end
    //SOPC: S_CMP_LE_U32
    {2'b10,8'd4,24'hb}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
      end
    //SOP2 --------------------------------------------
    //SOP2: S_ADD_U32
    {2'b10,8'd8,24'h0}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_SUB_U32
    {2'b10,8'd8,24'h1}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_ADD_I32
    {2'b10,8'd8,24'h2}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_SUB_I32
    {2'b10,8'd8,24'h3}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_ADDC_U32
    {2'b10,8'd8,24'h4}:
      begin
        scc_write <= 1'b1;
        scc_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_SUBB_U32
    {2'b10,8'd8,24'h5}:
      begin
        scc_write <= 1'b1;
        scc_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_MIN_I32
    {2'b10,8'd8,24'h6}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_MIN_U32
    {2'b10,8'd8,24'h7}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_MAX_I32
    {2'b10,8'd8,24'h8}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_MAX_U32
    {2'b10,8'd8,24'h9}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_CSELECT_B32
    {2'b10,8'd8,24'hA}:
      begin
	scc_read <= 1'b1;
	s1_width <= `DECODE_BIT32;
	s2_width <= `DECODE_BIT32;
	dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_AND_B32
    {2'b10,8'd8,24'he}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_AND_B64
    {2'b10,8'd8,24'hf}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP2: S_OR_B32
    {2'b10,8'd8,24'h10}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_OR_B64
    {2'b10,8'd8,24'h11}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP2: S_XOR_B32
    {2'b10,8'd8,24'h12}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_XOR_B64
    {2'b10,8'd8,24'h13}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP2: S_ANDN2_B32
    {2'b10,8'd8,24'h14}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_ANDN2_B64
    {2'b10,8'd8,24'h15}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP2: S_ORN2_B32
    {2'b10,8'd8,24'h16}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_ORN2_B64
    {2'b10,8'd8,24'h17}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP2: S_NAND_B32
    {2'b10,8'd8,24'h18}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_NAND_B64
    {2'b10,8'd8,24'h19}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP2: S_NOR_B32
    {2'b10,8'd8,24'h1a}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_NOR_B64
    {2'b10,8'd8,24'h1b}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP2: S_XNOR_B32
    {2'b10,8'd8,24'h1c}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_XNOR_B64
    {2'b10,8'd8,24'h1d}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP2: S_LSHL_B32
    {2'b10,8'd8,24'h1e}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_LSHL_B64
    {2'b10,8'd8,24'h1f}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP2: S_LSHR_B32
    {2'b10,8'd8,24'h20}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_LSHR_B64
    {2'b10,8'd8,24'h21}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP2: S_ASHR_I32
    {2'b10,8'd8,24'h22}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOP2: S_ASHR_I64
    {2'b10,8'd8,24'h23}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //SOP2: S_MUL_I32
    {2'b10,8'd8,24'h26}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SOPK --------------------------------------------
    //SOPK: S_MOVK_I32
    {2'b10,8'd16,24'h0}:
      begin
        dest1_width <= `DECODE_BIT32;
      end
    //SOPK: S_ADDK_I32
    {2'b10,8'd16,24'hf}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        copy_d1_to_s1 <= 1'b1;
      end
    //SOPK: S_MULK_I32
    {2'b10,8'd16,24'h10}:
      begin
        scc_write <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        copy_d1_to_s1 <= 1'b1;
      end
    //VOPC --------------------------------------------
    //VOPC: V_CMP/CMPX/CMPS/CMPSX_{OP16}_F32/64 (128 instructions)
    //OP16: F,LT,EQ,LE,GT,LG,GE,O,U,NGE,NLG,NGT,NLE,NEQ,NLT,TRU
    {2'b01,8'd1,16'h0,8'b0???_????}:
      begin
        vcc_write <= 1'b1;
        exec_write <= opcode[4] ? 1'b1 : 1'b0;
        exec_read <= 1'b1;
        s1_width <= opcode[5] ? `DECODE_BIT64 : `DECODE_BIT32;
        s2_width <= opcode[5] ? `DECODE_BIT64 : `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOPC: V_CMP/CMPX_{OP8}_I/U32/64 (64 instructions)
    //OP8: F,LT,EQ,LE,GT,LG,GE,TRU
    {2'b01,8'd1,16'h0,8'b1???_0???}:
      begin
        vcc_write <= 1'b1;
        exec_write <= opcode[4] ? 1'b1 : 1'b0;
        exec_read <= 1'b1;
        s1_width <= opcode[5] ? `DECODE_BIT64 : `DECODE_BIT32;
        s2_width <= opcode[5] ? `DECODE_BIT64 : `DECODE_BIT32;
      end
    //VOP1 --------------------------------------------
    //VOP1: V_NOP
    {2'b01,8'd2,24'h0}:
      begin
      end
    //VOP1: V_MOV_B32
    {2'b01,8'd2,24'h1}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP1: V_CVT_I32_F64
    {2'b01,8'd2,24'h3}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_CVT_F64_I32
    {2'b01,8'd2,24'h4}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP1: V_CVT_F32_I32
    {2'b01,8'd2,24'h5}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_CVT_F32_U32
    {2'b01,8'd2,24'h6}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_CVT_U32_F32
    {2'b01,8'd2,24'h7}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_CVT_I32_F32
    {2'b01,8'd2,24'h8}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_CVT_F16_F32
    {2'b01,8'd2,24'ha}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_CVT_F32_F16
    {2'b01,8'd2,24'hb}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_CVT_F32_F64
    {2'b01,8'd2,24'hf}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_CVT_F64_F32
    {2'b01,8'd2,24'h10}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP1: V_CVT_U32_F64
    {2'b01,8'd2,24'h15}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_CVT_F64_U32
    {2'b01,8'd2,24'h16}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP1: V_FRAC_F32
    {2'b01,8'd2,24'h20}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_TRUNC_F32
    {2'b01,8'd2,24'h21}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_CEIL_F32
    {2'b01,8'd2,24'h22}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_RNDNE_F32
    {2'b01,8'd2,24'h23}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_FLOOR_F32
    {2'b01,8'd2,24'h24}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_EXP_F32
    {2'b01,8'd2,24'h25}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_LOG_CLAMP_F32
    {2'b01,8'd2,24'h26}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_LOG_F32
    {2'b01,8'd2,24'h27}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_RCP_CLAMP_F32
    {2'b01,8'd2,24'h28}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_RCP_F32
    {2'b01,8'd2,24'h2a}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_RSQ_CLAMP_F32
    {2'b01,8'd2,24'h2c}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_RSQ_F32
    {2'b01,8'd2,24'h2e}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_RCP_F64
    {2'b01,8'd2,24'h2f}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP1: V_RCP_CLAMP_F64
    {2'b01,8'd2,24'h30}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP1: V_RSQ_F64
    {2'b01,8'd2,24'h31}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP1: V_RSQ_CLAMP_F64
    {2'b01,8'd2,24'h32}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP1: V_SQRT_F32
    {2'b01,8'd2,24'h33}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_SQRT_F64
    {2'b01,8'd2,24'h34}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP1: V_SIN_F32
    {2'b01,8'd2,24'h35}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_COS_F32
    {2'b01,8'd2,24'h36}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP1: V_NOT_B32
    {2'b01,8'd2,24'h37}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP1: V_BFREV_B32
    {2'b01,8'd2,24'h38}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP1: V_FFBH_U32
    {2'b01,8'd2,24'h39}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP1: V_FFBL_B32
    {2'b01,8'd2,24'h3a}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP1: V_FFBH_I32
    {2'b01,8'd2,24'h3b}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP1: V_FRACT_F64
    {2'b01,8'd2,24'h3e}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP2 --------------------------------------------
    //VOP2: V_CNDMASK_B32
    {2'b01,8'd4,24'h0}:
      begin
        vcc_read <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_READLINE_B32
    {2'b01,8'd4,24'h1}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_WRITELINE_B32
    {2'b01,8'd4,24'h2}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_ADD_F32
    {2'b01,8'd4,24'h3}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP2: V_SUB_F32
    {2'b01,8'd4,24'h4}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP2: V_SUBREV_F32
    {2'b01,8'd4,24'h5}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP2: V_MUL_F32
    {2'b01,8'd4,24'h8}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP2: V_MUL_I32_I24
    {2'b01,8'd4,24'h9}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_MUL_HI_I32_I24
    {2'b01,8'd4,24'ha}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_MUL_U32_U24
    {2'b01,8'd4,24'hb}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_MUL_HI_U32_U24
    {2'b01,8'd4,24'hc}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_MIN_F32
    {2'b01,8'd4,24'hf}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP2: V_MAX_F32
    {2'b01,8'd4,24'h10}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP2: V_MADMK_F32 - VIN
    {2'b01,8'd4,24'h20}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
				ext_literal_s3 <= 1'b1;
      end
    //VOP2: V_MIN_I32
    {2'b01,8'd4,24'h11}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_MAX_I32
    {2'b01,8'd4,24'h12}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_MIN_U32
    {2'b01,8'd4,24'h13}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_MAX_U32
    {2'b01,8'd4,24'h14}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_LSHR_B32
    {2'b01,8'd4,24'h15}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_LSHRREV_B32
    {2'b01,8'd4,24'h16}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_ASHR_I32
    {2'b01,8'd4,24'h17}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_ASHRREV_I32
    {2'b01,8'd4,24'h18}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_LSHL_B32
    {2'b01,8'd4,24'h19}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_LSHLREV_B32
    {2'b01,8'd4,24'h1a}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_AND_B32
    {2'b01,8'd4,24'h1b}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_OR_B32
    {2'b01,8'd4,24'h1c}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_XOR_B32
    {2'b01,8'd4,24'h1d}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_BFM_B32
    {2'b01,8'd4,24'h1e}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_MAC_F32  - VIN
    {2'b01,8'd4,24'h1f}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32; // `DECODE_BIT0
        s4_width <= `DECODE_BIT32; 
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
        copy_d1_to_s4 <= 1'b1;
        copy_d1_to_s3 <= 1'b1;
      end
    //VOP2: V_ADD_I32
    {2'b01,8'd4,24'h25}:
      begin
        vcc_write <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_SUB_I32
    {2'b01,8'd4,24'h26}:
      begin
        vcc_write <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_SUBREV_I32
    {2'b01,8'd4,24'h27}:
      begin
        vcc_write <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_ADDC_U32
    {2'b01,8'd4,24'h28}:
      begin
        vcc_write <= 1'b1;
        vcc_read <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_SUBB_U32
    {2'b01,8'd4,24'h29}:
      begin
        vcc_write <= 1'b1;
        vcc_read <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP2: V_SUBBREV_U32
    {2'b01,8'd4,24'h2a}:
      begin
        vcc_write <= 1'b1;
        vcc_read <= 1'b1;
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3b --------------------------------------------
    //VOP3b (from VOP2): V_ADD_I32
    {2'b01,8'd8,24'h125}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        dest2_width <= `DECODE_BIT32;
      end
    //VOP3b (from VOP2): V_SUB_I32
    {2'b01,8'd8,24'h126}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        dest2_width <= `DECODE_BIT32;
      end
    //VOP3b (from VOP2): V_SUBREV_I32
    {2'b01,8'd8,24'h127}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        dest2_width <= `DECODE_BIT32;
      end
    //VOP3b (from VOP2): V_ADDC_U32
    {2'b01,8'd8,24'h128}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        dest2_width <= `DECODE_BIT32;
      end
    //VOP3b (from VOP2): V_SUBB_U32
    {2'b01,8'd8,24'h129}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        dest2_width <= `DECODE_BIT32;
      end
    //VOP3b (from VOP2): V_SUBBREV_U32
    {2'b01,8'd8,24'h12a}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        dest2_width <= `DECODE_BIT32;
      end
    //VOP3a --------------------------------------------
    //VOP3a (from VOPC): V_CMP/CMPX/CMPS/CMPSX_{OP16}_F32/64 (128 instructions)
    //OP16: F,LT,EQ,LE,GT,LG,GE,O,U,NGE,NLG,NGT,NLE,NEQ,NLT,TRU
    {2'b01,8'd16,16'h0,8'b0???_????}:
      begin
        exec_write <=opcode[4] ? 1'b1 : 1'b0;
        exec_read <= 1'b1;
        s1_width <= opcode[5] ? `DECODE_BIT64 : `DECODE_BIT32;
        s2_width <= opcode[5] ? `DECODE_BIT64 : `DECODE_BIT32;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
        d1_vdst_to_sdst <= 1'b1;
      end
    //VOP3a (from VOPC): V_CMP/CMPX_{OP8}_I/U32/64 (64 instructions)
    //OP8: F,LT,EQ,LE,GT,LG,GE,TRU
    {2'b01,8'd16,16'h0,8'b1???_0???}:
      begin
        exec_write <=opcode[4] ? 1'b1 : 1'b0;
        exec_read <= 1'b1;
        s1_width <= opcode[5] ? `DECODE_BIT64 : `DECODE_BIT32;
        s2_width <= opcode[5] ? `DECODE_BIT64 : `DECODE_BIT32;
        dest1_width <= `DECODE_BIT64;
        d1_vdst_to_sdst <= 1'b1;
      end
    //VOP3a (from VOP2): V_CNDMASK_B32
    {2'b01,8'd16,24'h100}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_READLINE_B32
    {2'b01,8'd16,24'h101}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_WRITELINE_B32
    {2'b01,8'd16,24'h102}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_ADD_F32
    {2'b01,8'd16,24'h103}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP2): V_SUB_F32
    {2'b01,8'd16,24'h104}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP2): V_SUBREV_F32
    {2'b01,8'd16,24'h105}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP2): V_MUL_F32
    {2'b01,8'd16,24'h108}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP2): V_MUL_I32_I24
    {2'b01,8'd16,24'h109}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_MUL_HI_I32_I24
    {2'b01,8'd16,24'h10a}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_MUL_U32_U24
    {2'b01,8'd16,24'h10b}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_MUL_HI_U32_U24
    {2'b01,8'd16,24'h10c}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_MIN_F32
    {2'b01,8'd16,24'h10f}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP2): V_MAX_F32
    {2'b01,8'd16,24'h110}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP2): V_MIN_I32
    {2'b01,8'd16,24'h111}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_MAX_I32
    {2'b01,8'd16,24'h112}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_MIN_U32
    {2'b01,8'd16,24'h113}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_MAX_U32
    {2'b01,8'd16,24'h114}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_LSHR_B32
    {2'b01,8'd16,24'h115}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_LSHRREV_B32
    {2'b01,8'd16,24'h116}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_ASHR_I32
    {2'b01,8'd16,24'h117}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_ASHRREV_I32
    {2'b01,8'd16,24'h118}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_LSHL_B32
    {2'b01,8'd16,24'h119}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_LSHLREV_B32
    {2'b01,8'd16,24'h11a}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_AND_B32
    {2'b01,8'd16,24'h11b}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_OR_B32
    {2'b01,8'd16,24'h11c}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_XOR_B32
    {2'b01,8'd16,24'h11d}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_BFM_B32
    {2'b01,8'd16,24'h11e}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP2): V_MAC_F32
    {2'b01,8'd16,24'h11f}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s4_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
        copy_d1_to_s4 <= 1'b1;
      end
    //VOP3a: V_MAD_F32
    {2'b01,8'd16,24'h141}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a: V_MAD_I32_I24
    {2'b01,8'd16,24'h142}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_MAD_U32_U24
    {2'b01,8'd16,24'h143}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_BFE_U32
    {2'b01,8'd16,24'h148}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_BFE_I32
    {2'b01,8'd16,24'h149}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_BFI_B32
  {2'b01,8'd16,24'h14a}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_FMA_F32
    {2'b01,8'd16,24'h14b}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a: V_FMA_F64
    {2'b01,8'd16,24'h14c}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        s3_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a: V_MIN3_F32
    {2'b01,8'd16,24'h151}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a: V_MIN3_I32
    {2'b01,8'd16,24'h152}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_MIN3_U32
    {2'b01,8'd16,24'h153}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_MAX3_F32
    {2'b01,8'd16,24'h154}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a: V_MAX3_I32
    {2'b01,8'd16,24'h155}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_MAX3_U32
    {2'b01,8'd16,24'h156}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_MED3_F32
    {2'b01,8'd16,24'h157}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a: V_MED3_I32
    {2'b01,8'd16,24'h158}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_MED3_U32
    {2'b01,8'd16,24'h159}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_LSHL_B64
    {2'b01,8'd16,24'h161}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //VOP3a: V_LSHR_B64
    {2'b01,8'd16,24'h162}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //VOP3a: V_ASHR_I64
    {2'b01,8'd16,24'h163}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
      end
    //VOP3a (from VOP1): V_NOP
    {2'b01,8'd16,24'h180}:
      begin
      end
    //VOP3a (from VOP1): V_MOV_B32
    {2'b01,8'd16,24'h181}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP1): V_CVT_I32_F64
    {2'b01,8'd16,24'h183}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_CVT_F64_I32
    {2'b01,8'd16,24'h184}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_CVT_F32_I32
    {2'b01,8'd16,24'h185}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_CVT_F32_U32
    {2'b01,8'd16,24'h186}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_CVT_U32_F32
    {2'b01,8'd16,24'h187}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_CVT_I32_F32
    {2'b01,8'd16,24'h188}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_CVT_F16_F32
    {2'b01,8'd16,24'h18a}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_CVT_F32_F16
    {2'b01,8'd16,24'h18b}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_CVT_F32_F64
    {2'b01,8'd16,24'h18f}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_CVT_F64_F32
    {2'b01,8'd16,24'h190}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_CVT_U32_F64
    {2'b01,8'd16,24'h195}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_CVT_F64_U32
    {2'b01,8'd16,24'h196}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_FRAC_F32
    {2'b01,8'd16,24'h1a0}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_TRUNC_F32
    {2'b01,8'd16,24'h1a1}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_CEIL_F32
    {2'b01,8'd16,24'h1a2}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_RNDNE_F32
    {2'b01,8'd16,24'h1a3}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_FLOOR_F32
    {2'b01,8'd16,24'h1a4}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_EXP_F32
    {2'b01,8'd16,24'h1a5}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_LOG_CLAMP_F32
    {2'b01,8'd16,24'h1a6}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_LOG_F32
    {2'b01,8'd16,24'h1a7}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_RCP_CLAMP_F32
    {2'b01,8'd16,24'h1a8}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_RCP_F32
    {2'b01,8'd16,24'h1aa}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_RSQ_CLAMP_F32
    {2'b01,8'd16,24'h1ac}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_RSQ_F32
    {2'b01,8'd16,24'h1ae}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_RCP_F64
    {2'b01,8'd16,24'h1af}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_RCP_CLAMP_F64
    {2'b01,8'd16,24'h1b0}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_RSQ_F64
    {2'b01,8'd16,24'h1b1}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_RSQ_CLAMP_F64
    {2'b01,8'd16,24'h1b2}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_SQRT_F32
    {2'b01,8'd16,24'h1b3}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_SQRT_F64
    {2'b01,8'd16,24'h1b4}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_SIN_F32
    {2'b01,8'd16,24'h1b5}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_COS_F32
    {2'b01,8'd16,24'h1b6}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
        fp_instr <= 1'b1;
      end
    //VOP3a (from VOP1): V_NOT_B32
    {2'b01,8'd16,24'h1b7}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP1): V_BFREV_B32
    {2'b01,8'd16,24'h1b8}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP1): V_FFBH_U32
    {2'b01,8'd16,24'h1b9}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP1): V_FFBL_B32
    {2'b01,8'd16,24'h1ba}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP1): V_FFBH_I32
    {2'b01,8'd16,24'h1bb}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a (from VOP1): V_FRACT_F64
    {2'b01,8'd16,24'h1be}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a: V_ADD_F64
    {2'b01,8'd16,24'h164}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a: V_MUL_F64
    {2'b01,8'd16,24'h165}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a: V_MIN_F64
    {2'b01,8'd16,24'h166}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a: V_MAX_F64
    {2'b01,8'd16,24'h167}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT64;
        s2_width <= `DECODE_BIT64;
        dest1_width <= `DECODE_BIT64;
        fp_instr <= 1'b1;
      end
    //VOP3a: V_MUL_LO_U32
    {2'b01,8'd16,24'h169}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_MUL_HI_U32
    {2'b01,8'd16,24'h16a}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_MUL_LO_I32
    {2'b01,8'd16,24'h16b}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //VOP3a: V_MUL_HI_I32
    {2'b01,8'd16,24'h16c}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SMRD --------------------------------------------
    //SMRD: S_LOAD_DWORD
    {2'b11,8'd1,24'h0}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //SMRD: S_LOAD_DWORDX2
    {2'b11,8'd1,24'h1}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT64;
      end
    //SMRD: S_LOAD_DWORDX4
    {2'b11,8'd1,24'h2}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT128;
      end
    //SMRD: S_LOAD_DWORDX8
    {2'b11,8'd1,24'h3}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT256;
      end
    //SMRD: S_LOAD_DWORDX16
    {2'b11,8'd1,24'h4}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT512;
      end
    //SMRD: S_BUFFER_LOAD_DWORD
    {2'b11,8'd1,24'h8}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT128;
        dest1_width <= `DECODE_BIT32;
      end
    //SMRD: S_BUFFER_LOAD_DWORDX2
    {2'b11,8'd1,24'h9}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT128;
        dest1_width <= `DECODE_BIT64;
      end
    //SMRD: S_BUFFER_LOAD_DWORDX4
    {2'b11,8'd1,24'ha}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT128;
        dest1_width <= `DECODE_BIT128;
      end
    //SMRD: S_BUFFER_LOAD_DWORDX8
    {2'b11,8'd1,24'hb}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT128;
        dest1_width <= `DECODE_BIT256;
      end
    //SMRD: S_BUFFER_LOAD_DWORDX16
    {2'b11,8'd1,24'hc}:
      begin
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT128;
        dest1_width <= `DECODE_BIT512;
      end
    //LDS/GDS --------------------------------------------
    //LDS/GDS: DS_WRITE_B32
    {2'b11,8'd2,24'hd}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
      end
    //LDS/GDS: DS_READ_B32
    {2'b11,8'd2,24'h36}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        dest1_width <= `DECODE_BIT32;
      end
    //MTBUF --------------------------------------------
    //MTBUF: TBUFFER_LOAD_FORMAT_X
    {2'b11,8'd4,24'h0}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        s4_width <= `DECODE_BIT128;
        dest1_width <= `DECODE_BIT32;
      end
    //MTBUF: TBUFFER_LOAD_FORMAT_XY
    {2'b11,8'd4,24'h1}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        s4_width <= `DECODE_BIT128;
        dest1_width <= `DECODE_BIT64;
      end
    //MTBUF: TBUFFER_LOAD_FORMAT_XYZ
    {2'b11,8'd4,24'h2}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        s4_width <= `DECODE_BIT128;
        dest1_width <= `DECODE_BIT96;
      end
    //MTBUF: TBUFFER_LOAD_FORMAT_XYZW
    {2'b11,8'd4,24'h3}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        s4_width <= `DECODE_BIT128;
        dest1_width <= `DECODE_BIT128;
      end
    //MTBUF: TBUFFER_STORE_FORMAT_X
    {2'b11,8'd4,24'h4}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT32;
        s3_width <= `DECODE_BIT32;
        s4_width <= `DECODE_BIT128;
      end
    //MTBUF: TBUFFER_STORE_FORMAT_XY
    {2'b11,8'd4,24'h5}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT64;
        s3_width <= `DECODE_BIT32;
        s4_width <= `DECODE_BIT128;
      end
    //MTBUF: TBUFFER_STORE_FORMAT_XYZ
    {2'b11,8'd4,24'h6}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT96;
        s3_width <= `DECODE_BIT32;
        s4_width <= `DECODE_BIT128;
      end
    //MTBUF: TBUFFER_STORE_FORMAT_XYZW
    {2'b11,8'd4,24'h7}:
      begin
        exec_read <= 1'b1;
        s1_width <= `DECODE_BIT32;
        s2_width <= `DECODE_BIT128;
        s3_width <= `DECODE_BIT32;
        s4_width <= `DECODE_BIT128;
      end
  endcase
end
endmodule
