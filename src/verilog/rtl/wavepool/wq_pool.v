module wq_pool (
  q_vtail_incr,
  q_rd,
  q_wr,
  q_reset,
  q_empty,
  stop_fetch,
  instr_pc_in,
  instr_pc_out,
  wf_select,
  clk,
  rst
);

input [39:0] q_vtail_incr;
input [39:0] q_rd;
input [39:0] q_wr;
input [39:0] q_reset;

output [39:0] q_empty;
output [39:0] stop_fetch;

input [63:0] instr_pc_in;
output [63:0] instr_pc_out;

input [5:0] wf_select;
input clk;
input rst;

wire [2559:0] instr_pc_premux;

  wave_queue wf_queue[39:0] (
    .q_vtail_incr(q_vtail_incr),
    .q_rd(q_rd),
    .q_wr(q_wr),
    .q_reset(q_reset),
    .q_empty(q_empty),
    .stop_fetch(stop_fetch),
    .instr_pc_in(instr_pc_in),
    .instr_pc_out(instr_pc_premux),
    .clk(clk),
    .rst(rst)
  );

  mux_40x64b_to_1x64b mux_rd_port (.out(instr_pc_out), .in(instr_pc_premux), .select(wf_select));

endmodule
