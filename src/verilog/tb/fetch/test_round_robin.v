module test_round_robin();

reg[39:0] queue_vfull;
reg icache_ack;
reg[39:0] vacant;
reg clk, rst;

wire fetch_valid;
wire[5:0] pc_select;

round_robin rr(fetch_valid, pc_select, queue_vfull, icache_ack, vacant, clk, rst);

initial begin   
	clk = 0;
	while (1) begin
		#2;
		clk = ~clk;
	end
end

initial begin
	rst <= 1;
	icache_ack <= 0;
	queue_vfull <= 40'hffffffffff;
	vacant <= 40'hffffffffff;
	#20;
	rst = 0;
	#10;
	queue_vfull <= 40'hffffffff43;
	vacant <= 40'hffffffff51;
	#150;
	icache_ack = 1;
end

initial begin   
	#200
	$finish;
end

always @ (posedge clk) begin
	if (!rst) begin
		$display ("Time= %g : Fetch_valid= %b : PC_select= %b", $time, fetch_valid, pc_select);
		$display ("QF: %b", queue_vfull);
		$display ("VC: %b", vacant);
		$display ("NF: %b", rr.valid_queues_not_full);
		$display ("SQ: %b", rr.shifted_queue);
		$display ("HP_in= %d : HP_out = %d : PR_enc_out= %b", rr.highest_pr_in, rr.highest_pr_out, rr.prenc_out);
		$display ("IC_in= %d : IC_out = %d", rr.icache_req_in, rr.icache_req_out);
		$display ("IC_p1= %d : IC_m1 = %d", rr.icache_req_plus1, rr.icache_req_minus1);
		$display ("-----------------------------------------------------------");
	end
end

endmodule
