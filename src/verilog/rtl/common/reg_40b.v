module reg_40b (out, in, wr_en, clk, rst);

  output [39:0] out;
  input [39:0] in;
  input wr_en;
  input clk;
  input rst;

  dff_en bits[39:0] (.q(out), .d(in), .en(wr_en), .clk(clk), .rst(rst));

endmodule
