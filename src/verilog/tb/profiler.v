extern "C" void InitializeProfiler(int cuid);
extern "C" void StartSALUExec(int cuid, int tstamp);
extern "C" void StartVALUExec(int cuid, int tstamp);
extern "C" void StartMemExec(int cuid, int tstamp);
extern "C" void FinishSALUExec(int cuid, int tstamp);
extern "C" void FinishVALUExec(int cuid, int tstamp);
extern "C" void FinishMemExec(int cuid, int tstamp);
extern "C" void WavepoolQAdd(int cuid, int qid);
extern "C" void WavepoolQRemove(int cuid, int qid);
extern "C" void WavepoolQReset(int cuid, int qid);
extern "C" void WavepoolQProfile(int cuid);
extern "C" void WavepoolQProfileOut(int cuid);
extern "C" void ValuQAdd(int cuid, int qid);
extern "C" void ValuQRemove(int cuid, int qid);
extern "C" void ValuQProfile(int cuid);
extern "C" void ValuQProfileOut(int cuid);

module profiler(
	salu2sgpr_instr_done,
	salu2fetchwaveissue_branch_en,
	simd0_2vgpr_instr_done,
	simd1_2vgpr_instr_done,
	simd2_2vgpr_instr_done,
	simd3_2vgpr_instr_done,
	simf0_2vgpr_instr_done,
	simf1_2vgpr_instr_done,
	simf2_2vgpr_instr_done,
	simf3_2vgpr_instr_done,
	rfa2execvgprsgpr_select_fu,
	lsu2vgpr_instr_done,
	lsu2sgpr_instr_done,
	salu_alu_select,
    simd0_alu_select,
    simd1_alu_select,
    simd2_alu_select,
    simd3_alu_select,
    simf0_alu_select,
    simf1_alu_select,
    simf2_alu_select,
    simf3_alu_select,
    lsu_select,
	clk
 );

parameter CUID = -1;
parameter PROF_FREQ = 100;

input clk;

input salu2sgpr_instr_done, simd0_2vgpr_instr_done, simd1_2vgpr_instr_done,
	simd2_2vgpr_instr_done, simd3_2vgpr_instr_done, simf0_2vgpr_instr_done,
	simf1_2vgpr_instr_done,	simf2_2vgpr_instr_done,	simf3_2vgpr_instr_done,
	salu_alu_select, simd0_alu_select, simd1_alu_select,
    simd2_alu_select, simd3_alu_select, simf0_alu_select,
    simf1_alu_select, simf2_alu_select, simf3_alu_select,
    salu2fetchwaveissue_branch_en, lsu_select, lsu2sgpr_instr_done,
    lsu2vgpr_instr_done;
input[15:0] rfa2execvgprsgpr_select_fu;

reg [7:0] wrback;

integer i, profCnt;

initial begin
	InitializeProfiler(CUID);
	wrback = 8'hFF;
	profCnt = 0;
end

always @(posedge clk)
   profCnt = profCnt + 1;

always @ (posedge clk) begin

	// SALU logging
	if(salu2sgpr_instr_done | salu2fetchwaveissue_branch_en) begin
		FinishSALUExec(CUID, $time);
	end

	// LSU logging
	if(lsu2sgpr_instr_done | lsu2vgpr_instr_done) begin
		FinishMemExec(CUID, $time);
	end

	// SIMD logging
	if(wrback[0] && simd0_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[0])
		FinishVALUExec(CUID, $time);
	else if(wrback[0] && simd0_2vgpr_instr_done && ~rfa2execvgprsgpr_select_fu[0]) begin
		FinishVALUExec(CUID, $time);
		wrback[0] = 1'b0;
	end
	else if(simd0_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[0])
		wrback[0] = 1'b1;

	if(wrback[1] && simd1_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[1])
		FinishVALUExec(CUID, $time);
	else if(wrback[1] && simd1_2vgpr_instr_done && ~rfa2execvgprsgpr_select_fu[1]) begin
		FinishVALUExec(CUID, $time);
		wrback[1] = 1'b0;
	end
	else if(simd1_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[1])
		wrback[1] = 1'b1;

	if(wrback[2] && simd2_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[2])
		FinishVALUExec(CUID, $time);
	else if(wrback[2] && simd2_2vgpr_instr_done && ~rfa2execvgprsgpr_select_fu[2]) begin
		FinishVALUExec(CUID, $time);
		wrback[2] = 1'b0;
	end
	else if(simd2_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[2])
		wrback[2] = 1'b1;

	if(wrback[3] && simd3_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[3])
		FinishVALUExec(CUID, $time);
	else if(wrback[3] && simd3_2vgpr_instr_done && ~rfa2execvgprsgpr_select_fu[3]) begin
		FinishVALUExec(CUID, $time);
		wrback[3] = 1'b0;
	end
	else if(simd3_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[3])
		wrback[3] = 1'b1;

	// SIMF logging
	if(wrback[4] && simf0_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[4])
		FinishVALUExec(CUID, $time);
	else if(wrback[4] && simf0_2vgpr_instr_done && ~rfa2execvgprsgpr_select_fu[4]) begin
		FinishVALUExec(CUID, $time);
		wrback[4] = 1'b0;
	end
	else if(simf0_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[4])
		wrback[4] = 1'b1;

	if(wrback[5] && simf1_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[5])
		FinishVALUExec(CUID, $time);
	else if(wrback[5] && simf1_2vgpr_instr_done && ~rfa2execvgprsgpr_select_fu[5]) begin
		FinishVALUExec(CUID, $time);
		wrback[5] = 1'b0;
	end
	else if(simf1_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[5])
		wrback[5] = 1'b1;

	if(wrback[6] && simf2_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[6])
		FinishVALUExec(CUID, $time);
	else if(wrback[6] && simf2_2vgpr_instr_done && ~rfa2execvgprsgpr_select_fu[6]) begin
		FinishVALUExec(CUID, $time);
		wrback[6] = 1'b0;
	end
	else if(simf2_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[6])
		wrback[6] = 1'b1;

	if(wrback[7] && simf3_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[7])
		FinishVALUExec(CUID, $time);
	else if(wrback[7] && simf3_2vgpr_instr_done && ~rfa2execvgprsgpr_select_fu[7]) begin
		FinishVALUExec(CUID, $time);
		wrback[7] = 1'b0;
	end
	else if(simf3_2vgpr_instr_done && rfa2execvgprsgpr_select_fu[7])
		wrback[7] = 1'b1;

	if(salu_alu_select)
		StartSALUExec(CUID, $time);
    if(simd0_alu_select)
    	StartVALUExec(CUID, $time);
    if(simd1_alu_select)
    	StartVALUExec(CUID, $time);
    if(simd2_alu_select)
    	StartVALUExec(CUID, $time);
    if(simd3_alu_select)
    	StartVALUExec(CUID, $time);
    if(simf0_alu_select)
    	StartVALUExec(CUID, $time);
    if(simf1_alu_select)
    	StartVALUExec(CUID, $time);
    if(simf2_alu_select)
    	StartVALUExec(CUID, $time);
    if(simf3_alu_select)
    	StartVALUExec(CUID, $time);
	if(lsu_select)
		StartMemExec(CUID, $time);

end

always @(posedge clk) begin
	for(i = 0; i < 40; i++) begin
		if(gpu_tb.DUT[CUID].wavepool0.pool.q_wr[i])
			WavepoolQAdd(CUID, i);
		if(gpu_tb.DUT[CUID].wavepool0.pool.q_rd[i])
			WavepoolQRemove(CUID, i);
		if(gpu_tb.DUT[CUID].wavepool0.pool.q_reset[i])
			WavepoolQReset(CUID, i);
	end

	WavepoolQProfile(CUID);

	if(profCnt % PROF_FREQ == 0) WavepoolQProfileOut(CUID);
end

always @(posedge clk) begin
	if(gpu_tb.DUT[CUID].simd0.alu.wb_queue.inc_tail)
		ValuQAdd(CUID, 0);
	if(gpu_tb.DUT[CUID].simd0.alu.wb_queue.inc_head)
		ValuQRemove(CUID, 0);

	if(gpu_tb.DUT[CUID].simd1.alu.wb_queue.inc_tail)
		ValuQAdd(CUID, 1);
	if(gpu_tb.DUT[CUID].simd1.alu.wb_queue.inc_head)
		ValuQRemove(CUID, 1);

	if(gpu_tb.DUT[CUID].simd2.alu.wb_queue.inc_tail)
		ValuQAdd(CUID, 2);
	if(gpu_tb.DUT[CUID].simd2.alu.wb_queue.inc_head)
		ValuQRemove(CUID, 2);

	if(gpu_tb.DUT[CUID].simd3.alu.wb_queue.inc_tail)
		ValuQAdd(CUID, 3);
	if(gpu_tb.DUT[CUID].simd3.alu.wb_queue.inc_head)
		ValuQRemove(CUID, 3);

	if(gpu_tb.DUT[CUID].simf0.alu.wb_queue.inc_tail)
		ValuQAdd(CUID, 4);
	if(gpu_tb.DUT[CUID].simf0.alu.wb_queue.inc_head)
		ValuQRemove(CUID, 4);

	if(gpu_tb.DUT[CUID].simf1.alu.wb_queue.inc_tail)
		ValuQAdd(CUID, 5);
	if(gpu_tb.DUT[CUID].simf1.alu.wb_queue.inc_head)
		ValuQRemove(CUID, 5);

	if(gpu_tb.DUT[CUID].simf2.alu.wb_queue.inc_tail)
		ValuQAdd(CUID, 6);
	if(gpu_tb.DUT[CUID].simf2.alu.wb_queue.inc_head)
		ValuQRemove(CUID, 6);

	if(gpu_tb.DUT[CUID].simf3.alu.wb_queue.inc_tail)
		ValuQAdd(CUID, 7);
	if(gpu_tb.DUT[CUID].simf3.alu.wb_queue.inc_head)
		ValuQRemove(CUID, 7);

	ValuQProfile(CUID);

	if(profCnt % PROF_FREQ == 0) ValuQProfileOut(CUID);
end

endmodule
