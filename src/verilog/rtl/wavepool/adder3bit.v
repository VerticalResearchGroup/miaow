module adder3bit (
	sum,
	cout,
	in1,
	in2
);

output[2:0] sum;
output cout;

input[2:0] in1, in2;

wire cout0, cout1;

adder1bit add0(sum[0], cout0, in1[0], in2[0], 1'b0);
adder1bit add1(sum[1], cout1, in1[1], in2[1], cout0);
adder1bit add2(sum[2], cout, in1[2], in2[2], cout1);

endmodule
