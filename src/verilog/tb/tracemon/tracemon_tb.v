module tracemon_tb();

reg[31:0] wave2decode_instr_pc;
reg[31:0] wave2decode_instr;
reg wave2decode_instr_valid;
reg[8:0] wave2decode_sgpr_base;
reg[9:0] wave2decode_vgpr_base;
reg[9:0] wave2decode_lds_base;
	
reg salu2exec_wr_exec_en;
reg[63:0] salu2exec_wr_exec_value;
reg salu2exec_wr_vcc_en;
reg[63:0] salu2exec_wr_vcc_value;
reg salu_wr_scc_en;
reg salu_wr_scc_value;

reg salu2sgpr_dest_wr_en;
reg[8:0] salu2sgpr_dest_addr;
reg[31:0] salu2sgpr_dest_data;

reg simd12exec_wr_vcc_en;
reg[63:0] simd12exec_wr_vcc_value;

reg simd12vgpr_dest_wr_en;
reg[9:0] simd12vgpr_dest_addr;
reg[2047:0] simd12vgpr_dest_data;
reg[63:0] simd12vgpr_wr_mask;

reg simd22exec_wr_vcc_en;
reg[63:0] simd22exec_wr_vcc_value;

reg simd22vgpr_dest_wr_en;
reg[9:0] simd22vgpr_dest_addr;
reg[2047:0] simd22vgpr_dest_data;
reg[63:0] simd22vgpr_wr_mask;

reg simd32exec_wr_vcc_en;
reg[63:0] simd32exec_wr_vcc_value;

reg simd32vgpr_dest_wr_en;
reg[9:0] simd32vgpr_dest_addr;
reg[2047:0] simd32vgpr_dest_data;
reg[63:0] simd32vgpr_wr_mask;

reg simd42exec_wr_vcc_en;
reg[63:0] simd42exec_wr_vcc_value;

reg simd42vgpr_dest_wr_en;
reg[9:0] simd42vgpr_dest_addr;
reg[2047:0] simd42vgpr_dest_data;
reg[63:0] simd42vgpr_wr_mask;

reg lsu2sgpr_dest_wr_en;
reg[8:0] lsu2sgpr_dest_addr;
reg[31:0] lsu2sgpr_dest_data;

reg lsu2vgpr_dest_wr_en;
reg[2047:0] lsu2vgpr_dest_data;

reg[9:0] lsu_dest_str_addr;
reg[63:0] lsu_dest_str_mask;
 
reg[2047:0] lsu_addr;
reg[2047:0] lsu_store_data;

reg issue_halt;
reg[5:0] issue_halt_wfid;

reg salu_retire_valid, simd1_retire_valid, simd2_retire_valid, simd3_retire_valid, simd4_retire_valid, lsu_retire_valid;
reg[31:0] salu_retire_pc, simd1_retire_pc, simd2_retire_pc, simd3_retire_pc, simd4_retire_pc, lsu_retire_pc;
reg[5:0] wave2decode_wfid, salu_wfid, simd1_wfid, simd2_wfid, simd3_wfid, simd4_wfid, lsu_wfid;

reg clk, rst;

tracemon tm(
	wave2decode_instr_valid,
	wave2decode_instr,
	wave2decode_instr_pc,
	wave2decode_sgpr_base,
	wave2decode_vgpr_base,
	wave2decode_lds_base,
	wave2decode_wfid,
	
	salu2exec_wr_exec_en,
	salu2exec_wr_exec_value,
	salu2exec_wr_vcc_en,
	salu2exec_wr_vcc_value,
	salu_wr_scc_en,
	salu_wr_scc_value,
	
	salu2sgpr_dest_wr_en,
	salu2sgpr_dest_addr,
	salu2sgpr_dest_data,
	
	simd12exec_wr_vcc_en,
	simd12exec_wr_vcc_value,
	
	simd12vgpr_dest_wr_en,
	simd12vgpr_dest_addr,
	simd12vgpr_dest_data,
	simd12vgpr_wr_mask,
	
	simd22exec_wr_vcc_en,
	simd22exec_wr_vcc_value,
	
	simd22vgpr_dest_wr_en,
	simd22vgpr_dest_addr,
	simd22vgpr_dest_data,
	simd22vgpr_wr_mask,
	
	simd32exec_wr_vcc_en,
	simd32exec_wr_vcc_value,
	
	simd32vgpr_dest_wr_en,
	simd32vgpr_dest_addr,
	simd32vgpr_dest_data,
	simd32vgpr_wr_mask,
	
	simd42exec_wr_vcc_en,
	simd42exec_wr_vcc_value,
	
	simd42vgpr_dest_wr_en,
	simd42vgpr_dest_addr,
	simd42vgpr_dest_data,
	simd42vgpr_wr_mask,
	
	lsu2sgpr_dest_wr_en,
	lsu2sgpr_dest_addr,
	lsu2sgpr_dest_data,
	
	lsu2vgpr_dest_wr_en,
	lsu2vgpr_dest_data,
	
	lsu_dest_str_addr,
	lsu_dest_str_mask,
	
	lsu_addr,
	lsu_store_data,
	
	issue_halt,
	issue_halt_wfid,
	
	salu_retire_valid,
	salu_retire_pc,
	salu_wfid,
	
	simd1_retire_valid,
	simd1_retire_pc,
	simd1_wfid,
	
	simd2_retire_valid,
	simd2_retire_pc,
	simd2_wfid,
	
	simd3_retire_valid,
	simd3_retire_pc,
	simd3_wfid,
	
	simd4_retire_valid,
	simd4_retire_pc,
	simd4_wfid,
	
	lsu_retire_valid,
	lsu_retire_pc,
	lsu_wfid,
	
	clk,
	rst
);

initial begin   
	clk = 0;
	while (1) begin
		#2;
		clk = ~clk;
	end
end

initial begin
	rst = 1;
	salu_retire_valid = 0;
	simd1_retire_valid = 0;
	simd2_retire_valid = 0;
	simd3_retire_valid = 0;
	simd4_retire_valid = 0;
	lsu_retire_valid = 0;
	#11
	wave2decode_instr_valid = 1;
	wave2decode_instr_pc = 0;
	wave2decode_instr = 10;
	wave2decode_sgpr_base = 1;
	wave2decode_vgpr_base = 2;
	wave2decode_lds_base = 3;
	wave2decode_wfid = 0;
	#4
	wave2decode_instr_valid = 1;
	wave2decode_instr_pc = 1;
	wave2decode_instr = 20;
	wave2decode_sgpr_base = 1;
	wave2decode_vgpr_base = 2;
	wave2decode_lds_base = 3;
	wave2decode_wfid = 0;
	#4
	wave2decode_instr_valid = 1;
	wave2decode_instr_pc = 2;
	wave2decode_instr = 30;
	wave2decode_sgpr_base = 1;
	wave2decode_vgpr_base = 2;
	wave2decode_lds_base = 3;
	wave2decode_wfid = 0;
	/*
	#4
	salu_retire_valid = 1;
	salu_retire_pc = 0;
	salu_wfid = 0;
	salu2sgpr_dest_wr_en = 1;
	salu_wr_scc_en = 1;
	salu2sgpr_dest_data = 23;
	salu2sgpr_dest_addr = 4;
	salu_wr_scc_value = 1;
	#4
	salu_retire_valid = 0;
	*/
	/*
	#4
	simd3_retire_valid = 1;
	simd3_retire_pc = 2;
	simd3_wfid = 0;
	simd32vgpr_wr_mask = 7;
	simd32vgpr_dest_wr_en = 1;
	simd32exec_wr_vcc_en = 0;
	simd32vgpr_dest_data = 2048'h0000_1234_0000_5678;
	simd32vgpr_dest_addr = 4;
	simd32exec_wr_vcc_value = 1;
	
	simd4_retire_valid = 1;
	simd4_retire_pc = 1;
	simd4_wfid = 0;
	simd42vgpr_wr_mask = 10;
	simd42vgpr_dest_wr_en = 1;
	simd42exec_wr_vcc_en = 1;
	simd42vgpr_dest_data = 2047'h0000_1234_0000_5678;
	simd42vgpr_dest_addr = 4;
	simd42exec_wr_vcc_value = 2;
	#4
	simd3_retire_valid = 0;
	simd4_retire_valid = 0;
	*/
	#4
	lsu_retire_valid = 1;
	lsu_retire_pc = 0;
	lsu_wfid = 0;
	lsu2vgpr_dest_wr_en = 1;
	lsu_dest_str_addr = 6;
	lsu_addr = 2047'h0000_1234_0000_5678;
	lsu_dest_str_mask = 7;
	lsu2vgpr_dest_data = 15;//2047'h0000_5678_0000_1234;
	#4
	lsu_retire_valid = 0;
	#10
	$finish;
end

endmodule
