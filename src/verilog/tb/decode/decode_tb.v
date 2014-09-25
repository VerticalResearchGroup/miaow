module decode_tb;
  
  //wires
reg clk;

reg rst;

reg wave_instr_valid;
reg[5:0] wave_wfid;
reg[8:0] wave_sgpr_base;
reg[9:0] wave_vgpr_base;
reg[15:0] wave_lds_base;
reg[31:0] wave_instr_pc, wave_instr;

wire issue_wf_halt, issue_valid, issue_vcc_wr, issue_vcc_rd, issue_scc_wr,
         issue_scc_rd, issue_exec_rd, issue_exec_wr, issue_m0_rd, issue_m0_wr,
         issue_barrier, issue_branch, issue_waitcnt, wave_ins_half_rqd, tracemon_colldone;
wire[1:0] issue_fu;
wire[5:0] issue_wfid, wave_ins_half_wfid;
wire[15:0] issue_lds_base;
wire[12:0] issue_source_reg2, issue_source_reg3, issue_dest_reg2;
wire[13:0] issue_source_reg1, issue_source_reg4, issue_dest_reg1;
wire[15:0] issue_imm_value0;
wire[31:0] issue_opcode, issue_imm_value1, issue_instr_pc;
wire[63:0] tracemon_collinstr;

  //instantiation of dut
  decode decode0(
  .wave_instr_pc(wave_instr_pc),
  .wave_instr_valid(wave_instr_valid),
  .wave_instr(wave_instr),
  .wave_wfid(wave_wfid),
  .wave_vgpr_base(wave_vgpr_base),
  .wave_sgpr_base(wave_sgpr_base),
  .wave_lds_base(wave_lds_base),
  .issue_fu(issue_fu),
  .issue_wfid(issue_wfid),
  .issue_opcode(issue_opcode),
  .issue_source_reg1(issue_source_reg1),
  .issue_source_reg2(issue_source_reg2),
  .issue_source_reg3(issue_source_reg3),
  .issue_source_reg4(issue_source_reg4),
  .issue_dest_reg1(issue_dest_reg1),
  .issue_dest_reg2(issue_dest_reg2),
  .issue_imm_value0(issue_imm_value0),
  .issue_imm_value1(issue_imm_value1),
  .issue_valid(issue_valid),
  .issue_instr_pc(issue_instr_pc),
  .issue_vcc_wr(issue_vcc_wr),
  .issue_vcc_rd(issue_vcc_rd),
  .issue_scc_wr(issue_scc_wr),
  .issue_scc_rd(issue_scc_rd),
  .issue_exec_rd(issue_exec_rd),
  .issue_exec_wr(issue_exec_wr),
  .issue_m0_rd(issue_m0_rd),
  .issue_m0_wr(issue_m0_wr),
  .issue_wf_halt(issue_wf_halt),
  .issue_barrier(issue_barrier),
  .issue_branch(issue_branch),
  .issue_waitcnt(issue_waitcnt),
  .issue_lds_base(issue_lds_base),
  .wave_ins_half_wfid(wave_ins_half_wfid),
  .wave_ins_half_rqd(wave_ins_half_rqd),
  .tracemon_collinstr(tracemon_collinstr),
  .tracemon_colldone(tracemon_colldone),
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
    wave_instr_valid = 1'b0;
    #10 rst = 1'b0;
    #2000;
    $finish;
  end
  initial begin
    #41;
    //Test1: SOP1
    wave_instr_valid = 1'b1;
    wave_wfid = 6'd37;
    wave_instr_pc = 32'hcafe_0000;
    wave_sgpr_base = 9'd256;
    wave_vgpr_base = 10'd512;
    wave_lds_base = {16{1'bx}};
    wave_instr = 32'b101111101_0000010_00000111_00000111;
    //              /SOP1-----/SDST7--/OP------/SSRC8---/

    #10;
    wave_instr_valid = 1'b0;
    #10;
    
    //Test2: SOP1 with literal constant
    wave_instr_valid = 1'b1;
    wave_wfid = 6'd37;
    wave_instr_pc = 32'hcafe_0000;
    wave_sgpr_base = 9'd256;
    wave_vgpr_base = 10'd512;
    wave_lds_base = {16{1'bx}};
    wave_instr = 32'b101111101_0000010_00000111_11111111;
    //              /SOP1-----/SDST7--/OP------/SSRC8---/
    #10;
    wave_instr_valid = 1'b0;
    #50;
    wave_instr_valid = 1'b1;
    wave_wfid = 6'd37;
    wave_instr_pc = 32'hcafe_0000;
    wave_sgpr_base = 9'd256;
    wave_vgpr_base = 10'd512;
    wave_lds_base = {16{1'bx}};
    wave_instr = 32'b101111101_0000010_00000111_00000111;
    //This is just a literal constant

    #10;
    wave_instr_valid = 1'b0;
    #10;



    //Test3: MTBUF
    wave_instr_valid = 1'b1;
    wave_wfid = 6'd27;
    wave_instr_pc = 32'hcafe_f00d;
    wave_sgpr_base = 9'd256;
    wave_vgpr_base = 10'd512;
    wave_lds_base = {16{1'bx}};
    wave_instr = 32'b111010_xxxxxxx_100_xx11_110011001100;
    //              /MTBUF-/?------/OP3/flag/OFFSET12----/
    //MTBUF - 1st word
    #10;
    wave_instr_valid = 1'b0;
    #10;
    wave_instr_valid = 1'b1;
    wave_wfid = 6'd27;
    wave_instr_pc = 32'hcafe_f011;
    wave_sgpr_base = 9'd256;
    wave_vgpr_base = 10'd512;
    wave_lds_base = {16{1'bx}};
    wave_instr = 32'b00110011_xxx_11111_00001111_11110000;
    //              /SOFFSET8/flg/srsc5/VDATA8--/VADDR8--/
    //MTBUF - 2nd word
    
    //Test4: SOPP (halt)
    #10;
    wave_instr_valid = 1'b0;
    #10;
    wave_instr_valid = 1'b1;
    wave_wfid = 6'd0;
    wave_instr_pc = 32'hdead_babe;
    wave_sgpr_base = 9'd256;
    wave_vgpr_base = 10'd512;
    wave_lds_base = {16{1'bx}};
    wave_instr = 32'b101111111_0000001_xxxxxxxxxxxxxxxx;
    //              /SOPP-----/OP7----/SIMM16----------/
    //halt

    #10;
    wave_instr_valid = 1'b0;
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
      $vcdpluson(0,decode_tb);
      //$vcdpluson(<level>,scope,<signal>);
      //Lots of options for dumping waves
      //(both system calls and run time arguments)
      // http://read.pudn.com/downloads97/sourcecode/others/399556/vcs_0123.pdf
    end
  end

endmodule
