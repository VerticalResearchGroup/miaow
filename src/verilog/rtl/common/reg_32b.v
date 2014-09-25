module reg_32b (out, in, wr_en, clk, rst);

  output [31:0] out;
  input [31:0] in;
  input wr_en;
  input clk;
  input rst;

  dff_en bits[31:0] (.q(out), .d(in), .en(wr_en), .clk(clk), .rst(rst));

endmodule
