module simd(
      issue_source_reg1,
      issue_source_reg2,
      issue_source_reg3,
      issue_dest_reg1,
      issue_dest_reg2,
      issue_imm_value0,
      issue_imm_value1,
      issue_opcode,
      issue_wfid,
      issue_alu_select,
      vgpr_source1_data,
      vgpr_source2_data,
      vgpr_source3_data,
      sgpr_rd_data,
      exec_rd_exec_value,
      exec_rd_vcc_value,
      exec_rd_m0_value,
      exec_rd_scc_value,
      issue_instr_pc,
      rfa_queue_entry_serviced,
      vgpr_source1_rd_en,
      vgpr_source2_rd_en,
      vgpr_source3_rd_en,
      vgpr_source1_addr,
      vgpr_source2_addr,
      vgpr_source3_addr,
      vgpr_dest_addr,
      vgpr_dest_data,
      vgpr_wr_en,
      vgpr_wr_mask,
      exec_rd_wfid,
      exec_rd_en,
      exec_wr_vcc_wfid,
      exec_wr_vcc_en,
      exec_wr_vcc_value,
      sgpr_rd_en,
      sgpr_rd_addr,
      sgpr_wr_addr,
      sgpr_wr_en,
      sgpr_wr_data,
      sgpr_wr_mask,
      issue_alu_ready,
      vgpr_instr_done_wfid,
      vgpr_instr_done,
      rfa_queue_entry_valid,
      tracemon_retire_pc,
      clk,
      rst
 );

input clk;

input rst;

input issue_alu_select, exec_rd_scc_value, rfa_queue_entry_serviced;
input[5:0] issue_wfid;
input[11:0] issue_source_reg1, issue_source_reg2, issue_source_reg3,
         issue_dest_reg1, issue_dest_reg2;
input[15:0] issue_imm_value0;
input[31:0] issue_imm_value1, issue_opcode, sgpr_rd_data, exec_rd_m0_value,
         issue_instr_pc;
input[63:0] exec_rd_exec_value, exec_rd_vcc_value;
input[2047:0] vgpr_source1_data, vgpr_source2_data, vgpr_source3_data;

output vgpr_source1_rd_en, vgpr_source2_rd_en, vgpr_source3_rd_en, vgpr_wr_en,
         exec_rd_en, exec_wr_vcc_en, sgpr_rd_en, sgpr_wr_en, issue_alu_ready,
         vgpr_instr_done, rfa_queue_entry_valid;
output[5:0] exec_rd_wfid, exec_wr_vcc_wfid, vgpr_instr_done_wfid;
output[8:0] sgpr_rd_addr, sgpr_wr_addr;
output[9:0] vgpr_source1_addr, vgpr_source2_addr, vgpr_source3_addr,
         vgpr_dest_addr;
output[31:0] tracemon_retire_pc;
output[63:0] vgpr_wr_mask, exec_wr_vcc_value, sgpr_wr_data, sgpr_wr_mask;
output[2047:0] vgpr_dest_data;

alu #(.MODULE(`MODULE_SIMD))
      alu(
      .issue_source_reg1(issue_source_reg1),
      .issue_source_reg2(issue_source_reg2),
      .issue_source_reg3(issue_source_reg3),
      .issue_dest_reg1(issue_dest_reg1),
      .issue_dest_reg2(issue_dest_reg2),
      .issue_imm_value0(issue_imm_value0),
      .issue_imm_value1(issue_imm_value1),
      .issue_opcode(issue_opcode),
      .issue_wfid(issue_wfid),
      .issue_alu_select(issue_alu_select),
      .vgpr_source1_data(vgpr_source1_data),
      .vgpr_source2_data(vgpr_source2_data),
      .vgpr_source3_data(vgpr_source3_data),
      .sgpr_rd_data(sgpr_rd_data),
      .exec_rd_exec_value(exec_rd_exec_value),
      .exec_rd_vcc_value(exec_rd_vcc_value),
      .exec_rd_m0_value(exec_rd_m0_value),
      .exec_rd_scc_value(exec_rd_scc_value),
      .issue_instr_pc(issue_instr_pc),
      .rfa_queue_entry_serviced(rfa_queue_entry_serviced),
      .vgpr_source1_rd_en(vgpr_source1_rd_en),
      .vgpr_source2_rd_en(vgpr_source2_rd_en),
      .vgpr_source3_rd_en(vgpr_source3_rd_en),
      .vgpr_source1_addr(vgpr_source1_addr),
      .vgpr_source2_addr(vgpr_source2_addr),
      .vgpr_source3_addr(vgpr_source3_addr),
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
      .sgpr_wr_addr(sgpr_wr_addr),
      .sgpr_wr_en(sgpr_wr_en),
      .sgpr_wr_data(sgpr_wr_data),
      .sgpr_wr_mask(sgpr_wr_mask),
      .issue_alu_ready(issue_alu_ready),
      .vgpr_instr_done_wfid(vgpr_instr_done_wfid),
      .vgpr_instr_done(vgpr_instr_done),
      .rfa_queue_entry_valid(rfa_queue_entry_valid),
      .tracemon_retire_pc(tracemon_retire_pc),
      .clk(clk),
      .rst(rst)
 );
endmodule
