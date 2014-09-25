module PS_flops_fetch_wavepool (
 buff_tag,
 buff_instr,
 buff_ack,
 flopped_buff_wfid,
 flopped_buff_instr_pc,
 flopped_buff_first,
 flopped_buff_ack,
 clk,
 rst
);

input [38:0] buff_tag;
input [31:0] buff_instr;
input buff_ack;
output [5:0] flopped_buff_wfid;
output [63:0] flopped_buff_instr_pc;
output flopped_buff_first;
output flopped_buff_ack;
input clk;
input rst;

dff flop_wfid[5:0] (.q(flopped_buff_wfid), .d(buff_tag[37:32]), .clk(clk), .rst(rst));
dff flop_instr_pc[63:0] (.q(flopped_buff_instr_pc), .d({buff_instr,buff_tag[31:0]}), .clk(clk), .rst(rst));
dff flop_first (.q(flopped_buff_first), .d(buff_tag[38]), .clk(clk), .rst(rst));
dff flop_ack (.q(flopped_buff_ack), .d(buff_ack), .clk(clk), .rst(rst));

endmodule
