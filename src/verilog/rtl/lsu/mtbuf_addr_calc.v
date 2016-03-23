module mtbuf_addr_calc (
  out_addr,
  vector_source_b,
  scalar_source_a,
  scalar_source_b,
  imm_value0,
  idx_en,
  off_en,
  tid
);

output[31:0] out_addr;

input [31:0] vector_source_b;
input [127:0] scalar_source_a;
input [31:0] scalar_source_b;

input [15:0] imm_value0;

input idx_en;
input off_en;

input[5:0] tid;

`define BASE_VALUE scalar_source_a[47:0]
`define STRIDE_VALUE scalar_source_a[61:48]

wire[47:0] out_temp;

// Simplified equation is as follows:
// address = baseAddress + baseOffset + instrOffset + vectorOffset + stride * (vectorIndex + threadID)
assign out_temp = `BASE_VALUE + scalar_source_b + imm_value0 + (off_en ? {12'b0, vector_source_b} : 48'd0) + (`STRIDE_VALUE * (tid + (idx_en ? vector_source_b : 48'b0)));

assign out_addr = out_temp[31:0];

endmodule
