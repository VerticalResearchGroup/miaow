module PS_flops_rd_ex_lsu(
  in_vector_source_a,
  in_vector_source_b,
  in_scalar_source_a,
  in_scalar_source_b,
  in_imm_value0,
  in_opcode,
  in_lddst_stsrc_addr,
  in_rd_en,
  in_wr_en,
  in_wfid,
  in_instr_pc,
  in_lds_base,
  in_exec_value,
  out_vector_source_a,
  out_vector_source_b,
  out_scalar_source_a,
  out_scalar_source_b,
  out_imm_value0,
  out_opcode,
  out_lddst_stsrc_addr,
  out_rd_en,
  out_wr_en,
  out_wfid,
  out_instr_pc,
  out_lds_base,
  out_exec_value,
  clk,
  rst,
  shift_src_a,
  load_src_a
);

input clk;
input rst;
/////////////////////////////////////////CHANGE
input [2047:0] in_vector_source_a;
input [2047:0] in_vector_source_b;
input [127:0] in_scalar_source_a;
input [31:0] in_scalar_source_b;
input [15:0] in_imm_value0;
input [31:0] in_opcode;
input [11:0] in_lddst_stsrc_addr;
input [3:0] in_rd_en;
input [3:0] in_wr_en;
input [5:0] in_wfid;
input [31:0] in_instr_pc;
input [15:0] in_lds_base;
input [63:0] in_exec_value;
input load_src_a, shift_src_a;

/////////////////////////////////////////CHANGE
output [31:0] out_vector_source_a;
output [2047:0] out_vector_source_b;
output [127:0] out_scalar_source_a;
output [31:0] out_scalar_source_b;
output [15:0] out_imm_value0;
output [31:0] out_opcode;
output [11:0] out_lddst_stsrc_addr;
output [3:0] out_rd_en;
output [3:0] out_wr_en;
output [5:0] out_wfid;
output [31:0] out_instr_pc;
output [15:0] out_lds_base;
output [63:0] out_exec_value;

//////////////////////////////////////////////CHANGE 
// change to shift register
// dff flop_vector_source_a[8191:0](
//   .q(out_vector_source_a),
//   .d(in_vector_source_a),
//   .clk(clk),
//   .rst(rst)
// );

reg [2047:0] vec_src_a;
always @(posedge clk, posedge rst) begin
  if(rst) begin
    vec_src_a <= 0;
  end
  else if(shift_src_a) begin
    vec_src_a[2015:0] <= vec_src_a[2047:32];
  end
  else if(load_src_a) begin
    vec_src_a <= in_vector_source_a;
  end
end
assign out_vector_source_a = vec_src_a[31:0];

dff flop_vector_source_b[2047:0](
  .q(out_vector_source_b),
  .d(in_vector_source_b),
  .clk(clk),
  .rst(rst)
);

dff flop_scalar_source_a[127:0](
  .q(out_scalar_source_a),
  .d(in_scalar_source_a),
  .clk(clk),
  .rst(rst)
);

dff flop_scalar_source_b[31:0](
  .q(out_scalar_source_b),
  .d(in_scalar_source_b),
  .clk(clk),
  .rst(rst)
);

dff flop_imm_value0[15:0](
  .q(out_imm_value0),
  .d(in_imm_value0),
  .clk(clk),
  .rst(rst)
);

dff flop_opcode[31:0](
  .q(out_opcode),
  .d(in_opcode),
  .clk(clk),
  .rst(rst)
);

dff flop_lddst_stsrc_add[11:0](
  .q(out_lddst_stsrc_addr),
  .d(in_lddst_stsrc_addr),
  .clk(clk),
  .rst(rst)
);

dff flop_rd_en[3:0](
  .q(out_rd_en),
  .d(in_rd_en),
  .clk(clk),
  .rst(rst)
);

dff flop_wr_en[3:0](
  .q(out_wr_en),
  .d(in_wr_en),
  .clk(clk),
  .rst(rst)
);

dff flop_wfid[5:0](
  .q(out_wfid),
  .d(in_wfid),
  .clk(clk),
  .rst(rst)
);

dff flop_instr_pc[31:0](
  .q(out_instr_pc),
  .d(in_instr_pc),
  .clk(clk),
  .rst(rst)
);

dff flop_lds_base[15:0](
  .q(out_lds_base),
  .d(in_lds_base),
  .clk(clk),
  .rst(rst)
);

dff flop_exec_value[63:0](
  .q(out_exec_value),
  .d(in_exec_value),
  .clk(clk),
  .rst(rst)
);

endmodule
