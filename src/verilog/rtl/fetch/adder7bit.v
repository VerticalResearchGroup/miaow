module adder7bit (
	sum,
	cout,
	in1,
	in2
);

output[6:0] sum;
output cout;

input[6:0] in1, in2;

wire cout0, cout1, cout2, cout3, cout4, cout5;

adder1bit add0(sum[0], cout0, in1[0], in2[0], 1'b0);
adder1bit add1(sum[1], cout1, in1[1], in2[1], cout0);
adder1bit add2(sum[2], cout2, in1[2], in2[2], cout1);
adder1bit add3(sum[3], cout3, in1[3], in2[3], cout2);
adder1bit add4(sum[4], cout4, in1[4], in2[4], cout3);
adder1bit add5(sum[5], cout5, in1[5], in2[5], cout4);
adder1bit add6(sum[6], cout, in1[6], in2[6], cout5);

endmodule
