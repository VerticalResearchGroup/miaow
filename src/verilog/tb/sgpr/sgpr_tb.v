module sgpr_tb;
//wires and regs
reg clk;

reg rst;

reg lsu_instr_done, simd0_rd_en, simd1_rd_en, simd2_rd_en,
         simd3_rd_en, simd0_wr_en, simd1_wr_en, simd2_wr_en, simd3_wr_en, simf0_rd_en,
         simf1_rd_en, simf2_rd_en, simf3_rd_en, simf0_wr_en, simf1_wr_en, simf2_wr_en,
         simf3_wr_en, salu_instr_done;
reg lsu_source1_rd_en, lsu_source2_rd_en, salu_source1_rd_en, salu_source2_rd_en;
reg[3:0] lsu_dest_wr_en;
reg[1:0] salu_dest_wr_en;
reg[5:0] lsu_instr_done_wfid, salu_instr_done_wfid;
reg[8:0] lsu_source1_addr, lsu_source2_addr, lsu_dest_addr, simd0_rd_addr,
         simd1_rd_addr, simd2_rd_addr, simd3_rd_addr, simd0_wr_addr, simd1_wr_addr,
         simd2_wr_addr, simd3_wr_addr, simf0_rd_addr, simf1_rd_addr, simf2_rd_addr,
         simf3_rd_addr, simf0_wr_addr, simf1_wr_addr, simf2_wr_addr, simf3_wr_addr,
         salu_dest_addr, salu_source2_addr, salu_source1_addr;
reg[15:0] rfa_select_fu;
reg[127:0] lsu_dest_data;
reg[63:0] simd0_wr_data, simd1_wr_data, simd2_wr_data, simd3_wr_data,
         simf0_wr_data, simf1_wr_data, simf2_wr_data, simf3_wr_data, salu_dest_data,
         simd0_wr_mask, simd1_wr_mask, simd2_wr_mask, simd3_wr_mask,
         simf0_wr_mask, simf1_wr_mask, simf2_wr_mask, simf3_wr_mask;

wire issue_alu_wr_done, issue_lsu_instr_done, issue_valu_dest_reg_valid;
wire[3:0] issue_lsu_dest_reg_valid;
wire[1:0] issue_alu_dest_reg_valid;
wire[5:0] issue_alu_wr_done_wfid, issue_lsu_instr_done_wfid;
wire[8:0] issue_alu_dest_reg_addr, issue_lsu_dest_reg_addr, issue_valu_dest_addr;
wire[31:0] lsu_source2_data, simd_rd_data, simf_rd_data;
wire[63:0] salu_source2_data, salu_source1_data;
wire[127:0] lsu_source1_data;

//instantiation of dut
sgpr sgpr(
  .lsu_source1_addr(lsu_source1_addr),
  .lsu_source1_rd_en(lsu_source1_rd_en),
  .lsu_source2_addr(lsu_source2_addr),
  .lsu_source2_rd_en(lsu_source2_rd_en),
  .lsu_dest_addr(lsu_dest_addr),
  .lsu_dest_data(lsu_dest_data),
  .lsu_dest_wr_en(lsu_dest_wr_en),
  .lsu_instr_done_wfid(lsu_instr_done_wfid),
  .lsu_instr_done(lsu_instr_done),
  .simd0_rd_addr(simd0_rd_addr),
  .simd0_rd_en(simd0_rd_en),
  .simd1_rd_addr(simd1_rd_addr),
  .simd1_rd_en(simd1_rd_en),
  .simd2_rd_addr(simd2_rd_addr),
  .simd2_rd_en(simd2_rd_en),
  .simd3_rd_addr(simd3_rd_addr),
  .simd3_rd_en(simd3_rd_en),
  .simd0_wr_addr(simd0_wr_addr),
  .simd0_wr_en(simd0_wr_en),
  .simd0_wr_data(simd0_wr_data),
  .simd0_wr_mask(simd0_wr_mask),
  .simd1_wr_addr(simd1_wr_addr),
  .simd1_wr_en(simd1_wr_en),
  .simd1_wr_data(simd1_wr_data),
  .simd1_wr_mask(simd1_wr_mask),
  .simd2_wr_addr(simd2_wr_addr),
  .simd2_wr_en(simd2_wr_en),
  .simd2_wr_data(simd2_wr_data),
  .simd2_wr_mask(simd2_wr_mask),
  .simd3_wr_addr(simd3_wr_addr),
  .simd3_wr_en(simd3_wr_en),
  .simd3_wr_data(simd3_wr_data),
  .simd3_wr_mask(simd3_wr_mask),
  .simf0_rd_addr(simf0_rd_addr),
  .simf0_rd_en(simf0_rd_en),
  .simf1_rd_addr(simf1_rd_addr),
  .simf1_rd_en(simf1_rd_en),
  .simf2_rd_addr(simf2_rd_addr),
  .simf2_rd_en(simf2_rd_en),
  .simf3_rd_addr(simf3_rd_addr),
  .simf3_rd_en(simf3_rd_en),
  .simf0_wr_addr(simf0_wr_addr),
  .simf0_wr_en(simf0_wr_en),
  .simf0_wr_data(simf0_wr_data),
  .simf0_wr_mask(simf0_wr_mask),
  .simf1_wr_addr(simf1_wr_addr),
  .simf1_wr_en(simf1_wr_en),
  .simf1_wr_data(simf1_wr_data),
  .simf1_wr_mask(simf1_wr_mask),
  .simf2_wr_addr(simf2_wr_addr),
  .simf2_wr_en(simf2_wr_en),
  .simf2_wr_data(simf2_wr_data),
  .simf2_wr_mask(simf2_wr_mask),
  .simf3_wr_addr(simf3_wr_addr),
  .simf3_wr_en(simf3_wr_en),
  .simf3_wr_data(simf3_wr_data),
  .simf3_wr_mask(simf3_wr_mask),
  .salu_dest_data(salu_dest_data),
  .salu_dest_addr(salu_dest_addr),
  .salu_dest_wr_en(salu_dest_wr_en),
  .salu_source2_addr(salu_source2_addr),
  .salu_source2_rd_en(salu_source2_rd_en),
  .salu_source1_addr(salu_source1_addr),
  .salu_source1_rd_en(salu_source1_rd_en),
  .salu_instr_done_wfid(salu_instr_done_wfid),
  .salu_instr_done(salu_instr_done),
  .rfa_select_fu(rfa_select_fu),
  .lsu_source1_data(lsu_source1_data),
  .lsu_source2_data(lsu_source2_data),
  .simd_rd_data(simd_rd_data),
  .simf_rd_data(simf_rd_data),
  .salu_source2_data(salu_source2_data),
  .salu_source1_data(salu_source1_data),
  .issue_alu_wr_done_wfid(issue_alu_wr_done_wfid),
  .issue_alu_wr_done(issue_alu_wr_done),
  .issue_alu_dest_reg_addr(issue_alu_dest_reg_addr),
  .issue_alu_dest_reg_valid(issue_alu_dest_reg_valid),
  .issue_lsu_instr_done_wfid(issue_lsu_instr_done_wfid),
  .issue_lsu_instr_done(issue_lsu_instr_done),
  .issue_lsu_dest_reg_addr(issue_lsu_dest_reg_addr),
  .issue_lsu_dest_reg_valid(issue_lsu_dest_reg_valid),
  .issue_valu_dest_reg_valid(issue_valu_dest_reg_valid),
  .issue_valu_dest_addr(issue_valu_dest_addr),
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
    lsu_dest_wr_en = 4'b0;
    simd0_rd_en = 1'b0;
    simd1_rd_en = 1'b0;
    simd2_rd_en = 1'b0;
    simd3_rd_en = 1'b0;
    simf0_rd_en = 1'b0;
    simf1_rd_en = 1'b0;
    simf2_rd_en = 1'b0;
    simf3_rd_en = 1'b0;
    lsu_source1_rd_en = 1'b0;
    lsu_source2_rd_en = 1'b0;
    salu_source1_rd_en = 1'b0;
    salu_source2_rd_en = 1'b0;
    simd0_wr_en = 1'b0;
    simd1_wr_en = 1'b0;
    simd2_wr_en = 1'b0;
    simd3_wr_en = 1'b0;
    simf0_wr_en = 1'b0;
    simf1_wr_en = 1'b0;
    simf2_wr_en = 1'b0;
    simf3_wr_en = 1'b0;
    salu_dest_wr_en = 1'b0;
    salu_instr_done = 1'b0;
    rfa_select_fu = 16'b0;
    #10 rst = 1'b0;
    #2000;
    $finish;
  end
  initial begin
    #31;
    
    #10 lsu_dest_addr = 9'd50;
    lsu_dest_data = {{96{1'bx}},32'hf0f0_f0f0};
    lsu_dest_wr_en = 4'b0001;

    #10 lsu_dest_wr_en = 4'b0000;
   
    #10 simd3_rd_addr =  9'd50;
    simd3_rd_en = 1'b1;
    rfa_select_fu = 16'h0020; 
    
    #10 rfa_select_fu = 16'h0000;
    simd3_rd_en = 1'b0; 
    salu_dest_addr = 9'd100;
    salu_dest_data = {32'hdead_dead,32'haaaa_a0a0};
    salu_dest_wr_en = 2'b11;

    #10 salu_dest_addr = 9'd103;
    salu_dest_data = {32'hbbbb_bbbb,32'hf0f0_f0f0};
    salu_dest_wr_en = 2'b01;

    #10 salu_dest_addr = 9'd102;
    salu_dest_data = {32'h1234_4321,32'hdead_babe};
    salu_dest_wr_en = 2'b01;
    

    #10 salu_dest_wr_en = 2'b0;

    #10 simf1_rd_addr = 9'd100;
    simf1_rd_en = 1'b1; 
    #10 simf1_rd_addr = 9'd101;
    simf1_rd_en = 1'b1; 
    #10 simf1_rd_addr = 9'd102;
    simf1_rd_en = 1'b1; 
    #10 simf1_rd_addr = 9'd103;
    simf1_rd_en = 1'b1; 

    #10 simf1_rd_en = 1'b0;

    lsu_source1_rd_en = 1'b1;
    lsu_source1_addr = 9'd100;

    #10;
    lsu_source1_addr = 9'd99;

    #10;
    lsu_source1_rd_en = 1'b0;
  end
  //monitors
  initial begin
    if ($test$plusargs("print_outputs")) begin
      $monitor("simd_rd_data output = %x", simd_rd_data);
      $monitor("lsu_source1_data = %x", lsu_source1_data);
    end
  end

  //waveforms
  initial begin
    if ($test$plusargs("dump_waveforms")) begin
      $vcdpluson(0,sgpr_tb);
      //$vcdpluson(<level>,scope,<signal>);
      //Lots of options for dumping waves
      //(both system calls and run time arguments)
      // http://read.pudn.com/downloads97/sourcecode/others/399556/vcs_0123.pdf
    end
  end

endmodule
