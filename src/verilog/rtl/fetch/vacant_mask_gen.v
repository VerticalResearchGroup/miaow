module vacant_mask_gen(
	new_wfid, 
	new_vacant, 
	wf_id_done, 
	vacant, 
	halt, 
	wr
);

input [5:0] new_wfid;
input wr;
input [39:0] vacant;
input [5:0] wf_id_done;
input halt;

output [39:0] new_vacant;

wire [39:0] halt_reset_mask, masked_vacant;
wire [39:0] new_slot_mask_neg, new_slot_mask;

assign new_vacant = halt ? (masked_vacant | halt_reset_mask) : masked_vacant;
assign masked_vacant = wr ? (new_slot_mask & vacant) : vacant;
assign new_slot_mask = ~new_slot_mask_neg;

decoder_6b_40b_en halt_mask(
	.addr_in(wf_id_done), .en(1'b1), .out(halt_reset_mask)
);

decoder_6b_40b_en new_wfid_mask(
	.addr_in(new_wfid), .en(1'b1), .out(new_slot_mask_neg)
);

endmodule
