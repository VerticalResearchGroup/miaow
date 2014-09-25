module flop_en (q, d, en, clk);

  output q;
  input d;
  input en;
  input clk;

  wire d_int, q1;

  assign d_int = en ? d : q1;
  assign q = q1;

  flop flop_0(.q(q1), .d(d_int), .clk(clk));
  
endmodule
