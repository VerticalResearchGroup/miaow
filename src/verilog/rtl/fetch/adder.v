module adder(in,out);
input [31:0]in;
output [31:0]out;

//wire [31:0]carry;
wire carry;

//adder1bit b1 [31:0] (out, carry, in, 32'd4, {carry[30:0],1'b0});
assign {carry, out} = in + 4;

endmodule
