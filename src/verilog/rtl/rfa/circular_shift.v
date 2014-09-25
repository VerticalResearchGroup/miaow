module circular_shift (
   out,
   in,
   shift_amount
);

output[15:0] out;

input[15:0] in;
input[3:0] shift_amount;

wire[15:0] shift_1, shift_2, shift_4;

assign shift_1  = shift_amount[0] ? (in >> 1 | in << 15) : in;
assign shift_2  = shift_amount[1] ? (shift_1 >> 2 | shift_1 << 14) : shift_1;
assign shift_4  = shift_amount[2] ? (shift_2 >> 4 | shift_2 << 12) : shift_2;
assign out  = shift_amount[3] ? (shift_4 >> 8 | shift_4 << 8) : shift_4;

endmodule
