module queue_controller (
  q_vtail_incr,
  q_rd,
  q_wr,
  q_reset,
  q_empty,
  stop_fetch,
  buff_rd_addr,
  buff_wr_addr,
  buff_wr_en,
  clk,
  rst
);

input q_vtail_incr;
input q_rd;
input q_wr;
input q_reset;

output q_empty;
output stop_fetch;
output [2:0] buff_rd_addr;
output [2:0] buff_wr_addr;
output buff_wr_en;
input clk;
input rst;

wire [2:0] vtail;
wire [2:0] tail;
wire [2:0] head;

wire [2:0] next_vtail;
wire [2:0] next_tail;
wire [2:0] next_head;
wire [2:0] next_vtail_qualified;
wire [2:0] next_tail_qualified;
wire [2:0] next_head_qualified;

wire [2:0] vtail_plus2;

assign next_vtail_qualified = next_vtail & ~{3{q_reset}};
assign next_tail_qualified = next_tail & ~{3{q_reset}};
assign next_head_qualified = next_head & ~{3{q_reset}};

reg_3b Vtail(.out(vtail), .in(next_vtail_qualified), .wr_en(q_vtail_incr|q_reset), .clk(clk), .rst(rst));
reg_3b Tail(.out(tail), .in(next_tail_qualified), .wr_en(q_wr|q_reset), .clk(clk), .rst(rst));
reg_3b Head(.out(head), .in(next_head_qualified), .wr_en(q_rd|q_reset), .clk(clk), .rst(rst));

adder3bit Vtail_Incr(.sum(next_vtail), .cout(), .in1(vtail), .in2(3'b1));
adder3bit Tail_Incr(.sum(next_tail), .cout(), .in1(tail), .in2(3'b1));
adder3bit Head_Incr(.sum(next_head), .cout(), .in1(head), .in2(3'b1));

adder3bit Vtail_Plus2(.sum(vtail_plus2), .cout(), .in1(vtail), .in2(3'd2));

assign q_empty = (head == tail);
assign stop_fetch = (head == next_vtail) | (head == vtail_plus2);

assign buff_rd_addr = head;
assign buff_wr_addr = tail;
assign buff_wr_en = q_wr;

endmodule
