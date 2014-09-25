module wave_queue (
  q_vtail_incr,
  q_rd,
  q_wr,
  q_reset,
  q_empty,
  stop_fetch,
  instr_pc_in,
  instr_pc_out,
  clk,
  rst
);

input q_vtail_incr;
input q_rd;
input q_wr;
input q_reset;

output q_empty;
output stop_fetch;

input [63:0] instr_pc_in;
output [63:0] instr_pc_out;

input clk;
input rst;

wire [2:0] buff_rd_addr;
wire [2:0] buff_wr_addr;
wire  buff_wr_en;

queue_controller q_cntrl (
  .q_vtail_incr(q_vtail_incr),
  .q_rd(q_rd),
  .q_wr(q_wr),
  .q_reset(q_reset),
  .q_empty(q_empty),
  .stop_fetch(stop_fetch),
  .buff_rd_addr(buff_rd_addr),
  .buff_wr_addr(buff_wr_addr),
  .buff_wr_en(buff_wr_en),
  .clk(clk),
  .rst(rst)
);

reg_8x64b_1r_1w q_buff(
  .rd_addr(buff_rd_addr),
  .rd_data(instr_pc_out),
  .wr_en(buff_wr_en),
  .wr_addr(buff_wr_addr),
  .wr_data(instr_pc_in),
  .clk(clk),
  .rst(rst)
);

endmodule  
