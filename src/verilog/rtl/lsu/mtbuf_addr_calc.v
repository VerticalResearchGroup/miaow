module mtbuf_addr_calc (
  out_addr,
  vector_source_b,
  scalar_source_a,
  imm_value0,
  idx_en,
  off_en,
  tid
);

output[31:0] out_addr;

input [31:0] vector_source_b;
input [127:0] scalar_source_a;

input [15:0] imm_value0;

input idx_en;
input off_en;

input[5:0] tid;

wire[47:0] out_temp;

assign out_temp = (off_en ? {12'b0, vector_source_b} : imm_value0) + (idx_en ? (scalar_source_a[61:48] * (vector_source_b + tid)) : 48'b0);

assign out_addr = out_temp[31:0];

endmodule
