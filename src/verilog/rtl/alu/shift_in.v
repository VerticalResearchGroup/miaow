module shift_in (
 data_in,
 wr_en,
 shift_en,
 data_out,
 clk,
 rst
);

parameter WIDTH=1;

input [(64*WIDTH)-1:0] data_in;
input wr_en;
input shift_en;
output [(16*WIDTH)-1:0] data_out;
input clk;
input rst;

wire [(64*WIDTH)-1:0] reg_in;
wire [(64*WIDTH)-1:0] reg_out;
reg line_wr_en;
reg s_or_w_;

always @ (shift_en or wr_en)
begin
  casex({shift_en,wr_en})
    2'b00:
      begin
        line_wr_en <= 1'b0;
        s_or_w_ <= 1'bx;
      end
    2'b01:
      begin
        line_wr_en <= 1'b1;
        s_or_w_ <= 1'b0;
      end
    2'b10:
      begin
        line_wr_en <= 1'b1;
        s_or_w_ <= 1'b1;
      end
    default:
      begin
        line_wr_en <= 1'bx;
        s_or_w_ <= 1'bx;
      end
  endcase
end

register #(WIDTH*16) reg_line[3:0](.out(reg_out), .in(reg_in), .wr_en(line_wr_en), .clk(clk), .rst(rst));

mux_2_to_1 #(WIDTH*16) line3_mux(.out(reg_in[(WIDTH*64)-1:(WIDTH*48)]), .in({{WIDTH*16{1'bx}},data_in[(WIDTH*64)-1:(WIDTH*48)]}), .select(s_or_w_));
mux_2_to_1 #(WIDTH*16) line2_mux(.out(reg_in[(WIDTH*48)-1:(WIDTH*32)]), .in({reg_out[(WIDTH*64)-1:WIDTH*48],data_in[(WIDTH*48)-1:(WIDTH*32)]}), .select(s_or_w_));
mux_2_to_1 #(WIDTH*16) line1_mux(.out(reg_in[(WIDTH*32)-1:(WIDTH*16)]), .in({reg_out[(WIDTH*48)-1:WIDTH*32],data_in[(WIDTH*32)-1:(WIDTH*16)]}), .select(s_or_w_));
mux_2_to_1 #(WIDTH*16) line0_mux(.out(reg_in[(WIDTH*16)-1:0]), .in({reg_out[(WIDTH*32)-1:WIDTH*16],data_in[(WIDTH*16)-1:0]}), .select(s_or_w_));

assign data_out = reg_out[(WIDTH*16)-1:0];

endmodule
