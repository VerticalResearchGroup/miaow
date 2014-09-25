module adder_param(
    in1,
    in2,
    cin,
    sum,
    cout
);

parameter WIDTH = 32;

input cin;
input[WIDTH-1:0] in1,in2;
output[WIDTH-1:0] sum;
output cout;

wire[WIDTH-1:0] cout_adders;

adder1bit adders[WIDTH-1:0](
	.sum(sum),
	.cout(cout_adders),
	.in1(in1),
	.in2(in2),
	.cin({cout_adders[WIDTH-2:0],cin})
);

assign cout = cout_adders[WIDTH-1];

endmodule
