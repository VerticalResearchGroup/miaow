module ds_addr_calc (
 lds_base,
 in_addr,
 out_addr
);

input [15:0] lds_base;
input [31:0] in_addr;
output [31:0] out_addr;

assign out_addr = {16'b0,lds_base} + in_addr;

endmodule 

