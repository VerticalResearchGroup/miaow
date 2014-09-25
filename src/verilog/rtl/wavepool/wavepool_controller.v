module wavepool_controller (
  buff_wfid,
  buff_first,
  buff_ack,
  q_wr,
  reserve_slotid,
  reserve_valid,
  q_vtail_incr,
  halt_wfid,
  wf_halt,
  branch_wfid,
  branch_en,
  branch_taken,
  q_reset,
  feed_wfid,
  feed_valid,
  q_rd,
  valid_wf,
  decode_wfid,
  decode_instr_valid,
  clk,
  rst
);

input [5:0] buff_wfid;
input buff_first;
input buff_ack;
output [39:0] q_wr;

input [5:0] reserve_slotid;
input reserve_valid;
output [39:0] q_vtail_incr;

input [5:0] halt_wfid;
input wf_halt;
input [5:0] branch_wfid;
input branch_en;
input branch_taken;
output [39:0] q_reset;

input [5:0] feed_wfid;
input feed_valid;
output [39:0] q_rd;

output [39:0] valid_wf;

output [5:0] decode_wfid;
output decode_instr_valid;

input clk;
input rst;

wire [39:0] next_valid_wf;
wire [39:0] valid_wf;
wire [39:0] temp_q_wr;
wire [39:0] temp_q_vtail_incr;
wire [39:0] halt_temp_q_reset;
wire [39:0] branch_temp_q_reset;
wire [39:0] temp_q_rd;
wire branch_taken_en;

reg_40b valid_wavefront(.out(valid_wf), .in(next_valid_wf), .wr_en(1'b1), .clk(clk), .rst(rst));
assign next_valid_wf = (valid_wf | ((temp_q_wr & {40{buff_ack}}) & {40{buff_first}})) & (~q_reset);

decoder_6_to_40 dec_q_wr(.out(temp_q_wr), .in(buff_wfid));
assign q_wr = (temp_q_wr & {40{buff_ack}}) & ({40{buff_first}} | valid_wf);

decoder_6_to_40 dec_q_vtail_incr(.out(temp_q_vtail_incr), .in(reserve_slotid));
assign q_vtail_incr = temp_q_vtail_incr & {40{reserve_valid}};

decoder_6_to_40 dec_q_reset_halt(.out(halt_temp_q_reset), .in(halt_wfid));
decoder_6_to_40 dec_q_reset_branch(.out(branch_temp_q_reset), .in(branch_wfid));
assign branch_taken_en = branch_taken & branch_en;
assign q_reset = (halt_temp_q_reset & {40{wf_halt}}) | (branch_temp_q_reset & {40{branch_taken_en}});

decoder_6_to_40 dec_q_rd(.out(temp_q_rd), .in(feed_wfid));
assign q_rd = temp_q_rd & {40{feed_valid}};

assign decode_wfid = feed_wfid;
assign decode_instr_valid = feed_valid;

endmodule
