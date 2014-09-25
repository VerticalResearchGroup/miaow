module flop_32b (out, in, wr_en, clk);

  output [31:0] out;
  input [31:0] in;
  input wr_en;
  input clk;

  flop_en bits[31:0] (.q(out), .d(in), .en(wr_en), .clk(clk));

endmodule
