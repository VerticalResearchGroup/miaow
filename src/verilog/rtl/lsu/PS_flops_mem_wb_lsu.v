module PS_flops_mem_wb_lsu(
  in_rd_data,
  in_ack,
  in_tag,
  out_rd_data,
  out_ack,
  out_tag,
  clk,
  rst
);

input [8191:0] in_rd_data;
input in_ack;
input [6:0] in_tag;

output [8191:0] out_rd_data;
output out_ack;
output [6:0] out_tag;

input clk;
input rst;

dff flop_rd_data[8191:0](
  .q(out_rd_data),
  .d(in_rd_data),
  .clk(clk),
  .rst(rst)
);

dff flop_ack(
  .q(out_ack),
  .d(in_ack),
  .clk(clk),
  .rst(rst)
);

dff flop_tag[6:0](
  .q(out_tag),
  .d(in_tag),
  .clk(clk),
  .rst(rst)
);

endmodule
