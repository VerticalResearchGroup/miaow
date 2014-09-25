module reg_64page_1024x32b_3r_1w_fpga 
  (/*AUTOARG*/
   // Outputs
   rd0_data, rd1_data, rd2_data,
   // Inputs
   rd0_addr, rd1_addr, rd2_addr, wr0_addr, wr0_en, wr0_en_xoutof4,
   wr0_data, clk, clk_double
   );

   output [8191:0] rd0_data;
   output [2047:0] rd1_data;
   output [2047:0] rd2_data;

   input [9:0] 	   rd0_addr;
   input [9:0] 	   rd1_addr;
   input [9:0] 	   rd2_addr;

   input [9:0] 	   wr0_addr;

   input [63:0]    wr0_en;
   input [3:0] 	   wr0_en_xoutof4;


   input [8191:0]  wr0_data;

   input 	   clk;
   input clk_double;

   //wire [255:0]    effective_wr0_en;

reg [63:0] block_we;
reg [31:0] block_addr_a;
reg [31:0] block_addr_b;
wire [31:0] block_addr_c;

assign block_addr_c = {rd2_addr, 2'd0};

always @ (*)  begin
  if(clk) begin
    block_we <= 64'd0;
    block_addr_a <= {rd0_addr, 2'd0};
    block_addr_b <= {rd1_addr, 2'd0};
  end
  else begin
    block_we <= wr0_en;
    block_addr_a <= {wr0_addr, 2'd0};
  end
end

genvar index;

generate
for(index = 0; index < 64; index = index + 1) begin : block_ram_banks
  block_ram bank0
  (
    .clka(clk_double), // input clka
    //.rsta(rst), // input rsta
    .wea({4{block_we[index]}}), // input [3 : 0] wea
    .addra(block_addr_a), // input [31 : 0] addra
    .dina(wr0_data[(31 + (index * 128)):(index * 128)]), // input [31 : 0] dina
    .douta(rd0_data[31 + (index * 128):index * 128]), // output [31 : 0] douta
    .clkb(clk_double), // input clkb
    //.rstb(rst), // input rstb
    .web(4'd0), // input [3 : 0] web
    .addrb(block_addr_b), // input [31 : 0] addrb
    .dinb(32'd0), // input [31 : 0] dinb
    .doutb(rd1_data[31 + (index * 32):index * 32]) // output [31 : 0] doutb
  );
  
  block_ram bank1
  (
    .clka(clk_double), // input clka
    //.rsta(rst), // input rsta
    .wea(4'd0), // input [3 : 0] wea
    .addra(block_addr_c), // input [31 : 0] addra
    .dina(32'd0), // input [31 : 0] dina
    .douta(rd2_data[31 + (index * 32):index * 32]), // output [31 : 0] douta
    .clkb(clk_double), // input clkb
    //.rstb(rst), // input rstb
    .web({4{block_we[index]}}), // input [3 : 0] web
    .addrb(block_addr_a), // input [31 : 0] addrb
    .dinb(wr0_data[(31 + (index * 128)):(index * 128)]), // input [31 : 0] dinb
    .doutb() // output [31 : 0] doutb
  );
end
endgenerate

endmodule
