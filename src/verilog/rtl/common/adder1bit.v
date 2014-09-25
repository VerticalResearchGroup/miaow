module adder1bit (
	sum,
	cout,
	in1,
	in2,
	cin
);

output sum, cout;
input in1, in2, cin;

assign sum = in1 ^ in2 ^ cin;
assign cout = (in1 & in2) | (in2 & cin) | (cin & in1);

endmodule
