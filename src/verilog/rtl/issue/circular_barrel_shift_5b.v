module circular_barrel_shift_9b(
    output_val,
    input_val,
    shift_amt
);

output[8:0] output_val;

input[8:0] input_val;
input[3:0] shift_amt;

wire[8:0] shift_1, shift_2, shift_4, shift_8, shift_16; 

assign shift_1  = shift_amt[0] ? (input_val >> 1 | input_val << 8) : input_val;
assign shift_2  = shift_amt[1] ? (shift_1 >> 2 | shift_1 << 7) : shift_1;
assign shift_4  = shift_amt[2] ? (shift_2 >> 4 | shift_2 << 5) : shift_2;
assign output_val = shift_amt[3] ? (shift_4 >>  8 | shift_4 << 1) : shift_4;

endmodule
