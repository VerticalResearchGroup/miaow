module regfile_clr(d_in,wr_en,d_out,clk,rst);
  
  
  parameter BITWIDTH=11;
  input [BITWIDTH-1:0]d_in;
  output [BITWIDTH-1:0]d_out;
  input wr_en,clk,rst;
  
  wire [BITWIDTH-1:0]out;
  
  dff_clr d1[BITWIDTH-1:0](.q(d_out), .d(out), .clk(clk), .rst(rst));
  
  mux2_1 m1[BITWIDTH-1:0](.InA(d_out),.InB(d_in),.out(out),.S(wr_en));
  
endmodule