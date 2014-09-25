module fetch_controller (
	WF_dispatch_i, 
	fetch_valid, 
	wr, 
	inst_buff_rd, 
	wave_reserve_valid
);

input WF_dispatch_i;
input fetch_valid;

output wr;
output inst_buff_rd;
output wave_reserve_valid;

assign wr = WF_dispatch_i;
assign wave_reserve_valid = fetch_valid;
assign inst_buff_rd = fetch_valid;

endmodule
