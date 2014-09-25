module round_robin (
	fetch_valid,
	pc_select,
	queue_vfull,
	icache_ack,
	vacant,
	clk,
	rst
);

output fetch_valid;
output[5:0] pc_select;

input[39:0] queue_vfull;
input icache_ack;
input[39:0] vacant;
input clk, rst;

wire[5:0] icache_req_out, icache_req_in;
wire[5:0] icache_req_plus1, icache_req_minus1;
wire ign_cout1, ign_cout2;

wire[39:0] valid_queues_not_full;
wire can_fetch, any_to_fetch;

wire[39:0] shifted_queue;
wire[5:0] highest_pr_in, highest_pr_out, prenc_out;

//adder6bit plus1(icache_req_plus1, ign_cout1, icache_req_out, 6'b000001);
//adder6bit minus1(icache_req_minus1, ign_cout2, icache_req_out, 6'b111111);

assign {ign_cout1, icache_req_plus1} = icache_req_out + 1;
assign {ign_cout2, icache_req_minus1} = icache_req_out - 1;

mux4to1_6bit m4to1_6b(icache_req_in, icache_req_out, icache_req_plus1, icache_req_minus1,
				icache_req_out, {fetch_valid, icache_ack});

dff_en_fixed_reset_value req_ff(icache_req_out, icache_req_in, 6'b011111, 1'b1, clk, rst);
dff_en high_pr_ff[5:0](highest_pr_out, highest_pr_in, fetch_valid, clk, rst);

assign valid_queues_not_full = ~(queue_vfull | vacant);
assign can_fetch = |icache_req_out;

circular_barrel_shift cbs(shifted_queue, valid_queues_not_full, highest_pr_out);
priority_encoder_40to6 penc(prenc_out, any_to_fetch, shifted_queue, 1'b1);

assign fetch_valid = can_fetch & any_to_fetch;

add_wraparound_after40 awa(pc_select, prenc_out, highest_pr_out);
incr_wraparound_at40 iwa(highest_pr_in, pc_select);

endmodule
