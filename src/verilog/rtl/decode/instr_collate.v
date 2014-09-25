module instr_collate (
  in_wfid,
  in_instr,
  in_valid,
  in_pc,
  out_instr,
  out_valid,
  out_pc,
  in_long,
  out_long,
  clk,
  rst
);

input [5:0] in_wfid;
input [31:0] in_instr;
input in_valid;
input [31:0] in_pc;

output [63:0] out_instr;
output out_valid;
output [31:0] out_pc;

input in_long;
output out_long;

input clk;
input rst;

wire [31:0] stored_instr;
wire [31:0] stored_pc;

reg_40xX_1r_1w #(64) reg_instr_pc (
 .rd_addr(in_wfid),
 .rd_data({stored_instr,stored_pc}),
 .wr_en(in_long&in_valid),
 .wr_addr(in_wfid),
 .wr_data({in_instr,in_pc}),
 .clk(clk),
 .rst(rst)
);

reg_40xX_1r_1w #(1) reg_valid (
 .rd_addr(in_wfid),
 .rd_data(out_long),
 .wr_en(in_valid),
 .wr_addr(in_wfid),
 .wr_data(in_long),
 .clk(clk),
 .rst(rst)
);

assign out_instr = out_long ? {in_instr,stored_instr} : {32'b0,in_instr};
assign out_pc = out_long ? stored_pc : in_pc;
assign out_valid = in_valid & (~in_long);

endmodule
