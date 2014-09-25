module reg_40x35b_1r_1w (
  rd_addr,
  rd_data,

  wr_en,
  wr_addr,
  wr_data,

  clk,
  rst
);

  output [34:0] rd_data;
  input [5:0] rd_addr;

  input [5:0] wr_addr;
  input wr_en;
  input [34:0] wr_data;

  input clk;
  input rst;

  wire [1399:0] word_out;
  wire [39:0] wr_word_select;
  wire [39:0] wr_en_word;

  mux_40x35b_to_1x35b mux_rd_port (.out(rd_data), .in(word_out), .select(rd_addr));
  decoder_6_to_40 decoder_wr_port (.out(wr_word_select), .in(wr_addr));
  assign wr_en_word = {40{wr_en}} & wr_word_select;

  reg_35b word[39:0](.out(word_out), .in(wr_data), .wr_en(wr_en_word), .clk(clk), .rst(rst));

endmodule
