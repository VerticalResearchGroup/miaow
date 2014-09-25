module reg_64b (out, in, wr_en, clk, rst);

  output [63:0] out;
  input [63:0] in;
  input wr_en;
  input clk;
  input rst;

  dff_en bits[63:0] (.q(out), .d(in), .en(wr_en), .clk(clk), .rst(rst));

endmodule
