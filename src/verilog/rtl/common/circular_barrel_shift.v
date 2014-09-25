module circular_barrel_shift (
	output_val,
	input_val,
	shift_amt
);

output[39:0] output_val;

input[39:0] input_val;
input[5:0] shift_amt;

wire[39:0] shift_1, shift_2, shift_4, shift_8, shift_16; 

assign shift_1  = shift_amt[0] ? (input_val >> 1 | input_val << 39) : input_val;
assign shift_2  = shift_amt[1] ? (shift_1 >> 2 | shift_1 << 38) : shift_1;
assign shift_4  = shift_amt[2] ? (shift_2 >> 4 | shift_2 << 36) : shift_2;
assign shift_8  = shift_amt[3] ? (shift_4 >> 8 | shift_4 << 32) : shift_4;
assign shift_16 = shift_amt[4] ? (shift_8 >> 16 | shift_8 << 24) : shift_8;
assign output_val = shift_amt[5] ? (shift_16 >> 32 | shift_16 << 8) : shift_16;

endmodule
