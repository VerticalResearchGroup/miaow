module reg_128x32b_3r_2w_fpga
(/*AUTOARG*/
   // Outputs
   rd0_data, rd1_data, rd2_data,
   // Inputs
   clk, rd0_addr, rd1_addr, rd2_addr, wr0_addr, wr1_addr, wr0_en,
   wr1_en, wr0_data, wr1_data
   ,clk_double
   );
input clk;
input clk_double;

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

reg [31:0] converted_port_a_address;
reg [31:0] converted_port_b_address;
reg [31:0] converted_port_c_address;
wire [31:0] converted_port_d_address;

reg [3:0] wr_en_a;
reg [3:0] wr_en_b;

wire [31:0] block_out_a;
wire [31:0] block_out_b;
wire [31:0] block_out_c;

assign converted_port_d_address = {wr1_addr, 2'b0};

always @(*) begin
  if(wr0_en) begin
    converted_port_a_address <= {wr0_addr, 2'b0};
    converted_port_c_address <= {wr0_addr, 2'b0};
    wr_en_a <= {4{wr0_en}};
  end
  else begin
    converted_port_a_address <= {rd0_addr, 2'b0};
    converted_port_c_address <= {rd2_addr, 2'b0};
    wr_en_a <= 4'd0;
  end
  
  if(wr1_en) begin
    converted_port_b_address <= {wr1_addr, 2'b0};
    wr_en_b <= {4{wr1_en}};
  end
  else begin
    converted_port_b_address <= {rd1_addr, 2'b0};
    wr_en_b <= 4'd0;
  end
end

assign rd0_data = block_out_a;
assign rd1_data = block_out_b;
assign rd2_data = block_out_c;

block_ram bank0(
  .clka(clk), // input clka
  //.rsta(rst), // input rsta
  .wea(wr_en_a), // input [3 : 0] wea
  .addra(converted_port_a_address), // input [31 : 0] addra
  .dina(wr0_data), // input [31 : 0] dina
  .douta(block_out_a), // output [31 : 0] douta
  .clkb(clk), // input clkb
  //.rstb(rst), // input rstb
  .web(wr_en_b), // input [3 : 0] web
  .addrb(converted_port_b_address), // input [31 : 0] addrb
  .dinb(wr1_data), // input [31 : 0] dinb
  .doutb(block_out_b) // output [31 : 0] doutb
);

block_ram bank1(
  .clka(clk), // input clka
  //.rsta(rst), // input rsta
  .wea(wr_en_a), // input [3 : 0] wea
  .addra(converted_port_c_address), // input [31 : 0] addra
  .dina(wr0_data), // input [31 : 0] dina
  .douta(block_out_c), // output [31 : 0] douta
  .clkb(clk), // input clkb
  //.rstb(rst), // input rstb
  .web(wr_en_b), // input [3 : 0] web
  .addrb(converted_port_d_address), // input [31 : 0] addrb
  .dinb(wr1_data), // input [31 : 0] dinb
  .doutb() // output [31 : 0] doutb
);

endmodule
