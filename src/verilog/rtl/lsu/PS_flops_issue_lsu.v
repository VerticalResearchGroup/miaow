module PS_flops_issue_lsu (
  in_lsu_select,
  in_wfid,
  in_lds_base,
  in_source_reg1,
  in_source_reg2,
  in_source_reg3,
  in_mem_sgpr,
  in_imm_value0,
  in_imm_value1,
  in_dest_reg,
  in_opcode,
  in_instr_pc,
  out_lsu_select,
  out_wfid,
  out_lds_base,
  out_source_reg1,
  out_source_reg2,
  out_source_reg3,
  out_mem_sgpr,
  out_imm_value0,
  out_imm_value1,
  out_dest_reg,
  out_opcode,
  out_instr_pc,
  clk,
  rst
);

input in_lsu_select;
input [5:0] in_wfid;
input [15:0] in_lds_base;
input [11:0] in_source_reg1;
input [11:0] in_source_reg2;
input [11:0] in_source_reg3;
input [11:0] in_mem_sgpr;
input [15:0] in_imm_value0;
input [31:0] in_imm_value1;
input [11:0] in_dest_reg;
input [31:0] in_opcode;
input [31:0] in_instr_pc;

input clk;
input rst;

output out_lsu_select;
output [5:0] out_wfid;
output [15:0] out_lds_base;
output [11:0] out_source_reg1;
output [11:0] out_source_reg2;
output [11:0] out_source_reg3;
output [11:0] out_mem_sgpr;
output [15:0] out_imm_value0;
output [31:0] out_imm_value1;
output [11:0] out_dest_reg;
output [31:0] out_opcode;
output [31:0] out_instr_pc;


//lsu_select is not enabled; all other flops are enabled
dff flop_lsu_select(
  .q(out_lsu_select),
  .d(in_lsu_select),
  .clk(clk),
  .rst(rst)
);

dff_en flop_wfid[5:0](
  .q(out_wfid),
  .d(in_wfid),
  .clk(clk),
  .rst(rst),
  .en(in_lsu_select)
);

dff_en flop_lds_base[15:0](
  .q(out_lds_base),
  .d(in_lds_base),
  .clk(clk),
  .rst(rst),
  .en(in_lsu_select)
);

dff_en flop_source_reg1[11:0](
  .q(out_source_reg1),
  .d(in_source_reg1),
  .clk(clk),
  .rst(rst),
  .en(in_lsu_select)
);

dff_en flop_source_reg2[11:0](
  .q(out_source_reg2),
  .d(in_source_reg2),
  .clk(clk),
  .rst(rst),
  .en(in_lsu_select)
);

dff_en flop_source_reg3[11:0](
  .q(out_source_reg3),
  .d(in_source_reg3),
  .clk(clk),
  .rst(rst),
  .en(in_lsu_select)
);

dff_en flop_mem_sgpr[11:0](
  .q(out_mem_sgpr),
  .d(in_mem_sgpr),
  .clk(clk),
  .rst(rst),
  .en(in_lsu_select)
);

dff_en flop_imm_value0[15:0](
  .q(out_imm_value0),
  .d(in_imm_value0),
  .clk(clk),
  .rst(rst),
  .en(in_lsu_select)
);

dff_en flop_imm_value1[31:0](
  .q(out_imm_value1),
  .d(in_imm_value1),
  .clk(clk),
  .rst(rst),
  .en(in_lsu_select)
);

dff_en flop_dest_reg[11:0](
  .q(out_dest_reg),
  .d(in_dest_reg),
  .clk(clk),
  .rst(rst),
  .en(in_lsu_select)
);

dff_en flop_opcode[31:0](
  .q(out_opcode),
  .d(in_opcode),
  .clk(clk),
  .rst(rst),
  .en(in_lsu_select)
);

dff_en flop_instr_pc[31:0](
  .q(out_instr_pc),
  .d(in_instr_pc),
  .clk(clk),
  .rst(rst),
  .en(in_lsu_select)
);

endmodule
