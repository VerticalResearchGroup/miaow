module add_wraparound_after40 (
	out_value,
	in_value_1,
	in_value_2
);

output[5:0] out_value;
input[5:0] in_value_1, in_value_2;

wire[5:0] inter_sum;
wire[6:0] inter_sub_40;
wire cout1, cout2, is_less_than_40;

adder6bit a6b(inter_sum, cout1, in_value_1, in_value_2); // adding two inputs
adder7bit a7b(inter_sub_40, cout2, {cout1, inter_sum}, 7'b1011000); // sum - 40 is output if sum is > 40

assign is_less_than_40 = inter_sub_40[6];
assign out_value = is_less_than_40 ? inter_sum : inter_sub_40[5:0];

endmodule
