//rd0 - 128bit, aligned (also supports unaligned)
//rd1 - 64bit, aligned (also supports unaligned)
//rd2 - 64bit, aligned (also supports unaligned)

//wr0 - 128/64/32bit (4 bit enable), aligned
//wr1 - 64/32bit (2 bit enable), aligned


module reg_512x32b_3r_2w 
  (/*AUTOARG*/
   // Outputs
   rd0_data, rd1_data, rd2_data,
   // Inputs
   clk, rd0_addr, rd1_addr, rd2_addr, wr0_addr, wr1_addr, wr0_en,
   wr1_en, wr0_data, wr1_data
   );
   input clk;

   output [127:0] rd0_data;
   output [63:0]  rd1_data;
   output [63:0]  rd2_data;

   input [8:0] 	  rd0_addr;
   input [8:0] 	  rd1_addr;
   input [8:0] 	  rd2_addr;

   input [8:0] 	  wr0_addr;
   input [8:0] 	  wr1_addr;

   input [3:0] 	  wr0_en;
   input [1:0] 	  wr1_en;

   input [127:0]  wr0_data;
   input [63:0]   wr1_data;

   /////////////

   wire [8:0] 	  rd0_addr_last;
   wire [8:0] 	  rd1_addr_last;
   wire [8:0] 	  rd2_addr_last;
   
   reg [127:0] 	  rd0_data;
   reg [63:0] 	  rd1_data;
   reg [63:0] 	  rd2_data;

   wire [8:0] 	  rd0_addr_plus1;
   wire [8:0] 	  rd0_addr_plus2;
   wire [8:0] 	  rd0_addr_plus3;
   assign rd0_addr_plus1 = rd0_addr + 1'b1;
   assign rd0_addr_plus2 = rd0_addr + 2'b10;
   assign rd0_addr_plus3 = rd0_addr + 2'b11;
   wire [31:0] 	  rd0_data_bank0;
   wire [31:0] 	  rd0_data_bank1;
   wire [31:0] 	  rd0_data_bank2;
   wire [31:0] 	  rd0_data_bank3;
   reg [6:0] 	  rd0_addr_bank0;
   reg [6:0] 	  rd0_addr_bank1;
   reg [6:0] 	  rd0_addr_bank2;
   reg [6:0] 	  rd0_addr_bank3;
   //see mux at end of module


   wire [8:0] 	  rd1_addr_plus1;
   assign rd1_addr_plus1 = rd1_addr + 1'b1;
   wire [31:0] 	  rd1_data_bank0;
   wire [31:0] 	  rd1_data_bank1;
   wire [31:0] 	  rd1_data_bank2;
   wire [31:0] 	  rd1_data_bank3;
   reg [6:0] 	  rd1_addr_bank0;
   reg [6:0] 	  rd1_addr_bank1;
   reg [6:0] 	  rd1_addr_bank2;
   reg [6:0] 	  rd1_addr_bank3;
   //see mux at end of module

   wire [8:0] 	  rd2_addr_plus1;
   assign rd2_addr_plus1 = rd2_addr + 1'b1;
   wire [31:0] 	  rd2_data_bank0;
   wire [31:0] 	  rd2_data_bank1;
   wire [31:0] 	  rd2_data_bank2;
   wire [31:0] 	  rd2_data_bank3;
   reg [6:0] 	  rd2_addr_bank0;
   reg [6:0] 	  rd2_addr_bank1;
   reg [6:0] 	  rd2_addr_bank2;
   reg [6:0] 	  rd2_addr_bank3;
   //see mux at end of module

   /////
   reg 		  wr0_en_bank0;
   reg 		  wr0_en_bank1;
   reg 		  wr0_en_bank2;
   reg 		  wr0_en_bank3;
   reg [31:0] 	  wr0_data_bank0;
   reg [31:0] 	  wr0_data_bank1;
   reg [31:0] 	  wr0_data_bank2;
   reg [31:0] 	  wr0_data_bank3;
   //see mux at end of module

   reg 		  wr1_en_bank0;
   reg 		  wr1_en_bank1;
   reg 		  wr1_en_bank2;
   reg 		  wr1_en_bank3;
   reg [31:0] 	  wr1_data_bank0;
   reg [31:0] 	  wr1_data_bank1;
   reg [31:0] 	  wr1_data_bank2;
   reg [31:0] 	  wr1_data_bank3;
   //see mux at end of module

`ifdef FPGA_BUILD
  reg_128x32b_3r_2w_fpga
`else
  reg_128x32b_3r_2w
`endif
  bank0(
			   .rd0_addr(rd0_addr_bank0),
			   .rd0_data(rd0_data_bank0),
			   .rd1_addr(rd1_addr_bank0),
			   .rd1_data(rd1_data_bank0),
			   .rd2_addr(rd2_addr_bank0),
			   .rd2_data(rd2_data_bank0),
			   .wr0_addr(wr0_addr[8:2]),
			   .wr0_en(wr0_en_bank0),
			   .wr0_data(wr0_data_bank0),
			   .wr1_addr(wr1_addr[8:2]),
			   .wr1_en(wr1_en_bank0),
			   .wr1_data(wr1_data_bank0),
			   .clk(clk)
			   );

`ifdef FPGA_BUILD
  reg_128x32b_3r_2w_fpga
`else
  reg_128x32b_3r_2w
`endif
  bank1(
			   .rd0_addr(rd0_addr_bank1),
			   .rd0_data(rd0_data_bank1),
			   .rd1_addr(rd1_addr_bank1),
			   .rd1_data(rd1_data_bank1),
			   .rd2_addr(rd2_addr_bank1),
			   .rd2_data(rd2_data_bank1),
			   .wr0_addr(wr0_addr[8:2]),
			   .wr0_en(wr0_en_bank1),
			   .wr0_data(wr0_data_bank1),
			   .wr1_addr(wr1_addr[8:2]),
			   .wr1_en(wr1_en_bank1),
			   .wr1_data(wr1_data_bank1),
			   .clk(clk)
			   );

`ifdef FPGA_BUILD
  reg_128x32b_3r_2w_fpga
`else
  reg_128x32b_3r_2w
`endif
  bank2(
			   .rd0_addr(rd0_addr_bank2),
			   .rd0_data(rd0_data_bank2),
			   .rd1_addr(rd1_addr_bank2),
			   .rd1_data(rd1_data_bank2),
			   .rd2_addr(rd2_addr_bank2),
			   .rd2_data(rd2_data_bank2),
			   .wr0_addr(wr0_addr[8:2]),
			   .wr0_en(wr0_en_bank2),
			   .wr0_data(wr0_data_bank2),
			   .wr1_addr(wr1_addr[8:2]),
			   .wr1_en(wr1_en_bank2),
			   .wr1_data(wr1_data_bank2),
			   .clk(clk)
			   );

`ifdef FPGA_BUILD
  reg_128x32b_3r_2w_fpga
`else
  reg_128x32b_3r_2w
`endif
  bank3(
			   .rd0_addr(rd0_addr_bank3),
			   .rd0_data(rd0_data_bank3),
			   .rd1_addr(rd1_addr_bank3),
			   .rd1_data(rd1_data_bank3),
			   .rd2_addr(rd2_addr_bank3),
			   .rd2_data(rd2_data_bank3),
			   .wr0_addr(wr0_addr[8:2]),
			   .wr0_en(wr0_en_bank3),
			   .wr0_data(wr0_data_bank3),
			   .wr1_addr(wr1_addr[8:2]),
			   .wr1_en(wr1_en_bank3),
			   .wr1_data(wr1_data_bank3),
			   .clk(clk)
			   );

   //Bank distribution for 128/64/32 write bit port
   always @(wr0_data or wr0_addr or wr0_en)
     begin
	casex({wr0_en,wr0_addr[1:0]})
	  6'b0001_00:
	    begin
               wr0_en_bank0 <= 1'b1;
               wr0_en_bank1 <= 1'b0;
               wr0_en_bank2 <= 1'b0;
               wr0_en_bank3 <= 1'b0;
               wr0_data_bank0 <= wr0_data[31:0];
               wr0_data_bank1 <= {32{1'bx}};
               wr0_data_bank2 <= {32{1'bx}};
               wr0_data_bank3 <= {32{1'bx}};
	    end
	  6'b0001_01:
	    begin
               wr0_en_bank0 <= 1'b0;
               wr0_en_bank1 <= 1'b1;
               wr0_en_bank2 <= 1'b0;
               wr0_en_bank3 <= 1'b0;
               wr0_data_bank0 <= {32{1'bx}};
               wr0_data_bank1 <= wr0_data[31:0];
               wr0_data_bank2 <= {32{1'bx}};
               wr0_data_bank3 <= {32{1'bx}};
	    end
	  6'b0001_10:
	    begin
               wr0_en_bank0 <= 1'b0;
               wr0_en_bank1 <= 1'b0;
               wr0_en_bank2 <= 1'b1;
               wr0_en_bank3 <= 1'b0;
               wr0_data_bank0 <= {32{1'bx}};
               wr0_data_bank1 <= {32{1'bx}};
               wr0_data_bank2 <= wr0_data[31:0];
               wr0_data_bank3 <= {32{1'bx}};
	    end
	  6'b0001_11:
	    begin
               wr0_en_bank0 <= 1'b0;
               wr0_en_bank1 <= 1'b0;
               wr0_en_bank2 <= 1'b0;
               wr0_en_bank3 <= 1'b1;
               wr0_data_bank0 <= {32{1'bx}};
               wr0_data_bank1 <= {32{1'bx}};
               wr0_data_bank2 <= {32{1'bx}};
               wr0_data_bank3 <= wr0_data[31:0];
	    end
	  6'b0011_00:
	    begin
               wr0_en_bank0 <= 1'b1;
               wr0_en_bank1 <= 1'b1;
               wr0_en_bank2 <= 1'b0;
               wr0_en_bank3 <= 1'b0;
               wr0_data_bank0 <= wr0_data[31:0];
               wr0_data_bank1 <= wr0_data[63:32];
               wr0_data_bank2 <= {32{1'bx}};
               wr0_data_bank3 <= {32{1'bx}};
	    end
	  6'b0011_10:
	    begin
               wr0_en_bank0 <= 1'b0;
               wr0_en_bank1 <= 1'b0;
               wr0_en_bank2 <= 1'b1;
               wr0_en_bank3 <= 1'b1;
               wr0_data_bank0 <= {32{1'bx}};
               wr0_data_bank1 <= {32{1'bx}};
               wr0_data_bank2 <= wr0_data[31:0];
               wr0_data_bank3 <= wr0_data[63:32];
	    end
	  6'b1111_00:
	    begin
               wr0_en_bank0 <= 1'b1;
               wr0_en_bank1 <= 1'b1;
               wr0_en_bank2 <= 1'b1;
               wr0_en_bank3 <= 1'b1;
               wr0_data_bank0 <= wr0_data[31:0];
               wr0_data_bank1 <= wr0_data[63:32];
               wr0_data_bank2 <= wr0_data[95:64];
               wr0_data_bank3 <= wr0_data[127:96];
	    end
	  6'b0000_??:
	    begin
               wr0_en_bank0 <= 1'b0;
               wr0_en_bank1 <= 1'b0;
               wr0_en_bank2 <= 1'b0;
               wr0_en_bank3 <= 1'b0;
               wr0_data_bank0 <= {32{1'bx}};
               wr0_data_bank1 <= {32{1'bx}};
               wr0_data_bank2 <= {32{1'bx}};
               wr0_data_bank3 <= {32{1'bx}};
	    end
	  default:
	    begin
               wr0_en_bank0 <= 1'bx;
               wr0_en_bank1 <= 1'bx;
               wr0_en_bank2 <= 1'bx;
               wr0_en_bank3 <= 1'bx;
               wr0_data_bank0 <= {32{1'bx}};
               wr0_data_bank1 <= {32{1'bx}};
               wr0_data_bank2 <= {32{1'bx}};
               wr0_data_bank3 <= {32{1'bx}};
	    end
	endcase
     end

   //Bank distribution for 64/32 bit write port
   always @(wr1_data or wr1_addr or wr1_en)
     begin
	casex({wr1_en,wr1_addr[1:0]})
	  4'b01_00:
	    begin
               wr1_en_bank0 <= 1'b1;
               wr1_en_bank1 <= 1'b0;
               wr1_en_bank2 <= 1'b0;
               wr1_en_bank3 <= 1'b0;
               wr1_data_bank0 <= wr1_data[31:0];
               wr1_data_bank1 <= {32{1'bx}};
               wr1_data_bank2 <= {32{1'bx}};
               wr1_data_bank3 <= {32{1'bx}};
	    end
	  4'b01_01:
	    begin
               wr1_en_bank0 <= 1'b0;
               wr1_en_bank1 <= 1'b1;
               wr1_en_bank2 <= 1'b0;
               wr1_en_bank3 <= 1'b0;
               wr1_data_bank0 <= {32{1'bx}};
               wr1_data_bank1 <= wr1_data[31:0];
               wr1_data_bank2 <= {32{1'bx}};
               wr1_data_bank3 <= {32{1'bx}};
	    end
	  4'b01_10:
	    begin
               wr1_en_bank0 <= 1'b0;
               wr1_en_bank1 <= 1'b0;
               wr1_en_bank2 <= 1'b1;
               wr1_en_bank3 <= 1'b0;
               wr1_data_bank0 <= {32{1'bx}};
               wr1_data_bank1 <= {32{1'bx}};
               wr1_data_bank2 <= wr1_data[31:0];
               wr1_data_bank3 <= {32{1'bx}};
	    end
	  4'b01_11:
	    begin
               wr1_en_bank0 <= 1'b0;
               wr1_en_bank1 <= 1'b0;
               wr1_en_bank2 <= 1'b0;
               wr1_en_bank3 <= 1'b1;
               wr1_data_bank0 <= {32{1'bx}};
               wr1_data_bank1 <= {32{1'bx}};
               wr1_data_bank2 <= {32{1'bx}};
               wr1_data_bank3 <= wr1_data[31:0];
	    end
	  4'b11_00:
	    begin
               wr1_en_bank0 <= 1'b1;
               wr1_en_bank1 <= 1'b1;
               wr1_en_bank2 <= 1'b0;
               wr1_en_bank3 <= 1'b0;
               wr1_data_bank0 <= wr1_data[31:0];
               wr1_data_bank1 <= wr1_data[63:32];
               wr1_data_bank2 <= {32{1'bx}};
               wr1_data_bank3 <= {32{1'bx}};
	    end
	  4'b11_10:
	    begin
               wr1_en_bank0 <= 1'b0;
               wr1_en_bank1 <= 1'b0;
               wr1_en_bank2 <= 1'b1;
               wr1_en_bank3 <= 1'b1;
               wr1_data_bank0 <= {32{1'bx}};
               wr1_data_bank1 <= {32{1'bx}};
               wr1_data_bank2 <= wr1_data[31:0];
               wr1_data_bank3 <= wr1_data[63:32];
	    end
	  4'b00_??:
	    begin
               wr1_en_bank0 <= 1'b0;
               wr1_en_bank1 <= 1'b0;
               wr1_en_bank2 <= 1'b0;
               wr1_en_bank3 <= 1'b0;
               wr1_data_bank0 <= {32{1'bx}};
               wr1_data_bank1 <= {32{1'bx}};
               wr1_data_bank2 <= {32{1'bx}};
               wr1_data_bank3 <= {32{1'bx}};
	    end
	  default:
	    begin
               wr1_en_bank0 <= 1'bx;
               wr1_en_bank1 <= 1'bx;
               wr1_en_bank2 <= 1'bx;
               wr1_en_bank3 <= 1'bx;
               wr1_data_bank0 <= {32{1'bx}};
               wr1_data_bank1 <= {32{1'bx}};
               wr1_data_bank2 <= {32{1'bx}};
               wr1_data_bank3 <= {32{1'bx}};
	    end
	endcase
     end





   dff rd_addr_delay[9+9+9-1:0]
     (.q({rd0_addr_last, rd1_addr_last, rd2_addr_last}),
      .d({rd0_addr, rd1_addr, rd2_addr}),
      .clk(clk),
      .rst(1'b0));
   
   //Bank distribution for 128/64/32 bit read port
   always @(rd0_addr or rd0_addr_plus1 or rd0_addr_plus2 or rd0_addr_plus3)
     begin
	casex(rd0_addr[1:0])
	  2'b00:
	    begin
               rd0_addr_bank0 <= rd0_addr[8:2];
               rd0_addr_bank1 <= rd0_addr_plus1[8:2];
               rd0_addr_bank2 <= rd0_addr_plus2[8:2];
               rd0_addr_bank3 <= rd0_addr_plus3[8:2];
	    end
	  2'b01:
	    begin
               rd0_addr_bank0 <= rd0_addr_plus3[8:2];
               rd0_addr_bank1 <= rd0_addr[8:2];
               rd0_addr_bank2 <= rd0_addr_plus1[8:2];
               rd0_addr_bank3 <= rd0_addr_plus2[8:2];
	    end
	  2'b10:
	    begin
               rd0_addr_bank0 <= rd0_addr_plus2[8:2];
               rd0_addr_bank1 <= rd0_addr_plus3[8:2];
               rd0_addr_bank2 <= rd0_addr[8:2];
               rd0_addr_bank3 <= rd0_addr_plus1[8:2];
	    end
	  2'b11:
	    begin
               rd0_addr_bank0 <= rd0_addr_plus1[8:2];
               rd0_addr_bank1 <= rd0_addr_plus2[8:2];
               rd0_addr_bank2 <= rd0_addr_plus3[8:2];
               rd0_addr_bank3 <= rd0_addr[8:2];
	    end
	  default:
	    begin
               rd0_addr_bank0 <= {7{1'bx}};
               rd0_addr_bank1 <= {7{1'bx}};
               rd0_addr_bank2 <= {7{1'bx}};
               rd0_addr_bank3 <= {7{1'bx}};
	    end
	endcase
     end

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
   
   //Bank distribution for 64/32 bit read port
   always @(rd1_addr or rd1_addr_plus1)
     begin
	casex(rd1_addr[1:0])
	  2'b00:
	    begin
               rd1_addr_bank0 <= rd1_addr[8:2];
               rd1_addr_bank1 <= rd1_addr_plus1[8:2];
               rd1_addr_bank2 <= {7{1'bx}};
               rd1_addr_bank3 <= {7{1'bx}};
	    end
	  2'b01:
	    begin
               rd1_addr_bank0 <= {7{1'bx}};
               rd1_addr_bank1 <= rd1_addr[8:2];
               rd1_addr_bank2 <= rd1_addr_plus1[8:2];
               rd1_addr_bank3 <= {7{1'bx}};
	    end
	  2'b10:
	    begin
               rd1_addr_bank0 <= {7{1'bx}};
               rd1_addr_bank1 <= {7{1'bx}};
               rd1_addr_bank2 <= rd1_addr[8:2];
               rd1_addr_bank3 <= rd1_addr_plus1[8:2];
	    end
	  2'b11:
	    begin
               rd1_addr_bank0 <= rd1_addr_plus1[8:2];
               rd1_addr_bank1 <= {7{1'bx}};
               rd1_addr_bank2 <= {7{1'bx}};
               rd1_addr_bank3 <= rd1_addr[8:2];
	    end
	  default:
	    begin
               rd1_addr_bank0 <= {7{1'bx}};
               rd1_addr_bank1 <= {7{1'bx}};
               rd1_addr_bank2 <= {7{1'bx}};
               rd1_addr_bank3 <= {7{1'bx}};
	    end
	endcase
     end

   always @(rd1_addr_last or rd1_data_bank0 or rd1_data_bank1 or 
	    rd1_data_bank2 or rd1_data_bank3)
     begin
	casex(rd1_addr_last[1:0])
	  2'b00:
	    begin
               rd1_data <= {rd1_data_bank1,rd1_data_bank0};
	    end
	  2'b01:
	    begin
               rd1_data <= {rd1_data_bank2,rd1_data_bank1};
	    end
	  2'b10:
	    begin
               rd1_data <= {rd1_data_bank3,rd1_data_bank2};
	    end
	  2'b11:
	    begin
               rd1_data <= {rd1_data_bank0,rd1_data_bank3};
	    end
	  default:
	    begin
               rd1_data <= {128{1'bx}};
	    end
	endcase
     end

   
   //Bank distribution for 64/32 bit read port
   always @(rd2_addr or rd2_addr_plus1)
     begin
	casex(rd2_addr[1:0])
	  2'b00:
	    begin
               rd2_addr_bank0 <= rd2_addr[8:2];
               rd2_addr_bank1 <= rd2_addr_plus1[8:2];
               rd2_addr_bank2 <= {7{1'bx}};
               rd2_addr_bank3 <= {7{1'bx}};
	    end
	  2'b01:
	    begin
               rd2_addr_bank0 <= {7{1'bx}};
               rd2_addr_bank1 <= rd2_addr[8:2];
               rd2_addr_bank2 <= rd2_addr_plus1[8:2];
               rd2_addr_bank3 <= {7{1'bx}};
	    end
	  2'b10:
	    begin
               rd2_addr_bank0 <= {7{1'bx}};
               rd2_addr_bank1 <= {7{1'bx}};
               rd2_addr_bank2 <= rd2_addr[8:2];
               rd2_addr_bank3 <= rd2_addr_plus1[8:2];
	    end
	  2'b11:
	    begin
               rd2_addr_bank0 <= rd2_addr_plus1[8:2];
               rd2_addr_bank1 <= {7{1'bx}};
               rd2_addr_bank2 <= {7{1'bx}};
               rd2_addr_bank3 <= rd2_addr[8:2];
	    end
	  default:
	    begin
               rd2_addr_bank0 <= {7{1'bx}};
               rd2_addr_bank1 <= {7{1'bx}};
               rd2_addr_bank2 <= {7{1'bx}};
               rd2_addr_bank3 <= {7{1'bx}};
	    end
	endcase
     end

   always @(rd2_addr_last or rd2_data_bank0 or rd2_data_bank1 or 
	    rd2_data_bank2 or rd2_data_bank3)
     begin
	casex(rd2_addr_last[1:0])
	  2'b00:
	    begin
               rd2_data <= {rd2_data_bank1,rd2_data_bank0};
	    end
	  2'b01:
	    begin
               rd2_data <= {rd2_data_bank2,rd2_data_bank1};
	    end
	  2'b10:
	    begin
               rd2_data <= {rd2_data_bank3,rd2_data_bank2};
	    end
	  2'b11:
	    begin
               rd2_data <= {rd2_data_bank0,rd2_data_bank3};
	    end
	  default:
	    begin
               rd2_data <= {128{1'bx}};
	    end
	endcase
     end
   
endmodule
