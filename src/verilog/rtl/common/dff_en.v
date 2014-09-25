module dff_en (q, d, en, clk, rst);

  output q;
  input d;
  input en;
  input clk;
  input rst;

  wire d_int, q1;

  assign d_int = en ? d : q1;
  assign q = q1;

  dff dff_0(.q(q1), .d(d_int), .clk(clk), .rst(rst));
  
endmodule
