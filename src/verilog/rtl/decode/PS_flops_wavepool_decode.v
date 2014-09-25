module PS_flops_wavepool_decode (
 wave_instr_pc,
 wave_instr_valid,
 wave_instr,
 wave_wfid,
 wave_vgpr_base,
 wave_sgpr_base,
 wave_lds_base,
 flopped_instr_pc,
 flopped_instr_valid,
 flopped_instr,
 flopped_wfid,
 flopped_vgpr_base,
 flopped_sgpr_base,
 flopped_lds_base,
 clk,
 rst
);

input clk;
input rst;

input [31:0] wave_instr_pc;
input wave_instr_valid;
input [31:0] wave_instr;
input [5:0] wave_wfid;
input [9:0] wave_vgpr_base;
input [8:0] wave_sgpr_base;
input [15:0] wave_lds_base;

output [31:0] flopped_instr_pc;
output flopped_instr_valid;
output [31:0] flopped_instr;
output [5:0] flopped_wfid;
output [9:0] flopped_vgpr_base;
output [8:0] flopped_sgpr_base;
output [15:0] flopped_lds_base;

dff flop_instr_pc [31:0] (.q(flopped_instr_pc), .d(wave_instr_pc), .clk(clk), .rst(rst));
dff flop_instr_valid (.q(flopped_instr_valid), .d(wave_instr_valid), .clk(clk), .rst(rst));
dff flop_instr [31:0] (.q(flopped_instr), .d(wave_instr), .clk(clk), .rst(rst));
dff flop_wfid [5:0] (.q(flopped_wfid), .d(wave_wfid), .clk(clk), .rst(rst));
dff flop_vgpr_base [9:0] (.q(flopped_vgpr_base), .d(wave_vgpr_base), .clk(clk), .rst(rst));
dff flop_sgpr_base [8:0] (.q(flopped_sgpr_base), .d(wave_sgpr_base), .clk(clk), .rst(rst));
dff flop_lds_base [15:0] (.q(flopped_lds_base), .d(wave_lds_base), .clk(clk), .rst(rst));

endmodule
