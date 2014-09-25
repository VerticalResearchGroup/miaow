module vgpr_tb;
  
  //wires
reg clk;

reg rst;

reg simd0_source1_rd_en, simd1_source1_rd_en, simd2_source1_rd_en,
         simd3_source1_rd_en, simd0_source2_rd_en, simd1_source2_rd_en, simd2_source2_rd_en,
         simd3_source2_rd_en, simd0_source3_rd_en, simd1_source3_rd_en, simd2_source3_rd_en,
         simd3_source3_rd_en, simd0_wr_en, simd1_wr_en, simd2_wr_en, simd3_wr_en,
         simf0_source1_rd_en, simf1_source1_rd_en, simf2_source1_rd_en, simf3_source1_rd_en,
         simf0_source2_rd_en, simf1_source2_rd_en, simf2_source2_rd_en, simf3_source2_rd_en,
         simf0_source3_rd_en, simf1_source3_rd_en, simf2_source3_rd_en, simf3_source3_rd_en,
         simf0_wr_en, simf1_wr_en, simf2_wr_en, simf3_wr_en, lsu_instr_done,
         simd0_instr_done, simd1_instr_done, simd2_instr_done, simd3_instr_done,
         simf0_instr_done, simf1_instr_done, simf2_instr_done, simf3_instr_done,
         lsu_source1_rd_en, lsu_source2_rd_en;
reg[5:0] lsu_instr_done_wfid, simd0_instr_done_wfid, simd1_instr_done_wfid,
         simd2_instr_done_wfid, simd3_instr_done_wfid, simf0_instr_done_wfid,
         simf1_instr_done_wfid, simf2_instr_done_wfid, simf3_instr_done_wfid;
reg[9:0] simd0_source1_addr, simd1_source1_addr, simd2_source1_addr,
         simd3_source1_addr, simd0_source2_addr, simd1_source2_addr, simd2_source2_addr,
         simd3_source2_addr, simd0_source3_addr, simd1_source3_addr, simd2_source3_addr,
         simd3_source3_addr, simd0_dest_addr, simd1_dest_addr, simd2_dest_addr,
         simd3_dest_addr, simf0_source1_addr, simf1_source1_addr, simf2_source1_addr,
         simf3_source1_addr, simf0_source2_addr, simf1_source2_addr, simf2_source2_addr,
         simf3_source2_addr, simf0_source3_addr, simf1_source3_addr, simf2_source3_addr,
         simf3_source3_addr, simf0_dest_addr, simf1_dest_addr, simf2_dest_addr,
         simf3_dest_addr, lsu_source1_addr, lsu_source2_addr, lsu_dest_addr;
reg[15:0] rfa_select_fu;
reg[63:0] simd0_wr_mask, simd1_wr_mask, simd2_wr_mask, simd3_wr_mask,
         simf0_wr_mask, simf1_wr_mask, simf2_wr_mask, simf3_wr_mask, lsu_dest_wr_mask;
reg[3:0] lsu_dest_wr_en;
reg[2047:0] simd0_dest_data, simd1_dest_data, simd2_dest_data, simd3_dest_data,
         simf0_dest_data, simf1_dest_data, simf2_dest_data, simf3_dest_data;
reg[8191:0] lsu_dest_data;

wire issue_alu_wr_done, issue_alu_dest_reg_valid, issue_lsu_wr_done;
wire[3:0] issue_lsu_dest_reg_valid;
wire[5:0] issue_alu_wr_done_wfid, issue_lsu_wr_done_wfid;
wire[9:0] issue_alu_dest_reg_addr, issue_lsu_dest_reg_addr;
wire[2047:0] simd_source1_data, simd_source2_data, simd_source3_data,
         simf_source1_data, simf_source2_data, simf_source3_data, lsu_source2_data;
wire[8191:0] lsu_source1_data;

  //instantiation of dut
  vgpr vgpr0 (
    .simd0_source1_rd_en(simd0_source1_rd_en),
    .simd1_source1_rd_en(simd1_source1_rd_en),
    .simd2_source1_rd_en(simd2_source1_rd_en),
    .simd3_source1_rd_en(simd3_source1_rd_en),
    .simd0_source2_rd_en(simd0_source2_rd_en),
    .simd1_source2_rd_en(simd1_source2_rd_en),
    .simd2_source2_rd_en(simd2_source2_rd_en),
    .simd3_source2_rd_en(simd3_source2_rd_en),
    .simd0_source3_rd_en(simd0_source3_rd_en),
    .simd1_source3_rd_en(simd1_source3_rd_en),
    .simd2_source3_rd_en(simd2_source3_rd_en),
    .simd3_source3_rd_en(simd3_source3_rd_en),
    .simd0_source1_addr(simd0_source1_addr),
    .simd1_source1_addr(simd1_source1_addr),
    .simd2_source1_addr(simd2_source1_addr),
    .simd3_source1_addr(simd3_source1_addr),
    .simd0_source2_addr(simd0_source2_addr),
    .simd1_source2_addr(simd1_source2_addr),
    .simd2_source2_addr(simd2_source2_addr),
    .simd3_source2_addr(simd3_source2_addr),
    .simd0_source3_addr(simd0_source3_addr),
    .simd1_source3_addr(simd1_source3_addr),
    .simd2_source3_addr(simd2_source3_addr),
    .simd3_source3_addr(simd3_source3_addr),
    .simd0_dest_addr(simd0_dest_addr),
    .simd1_dest_addr(simd1_dest_addr),
    .simd2_dest_addr(simd2_dest_addr),
    .simd3_dest_addr(simd3_dest_addr),
    .simd0_dest_data(simd0_dest_data),
    .simd1_dest_data(simd1_dest_data),
    .simd2_dest_data(simd2_dest_data),
    .simd3_dest_data(simd3_dest_data),
    .simd0_wr_en(simd0_wr_en),
    .simd1_wr_en(simd1_wr_en),
    .simd2_wr_en(simd2_wr_en),
    .simd3_wr_en(simd3_wr_en),
    .simd0_wr_mask(simd0_wr_mask),
    .simd1_wr_mask(simd1_wr_mask),
    .simd2_wr_mask(simd2_wr_mask),
    .simd3_wr_mask(simd3_wr_mask),
    .simf0_source1_rd_en(simf0_source1_rd_en),
    .simf1_source1_rd_en(simf1_source1_rd_en),
    .simf2_source1_rd_en(simf2_source1_rd_en),
    .simf3_source1_rd_en(simf3_source1_rd_en),
    .simf0_source2_rd_en(simf0_source2_rd_en),
    .simf1_source2_rd_en(simf1_source2_rd_en),
    .simf2_source2_rd_en(simf2_source2_rd_en),
    .simf3_source2_rd_en(simf3_source2_rd_en),
    .simf0_source3_rd_en(simf0_source3_rd_en),
    .simf1_source3_rd_en(simf1_source3_rd_en),
    .simf2_source3_rd_en(simf2_source3_rd_en),
    .simf3_source3_rd_en(simf3_source3_rd_en),
    .simf0_source1_addr(simf0_source1_addr),
    .simf1_source1_addr(simf1_source1_addr),
    .simf2_source1_addr(simf2_source1_addr),
    .simf3_source1_addr(simf3_source1_addr),
    .simf0_source2_addr(simf0_source2_addr),
    .simf1_source2_addr(simf1_source2_addr),
    .simf2_source2_addr(simf2_source2_addr),
    .simf3_source2_addr(simf3_source2_addr),
    .simf0_source3_addr(simf0_source3_addr),
    .simf1_source3_addr(simf1_source3_addr),
    .simf2_source3_addr(simf2_source3_addr),
    .simf3_source3_addr(simf3_source3_addr),
    .simf0_dest_addr(simf0_dest_addr),
    .simf1_dest_addr(simf1_dest_addr),
    .simf2_dest_addr(simf2_dest_addr),
    .simf3_dest_addr(simf3_dest_addr),
    .simf0_dest_data(simf0_dest_data),
    .simf1_dest_data(simf1_dest_data),
    .simf2_dest_data(simf2_dest_data),
    .simf3_dest_data(simf3_dest_data),
    .simf0_wr_en(simf0_wr_en),
    .simf1_wr_en(simf1_wr_en),
    .simf2_wr_en(simf2_wr_en),
    .simf3_wr_en(simf3_wr_en),
    .simf0_wr_mask(simf0_wr_mask),
    .simf1_wr_mask(simf1_wr_mask),
    .simf2_wr_mask(simf2_wr_mask),
    .simf3_wr_mask(simf3_wr_mask),
    .lsu_source1_addr(lsu_source1_addr),
    .lsu_source1_rd_en(lsu_source1_rd_en),
    .lsu_source2_addr(lsu_source2_addr),
    .lsu_source2_rd_en(lsu_source2_rd_en),
    .lsu_dest_addr(lsu_dest_addr),
    .lsu_dest_data(lsu_dest_data),
    .lsu_dest_wr_mask(lsu_dest_wr_mask),
    .lsu_dest_wr_en(lsu_dest_wr_en),
    .lsu_instr_done_wfid(lsu_instr_done_wfid),
    .lsu_instr_done(lsu_instr_done),
    .simd0_instr_done_wfid(simd0_instr_done_wfid),
    .simd1_instr_done_wfid(simd1_instr_done_wfid),
    .simd2_instr_done_wfid(simd2_instr_done_wfid),
    .simd3_instr_done_wfid(simd3_instr_done_wfid),
    .simd0_instr_done(simd0_instr_done),
    .simd1_instr_done(simd1_instr_done),
    .simd2_instr_done(simd2_instr_done),
    .simd3_instr_done(simd3_instr_done),
    .simf0_instr_done_wfid(simf0_instr_done_wfid),
    .simf1_instr_done_wfid(simf1_instr_done_wfid),
    .simf2_instr_done_wfid(simf2_instr_done_wfid),
    .simf3_instr_done_wfid(simf3_instr_done_wfid),
    .simf0_instr_done(simf0_instr_done),
    .simf1_instr_done(simf1_instr_done),
    .simf2_instr_done(simf2_instr_done),
    .simf3_instr_done(simf3_instr_done),
    .rfa_select_fu(rfa_select_fu),
    .simd_source1_data(simd_source1_data),
    .simd_source2_data(simd_source2_data),
    .simd_source3_data(simd_source3_data),
    .simf_source1_data(simf_source1_data),
    .simf_source2_data(simf_source2_data),
    .simf_source3_data(simf_source3_data),
    .lsu_source1_data(lsu_source1_data),
    .lsu_source2_data(lsu_source2_data),
    .issue_alu_wr_done_wfid(issue_alu_wr_done_wfid),
    .issue_alu_wr_done(issue_alu_wr_done),
    .issue_alu_dest_reg_addr(issue_alu_dest_reg_addr),
    .issue_alu_dest_reg_valid(issue_alu_dest_reg_valid),
    .issue_lsu_wr_done_wfid(issue_lsu_wr_done_wfid),
    .issue_lsu_wr_done(issue_lsu_wr_done),
    .issue_lsu_dest_reg_addr(issue_lsu_dest_reg_addr),
    .issue_lsu_dest_reg_valid(issue_lsu_dest_reg_valid),
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
    lsu_dest_wr_mask = 64'h0000_0000_0000_0000;
    lsu_dest_wr_en = 4'b0000;
    rfa_select_fu = 16'b0;
    simd0_wr_en = 1'b0;
    simd1_wr_en = 1'b0;
    simd2_wr_en = 1'b0;
    simd3_wr_en = 1'b0;
    simf0_wr_en = 1'b0;
    simf1_wr_en = 1'b0;
    simf2_wr_en = 1'b0;
    simf3_wr_en = 1'b0;
    //simd0_wr_mask = 64'b0;
    //simd1_wr_mask = 64'b0;
    //simd2_wr_mask = 64'b0;
    //simd3_wr_mask = 64'b0;
    simd0_source1_rd_en = 1'b0;
    simd1_source1_rd_en = 1'b0;
    simd2_source1_rd_en = 1'b0;
    simd3_source1_rd_en = 1'b0;
    simd0_source2_rd_en = 1'b0;
    simd1_source2_rd_en = 1'b0;
    simd2_source2_rd_en = 1'b0;
    simd3_source2_rd_en = 1'b0;
    simd0_source3_rd_en = 1'b0;
    simd1_source3_rd_en = 1'b0;
    simd2_source3_rd_en = 1'b0;
    simd3_source3_rd_en = 1'b0;
    simf0_source1_rd_en = 1'b0;
    simf1_source1_rd_en = 1'b0;
    simf2_source1_rd_en = 1'b0;
    simf3_source1_rd_en = 1'b0;
    simf0_source2_rd_en = 1'b0;
    simf1_source2_rd_en = 1'b0;
    simf2_source2_rd_en = 1'b0;
    simf3_source2_rd_en = 1'b0;
    simf0_source3_rd_en = 1'b0;
    simf1_source3_rd_en = 1'b0;
    simf2_source3_rd_en = 1'b0;
    simf3_source3_rd_en = 1'b0;
    simd0_instr_done = 1'b0;
    simd1_instr_done = 1'b0;
    simd2_instr_done = 1'b0;
    simd3_instr_done = 1'b0;
    lsu_source1_rd_en = 1'b0;
    lsu_source2_rd_en = 1'b0;

    #10 rst = 1'b0;
    #2000;
    $finish;
  end
  initial begin
    #31;
    #10 lsu_source1_rd_en = 1'b1;
    lsu_source1_addr = 10'd100;
    
    #10 lsu_source1_rd_en = 1'b0;
    lsu_dest_addr = 10'd50;
    lsu_dest_data = {{6144{1'bx}},2047'hf0f0_f0f0_ffff_0000};
    lsu_dest_wr_mask = 64'h0000_0000_0000_0001;
    lsu_dest_wr_en = 4'b0001;
    
    #10 lsu_dest_wr_mask = 64'h0000_0000_0000_0000;
    lsu_dest_wr_en = 4'b0000;
   
    #10 simf2_source2_addr =  10'd50;
    simf2_source2_rd_en = 1'b1;
    
  end
  //monitors
  initial begin
    if ($test$plusargs("print_outputs")) begin
      $monitor("rst = %b", rst);
    end
  end

  //waveforms
  initial begin
    if ($test$plusargs("dump_waveforms")) begin
      $vcdpluson(0,vgpr_tb);
      //$vcdpluson(<level>,scope,<signal>);
      //Lots of options for dumping waves
      //(both system calls and run time arguments)
      // http://read.pudn.com/downloads97/sourcecode/others/399556/vcs_0123.pdf
    end
  end

endmodule
