module PS_flops_EX_WB_alu (
 in_wfid,
 in_instr_pc,
 in_vgpr_dest_addr,
 in_sgpr_dest_addr,
 in_instr_done,
 in_vgpr_wr_en,
 in_sgpr_wr_en,
 in_vcc_wr_en,
 out_wfid,
 out_instr_pc,
 out_vgpr_dest_addr,
 out_sgpr_dest_addr,
 out_instr_done,
 out_vgpr_dest_wr_en,
 out_sgpr_dest_wr_en,
 out_vcc_wr_en,
 clk,
 rst
);

input [5:0] in_wfid;
input [31:0] in_instr_pc;
input [9:0] in_vgpr_dest_addr;
input [8:0] in_sgpr_dest_addr;
input in_instr_done;
input in_vgpr_wr_en;
input in_sgpr_wr_en;
input in_vcc_wr_en;

output [5:0] out_wfid;
output [31:0] out_instr_pc;
output [9:0] out_vgpr_dest_addr;
output [8:0] out_sgpr_dest_addr;
output out_instr_done;
output out_vgpr_dest_wr_en;
output out_sgpr_dest_wr_en;
output out_vcc_wr_en;

input clk;
input rst;

dff flop_wfid[5:0] (.q(out_wfid), .d(in_wfid), .clk(clk), .rst(rst));
dff flop_instr_pc[31:0] (.q(out_instr_pc), .d(in_instr_pc), .clk(clk), .rst(rst));
dff flop_vgpr_dest_addr[9:0] (.q(out_vgpr_dest_addr), .d(in_vgpr_dest_addr), .clk(clk), .rst(rst));
dff flop_sgpr_dest_addr[8:0] (.q(out_sgpr_dest_addr), .d(in_sgpr_dest_addr), .clk(clk), .rst(rst));
dff flop_instr_done (.q(out_instr_done), .d(in_instr_done), .clk(clk), .rst(rst));
dff flop_vgpr_wr_en (.q(out_vgpr_dest_wr_en), .d(in_vgpr_wr_en), .clk(clk), .rst(rst));
dff flop_sgpr_wr_en (.q(out_sgpr_dest_wr_en), .d(in_sgpr_wr_en), .clk(clk), .rst(rst));
dff flop_vcc_wr_en (.q(out_vcc_wr_en), .d(in_vcc_wr_en), .clk(clk), .rst(rst));

endmodule
