module src_shift_reg (
 source1_data,
 source2_data,
 source3_data,
 source_vcc_value,
 source_exec_value,
 src_buffer_wr_en,
 src_buffer_shift_en,
 alu_source1_data,
 alu_source2_data,
 alu_source3_data,
 alu_source_vcc_value,
 alu_source_exec_value,
 clk,
 rst
);

input [2047:0] source1_data;
input [2047:0] source2_data;
input [2047:0] source3_data;
input [63:0]   source_vcc_value;
input [63:0]   source_exec_value;
input          src_buffer_wr_en;
input          src_buffer_shift_en;
output [511:0] alu_source1_data;
output [511:0] alu_source2_data;
output [511:0] alu_source3_data;
output [15:0]  alu_source_vcc_value;
output [15:0]  alu_source_exec_value;
input          clk;
input          rst;

shift_in #(32) src1_shift(
  .data_in(source1_data),
  .wr_en(src_buffer_wr_en),
  .shift_en(src_buffer_shift_en),
  .data_out(alu_source1_data),
  .clk(clk),
  .rst(rst)
);

shift_in #(32) src2_shift(
  .data_in(source2_data),
  .wr_en(src_buffer_wr_en),
  .shift_en(src_buffer_shift_en),
  .data_out(alu_source2_data),
  .clk(clk),
  .rst(rst)
);

shift_in #(32) src3_shift(
  .data_in(source3_data),
  .wr_en(src_buffer_wr_en),
  .shift_en(src_buffer_shift_en),
  .data_out(alu_source3_data),
  .clk(clk),
  .rst(rst)
);

shift_in #(1) exec_shift(
  .data_in(source_exec_value),
  .wr_en(src_buffer_wr_en),
  .shift_en(src_buffer_shift_en),
  .data_out(alu_source_exec_value),
  .clk(clk),
  .rst(rst)
);

shift_in #(1) vcc_shift(
  .data_in(source_vcc_value),
  .wr_en(src_buffer_wr_en),
  .shift_en(src_buffer_shift_en),
  .data_out(alu_source_vcc_value),
  .clk(clk),
  .rst(rst)
);

endmodule
