`define IDLE       3'b000
`define STATE_RD   3'b001
`define STATE_EX1  3'b010
`define STATE_EX2  3'b011
`define STATE_EX3  3'b100
`define STATE_EX4  3'b101

module alu_fsm (
 in_alu_select,
 out_alu_start,
 in_valu_done,
 out_alu_ready,
 RD,
 EX,
 WB,
 clk,
 rst
);

input in_alu_select;
input in_valu_done;

output out_alu_start;
output out_alu_ready;
output RD;
output EX;
output WB;

input clk;
input rst;

reg out_alu_ready;
reg RD;
reg WB;
reg [2:0] next_state;
reg next_EX;
reg next_alu_start;

wire [2:0] current_state;

dff state_flop[2:0] (.q(current_state), .d(next_state), .clk(clk), .rst(rst));
dff EX_flop (.q(EX), .d(next_EX), .clk(clk), .rst(rst));
dff alu_start_flop (.q(out_alu_start), .d(next_alu_start), .clk(clk), .rst(rst));

always @ (current_state or in_alu_select or in_valu_done) begin
	casex({current_state, in_alu_select, in_valu_done})
		{`IDLE, 1'b0, 1'b0} :
			begin
				next_state <= `IDLE;
				out_alu_ready <= 1'b1;
				RD <= 1'b0;
				next_EX <= 1'b0;
				next_alu_start <= 1'b0;
				WB <= 1'b0;
			end
		{`IDLE, 1'b1, 1'b0} :
			begin
				next_state <= `STATE_EX1;
				out_alu_ready <= 1'b0;
				RD <= 1'b1;
				next_EX <= 1'b1;
				next_alu_start <= 1'b1;
				WB <= 1'b0;
			end
		{`STATE_RD, 1'b0, 1'b?} :
			begin
				next_state <= `STATE_EX1;
				out_alu_ready <= 1'b0;
				RD <= 1'b0;
				next_EX <= 1'b1;
				next_alu_start <= 1'b0;
				WB <= 1'b0;
			end
		{`STATE_EX1, 1'b0, 1'b0} :
			begin
				next_state <= `STATE_EX1;
				out_alu_ready <= 1'b0;
				RD <= 1'b0;
				next_EX <= 1'b1;
				next_alu_start <= 1'b0;
				WB <= 1'b0;
			end
		{`STATE_EX1, 1'b0, 1'b1} :
			begin
				next_state <= `STATE_EX2;
				out_alu_ready <= 1'b0;
				RD <= 1'b0;
				next_EX <= 1'b1;
				next_alu_start <= 1'b1;
				WB <= 1'b0;
			end
		{`STATE_EX2, 1'b0, 1'b0} :
			begin
				next_state <= `STATE_EX2;
				out_alu_ready <= 1'b0;
				RD <= 1'b0;
				next_EX <= 1'b1;
				next_alu_start <= 1'b0;
				WB <= 1'b0;
			end
		{`STATE_EX2, 1'b0, 1'b1} :
			begin
				next_state <= `STATE_EX3;
				out_alu_ready <= 1'b0;
				RD <= 1'b0;
				next_EX <= 1'b1;
				next_alu_start <= 1'b1;
				WB <= 1'b0;
			end
		{`STATE_EX3, 1'b0, 1'b0} :
			begin
				next_state <= `STATE_EX3;
				out_alu_ready <= 1'b0;
				RD <= 1'b0;
				next_EX <= 1'b1;
				next_alu_start <= 1'b0;
				WB <= 1'b0;
			end
		{`STATE_EX3, 1'b0, 1'b1} :
			begin
				next_state <= `STATE_EX4;
				out_alu_ready <= 1'b0;
				RD <= 1'b0;
				next_EX <= 1'b1;
				next_alu_start <= 1'b1;
				WB <= 1'b0;
			end
		{`STATE_EX4, 1'b0, 1'b0} :
			begin
				next_state <= `STATE_EX4;
				out_alu_ready <= 1'b0;
				RD <= 1'b0;
				next_EX <= 1'b1;
				next_alu_start <= 1'b0;
				WB <= 1'b0;
			end
		{`STATE_EX4, 1'b0, 1'b1} :
			begin
				next_state <= `IDLE;
				out_alu_ready <= 1'b1;
				RD <= 1'b0;
				next_EX <= 1'b0;
				next_alu_start <= 1'b0;
				WB <= 1'b1;
			end
		default :
			begin
				next_state <= 3'bxxx;
				out_alu_ready <= 1'bx;
				RD <= 1'bx;
				next_EX <= 1'bx;
				next_alu_start <= 1'bx;
				WB <= 1'bx;
			end
	endcase
end

endmodule
