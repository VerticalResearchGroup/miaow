module shift_out (
 data_in,
 wr_en,
 shift_en,
 data_out,
 clk,
 rst
);

parameter WIDTH=1;

input [(16*WIDTH)-1:0] data_in;
input wr_en;
input shift_en;
output [(64*WIDTH)-1:0] data_out;
input clk;
input rst;

wire [(64*WIDTH)-1:0] reg_in;
wire [3:0] line_wr_en;

assign reg_in[(WIDTH*16)-1:0] = data_out[(WIDTH*32)-1:(WIDTH*16)];
assign reg_in[(WIDTH*32)-1:(WIDTH*16)] = data_out[(WIDTH*48)-1:(WIDTH*32)];
assign reg_in[(WIDTH*48)-1:(WIDTH*32)] = data_out[(WIDTH*64)-1:(WIDTH*48)];
assign reg_in[(WIDTH*64)-1:(WIDTH*48)] = data_in;

assign line_wr_en[0:0] = wr_en;
assign line_wr_en[3:1] = {3{shift_en}};

register #(WIDTH*16) reg_line[3:0](.out(data_out), .in(reg_in), .wr_en(line_wr_en), .clk(clk), .rst(rst));

endmodule
