module reg_8x64b_1r_1w (
  rd_addr,
  rd_data,

  wr_en,
  wr_addr,
  wr_data,

  clk,
  rst
);

  output [63:0] rd_data;
  input [2:0] rd_addr;

  input [2:0] wr_addr;
  input wr_en;
  input [63:0] wr_data;

  input clk;
  input rst;

  wire [511:0] word_out;
  wire [7:0] wr_word_select;
  wire [7:0] wr_en_word;

  mux_8x64b_to_1x64b mux_rd_port (.out(rd_data), .in(word_out), .select(rd_addr));
  decoder_3_to_8 decoder_wr_port (.out(wr_word_select), .in(wr_addr));
  assign wr_en_word = {8{wr_en}} & wr_word_select;

  reg_64b word[7:0] (.out(word_out), .in(wr_data), .wr_en(wr_en_word), .clk(clk), .rst(rst));

endmodule
