module scbd_feeder(
  valid_wf,
  ins_half_reqd,
  ins_half_wfid,
  issue_vacant,
  q_empty,
  q_reset,
  feed_valid,
  feed_wfid,
  clk,
  rst
);

input [39:0] valid_wf;

input ins_half_reqd;
input [5:0] ins_half_wfid;
input [39:0] issue_vacant;
input [39:0] q_empty;
input [39:0] q_reset;

output feed_valid;
output [5:0] feed_wfid;


input clk;
input rst;

wire [39:0] ins_half_reqd_bitwise;
wire [39:0] selected_instr_bitwise;
wire [39:0] hungry;
wire [39:0] next_hungry;
wire [39:0] sb_candidates;

decoder_6_to_40 ins_half_dec(.out(ins_half_reqd_bitwise), .in(ins_half_wfid));

assign next_hungry = (issue_vacant | (ins_half_reqd_bitwise & {40{ins_half_reqd}}) | q_reset | hungry) & (~ ({40{feed_valid}} & selected_instr_bitwise));

reg_40b_set scbd_hungry(.out(hungry), .in(next_hungry), .wr_en(1'b1), .clk(clk), .set(rst));

assign sb_candidates = hungry & (~ q_empty) & valid_wf;

priority_encoder_40to6 select_enc(.binary_out(feed_wfid), .valid(feed_valid), .encoder_in(sb_candidates), .enable(1'b1));

decoder_6_to_40 update_dec(.out(selected_instr_bitwise), .in(feed_wfid));

endmodule
