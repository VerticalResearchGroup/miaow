module wavepool_tb;
  
  //wires
  reg clk;

  reg rst;

  reg fetch_reserve_valid, fetch_basereg_wr, buff2fetchwave_ack, issue_wf_done_en,
         salu_branch_en, salu_branch_taken;
  reg[5:0] fetch_reserve_slotid, fetch_basereg_wfid, issue_wf_done_wf_id,
         salu_branch_wfid;
  reg[8:0] fetch_sgpr_base;
  reg[9:0] fetch_vgpr_base;
  reg[15:0] fetch_lds_base;
  reg[31:0] buff_instr;
  reg[38:0] buff_tag;
  reg[39:0] issue_valid_entries;
  reg decode_ins_half_rqd;
  reg[5:0] decode_ins_half_wfid;

  wire decode_instr_valid;
  wire[5:0] decode_wfid;
  wire[8:0] decode_sgpr_base;
  wire[9:0] decode_vgpr_base;
  wire[15:0] decode_lds_base;
  wire[31:0] decode_instr, decode_instr_pc;
  wire[39:0] fetch_stop_fetch;

  //instantiation of dut
  wavepool wavepool0(
  .fetch_reserve_slotid(fetch_reserve_slotid),
  .fetch_reserve_valid(fetch_reserve_valid),
  .fetch_basereg_wr(fetch_basereg_wr),
  .fetch_basereg_wfid(fetch_basereg_wfid),
  .fetch_vgpr_base(fetch_vgpr_base),
  .fetch_sgpr_base(fetch_sgpr_base),
  .fetch_lds_base(fetch_lds_base),
  .issue_valid_entries(issue_valid_entries),
  .decode_ins_half_rqd(decode_ins_half_rqd),
  .decode_ins_half_wfid(decode_ins_half_wfid),
  .buff_tag(buff_tag),
  .buff_instr(buff_instr),
  .buff2fetchwave_ack(buff2fetchwave_ack),
  .issue_wf_done_en(issue_wf_done_en),
  .issue_wf_done_wf_id(issue_wf_done_wf_id),
  .salu_branch_wfid(salu_branch_wfid),
  .salu_branch_en(salu_branch_en),
  .salu_branch_taken(salu_branch_taken),
  .fetch_stop_fetch(fetch_stop_fetch),
  .decode_instr_valid(decode_instr_valid),
  .decode_instr(decode_instr),
  .decode_wfid(decode_wfid),
  .decode_vgpr_base(decode_vgpr_base),
  .decode_sgpr_base(decode_sgpr_base),
  .decode_lds_base(decode_lds_base),
  .decode_instr_pc(decode_instr_pc),
  .clk(clk),
  .rst(rst)
  );

  //stimulii
  initial begin
    forever #5 clk = ~clk;
  end
  initial begin
    #3 clk = 1'b0;
    #16 rst = 1'b1;
    fetch_reserve_valid = 1'b0;
    fetch_basereg_wr = 1'b0;
    issue_valid_entries = 1'b0;
    decode_ins_half_rqd = 1'b0;
    buff2fetchwave_ack = 1'b0;
    issue_wf_done_en = 1'b0;
    salu_branch_en = 1'b0;
    salu_branch_taken = 1'b0;
    
    #10 rst = 1'b0;
    #2000;
    $finish;
  end
  initial begin
    #31;
    fetch_reserve_valid = 1'b1;
    fetch_reserve_slotid = 6'd17;
    #10;
    fetch_reserve_valid = 1'b0;
    buff2fetchwave_ack = 1'b1;
    buff_instr = 32'hdead_babe; 
    buff_tag = {1'b1,6'd17,32'hcafe_f00d};
    #10; 
    buff2fetchwave_ack = 1'b0;
    fetch_reserve_valid = 1'b1;
    fetch_reserve_slotid = 6'd17;
    #10;
    fetch_reserve_valid = 1'b0;
    buff2fetchwave_ack = 1'b1;
    buff_instr = 32'hdeaf_beef; 
    buff_tag = {1'b0,6'd17,32'hcafe_f011};
    #10;
    buff2fetchwave_ack = 1'b0;
    #30;
    decode_ins_half_rqd = 1'b1;
    decode_ins_half_wfid = 6'd17;
    #10;
    decode_ins_half_rqd = 1'b0;

    

    
  end

  //monitors
  initial begin
    if ($test$plusargs("print_outputs")) begin
      $monitor("test output = %b", rst);
    end
  end

  //waveforms
  initial begin
    if ($test$plusargs("dump_waveforms")) begin
      $vcdpluson(0,wavepool_tb);
      //$vcdpluson(<level>,scope,<signal>);
      //Lots of options for dumping waves
      //(both system calls and run time arguments)
      // http://read.pudn.com/downloads97/sourcecode/others/399556/vcs_0123.pdf
    end
  end

endmodule
