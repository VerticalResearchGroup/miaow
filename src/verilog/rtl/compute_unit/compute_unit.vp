module compute_unit
  ( 
    /*AUTOARG*/
   // Outputs
   cu2dispatch_wf_done, cu2dispatch_wf_tag_done,
   fetch2buff_rd_en, fetch2buff_addr, fetch2buff_tag,
   lsu2mem_rd_en, lsu2mem_wr_en, lsu2mem_tag_req, lsu2mem_wr_mask,
   lsu2mem_addr, lsu2mem_wr_data, lsu2mem_gm_or_lds,
`ifdef FPGA_BUILD
  sgpr2dispatch_rd_data,
  vgpr2dispatch_rd_data,
`endif
`ifndef FPGA_BUILD
   issue2tracemon_barrier_retire_en, issue2tracemon_waitcnt_retire_en,
   wave2decode_instr_valid, salu2sgpr_instr_done,
   salu2exec_wr_exec_en, salu2exec_wr_vcc_en, salu2exec_wr_scc_en,
   salu2exec_wr_scc_value, simd0_2vgpr_instr_done,
   simd1_2vgpr_instr_done, simd2_2vgpr_instr_done,
   simd3_2vgpr_instr_done, simd0_2exec_wr_vcc_en, simd0_2vgpr_wr_en,
   simd1_2exec_wr_vcc_en, simd1_2vgpr_wr_en, simd2_2exec_wr_vcc_en,
   simd2_2vgpr_wr_en, simd3_2exec_wr_vcc_en, simd3_2vgpr_wr_en,
   simf0_2vgpr_instr_done, simf1_2vgpr_instr_done,
   simf2_2vgpr_instr_done, simf3_2vgpr_instr_done,
   simf0_2exec_wr_vcc_en, simf0_2vgpr_wr_en, simf1_2exec_wr_vcc_en,
   simf1_2vgpr_wr_en, simf2_2exec_wr_vcc_en, simf2_2vgpr_wr_en,
   simf3_2exec_wr_vcc_en, simf3_2vgpr_wr_en, simd0_2sgpr_wr_en,
   simd1_2sgpr_wr_en, simd2_2sgpr_wr_en, simd3_2sgpr_wr_en,
   simf0_2sgpr_wr_en, simf1_2sgpr_wr_en, simf2_2sgpr_wr_en,
   simf3_2sgpr_wr_en, lsu2sgpr_instr_done, lsu2vgpr_instr_done,
   issue2fetchwave_wf_done_en, salu2fetchwaveissue_branch_en,
   salu2fetchwaveissue_branch_taken, decode2tracemon_colldone,
   decode2issue_valid,
   lsu2tracemon_gm_or_lds, lsu2tracemon_addr, lsu2tracemon_store_data, lsu2tracemon_store_enable, lsu2tracemon_idle,
   fetch2tracemon_dispatch, salu2exec_wr_m0_en, decode2issue_barrier,
   salu2tracemon_exec_word_sel, salu2tracemon_vcc_word_sel,
   salu2sgpr_dest_wr_en, 
   lsu2sgpr_dest_wr_en, lsu2vgpr_dest_wr_en,
   issue2tracemon_waitcnt_retire_wfid, wave2decode_wfid,
   salu2sgpr_instr_done_wfid, simd0_2vgpr_instr_done_wfid,
   simd1_2vgpr_instr_done_wfid, simd2_2vgpr_instr_done_wfid,
   simd3_2vgpr_instr_done_wfid, simf0_2vgpr_instr_done_wfid,
   simf1_2vgpr_instr_done_wfid, simf2_2vgpr_instr_done_wfid,
   simf3_2vgpr_instr_done_wfid, lsu2sgpr_instr_done_wfid,
   lsu2vgpr_instr_done_wfid, issue2fetchwave_wf_done_wf_id,
   salu2fetchwaveissue_branch_wfid, decode2issue_wfid,
   fetch2tracemon_new_wfid, wave2decode_sgpr_base,
   salu2sgpr_dest_addr, simd0_2sgpr_wr_addr, simd1_2sgpr_wr_addr,
   simd2_2sgpr_wr_addr, simd3_2sgpr_wr_addr, simf0_2sgpr_wr_addr,
   simf1_2sgpr_wr_addr, simf2_2sgpr_wr_addr, simf3_2sgpr_wr_addr,
   lsu2sgpr_dest_addr, wave2decode_vgpr_base, simd0_2vgpr_dest_addr,
   simd1_2vgpr_dest_addr, simd2_2vgpr_dest_addr,
   simd3_2vgpr_dest_addr, simf0_2vgpr_dest_addr,
   simf1_2vgpr_dest_addr, simf2_2vgpr_dest_addr,
   simf3_2vgpr_dest_addr, lsu2vgpr_dest_addr,
   fetch2tracemon_wf_tag, wave2decode_lds_base,
   rfa2execvgprsgpr_select_fu,
   simd0_2tracemon_retire_pc, simd1_2tracemon_retire_pc,
   simd2_2tracemon_retire_pc, simd3_2tracemon_retire_pc,
   simf0_2tracemon_retire_pc, simf1_2tracemon_retire_pc,
   simf2_2tracemon_retire_pc, simf3_2tracemon_retire_pc,
   salu2tracemon_retire_pc, lsu2tracemon_retire_pc,
   issue2tracemon_barrier_retire_pc, issue2tracemon_waitcnt_retire_pc,
   salu2fetch_branch_pc_value, decode2issue_instr_pc,
   salu2exec_wr_m0_value,
   issue2tracemon_barrier_retire_wf_bitmap,
   salu2exec_wr_exec_value, salu2exec_wr_vcc_value,
   salu2sgpr_dest_data, simd0_2exec_wr_vcc_value, simd0_2vgpr_wr_mask,
   simd1_2exec_wr_vcc_value, simd1_2vgpr_wr_mask,
   simd2_2exec_wr_vcc_value, simd2_2vgpr_wr_mask,
   simd3_2exec_wr_vcc_value, simd3_2vgpr_wr_mask,
   simf0_2exec_wr_vcc_value, simf0_2vgpr_wr_mask,
   simf1_2exec_wr_vcc_value, simf1_2vgpr_wr_mask,
   simf2_2exec_wr_vcc_value, simf2_2vgpr_wr_mask,
   simf3_2exec_wr_vcc_value, simf3_2vgpr_wr_mask, simd0_2sgpr_wr_data,
   simd1_2sgpr_wr_data, simd2_2sgpr_wr_data, simd3_2sgpr_wr_data,
   simf0_2sgpr_wr_data, simf1_2sgpr_wr_data, simf2_2sgpr_wr_data,
   simf3_2sgpr_wr_data, lsu2vgpr_dest_wr_mask,
   decode2tracemon_collinstr, lsu2sgpr_dest_data,
   simd0_2vgpr_dest_data, simd1_2vgpr_dest_data,
   simd2_2vgpr_dest_data, simd3_2vgpr_dest_data,
   simf0_2vgpr_dest_data, simf1_2vgpr_dest_data,
   simf2_2vgpr_dest_data, simf3_2vgpr_dest_data,
   lsu2vgpr_dest_data,
`endif
   // Inputs
`ifdef FPGA_BUILD
  dispatch2sgpr_addr, dispatch2sgpr_wr_data, dispatch2sgpr_wr_en,
  dispatch2vgpr_addr, dispatch2vgpr_wr_data, dispatch2vgpr_wr_en, dispatch2vgpr_wr_mask,
  dispatch2cu_idle,
`endif
  dispatch2cu_wf_dispatch, dispatch2cu_wf_tag_dispatch, dispatch2cu_start_pc_dispatch,
  dispatch2cu_sgpr_base_dispatch, dispatch2cu_vgpr_base_dispatch, dispatch2cu_lds_base_dispatch,
  buff2fetchwave_ack, buff2wave_instr, buff2wave_tag,
  dispatch2cu_wg_wf_count, dispatch2cu_wf_size_dispatch,
  mem2lsu_ack, mem2lsu_tag_resp, mem2lsu_rd_data,
  clk, rst
);

  input clk;
  input rst;

  input dispatch2cu_wf_dispatch, mem2lsu_ack, buff2fetchwave_ack;
  input [3:0] dispatch2cu_wg_wf_count;
  input [5:0] dispatch2cu_wf_size_dispatch;
  input [6:0] mem2lsu_tag_resp;
  input [8:0] dispatch2cu_sgpr_base_dispatch;
  input [9:0] dispatch2cu_vgpr_base_dispatch;
  input [14:0] dispatch2cu_wf_tag_dispatch;
  input [15:0] dispatch2cu_lds_base_dispatch;
  input [31:0] dispatch2cu_start_pc_dispatch, buff2wave_instr;
  input [38:0] buff2wave_tag;
  input [31:0] mem2lsu_rd_data;
  
`ifdef FPGA_BUILD
  input dispatch2cu_idle;
  input [8:0] dispatch2sgpr_addr;
  input [127:0] dispatch2sgpr_wr_data;
  input dispatch2sgpr_wr_en;
  
  input [9:0] dispatch2vgpr_addr;
  input [2047:0] dispatch2vgpr_wr_data;
  input dispatch2vgpr_wr_en;
  input [63:0] dispatch2vgpr_wr_mask;
  
  output [127:0] sgpr2dispatch_rd_data;
  output [2047:0] vgpr2dispatch_rd_data;
`endif

  output 	  cu2dispatch_wf_done, fetch2buff_rd_en, lsu2mem_rd_en, lsu2mem_wr_en, lsu2mem_gm_or_lds;

  output [6:0] lsu2mem_tag_req;
  output [63:0] lsu2mem_wr_mask;
  output [31:0] lsu2mem_wr_data, lsu2mem_addr;

  output [31:0] fetch2buff_addr;
  output [38:0]  fetch2buff_tag;
  
  output [14:0] cu2dispatch_wf_tag_done;
`ifndef FPGA_BUILD
   output issue2tracemon_barrier_retire_en,
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
		  decode2issue_valid, fetch2tracemon_dispatch,
		  salu2exec_wr_m0_en, decode2issue_barrier;

    output lsu2tracemon_gm_or_lds;
    output [2047:0] lsu2tracemon_addr;
    output [2047:0] lsu2tracemon_store_data;
    output lsu2tracemon_store_enable, lsu2tracemon_idle;
   output [1:0]   salu2tracemon_exec_word_sel, salu2tracemon_vcc_word_sel,
		  salu2sgpr_dest_wr_en;
   output [3:0]   lsu2sgpr_dest_wr_en;
   output lsu2vgpr_dest_wr_en;
   output [5:0]   issue2tracemon_waitcnt_retire_wfid, wave2decode_wfid, salu2sgpr_instr_done_wfid,
		  simd0_2vgpr_instr_done_wfid, simd1_2vgpr_instr_done_wfid, simd2_2vgpr_instr_done_wfid,
		  simd3_2vgpr_instr_done_wfid, simf0_2vgpr_instr_done_wfid, simf1_2vgpr_instr_done_wfid,
		  simf2_2vgpr_instr_done_wfid, simf3_2vgpr_instr_done_wfid, lsu2sgpr_instr_done_wfid,
		  lsu2vgpr_instr_done_wfid, issue2fetchwave_wf_done_wf_id, salu2fetchwaveissue_branch_wfid,
		  decode2issue_wfid, fetch2tracemon_new_wfid;
   
   output [8:0]   wave2decode_sgpr_base, salu2sgpr_dest_addr, simd0_2sgpr_wr_addr,
		  simd1_2sgpr_wr_addr, simd2_2sgpr_wr_addr, simd3_2sgpr_wr_addr, simf0_2sgpr_wr_addr,
		  simf1_2sgpr_wr_addr, simf2_2sgpr_wr_addr, simf3_2sgpr_wr_addr, lsu2sgpr_dest_addr;
   output [9:0]   wave2decode_vgpr_base, simd0_2vgpr_dest_addr, simd1_2vgpr_dest_addr,
		  simd2_2vgpr_dest_addr, simd3_2vgpr_dest_addr, simf0_2vgpr_dest_addr,
		  simf1_2vgpr_dest_addr, simf2_2vgpr_dest_addr, simf3_2vgpr_dest_addr,
		  lsu2vgpr_dest_addr;
   output [14:0]  fetch2tracemon_wf_tag;
   output [15:0]  wave2decode_lds_base, rfa2execvgprsgpr_select_fu;
   output [31:0]  simd0_2tracemon_retire_pc, simd1_2tracemon_retire_pc,
		  simd2_2tracemon_retire_pc, simd3_2tracemon_retire_pc, simf0_2tracemon_retire_pc,
		  simf1_2tracemon_retire_pc, simf2_2tracemon_retire_pc, simf3_2tracemon_retire_pc,
		  salu2tracemon_retire_pc, lsu2tracemon_retire_pc, issue2tracemon_barrier_retire_pc,
		  issue2tracemon_waitcnt_retire_pc, salu2fetch_branch_pc_value, decode2issue_instr_pc,
		  salu2exec_wr_m0_value;
   output [39:0]  issue2tracemon_barrier_retire_wf_bitmap;
   output [63:0]  salu2exec_wr_exec_value, salu2exec_wr_vcc_value,
		  salu2sgpr_dest_data, simd0_2exec_wr_vcc_value, simd0_2vgpr_wr_mask,
		  simd1_2exec_wr_vcc_value, simd1_2vgpr_wr_mask, simd2_2exec_wr_vcc_value,
		  simd2_2vgpr_wr_mask, simd3_2exec_wr_vcc_value, simd3_2vgpr_wr_mask,
		  simf0_2exec_wr_vcc_value, simf0_2vgpr_wr_mask, simf1_2exec_wr_vcc_value,
		  simf1_2vgpr_wr_mask, simf2_2exec_wr_vcc_value, simf2_2vgpr_wr_mask,
		  simf3_2exec_wr_vcc_value, simf3_2vgpr_wr_mask, simd0_2sgpr_wr_data,
		  simd1_2sgpr_wr_data, simd2_2sgpr_wr_data, simd3_2sgpr_wr_data, simf0_2sgpr_wr_data,
		  simf1_2sgpr_wr_data, simf2_2sgpr_wr_data, simf3_2sgpr_wr_data, lsu2vgpr_dest_wr_mask,
		  decode2tracemon_collinstr;
   output [127:0] lsu2sgpr_dest_data;
   output [2047:0] simd0_2vgpr_dest_data, simd1_2vgpr_dest_data,
		   simd2_2vgpr_dest_data, simd3_2vgpr_dest_data, simf0_2vgpr_dest_data,
		   simf1_2vgpr_dest_data, simf2_2vgpr_dest_data, simf3_2vgpr_dest_data;
   output [2047:0] lsu2vgpr_dest_data; //**CHANGE
`endif
   ///////////////////////////////
		   //Signals for submodules 
   ///////////////////////////////
   wire 	   buff2fetchwave_ack, cu2dispatch_wf_done, decode2issue_barrier,
		   decode2issue_branch, decode2issue_exec_rd, decode2issue_exec_wr, decode2issue_m0_rd,
		   decode2issue_m0_wr, decode2issue_scc_rd, decode2issue_scc_wr, decode2issue_valid,
		   decode2issue_vcc_rd, decode2issue_vcc_wr, decode2issue_waitcnt, decode2issue_wf_halt,
		   decode2tracemon_colldone, decode2wave_ins_half_rqd, dispatch2cu_wf_dispatch,
		   exec2issue_salu_wr_exec_en, exec2issue_salu_wr_m0_en, exec2issue_salu_wr_scc_en,
		   exec2issue_salu_wr_vcc_en, exec2issue_valu_wr_vcc_en, exec2salu_rd_scc_value,
		   exec2simd_rd_scc_value, exec2simf_rd_scc_value, fetch2buff_rd_en, fetch2exec_init_wf_en,
		   fetch2tracemon_dispatch, fetch2wave_basereg_wr, fetch2wave_reserve_valid,
		   issue2fetchwave_wf_done_en, issue2lsu_lsu_select, issue2salu_alu_select,
		   issue2simd0_alu_select, issue2simd1_alu_select, issue2simd2_alu_select,
		   issue2simd3_alu_select, issue2simf0_alu_select, issue2simf1_alu_select,
		   issue2simf2_alu_select, issue2simf3_alu_select, issue2tracemon_barrier_retire_en,
		   issue2tracemon_waitcnt_retire_en, lsu2issue_ready, lsu2issue_done, lsu2mem_gm_or_lds,
		   lsu2sgpr_instr_done, lsu2sgpr_source1_rd_en, lsu2sgpr_source2_rd_en,
		   lsu2tracemon_gm_or_lds, lsu2vgpr_instr_done, lsu2vgpr_source1_rd_en,
		   lsu2vgpr_source2_rd_en, lsu2rfa_dest_wr_req, mem2lsu_ack, rfa2simd0_queue_entry_serviced,
		   rfa2simd1_queue_entry_serviced, rfa2simd2_queue_entry_serviced, rfa2simd3_queue_entry_serviced,
		   rfa2simf0_queue_entry_serviced, rfa2simf1_queue_entry_serviced, rfa2simf2_queue_entry_serviced,
		   rfa2simf3_queue_entry_serviced, salu2exec_rd_en, salu2exec_wr_exec_en,
		   salu2exec_wr_m0_en, salu2exec_wr_scc_en, salu2exec_wr_scc_value, salu2exec_wr_vcc_en,
		   salu2fetchwaveissue_branch_en, salu2fetchwaveissue_branch_taken, salu2issue_alu_ready,
		   salu2sgpr_instr_done, salu2sgpr_source1_rd_en, salu2sgpr_source2_rd_en,
		   sgpr2issue_alu_wr_done, sgpr2issue_lsu_instr_done, sgpr2issue_valu_dest_reg_valid,
		   simd0_2exec_rd_en, simd0_2exec_wr_vcc_en, simd0_2issue_alu_ready, simd0_2rfa_queue_entry_valid,
		   simd0_2sgpr_rd_en, simd0_2sgpr_wr_en, simd0_2vgpr_instr_done, simd0_2vgpr_source1_rd_en,
		   simd0_2vgpr_source2_rd_en, simd0_2vgpr_source3_rd_en, simd0_2vgpr_wr_en,
		   simd1_2exec_rd_en, simd1_2exec_wr_vcc_en, simd1_2issue_alu_ready, simd1_2rfa_queue_entry_valid,
		   simd1_2sgpr_rd_en, simd1_2sgpr_wr_en, simd1_2vgpr_instr_done, simd1_2vgpr_source1_rd_en,
		   simd1_2vgpr_source2_rd_en, simd1_2vgpr_source3_rd_en, simd1_2vgpr_wr_en,
		   simd2_2exec_rd_en, simd2_2exec_wr_vcc_en, simd2_2issue_alu_ready, simd2_2rfa_queue_entry_valid,
		   simd2_2sgpr_rd_en, simd2_2sgpr_wr_en, simd2_2vgpr_instr_done, simd2_2vgpr_source1_rd_en,
		   simd2_2vgpr_source2_rd_en, simd2_2vgpr_source3_rd_en, simd2_2vgpr_wr_en,
		   simd3_2exec_rd_en, simd3_2exec_wr_vcc_en, simd3_2issue_alu_ready, simd3_2rfa_queue_entry_valid,
		   simd3_2sgpr_rd_en, simd3_2sgpr_wr_en, simd3_2vgpr_instr_done, simd3_2vgpr_source1_rd_en,
		   simd3_2vgpr_source2_rd_en, simd3_2vgpr_source3_rd_en, simd3_2vgpr_wr_en,
		   simf0_2exec_rd_en, simf0_2exec_wr_vcc_en, simf0_2issue_alu_ready, simf0_2rfa_queue_entry_valid,
		   simf0_2sgpr_rd_en, simf0_2sgpr_wr_en, simf0_2vgpr_instr_done, simf0_2vgpr_source1_rd_en,
		   simf0_2vgpr_source2_rd_en, simf0_2vgpr_source3_rd_en, simf0_2vgpr_wr_en,
		   simf1_2exec_rd_en, simf1_2exec_wr_vcc_en, simf1_2issue_alu_ready, simf1_2rfa_queue_entry_valid,
		   simf1_2sgpr_rd_en, simf1_2sgpr_wr_en, simf1_2vgpr_instr_done, simf1_2vgpr_source1_rd_en,
		   simf1_2vgpr_source2_rd_en, simf1_2vgpr_source3_rd_en, simf1_2vgpr_wr_en,
		   simf2_2exec_rd_en, simf2_2exec_wr_vcc_en, simf2_2issue_alu_ready, simf2_2rfa_queue_entry_valid,
		   simf2_2sgpr_rd_en, simf2_2sgpr_wr_en, simf2_2vgpr_instr_done, simf2_2vgpr_source1_rd_en,
		   simf2_2vgpr_source2_rd_en, simf2_2vgpr_source3_rd_en, simf2_2vgpr_wr_en,
		   simf3_2exec_rd_en, simf3_2exec_wr_vcc_en, simf3_2issue_alu_ready, simf3_2rfa_queue_entry_valid,
		   simf3_2sgpr_rd_en, simf3_2sgpr_wr_en, simf3_2vgpr_instr_done, simf3_2vgpr_source1_rd_en,
		   simf3_2vgpr_source2_rd_en, simf3_2vgpr_source3_rd_en, simf3_2vgpr_wr_en,
		   vgpr2issue_alu_dest_reg_valid, vgpr2issue_alu_wr_done, vgpr2issue_lsu_wr_done,
		   wave2decode_instr_valid;
   wire [1:0] 	   decode2issue_fu, salu2sgpr_dest_wr_en, salu2tracemon_exec_word_sel,
		   salu2tracemon_vcc_word_sel, sgpr2issue_alu_dest_reg_valid;
   wire [3:0] 	   dispatch2cu_wg_wf_count, fetch2issue_wg_wf_count,
		   lsu2sgpr_dest_wr_en, sgpr2issue_lsu_dest_reg_valid,
		   vgpr2issue_lsu_dest_reg_valid;
   wire lsu2mem_rd_en, lsu2mem_wr_en, lsu2vgpr_dest_wr_en;
   wire [5:0] 	   decode2issue_wfid, decode2wave_ins_half_wfid, dispatch2cu_wf_size_dispatch,
		   exec2issue_salu_wr_wfid, exec2issue_valu_wr_vcc_wfid, fetch2exec_init_wf_id,
		   fetch2issue_wg_wgid, fetch2tracemon_new_wfid, fetch2wave_basereg_wfid,
		   fetch2wave_reserve_slotid, issue2alu_wfid, issue2fetch_wg_wfid, issue2fetchwave_wf_done_wf_id,
		   issue2lsu_wfid, issue2tracemon_waitcnt_retire_wfid, lsu2exec_rd_wfid,
		   lsu2sgpr_instr_done_wfid, lsu2vgpr_instr_done_wfid, lsu2issue_done_wfid, salu2exec_rd_wfid,
		   salu2exec_wr_wfid, salu2fetchwaveissue_branch_wfid, salu2sgpr_instr_done_wfid,
		   sgpr2issue_alu_wr_done_wfid, sgpr2issue_lsu_instr_done_wfid, simd0_2exec_rd_wfid,
		   simd0_2exec_wr_vcc_wfid, simd0_2vgpr_instr_done_wfid, simd1_2exec_rd_wfid,
		   simd1_2exec_wr_vcc_wfid, simd1_2vgpr_instr_done_wfid, simd2_2exec_rd_wfid,
		   simd2_2exec_wr_vcc_wfid, simd2_2vgpr_instr_done_wfid, simd3_2exec_rd_wfid,
		   simd3_2exec_wr_vcc_wfid, simd3_2vgpr_instr_done_wfid, simf0_2exec_rd_wfid,
		   simf0_2exec_wr_vcc_wfid, simf0_2vgpr_instr_done_wfid, simf1_2exec_rd_wfid,
		   simf1_2exec_wr_vcc_wfid, simf1_2vgpr_instr_done_wfid, simf2_2exec_rd_wfid,
		   simf2_2exec_wr_vcc_wfid, simf2_2vgpr_instr_done_wfid, simf3_2exec_rd_wfid,
		   simf3_2exec_wr_vcc_wfid, simf3_2vgpr_instr_done_wfid, vgpr2issue_alu_wr_done_wfid,
		   vgpr2issue_lsu_wr_done_wfid, wave2decode_wfid;
   wire [6:0] 	   lsu2mem_tag_req, mem2lsu_tag_resp;
   wire [8:0] 	   dispatch2cu_sgpr_base_dispatch, fetch2wave_sgpr_base, lsu2sgpr_dest_addr,
		   lsu2sgpr_source1_addr, lsu2sgpr_source2_addr, salu2sgpr_dest_addr, salu2sgpr_source1_addr,
		   salu2sgpr_source2_addr, sgpr2issue_alu_dest_reg_addr, sgpr2issue_lsu_dest_reg_addr,
		   sgpr2issue_valu_dest_addr, simd0_2sgpr_rd_addr, simd0_2sgpr_wr_addr,
		   simd1_2sgpr_rd_addr, simd1_2sgpr_wr_addr, simd2_2sgpr_rd_addr, simd2_2sgpr_wr_addr,
		   simd3_2sgpr_rd_addr, simd3_2sgpr_wr_addr, simf0_2sgpr_rd_addr, simf0_2sgpr_wr_addr,
		   simf1_2sgpr_rd_addr, simf1_2sgpr_wr_addr, simf2_2sgpr_rd_addr, simf2_2sgpr_wr_addr,
		   simf3_2sgpr_rd_addr, simf3_2sgpr_wr_addr, wave2decode_sgpr_base;
   wire [9:0] 	   dispatch2cu_vgpr_base_dispatch, fetch2wave_vgpr_base, lsu2vgpr_dest_addr,
		   lsu2vgpr_source1_addr, lsu2vgpr_source2_addr, simd0_2vgpr_dest_addr,
		   simd0_2vgpr_source1_addr, simd0_2vgpr_source2_addr, simd0_2vgpr_source3_addr,
		   simd1_2vgpr_dest_addr, simd1_2vgpr_source1_addr, simd1_2vgpr_source2_addr,
		   simd1_2vgpr_source3_addr, simd2_2vgpr_dest_addr, simd2_2vgpr_source1_addr,
		   simd2_2vgpr_source2_addr, simd2_2vgpr_source3_addr, simd3_2vgpr_dest_addr,
		   simd3_2vgpr_source1_addr, simd3_2vgpr_source2_addr, simd3_2vgpr_source3_addr,
		   simf0_2vgpr_dest_addr, simf0_2vgpr_source1_addr, simf0_2vgpr_source2_addr,
		   simf0_2vgpr_source3_addr, simf1_2vgpr_dest_addr, simf1_2vgpr_source1_addr,
		   simf1_2vgpr_source2_addr, simf1_2vgpr_source3_addr, simf2_2vgpr_dest_addr,
		   simf2_2vgpr_source1_addr, simf2_2vgpr_source2_addr, simf2_2vgpr_source3_addr,
		   simf3_2vgpr_dest_addr, simf3_2vgpr_source1_addr, simf3_2vgpr_source2_addr,
		   simf3_2vgpr_source3_addr, vgpr2issue_alu_dest_reg_addr, vgpr2issue_lsu_dest_reg_addr,
		   wave2decode_vgpr_base;
   wire [11:0] 	   issue2alu_dest_reg1, issue2alu_dest_reg2, issue2alu_source_reg1,
		   issue2alu_source_reg2, issue2alu_source_reg3, issue2lsu_dest_reg, issue2lsu_mem_sgpr,
		   issue2lsu_source_reg1, issue2lsu_source_reg2, issue2lsu_source_reg3;
   wire [12:0] 	   decode2issue_dest_reg2, decode2issue_source_reg2, decode2issue_source_reg3;
   wire [13:0] 	   decode2issue_dest_reg1, decode2issue_source_reg1, decode2issue_source_reg4;
   wire [14:0] 	   cu2dispatch_wf_tag_done, dispatch2cu_wf_tag_dispatch, fetch2tracemon_wf_tag;
   wire [15:0] 	   decode2issue_imm_value0, decode2issue_lds_base, dispatch2cu_lds_base_dispatch,
		   fetch2wave_lds_base, issue2alu_imm_value0, issue2lsu_imm_value0, issue2lsu_lds_base,
		   rfa2execvgprsgpr_select_fu, wave2decode_lds_base;
   wire [31:0] 	   buff2wave_instr, decode2issue_imm_value1, decode2issue_instr_pc,
		   decode2issue_opcode, dispatch2cu_start_pc_dispatch, exec2lsu_rd_m0_value,
		   exec2salu_rd_m0_value, exec2simd_rd_m0_value, exec2simf_rd_m0_value,
		   fetch2buff_addr, issue2alu_imm_value1, issue2alu_instr_pc, issue2alu_opcode,
		   issue2lsu_imm_value1, issue2lsu_instr_pc, issue2lsu_opcode, issue2tracemon_barrier_retire_pc,
		   issue2tracemon_waitcnt_retire_pc, lsu2tracemon_retire_pc, salu2exec_wr_m0_value,
		   salu2fetch_branch_pc_value, salu2tracemon_retire_pc, sgpr2lsu_source2_data,
		   sgpr2simd_rd_data, sgpr2simf_rd_data, simd0_2tracemon_retire_pc, simd1_2tracemon_retire_pc,
		   simd2_2tracemon_retire_pc, simd3_2tracemon_retire_pc, simf0_2tracemon_retire_pc,
		   simf1_2tracemon_retire_pc, simf2_2tracemon_retire_pc, simf3_2tracemon_retire_pc,
		   wave2decode_instr, wave2decode_instr_pc;
   wire [38:0] 	   buff2wave_tag, fetch2buff_tag;
   wire [39:0] 	   issue2tracemon_barrier_retire_wf_bitmap, issue2wave_valid_entries,
		   wave2fetch_stop_fetch;
   wire [63:0] 	   decode2tracemon_collinstr, exec2lsu_exec_value, exec2salu_rd_exec_value,
		   exec2salu_rd_vcc_value, exec2simd_rd_exec_value, exec2simd_rd_vcc_value,
		   exec2simf_rd_exec_value, exec2simf_rd_vcc_value, fetch2exec_init_value,
		   lsu2mem_wr_mask, lsu2vgpr_dest_wr_mask, salu2exec_wr_exec_value, salu2exec_wr_vcc_value,
		   salu2sgpr_dest_data, sgpr2salu_source1_data, sgpr2salu_source2_data,
		   simd0_2exec_wr_vcc_value, simd0_2sgpr_wr_data, simd0_2sgpr_wr_mask,
		   simd0_2vgpr_wr_mask, simd1_2exec_wr_vcc_value, simd1_2sgpr_wr_data,
		   simd1_2sgpr_wr_mask, simd1_2vgpr_wr_mask, simd2_2exec_wr_vcc_value,
		   simd2_2sgpr_wr_data, simd2_2sgpr_wr_mask, simd2_2vgpr_wr_mask, simd3_2exec_wr_vcc_value,
		   simd3_2sgpr_wr_data, simd3_2sgpr_wr_mask, simd3_2vgpr_wr_mask, simf0_2exec_wr_vcc_value,
		   simf0_2sgpr_wr_data, simf0_2sgpr_wr_mask, simf0_2vgpr_wr_mask, simf1_2exec_wr_vcc_value,
		   simf1_2sgpr_wr_data, simf1_2sgpr_wr_mask, simf1_2vgpr_wr_mask, simf2_2exec_wr_vcc_value,
		   simf2_2sgpr_wr_data, simf2_2sgpr_wr_mask, simf2_2vgpr_wr_mask, simf3_2exec_wr_vcc_value,
		   simf3_2sgpr_wr_data, simf3_2sgpr_wr_mask, simf3_2vgpr_wr_mask;
   wire [127:0]    lsu2sgpr_dest_data, sgpr2lsu_source1_data;
   wire [2047:0]   simd0_2vgpr_dest_data, simd1_2vgpr_dest_data,
		   simd2_2vgpr_dest_data, simd3_2vgpr_dest_data, simf0_2vgpr_dest_data,
		   simf1_2vgpr_dest_data, simf2_2vgpr_dest_data, simf3_2vgpr_dest_data,
		   vgpr2lsu_source2_data, vgpr2simd_source1_data, vgpr2simd_source2_data,
		   vgpr2simd_source3_data, vgpr2simf_source1_data, vgpr2simf_source2_data,
		   vgpr2simf_source3_data;

   //**CHANGE
   wire [2047:0]   lsu2vgpr_dest_data, vgpr2lsu_source1_data;
   wire [31:0]     lsu2mem_wr_data, mem2lsu_rd_data, lsu2mem_addr;


   wire salu_request, lsu_stall;

`ifdef FPGA_BUILD
  wire [8:0] lsu2sgpr_dest_addr_muxed;
  wire [127:0] lsu2sgpr_dest_data_muxed;
  wire [3:0] lsu2sgpr_dest_wr_en_muxed;
  wire [8:0] lsu2sgpr_source1_addr_muxed;
  wire lsu2sgpr_source1_rd_en_muxed;
  
  wire [9:0] lsu2vgpr_dest_addr_muxed;
  wire [2047:0] lsu2vgpr_dest_data_muxed;
  wire [3:0] lsu2vgpr_dest_wr_en_muxed;
  wire [63:0] lsu2vgpr_dest_wr_mask_muxed;
  wire [9:0] lsu2vgpr_source1_addr_muxed;
  wire lsu2vgpr_source1_rd_en_muxed;
  
  wire [15:0] sgpr_select_fu;
  wire [15:0] vgpr_select_fu;

  assign sgpr2dispatch_rd_data = sgpr2lsu_source1_data;
  assign vgpr2dispatch_rd_data = vgpr2lsu_source1_data;
  
  assign sgpr_select_fu = dispatch2cu_idle ? {7'd0, dispatch2sgpr_wr_en, 8'd0} : rfa2execvgprsgpr_select_fu;
  assign lsu2sgpr_dest_addr_muxed = dispatch2cu_idle ? dispatch2sgpr_addr : lsu2sgpr_dest_addr;
  assign lsu2sgpr_dest_data_muxed = dispatch2cu_idle ? dispatch2sgpr_wr_data : lsu2sgpr_dest_data;
  assign lsu2sgpr_dest_wr_en_muxed = dispatch2cu_idle ? {4{dispatch2sgpr_wr_en}} : lsu2sgpr_dest_wr_en;
  assign lsu2sgpr_source1_addr_muxed = dispatch2cu_idle ? dispatch2sgpr_addr : lsu2sgpr_source1_addr;
  assign lsu2sgpr_source1_rd_en_muxed = dispatch2cu_idle | lsu2sgpr_source1_rd_en;
  
  assign vgpr_select_fu = dispatch2cu_idle ? {7'd0,  dispatch2vgpr_wr_en, 8'd0} : rfa2execvgprsgpr_select_fu;
  assign lsu2vgpr_dest_addr_muxed = dispatch2cu_idle ? dispatch2vgpr_addr : lsu2vgpr_dest_addr;
  assign lsu2vgpr_dest_data_muxed = dispatch2cu_idle ? dispatch2vgpr_wr_data : lsu2vgpr_dest_data;
  assign lsu2vgpr_dest_wr_en_muxed = dispatch2cu_idle ? {4{dispatch2vgpr_wr_en}} : lsu2vgpr_dest_wr_en;
  assign lsu2vgpr_dest_wr_mask_muxed = dispatch2cu_idle ? dispatch2vgpr_wr_mask : lsu2vgpr_dest_wr_mask;
  assign lsu2vgpr_source1_addr_muxed = dispatch2cu_idle ? dispatch2vgpr_addr : lsu2vgpr_source1_addr;
  assign lsu2vgpr_source1_rd_en_muxed = dispatch2cu_idle | lsu2vgpr_source1_rd_en;
`endif

   decode decode0 (
		   // Unit that decodes instructions and passes them to issue.
		   .clk(clk),
		   .rst(rst),
		   //  Inputs
		   .wave_instr_pc(wave2decode_instr_pc),
		   .wave_instr_valid(wave2decode_instr_valid),
		   .wave_instr(wave2decode_instr),
		   .wave_wfid(wave2decode_wfid),
		   .wave_vgpr_base(wave2decode_vgpr_base),
		   .wave_sgpr_base(wave2decode_sgpr_base),
		   .wave_lds_base(wave2decode_lds_base),
		   //  Outputs
		   .issue_wf_halt(decode2issue_wf_halt),
		   .issue_fu(decode2issue_fu),
		   .issue_wfid(decode2issue_wfid),
		   .issue_opcode(decode2issue_opcode),
		   .issue_source_reg1(decode2issue_source_reg1),
		   .issue_source_reg2(decode2issue_source_reg2),
		   .issue_source_reg3(decode2issue_source_reg3),
		   .issue_source_reg4(decode2issue_source_reg4),
		   .issue_dest_reg1(decode2issue_dest_reg1),
		   .issue_dest_reg2(decode2issue_dest_reg2),
		   .issue_imm_value0(decode2issue_imm_value0),
		   .issue_imm_value1(decode2issue_imm_value1),
		   .issue_valid(decode2issue_valid),
		   .issue_instr_pc(decode2issue_instr_pc),
		   .issue_vcc_wr(decode2issue_vcc_wr),
		   .issue_vcc_rd(decode2issue_vcc_rd),
		   .issue_scc_wr(decode2issue_scc_wr),
		   .issue_scc_rd(decode2issue_scc_rd),
		   .issue_exec_rd(decode2issue_exec_rd),
		   .issue_exec_wr(decode2issue_exec_wr),
		   .issue_m0_rd(decode2issue_m0_rd),
		   .issue_m0_wr(decode2issue_m0_wr),
		   .issue_barrier(decode2issue_barrier),
		   .issue_branch(decode2issue_branch),
		   .issue_lds_base(decode2issue_lds_base),
		   .issue_waitcnt(decode2issue_waitcnt),
		   .wave_ins_half_rqd(decode2wave_ins_half_rqd),
		   .wave_ins_half_wfid(decode2wave_ins_half_wfid),
		   .tracemon_collinstr(decode2tracemon_collinstr),
		   .tracemon_colldone(decode2tracemon_colldone)
		   );

   exec exec0 (
	       // Exec flag, used to choose which wave items inside a wavefront will retire and which will not.
	       .clk(clk),
	       .rst(rst),
	       //  Inputs
	       .lsu_rd_wfid(lsu2exec_rd_wfid),
	       .salu_wr_exec_en(salu2exec_wr_exec_en),
	       .salu_wr_vcc_en(salu2exec_wr_vcc_en),
	       .salu_wr_exec_value(salu2exec_wr_exec_value),
	       .salu_wr_vcc_value(salu2exec_wr_vcc_value),
	       .salu_wr_wfid(salu2exec_wr_wfid),
	       .salu_rd_en(salu2exec_rd_en),
	       .salu_rd_wfid(salu2exec_rd_wfid),
	       .salu_wr_m0_en(salu2exec_wr_m0_en),
	       .salu_wr_m0_value(salu2exec_wr_m0_value),
	       .salu_wr_scc_en(salu2exec_wr_scc_en),
	       .salu_wr_scc_value(salu2exec_wr_scc_value),
	       .simd0_rd_wfid(simd0_2exec_rd_wfid),
	       .simd1_rd_wfid(simd1_2exec_rd_wfid),
	       .simd2_rd_wfid(simd2_2exec_rd_wfid),
	       .simd3_rd_wfid(simd3_2exec_rd_wfid),
	       .simd0_rd_en(simd0_2exec_rd_en),
	       .simd1_rd_en(simd1_2exec_rd_en),
	       .simd2_rd_en(simd2_2exec_rd_en),
	       .simd3_rd_en(simd3_2exec_rd_en),
	       .simd0_vcc_wr_wfid(simd0_2exec_wr_vcc_wfid),
	       .simd1_vcc_wr_wfid(simd1_2exec_wr_vcc_wfid),
	       .simd2_vcc_wr_wfid(simd2_2exec_wr_vcc_wfid),
	       .simd3_vcc_wr_wfid(simd3_2exec_wr_vcc_wfid),
	       .simd0_vcc_wr_en(simd0_2exec_wr_vcc_en),
	       .simd1_vcc_wr_en(simd1_2exec_wr_vcc_en),
	       .simd2_vcc_wr_en(simd2_2exec_wr_vcc_en),
	       .simd3_vcc_wr_en(simd3_2exec_wr_vcc_en),
	       .simd0_vcc_value(simd0_2exec_wr_vcc_value),
	       .simd1_vcc_value(simd1_2exec_wr_vcc_value),
	       .simd2_vcc_value(simd2_2exec_wr_vcc_value),
	       .simd3_vcc_value(simd3_2exec_wr_vcc_value),
	       .simf0_rd_wfid(simf0_2exec_rd_wfid),
	       .simf1_rd_wfid(simf1_2exec_rd_wfid),
	       .simf2_rd_wfid(simf2_2exec_rd_wfid),
	       .simf3_rd_wfid(simf3_2exec_rd_wfid),
	       .simf0_rd_en(simf0_2exec_rd_en),
	       .simf1_rd_en(simf1_2exec_rd_en),
	       .simf2_rd_en(simf2_2exec_rd_en),
	       .simf3_rd_en(simf3_2exec_rd_en),
	       .simf0_vcc_wr_wfid(simf0_2exec_wr_vcc_wfid),
	       .simf1_vcc_wr_wfid(simf1_2exec_wr_vcc_wfid),
	       .simf2_vcc_wr_wfid(simf2_2exec_wr_vcc_wfid),
	       .simf3_vcc_wr_wfid(simf3_2exec_wr_vcc_wfid),
	       .simf0_vcc_wr_en(simf0_2exec_wr_vcc_en),
	       .simf1_vcc_wr_en(simf1_2exec_wr_vcc_en),
	       .simf2_vcc_wr_en(simf2_2exec_wr_vcc_en),
	       .simf3_vcc_wr_en(simf3_2exec_wr_vcc_en),
	       .simf0_vcc_value(simf0_2exec_wr_vcc_value),
	       .simf1_vcc_value(simf1_2exec_wr_vcc_value),
	       .simf2_vcc_value(simf2_2exec_wr_vcc_value),
	       .simf3_vcc_value(simf3_2exec_wr_vcc_value),
	       .fetch_init_wf_en(fetch2exec_init_wf_en),
	       .fetch_init_wf_id(fetch2exec_init_wf_id),
	       .fetch_init_value(fetch2exec_init_value),
	       .rfa_select_fu(rfa2execvgprsgpr_select_fu),
	       //  Outputs
	       .lsu_exec_value(exec2lsu_exec_value),
	       .lsu_rd_m0_value(exec2lsu_rd_m0_value),
	       .simd_rd_exec_value(exec2simd_rd_exec_value),
	       .simd_rd_vcc_value(exec2simd_rd_vcc_value),
	       .simd_rd_m0_value(exec2simd_rd_m0_value),
	       .simd_rd_scc_value(exec2simd_rd_scc_value),
	       .simf_rd_exec_value(exec2simf_rd_exec_value),
	       .simf_rd_vcc_value(exec2simf_rd_vcc_value),
	       .simf_rd_m0_value(exec2simf_rd_m0_value),
	       .simf_rd_scc_value(exec2simf_rd_scc_value),
	       .salu_rd_exec_value(exec2salu_rd_exec_value),
	       .salu_rd_vcc_value(exec2salu_rd_vcc_value),
	       .salu_rd_m0_value(exec2salu_rd_m0_value),
	       .salu_rd_scc_value(exec2salu_rd_scc_value),
	       .issue_salu_wr_vcc_wfid(exec2issue_salu_wr_wfid),
	       .issue_salu_wr_vcc_en(exec2issue_salu_wr_vcc_en),
	       .issue_salu_wr_exec_en(exec2issue_salu_wr_exec_en),
	       .issue_salu_wr_m0_en(exec2issue_salu_wr_m0_en),
	       .issue_salu_wr_scc_en(exec2issue_salu_wr_scc_en),
	       .issue_valu_wr_vcc_wfid(exec2issue_valu_wr_vcc_wfid),
	       .issue_valu_wr_vcc_en(exec2issue_valu_wr_vcc_en)
	       );

   fetch fetch0 (
		 // Unit that fetches instructions from a wavefront chosen by the wavepool
		 .clk(clk),
		 .rst(rst),
		 //  Inputs
		 .dispatch2cu_wf_dispatch(dispatch2cu_wf_dispatch),
		 .dispatch2cu_wf_tag_dispatch(dispatch2cu_wf_tag_dispatch),
		 .dispatch2cu_start_pc_dispatch(dispatch2cu_start_pc_dispatch),
		 .dispatch2cu_vgpr_base_dispatch(dispatch2cu_vgpr_base_dispatch),
		 .dispatch2cu_sgpr_base_dispatch(dispatch2cu_sgpr_base_dispatch),
		 .dispatch2cu_lds_base_dispatch(dispatch2cu_lds_base_dispatch),
		 .dispatch2cu_wf_size_dispatch(dispatch2cu_wf_size_dispatch),
		 .dispatch2cu_wg_wf_count(dispatch2cu_wg_wf_count),
		 .buff_ack(buff2fetchwave_ack),
		 .wave_stop_fetch(wave2fetch_stop_fetch),
		 .issue_wf_done_en(issue2fetchwave_wf_done_en),
		 .issue_wf_done_wf_id(issue2fetchwave_wf_done_wf_id),
		 .issue_wg_wfid(issue2fetch_wg_wfid),
		 .salu_branch_wfid(salu2fetchwaveissue_branch_wfid),
		 .salu_branch_en(salu2fetchwaveissue_branch_en),
		 .salu_branch_taken(salu2fetchwaveissue_branch_taken),
		 .salu_branch_pc_value(salu2fetch_branch_pc_value),
		 //  Outputs
		 .cu2dispatch_wf_tag_done(cu2dispatch_wf_tag_done),
		 .cu2dispatch_wf_done(cu2dispatch_wf_done),
		 .buff_addr(fetch2buff_addr),
		 .buff_tag(fetch2buff_tag),
		 .buff_rd_en(fetch2buff_rd_en),
		 .wave_reserve_slotid(fetch2wave_reserve_slotid),
		 .wave_reserve_valid(fetch2wave_reserve_valid),
		 .wave_basereg_wr(fetch2wave_basereg_wr),
		 .wave_basereg_wfid(fetch2wave_basereg_wfid),
		 .wave_vgpr_base(fetch2wave_vgpr_base),
		 .wave_sgpr_base(fetch2wave_sgpr_base),
		 .wave_lds_base(fetch2wave_lds_base),
		 .exec_init_wf_en(fetch2exec_init_wf_en),
		 .exec_init_wf_id(fetch2exec_init_wf_id),
		 .exec_init_value(fetch2exec_init_value),
		 .issue_wg_wgid(fetch2issue_wg_wgid),
		 .issue_wg_wf_count(fetch2issue_wg_wf_count),
		 .tracemon_dispatch(fetch2tracemon_dispatch),
		 .tracemon_wf_tag_dispatch(fetch2tracemon_wf_tag),
		 .tracemon_new_wfid(fetch2tracemon_new_wfid)
		 );

   issue issue0 (
		 // Unit that does scoreboarding and choses from which wavefront to issue at a cycle.
		 .clk(clk),
		 .rst(rst),
		 //  Inputs
		 .decode_branch(decode2issue_branch),
		 .decode_barrier(decode2issue_barrier),
		 .decode_vcc_wr(decode2issue_vcc_wr),
		 .decode_vcc_rd(decode2issue_vcc_rd),
		 .decode_scc_wr(decode2issue_scc_wr),
		 .decode_scc_rd(decode2issue_scc_rd),
		 .decode_exec_rd(decode2issue_exec_rd),
		 .decode_exec_wr(decode2issue_exec_wr),
		 .decode_m0_rd(decode2issue_m0_rd),
		 .decode_m0_wr(decode2issue_m0_wr),
		 .decode_instr_pc(decode2issue_instr_pc),
		 .decode_wf_halt(decode2issue_wf_halt),
		 .decode_fu(decode2issue_fu),
		 .decode_wfid(decode2issue_wfid),
		 .decode_opcode(decode2issue_opcode),
		 .decode_source_reg1(decode2issue_source_reg1),
		 .decode_source_reg2(decode2issue_source_reg2),
		 .decode_source_reg3(decode2issue_source_reg3),
		 .decode_source_reg4(decode2issue_source_reg4),
		 .decode_dest_reg1(decode2issue_dest_reg1),
		 .decode_dest_reg2(decode2issue_dest_reg2),
		 .decode_imm_value0(decode2issue_imm_value0),
		 .decode_imm_value1(decode2issue_imm_value1),
		 .decode_lds_base(decode2issue_lds_base),
		 .decode_waitcnt(decode2issue_waitcnt),
		 .decode_valid(decode2issue_valid),
		 .vgpr_alu_wr_done_wfid(vgpr2issue_alu_wr_done_wfid),
		 .vgpr_alu_wr_done(vgpr2issue_alu_wr_done),
		 .vgpr_alu_dest_reg_addr(vgpr2issue_alu_dest_reg_addr),
		 .vgpr_alu_dest_reg_valid(vgpr2issue_alu_dest_reg_valid),
		 .vgpr_lsu_wr_done_wfid(vgpr2issue_lsu_wr_done_wfid),
		 .vgpr_lsu_wr_done(vgpr2issue_lsu_wr_done),
		 .vgpr_lsu_dest_reg_addr(vgpr2issue_lsu_dest_reg_addr),
		 .vgpr_lsu_dest_reg_valid(vgpr2issue_lsu_dest_reg_valid),
		 .sgpr_alu_wr_done_wfid(sgpr2issue_alu_wr_done_wfid),
		 .sgpr_alu_wr_done(sgpr2issue_alu_wr_done),
		 .sgpr_alu_dest_reg_addr(sgpr2issue_alu_dest_reg_addr),
		 .sgpr_alu_dest_reg_valid(sgpr2issue_alu_dest_reg_valid),
		 .sgpr_lsu_instr_done_wfid(sgpr2issue_lsu_instr_done_wfid),
		 .sgpr_lsu_instr_done(sgpr2issue_lsu_instr_done),
		 .sgpr_lsu_dest_reg_addr(sgpr2issue_lsu_dest_reg_addr),
		 .sgpr_lsu_dest_reg_valid(sgpr2issue_lsu_dest_reg_valid),
		 .sgpr_valu_dest_reg_valid(sgpr2issue_valu_dest_reg_valid),
		 .sgpr_valu_dest_addr(sgpr2issue_valu_dest_addr),
		 .simd0_alu_ready(simd0_2issue_alu_ready),
		 .simd1_alu_ready(simd1_2issue_alu_ready),
		 .simd2_alu_ready(simd2_2issue_alu_ready),
		 .simd3_alu_ready(simd3_2issue_alu_ready),
		 .simf0_alu_ready(simf0_2issue_alu_ready),
		 .simf1_alu_ready(simf1_2issue_alu_ready),
		 .simf2_alu_ready(simf2_2issue_alu_ready),
		 .simf3_alu_ready(simf3_2issue_alu_ready),
		 .salu_alu_ready(salu2issue_alu_ready),
		 .lsu_ready(lsu2issue_ready),
         .lsu_done(lsu2issue_done),
         .lsu_done_wfid(lsu2issue_done_wfid),
		 .exec_salu_wr_wfid(exec2issue_salu_wr_wfid),
		 .exec_salu_wr_vcc_en(exec2issue_salu_wr_vcc_en),
		 .exec_salu_wr_exec_en(exec2issue_salu_wr_exec_en),
		 .exec_salu_wr_scc_en(exec2issue_salu_wr_scc_en),
		 .exec_salu_wr_m0_en(exec2issue_salu_wr_m0_en),
		 .exec_valu_wr_vcc_wfid(exec2issue_valu_wr_vcc_wfid),
		 .exec_valu_wr_vcc_en(exec2issue_valu_wr_vcc_en),
		 .fetch_wg_wgid(fetch2issue_wg_wgid),
		 .fetch_wg_wf_count(fetch2issue_wg_wf_count),
		 .salu_branch_wfid(salu2fetchwaveissue_branch_wfid),
		 .salu_branch_en(salu2fetchwaveissue_branch_en),
		 .salu_branch_taken(salu2fetchwaveissue_branch_taken),
		 //  Outputs
		 .wave_valid_entries(issue2wave_valid_entries),
		 .salu_alu_select(issue2salu_alu_select),
		 .simd0_alu_select(issue2simd0_alu_select),
		 .simd1_alu_select(issue2simd1_alu_select),
		 .simd2_alu_select(issue2simd2_alu_select),
		 .simd3_alu_select(issue2simd3_alu_select),
		 .simf0_alu_select(issue2simf0_alu_select),
		 .simf1_alu_select(issue2simf1_alu_select),
		 .simf2_alu_select(issue2simf2_alu_select),
		 .simf3_alu_select(issue2simf3_alu_select),
		 .lsu_lsu_select(issue2lsu_lsu_select),
		 .lsu_source_reg1(issue2lsu_source_reg1),
		 .lsu_source_reg2(issue2lsu_source_reg2),
		 .lsu_source_reg3(issue2lsu_source_reg3),
		 .lsu_dest_reg(issue2lsu_dest_reg),
		 .lsu_imm_value0(issue2lsu_imm_value0),
		 .lsu_imm_value1(issue2lsu_imm_value1),
		 .lsu_opcode(issue2lsu_opcode),
		 .lsu_mem_sgpr(issue2lsu_mem_sgpr),
		 .lsu_wfid(issue2lsu_wfid),
		 .lsu_lds_base(issue2lsu_lds_base),
		 .alu_source_reg1(issue2alu_source_reg1),
		 .alu_source_reg2(issue2alu_source_reg2),
		 .alu_source_reg3(issue2alu_source_reg3),
		 .alu_dest_reg1(issue2alu_dest_reg1),
		 .alu_dest_reg2(issue2alu_dest_reg2),
		 .alu_imm_value0(issue2alu_imm_value0),
		 .alu_imm_value1(issue2alu_imm_value1),
		 .alu_opcode(issue2alu_opcode),
		 .alu_wfid(issue2alu_wfid),
		 .alu_instr_pc(issue2alu_instr_pc),
		 .lsu_instr_pc(issue2lsu_instr_pc),
		 .fetchwave_wf_done_en(issue2fetchwave_wf_done_en),
		 .fetchwave_wf_done_wf_id(issue2fetchwave_wf_done_wf_id),
		 .fetch_wg_wfid(issue2fetch_wg_wfid),
		 .tracemon_barrier_retire_en(issue2tracemon_barrier_retire_en),
		 .tracemon_barrier_retire_wf_bitmap(issue2tracemon_barrier_retire_wf_bitmap),
		 .tracemon_barrier_retire_pc(issue2tracemon_barrier_retire_pc),
		 .tracemon_waitcnt_retire_en(issue2tracemon_waitcnt_retire_en),
		 .tracemon_waitcnt_retire_wfid(issue2tracemon_waitcnt_retire_wfid),
		 .tracemon_waitcnt_retire_pc(issue2tracemon_waitcnt_retire_pc)
		 );

// Because of how the LSU internally works it's the same buffer that feeds
// into the VGPR and the SGPR write buses so we can just use the VGPR output
// bus to capture store operations for both.
assign lsu2tracemon_store_data = lsu2vgpr_dest_data;

lsu lsu0 (
    // unit to handle loads and stores
    .clk(clk),//
    .rst(rst),//
    //  Inputs
    .issue_lsu_select(issue2lsu_lsu_select),//
    .issue_source_reg1(issue2lsu_source_reg1),//
    .issue_source_reg2(issue2lsu_source_reg2),//
    .issue_source_reg3(issue2lsu_source_reg3),//
    .issue_dest_reg(issue2lsu_dest_reg),//
    .issue_imm_value0(issue2lsu_imm_value0),//
    .issue_imm_value1(issue2lsu_imm_value1),//
    .issue_opcode(issue2lsu_opcode),//
    .issue_mem_sgpr(issue2lsu_mem_sgpr),//
    .issue_wfid(issue2lsu_wfid),//
    .issue_lds_base(issue2lsu_lds_base),//
    .vgpr_source1_data(vgpr2lsu_source1_data),//
    .vgpr_source2_data(vgpr2lsu_source2_data),//
    .mem_rd_data(mem2lsu_rd_data),//
    .mem_tag_resp(mem2lsu_tag_resp),//
    .mem_ack(mem2lsu_ack),//
    .sgpr_source1_data(sgpr2lsu_source1_data),//
    .sgpr_source2_data(sgpr2lsu_source2_data),//
    .exec_exec_value(exec2lsu_exec_value),//
    .exec_rd_m0_value(exec2lsu_rd_m0_value),//
    .issue_instr_pc(issue2lsu_instr_pc),//
     .lsu_stall(lsu_stall),//**CHANGE
    //  Outputs
    .issue_ready(lsu2issue_ready),
    .lsu_done(lsu2issue_done),
    .lsu_done_wfid(lsu2issue_done_wfid),
    .vgpr_source1_addr(lsu2vgpr_source1_addr),
    .vgpr_source2_addr(lsu2vgpr_source2_addr),
    .vgpr_dest_addr(lsu2vgpr_dest_addr),
    .vgpr_dest_data(lsu2vgpr_dest_data),
    .vgpr_dest_wr_en(lsu2vgpr_dest_wr_en),
    .vgpr_dest_wr_mask(lsu2vgpr_dest_wr_mask),
    .vgpr_instr_done_wfid(lsu2vgpr_instr_done_wfid),
    .vgpr_instr_done(lsu2vgpr_instr_done),
    .vgpr_source1_rd_en(lsu2vgpr_source1_rd_en),
    .vgpr_source2_rd_en(lsu2vgpr_source2_rd_en),
    .exec_rd_wfid(lsu2exec_rd_wfid),
    .mem_rd_en(lsu2mem_rd_en),
    .mem_wr_en(lsu2mem_wr_en),
    .mem_addr(lsu2mem_addr),
    .mem_wr_data(lsu2mem_wr_data),
    .mem_tag_req(lsu2mem_tag_req),
    .mem_wr_mask(lsu2mem_wr_mask),
    .sgpr_source1_addr(lsu2sgpr_source1_addr),
    .sgpr_source2_addr(lsu2sgpr_source2_addr),
    .sgpr_dest_addr(lsu2sgpr_dest_addr),
    .sgpr_dest_data(lsu2sgpr_dest_data),
    .sgpr_dest_wr_en(lsu2sgpr_dest_wr_en),
    .sgpr_instr_done_wfid(lsu2sgpr_instr_done_wfid),
    .sgpr_instr_done(lsu2sgpr_instr_done),
    .sgpr_source1_rd_en(lsu2sgpr_source1_rd_en),
    .sgpr_source2_rd_en(lsu2sgpr_source2_rd_en),
    .mem_gm_or_lds(lsu2mem_gm_or_lds),
    .rfa_dest_wr_req(lsu2rfa_dest_wr_req),
    .tracemon_retire_pc(lsu2tracemon_retire_pc),
    .tracemon_gm_or_lds(lsu2tracemon_gm_or_lds),
    .tracemon_mem_addr(lsu2tracemon_addr),
    .tracemon_idle(lsu2tracemon_idle)
);

   rfa rfa0 (
	     // Unit that controls access to register file
	     .clk(clk),
	     .rst(rst),
	     //  Inputs
	     .lsu_dest_wr_req(lsu2rfa_dest_wr_req),
	     .simd0_queue_entry_valid(simd0_2rfa_queue_entry_valid),
	     .simd1_queue_entry_valid(simd1_2rfa_queue_entry_valid),
	     .simd2_queue_entry_valid(simd2_2rfa_queue_entry_valid),
	     .simd3_queue_entry_valid(simd3_2rfa_queue_entry_valid),
	     .simf0_queue_entry_valid(simf0_2rfa_queue_entry_valid),
	     .simf1_queue_entry_valid(simf1_2rfa_queue_entry_valid),
	     .simf2_queue_entry_valid(simf2_2rfa_queue_entry_valid),
	     .simf3_queue_entry_valid(simf3_2rfa_queue_entry_valid),
	     //  Outputs
	     .simd0_queue_entry_serviced(rfa2simd0_queue_entry_serviced),
	     .simd1_queue_entry_serviced(rfa2simd1_queue_entry_serviced),
	     .simd2_queue_entry_serviced(rfa2simd2_queue_entry_serviced),
	     .simd3_queue_entry_serviced(rfa2simd3_queue_entry_serviced),
	     .simf0_queue_entry_serviced(rfa2simf0_queue_entry_serviced),
	     .simf1_queue_entry_serviced(rfa2simf1_queue_entry_serviced),
	     .simf2_queue_entry_serviced(rfa2simf2_queue_entry_serviced),
	     .simf3_queue_entry_serviced(rfa2simf3_queue_entry_serviced),
	     .execvgprsgpr_select_fu(rfa2execvgprsgpr_select_fu),
             .lsu_wait(lsu_stall), //**change,
             .salu_req(salu_request) //**change
	     );

   salu salu0 (
	       // The scalar alu for scalar operations
	       .clk(clk),
	       .rst(rst),
	       //  Inputs
	       .issue_source_reg1(issue2alu_source_reg1),
	       .issue_source_reg2(issue2alu_source_reg2),
	       .issue_dest_reg(issue2alu_dest_reg1),
	       .issue_imm_value0(issue2alu_imm_value0),
	       .issue_imm_value1(issue2alu_imm_value1),
	       .issue_opcode(issue2alu_opcode),
	       .issue_wfid(issue2alu_wfid),
	       .issue_alu_select(issue2salu_alu_select),
	       .exec_rd_exec_value(exec2salu_rd_exec_value),
	       .exec_rd_vcc_value(exec2salu_rd_vcc_value),
	       .exec_rd_m0_value(exec2salu_rd_m0_value),
	       .exec_rd_scc_value(exec2salu_rd_scc_value),
	       .sgpr_source2_data(sgpr2salu_source2_data),
	       .sgpr_source1_data(sgpr2salu_source1_data),
	       .issue_instr_pc(issue2alu_instr_pc),
	       //  Outputs
	       .exec_wr_exec_en(salu2exec_wr_exec_en),
	       .exec_wr_vcc_en(salu2exec_wr_vcc_en),
	       .exec_wr_m0_en(salu2exec_wr_m0_en),
	       .exec_wr_scc_en(salu2exec_wr_scc_en),
	       .exec_wr_exec_value(salu2exec_wr_exec_value),
	       .exec_wr_vcc_value(salu2exec_wr_vcc_value),
	       .exec_wr_m0_value(salu2exec_wr_m0_value),
	       .exec_wr_scc_value(salu2exec_wr_scc_value),
	       .exec_wr_wfid(salu2exec_wr_wfid),
	       .exec_rd_en(salu2exec_rd_en),
	       .exec_rd_wfid(salu2exec_rd_wfid),
	       .sgpr_dest_data(salu2sgpr_dest_data),
	       .sgpr_dest_addr(salu2sgpr_dest_addr),
	       .sgpr_dest_wr_en(salu2sgpr_dest_wr_en),
	       .sgpr_source2_addr(salu2sgpr_source2_addr),
	       .sgpr_source1_addr(salu2sgpr_source1_addr),
	       .sgpr_source1_rd_en(salu2sgpr_source1_rd_en),
	       .sgpr_source2_rd_en(salu2sgpr_source2_rd_en),
	       .issue_alu_ready(salu2issue_alu_ready),
	       .sgpr_instr_done_wfid(salu2sgpr_instr_done_wfid),
	       .sgpr_instr_done(salu2sgpr_instr_done),
	       .fetchwaveissue_branch_wfid(salu2fetchwaveissue_branch_wfid),
	       .fetchwaveissue_branch_en(salu2fetchwaveissue_branch_en),
	       .fetchwaveissue_branch_taken(salu2fetchwaveissue_branch_taken),
	       .fetch_branch_pc_value(salu2fetch_branch_pc_value),
	       .tracemon_retire_pc(salu2tracemon_retire_pc),
	       .tracemon_exec_word_sel(salu2tracemon_exec_word_sel),
	       .tracemon_vcc_word_sel(salu2tracemon_vcc_word_sel),
               .rfa2sgpr_request(salu_request)//**change
	       );

   sgpr sgpr0 (
	      // set of scalar general purpose registers
	      .clk(clk),
	      .rst(rst),
	      //  Inputs
`ifdef FPGA_BUILD
        .rfa_select_fu(sgpr_select_fu),
	      .lsu_source1_addr(lsu2sgpr_source1_addr_muxed),
        .lsu_source1_rd_en(lsu2sgpr_source1_rd_en_muxed),
        .lsu_dest_addr(lsu2sgpr_dest_addr_muxed),
	      .lsu_dest_data(lsu2sgpr_dest_data_muxed),
	      .lsu_dest_wr_en(lsu2sgpr_dest_wr_en_muxed),
`else
        .rfa_select_fu(rfa2execvgprsgpr_select_fu),
	      .lsu_source1_addr(lsu2sgpr_source1_addr),
        .lsu_source1_rd_en(lsu2sgpr_source1_rd_en),
        .lsu_dest_addr(lsu2sgpr_dest_addr),
	      .lsu_dest_data(lsu2sgpr_dest_data),
	      .lsu_dest_wr_en(lsu2sgpr_dest_wr_en),
`endif
	       .lsu_source2_addr(lsu2sgpr_source2_addr),
	       .lsu_source2_rd_en(lsu2sgpr_source2_rd_en),
	       .lsu_instr_done_wfid(lsu2sgpr_instr_done_wfid),
	       .lsu_instr_done(lsu2sgpr_instr_done),
	       .simd0_rd_addr(simd0_2sgpr_rd_addr),
	       .simd0_rd_en(simd0_2sgpr_rd_en),
	       .simd1_rd_addr(simd1_2sgpr_rd_addr),
	       .simd1_rd_en(simd1_2sgpr_rd_en),
	       .simd2_rd_addr(simd2_2sgpr_rd_addr),
	       .simd2_rd_en(simd2_2sgpr_rd_en),
	       .simd3_rd_addr(simd3_2sgpr_rd_addr),
	       .simd3_rd_en(simd3_2sgpr_rd_en),
	       .simd0_wr_addr(simd0_2sgpr_wr_addr),
	       .simd0_wr_en(simd0_2sgpr_wr_en),
	       .simd0_wr_data(simd0_2sgpr_wr_data),
	       .simd1_wr_addr(simd1_2sgpr_wr_addr),
	       .simd1_wr_en(simd1_2sgpr_wr_en),
	       .simd1_wr_data(simd1_2sgpr_wr_data),
	       .simd2_wr_addr(simd2_2sgpr_wr_addr),
	       .simd2_wr_en(simd2_2sgpr_wr_en),
	       .simd2_wr_data(simd2_2sgpr_wr_data),
	       .simd3_wr_addr(simd3_2sgpr_wr_addr),
	       .simd3_wr_en(simd3_2sgpr_wr_en),
	       .simd3_wr_data(simd3_2sgpr_wr_data),
	       .simd0_wr_mask(simd0_2sgpr_wr_mask),
	       .simd1_wr_mask(simd1_2sgpr_wr_mask),
	       .simd2_wr_mask(simd2_2sgpr_wr_mask),
	       .simd3_wr_mask(simd3_2sgpr_wr_mask),
	       .simf0_rd_addr(simf0_2sgpr_rd_addr),
	       .simf0_rd_en(simf0_2sgpr_rd_en),
	       .simf1_rd_addr(simf1_2sgpr_rd_addr),
	       .simf1_rd_en(simf1_2sgpr_rd_en),
	       .simf2_rd_addr(simf2_2sgpr_rd_addr),
	       .simf2_rd_en(simf2_2sgpr_rd_en),
	       .simf3_rd_addr(simf3_2sgpr_rd_addr),
	       .simf3_rd_en(simf3_2sgpr_rd_en),
	       .simf0_wr_addr(simf0_2sgpr_wr_addr),
	       .simf0_wr_en(simf0_2sgpr_wr_en),
	       .simf0_wr_data(simf0_2sgpr_wr_data),
	       .simf1_wr_addr(simf1_2sgpr_wr_addr),
	       .simf1_wr_en(simf1_2sgpr_wr_en),
	       .simf1_wr_data(simf1_2sgpr_wr_data),
	       .simf2_wr_addr(simf2_2sgpr_wr_addr),
	       .simf2_wr_en(simf2_2sgpr_wr_en),
	       .simf2_wr_data(simf2_2sgpr_wr_data),
	       .simf3_wr_addr(simf3_2sgpr_wr_addr),
	       .simf3_wr_en(simf3_2sgpr_wr_en),
	       .simf3_wr_data(simf3_2sgpr_wr_data),
	       .simf0_wr_mask(simf0_2sgpr_wr_mask),
	       .simf1_wr_mask(simf1_2sgpr_wr_mask),
	       .simf2_wr_mask(simf2_2sgpr_wr_mask),
	       .simf3_wr_mask(simf3_2sgpr_wr_mask),
	       .salu_dest_data(salu2sgpr_dest_data),
	       .salu_dest_addr(salu2sgpr_dest_addr),
	       .salu_dest_wr_en(salu2sgpr_dest_wr_en),
	       .salu_source2_addr(salu2sgpr_source2_addr),
	       .salu_source1_addr(salu2sgpr_source1_addr),
	       .salu_instr_done_wfid(salu2sgpr_instr_done_wfid),
	       .salu_instr_done(salu2sgpr_instr_done),
	       .salu_source1_rd_en(salu2sgpr_source1_rd_en),
	       .salu_source2_rd_en(salu2sgpr_source2_rd_en),
	       //  Outputs
	       .lsu_source1_data(sgpr2lsu_source1_data),
	       .lsu_source2_data(sgpr2lsu_source2_data),
	       .simd_rd_data(sgpr2simd_rd_data),
	       .simf_rd_data(sgpr2simf_rd_data),
	       .salu_source2_data(sgpr2salu_source2_data),
	       .salu_source1_data(sgpr2salu_source1_data),
	       .issue_alu_wr_done_wfid(sgpr2issue_alu_wr_done_wfid),
	       .issue_alu_wr_done(sgpr2issue_alu_wr_done),
	       .issue_alu_dest_reg_addr(sgpr2issue_alu_dest_reg_addr),
	       .issue_alu_dest_reg_valid(sgpr2issue_alu_dest_reg_valid),
	       .issue_lsu_instr_done_wfid(sgpr2issue_lsu_instr_done_wfid),
	       .issue_lsu_instr_done(sgpr2issue_lsu_instr_done),
	       .issue_lsu_dest_reg_addr(sgpr2issue_lsu_dest_reg_addr),
	       .issue_lsu_dest_reg_valid(sgpr2issue_lsu_dest_reg_valid),
	       .issue_valu_dest_reg_valid(sgpr2issue_valu_dest_reg_valid),
	       .issue_valu_dest_addr(sgpr2issue_valu_dest_addr)
	       );

   simd simd0 (
	       // Contains a 16 wide vector alu for vector operations
	       .clk(clk),
	       .rst(rst),
	       //  Inputs
	       .issue_source_reg1(issue2alu_source_reg1),
	       .issue_source_reg2(issue2alu_source_reg2),
	       .issue_source_reg3(issue2alu_source_reg3),
	       .issue_dest_reg1(issue2alu_dest_reg1),
	       .issue_dest_reg2(issue2alu_dest_reg2),
	       .issue_imm_value0(issue2alu_imm_value0),
	       .issue_imm_value1(issue2alu_imm_value1),
	       .issue_opcode(issue2alu_opcode),
	       .issue_wfid(issue2alu_wfid),
	       .issue_alu_select(issue2simd0_alu_select),
	       .vgpr_source1_data(vgpr2simd_source1_data),
	       .vgpr_source2_data(vgpr2simd_source2_data),
	       .vgpr_source3_data(vgpr2simd_source3_data),
	       .sgpr_rd_data(sgpr2simd_rd_data),
	       .exec_rd_exec_value(exec2simd_rd_exec_value),
	       .exec_rd_vcc_value(exec2simd_rd_vcc_value),
	       .exec_rd_m0_value(exec2simd_rd_m0_value),
	       .exec_rd_scc_value(exec2simd_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simd0_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simd0_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simd0_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simd0_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simd0_2vgpr_source1_addr),
	       .vgpr_source2_addr(simd0_2vgpr_source2_addr),
	       .vgpr_source3_addr(simd0_2vgpr_source3_addr),
	       .vgpr_dest_addr(simd0_2vgpr_dest_addr),
	       .vgpr_dest_data(simd0_2vgpr_dest_data),
	       .vgpr_wr_en(simd0_2vgpr_wr_en),
	       .vgpr_wr_mask(simd0_2vgpr_wr_mask),
	       .exec_rd_wfid(simd0_2exec_rd_wfid),
	       .exec_rd_en(simd0_2exec_rd_en),
	       .exec_wr_vcc_wfid(simd0_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simd0_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simd0_2exec_wr_vcc_value),
	       .sgpr_rd_en(simd0_2sgpr_rd_en),
	       .sgpr_rd_addr(simd0_2sgpr_rd_addr),
	       .sgpr_wr_addr(simd0_2sgpr_wr_addr),
	       .sgpr_wr_en(simd0_2sgpr_wr_en),
	       .sgpr_wr_data(simd0_2sgpr_wr_data),
	       .sgpr_wr_mask(simd0_2sgpr_wr_mask),
	       .issue_alu_ready(simd0_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simd0_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simd0_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simd0_2rfa_queue_entry_valid),
	       .tracemon_retire_pc(simd0_2tracemon_retire_pc)
	       );

`ifndef FPGA_BUILD
   simd simd1 (
	       // Contains a 16 wide vector alu for vector operations
	       .clk(clk),
	       .rst(rst),
	       //  Inputs
	       .issue_source_reg1(issue2alu_source_reg1),
	       .issue_source_reg2(issue2alu_source_reg2),
	       .issue_source_reg3(issue2alu_source_reg3),
	       .issue_dest_reg1(issue2alu_dest_reg1),
	       .issue_dest_reg2(issue2alu_dest_reg2),
	       .issue_imm_value0(issue2alu_imm_value0),
	       .issue_imm_value1(issue2alu_imm_value1),
	       .issue_opcode(issue2alu_opcode),
	       .issue_wfid(issue2alu_wfid),
	       .issue_alu_select(issue2simd1_alu_select),
	       .vgpr_source1_data(vgpr2simd_source1_data),
	       .vgpr_source2_data(vgpr2simd_source2_data),
	       .vgpr_source3_data(vgpr2simd_source3_data),
	       .sgpr_rd_data(sgpr2simd_rd_data),
	       .exec_rd_exec_value(exec2simd_rd_exec_value),
	       .exec_rd_vcc_value(exec2simd_rd_vcc_value),
	       .exec_rd_m0_value(exec2simd_rd_m0_value),
	       .exec_rd_scc_value(exec2simd_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simd1_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simd1_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simd1_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simd1_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simd1_2vgpr_source1_addr),
	       .vgpr_source2_addr(simd1_2vgpr_source2_addr),
	       .vgpr_source3_addr(simd1_2vgpr_source3_addr),
	       .vgpr_dest_addr(simd1_2vgpr_dest_addr),
	       .vgpr_dest_data(simd1_2vgpr_dest_data),
	       .vgpr_wr_en(simd1_2vgpr_wr_en),
	       .vgpr_wr_mask(simd1_2vgpr_wr_mask),
	       .exec_rd_wfid(simd1_2exec_rd_wfid),
	       .exec_rd_en(simd1_2exec_rd_en),
	       .exec_wr_vcc_wfid(simd1_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simd1_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simd1_2exec_wr_vcc_value),
	       .sgpr_rd_en(simd1_2sgpr_rd_en),
	       .sgpr_rd_addr(simd1_2sgpr_rd_addr),
	       .sgpr_wr_addr(simd1_2sgpr_wr_addr),
	       .sgpr_wr_en(simd1_2sgpr_wr_en),
	       .sgpr_wr_data(simd1_2sgpr_wr_data),
	       .sgpr_wr_mask(simd1_2sgpr_wr_mask),
	       .issue_alu_ready(simd1_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simd1_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simd1_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simd1_2rfa_queue_entry_valid),
	       .tracemon_retire_pc(simd1_2tracemon_retire_pc)
	       );

   simd simd2 (
	       // Contains a 16 wide vector alu for vector operations
	       .clk(clk),
	       .rst(rst),
	       //  Inputs
	       .issue_source_reg1(issue2alu_source_reg1),
	       .issue_source_reg2(issue2alu_source_reg2),
	       .issue_source_reg3(issue2alu_source_reg3),
	       .issue_dest_reg1(issue2alu_dest_reg1),
	       .issue_dest_reg2(issue2alu_dest_reg2),
	       .issue_imm_value0(issue2alu_imm_value0),
	       .issue_imm_value1(issue2alu_imm_value1),
	       .issue_opcode(issue2alu_opcode),
	       .issue_wfid(issue2alu_wfid),
	       .issue_alu_select(issue2simd2_alu_select),
	       .vgpr_source1_data(vgpr2simd_source1_data),
	       .vgpr_source2_data(vgpr2simd_source2_data),
	       .vgpr_source3_data(vgpr2simd_source3_data),
	       .sgpr_rd_data(sgpr2simd_rd_data),
	       .exec_rd_exec_value(exec2simd_rd_exec_value),
	       .exec_rd_vcc_value(exec2simd_rd_vcc_value),
	       .exec_rd_m0_value(exec2simd_rd_m0_value),
	       .exec_rd_scc_value(exec2simd_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simd2_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simd2_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simd2_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simd2_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simd2_2vgpr_source1_addr),
	       .vgpr_source2_addr(simd2_2vgpr_source2_addr),
	       .vgpr_source3_addr(simd2_2vgpr_source3_addr),
	       .vgpr_dest_addr(simd2_2vgpr_dest_addr),
	       .vgpr_dest_data(simd2_2vgpr_dest_data),
	       .vgpr_wr_en(simd2_2vgpr_wr_en),
	       .vgpr_wr_mask(simd2_2vgpr_wr_mask),
	       .exec_rd_wfid(simd2_2exec_rd_wfid),
	       .exec_rd_en(simd2_2exec_rd_en),
	       .exec_wr_vcc_wfid(simd2_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simd2_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simd2_2exec_wr_vcc_value),
	       .sgpr_rd_en(simd2_2sgpr_rd_en),
	       .sgpr_rd_addr(simd2_2sgpr_rd_addr),
	       .sgpr_wr_addr(simd2_2sgpr_wr_addr),
	       .sgpr_wr_en(simd2_2sgpr_wr_en),
	       .sgpr_wr_data(simd2_2sgpr_wr_data),
	       .sgpr_wr_mask(simd2_2sgpr_wr_mask),
	       .issue_alu_ready(simd2_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simd2_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simd2_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simd2_2rfa_queue_entry_valid),
	       .tracemon_retire_pc(simd2_2tracemon_retire_pc)
	       );

   simd simd3 (
	       // Contains a 16 wide vector alu for vector operations
	       .clk(clk),
	       .rst(rst),
	       //  Inputs
	       .issue_source_reg1(issue2alu_source_reg1),
	       .issue_source_reg2(issue2alu_source_reg2),
	       .issue_source_reg3(issue2alu_source_reg3),
	       .issue_dest_reg1(issue2alu_dest_reg1),
	       .issue_dest_reg2(issue2alu_dest_reg2),
	       .issue_imm_value0(issue2alu_imm_value0),
	       .issue_imm_value1(issue2alu_imm_value1),
	       .issue_opcode(issue2alu_opcode),
	       .issue_wfid(issue2alu_wfid),
	       .issue_alu_select(issue2simd3_alu_select),
	       .vgpr_source1_data(vgpr2simd_source1_data),
	       .vgpr_source2_data(vgpr2simd_source2_data),
	       .vgpr_source3_data(vgpr2simd_source3_data),
	       .sgpr_rd_data(sgpr2simd_rd_data),
	       .exec_rd_exec_value(exec2simd_rd_exec_value),
	       .exec_rd_vcc_value(exec2simd_rd_vcc_value),
	       .exec_rd_m0_value(exec2simd_rd_m0_value),
	       .exec_rd_scc_value(exec2simd_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simd3_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simd3_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simd3_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simd3_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simd3_2vgpr_source1_addr),
	       .vgpr_source2_addr(simd3_2vgpr_source2_addr),
	       .vgpr_source3_addr(simd3_2vgpr_source3_addr),
	       .vgpr_dest_addr(simd3_2vgpr_dest_addr),
	       .vgpr_dest_data(simd3_2vgpr_dest_data),
	       .vgpr_wr_en(simd3_2vgpr_wr_en),
	       .vgpr_wr_mask(simd3_2vgpr_wr_mask),
	       .exec_rd_wfid(simd3_2exec_rd_wfid),
	       .exec_rd_en(simd3_2exec_rd_en),
	       .exec_wr_vcc_wfid(simd3_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simd3_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simd3_2exec_wr_vcc_value),
	       .sgpr_rd_en(simd3_2sgpr_rd_en),
	       .sgpr_rd_addr(simd3_2sgpr_rd_addr),
	       .sgpr_wr_addr(simd3_2sgpr_wr_addr),
	       .sgpr_wr_en(simd3_2sgpr_wr_en),
	       .sgpr_wr_data(simd3_2sgpr_wr_data),
	       .sgpr_wr_mask(simd3_2sgpr_wr_mask),
	       .issue_alu_ready(simd3_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simd3_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simd3_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simd3_2rfa_queue_entry_valid),
	       .tracemon_retire_pc(simd3_2tracemon_retire_pc)
	       );
`endif
   simf simf0 (
	       // Contains a 16 wide floating point vector alu for vector operations
	       .clk(clk),
	       .rst(rst),
	       //  Inputs
	       .issue_source_reg1(issue2alu_source_reg1),
	       .issue_source_reg2(issue2alu_source_reg2),
	       .issue_source_reg3(issue2alu_source_reg3),
	       .issue_dest_reg1(issue2alu_dest_reg1),
	       .issue_dest_reg2(issue2alu_dest_reg2),
	       .issue_imm_value0(issue2alu_imm_value0),
	       .issue_imm_value1(issue2alu_imm_value1),
	       .issue_opcode(issue2alu_opcode),
	       .issue_wfid(issue2alu_wfid),
	       .issue_alu_select(issue2simf0_alu_select),
	       .vgpr_source1_data(vgpr2simf_source1_data),
	       .vgpr_source2_data(vgpr2simf_source2_data),
	       .vgpr_source3_data(vgpr2simf_source3_data),
	       .sgpr_rd_data(sgpr2simf_rd_data),
	       .exec_rd_exec_value(exec2simf_rd_exec_value),
	       .exec_rd_vcc_value(exec2simf_rd_vcc_value),
	       .exec_rd_m0_value(exec2simf_rd_m0_value),
	       .exec_rd_scc_value(exec2simf_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simf0_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simf0_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simf0_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simf0_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simf0_2vgpr_source1_addr),
	       .vgpr_source2_addr(simf0_2vgpr_source2_addr),
	       .vgpr_source3_addr(simf0_2vgpr_source3_addr),
	       .vgpr_dest_addr(simf0_2vgpr_dest_addr),
	       .vgpr_dest_data(simf0_2vgpr_dest_data),
	       .vgpr_wr_en(simf0_2vgpr_wr_en),
	       .vgpr_wr_mask(simf0_2vgpr_wr_mask),
	       .exec_rd_wfid(simf0_2exec_rd_wfid),
	       .exec_rd_en(simf0_2exec_rd_en),
	       .exec_wr_vcc_wfid(simf0_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simf0_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simf0_2exec_wr_vcc_value),
	       .sgpr_rd_en(simf0_2sgpr_rd_en),
	       .sgpr_rd_addr(simf0_2sgpr_rd_addr),
	       .sgpr_wr_addr(simf0_2sgpr_wr_addr),
	       .sgpr_wr_en(simf0_2sgpr_wr_en),
	       .sgpr_wr_data(simf0_2sgpr_wr_data),
	       .sgpr_wr_mask(simf0_2sgpr_wr_mask),
	       .issue_alu_ready(simf0_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simf0_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simf0_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simf0_2rfa_queue_entry_valid),
	       .tracemon_retire_pc(simf0_2tracemon_retire_pc)
	       );

`ifndef FPGA_BUILD
   simf simf1 (
	       // Contains a 16 wide floating point vector alu for vector operations
	       .clk(clk),
	       .rst(rst),
	       //  Inputs
	       .issue_source_reg1(issue2alu_source_reg1),
	       .issue_source_reg2(issue2alu_source_reg2),
	       .issue_source_reg3(issue2alu_source_reg3),
	       .issue_dest_reg1(issue2alu_dest_reg1),
	       .issue_dest_reg2(issue2alu_dest_reg2),
	       .issue_imm_value0(issue2alu_imm_value0),
	       .issue_imm_value1(issue2alu_imm_value1),
	       .issue_opcode(issue2alu_opcode),
	       .issue_wfid(issue2alu_wfid),
	       .issue_alu_select(issue2simf1_alu_select),
	       .vgpr_source1_data(vgpr2simf_source1_data),
	       .vgpr_source2_data(vgpr2simf_source2_data),
	       .vgpr_source3_data(vgpr2simf_source3_data),
	       .sgpr_rd_data(sgpr2simf_rd_data),
	       .exec_rd_exec_value(exec2simf_rd_exec_value),
	       .exec_rd_vcc_value(exec2simf_rd_vcc_value),
	       .exec_rd_m0_value(exec2simf_rd_m0_value),
	       .exec_rd_scc_value(exec2simf_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simf1_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simf1_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simf1_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simf1_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simf1_2vgpr_source1_addr),
	       .vgpr_source2_addr(simf1_2vgpr_source2_addr),
	       .vgpr_source3_addr(simf1_2vgpr_source3_addr),
	       .vgpr_dest_addr(simf1_2vgpr_dest_addr),
	       .vgpr_dest_data(simf1_2vgpr_dest_data),
	       .vgpr_wr_en(simf1_2vgpr_wr_en),
	       .vgpr_wr_mask(simf1_2vgpr_wr_mask),
	       .exec_rd_wfid(simf1_2exec_rd_wfid),
	       .exec_rd_en(simf1_2exec_rd_en),
	       .exec_wr_vcc_wfid(simf1_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simf1_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simf1_2exec_wr_vcc_value),
	       .sgpr_rd_en(simf1_2sgpr_rd_en),
	       .sgpr_rd_addr(simf1_2sgpr_rd_addr),
	       .sgpr_wr_addr(simf1_2sgpr_wr_addr),
	       .sgpr_wr_en(simf1_2sgpr_wr_en),
	       .sgpr_wr_data(simf1_2sgpr_wr_data),
	       .sgpr_wr_mask(simf1_2sgpr_wr_mask),
	       .issue_alu_ready(simf1_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simf1_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simf1_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simf1_2rfa_queue_entry_valid),
	       .tracemon_retire_pc(simf1_2tracemon_retire_pc)
	       );

   simf simf2 (
	       // Contains a 16 wide floating point vector alu for vector operations
	       .clk(clk),
	       .rst(rst),
	       //  Inputs
	       .issue_source_reg1(issue2alu_source_reg1),
	       .issue_source_reg2(issue2alu_source_reg2),
	       .issue_source_reg3(issue2alu_source_reg3),
	       .issue_dest_reg1(issue2alu_dest_reg1),
	       .issue_dest_reg2(issue2alu_dest_reg2),
	       .issue_imm_value0(issue2alu_imm_value0),
	       .issue_imm_value1(issue2alu_imm_value1),
	       .issue_opcode(issue2alu_opcode),
	       .issue_wfid(issue2alu_wfid),
	       .issue_alu_select(issue2simf2_alu_select),
	       .vgpr_source1_data(vgpr2simf_source1_data),
	       .vgpr_source2_data(vgpr2simf_source2_data),
	       .vgpr_source3_data(vgpr2simf_source3_data),
	       .sgpr_rd_data(sgpr2simf_rd_data),
	       .exec_rd_exec_value(exec2simf_rd_exec_value),
	       .exec_rd_vcc_value(exec2simf_rd_vcc_value),
	       .exec_rd_m0_value(exec2simf_rd_m0_value),
	       .exec_rd_scc_value(exec2simf_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simf2_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simf2_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simf2_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simf2_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simf2_2vgpr_source1_addr),
	       .vgpr_source2_addr(simf2_2vgpr_source2_addr),
	       .vgpr_source3_addr(simf2_2vgpr_source3_addr),
	       .vgpr_dest_addr(simf2_2vgpr_dest_addr),
	       .vgpr_dest_data(simf2_2vgpr_dest_data),
	       .vgpr_wr_en(simf2_2vgpr_wr_en),
	       .vgpr_wr_mask(simf2_2vgpr_wr_mask),
	       .exec_rd_wfid(simf2_2exec_rd_wfid),
	       .exec_rd_en(simf2_2exec_rd_en),
	       .exec_wr_vcc_wfid(simf2_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simf2_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simf2_2exec_wr_vcc_value),
	       .sgpr_rd_en(simf2_2sgpr_rd_en),
	       .sgpr_rd_addr(simf2_2sgpr_rd_addr),
	       .sgpr_wr_addr(simf2_2sgpr_wr_addr),
	       .sgpr_wr_en(simf2_2sgpr_wr_en),
	       .sgpr_wr_data(simf2_2sgpr_wr_data),
	       .sgpr_wr_mask(simf2_2sgpr_wr_mask),
	       .issue_alu_ready(simf2_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simf2_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simf2_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simf2_2rfa_queue_entry_valid),
	       .tracemon_retire_pc(simf2_2tracemon_retire_pc)
	       );

   simf simf3 (
	       // Contains a 16 wide floating point vector alu for vector operations
	       .clk(clk),
	       .rst(rst),
	       //  Inputs
	       .issue_source_reg1(issue2alu_source_reg1),
	       .issue_source_reg2(issue2alu_source_reg2),
	       .issue_source_reg3(issue2alu_source_reg3),
	       .issue_dest_reg1(issue2alu_dest_reg1),
	       .issue_dest_reg2(issue2alu_dest_reg2),
	       .issue_imm_value0(issue2alu_imm_value0),
	       .issue_imm_value1(issue2alu_imm_value1),
	       .issue_opcode(issue2alu_opcode),
	       .issue_wfid(issue2alu_wfid),
	       .issue_alu_select(issue2simf3_alu_select),
	       .vgpr_source1_data(vgpr2simf_source1_data),
	       .vgpr_source2_data(vgpr2simf_source2_data),
	       .vgpr_source3_data(vgpr2simf_source3_data),
	       .sgpr_rd_data(sgpr2simf_rd_data),
	       .exec_rd_exec_value(exec2simf_rd_exec_value),
	       .exec_rd_vcc_value(exec2simf_rd_vcc_value),
	       .exec_rd_m0_value(exec2simf_rd_m0_value),
	       .exec_rd_scc_value(exec2simf_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simf3_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simf3_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simf3_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simf3_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simf3_2vgpr_source1_addr),
	       .vgpr_source2_addr(simf3_2vgpr_source2_addr),
	       .vgpr_source3_addr(simf3_2vgpr_source3_addr),
	       .vgpr_dest_addr(simf3_2vgpr_dest_addr),
	       .vgpr_dest_data(simf3_2vgpr_dest_data),
	       .vgpr_wr_en(simf3_2vgpr_wr_en),
	       .vgpr_wr_mask(simf3_2vgpr_wr_mask),
	       .exec_rd_wfid(simf3_2exec_rd_wfid),
	       .exec_rd_en(simf3_2exec_rd_en),
	       .exec_wr_vcc_wfid(simf3_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simf3_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simf3_2exec_wr_vcc_value),
	       .sgpr_rd_en(simf3_2sgpr_rd_en),
	       .sgpr_rd_addr(simf3_2sgpr_rd_addr),
	       .sgpr_wr_addr(simf3_2sgpr_wr_addr),
	       .sgpr_wr_en(simf3_2sgpr_wr_en),
	       .sgpr_wr_data(simf3_2sgpr_wr_data),
	       .sgpr_wr_mask(simf3_2sgpr_wr_mask),
	       .issue_alu_ready(simf3_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simf3_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simf3_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simf3_2rfa_queue_entry_valid),
	       .tracemon_retire_pc(simf3_2tracemon_retire_pc)
	       );
`endif

   vgpr vgpr0 (
	      // A set of vector general purpose registers
	      .clk(clk),
	      .rst(rst),
	      //  Inputs
`ifdef FPGA_BUILD
        .rfa_select_fu(vgpr_select_fu),
        .lsu_source1_addr(lsu2vgpr_source1_addr_muxed),
        .lsu_source1_rd_en(lsu2vgpr_source1_rd_en_muxed),
        .lsu_dest_addr(lsu2vgpr_dest_addr_muxed),
	      .lsu_dest_data(lsu2vgpr_dest_data_muxed),
	      .lsu_dest_wr_en(lsu2vgpr_dest_wr_en_muxed),
	      .lsu_dest_wr_mask(lsu2vgpr_dest_wr_mask_muxed),
`else
        .rfa_select_fu(rfa2execvgprsgpr_select_fu),
        .lsu_source1_addr(lsu2vgpr_source1_addr),
        .lsu_source1_rd_en(lsu2vgpr_source1_rd_en),
        .lsu_dest_addr(lsu2vgpr_dest_addr),
	      .lsu_dest_data(lsu2vgpr_dest_data),
	      .lsu_dest_wr_en(lsu2vgpr_dest_wr_en),
	      .lsu_dest_wr_mask(lsu2vgpr_dest_wr_mask),
`endif
	       .lsu_source2_addr(lsu2vgpr_source2_addr),
	       .lsu_source2_rd_en(lsu2vgpr_source2_rd_en),
	       .lsu_instr_done_wfid(lsu2vgpr_instr_done_wfid),
	       .lsu_instr_done(lsu2vgpr_instr_done),
	       .simd0_source1_rd_en(simd0_2vgpr_source1_rd_en),
	       .simd1_source1_rd_en(simd1_2vgpr_source1_rd_en),
	       .simd2_source1_rd_en(simd2_2vgpr_source1_rd_en),
	       .simd3_source1_rd_en(simd3_2vgpr_source1_rd_en),
	       .simd0_source2_rd_en(simd0_2vgpr_source2_rd_en),
	       .simd1_source2_rd_en(simd1_2vgpr_source2_rd_en),
	       .simd2_source2_rd_en(simd2_2vgpr_source2_rd_en),
	       .simd3_source2_rd_en(simd3_2vgpr_source2_rd_en),
	       .simd0_source3_rd_en(simd0_2vgpr_source3_rd_en),
	       .simd1_source3_rd_en(simd1_2vgpr_source3_rd_en),
	       .simd2_source3_rd_en(simd2_2vgpr_source3_rd_en),
	       .simd3_source3_rd_en(simd3_2vgpr_source3_rd_en),
	       .simd0_source1_addr(simd0_2vgpr_source1_addr),
	       .simd1_source1_addr(simd1_2vgpr_source1_addr),
	       .simd2_source1_addr(simd2_2vgpr_source1_addr),
	       .simd3_source1_addr(simd3_2vgpr_source1_addr),
	       .simd0_source2_addr(simd0_2vgpr_source2_addr),
	       .simd1_source2_addr(simd1_2vgpr_source2_addr),
	       .simd2_source2_addr(simd2_2vgpr_source2_addr),
	       .simd3_source2_addr(simd3_2vgpr_source2_addr),
	       .simd0_source3_addr(simd0_2vgpr_source3_addr),
	       .simd1_source3_addr(simd1_2vgpr_source3_addr),
	       .simd2_source3_addr(simd2_2vgpr_source3_addr),
	       .simd3_source3_addr(simd3_2vgpr_source3_addr),
	       .simd0_dest_addr(simd0_2vgpr_dest_addr),
	       .simd1_dest_addr(simd1_2vgpr_dest_addr),
	       .simd2_dest_addr(simd2_2vgpr_dest_addr),
	       .simd3_dest_addr(simd3_2vgpr_dest_addr),
	       .simd0_dest_data(simd0_2vgpr_dest_data),
	       .simd1_dest_data(simd1_2vgpr_dest_data),
	       .simd2_dest_data(simd2_2vgpr_dest_data),
	       .simd3_dest_data(simd3_2vgpr_dest_data),
	       .simd0_wr_en(simd0_2vgpr_wr_en),
	       .simd1_wr_en(simd1_2vgpr_wr_en),
	       .simd2_wr_en(simd2_2vgpr_wr_en),
	       .simd3_wr_en(simd3_2vgpr_wr_en),
	       .simd0_wr_mask(simd0_2vgpr_wr_mask),
	       .simd1_wr_mask(simd1_2vgpr_wr_mask),
	       .simd2_wr_mask(simd2_2vgpr_wr_mask),
	       .simd3_wr_mask(simd3_2vgpr_wr_mask),
	       .simf0_source1_rd_en(simf0_2vgpr_source1_rd_en),
	       .simf1_source1_rd_en(simf1_2vgpr_source1_rd_en),
	       .simf2_source1_rd_en(simf2_2vgpr_source1_rd_en),
	       .simf3_source1_rd_en(simf3_2vgpr_source1_rd_en),
	       .simf0_source2_rd_en(simf0_2vgpr_source2_rd_en),
	       .simf1_source2_rd_en(simf1_2vgpr_source2_rd_en),
	       .simf2_source2_rd_en(simf2_2vgpr_source2_rd_en),
	       .simf3_source2_rd_en(simf3_2vgpr_source2_rd_en),
	       .simf0_source3_rd_en(simf0_2vgpr_source3_rd_en),
	       .simf1_source3_rd_en(simf1_2vgpr_source3_rd_en),
	       .simf2_source3_rd_en(simf2_2vgpr_source3_rd_en),
	       .simf3_source3_rd_en(simf3_2vgpr_source3_rd_en),
	       .simf0_source1_addr(simf0_2vgpr_source1_addr),
	       .simf1_source1_addr(simf1_2vgpr_source1_addr),
	       .simf2_source1_addr(simf2_2vgpr_source1_addr),
	       .simf3_source1_addr(simf3_2vgpr_source1_addr),
	       .simf0_source2_addr(simf0_2vgpr_source2_addr),
	       .simf1_source2_addr(simf1_2vgpr_source2_addr),
	       .simf2_source2_addr(simf2_2vgpr_source2_addr),
	       .simf3_source2_addr(simf3_2vgpr_source2_addr),
	       .simf0_source3_addr(simf0_2vgpr_source3_addr),
	       .simf1_source3_addr(simf1_2vgpr_source3_addr),
	       .simf2_source3_addr(simf2_2vgpr_source3_addr),
	       .simf3_source3_addr(simf3_2vgpr_source3_addr),
	       .simf0_dest_addr(simf0_2vgpr_dest_addr),
	       .simf1_dest_addr(simf1_2vgpr_dest_addr),
	       .simf2_dest_addr(simf2_2vgpr_dest_addr),
	       .simf3_dest_addr(simf3_2vgpr_dest_addr),
	       .simf0_dest_data(simf0_2vgpr_dest_data),
	       .simf1_dest_data(simf1_2vgpr_dest_data),
	       .simf2_dest_data(simf2_2vgpr_dest_data),
	       .simf3_dest_data(simf3_2vgpr_dest_data),
	       .simf0_wr_en(simf0_2vgpr_wr_en),
	       .simf1_wr_en(simf1_2vgpr_wr_en),
	       .simf2_wr_en(simf2_2vgpr_wr_en),
	       .simf3_wr_en(simf3_2vgpr_wr_en),
	       .simf0_wr_mask(simf0_2vgpr_wr_mask),
	       .simf1_wr_mask(simf1_2vgpr_wr_mask),
	       .simf2_wr_mask(simf2_2vgpr_wr_mask),
	       .simf3_wr_mask(simf3_2vgpr_wr_mask),
	       .simd0_instr_done_wfid(simd0_2vgpr_instr_done_wfid),
	       .simd1_instr_done_wfid(simd1_2vgpr_instr_done_wfid),
	       .simd2_instr_done_wfid(simd2_2vgpr_instr_done_wfid),
	       .simd3_instr_done_wfid(simd3_2vgpr_instr_done_wfid),
	       .simd0_instr_done(simd0_2vgpr_instr_done),
	       .simd1_instr_done(simd1_2vgpr_instr_done),
	       .simd2_instr_done(simd2_2vgpr_instr_done),
	       .simd3_instr_done(simd3_2vgpr_instr_done),
	       .simf0_instr_done_wfid(simf0_2vgpr_instr_done_wfid),
	       .simf1_instr_done_wfid(simf1_2vgpr_instr_done_wfid),
	       .simf2_instr_done_wfid(simf2_2vgpr_instr_done_wfid),
	       .simf3_instr_done_wfid(simf3_2vgpr_instr_done_wfid),
	       .simf0_instr_done(simf0_2vgpr_instr_done),
	       .simf1_instr_done(simf1_2vgpr_instr_done),
	       .simf2_instr_done(simf2_2vgpr_instr_done),
	       .simf3_instr_done(simf3_2vgpr_instr_done),
	       //  Outputs
	       .simd_source1_data(vgpr2simd_source1_data),
	       .simd_source2_data(vgpr2simd_source2_data),
	       .simd_source3_data(vgpr2simd_source3_data),
	       .simf_source1_data(vgpr2simf_source1_data),
	       .simf_source2_data(vgpr2simf_source2_data),
	       .simf_source3_data(vgpr2simf_source3_data),
	       .lsu_source1_data(vgpr2lsu_source1_data),
	       .lsu_source2_data(vgpr2lsu_source2_data),
	       .issue_alu_wr_done_wfid(vgpr2issue_alu_wr_done_wfid),
	       .issue_alu_wr_done(vgpr2issue_alu_wr_done),
	       .issue_alu_dest_reg_addr(vgpr2issue_alu_dest_reg_addr),
	       .issue_alu_dest_reg_valid(vgpr2issue_alu_dest_reg_valid),
	       .issue_lsu_wr_done_wfid(vgpr2issue_lsu_wr_done_wfid),
	       .issue_lsu_wr_done(vgpr2issue_lsu_wr_done),
	       .issue_lsu_dest_reg_addr(vgpr2issue_lsu_dest_reg_addr),
	       .issue_lsu_dest_reg_valid(vgpr2issue_lsu_dest_reg_valid)
	       );

   wavepool wavepool0 (
		       // Unit that choses wavefronts fetched and keeps control of a instruction queue.
		       .clk(clk),
		       .rst(rst),
		       //  Inputs
		       .fetch_reserve_slotid(fetch2wave_reserve_slotid),
		       .fetch_reserve_valid(fetch2wave_reserve_valid),
		       .fetch_basereg_wr(fetch2wave_basereg_wr),
		       .fetch_basereg_wfid(fetch2wave_basereg_wfid),
		       .fetch_vgpr_base(fetch2wave_vgpr_base),
		       .fetch_sgpr_base(fetch2wave_sgpr_base),
		       .fetch_lds_base(fetch2wave_lds_base),
		       .issue_valid_entries(issue2wave_valid_entries),
		       .buff_tag(buff2wave_tag),
		       .buff_instr(buff2wave_instr),
		       .buff2fetchwave_ack(buff2fetchwave_ack),
		       .issue_wf_done_en(issue2fetchwave_wf_done_en),
		       .issue_wf_done_wf_id(issue2fetchwave_wf_done_wf_id),
		       .salu_branch_wfid(salu2fetchwaveissue_branch_wfid),
		       .salu_branch_en(salu2fetchwaveissue_branch_en),
		       .salu_branch_taken(salu2fetchwaveissue_branch_taken),
		       .decode_ins_half_rqd(decode2wave_ins_half_rqd),
		       .decode_ins_half_wfid(decode2wave_ins_half_wfid),
		       //  Outputs
		       .fetch_stop_fetch(wave2fetch_stop_fetch),
		       .decode_instr_valid(wave2decode_instr_valid),
		       .decode_instr(wave2decode_instr),
		       .decode_wfid(wave2decode_wfid),
		       .decode_vgpr_base(wave2decode_vgpr_base),
		       .decode_sgpr_base(wave2decode_sgpr_base),
		       .decode_lds_base(wave2decode_lds_base),
		       .decode_instr_pc(wave2decode_instr_pc)
		       );

endmodule
