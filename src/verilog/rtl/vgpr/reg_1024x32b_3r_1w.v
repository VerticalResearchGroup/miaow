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

   output [127:0] rd0_data;
   output [31:0]  rd1_data;
   output [31:0]  rd2_data;

   input [9:0] 	  rd0_addr;
   input [9:0] 	  rd1_addr;
   input [9:0] 	  rd2_addr;

   input [9:0] 	  wr0_addr;
   input [3:0] 	  wr0_en;
   input [127:0]  wr0_data;

   input 	  clk;

   /////////////////////////////////////////
		  reg [127:0] rd0_data;
   reg [31:0] 		      rd1_data;
   reg [31:0] 		      rd2_data;

   /////////////////////////////////////////
			      //Muxing for rd0

   wire [9:0] 		      rd0_addr_plus1;
   wire [9:0] 		      rd0_addr_plus2;
   wire [9:0] 		      rd0_addr_plus3;
   assign rd0_addr_plus1 = rd0_addr + 1'b1;
   assign rd0_addr_plus2 = rd0_addr + 2'b10;
   assign rd0_addr_plus3 = rd0_addr + 2'b11;
   wire [31:0] 		      rd0_data_bank0;
   wire [31:0] 		      rd0_data_bank1;
   wire [31:0] 		      rd0_data_bank2;
   wire [31:0] 		      rd0_data_bank3;
   reg [7:0] 		      rd0_addr_bank0;
   reg [7:0] 		      rd0_addr_bank1;
   reg [7:0] 		      rd0_addr_bank2;
   reg [7:0] 		      rd0_addr_bank3;

   wire [9:0] 	  rd0_addr_last;
   wire [9:0] 	  rd1_addr_last;
   wire [9:0] 	  rd2_addr_last;

   dff rd_addr_data_path_delay[10+10+10-1:0]
     (.q({rd0_addr_last, rd1_addr_last, rd2_addr_last}),
      .d({rd0_addr, rd1_addr, rd2_addr}),
      .clk(clk),
      .rst(1'b0));
   
   
   //Bank distribution for 128/64/32 bit read port
   // Address path
   always @(rd0_addr or rd0_addr_plus1 or rd0_addr_plus2 or rd0_addr_plus3)
     begin
	casex(rd0_addr[1:0])
	  2'b00:
	    begin
               rd0_addr_bank0 <= rd0_addr[9:2];
               rd0_addr_bank1 <= rd0_addr_plus1[9:2];
               rd0_addr_bank2 <= rd0_addr_plus2[9:2];
               rd0_addr_bank3 <= rd0_addr_plus3[9:2];
	    end
	  2'b01:
	    begin
               rd0_addr_bank0 <= rd0_addr_plus3[9:2];
               rd0_addr_bank1 <= rd0_addr[9:2];
               rd0_addr_bank2 <= rd0_addr_plus1[9:2];
               rd0_addr_bank3 <= rd0_addr_plus2[9:2];
	    end
	  2'b10:
	    begin
               rd0_addr_bank0 <= rd0_addr_plus2[9:2];
               rd0_addr_bank1 <= rd0_addr_plus3[9:2];
               rd0_addr_bank2 <= rd0_addr[9:2];
               rd0_addr_bank3 <= rd0_addr_plus1[9:2];
	    end
	  2'b11:
	    begin
               rd0_addr_bank0 <= rd0_addr_plus1[9:2];
               rd0_addr_bank1 <= rd0_addr_plus2[9:2];
               rd0_addr_bank2 <= rd0_addr_plus3[9:2];
               rd0_addr_bank3 <= rd0_addr[9:2];
	    end
	  default:
	    begin
               rd0_addr_bank0 <= {8{1'bx}};
               rd0_addr_bank1 <= {8{1'bx}};
               rd0_addr_bank2 <= {8{1'bx}};
               rd0_addr_bank3 <= {8{1'bx}};
	    end
	endcase
     end // always @ (rd0_addr or rd0_addr_plus1 or rd0_addr_plus2 or rd0_addr_plus3...

   // Rd data path
   always @(rd0_addr_last or rd0_data_bank0 or rd0_data_bank1 or 
	    rd0_data_bank2 or rd0_data_bank3)
     begin
	casex(rd0_addr_last[1:0])
	  2'b00:
	    begin
               rd0_data <= {rd0_data_bank3,rd0_data_bank2,
			    rd0_data_bank1,rd0_data_bank0};
	    end
	  2'b01:
	    begin
               rd0_data <= {rd0_data_bank0,rd0_data_bank3,
			    rd0_data_bank2,rd0_data_bank1};
	    end
	  2'b10:
	    begin
               rd0_data <= {rd0_data_bank1,rd0_data_bank0,
			    rd0_data_bank3,rd0_data_bank2};
	    end
	  2'b11:
	    begin
               rd0_data <= {rd0_data_bank2,rd0_data_bank1,
			    rd0_data_bank0,rd0_data_bank3};
	    end
	  default:
	    begin
               rd0_data <= {128{1'bx}};
	    end
	endcase
     end
   
   /////////////////////////////////////////
   //Muxing for rd1
   wire [31:0] rd1_data_bank0;
   wire [31:0] rd1_data_bank1;
   wire [31:0] rd1_data_bank2;
   wire [31:0] rd1_data_bank3;
   always @(rd1_addr_last or rd1_data_bank0 or rd1_data_bank1 or 
	    rd1_data_bank2 or rd1_data_bank3)
     begin
	casex(rd1_addr_last[1:0])
	  2'b00:
	    begin
               rd1_data <= rd1_data_bank0;
	    end
	  2'b01:
	    begin
               rd1_data <= rd1_data_bank1;
	    end
	  2'b10:
	    begin
               rd1_data <= rd1_data_bank2;
	    end
	  2'b11:
	    begin
               rd1_data <= rd1_data_bank3;
	    end
	  default:
	    begin
               rd1_data <= {32{1'bx}};
	    end
	endcase
     end
   /////////////////////////////////////////
   //Muxing for rd2

   wire [31:0] rd2_data_bank0;
   wire [31:0] rd2_data_bank1;
   wire [31:0] rd2_data_bank2;
   wire [31:0] rd2_data_bank3;
   always @(rd2_addr_last or rd2_data_bank0 or rd2_data_bank1 or 
	    rd2_data_bank2 or rd2_data_bank3)
     begin
	casex(rd2_addr_last[1:0])
	  2'b00:
	    begin
               rd2_data <= rd2_data_bank0;
	    end
	  2'b01:
	    begin
               rd2_data <= rd2_data_bank1;
	    end
	  2'b10:
	    begin
               rd2_data <= rd2_data_bank2;
	    end
	  2'b11:
	    begin
               rd2_data <= rd2_data_bank3;
	    end
	  default:
	    begin
               rd2_data <= {32{1'bx}};
	    end
	endcase
     end
   /////////////////////////////////////////
   //Muxing for wr1

   reg [3:0] wr0_en_internal;
   reg 	     wr0_en_bank0;
   reg 	     wr0_en_bank1;
   reg 	     wr0_en_bank2;
   reg 	     wr0_en_bank3;
   reg [7:0] wr0_addr_bank0;
   reg [7:0] wr0_addr_bank1;
   reg [7:0] wr0_addr_bank2;
   reg [7:0] wr0_addr_bank3;
   reg [31:0] wr0_data_bank0;
   reg [31:0] wr0_data_bank1;
   reg [31:0] wr0_data_bank2;
   reg [31:0] wr0_data_bank3;
   wire [9:0] wr0_addr_plus1;
   wire [9:0] wr0_addr_plus2;
   wire [9:0] wr0_addr_plus3;
   assign wr0_addr_plus1 = wr0_addr + 1'b1;
   assign wr0_addr_plus2 = wr0_addr + 2'b10;
   assign wr0_addr_plus3 = wr0_addr + 2'b11;

   always @(wr0_addr or wr0_addr_plus1 or wr0_addr_plus2 or wr0_addr_plus3 or wr0_data)
     begin
	casex(wr0_addr[1:0])
	  2'b00:
	    begin
	       wr0_addr_bank0 <= wr0_addr[9:2];
	       wr0_addr_bank1 <= wr0_addr_plus1[9:2];
	       wr0_addr_bank2 <= wr0_addr_plus2[9:2];
	       wr0_addr_bank3 <= wr0_addr_plus3[9:2];
	       wr0_data_bank0 <= wr0_data[31:0];
	       wr0_data_bank1 <= wr0_data[63:32];
	       wr0_data_bank2 <= wr0_data[95:64];
	       wr0_data_bank3 <= wr0_data[127:96];
	       wr0_en_internal <= 4'b0001;
	    end
	  2'b01:
	    begin
	       wr0_addr_bank0 <= wr0_addr_plus3[9:2];
	       wr0_addr_bank1 <= wr0_addr[9:2];
	       wr0_addr_bank2 <= wr0_addr_plus1[9:2];
	       wr0_addr_bank3 <= wr0_addr_plus2[9:2];
	       wr0_data_bank0 <= wr0_data[127:96];
	       wr0_data_bank1 <= wr0_data[31:0];
	       wr0_data_bank2 <= wr0_data[63:32];
	       wr0_data_bank3 <= wr0_data[95:64];
	       wr0_en_internal <= 4'b0010;
	    end
	  2'b10:
	    begin
	       wr0_addr_bank0 <= wr0_addr_plus2[9:2];
	       wr0_addr_bank1 <= wr0_addr_plus3[9:2];
	       wr0_addr_bank2 <= wr0_addr[9:2];
	       wr0_addr_bank3 <= wr0_addr_plus1[9:2];
	       wr0_data_bank0 <= wr0_data[95:64];
	       wr0_data_bank1 <= wr0_data[127:96];
	       wr0_data_bank2 <= wr0_data[31:0];
	       wr0_data_bank3 <= wr0_data[63:32];
	       wr0_en_internal <= 4'b0100;
	    end
	  2'b11:
	    begin
	       wr0_addr_bank0 <= wr0_addr_plus1[9:2];
	       wr0_addr_bank1 <= wr0_addr_plus2[9:2];
	       wr0_addr_bank2 <= wr0_addr_plus3[9:2];
	       wr0_addr_bank3 <= wr0_addr[9:2];
	       wr0_data_bank0 <= wr0_data[63:32];
	       wr0_data_bank1 <= wr0_data[95:64];
	       wr0_data_bank2 <= wr0_data[127:96];
	       wr0_data_bank3 <= wr0_data[31:0];
	       wr0_en_internal <= 4'b1000;
	    end
	  default:
	    begin
	       wr0_addr_bank0 <= {8{1'bx}};
	       wr0_addr_bank1 <= {8{1'bx}};
	       wr0_addr_bank2 <= {8{1'bx}};
	       wr0_addr_bank3 <= {8{1'bx}};
	       wr0_data_bank0 <= {32{1'bx}};
	       wr0_data_bank1 <= {32{1'bx}};
	       wr0_data_bank2 <= {32{1'bx}};
	       wr0_data_bank3 <= {32{1'bx}};
	       wr0_en_internal <= {4{1'bx}};
	    end
	endcase
     end

   always @(wr0_en_internal or wr0_en)
     begin
	casex(wr0_en)
	  4'b0000:
	    begin
               wr0_en_bank0 <= 1'b0;
               wr0_en_bank1 <= 1'b0;
               wr0_en_bank2 <= 1'b0;
               wr0_en_bank3 <= 1'b0;
	    end
	  4'b0001:
	    begin
               wr0_en_bank0 <= wr0_en_internal[0];
               wr0_en_bank1 <= wr0_en_internal[1];
               wr0_en_bank2 <= wr0_en_internal[2];
               wr0_en_bank3 <= wr0_en_internal[3];
	    end
	  4'b0011:
	    begin
               wr0_en_bank0 <= wr0_en_internal[0] | wr0_en_internal[3];
               wr0_en_bank1 <= wr0_en_internal[1] | wr0_en_internal[0];
               wr0_en_bank2 <= wr0_en_internal[2] | wr0_en_internal[1];
               wr0_en_bank3 <= wr0_en_internal[3] | wr0_en_internal[2];
	    end
	  4'b1111:
	    begin
               wr0_en_bank0 <= 1'b1;
               wr0_en_bank1 <= 1'b1;
               wr0_en_bank2 <= 1'b1;
               wr0_en_bank3 <= 1'b1;
	    end
	  default:
	    begin
               wr0_en_bank0 <= 1'bx;
               wr0_en_bank1 <= 1'bx;
               wr0_en_bank2 <= 1'bx;
               wr0_en_bank3 <= 1'bx;
	    end
	endcase
     end
   /////////////////////////////////////////
   reg_256x32b_3r_1w bank0(
			   .rd0_addr(rd0_addr_bank0),
			   .rd0_data(rd0_data_bank0),
			   .rd1_addr(rd1_addr[9:2]),
			   .rd1_data(rd1_data_bank0),
			   .rd2_addr(rd2_addr[9:2]),
			   .rd2_data(rd2_data_bank0),
			   .wr0_addr(wr0_addr_bank0),
			   .wr0_en(wr0_en_bank0),
			   .wr0_data(wr0_data_bank0),
			   .clk(clk)
			   );

   reg_256x32b_3r_1w bank1(
			   .rd0_addr(rd0_addr_bank1),
			   .rd0_data(rd0_data_bank1),
			   .rd1_addr(rd1_addr[9:2]),
			   .rd1_data(rd1_data_bank1),
			   .rd2_addr(rd2_addr[9:2]),
			   .rd2_data(rd2_data_bank1),
			   .wr0_addr(wr0_addr_bank1),
			   .wr0_en(wr0_en_bank1),
			   .wr0_data(wr0_data_bank1),
			   .clk(clk)
			   );

   reg_256x32b_3r_1w bank2(
			   .rd0_addr(rd0_addr_bank2),
			   .rd0_data(rd0_data_bank2),
			   .rd1_addr(rd1_addr[9:2]),
			   .rd1_data(rd1_data_bank2),
			   .rd2_addr(rd2_addr[9:2]),
			   .rd2_data(rd2_data_bank2),
			   .wr0_addr(wr0_addr_bank2),
			   .wr0_en(wr0_en_bank2),
			   .wr0_data(wr0_data_bank2),
			   .clk(clk)
			   );

   reg_256x32b_3r_1w bank3(
			   .rd0_addr(rd0_addr_bank3),
			   .rd0_data(rd0_data_bank3),
			   .rd1_addr(rd1_addr[9:2]),
			   .rd1_data(rd1_data_bank3),
			   .rd2_addr(rd2_addr[9:2]),
			   .rd2_data(rd2_data_bank3),
			   .wr0_addr(wr0_addr_bank3),
			   .wr0_en(wr0_en_bank3),
			   .wr0_data(wr0_data_bank3),
			   .clk(clk)
			   );
   /////////////////////////////////////////

endmodule
