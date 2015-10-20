module reg_128x32b_3r_2w_fpga
(/*AUTOARG*/
   // Outputs
   rd0_data, rd1_data, rd2_data,
   // Inputs
   clk, rd0_addr, rd1_addr, rd2_addr, wr0_addr, wr1_addr, wr0_en,
   wr1_en, wr0_data, wr1_data
   );
input clk;

output [31:0] rd0_data;
output [31:0] rd1_data;
output [31:0] rd2_data;

input [6:0] rd0_addr;
input [6:0] rd1_addr;
input [6:0] rd2_addr;

input [6:0] wr0_addr;
input [6:0] wr1_addr;

input wr0_en;
input wr1_en;

input [31:0] wr0_data;
input [31:0] wr1_data;

wire [6:0] wr_addr;
wire [9:0] wr_addr_blk;
wire wr_en;
wire [31:0] wr_data;

wire [9:0] rd0_addr_blk;
wire [9:0] rd1_addr_blk;
wire [9:0] rd2_addr_blk;

assign rd0_addr_blk = {3'b000, rd0_addr};
assign rd1_addr_blk = {3'b000, rd1_addr};
assign rd2_addr_blk = {3'b000, rd2_addr};

assign wr_data = wr1_en ? wr1_data : wr0_data;
assign wr_addr = wr1_en ? wr1_addr : wr0_addr;
assign wr_addr_blk = {3'b000, wr_addr};
assign wr_en = wr0_en | wr1_en;

block_ram bank0(
  .clka(clk), // input clka
  //.rsta(rst), // input rsta
  .wea(wr_en), // input [3 : 0] wea
  .addra(wr_addr_blk), // input [31 : 0] addra
  .dina(wr_data), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(clk), // input clkb
  //.rstb(rst), // input rstb
  .web(1'b0), // input [3 : 0] web
  .addrb(rd0_addr_blk), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(rd0_data) // output [31 : 0] doutb
);

block_ram bank1(
  .clka(clk), // input clka
  //.rsta(rst), // input rsta
  .wea(wr_en), // input [3 : 0] wea
  .addra(wr_addr_blk), // input [31 : 0] addra
  .dina(wr_data), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(clk), // input clkb
  //.rstb(rst), // input rstb
  .web(1'b0), // input [3 : 0] web
  .addrb(rd1_addr_blk), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(rd1_data) // output [31 : 0] doutb
);

block_ram bank2(
  .clka(clk), // input clka
  //.rsta(rst), // input rsta
  .wea(wr_en), // input [3 : 0] wea
  .addra(wr_addr_blk), // input [31 : 0] addra
  .dina(wr_data), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(clk), // input clkb
  //.rstb(rst), // input rstb
  .web(1'b0), // input [3 : 0] web
  .addrb(rd2_addr_blk), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(rd2_data) // output [31 : 0] doutb
);

endmodule
