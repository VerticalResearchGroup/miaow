module reg_256x32b_3r_1w_fpga
  (/*AUTOARG*/
   // Outputs
   rd0_data, rd1_data, rd2_data,
   // Inputs
   clk, rd0_addr, rd1_addr, rd2_addr, wr0_addr, wr0_en, wr0_data
   );
   input clk;

   output [31:0] rd0_data;
   output [31:0] rd1_data;
   output [31:0] rd2_data;

   input [9:0]   rd0_addr;
   input [9:0]   rd1_addr;
   input [9:0]   rd2_addr;

   input [9:0]   wr0_addr;

   input   wr0_en;

   input [31:0]  wr0_data;

wire [31:0] block_out_a;
wire [31:0] block_out_b;
wire [31:0] block_out_c;

reg wr_en_a;

assign rd0_data = block_out_a;
assign rd1_data = block_out_b;
assign rd2_data = block_out_c;

block_ram bank0(
  .clka(clk), // input clka
  //.rsta(rst), // input rsta
  .wea(wr0_en), // input [3 : 0] wea
  .addra(wr0_addr), // input [31 : 0] addra
  .dina(wr0_data), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(clk), // input clkb
  //.rstb(rst), // input rstb
  .web(1'b0), // input [3 : 0] web
  .addrb(rd0_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(block_out_a) // output [31 : 0] doutb
);

block_ram bank1(
  .clka(clk), // input clka
  //.rsta(rst), // input rsta
  .wea(wr0_en), // input [3 : 0] wea
  .addra(wr0_addr), // input [31 : 0] addra
  .dina(wr0_data), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(clk), // input clkb
  //.rstb(rst), // input rstb
  .web(1'b0), // input [3 : 0] web
  .addrb(rd1_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(block_out_b) // output [31 : 0] doutb
);

block_ram bank2(
  .clka(clk), // input clka
  //.rsta(rst), // input rsta
  .wea(wr0_en), // input [3 : 0] wea
  .addra(wr0_addr), // input [31 : 0] addra
  .dina(wr0_data), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(clk), // input clkb
  //.rstb(rst), // input rstb
  .web(1'b0), // input [3 : 0] web
  .addrb(rd2_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(block_out_c) // output [31 : 0] doutb
);
   
endmodule
