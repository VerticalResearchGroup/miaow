// DO NOT USE THIS, THIS IS A PLACEHOLDER FOR A XILINX IP CORE BLOCK RAM

module block_ram
(
  clka,
  wea,
  addra,
  dina,
  douta,
  clkb,
  web,
  addrb,
  dinb,
  doutb
);

input clka, clkb;
input [3:0] wea, web;
input [31:0] addra, addrb, dina, dinb;
output [31:0] douta, doutb;

endmodule
