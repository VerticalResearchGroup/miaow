module PS_flops_issue_alu (/*AUTOARG*/
   // Outputs
   out_alu_select, out_wfid, out_instr_pc, out_opcode, out_imm_value0,
   out_imm_value1, out_dest1_addr, out_dest2_addr,
   // Inputs
   in_alu_select, in_wfid, in_instr_pc, in_opcode, in_imm_value0,
   in_imm_value1, in_dest1_addr, in_dest2_addr, clk, rst
   );

input in_alu_select;
input [5:0] in_wfid;
input [31:0] in_instr_pc;
input [31:0] in_opcode;
input [15:0] in_imm_value0;
input [31:0] in_imm_value1;
input [11:0] in_dest1_addr;
input [11:0] in_dest2_addr;

output out_alu_select;
output [5:0]  out_wfid;
output [31:0] out_instr_pc;
output [31:0] out_opcode;
output [15:0] out_imm_value0;
output [31:0] out_imm_value1;
output [11:0] out_dest1_addr;
output [11:0] out_dest2_addr;

input clk;
input rst;

dff_en flop_alu_select (.q(out_alu_select), .d(in_alu_select), .en(1'b1), .clk(clk), .rst(rst));
dff_en flop_wfid[5:0] (.q(out_wfid), .d(in_wfid), .en(in_alu_select), .clk(clk), .rst(rst));
dff_en flop_instr_pc[31:0] (.q(out_instr_pc), .d(in_instr_pc), .en(in_alu_select), .clk(clk), .rst(rst));
dff_en flop_opcode[31:0] (.q(out_opcode), .d(in_opcode), .en(in_alu_select), .clk(clk), .rst(rst));
dff_en flop_imm_value0[15:0] (.q(out_imm_value0), .d(in_imm_value0), .en(in_alu_select), .clk(clk), .rst(rst));
dff_en flop_imm_value1[31:0] (.q(out_imm_value1), .d(in_imm_value1), .en(in_alu_select), .clk(clk), .rst(rst));
dff_en flop_dest1_addr[11:0] (.q(out_dest1_addr), .d(in_dest1_addr), .en(in_alu_select), .clk(clk), .rst(rst));
dff_en flop_dest2_addr[11:0] (.q(out_dest2_addr), .d(in_dest2_addr), .en(in_alu_select), .clk(clk), .rst(rst));

endmodule
