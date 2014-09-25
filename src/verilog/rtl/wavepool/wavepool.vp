module wavepool( 
      fetch_reserve_slotid,
      fetch_reserve_valid,
      fetch_basereg_wr,
      fetch_basereg_wfid,
      fetch_vgpr_base,
      fetch_sgpr_base,
      fetch_lds_base,
      issue_valid_entries,
      buff_tag,
      buff_instr,
      buff2fetchwave_ack,
      issue_wf_done_en,
      issue_wf_done_wf_id,
      salu_branch_wfid,
      salu_branch_en,
      salu_branch_taken,
      decode_ins_half_rqd,
      decode_ins_half_wfid,
      fetch_stop_fetch,
      decode_instr_valid,
      decode_instr,
      decode_wfid,
      decode_vgpr_base,
      decode_sgpr_base,
      decode_lds_base,
      decode_instr_pc,
      clk,
      rst
 );

input clk;

input rst;

input fetch_reserve_valid, fetch_basereg_wr, buff2fetchwave_ack, issue_wf_done_en,
         salu_branch_en, salu_branch_taken, decode_ins_half_rqd;
input[5:0] fetch_reserve_slotid, fetch_basereg_wfid, issue_wf_done_wf_id,
         salu_branch_wfid, decode_ins_half_wfid;
input[8:0] fetch_sgpr_base;
input[9:0] fetch_vgpr_base;
input[15:0] fetch_lds_base;
input[31:0] buff_instr;
input[38:0] buff_tag;
input[39:0] issue_valid_entries;

output decode_instr_valid;
output[5:0] decode_wfid;
output[8:0] decode_sgpr_base;
output[9:0] decode_vgpr_base;
output[15:0] decode_lds_base;
output[31:0] decode_instr, decode_instr_pc;
output[39:0] fetch_stop_fetch;

///////////////////////////////
//Your code goes here - beware: script does not recognize changes
// into files. It ovewrites everithing without mercy. Save your work before running the script
///////////////////////////////

wire [5:0] flopped_buff_wfid;
wire [63:0] flopped_buff_instr_pc;
wire flopped_buff_first;
wire flopped_buff_ack;

wire [5:0] feed_wfid;
wire feed_valid;

wire [39:0] valid_wf;

wire [39:0] q_wr;
wire [39:0] q_vtail_incr;
wire [39:0] q_reset;
wire [39:0] q_rd;
wire [39:0] q_empty;

PS_flops_fetch_wavepool PS_flops(
  .buff_tag(buff_tag),
  .buff_instr(buff_instr),
  .buff_ack(buff2fetchwave_ack),
  .flopped_buff_wfid(flopped_buff_wfid),
  .flopped_buff_instr_pc(flopped_buff_instr_pc),
  .flopped_buff_first(flopped_buff_first),
  .flopped_buff_ack(flopped_buff_ack),
  .clk(clk),
  .rst(rst)
);

wavepool_controller cntrl(
  .buff_wfid(flopped_buff_wfid),
  .buff_first(flopped_buff_first),
  .buff_ack(flopped_buff_ack),
  .q_wr(q_wr),
  .reserve_slotid(fetch_reserve_slotid),
  .reserve_valid(fetch_reserve_valid),
  .q_vtail_incr(q_vtail_incr),
  .halt_wfid(issue_wf_done_wf_id),
  .wf_halt(issue_wf_done_en),
  .branch_wfid(salu_branch_wfid),
  .branch_en(salu_branch_en),
  .branch_taken(salu_branch_taken),
  .q_reset(q_reset),
  .feed_wfid(feed_wfid),
  .feed_valid(feed_valid),
  .q_rd(q_rd),
  .valid_wf(valid_wf),
  .decode_wfid(decode_wfid),
  .decode_instr_valid(decode_instr_valid),
  .clk(clk),
  .rst(rst)
);

scbd_feeder feeder(
  .valid_wf(valid_wf),
  .ins_half_reqd(decode_ins_half_rqd),
  .ins_half_wfid(decode_ins_half_wfid),
  .issue_vacant(issue_valid_entries),
  .q_empty(q_empty),
  .q_reset(q_reset),
  .feed_valid(feed_valid),
  .feed_wfid(feed_wfid),
  .clk(clk),
  .rst(rst)
);

wq_pool pool(
  .q_vtail_incr(q_vtail_incr),
  .q_rd(q_rd),
  .q_wr(q_wr),
  .q_reset(q_reset),
  .q_empty(q_empty),
  .stop_fetch(fetch_stop_fetch),
  .instr_pc_in(flopped_buff_instr_pc),
  .instr_pc_out({decode_instr,decode_instr_pc}),
  .wf_select(decode_wfid),
  .clk(clk),
  .rst(rst)
);

reg_40x35b_1r_1w base_regs(
  .rd_addr(decode_wfid),
  .rd_data({decode_vgpr_base,decode_sgpr_base,decode_lds_base}),
  .wr_en(fetch_basereg_wr),
  .wr_addr(fetch_basereg_wfid),
  .wr_data({fetch_vgpr_base,fetch_sgpr_base,fetch_lds_base}),
  .clk(clk),
  .rst(rst)
);

///////////////////////////////
//Your code goes here - beware: script does not recognize changes
// into files. It ovewrites everithing without mercy. Save your work before running the script
///////////////////////////////
endmodule
