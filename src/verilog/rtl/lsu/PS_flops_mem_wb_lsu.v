module PS_flops_mem_wb_lsu(
  in_rd_data,
  in_ack,
  in_tag,
  out_rd_data,
  out_ack,
  out_tag,
  clk,
  rst,
  shift_wb,
  load_wb
);

input [31:0] in_rd_data;
input in_ack;
input [6:0] in_tag;
input shift_wb, load_wb;

output [2047:0] out_rd_data;
output out_ack;
output [6:0] out_tag;

input clk;
input rst;

reg [2047:0] flop_rd_data;
always @(posedge clk, posedge rst) begin
  if(rst) begin
    flop_rd_data <= 0;
  end
  // else if(shift_wb) begin
    
  // end
  else if(load_wb) begin
    flop_rd_data[2047:2016] <= in_rd_data;
    flop_rd_data[2015:0] <= flop_rd_data[2047:32];
  end
end
assign out_rd_data = flop_rd_data;

// dff flop_rd_data[8191:0](
//   .q(out_rd_data),
//   .d(in_rd_data),
//   .clk(clk),
//   .rst(rst)
// );

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
