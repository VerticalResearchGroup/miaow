module simf_tb;

  //wires
  reg clk;

  reg rst;

  reg issue_alu_select, exec_rd_scc_value, rfa_queue_entry_serviced;
  reg [5:0] issue_wfid;
  reg [11:0] issue_source_reg1, issue_source_reg2, issue_source_reg3,
           issue_dest_reg1, issue_dest_reg2;
  reg [15:0] issue_imm_value0;
  reg [31:0] issue_imm_value1, issue_opcode, sgpr_rd_data, exec_rd_m0_value,
           issue_instr_pc;
  reg [63:0] exec_rd_exec_value, exec_rd_vcc_value;
  reg [2047:0] vgpr_source1_data, vgpr_source2_data, vgpr_source3_data;

  wire vgpr_source1_rd_en, vgpr_source2_rd_en, vgpr_source3_rd_en, vgpr_wr_en,
           exec_rd_en, exec_wr_vcc_en, sgpr_rd_en, sgpr_wr_en, issue_alu_ready,
           vgpr_instr_done, rfa_queue_entry_valid;
  wire [5:0] exec_rd_wfid, exec_wr_vcc_wfid, vgpr_instr_done_wfid;
  wire [8:0] sgpr_rd_addr, sgpr_wr_addr;
  wire [9:0] vgpr_source1_addr, vgpr_source2_addr, vgpr_source3_addr,
           vgpr_dest_addr;
  wire [31:0] tracemon_retire_pc;
  wire [63:0] vgpr_wr_mask, exec_wr_vcc_value, sgpr_wr_data;
  wire [2047:0] vgpr_dest_data;

  //instantiation of dut
  simf simf(
         .issue_source_reg1(issue_source_reg1),
         .issue_source_reg2(issue_source_reg2),
         .issue_source_reg3(issue_source_reg3), //TODO implement this.
         .issue_dest_reg1(issue_dest_reg1),
         .issue_dest_reg2(issue_dest_reg2), //TODO implement this
         .issue_imm_value0(issue_imm_value0),
         .issue_imm_value1(issue_imm_value1),
         .issue_opcode(issue_opcode),
         .issue_wfid(issue_wfid),
         .issue_alu_select(issue_alu_select),
         .vgpr_source1_data(vgpr_source1_data),
         .vgpr_source2_data(vgpr_source2_data),
         .vgpr_source3_data(vgpr_source3_data), //TODO implement this
         .sgpr_rd_data(sgpr_rd_data),
         .exec_rd_exec_value(exec_rd_exec_value),
         .exec_rd_vcc_value(exec_rd_vcc_value),
         .exec_rd_m0_value(exec_rd_m0_value), //TODO implement this
         .exec_rd_scc_value(exec_rd_scc_value),
         .issue_instr_pc(issue_instr_pc),
         .rfa_queue_entry_serviced(rfa_queue_entry_serviced),
         .vgpr_source1_rd_en(vgpr_source1_rd_en),
         .vgpr_source2_rd_en(vgpr_source2_rd_en),
         .vgpr_source3_rd_en(vgpr_source3_rd_en), //TODO
         .vgpr_source1_addr(vgpr_source1_addr),
         .vgpr_source2_addr(vgpr_source2_addr),
         .vgpr_source3_addr(vgpr_source3_addr), //TODO implement
         .vgpr_dest_addr(vgpr_dest_addr),
         .vgpr_dest_data(vgpr_dest_data),
         .vgpr_wr_en(vgpr_wr_en),
         .vgpr_wr_mask(vgpr_wr_mask),
         .exec_rd_wfid(exec_rd_wfid),
         .exec_rd_en(exec_rd_en),
         .exec_wr_vcc_wfid(exec_wr_vcc_wfid),
         .exec_wr_vcc_en(exec_wr_vcc_en),
         .exec_wr_vcc_value(exec_wr_vcc_value),
         .sgpr_rd_en(sgpr_rd_en),
         .sgpr_rd_addr(sgpr_rd_addr),
         .sgpr_wr_addr(sgpr_wr_addr), //TODO
         .sgpr_wr_en(sgpr_wr_en), //TODO
         .sgpr_wr_data(sgpr_wr_data), //TODO
         .issue_alu_ready(issue_alu_ready),
         .vgpr_instr_done_wfid(vgpr_instr_done_wfid),
         .vgpr_instr_done(vgpr_instr_done),
         .rfa_queue_entry_valid(rfa_queue_entry_valid),
         .tracemon_retire_pc(tracemon_retire_pc),
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
      issue_alu_select = 1'b0;
      rfa_queue_entry_serviced = 1'b0;

      #10 rst = 1'b0;
      #10000;
    $finish;
  end

   initial begin
      #31;

      $display("ISSUING FLOAT ADD\n");
      issue_source_reg1 = {2'b10,10'd23};
      issue_source_reg2 = {2'b10,10'd27};
      issue_source_reg3 = {32{1'bx}};
      issue_dest_reg1 = {2'b10,10'd31};
      issue_dest_reg2 = {12{1'bx}};
      issue_imm_value0 = {16{1'bx}};
      issue_imm_value1 = {32{1'bx}};

      issue_opcode = {`ALU_VOP2_FORMAT, 12'h0, 12'h003}; //V_ADD_F32
      issue_wfid = 6'd15;
      issue_alu_select = 1'b1;

      sgpr_rd_data = {32{1'bx}};
      exec_rd_exec_value = 64'hf0ff_ffff_ffff_ffff;
      exec_rd_vcc_value = {64{1'bx}};
      exec_rd_m0_value = {32{1'bx}};
      exec_rd_scc_value = 1'bx;
      issue_instr_pc = 32'hdead_f00d;
      rfa_queue_entry_serviced = 1'b0;

      vgpr_source1_data = {64{32'h4205_9999}}; //33.4
      vgpr_source2_data = {64{32'h41B7_3333}}; //22.9
      vgpr_source3_data = {64{32'hx}};

      #10;
      issue_alu_select = 1'b0;

      #1000;
      $display("ISSUING FLOAT SUB\n");
      issue_alu_select = 1'b1;
      issue_wfid = 6'd15;
      issue_source_reg1 = {2'b10,10'd23};
      issue_source_reg2 = {2'b10,10'd27};
      issue_dest_reg1 = {2'b10,10'd31};
      issue_imm_value0 = {32{1'bx}};
      issue_imm_value1 = {16{1'bx}};
      issue_opcode = {`ALU_VOP2_FORMAT, 12'h0, 12'h004}; //V_SUB_F32
      sgpr_rd_data = {32{1'bx}};
      issue_instr_pc = 32'hdead_f00d;
      exec_rd_exec_value = 64'hffff_ffff_ffff_ffff;
      exec_rd_vcc_value = {64{1'bx}};
      vgpr_source1_data = {64{32'h4205_9999}}; //33.4
      vgpr_source2_data = {64{32'h41B7_3333}}; //22.9

      #10;
      issue_alu_select = 1'b0;

      #10;
      rfa_queue_entry_serviced = 1'b1;

      #10;
      rfa_queue_entry_serviced = 1'b0;

      #1000;
      $display("ISSUING FLOAT MUL");
      issue_alu_select = 1'b1;
      issue_wfid = 6'd15;
      issue_source_reg1 = {2'b10,10'd23};
      issue_source_reg2 = {2'b10,10'd27};
      issue_dest_reg1 = {2'b10,10'd31};
      issue_imm_value0 = {32{1'bx}};
      issue_imm_value1 = {16{1'bx}};
      issue_opcode = {`ALU_VOP2_FORMAT, 12'h0, 12'h008}; //V_MUL_F32
      sgpr_rd_data = {32{1'bx}};
      issue_instr_pc = 32'hdead_f00d;
      exec_rd_exec_value = 64'hffff_ffff_ffff_ffff;
      exec_rd_vcc_value = {64{1'bx}};
      vgpr_source1_data = {64{32'h4205_9999}}; //33.4
      vgpr_source2_data = {64{32'h41B7_3333}}; //22.9

      #10;
      issue_alu_select = 1'b0;

      #100;
      if (rfa_queue_entry_valid)
        rfa_queue_entry_serviced = 1'b1;

      #10;
        rfa_queue_entry_serviced = 1'b0;

      #100;
      if (rfa_queue_entry_valid)
        rfa_queue_entry_serviced = 1'b1;

      #10;
      rfa_queue_entry_serviced = 1'b0;
   end

  //monitors
  initial begin
    if ($test$plusargs("print_outputs")) begin
      $monitor($time, ": issue_alu_select = %b, issue_alu_ready = %b \n \
         rfa_queue_entry_serviced = %h, rfa_queue_entry_valid = %h \n \
         vgpr_dest_data = %h",
         issue_alu_select, issue_alu_ready,
         rfa_queue_entry_serviced, rfa_queue_entry_valid,
         vgpr_dest_data[31:0]
         );
     // $monitor("$time:  vgpr_dest_data = %h", vgpr_dest_data);
      //$monitor("$time: rfa_queue_entry_serviced = %b", rfa_queue_entry_serviced);
    end
  end

  //waveforms
  initial begin
    if ($test$plusargs("dump_waveforms")) begin
      $vcdpluson(0,simf_tb);
      //$vcdpluson(<level>,scope,<signal>);
      //Lots of options for dumping waves
      //(both system calls and run time arguments)
      // http://read.pudn.com/downloads97/sourcecode/others/399556/vcs_0123.pdf
    end
  end

endmodule
