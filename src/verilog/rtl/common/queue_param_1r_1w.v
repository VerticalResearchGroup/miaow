module queue_param_1r_1w(
                        in_wr_en,
                        in_wr_addr,
                        in_wr_data,
                        in_rd_addr,
                        out_rd_data,
                        clk,
                        rst
                        );

   parameter BITS = 2;
   parameter SIZE = 4;
   parameter WIDTH = 32;

   input in_wr_en;
   input [BITS - 1:0] in_wr_addr;
   input [WIDTH - 1:0] in_wr_data;
   input [BITS - 1:0] in_rd_addr;

   output [WIDTH - 1:0] out_rd_data;
   input clk;
   input rst;

   wire [(SIZE * WIDTH) - 1:0] word_out;
   wire [SIZE - 1:0] wr_word_select;
   wire [SIZE - 1:0] wr_en_word;

   mux_param #(.BITS(BITS), .SIZE(SIZE), .WIDTH(WIDTH)) mux_rd_port (.out(out_rd_data), .in(word_out), .select(in_rd_addr));
   decoder_param #(.BITS(BITS), .SIZE(SIZE)) decoder_wr_port (.out(wr_word_select), .in(in_wr_addr));
   assign wr_en_word = {SIZE{in_wr_en}} & wr_word_select;

   reg_param #(.WIDTH(WIDTH)) word[SIZE - 1:0] (.out(word_out), .in(in_wr_data), .wr_en(wr_en_word), .clk(clk), .rst(rst));

endmodule
