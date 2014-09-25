module reg_35b (out, in, wr_en, clk, rst);

  output [34:0] out;
  input [34:0] in;
  input wr_en;
  input clk;
  input rst;

  dff_en bits[34:0] (.q(out), .d(in), .en(wr_en), .clk(clk), .rst(rst));

endmodule
