module instr_buffer_tb();

reg clk;
reg rst;

reg fetch_rd_en;
reg[31:0] fetch_addr;
reg[38:0] fetch_tag;

wire fetchwave_ack;
wire[31:0] wave_instr;
wire[38:0] wave_tag;

instr_buffer ibuf(fetch_rd_en, fetch_addr, fetch_tag, fetchwave_ack, wave_instr, wave_tag, clk, rst);

initial begin   
	clk = 0;
	while (1) begin
		#2;
		clk = ~clk;
	end
end

initial begin
	rst = 1;
	fetch_rd_en = 0;
	#11;
	rst = 0;
	#10
	ibuf.instr_mem[4] = 8'h0A;
	ibuf.instr_mem[5] = 8'h0B;
	ibuf.instr_mem[6] = 8'h0C;
	ibuf.instr_mem[7] = 8'h0D;
	#20
	fetch_tag = 1;
	fetch_addr  = 32'h00000004;
	fetch_rd_en = 1'b1;
	#4
	fetch_rd_en = 0;
	#10
	$finish;
end

always @ (posedge clk) begin
	if (!rst) begin
		$display ("Time= %g : Wave_Ack= %b : Wave_Tag= %b", $time, fetchwave_ack, wave_tag);
		if(fetchwave_ack) $display ("Read Data: %h", wave_instr);
	end
end

endmodule
