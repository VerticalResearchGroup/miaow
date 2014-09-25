module lsu_transit_table(
  in_wftag_resp,
  in_wfid,
  in_lddst_stsrc_addr,
  in_exec_value,
  in_gm_or_lds,
  in_rd_en,
  in_wr_en,
  in_instr_pc,
  out_exec_value,
  out_gm_or_lds,
  out_lddst_stsrc_addr,
  out_reg_wr_en,
  out_instr_pc,
  clk,
  rst
);

input [6:0] in_wftag_resp;
input [5:0] in_wfid;

input [11:0] in_lddst_stsrc_addr;
input [63:0] in_exec_value;
input in_gm_or_lds;
input [3:0] in_rd_en;
input [3:0] in_wr_en;
input [31:0] in_instr_pc;

output [63:0] out_exec_value;
output out_gm_or_lds;
output [11:0] out_lddst_stsrc_addr;
output [3:0] out_reg_wr_en;
output [31:0] out_instr_pc;

input clk;
input rst;

wire enable;
assign enable = |{in_rd_en,in_wr_en};

reg_40xX_1r_1w #(12) lddst_stsrc_addr(
  .rd_addr(in_wftag_resp[6:1]),
  .rd_data(out_lddst_stsrc_addr),
  .wr_en(enable),
  .wr_addr(in_wfid),
  .wr_data(in_lddst_stsrc_addr),
  .clk(clk),
  .rst(rst)
);

reg_40xX_1r_1w #(64) exec_value(
  .rd_addr(in_wftag_resp[6:1]),
  .rd_data(out_exec_value),
  .wr_en(enable),
  .wr_addr(in_wfid),
  .wr_data(in_exec_value),
  .clk(clk),
  .rst(rst)
);

reg_40xX_1r_1w #(1) gm_or_lds(
  .rd_addr(in_wftag_resp[6:1]),
  .rd_data(out_gm_or_lds),
  .wr_en(enable),
  .wr_addr(in_wfid),
  .wr_data(in_gm_or_lds),
  .clk(clk),
  .rst(rst)
);

reg_40xX_1r_1w #(32) instr_pc(
  .rd_addr(in_wftag_resp[6:1]),
  .rd_data(out_instr_pc),
  .wr_en(enable),
  .wr_addr(in_wfid),
  .wr_data(in_instr_pc),
  .clk(clk),
  .rst(rst)
);

reg_40xX_1r_1w #(4) register_wr_en(
  .rd_addr(in_wftag_resp[6:1]),
  //.rd_data(reg_wr_en),
  .rd_data(out_reg_wr_en),
  .wr_en(enable),
  .wr_addr(in_wfid),
  .wr_data(in_rd_en),
  .clk(clk),
  .rst(rst)
);

endmodule
