module reg_40b_set (out, in, wr_en, clk, set);

  output [39:0] out;
  input [39:0] in;
  input wr_en;
  input clk;
  input set;

  dff_set_en bits[39:0] (.q(out), .d(in), .en(wr_en), .clk(clk), .set(set));

endmodule
