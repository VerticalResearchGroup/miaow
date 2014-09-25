module mux4to1_6bit (
	out,
	input0,
	input1,
	input2,
	input3,
	select
);

output[5:0] out;

input[5:0] input0, input1, input2, input3;
input[1:0] select;

assign out = (input0 & {6{(select == 2'b00)}}) |
			 (input1 & {6{(select == 2'b01)}}) |
			 (input2 & {6{(select == 2'b10)}}) |
			 (input3 & {6{(select == 2'b11)}});

endmodule
