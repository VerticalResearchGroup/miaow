module arbiter(
    // Inputs
    input_arry,
    issued_en,
    issued_wf_id,
    
    // Outputs
    choosen_valid,
    choosen_wf_id,
    
    clk,
    rst
);

input clk,rst;
input issued_en;
input[5:0] issued_wf_id;
input[39:0] input_arry;

output choosen_valid;
output[5:0] choosen_wf_id;

wire[5:0] last_issued_wf_id, last_issued_wf_id_corr_output, priority_encoder_out;
wire[39:0] priority_encoder_in, decoded_priority_encoder_out, choosen_wf_id_encoded;

reg_param #(6) last_wf_id_issued_reg(
    .out(last_issued_wf_id),
    .in(issued_wf_id),
    .wr_en(issued_en),
    .clk(clk),
    .rst(rst)
);

circular_barrel_shift input_priority_shifter(
	.output_val(priority_encoder_in),
	.input_val(input_arry),
	.shift_amt(last_issued_wf_id)
);

circular_barrel_shift output_priority_shifter(
    .output_val(choosen_wf_id_encoded),
    .input_val(decoded_priority_encoder_out),
    .shift_amt(last_issued_wf_id_corr_output)
);

decoder_6b_40b_en decoder_6b_40b_en(
	.addr_in(priority_encoder_out),
	.out(decoded_priority_encoder_out),
	.en(choosen_valid)
);

priority_encoder_40to6 priority_encoder(
	.binary_out(priority_encoder_out),
	.valid(choosen_valid),
	.encoder_in(priority_encoder_in),
	.enable(|priority_encoder_in)
);

encoder encoder(
	.in(choosen_wf_id_encoded),
	.out(choosen_wf_id)
);

assign last_issued_wf_id_corr_output = 6'd40 - last_issued_wf_id;

endmodule
