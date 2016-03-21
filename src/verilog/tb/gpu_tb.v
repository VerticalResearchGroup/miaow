
extern "C" int Initialize(int num_of_cu, int iter);
extern "C" int getTotalWavefronts();
extern "C" int ScheduleWavefront();
extern "C" void DescheduleWavefront(int cuid, int wfTag);
extern "C" int getCuId();
//extern "C" int getWgId();
//extern "C" int getWfId();
extern "C" int getWfTag();
extern "C" int getWfCnt();
extern "C" int getWfNumThrds();
extern "C" int getVregBase();
extern "C" int getVregSize();
extern "C" int getSregBase();
extern "C" int getSregSize();
extern "C" int getLdsBase();
extern "C" int getLdsSize();
extern "C" int getSetVregs();
extern "C" int getVregKey(int index, int thrd);
extern "C" int getVregValue(int index, int thrd);
extern "C" int getSetSregs();
extern "C" int getSregKey(int index);
extern "C" int getSregValue(int index);
extern "C" void setVregValue(int cuid, int thrd, int vreg, int bitnum, int value);
extern "C" void setSregValue(int cuid, int sreg, int bitnum, int value);
extern "C" int getPC();

module gpu_tb();

	parameter NUMOFCU = 1;
	//parameter NUM_OF_ENTRIES_IMEM = 20;  // number of entries to print

	reg clk;
	reg rst;

	reg [15:0] ldssize;
	reg [9:0]  vregsize;
	reg [8:0]  sregsize;

	reg[31:0]	sregVal, vregVal;

	integer     cycle_count;
	integer     killtime;
	integer     clockperiod;
	integer     half_clockperiod;
	integer     deassert_reset;
	integer     m, n;
	integer		x, y, z;
	integer		thrds, setVregs, setSregs;
	integer		sregKey, vregKey;
	integer 	cuid;
	integer 	a;
	integer     wf_rem, iter, kern;

	reg [(NUMOFCU-1):0] dispatch2cu_wf_dispatch;
	reg [3:0] dispatch2cu_wg_wf_count;
	reg [5:0] dispatch2cu_wf_size_dispatch;
	reg [8:0] dispatch2cu_sgpr_base_dispatch;
	reg [9:0] dispatch2cu_vgpr_base_dispatch;
	reg [14:0] dispatch2cu_wf_tag_dispatch;
	reg [15:0] dispatch2cu_lds_base_dispatch;
	reg [31:0] dispatch2cu_start_pc_dispatch;

	wire [(NUMOFCU - 1):0] mem2lsu_ack, buff2fetchwave_ack;
	wire [(NUMOFCU*7 - 1):0] mem2lsu_tag_resp;
	wire [(NUMOFCU*32 - 1):0] buff2wave_instr;
	wire [(NUMOFCU*39 - 1):0] buff2wave_tag;
	wire [31:0] mem2lsu_rd_data;

	wire [NUMOFCU-1:0] cu2dispatch_wf_done, lsu2mem_gm_or_lds, fetch2buff_rd_en, issue2tracemon_barrier_retire_en,
         issue2tracemon_waitcnt_retire_en, wave2decode_instr_valid, salu2sgpr_instr_done,
         salu2exec_wr_exec_en, salu2exec_wr_vcc_en, salu2exec_wr_scc_en, salu2exec_wr_scc_value,
         simd0_2vgpr_instr_done, simd1_2vgpr_instr_done, simd2_2vgpr_instr_done,
         simd3_2vgpr_instr_done, simd0_2exec_wr_vcc_en, simd0_2vgpr_wr_en, simd1_2exec_wr_vcc_en,
         simd1_2vgpr_wr_en, simd2_2exec_wr_vcc_en, simd2_2vgpr_wr_en, simd3_2exec_wr_vcc_en,
         simd3_2vgpr_wr_en, simf0_2vgpr_instr_done, simf1_2vgpr_instr_done, simf2_2vgpr_instr_done,
         simf3_2vgpr_instr_done, simf0_2exec_wr_vcc_en, simf0_2vgpr_wr_en, simf1_2exec_wr_vcc_en,
         simf1_2vgpr_wr_en, simf2_2exec_wr_vcc_en, simf2_2vgpr_wr_en, simf3_2exec_wr_vcc_en,
         simf3_2vgpr_wr_en, simd0_2sgpr_wr_en, simd1_2sgpr_wr_en, simd2_2sgpr_wr_en,
         simd3_2sgpr_wr_en, simf0_2sgpr_wr_en, simf1_2sgpr_wr_en, simf2_2sgpr_wr_en,
         simf3_2sgpr_wr_en, lsu2sgpr_instr_done, lsu2vgpr_instr_done, issue2fetchwave_wf_done_en,
         salu2fetchwaveissue_branch_en, salu2fetchwaveissue_branch_taken, decode2tracemon_colldone,
         decode2issue_valid, lsu2tracemon_gm_or_lds, fetch2tracemon_dispatch, lsu2tracemon_idle,
         salu2exec_wr_m0_en, decode2issue_barrier;
	wire [NUMOFCU*2 - 1:0] salu2tracemon_exec_word_sel, salu2tracemon_vcc_word_sel,
         salu2sgpr_dest_wr_en;
	wire [NUMOFCU*4 - 1:0] lsu2sgpr_dest_wr_en;
    wire lsu2mem_rd_en, lsu2mem_wr_en, lsu2vgpr_dest_wr_en;
	wire [NUMOFCU*6 - 1:0] issue2tracemon_waitcnt_retire_wfid, wave2decode_wfid, salu2sgpr_instr_done_wfid,
         simd0_2vgpr_instr_done_wfid, simd1_2vgpr_instr_done_wfid, simd2_2vgpr_instr_done_wfid,
         simd3_2vgpr_instr_done_wfid, simf0_2vgpr_instr_done_wfid, simf1_2vgpr_instr_done_wfid,
         simf2_2vgpr_instr_done_wfid, simf3_2vgpr_instr_done_wfid, lsu2sgpr_instr_done_wfid,
         lsu2vgpr_instr_done_wfid, issue2fetchwave_wf_done_wf_id, salu2fetchwaveissue_branch_wfid,
         decode2issue_wfid, fetch2tracemon_new_wfid;
	wire [NUMOFCU*7 - 1:0] lsu2mem_tag_req;
	wire [NUMOFCU*9 - 1:0] wave2decode_sgpr_base, salu2sgpr_dest_addr, simd0_2sgpr_wr_addr,
         simd1_2sgpr_wr_addr, simd2_2sgpr_wr_addr, simd3_2sgpr_wr_addr, simf0_2sgpr_wr_addr,
         simf1_2sgpr_wr_addr, simf2_2sgpr_wr_addr, simf3_2sgpr_wr_addr, lsu2sgpr_dest_addr;
	wire [NUMOFCU*10 - 1:0] wave2decode_vgpr_base, simd0_2vgpr_dest_addr, simd1_2vgpr_dest_addr,
         simd2_2vgpr_dest_addr, simd3_2vgpr_dest_addr, simf0_2vgpr_dest_addr,
         simf1_2vgpr_dest_addr, simf2_2vgpr_dest_addr, simf3_2vgpr_dest_addr,
         lsu2vgpr_dest_addr;
	wire [NUMOFCU*15 - 1:0] cu2dispatch_wf_tag_done, fetch2tracemon_wf_tag;
	wire [NUMOFCU*16 - 1:0] wave2decode_lds_base, rfa2execvgprsgpr_select_fu;
	wire [NUMOFCU*32 - 1:0] fetch2buff_addr, simd0_2tracemon_retire_pc, simd1_2tracemon_retire_pc,
         simd2_2tracemon_retire_pc, simd3_2tracemon_retire_pc, simf0_2tracemon_retire_pc,
         simf1_2tracemon_retire_pc, simf2_2tracemon_retire_pc, simf3_2tracemon_retire_pc,
         salu2tracemon_retire_pc, lsu2tracemon_retire_pc, issue2tracemon_barrier_retire_pc,
         issue2tracemon_waitcnt_retire_pc, salu2fetch_branch_pc_value, decode2issue_instr_pc,
         salu2exec_wr_m0_value;
	wire [NUMOFCU*39 - 1:0] fetch2buff_tag;
	wire [NUMOFCU*40 - 1:0] issue2tracemon_barrier_retire_wf_bitmap;
	wire [NUMOFCU*64 - 1:0] lsu2mem_wr_mask, salu2exec_wr_exec_value, salu2exec_wr_vcc_value,
         salu2sgpr_dest_data, simd0_2exec_wr_vcc_value, simd0_2vgpr_wr_mask,
         simd1_2exec_wr_vcc_value, simd1_2vgpr_wr_mask, simd2_2exec_wr_vcc_value,
         simd2_2vgpr_wr_mask, simd3_2exec_wr_vcc_value, simd3_2vgpr_wr_mask,
         simf0_2exec_wr_vcc_value, simf0_2vgpr_wr_mask, simf1_2exec_wr_vcc_value,
         simf1_2vgpr_wr_mask, simf2_2exec_wr_vcc_value, simf2_2vgpr_wr_mask,
         simf3_2exec_wr_vcc_value, simf3_2vgpr_wr_mask, simd0_2sgpr_wr_data,
         simd1_2sgpr_wr_data, simd2_2sgpr_wr_data, simd3_2sgpr_wr_data, simf0_2sgpr_wr_data,
         simf1_2sgpr_wr_data, simf2_2sgpr_wr_data, simf3_2sgpr_wr_data, lsu2vgpr_dest_wr_mask,
         decode2tracemon_collinstr;
	wire [NUMOFCU*128 - 1:0] lsu2sgpr_dest_data;
	wire [NUMOFCU*2048 - 1:0] simd0_2vgpr_dest_data, simd1_2vgpr_dest_data,
         simd2_2vgpr_dest_data, simd3_2vgpr_dest_data, simf0_2vgpr_dest_data,
         simf1_2vgpr_dest_data, simf2_2vgpr_dest_data, simf3_2vgpr_dest_data;
	wire [31:0] lsu2mem_wr_data,lsu2mem_addr;
	wire [2047:0] lsu2vgpr_dest_data;

	// signals not a part of compute unit
	// from memory to tracemon
	wire [NUMOFCU*4 - 1:0] mem2tracemon_store_en;
	wire [NUMOFCU*2048 - 1:0] mem2tracemon_addr;
	wire [NUMOFCU*2048 - 1:0] mem2tracemon_store_data;

	compute_unit DUT[(NUMOFCU-1):0] (
		.dispatch2cu_wf_dispatch(dispatch2cu_wf_dispatch),
		.dispatch2cu_wf_tag_dispatch(dispatch2cu_wf_tag_dispatch),
		.dispatch2cu_start_pc_dispatch(dispatch2cu_start_pc_dispatch),
		.dispatch2cu_vgpr_base_dispatch(dispatch2cu_vgpr_base_dispatch),
		.dispatch2cu_sgpr_base_dispatch(dispatch2cu_sgpr_base_dispatch),
		.dispatch2cu_lds_base_dispatch(dispatch2cu_lds_base_dispatch),
		.dispatch2cu_wf_size_dispatch(dispatch2cu_wf_size_dispatch),
		.dispatch2cu_wg_wf_count(dispatch2cu_wg_wf_count),
		.mem2lsu_rd_data(mem2lsu_rd_data),
		.mem2lsu_tag_resp(mem2lsu_tag_resp),
		.mem2lsu_ack(mem2lsu_ack),
		.buff2fetchwave_ack(buff2fetchwave_ack),
		.buff2wave_instr(buff2wave_instr),
		.buff2wave_tag(buff2wave_tag),
		.cu2dispatch_wf_tag_done(cu2dispatch_wf_tag_done),
		.cu2dispatch_wf_done(cu2dispatch_wf_done),
		.lsu2mem_rd_en(lsu2mem_rd_en),
		.lsu2mem_wr_en(lsu2mem_wr_en),
		.lsu2mem_addr(lsu2mem_addr),
		.lsu2mem_wr_data(lsu2mem_wr_data),
		.lsu2mem_tag_req(lsu2mem_tag_req),
		.lsu2mem_wr_mask(lsu2mem_wr_mask),
		.lsu2mem_gm_or_lds(lsu2mem_gm_or_lds),
		.fetch2buff_rd_en(fetch2buff_rd_en),
		.fetch2buff_addr(fetch2buff_addr),
		.fetch2buff_tag(fetch2buff_tag),
		.simd0_2tracemon_retire_pc(simd0_2tracemon_retire_pc),
		.simd1_2tracemon_retire_pc(simd1_2tracemon_retire_pc),
		.simd2_2tracemon_retire_pc(simd2_2tracemon_retire_pc),
		.simd3_2tracemon_retire_pc(simd3_2tracemon_retire_pc),
		.simf0_2tracemon_retire_pc(simf0_2tracemon_retire_pc),
		.simf1_2tracemon_retire_pc(simf1_2tracemon_retire_pc),
		.simf2_2tracemon_retire_pc(simf2_2tracemon_retire_pc),
		.simf3_2tracemon_retire_pc(simf3_2tracemon_retire_pc),
		.salu2tracemon_retire_pc(salu2tracemon_retire_pc),
		.salu2tracemon_exec_word_sel(salu2tracemon_exec_word_sel),
		.salu2tracemon_vcc_word_sel(salu2tracemon_vcc_word_sel),
		.lsu2tracemon_retire_pc(lsu2tracemon_retire_pc),
        //.lsu2tracemon_addr(mem2tracemon_addr),
        .lsu2tracemon_store_data(mem2tracemon_store_data),
        .lsu2tracemon_idle(lsu2tracemon_idle),
		.issue2tracemon_barrier_retire_en(issue2tracemon_barrier_retire_en),
		.issue2tracemon_barrier_retire_wf_bitmap(issue2tracemon_barrier_retire_wf_bitmap),
		.issue2tracemon_barrier_retire_pc(issue2tracemon_barrier_retire_pc),
		.issue2tracemon_waitcnt_retire_en(issue2tracemon_waitcnt_retire_en),
		.issue2tracemon_waitcnt_retire_wfid(issue2tracemon_waitcnt_retire_wfid),
		.issue2tracemon_waitcnt_retire_pc(issue2tracemon_waitcnt_retire_pc),
		.wave2decode_instr_valid(wave2decode_instr_valid),
		.wave2decode_sgpr_base(wave2decode_sgpr_base),
		.wave2decode_vgpr_base(wave2decode_vgpr_base),
		.wave2decode_lds_base(wave2decode_lds_base),
		.wave2decode_wfid(wave2decode_wfid),
		.salu2sgpr_instr_done(salu2sgpr_instr_done),
		.salu2sgpr_instr_done_wfid(salu2sgpr_instr_done_wfid),
		.salu2exec_wr_exec_en(salu2exec_wr_exec_en),
		.salu2exec_wr_exec_value(salu2exec_wr_exec_value),
		.salu2exec_wr_vcc_en(salu2exec_wr_vcc_en),
		.salu2exec_wr_vcc_value(salu2exec_wr_vcc_value),
		.salu2exec_wr_scc_en(salu2exec_wr_scc_en),
		.salu2exec_wr_scc_value(salu2exec_wr_scc_value),
		.salu2sgpr_dest_wr_en(salu2sgpr_dest_wr_en),
		.salu2sgpr_dest_addr(salu2sgpr_dest_addr),
		.salu2sgpr_dest_data(salu2sgpr_dest_data),
		.simd0_2vgpr_instr_done(simd0_2vgpr_instr_done),
		.simd0_2vgpr_instr_done_wfid(simd0_2vgpr_instr_done_wfid),
		.simd1_2vgpr_instr_done(simd1_2vgpr_instr_done),
		.simd1_2vgpr_instr_done_wfid(simd1_2vgpr_instr_done_wfid),
		.simd2_2vgpr_instr_done(simd2_2vgpr_instr_done),
		.simd2_2vgpr_instr_done_wfid(simd2_2vgpr_instr_done_wfid),
		.simd3_2vgpr_instr_done(simd3_2vgpr_instr_done),
		.simd3_2vgpr_instr_done_wfid(simd3_2vgpr_instr_done_wfid),
		.simd0_2exec_wr_vcc_en(simd0_2exec_wr_vcc_en),
		.simd0_2exec_wr_vcc_value(simd0_2exec_wr_vcc_value),
		.simd0_2vgpr_wr_en(simd0_2vgpr_wr_en),
		.simd0_2vgpr_dest_addr(simd0_2vgpr_dest_addr),
		.simd0_2vgpr_dest_data(simd0_2vgpr_dest_data),
		.simd0_2vgpr_wr_mask(simd0_2vgpr_wr_mask),
		.simd1_2exec_wr_vcc_en(simd1_2exec_wr_vcc_en),
		.simd1_2exec_wr_vcc_value(simd1_2exec_wr_vcc_value),
		.simd1_2vgpr_wr_en(simd1_2vgpr_wr_en),
		.simd1_2vgpr_dest_addr(simd1_2vgpr_dest_addr),
		.simd1_2vgpr_dest_data(simd1_2vgpr_dest_data),
		.simd1_2vgpr_wr_mask(simd1_2vgpr_wr_mask),
		.simd2_2exec_wr_vcc_en(simd2_2exec_wr_vcc_en),
		.simd2_2exec_wr_vcc_value(simd2_2exec_wr_vcc_value),
		.simd2_2vgpr_wr_en(simd2_2vgpr_wr_en),
		.simd2_2vgpr_dest_addr(simd2_2vgpr_dest_addr),
		.simd2_2vgpr_dest_data(simd2_2vgpr_dest_data),
		.simd2_2vgpr_wr_mask(simd2_2vgpr_wr_mask),
		.simd3_2exec_wr_vcc_en(simd3_2exec_wr_vcc_en),
		.simd3_2exec_wr_vcc_value(simd3_2exec_wr_vcc_value),
		.simd3_2vgpr_wr_en(simd3_2vgpr_wr_en),
		.simd3_2vgpr_dest_addr(simd3_2vgpr_dest_addr),
		.simd3_2vgpr_dest_data(simd3_2vgpr_dest_data),
		.simd3_2vgpr_wr_mask(simd3_2vgpr_wr_mask),
		.simf0_2vgpr_instr_done(simf0_2vgpr_instr_done),
		.simf0_2vgpr_instr_done_wfid(simf0_2vgpr_instr_done_wfid),
		.simf1_2vgpr_instr_done(simf1_2vgpr_instr_done),
		.simf1_2vgpr_instr_done_wfid(simf1_2vgpr_instr_done_wfid),
		.simf2_2vgpr_instr_done(simf2_2vgpr_instr_done),
		.simf2_2vgpr_instr_done_wfid(simf2_2vgpr_instr_done_wfid),
		.simf3_2vgpr_instr_done(simf3_2vgpr_instr_done),
		.simf3_2vgpr_instr_done_wfid(simf3_2vgpr_instr_done_wfid),
		.simf0_2exec_wr_vcc_en(simf0_2exec_wr_vcc_en),
		.simf0_2exec_wr_vcc_value(simf0_2exec_wr_vcc_value),
		.simf0_2vgpr_wr_en(simf0_2vgpr_wr_en),
		.simf0_2vgpr_dest_addr(simf0_2vgpr_dest_addr),
		.simf0_2vgpr_dest_data(simf0_2vgpr_dest_data),
		.simf0_2vgpr_wr_mask(simf0_2vgpr_wr_mask),
		.simf1_2exec_wr_vcc_en(simf1_2exec_wr_vcc_en),
		.simf1_2exec_wr_vcc_value(simf1_2exec_wr_vcc_value),
		.simf1_2vgpr_wr_en(simf1_2vgpr_wr_en),
		.simf1_2vgpr_dest_addr(simf1_2vgpr_dest_addr),
		.simf1_2vgpr_dest_data(simf1_2vgpr_dest_data),
		.simf1_2vgpr_wr_mask(simf1_2vgpr_wr_mask),
		.simf2_2exec_wr_vcc_en(simf2_2exec_wr_vcc_en),
		.simf2_2exec_wr_vcc_value(simf2_2exec_wr_vcc_value),
		.simf2_2vgpr_wr_en(simf2_2vgpr_wr_en),
		.simf2_2vgpr_dest_addr(simf2_2vgpr_dest_addr),
		.simf2_2vgpr_dest_data(simf2_2vgpr_dest_data),
		.simf2_2vgpr_wr_mask(simf2_2vgpr_wr_mask),
		.simf3_2exec_wr_vcc_en(simf3_2exec_wr_vcc_en),
		.simf3_2exec_wr_vcc_value(simf3_2exec_wr_vcc_value),
		.simf3_2vgpr_wr_en(simf3_2vgpr_wr_en),
		.simf3_2vgpr_dest_addr(simf3_2vgpr_dest_addr),
		.simf3_2vgpr_dest_data(simf3_2vgpr_dest_data),
		.simf3_2vgpr_wr_mask(simf3_2vgpr_wr_mask),
		.simd0_2sgpr_wr_addr(simd0_2sgpr_wr_addr),
		.simd0_2sgpr_wr_en(simd0_2sgpr_wr_en),
		.simd0_2sgpr_wr_data(simd0_2sgpr_wr_data),
		.simd1_2sgpr_wr_addr(simd1_2sgpr_wr_addr),
		.simd1_2sgpr_wr_en(simd1_2sgpr_wr_en),
		.simd1_2sgpr_wr_data(simd1_2sgpr_wr_data),
		.simd2_2sgpr_wr_addr(simd2_2sgpr_wr_addr),
		.simd2_2sgpr_wr_en(simd2_2sgpr_wr_en),
		.simd2_2sgpr_wr_data(simd2_2sgpr_wr_data),
		.simd3_2sgpr_wr_addr(simd3_2sgpr_wr_addr),
		.simd3_2sgpr_wr_en(simd3_2sgpr_wr_en),
		.simd3_2sgpr_wr_data(simd3_2sgpr_wr_data),
		.simf0_2sgpr_wr_addr(simf0_2sgpr_wr_addr),
		.simf0_2sgpr_wr_en(simf0_2sgpr_wr_en),
		.simf0_2sgpr_wr_data(simf0_2sgpr_wr_data),
		.simf1_2sgpr_wr_addr(simf1_2sgpr_wr_addr),
		.simf1_2sgpr_wr_en(simf1_2sgpr_wr_en),
		.simf1_2sgpr_wr_data(simf1_2sgpr_wr_data),
		.simf2_2sgpr_wr_addr(simf2_2sgpr_wr_addr),
		.simf2_2sgpr_wr_en(simf2_2sgpr_wr_en),
		.simf2_2sgpr_wr_data(simf2_2sgpr_wr_data),
		.simf3_2sgpr_wr_addr(simf3_2sgpr_wr_addr),
		.simf3_2sgpr_wr_en(simf3_2sgpr_wr_en),
		.simf3_2sgpr_wr_data(simf3_2sgpr_wr_data),
		.lsu2sgpr_instr_done(lsu2sgpr_instr_done),
		.lsu2sgpr_instr_done_wfid(lsu2sgpr_instr_done_wfid),
		.lsu2sgpr_dest_wr_en(lsu2sgpr_dest_wr_en),
		.lsu2sgpr_dest_addr(lsu2sgpr_dest_addr),
		.lsu2sgpr_dest_data(lsu2sgpr_dest_data),
		.lsu2vgpr_instr_done(lsu2vgpr_instr_done),
		.lsu2vgpr_dest_data(lsu2vgpr_dest_data),
		.lsu2vgpr_dest_addr(lsu2vgpr_dest_addr),
		.lsu2vgpr_dest_wr_mask(lsu2vgpr_dest_wr_mask),
		.lsu2vgpr_instr_done_wfid(lsu2vgpr_instr_done_wfid),
		.lsu2vgpr_dest_wr_en(lsu2vgpr_dest_wr_en),
		.issue2fetchwave_wf_done_en(issue2fetchwave_wf_done_en),
		.issue2fetchwave_wf_done_wf_id(issue2fetchwave_wf_done_wf_id),
		.salu2fetchwaveissue_branch_wfid(salu2fetchwaveissue_branch_wfid),
		.salu2fetchwaveissue_branch_en(salu2fetchwaveissue_branch_en),
		.salu2fetchwaveissue_branch_taken(salu2fetchwaveissue_branch_taken),
		.salu2fetch_branch_pc_value(salu2fetch_branch_pc_value),
		.rfa2execvgprsgpr_select_fu(rfa2execvgprsgpr_select_fu),
		.decode2tracemon_collinstr(decode2tracemon_collinstr),
		.decode2tracemon_colldone(decode2tracemon_colldone),
		.decode2issue_valid(decode2issue_valid),
		.decode2issue_instr_pc(decode2issue_instr_pc),
		.decode2issue_wfid(decode2issue_wfid),
		.lsu2tracemon_gm_or_lds(lsu2tracemon_gm_or_lds),
		.fetch2tracemon_dispatch(fetch2tracemon_dispatch),
		.fetch2tracemon_wf_tag(fetch2tracemon_wf_tag),
		.fetch2tracemon_new_wfid(fetch2tracemon_new_wfid),
		.salu2exec_wr_m0_en(salu2exec_wr_m0_en),
		.salu2exec_wr_m0_value(salu2exec_wr_m0_value),
		.decode2issue_barrier(decode2issue_barrier),
		.clk(clk),
		.rst(rst)
	);

	instr_buffer #(.NUMOFCU(NUMOFCU)) instr_buffer0 (
		// Instruction buffer - modeled by the testbench.
		.clk(clk),
		.rst(rst),
		//  Inputs
		.fetch_rd_en(fetch2buff_rd_en),
		.fetch_addr(fetch2buff_addr),
		.fetch_tag(fetch2buff_tag),
		//  Outputs
		.fetchwave_ack(buff2fetchwave_ack),
		.wave_instr(buff2wave_instr),
		.wave_tag(buff2wave_tag)
	);

	memory #(.NUMOFCU(NUMOFCU)) memory0 (
		// Memory module - will be implemented by the testbench
		.clk(clk),
		.rst(rst),
		//  Inputs
		.gm_or_lds(lsu2mem_gm_or_lds),
		.rd_en(lsu2mem_rd_en),
		.wr_en(lsu2mem_wr_en),
		.addresses(lsu2mem_addr),
		.wr_data(lsu2mem_wr_data),
		.input_tag(lsu2mem_tag_req),
		//.wr_mask(lsu2mem_wr_mask),
		//  Outputs
		.rd_data(mem2lsu_rd_data),
		.output_tag(mem2lsu_tag_resp),
		.ack(mem2lsu_ack)
		//.tracemon_addr(mem2tracemon_addr),
		//.tracemon_store_data(mem2tracemon_store_data),
		//.tracemon_store_en(mem2tracemon_store_en)
	);
	// initial begin
	// 		//$monitor("read happened %b", lsu2mem_rd_en);
	// 		//$monitor("write happened %b", lsu2mem_wr_en);
	// 		//$monitor("retire happened %b", DUT[0].lsu0.mem_ctrl.retire);
	// 		//$monitor("sgpr happened %b", DUT[0].lsu0.sgpr_dest_wr_en);
	// 		$monitor("sgpr addr %b", DUT[0].lsu0.sgpr_dest_addr);
	// end
	initial begin
			//$monitor("read happened %b", lsu2mem_rd_en);
			//$monitor("write happened %b", lsu2mem_wr_en);
			//$monitor("retire happened %b", DUT[0].lsu0.mem_ctrl.retire);
			//$monitor("sgpr happened %b", DUT[0].lsu0.sgpr_dest_wr_en);
			//$monitor("sgpr data %h", DUT[0].lsu0.flops_mem_wb.flop_rd_data);
			//$monitor("sgpr addr %h", DUT[0].lsu2mem_addr);
			//$monitor("exec addr %h", DUT[0].lsu0.exec_exec_value);
			//$monitor("sgpr addr %h", DUT[0].lsu0.addr_calc.out_ld_st_addr);
			//$monitor("sgpr data %h", DUT[0].lsu0.flops_mem_wb.flop_rd_data);
	end

	//SAIF flow
	`ifdef SAIF
		initial begin
			$set_gate_level_monitoring("rtl_on", "mda");
			$set_toggle_region(gpu_tb.DUT[0]);
			#0;
			$toggle_start;
		end
	`endif

	//waveforms
	initial begin
		if ($test$plusargs("dump_waveforms")) begin
			$vcdpluson(0,gpu_tb);
			if ($test$plusargs("dump_glitches")) begin
				$vcdplusdeltacycleon;
				$vcdplusglitchon;
			end
		end
	end

	genvar tg;

	generate
		for (tg=0; tg < NUMOFCU; tg=tg+1) begin : TT

			tracemon #(.CUID(tg)) tracemon0 (
				// Dummy unit to aid testbench
				.issue2tracemon_barrier_retire_en(issue2tracemon_barrier_retire_en),
				.issue2tracemon_barrier_retire_wf_bitmap(issue2tracemon_barrier_retire_wf_bitmap),
				.issue2tracemon_barrier_retire_pc(issue2tracemon_barrier_retire_pc),
				.issue2tracemon_waitcnt_retire_en(issue2tracemon_waitcnt_retire_en),
				.issue2tracemon_waitcnt_retire_wfid(issue2tracemon_waitcnt_retire_wfid),
				.issue2tracemon_waitcnt_retire_pc(issue2tracemon_waitcnt_retire_pc),
				.simd0_2tracemon_retire_pc(simd0_2tracemon_retire_pc),
				.simd1_2tracemon_retire_pc(simd1_2tracemon_retire_pc),
				.simd2_2tracemon_retire_pc(simd2_2tracemon_retire_pc),
				.simd3_2tracemon_retire_pc(simd3_2tracemon_retire_pc),
				.simf0_2tracemon_retire_pc(simf0_2tracemon_retire_pc),
				.simf1_2tracemon_retire_pc(simf1_2tracemon_retire_pc),
				.simf2_2tracemon_retire_pc(simf2_2tracemon_retire_pc),
				.simf3_2tracemon_retire_pc(simf3_2tracemon_retire_pc),
				.lsu2mem_rd_en(lsu2mem_rd_en),
                .lsu2mem_wr_en(lsu2mem_wr_en),
                .lsu2tracemon_retire_pc(lsu2tracemon_retire_pc),
				.salu2tracemon_retire_pc(salu2tracemon_retire_pc),
				.salu2tracemon_exec_word_sel(salu2tracemon_exec_word_sel),
				.salu2tracemon_vcc_word_sel(salu2tracemon_vcc_word_sel),
				.wave2decode_instr_valid(wave2decode_instr_valid),
				.wave2decode_sgpr_base(wave2decode_sgpr_base),
				.wave2decode_vgpr_base(wave2decode_vgpr_base),
				.wave2decode_lds_base(wave2decode_lds_base),
				.wave2decode_wfid(wave2decode_wfid),
				.salu2sgpr_instr_done(salu2sgpr_instr_done),
				.salu2sgpr_instr_done_wfid(salu2sgpr_instr_done_wfid),
				.salu2exec_wr_exec_en(salu2exec_wr_exec_en),
				.salu2exec_wr_exec_value(salu2exec_wr_exec_value),
				.salu2exec_wr_vcc_en(salu2exec_wr_vcc_en),
				.salu2exec_wr_vcc_value(salu2exec_wr_vcc_value),
				.salu2exec_wr_scc_en(salu2exec_wr_scc_en),
				.salu2exec_wr_scc_value(salu2exec_wr_scc_value),
				.salu2sgpr_dest_wr_en(salu2sgpr_dest_wr_en),
				.salu2sgpr_dest_addr(salu2sgpr_dest_addr),
				.salu2sgpr_dest_data(salu2sgpr_dest_data),
				.salu2fetchwaveissue_branch_wfid(salu2fetchwaveissue_branch_wfid),
				.salu2fetchwaveissue_branch_en(salu2fetchwaveissue_branch_en),
				.salu2fetchwaveissue_branch_taken(salu2fetchwaveissue_branch_taken),
				.salu2fetch_branch_pc_value(salu2fetch_branch_pc_value),
				.simd0_2vgpr_instr_done(simd0_2vgpr_instr_done),
				.simd0_2vgpr_instr_done_wfid(simd0_2vgpr_instr_done_wfid),
				.simd1_2vgpr_instr_done(simd1_2vgpr_instr_done),
				.simd1_2vgpr_instr_done_wfid(simd1_2vgpr_instr_done_wfid),
				.simd2_2vgpr_instr_done(simd2_2vgpr_instr_done),
				.simd2_2vgpr_instr_done_wfid(simd2_2vgpr_instr_done_wfid),
				.simd3_2vgpr_instr_done(simd3_2vgpr_instr_done),
				.simd3_2vgpr_instr_done_wfid(simd3_2vgpr_instr_done_wfid),
				.simd0_2exec_wr_vcc_en(simd0_2exec_wr_vcc_en),
				.simd0_2exec_wr_vcc_value(simd0_2exec_wr_vcc_value),
				.simd0_2vgpr_wr_en(simd0_2vgpr_wr_en),
				.simd0_2vgpr_dest_addr(simd0_2vgpr_dest_addr),
				.simd0_2vgpr_dest_data(simd0_2vgpr_dest_data),
				.simd0_2vgpr_wr_mask(simd0_2vgpr_wr_mask),
				.simd1_2exec_wr_vcc_en(simd1_2exec_wr_vcc_en),
				.simd1_2exec_wr_vcc_value(simd1_2exec_wr_vcc_value),
				.simd1_2vgpr_wr_en(simd1_2vgpr_wr_en),
				.simd1_2vgpr_dest_addr(simd1_2vgpr_dest_addr),
				.simd1_2vgpr_dest_data(simd1_2vgpr_dest_data),
				.simd1_2vgpr_wr_mask(simd1_2vgpr_wr_mask),
				.simd2_2exec_wr_vcc_en(simd2_2exec_wr_vcc_en),
				.simd2_2exec_wr_vcc_value(simd2_2exec_wr_vcc_value),
				.simd2_2vgpr_wr_en(simd2_2vgpr_wr_en),
				.simd2_2vgpr_dest_addr(simd2_2vgpr_dest_addr),
				.simd2_2vgpr_dest_data(simd2_2vgpr_dest_data),
				.simd2_2vgpr_wr_mask(simd2_2vgpr_wr_mask),
				.simd3_2exec_wr_vcc_en(simd3_2exec_wr_vcc_en),
				.simd3_2exec_wr_vcc_value(simd3_2exec_wr_vcc_value),
				.simd3_2vgpr_wr_en(simd3_2vgpr_wr_en),
				.simd3_2vgpr_dest_addr(simd3_2vgpr_dest_addr),
				.simd3_2vgpr_dest_data(simd3_2vgpr_dest_data),
				.simd3_2vgpr_wr_mask(simd3_2vgpr_wr_mask),
				.simf0_2vgpr_instr_done(simf0_2vgpr_instr_done),
				.simf0_2vgpr_instr_done_wfid(simf0_2vgpr_instr_done_wfid),
				.simf1_2vgpr_instr_done(simf1_2vgpr_instr_done),
				.simf1_2vgpr_instr_done_wfid(simf1_2vgpr_instr_done_wfid),
				.simf2_2vgpr_instr_done(simf2_2vgpr_instr_done),
				.simf2_2vgpr_instr_done_wfid(simf2_2vgpr_instr_done_wfid),
				.simf3_2vgpr_instr_done(simf3_2vgpr_instr_done),
				.simf3_2vgpr_instr_done_wfid(simf3_2vgpr_instr_done_wfid),
				.simf0_2exec_wr_vcc_en(simf0_2exec_wr_vcc_en),
				.simf0_2exec_wr_vcc_value(simf0_2exec_wr_vcc_value),
				.simf0_2vgpr_wr_en(simf0_2vgpr_wr_en),
				.simf0_2vgpr_dest_addr(simf0_2vgpr_dest_addr),
				.simf0_2vgpr_dest_data(simf0_2vgpr_dest_data),
				.simf0_2vgpr_wr_mask(simf0_2vgpr_wr_mask),
				.simf1_2exec_wr_vcc_en(simf1_2exec_wr_vcc_en),
				.simf1_2exec_wr_vcc_value(simf1_2exec_wr_vcc_value),
				.simf1_2vgpr_wr_en(simf1_2vgpr_wr_en),
				.simf1_2vgpr_dest_addr(simf1_2vgpr_dest_addr),
				.simf1_2vgpr_dest_data(simf1_2vgpr_dest_data),
				.simf1_2vgpr_wr_mask(simf1_2vgpr_wr_mask),
				.simf2_2exec_wr_vcc_en(simf2_2exec_wr_vcc_en),
				.simf2_2exec_wr_vcc_value(simf2_2exec_wr_vcc_value),
				.simf2_2vgpr_wr_en(simf2_2vgpr_wr_en),
				.simf2_2vgpr_dest_addr(simf2_2vgpr_dest_addr),
				.simf2_2vgpr_dest_data(simf2_2vgpr_dest_data),
				.simf2_2vgpr_wr_mask(simf2_2vgpr_wr_mask),
				.simf3_2exec_wr_vcc_en(simf3_2exec_wr_vcc_en),
				.simf3_2exec_wr_vcc_value(simf3_2exec_wr_vcc_value),
				.simf3_2vgpr_wr_en(simf3_2vgpr_wr_en),
				.simf3_2vgpr_dest_addr(simf3_2vgpr_dest_addr),
				.simf3_2vgpr_dest_data(simf3_2vgpr_dest_data),
				.simf3_2vgpr_wr_mask(simf3_2vgpr_wr_mask),
				.simd0_2sgpr_wr_addr(simd0_2sgpr_wr_addr),
				.simd0_2sgpr_wr_en(simd0_2sgpr_wr_en),
				.simd0_2sgpr_wr_data(simd0_2sgpr_wr_data),
				.simd1_2sgpr_wr_addr(simd1_2sgpr_wr_addr),
				.simd1_2sgpr_wr_en(simd1_2sgpr_wr_en),
				.simd1_2sgpr_wr_data(simd1_2sgpr_wr_data),
				.simd2_2sgpr_wr_addr(simd2_2sgpr_wr_addr),
				.simd2_2sgpr_wr_en(simd2_2sgpr_wr_en),
				.simd2_2sgpr_wr_data(simd2_2sgpr_wr_data),
				.simd3_2sgpr_wr_addr(simd3_2sgpr_wr_addr),
				.simd3_2sgpr_wr_en(simd3_2sgpr_wr_en),
				.simd3_2sgpr_wr_data(simd3_2sgpr_wr_data),
				.simf0_2sgpr_wr_addr(simf0_2sgpr_wr_addr),
				.simf0_2sgpr_wr_en(simf0_2sgpr_wr_en),
				.simf0_2sgpr_wr_data(simf0_2sgpr_wr_data),
				.simf1_2sgpr_wr_addr(simf1_2sgpr_wr_addr),
				.simf1_2sgpr_wr_en(simf1_2sgpr_wr_en),
				.simf1_2sgpr_wr_data(simf1_2sgpr_wr_data),
				.simf2_2sgpr_wr_addr(simf2_2sgpr_wr_addr),
				.simf2_2sgpr_wr_en(simf2_2sgpr_wr_en),
				.simf2_2sgpr_wr_data(simf2_2sgpr_wr_data),
				.simf3_2sgpr_wr_addr(simf3_2sgpr_wr_addr),
				.simf3_2sgpr_wr_en(simf3_2sgpr_wr_en),
				.simf3_2sgpr_wr_data(simf3_2sgpr_wr_data),
				.lsu2sgpr_instr_done(lsu2sgpr_instr_done),
				.lsu2sgpr_instr_done_wfid(lsu2sgpr_instr_done_wfid),
				.lsu2sgpr_dest_wr_en(lsu2sgpr_dest_wr_en),
				.lsu2sgpr_dest_addr(lsu2sgpr_dest_addr),
				.lsu2sgpr_dest_data(lsu2sgpr_dest_data),
				.lsu2vgpr_instr_done(lsu2vgpr_instr_done),
				.lsu2vgpr_dest_data(lsu2vgpr_dest_data),
				.lsu2vgpr_dest_addr(lsu2vgpr_dest_addr),
				.lsu2vgpr_dest_wr_mask(lsu2vgpr_dest_wr_mask),
				.lsu2vgpr_instr_done_wfid(lsu2vgpr_instr_done_wfid),
				.lsu2vgpr_dest_wr_en(lsu2vgpr_dest_wr_en),
				.issue2fetchwave_wf_done_en(issue2fetchwave_wf_done_en),
				.issue2fetchwave_wf_done_wf_id(issue2fetchwave_wf_done_wf_id),
				//.mem2tracemon_addr(mem2tracemon_addr),lsu2mem_addr
                .mem2tracemon_addr(lsu2mem_addr),
				.mem2tracemon_store_data(mem2tracemon_store_data),
				.mem2tracemon_store_en(mem2tracemon_store_en),
				.decode2tracemon_collinstr(decode2tracemon_collinstr),
				.decode2tracemon_colldone(decode2tracemon_colldone),
				.decode2issue_instr_pc(decode2issue_instr_pc),
				.decode2issue_valid(decode2issue_valid),
				.decode2issue_wfid(decode2issue_wfid),
				.rfa2execvgprsgpr_select_fu(rfa2execvgprsgpr_select_fu),
				.lsu2tracemon_gm_or_lds(lsu2tracemon_gm_or_lds),
                .lsu2tracemon_idle(lsu2tracemon_idle),
				.fetch2tracemon_dispatch(fetch2tracemon_dispatch),
				.fetch2tracemon_wf_tag(fetch2tracemon_wf_tag),
				.fetch2tracemon_new_wfid(fetch2tracemon_new_wfid),
				.salu2exec_wr_m0_en(salu2exec_wr_m0_en),
				.salu2exec_wr_m0_value(salu2exec_wr_m0_value),
				.decode2issue_barrier(decode2issue_barrier),
				.clk(clk),
				.rst(rst),
				.kernel_id(iter-1)
			);

		end
	endgenerate

	//genvar pg;

	//generate
	//	for (pg=0; pg < NUMOFCU; pg=pg+1) begin : PT

	//		profiler #(.CUID(pg)) profiler0 (
	//			// unit to aid in profiling
	//			.salu2sgpr_instr_done(salu2sgpr_instr_done),
	//			.salu2fetchwaveissue_branch_en(salu2fetchwaveissue_branch_en),
	//			.simd0_2vgpr_instr_done(DUT[pg].simd0_2rfa_queue_entry_valid),
	//			.simd1_2vgpr_instr_done(DUT[pg].simd1_2rfa_queue_entry_valid),
	//			.simd2_2vgpr_instr_done(DUT[pg].simd2_2rfa_queue_entry_valid),
	//			.simd3_2vgpr_instr_done(DUT[pg].simd3_2rfa_queue_entry_valid),
	//			.simf0_2vgpr_instr_done(DUT[pg].simf0_2rfa_queue_entry_valid),
	//			.simf1_2vgpr_instr_done(DUT[pg].simf1_2rfa_queue_entry_valid),
	//			.simf2_2vgpr_instr_done(DUT[pg].simf2_2rfa_queue_entry_valid),
	//			.simf3_2vgpr_instr_done(DUT[pg].simf3_2rfa_queue_entry_valid),
	//			.rfa2execvgprsgpr_select_fu(rfa2execvgprsgpr_select_fu),
	//			.lsu2vgpr_instr_done(lsu2vgpr_instr_done),
	//			.lsu2sgpr_instr_done(lsu2sgpr_instr_done),
	//			.salu_alu_select(DUT[pg].issue2salu_alu_select),
	//			.simd0_alu_select(DUT[pg].issue2simd0_alu_select),
	//			.simd1_alu_select(DUT[pg].issue2simd1_alu_select),
	//			.simd2_alu_select(DUT[pg].issue2simd2_alu_select),
	//			.simd3_alu_select(DUT[pg].issue2simd3_alu_select),
	//			.simf0_alu_select(DUT[pg].issue2simf0_alu_select),
	//			.simf1_alu_select(DUT[pg].issue2simf1_alu_select),
	//			.simf2_alu_select(DUT[pg].issue2simf2_alu_select),
	//			.simf3_alu_select(DUT[pg].issue2simf3_alu_select),
	//			.lsu_select(DUT[pg].issue2lsu_lsu_select),
	//			.clk(clk)
	//		);

	//	end
	//endgenerate

	initial begin
		$display("Starting");
		cycle_count = 0;
		//instr_count = 0;
	end

	initial begin
		clk = 0;
		while (1) begin
			`ifdef GATES
				$value$plusargs("CLOCKPERIOD=%d",clockperiod);
				half_clockperiod = clockperiod / 2;
				deassert_reset = (clockperiod * 12) + half_clockperiod + (half_clockperiod / 2);
				#half_clockperiod;
				if(clk == 1'b0)
				begin
					$display("GATES MONITOR %m : Posedge of CLK at time %t", $time);
				end
			`else
				#2; //Period is 4 clock ticks or 4ns for rtl
			`endif
			clk = ~clk;
		end
	end

	initial begin
		rst = 1;
		`ifdef GATES
			#1;
			#(deassert_reset-1);
		`else
			#51; //Period is 4 clock ticks; So reset is deasserted after 12.75 clock periods
		`endif
		rst = 0;
	end

	initial begin
		iter = 0;
		wf_rem = 0;

		// maximum simulation time
		$value$plusargs("KILLTIME=%d",killtime);
		$display("gpu_tb.v: Setting simulation time limit of #%d", killtime);
		#killtime;
		$display("gpu_tb.v: Simulation terminated. Maximum simulation time of #%d reached!", killtime);
		terminate();
	end

	always @(posedge clk) begin
		if (wf_rem <= 0) begin
			$display ("--------------------------------------");
			$display("Initializing kernel: %d", iter);
			$display ("--------------------------------------");
			
            kern = Initialize(NUMOFCU, iter);
			if (kern <= 0) terminate();

			#0;

			wf_rem = getTotalWavefronts();
				
			$display ("--------------------------------------");
			$display("Number of wavefronts: %d", wf_rem);
			$display ("--------------------------------------");
			
            $readmemh("instr.mem", instr_buffer0.instr_memory);
			$readmemh("data.mem", memory0.data_memory);

			iter = iter + 1;
		end
	end

	always @ (posedge clk) begin
		if (rst) begin
			// check       <= 1'b0;
			dispatch2cu_wf_dispatch <= 'b0;
		end
	end

	always @ (posedge clk) begin
		cycle_count = cycle_count + 1;
		if (!rst) begin
			if (ScheduleWavefront()==1'b1) begin
				#1
				thrds		= getWfNumThrds();
				setVregs	= getSetVregs();
				setSregs	= getSetSregs();
				cuid		= getCuId();

				// set vregs
				for (x = 0; x < setVregs; x++) begin
					vregKey = getVregKey(x, 0);
					for (y = 0; y < thrds; y++) begin
						vregVal = getVregValue(x, y);
						// set the vregister
						for(a = 0; a < 32; a++) begin
							setVregValue(cuid, y, vregKey, a, vregVal[a]);
							//DUT[cuid].vgpr0.reg_file.bank[y].word[vregKey].bits[a].dff_0.state = vregVal[a];
						end
					end
				end

				// set sregs
				for (z = 0; z < setSregs; z++) begin
					sregKey = getSregKey(z);
					sregVal = getSregValue(z);
					// set the sregister
					for(a = 0; a < 32; a++) begin
						setSregValue(cuid, sregKey, a, sregVal[a]);
						//DUT[cuid].sgpr0.sgpr_reg_file.word[sregKey].bits[a].dff_0.state = sregVal[a];
					end
				end

				dispatch2cu_vgpr_base_dispatch     <= getVregBase();
				dispatch2cu_sgpr_base_dispatch     <= getSregBase();
				dispatch2cu_lds_base_dispatch      <= getLdsBase();
				vregsize     <= getVregSize();
				sregsize     <= getSregSize();
				ldssize      <= getLdsSize();
				dispatch2cu_start_pc_dispatch      <= getPC();
				dispatch2cu_wf_size_dispatch       <= getWfNumThrds() - 1;
				dispatch2cu_wf_tag_dispatch        <= getWfTag();
				dispatch2cu_wg_wf_count            <= getWfCnt();

				for (m = 0; m < NUMOFCU; m++) begin
					// $display("CUID: %d",getCuId());
					if(m==getCuId()) dispatch2cu_wf_dispatch[m]  <= 1'b1;
					else dispatch2cu_wf_dispatch[m] <= 1'b0;
					// $display("m: %d dispatch2cu_wf_dispatch: %d",m,dispatch2cu_wf_dispatch[m]);
				end
			end
			else begin
				for ( m = 0; m < NUMOFCU; m++) begin
					dispatch2cu_vgpr_base_dispatch     <= 10'bx;
					dispatch2cu_sgpr_base_dispatch     <= 9'bx;
					dispatch2cu_lds_base_dispatch      <= 16'bx;
					vregsize     <= 10'bx;
					sregsize     <= 9'bx;
					ldssize      <= 16'bx;
					dispatch2cu_start_pc_dispatch      <= 32'bx;
					dispatch2cu_wf_size_dispatch       <= 6'bx;
					dispatch2cu_wf_tag_dispatch        <= 11'bx;
					dispatch2cu_wf_dispatch[m]         <= 1'b0;
				end
			end

			if(|{dispatch2cu_wf_dispatch, cu2dispatch_wf_done})
				$display ("--------------------------------------");

			for(n=0; n<NUMOFCU; n++) begin
				if(|{dispatch2cu_wf_dispatch[n], cu2dispatch_wf_done[n]})
					$display ("Time: %g CU: %d Dispatch: %b cu2dispatch_wf_done: %b", $time, n, dispatch2cu_wf_dispatch[n], cu2dispatch_wf_done[n]);
			end

			if(|dispatch2cu_wf_dispatch) begin
				$display ("VGPR_Size value: %d", vregsize);
				$display ("SREG_Size value: %d", sregsize);
				$display ("LDS_Size value: %d", ldssize);
				$display ("PC value: %d", dispatch2cu_start_pc_dispatch);
				$display ("WFID: %d", dispatch2cu_wf_tag_dispatch);
			end
		end
	end

	always @ (posedge clk) begin
		for(n=0; n<NUMOFCU; n++) begin
			if (cu2dispatch_wf_done[n]) begin
				DescheduleWavefront(n, cu2dispatch_wf_tag_done[((n * 15) + 14)-:15]); // cuid
				$display("Descheduled WFID: %d from CU: %d", cu2dispatch_wf_tag_done[((n * 15) + 14)-:15], n);
				$display ("--------------------------------------");
				wf_rem = wf_rem - 1;
				$display("Wavefronts remaining : %d", wf_rem);
			end
		end
	end

	//fault_injection fault_injector(.clk(clk));
integer loop;
	task terminate;
		begin
			`ifdef SAIF
				$toggle_stop;
				$toggle_report("backward.saif",1.0e-9,"gpu_tb.DUT[0]");
			`endif
		// 	for(loop = 0; loop<1000; loop=loop+1) begin
		// 	$display("tracemon my %d: %h",loop, memory0.data_memory[loop]);
		// end
			$finish;
		end
	endtask

endmodule

