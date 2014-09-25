module salu_tb();

reg clk;
reg rst;
reg issue_alu_select, exec_rd_scc_value;
reg[5:0] issue_wfid;
reg[11:0] issue_source_reg1, issue_source_reg2, issue_dest_reg;
reg[15:0] issue_imm_value;
reg[31:0] exec_rd_m0_value, issue_instr_pc, issue_opcode;
reg[63:0] sgpr_source2_data, sgpr_source1_data,
            exec_rd_exec_value, exec_rd_vcc_value;

wire exec_wr_exec_en, exec_wr_vcc_en, exec_wr_m0_en, exec_wr_scc_en,
         exec_wr_scc_value, exec_rd_en, issue_alu_ready, sgpr_instr_done,
         fetchwaveissue_branch_en, fetchwaveissue_branch_taken,
         tracemon_exec_word_sel, tracemon_vcc_word_sel;
wire [1:0] sgpr_dest_wr_en;
wire[5:0] exec_wr_wfid, exec_rd_wfid, sgpr_instr_done_wfid,
            fetchwaveissue_branch_wfid;
wire[8:0] sgpr_dest_addr, sgpr_source2_addr, sgpr_source1_addr;
wire[31:0] exec_wr_m0_value, fetch_branch_pc_value, tracemon_retire_pc;
wire[63:0] exec_wr_exec_value, exec_wr_vcc_value, sgpr_dest_data;

salu salu_dut(
      issue_source_reg1,
      issue_source_reg2,
      issue_dest_reg,
      issue_imm_value,
      issue_opcode,
      issue_wfid,
      issue_alu_select,
      exec_rd_exec_value,
      exec_rd_vcc_value,
      exec_rd_m0_value,
      exec_rd_scc_value,
      sgpr_source2_data,
      sgpr_source1_data,
      issue_instr_pc,
      exec_wr_exec_en,
      exec_wr_vcc_en,
      exec_wr_m0_en,
      exec_wr_scc_en,
      exec_wr_exec_value,
      exec_wr_vcc_value,
      exec_wr_m0_value,
      exec_wr_scc_value,
      exec_wr_wfid,
      exec_rd_en,
      exec_rd_wfid,
      sgpr_dest_data,
      sgpr_dest_addr,
      sgpr_dest_wr_en,
      sgpr_source2_addr,
      sgpr_source1_addr,
      issue_alu_ready,
      sgpr_instr_done_wfid,
      sgpr_instr_done,
      fetchwaveissue_branch_wfid,
      fetchwaveissue_branch_en,
      fetchwaveissue_branch_taken,
      fetch_branch_pc_value,
      tracemon_retire_pc,
      tracemon_exec_word_sel,
      tracemon_vcc_word_sel,
      clk,
      rst
 );

 initial
begin
 clk = 0;
 #1 rst = 1;
 #30 rst = 0;

end

initial begin
  while (1) begin
     #5;
     clk = ~clk;
  end
end

initial begin
      issue_alu_select   = 1'b0;
      issue_source_reg1  = 12'd0;
      issue_source_reg2  = 12'd0;
      issue_dest_reg     = 12'd0;
      issue_imm_value    = 16'd0;
      issue_opcode       = 16'd0;
      issue_wfid         = 6'd0;
      exec_rd_exec_value = 64'd0;
      exec_rd_vcc_value  = 64'd0;
      sgpr_source2_data  = 32'd0;
      sgpr_source1_data  = 32'd0;
	issue_instr_pc     = 32'd0;

// salu 32 op with reg
#40;
      issue_source_reg1  = 12'b110000000001;
      issue_source_reg2  = 12'b110000000010;
      issue_dest_reg     = 12'b110000000110;
      issue_imm_value    = 16'd0;
      issue_opcode       = 32'h08000002;
      issue_wfid         = 6'd2;
      issue_alu_select   = 1'b1;
      exec_rd_exec_value = 64'h8888888844444444;
      exec_rd_vcc_value  = 64'h2222222211111111;
      sgpr_source2_data  = 64'hxxxxxxxx00001106;
      sgpr_source1_data  = 64'hxxxxxxxx00000102;
	issue_instr_pc     = 32'd64;

// salu 64 op with reg
#10;
      issue_source_reg1  = 12'b110000000001;
      issue_source_reg2  = 12'b110000000010;
      issue_dest_reg     = 12'b110000000110;
      issue_imm_value    = 16'd0;
      issue_opcode       = 32'h0800000F;
      issue_wfid         = 6'd2;
      issue_alu_select   = 1'b1;
      exec_rd_exec_value = 64'h8888888844444444;
      exec_rd_vcc_value  = 64'h2222222211111111;
      sgpr_source2_data  = 64'h7777777700001106;
      sgpr_source1_data  = 64'h6666666600000102;
      issue_instr_pc     = 32'd64;

// salu op with exec and vcc
#10;
      issue_source_reg1  = 12'b111000000001;
      issue_source_reg2  = 12'b111000000010;
      issue_dest_reg     = 12'b111000001000;
      issue_imm_value    = 16'd0;
      issue_opcode       = 32'h08000007;
      issue_wfid         = 6'd2;
      issue_alu_select   = 1'b1;
      exec_rd_exec_value = 64'h8888888844444444;
      exec_rd_vcc_value  = 64'h2222222211111111;
      sgpr_source2_data  = 64'h7777777700001106;
      sgpr_source1_data  = 64'h6666666600000102;
      issue_instr_pc     = 32'd64;

// branch
#10;
      issue_source_reg1  = 12'b111000000001;
      issue_source_reg2  = 12'b111000000010;
      issue_dest_reg     = 12'b011000001000;
      issue_imm_value    = 16'd10;
      issue_opcode       = 32'h01000002;
      issue_wfid         = 6'd2;
      issue_alu_select   = 1'b1;
      exec_rd_exec_value = 64'h8888888844444444;
      exec_rd_vcc_value  = 64'h2222222211111111;
      sgpr_source2_data  = 64'h7777777700001106;
      sgpr_source1_data  = 64'h6666666600000102;
      issue_instr_pc     = 32'd64;

// branch on vccz
#10;
      issue_source_reg1  = 12'b111000000001;
      issue_source_reg2  = 12'b111000000010;
      issue_dest_reg     = 12'b011000001000;
      issue_imm_value    = 16'd10;
      issue_opcode       = 32'h01000006;
      issue_wfid         = 6'd2;
      issue_alu_select   = 1'b1;
      exec_rd_exec_value = 64'h8888888844444444;
      exec_rd_vcc_value  = 64'h0000000000000000;
      sgpr_source2_data  = 64'h7777777700001106;
      sgpr_source1_data  = 64'h6666666600000102;
      issue_instr_pc     = 32'd64;

#10;
      issue_alu_select   = 1'b0;
end

initial begin
      #150;
      $finish;
end

always@(posedge clk)
begin
      if(sgpr_dest_wr_en)
            $display("SGPR: TIME: %g SGPR_DEST_EN = %b SGPR_DONE_WFID: %h SGPR_DST_REG: %h SGPR_DST_DATA: %h RETIRE_PC: %h",
                  $time, sgpr_dest_wr_en, sgpr_instr_done_wfid,
                  sgpr_dest_addr, sgpr_dest_data, tracemon_retire_pc);
      if(exec_wr_scc_en)
            $display("SCC : TIME: %g SCC_WR_EN = %b SCC_WR_WFID: %h SCC_VALUE: %b RETIRE_PC: %h",
                  $time, exec_wr_scc_en, exec_wr_wfid,
                  exec_wr_scc_value, tracemon_retire_pc);
      if(exec_wr_exec_en)
            $display("EXEC: TIME: %g EXEC_WR_EN = %b EXEC_WR_WFID: %h EXEC_VALUE: %h RETIRE_PC: %h",
                  $time, exec_wr_exec_en, exec_wr_wfid,
                  exec_wr_exec_value, tracemon_retire_pc);
      if(exec_wr_vcc_en)
            $display("VCC : TIME: %g VCC_WR_EN = %b VCC_WR_WFID: %h VCC_VALUE: %h RETIRE_PC: %h",
                  $time, exec_wr_vcc_en, exec_wr_wfid,
                  exec_wr_vcc_value, tracemon_retire_pc);
      if(fetchwaveissue_branch_en)
            $display("BRH : TIME: %g BRANCH_EN = %b BRANCH_TK = %b BRANCH_WFID: %h NEW_PC: %h RETIRE_PC: %h",
                  $time, fetchwaveissue_branch_en, fetchwaveissue_branch_taken,
                  fetchwaveissue_branch_wfid, fetch_branch_pc_value, tracemon_retire_pc);

      if(sgpr_dest_wr_en | exec_wr_scc_en | exec_wr_exec_en |
            exec_wr_vcc_en | fetchwaveissue_branch_en)
            $display("");
end

endmodule