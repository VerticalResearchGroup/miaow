module decode( 
      wave_instr_pc,
      wave_instr_valid,
      wave_instr,
      wave_wfid,
      wave_vgpr_base,
      wave_sgpr_base,
      wave_lds_base,
      issue_wf_halt,
      issue_fu,
      issue_wfid,
      issue_opcode,
      issue_source_reg1,
      issue_source_reg2,
      issue_source_reg3,
      issue_source_reg4,
      issue_dest_reg1,
      issue_dest_reg2,
      issue_imm_value0,
      issue_imm_value1,
      issue_valid,
      issue_instr_pc,
      issue_vcc_wr,
      issue_vcc_rd,
      issue_scc_wr,
      issue_scc_rd,
      issue_exec_rd,
      issue_exec_wr,
      issue_m0_rd,
      issue_m0_wr,
      issue_barrier,
      issue_branch,
      issue_lds_base,
      issue_waitcnt,
      wave_ins_half_rqd,
      wave_ins_half_wfid,
      tracemon_collinstr,
      tracemon_colldone,
      clk,
      rst
 );

input clk;

input rst;

input wave_instr_valid;
input[5:0] wave_wfid;
input[8:0] wave_sgpr_base;
input[9:0] wave_vgpr_base;
input[15:0] wave_lds_base;
input[31:0] wave_instr_pc, wave_instr;

output issue_wf_halt, issue_valid, issue_vcc_wr, issue_vcc_rd, issue_scc_wr,
         issue_scc_rd, issue_exec_rd, issue_exec_wr, issue_m0_rd, issue_m0_wr,
         issue_barrier, issue_branch, issue_waitcnt, wave_ins_half_rqd, tracemon_colldone;
output[1:0] issue_fu;
output[5:0] issue_wfid, wave_ins_half_wfid;
output[15:0] issue_lds_base;
output[12:0] issue_source_reg2, issue_source_reg3, issue_dest_reg2;
output[13:0] issue_source_reg1, issue_source_reg4, issue_dest_reg1;
output[15:0] issue_imm_value0;
output[31:0] issue_opcode, issue_imm_value1, issue_instr_pc;
output[63:0] tracemon_collinstr;

///////////////////////////////
//Your code goes here - beware: script does not recognize changes
// into files. It ovewrites everithing without mercy. Save your work before running the script
///////////////////////////////


wire [31:0] flopped_instr_pc;
wire flopped_instr_valid;
wire [31:0] flopped_instr;
wire [5:0] flopped_wfid;
wire [9:0] flopped_vgpr_base;
wire [8:0] flopped_sgpr_base;
wire [15:0] flopped_lds_base;

//////////////////////////////
wire [63:0] collated_instr;
wire collate_required;
wire collate_done;

wire [9:0] s1_field;
wire [9:0] s2_field;
wire [9:0] s3_field;
wire [9:0] s4_field;
wire [9:0] dest1_field;
wire [9:0] dest2_field;
wire [9:0] dest1_field_converted;
wire [9:0] s4_field_converted;
wire [9:0] s3_field_converted;
wire [9:0] s1_field_converted;

wire [1:0] raw_fu;

wire implicit_scc_write;
wire implicit_scc_read;
wire implicit_vcc_write;
wire implicit_vcc_read;
wire implicit_exec_write;
wire implicit_exec_read;
wire implicit_M0_write;
wire implicit_M0_read;

wire [2:0] s1_width;
wire [2:0] s2_width;
wire [2:0] s3_width;
wire [2:0] s4_width;
wire [2:0] dest1_width;
wire [2:0] dest2_width;
wire fp_instr;
wire copy_d1_to_s4;
wire copy_d1_to_s3;
wire copy_d1_to_s1;
wire d1_vdst_to_sdst;

wire [11:0] encoded_s1_reg;
wire [11:0] encoded_s2_reg;
wire [11:0] encoded_s3_reg;
wire [11:0] encoded_s4_reg;
wire [11:0] encoded_dest1_reg;
wire [11:0] encoded_dest2_reg;

assign issue_lds_base = flopped_lds_base;
assign issue_wfid = flopped_wfid;

wire s1_literal_req;
wire s2_literal_req;
wire s3_literal_req;
wire s4_literal_req;
//Following two wires are dummies
wire dest1_literal_req;
wire dest2_literal_req;

wire s1_explicit_vcc;
wire s2_explicit_vcc;
wire s3_explicit_vcc;
wire s4_explicit_vcc;
wire dest1_explicit_vcc;
wire dest2_explicit_vcc;

wire s1_explicit_exec;
wire s2_explicit_exec;
wire s3_explicit_exec;
wire s4_explicit_exec;
wire dest1_explicit_exec;
wire dest2_explicit_exec;

wire s1_explicit_scc;
wire s2_explicit_scc;
wire s3_explicit_scc;
wire s4_explicit_scc;
wire dest1_explicit_scc;
wire dest2_explicit_scc;

wire s1_explicit_M0;
wire s2_explicit_M0;
wire s3_explicit_M0;
wire s4_explicit_M0;
wire dest1_explicit_M0;
wire dest2_explicit_M0;

wire ext_literal_s3; //VIN

wire long_instr_or_literal_required;
wire [31:0] imm1_frominstr_fromliteral;
reg [31:0] issue_imm_value1;
wire [9:0] s3_field_const; //VIN


wire [32:0] s1_fp_constant;
wire [32:0] s2_fp_constant;
wire [32:0] s3_fp_constant;
wire [32:0] s4_fp_constant;
wire [32:0] dest1_fp_constant;
wire [32:0] dest2_fp_constant;

wire width_qualified_s1_valid;
wire width_qualified_s2_valid;
wire width_qualified_s3_valid;
wire width_qualified_s4_valid;
wire width_qualified_dest1_valid;
wire width_qualified_dest2_valid;

PS_flops_wavepool_decode stage_flops (
  .wave_instr_pc(wave_instr_pc),
  .wave_instr_valid(wave_instr_valid),
  .wave_instr(wave_instr),
  .wave_wfid(wave_wfid),
  .wave_vgpr_base(wave_vgpr_base),
  .wave_sgpr_base(wave_sgpr_base),
  .wave_lds_base(wave_lds_base),
  .flopped_instr_pc(flopped_instr_pc),
  .flopped_instr_valid(flopped_instr_valid),
  .flopped_instr(flopped_instr),
  .flopped_wfid(flopped_wfid),
  .flopped_vgpr_base(flopped_vgpr_base),
  .flopped_sgpr_base(flopped_sgpr_base),
  .flopped_lds_base(flopped_lds_base),
  .clk(clk),
  .rst(rst)
);

assign long_instr_or_literal_required = collate_required | ((~collate_done) & ( ext_literal_s3|s1_literal_req|s2_literal_req|s3_literal_req|s4_literal_req));

instr_collate collater(
  .in_wfid(flopped_wfid),
  .in_instr(flopped_instr),
  .in_valid(flopped_instr_valid),
  .in_pc(flopped_instr_pc),
  .out_instr(collated_instr),
  .out_valid(issue_valid),
  .out_pc(issue_instr_pc),
  .in_long(long_instr_or_literal_required),
  .out_long(collate_done),
  .clk(clk),
  .rst(rst)
);

decode_core core(
  .collated_instr(collated_instr),
  .collate_done(collate_done),
  .collate_required(collate_required),
  .fu(raw_fu),
  .opcode(issue_opcode),
  .imm_value0(issue_imm_value0),
  .imm_value1(imm1_frominstr_fromliteral),
  .s1_field(s1_field),
  .s2_field(s2_field),
  .s3_field(s3_field),
  .s4_field(s4_field),
  .dest1_field(dest1_field),
  .dest2_field(dest2_field)
);

flag_generator flaggen(
  .opcode(issue_opcode),
  .fu(raw_fu),
  .wf_halt(issue_wf_halt),
  .wf_barrier(issue_barrier),
  .wf_branch(issue_branch),
  .wf_waitcnt(issue_waitcnt),
  .scc_write(implicit_scc_write),
  .scc_read(implicit_scc_read),
  .vcc_write(implicit_vcc_write),
  .vcc_read(implicit_vcc_read),
  .exec_write(implicit_exec_write),
  .exec_read(implicit_exec_read),
  .M0_write(implicit_M0_write),
  .M0_read(implicit_M0_read),
  .s1_width(s1_width),
  .s2_width(s2_width),
  .s3_width(s3_width),
  .s4_width(s4_width),
  .dest1_width(dest1_width),
  .dest2_width(dest2_width),
  .fp_instr(fp_instr),
  .copy_d1_to_s4(copy_d1_to_s4),
	.copy_d1_to_s3(copy_d1_to_s3),
  .copy_d1_to_s1(copy_d1_to_s1),
	.ext_literal_s3(ext_literal_s3),
  .d1_vdst_to_sdst(d1_vdst_to_sdst)
);

reg_field_encoder s1_encoder (
  .in(s1_field_converted),
  .sgpr_base(flopped_sgpr_base),
  .vgpr_base(flopped_vgpr_base),
  .out(encoded_s1_reg),
  .literal_required(s1_literal_req),
  .explicit_vcc(s1_explicit_vcc),
  .explicit_exec(s1_explicit_exec),
  .explicit_scc(s1_explicit_scc),
  .explicit_M0(s1_explicit_M0),
  .fp_constant(s1_fp_constant)
);
reg_field_encoder s2_encoder (
  .in(s2_field),
  .sgpr_base(flopped_sgpr_base),
  .vgpr_base(flopped_vgpr_base),
  .out(encoded_s2_reg),
  .literal_required(s2_literal_req),
  .explicit_vcc(s2_explicit_vcc),
  .explicit_exec(s2_explicit_exec),
  .explicit_scc(s2_explicit_scc),
  .explicit_M0(s2_explicit_M0),
  .fp_constant(s2_fp_constant)
);
reg_field_encoder s3_encoder (
  .in(s3_field_converted),
  .sgpr_base(flopped_sgpr_base),
  .vgpr_base(flopped_vgpr_base),
  .out(encoded_s3_reg),
  .literal_required(s3_literal_req),
  .explicit_vcc(s3_explicit_vcc),
  .explicit_exec(s3_explicit_exec),
  .explicit_scc(s3_explicit_scc),
  .explicit_M0(s3_explicit_M0),
  .fp_constant(s3_fp_constant)
);
reg_field_encoder s4_encoder (
  .in(s4_field_converted),
  .sgpr_base(flopped_sgpr_base),
  .vgpr_base(flopped_vgpr_base),
  .out(encoded_s4_reg),
  .literal_required(s4_literal_req),
  .explicit_vcc(s4_explicit_vcc),
  .explicit_exec(s4_explicit_exec),
  .explicit_scc(s4_explicit_scc),
  .explicit_M0(s4_explicit_M0),
  .fp_constant(s4_fp_constant)
);
reg_field_encoder dest1_encoder (
  .in(dest1_field_converted),
  .sgpr_base(flopped_sgpr_base),
  .vgpr_base(flopped_vgpr_base),
  .out(encoded_dest1_reg),
  .literal_required(dest1_literal_req),
  .explicit_vcc(dest1_explicit_vcc),
  .explicit_exec(dest1_explicit_exec),
  .explicit_scc(dest1_explicit_scc),
  .explicit_M0(dest1_explicit_M0),
  .fp_constant(dest1_fp_constant)
);
reg_field_encoder dest2_encoder (
  .in(dest2_field),
  .sgpr_base(flopped_sgpr_base),
  .vgpr_base(flopped_vgpr_base),
  .out(encoded_dest2_reg),
  .literal_required(dest2_literal_req),
  .explicit_vcc(dest2_explicit_vcc),
  .explicit_exec(dest2_explicit_exec),
  .explicit_scc(dest2_explicit_scc),
  .explicit_M0(dest2_explicit_M0),
  .fp_constant(dest2_fp_constant)
);

assign issue_vcc_wr = implicit_vcc_write | dest1_explicit_vcc | dest2_explicit_vcc;
assign issue_vcc_rd = implicit_vcc_read | s1_explicit_vcc | s2_explicit_vcc | s3_explicit_vcc | s4_explicit_vcc;
assign issue_scc_wr = implicit_scc_write | dest1_explicit_scc | dest2_explicit_scc;
assign issue_scc_rd = implicit_scc_read | s1_explicit_scc | s2_explicit_scc | s3_explicit_scc | s4_explicit_scc;
assign issue_exec_wr = implicit_exec_write | dest1_explicit_exec | dest2_explicit_exec;
assign issue_exec_rd = implicit_exec_read | s1_explicit_exec | s2_explicit_exec | s3_explicit_exec | s4_explicit_exec;
assign issue_m0_wr = implicit_M0_write | dest1_explicit_M0 | dest2_explicit_M0;
assign issue_m0_rd = implicit_M0_read | s1_explicit_M0 | s2_explicit_M0 | s3_explicit_M0 | s4_explicit_M0;

assign dest1_field_converted = d1_vdst_to_sdst ? {dest1_field[9],2'b0,dest1_field[6:0]} : dest1_field;
assign s4_field_converted = copy_d1_to_s4 ? dest1_field : s4_field;
assign s1_field_converted = copy_d1_to_s1 ? dest1_field : s1_field;

/* VIN */
assign s3_field_const = ext_literal_s3 ? `EXT_LIT_255 : s3_field;
/* VIN */

/*
always@(s3_field or ext_literal_s3)
begin
	casex(ext_literal_s3)
		2'b00 : s3_field_const <= s3_field;
		2'b01 : s3_field_const <= `EXT_LIT_128;
		2'b10 : s3_field_const <= `EXT_LIT_242;
		2'b11 : s3_field_const <= `EXT_LIT_255;
		default : s3_field_const <= s3_field;
	endcase
end
*/

assign s3_field_converted = copy_d1_to_s3 ? dest1_field : s3_field_const; // VIN
assign issue_fu = fp_instr ? 2'b0 : raw_fu;

assign width_qualified_s1_valid = (s1_width == `DECODE_BIT0) ? 1'b0 : encoded_s1_reg[11];
assign width_qualified_s2_valid = (s2_width == `DECODE_BIT0) ? 1'b0 : encoded_s2_reg[11];
assign width_qualified_s3_valid = (s3_width == `DECODE_BIT0) ? 1'b0 : encoded_s3_reg[11];
assign width_qualified_s4_valid = (s4_width == `DECODE_BIT0) ? 1'b0 : encoded_s4_reg[11];
assign width_qualified_dest1_valid = (dest1_width == `DECODE_BIT0) ? 1'b0 : encoded_dest1_reg[11];
assign width_qualified_dest2_valid = (dest2_width == `DECODE_BIT0) ? 1'b0 : encoded_dest2_reg[11];

assign issue_source_reg1 = {s1_width[1:0],width_qualified_s1_valid,encoded_s1_reg[10:0]};
assign issue_source_reg2 = {s2_width[0],width_qualified_s2_valid,encoded_s2_reg[10:0]};
assign issue_source_reg3 = {s3_width[0],width_qualified_s3_valid,encoded_s3_reg[10:0]};
assign issue_source_reg4 = {s4_width[1:0],width_qualified_s4_valid,encoded_s4_reg[10:0]};
assign issue_dest_reg1 = {dest1_width[1:0],width_qualified_dest1_valid,encoded_dest1_reg[10:0]};
assign issue_dest_reg2 = {dest2_width[0],width_qualified_dest2_valid,encoded_dest2_reg[10:0]};

//wire [2:0] qualified_width_s1;
//wire [2:0] qualified_width_s2;
//wire [2:0] qualified_width_s3;
//wire [2:0] qualified_width_s4;
//wire [2:0] qualified_width_dest1;
//wire [2:0] qualified_width_dest2;
//assign qualified_width_s1 = width_qualified_s1_valid ? s1_width : 3'b000;
//assign qualified_width_s2 = width_qualified_s2_valid ? s2_width : 3'b000;
//assign qualified_width_s3 = width_qualified_s3_valid ? s3_width : 3'b000;
//assign qualified_width_s4 = width_qualified_s4_valid ? s4_width : 3'b000;
//assign qualified_width_dest1 = width_qualified_dest1_valid ? dest1_width : 3'b000;
//assign qualified_width_dest2 = width_qualified_dest2_valid ? dest2_width : 3'b000;
//assign issue_source_reg1 = {qualified_width_s1[1:0],width_qualified_s1_valid,encoded_s1_reg[10:0]};
//assign issue_source_reg2 = {qualified_width_s2[0],width_qualified_s2_valid,encoded_s2_reg[10:0]};
//assign issue_source_reg3 = {qualified_width_s3[0],width_qualified_s3_valid,encoded_s3_reg[10:0]};
//assign issue_source_reg4 = {qualified_width_s4[1:0],width_qualified_s4_valid,encoded_s4_reg[10:0]};
//assign issue_dest_reg1 = {qualified_width_dest1[1:0],width_qualified_dest1_valid,encoded_dest1_reg[10:0]};
//assign issue_dest_reg2 = {qualified_width_dest2[0],width_qualified_dest2_valid,encoded_dest2_reg[10:0]};

assign wave_ins_half_wfid = flopped_wfid;
assign wave_ins_half_rqd = long_instr_or_literal_required & flopped_instr_valid;

assign tracemon_collinstr =  collated_instr;
assign tracemon_colldone = collate_done;

always @(s1_fp_constant or s2_fp_constant or s3_fp_constant or s4_fp_constant or imm1_frominstr_fromliteral)
begin
  casex({s1_fp_constant,s2_fp_constant,s3_fp_constant,s4_fp_constant})
    4'b0000:
      begin
        issue_imm_value1 <= imm1_frominstr_fromliteral;
      end
    4'b0001:
      begin
        issue_imm_value1 <= s4_fp_constant[31:0];
      end
    4'b0010:
      begin
        issue_imm_value1 <= s3_fp_constant[31:0];
      end
    4'b0100:
      begin
        issue_imm_value1 <= s2_fp_constant[31:0];
      end
    4'b1000:
      begin
        issue_imm_value1 <= s1_fp_constant[31:0];
      end
    default:
      begin
        issue_imm_value1 <= {32{1'bx}};
      end
  endcase
end

endmodule
