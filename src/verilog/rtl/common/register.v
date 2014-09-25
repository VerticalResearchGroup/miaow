module register(out, in, wr_en, clk, rst);

  parameter WIDTH = 1;
  output [WIDTH-1:0] out;
  input [WIDTH-1:0] in;
  input wr_en;
  input clk;
  input rst;

  dff_en bits[WIDTH-1:0] (.q(out), .d(in), .en(wr_en), .clk(clk), .rst(rst));

endmodule
