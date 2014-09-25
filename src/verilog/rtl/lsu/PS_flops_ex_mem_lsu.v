module PS_flops_ex_mem_lsu(
  in_mem_wr_data,
  in_rd_en,
  in_wr_en,
  in_ld_st_addr,
  in_mem_tag,
  in_exec_value,
  in_gm_or_lds,
  out_mem_wr_data,
  out_rd_en,
  out_wr_en,
  out_ld_st_addr,
  out_mem_tag,
  out_exec_value,
  out_gm_or_lds,
  clk,
  rst
);

input [8191:0] in_mem_wr_data;
input [3:0] in_rd_en;
input [3:0] in_wr_en;
input [2047:0] in_ld_st_addr;
input [6:0] in_mem_tag;
input [63:0] in_exec_value;
input in_gm_or_lds;

output [8191:0] out_mem_wr_data;
output [3:0] out_rd_en;
output [3:0] out_wr_en;
output [2047:0] out_ld_st_addr;
output [6:0] out_mem_tag;
output [63:0] out_exec_value;
output out_gm_or_lds;

input clk;
input rst;

dff flop_mem_wr_data[8191:0](
  .q(out_mem_wr_data),
  .d(in_mem_wr_data),
  .clk(clk),
  .rst(rst)
);

dff flop_rd_en[3:0](
  .q(out_rd_en),
  .d(in_rd_en),
  .clk(clk),
  .rst(rst)
);

dff flop_wr_en[3:0](
  .q(out_wr_en),
  .d(in_wr_en),
  .clk(clk),
  .rst(rst)
);

dff flop_ld_st_addr[2047:0](
  .q(out_ld_st_addr),
  .d(in_ld_st_addr),
  .clk(clk),
  .rst(rst)
);

dff flop_mem_tag[6:0](
  .q(out_mem_tag),
  .d(in_mem_tag),
  .clk(clk),
  .rst(rst)
);

dff flop_exec_value[63:0](
  .q(out_exec_value),
  .d(in_exec_value),
  .clk(clk),
  .rst(rst)
);

dff flop_gm_or_lds(
  .q(out_gm_or_lds),
  .d(in_gm_or_lds),
  .clk(clk),
  .rst(rst)
);

endmodule
