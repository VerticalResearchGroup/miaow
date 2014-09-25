module dff_en_fixed_reset_value (
	out_value,
	in_value,
	reset_value,
	en,
	clk,
	rst
);

output[5:0] out_value;
input[5:0] reset_value, in_value;
input en, clk, rst;

wire[5:0] dff_in_value;

assign dff_in_value = rst ? reset_value : in_value;

dff_en ff[5:0](out_value, dff_in_value, en, clk, 1'b0);

endmodule
