//rd0 - 128/64/32 bits wide (can be unaligned)
//rd1 - 32 bits wide
//rd2 - 32 bits wide

//wr0 - 128/64/32 bits wide (4 bit enable) (can be unaligned)

module reg_1024x32b_3r_1w (/*AUTOARG*/
			   // Outputs
			   rd0_data, rd1_data, rd2_data,
			   // Inputs
			   rd0_addr, rd1_addr, rd2_addr, wr0_addr, wr0_en, wr0_data, clk
			   );

   //innitial test will only include all 32b ops
   //keep 128 bit bus for future
   output [31:0]  rd0_data;
   output [31:0]  rd1_data;
   output [31:0]  rd2_data;

   //10 bit addr -> 1024 locations
   input [9:0] 	  rd0_addr;
   input [9:0] 	  rd1_addr;
   input [9:0] 	  rd2_addr;

   input [9:0] 	  wr0_addr;
   input [3:0] 	  wr0_en; //extern 4 bit enable [legacy--4 bits determined vector length]
   input [31:0]   wr0_data;

   input 	  clk;

   reg [31:0] 		      rd0_data;
   reg [31:0] 		      rd1_data;
   reg [31:0] 		      rd2_data;
   wire [31:0] 		      rd0_data_bank0;

   wire [9:0] 	  rd0_addr_last;
   wire [9:0] 	  rd1_addr_last;
   wire [9:0] 	  rd2_addr_last;

   dff rd_addr_data_path_delay[10+10+10-1:0]
     (.q({rd0_addr_last, rd1_addr_last, rd2_addr_last}),
      .d({rd0_addr, rd1_addr, rd2_addr}),
      .clk(clk),
      .rst(1'b0));

   // Rd data path
   always @(rd0_addr_last or rd0_data_bank0)//or rd0_data_bank1 or rd0_data_bank2 or rd0_data_bank3)
     begin
	//rd0_data <= {{96{1'b0}},rd0_data_bank0};
	// S: change to 32b line
	rd0_data <= rd0_data_bank0;
     end

   wire [31:0] rd1_data_bank0;
   always @(rd1_addr_last or rd1_data_bank0)// or rd1_data_bank1 or rd1_data_bank2 or rd1_data_bank3)
     begin
	rd1_data <= rd1_data_bank0;
     end

   wire [31:0] rd2_data_bank0;

   always @(rd2_addr_last or rd2_data_bank0)// or rd2_data_bank1 or rd2_data_bank2 or rd2_data_bank3)
     begin

	rd2_data <= rd2_data_bank0;

     end
`ifdef FPGA_BUILD
  reg_256x32b_3r_1w_fpga
`else
  reg_256x32b_3r_1w
`endif
   bank0(
    .rd0_addr(rd0_addr),
    .rd0_data(rd0_data_bank0),
    .rd1_addr(rd1_addr),
    .rd1_data(rd1_data_bank0),
    .rd2_addr(rd2_addr),
    .rd2_data(rd2_data_bank0),
    .wr0_addr(wr0_addr), //connect write address straight in
    .wr0_en(wr0_en[0]|wr0_en[1]|wr0_en[2]|wr0_en[3]),  //only focus on 32b, so only enable if bottom bit active high
    .wr0_data(wr0_data[31:0]),
    .clk(clk)
  );

endmodule
