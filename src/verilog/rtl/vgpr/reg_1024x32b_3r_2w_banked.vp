//rd0 - 128/64/32 bits wide (can be unaligned)
//rd1 - 32 bits wide
//rd2 - 32 bits wide

//wr0 - 32 bits wide
//wr1 - 128/64/32 bits wide (4 bit enable) (can be unaligned)

module reg_1024x32b_3r_2w_banked 
  (/*AUTOARG*/
   // Outputs
   rd0_data, rd1_data, rd2_data,
   // Inputs
   rd0_addr, rd1_addr, rd2_addr, wr0_addr, wr1_addr, wr0_en, wr1_en,
   wr0_data, wr1_data, clk
   );

   output [127:0] rd0_data;
   output [31:0]  rd1_data;
   output [31:0]  rd2_data;

   input [9:0] 	  rd0_addr;
   input [9:0] 	  rd1_addr;
   input [9:0] 	  rd2_addr;

   input [9:0] 	  wr0_addr;
   input [9:0] 	  wr1_addr;

   input 	  wr0_en;
   input [3:0] 	  wr1_en;

   input [31:0]   wr0_data;
   input [127:0]  wr1_data;

   input 	  clk;

   localparam NUMBER_BANKS = 16;

   localparam BANK_ADDR_SIZE = 4;
   
   wire [NUMBER_BANKS*(10-BANK_ADDR_SIZE)-1:0] bank_addr;
   wire [NUMBER_BANKS*32-1:0] 		       bank_data_in;
   wire [NUMBER_BANKS*32-1:0] 		       bank_data_out;
   wire [NUMBER_BANKS-1:0] 		       bank_wr_en_n;

   genvar 				       curr_bank;

   generate 
      for(curr_bank=0; curr_bank<NUMBER_BANKS; curr_bank = curr_bank+1) begin : gen_bank_signals   
	 assign bank_addr[curr_bank*(10-BANK_ADDR_SIZE)+:(10-BANK_ADDR_SIZE)] 
		  = (wr0_en && (wr0_addr[BANK_ADDR_SIZE-1:0] == curr_bank))?  wr0_addr[9:BANK_ADDR_SIZE] :
		    (wr1_en[0] && (wr1_addr[BANK_ADDR_SIZE-1:0] == curr_bank))? wr1_addr[9:BANK_ADDR_SIZE] :
		    (wr1_en[1] && (wr1_addr[BANK_ADDR_SIZE-1:0]+1 == curr_bank))? wr1_addr[9:BANK_ADDR_SIZE] :
		    (wr1_en[2] && (wr1_addr[BANK_ADDR_SIZE-1:0]+2 == curr_bank))? wr1_addr[9:BANK_ADDR_SIZE] :
		    (wr1_en[3] && (wr1_addr[BANK_ADDR_SIZE-1:0]+3 == curr_bank))? wr1_addr[9:BANK_ADDR_SIZE] :
		    (rd0_addr[BANK_ADDR_SIZE-1:0] == curr_bank)? rd0_addr[9:BANK_ADDR_SIZE] :		
		    (rd1_addr[BANK_ADDR_SIZE-1:0] == curr_bank)? rd1_addr[9:BANK_ADDR_SIZE] :		
		    (rd2_addr[BANK_ADDR_SIZE-1:0] == curr_bank)? rd2_addr[9:BANK_ADDR_SIZE] :		
		    (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == curr_bank)? rd0_addr[9:BANK_ADDR_SIZE] :		
		    (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == curr_bank)? rd0_addr[9:BANK_ADDR_SIZE] :		
		    rd0_addr[9:BANK_ADDR_SIZE];

	 assign bank_data_in[curr_bank*32+:32] 
		  = (wr0_en && (wr0_addr[BANK_ADDR_SIZE-1:0] == curr_bank))?  wr0_data[31:0] :
		    (wr1_en[0] && (wr1_addr[BANK_ADDR_SIZE-1:0] == curr_bank))? wr1_data[31:0] :
		    (wr1_en[1] && (wr1_addr[BANK_ADDR_SIZE-1:0]+1 == curr_bank))? wr1_data[63:32] :
		    (wr1_en[2] && (wr1_addr[BANK_ADDR_SIZE-1:0]+2 == curr_bank))? wr1_data[95:64] :
		    wr1_data[127:96];
	 assign bank_wr_en_n[curr_bank]
		  = (wr0_en && (wr0_addr[BANK_ADDR_SIZE-1:0] == curr_bank))?  1'b0 :
		    (wr1_en[0] && (wr1_addr[BANK_ADDR_SIZE-1:0] == curr_bank))? 1'b0 :
		    (wr1_en[1] && (wr1_addr[BANK_ADDR_SIZE-1:0]+1 == curr_bank))? 1'b0 :
		    (wr1_en[2] && (wr1_addr[BANK_ADDR_SIZE-1:0]+2 == curr_bank))? 1'b0 :
		    (wr1_en[3] && (wr1_addr[BANK_ADDR_SIZE-1:0]+3 == curr_bank))? 1'b0 : 1'b1;
      end // block: gen_bank_signals
   endgenerate
   
   assign rd0_data[31:0] 
	    =  (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'h0)?  bank_data_out[0*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'h1)?  bank_data_out[1*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'h2)?  bank_data_out[2*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'h3)?  bank_data_out[3*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'h4)?  bank_data_out[4*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'h5)?  bank_data_out[5*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'h6)?  bank_data_out[6*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'h7)?  bank_data_out[7*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'h8)?  bank_data_out[8*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'h9)?  bank_data_out[9*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'ha)?  bank_data_out[10*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'hb)?  bank_data_out[11*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'hc)?  bank_data_out[12*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'hd)?  bank_data_out[13*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0] == 4'he)?  bank_data_out[14*32+:32] :
	       bank_data_out[15*32+:32];

   assign rd0_data[63:32] 
	    =  (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'h0)?  bank_data_out[0*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'h1)?  bank_data_out[1*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'h2)?  bank_data_out[2*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'h3)?  bank_data_out[3*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'h4)?  bank_data_out[4*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'h5)?  bank_data_out[5*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'h6)?  bank_data_out[6*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'h7)?  bank_data_out[7*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'h8)?  bank_data_out[8*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'h9)?  bank_data_out[9*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'ha)?  bank_data_out[10*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'hb)?  bank_data_out[11*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'hc)?  bank_data_out[12*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'hd)?  bank_data_out[13*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+1 == 4'he)?  bank_data_out[14*32+:32] :
	       bank_data_out[15*32+:32];
   assign rd0_data[95:64] 
	    =  (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'h0)?  bank_data_out[0*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'h1)?  bank_data_out[1*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'h2)?  bank_data_out[2*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'h3)?  bank_data_out[3*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'h4)?  bank_data_out[4*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'h5)?  bank_data_out[5*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'h6)?  bank_data_out[6*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'h7)?  bank_data_out[7*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'h8)?  bank_data_out[8*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'h9)?  bank_data_out[9*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'ha)?  bank_data_out[10*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'hb)?  bank_data_out[11*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'hc)?  bank_data_out[12*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'hd)?  bank_data_out[13*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+2 == 4'he)?  bank_data_out[14*32+:32] :
	       bank_data_out[15*32+:32];
   assign rd0_data[127:96] 
	    =  (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'h0)?  bank_data_out[0*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'h1)?  bank_data_out[1*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'h2)?  bank_data_out[2*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'h3)?  bank_data_out[3*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'h4)?  bank_data_out[4*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'h5)?  bank_data_out[5*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'h6)?  bank_data_out[6*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'h7)?  bank_data_out[7*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'h8)?  bank_data_out[8*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'h9)?  bank_data_out[9*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'ha)?  bank_data_out[10*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'hb)?  bank_data_out[11*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'hc)?  bank_data_out[12*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'hd)?  bank_data_out[13*32+:32] :
	       (rd0_addr[BANK_ADDR_SIZE-1:0]+3 == 4'he)?  bank_data_out[14*32+:32] :
	       bank_data_out[15*32+:32];
   
   assign rd1_data[31:0] 
	    =  (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'h0)?  bank_data_out[0*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'h1)?  bank_data_out[1*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'h2)?  bank_data_out[2*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'h3)?  bank_data_out[3*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'h4)?  bank_data_out[4*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'h5)?  bank_data_out[5*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'h6)?  bank_data_out[6*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'h7)?  bank_data_out[7*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'h8)?  bank_data_out[8*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'h9)?  bank_data_out[9*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'ha)?  bank_data_out[10*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'hb)?  bank_data_out[11*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'hc)?  bank_data_out[12*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'hd)?  bank_data_out[13*32+:32] :
	       (rd1_addr[BANK_ADDR_SIZE-1:0] == 4'he)?  bank_data_out[14*32+:32] :
	       bank_data_out[15*32+:32];
   assign rd2_data[31:0] 
	    =  (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'h0)?  bank_data_out[0*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'h1)?  bank_data_out[1*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'h2)?  bank_data_out[2*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'h3)?  bank_data_out[3*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'h4)?  bank_data_out[4*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'h5)?  bank_data_out[5*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'h6)?  bank_data_out[6*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'h7)?  bank_data_out[7*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'h8)?  bank_data_out[8*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'h9)?  bank_data_out[9*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'ha)?  bank_data_out[10*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'hb)?  bank_data_out[11*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'hc)?  bank_data_out[12*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'hd)?  bank_data_out[13*32+:32] :
	       (rd2_addr[BANK_ADDR_SIZE-1:0] == 4'he)?  bank_data_out[14*32+:32] :
	       bank_data_out[15*32+:32];

   
   

   SRAMLP1RW64x32 sram_banks[NUMBER_BANKS-1:0] 
     (
      .A(bank_addr),
      // So it works like our current reg file, where we put the
      // addr in the bus and get the data on the same cycle
      .CE(~clk),
      .WEB(bank_wr_en_n),
      .OEB(~bank_wr_en_n),
      .CSB(1'b0),
      .I(bank_data_in),
      .O(bank_data_out),
      .SD(1'b0),
      .LS(1'b0),
      .DS(1'b0),
      .VDD(1'b1),
      .VDDL(1'b1),
      .VSS(1'b0)
      );
   
   

endmodule

/*********************************************************************                                                                                        
 *  SAED_EDK32nm_SRAMLP : SRAMLP1RW64x32 Verilog description             *                                                                                     
 *  ---------------------------------------------------------------   *                                                                                        
 *  Filename      : SRAMLP1RW64x32.v                                   *                                                                                       
 *  SRAMLP name     : SRAMLP1RW64x32                                     *                                                                                     
 *  Word width    : 32    bits                                        *                                                                                        
 *  Word number   : 64                                                *                                                                                        
 *  Adress width  : 6     bits                                        *                                                                                        
 **********************************************************************/

//`timescale 1ns/100fs

`define numAddr 6
`define numWords 64
`define wordLength 32

module SRAMLP1RW64x32 (A,CE,WEB,OEB,CSB,I,O,SD,LS,DS,VDD,VDDL,VSS);
   input                       SD;
   input                       LS;
   input                       DS;
   (* pg_type="primary_power" *)    input           VDD;
   (* pg_type="secondary_power" *)  input           VDDL;
   (* pg_type="primary_ground" *)   input           VSS;

   input 		       CE;
   input 		       WEB;
   input 		       OEB;
   input 		       CSB;

   input [`numAddr-1:0]        A;
   input [`wordLength-1:0]     I;
   output [`wordLength-1:0]    O;

   /*reg   [`wordLength-1:0]       memory[`numWords-1:0];*/
   /*reg   [`wordLength-1:0]       data_out;*/
   wire [`wordLength-1:0]      O;

   wire 		       RE;
   wire 		       WE;

   SRAMLP1RW64x32_1bit sram_IO0 ( CE, WEB,  A, OEB, CSB, I[0], O[0],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO1 ( CE, WEB,  A, OEB, CSB, I[1], O[1],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO2 ( CE, WEB,  A, OEB, CSB, I[2], O[2],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO3 ( CE, WEB,  A, OEB, CSB, I[3], O[3],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO4 ( CE, WEB,  A, OEB, CSB, I[4], O[4],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO5 ( CE, WEB,  A, OEB, CSB, I[5], O[5],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO6 ( CE, WEB,  A, OEB, CSB, I[6], O[6],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO7 ( CE, WEB,  A, OEB, CSB, I[7], O[7],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO8 ( CE, WEB,  A, OEB, CSB, I[8], O[8],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO9 ( CE, WEB,  A, OEB, CSB, I[9], O[9],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO10 ( CE, WEB,  A, OEB, CSB, I[10], O[10],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO11 ( CE, WEB,  A, OEB, CSB, I[11], O[11],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO12 ( CE, WEB,  A, OEB, CSB, I[12], O[12],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO13 ( CE, WEB,  A, OEB, CSB, I[13], O[13],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO14 ( CE, WEB,  A, OEB, CSB, I[14], O[14],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO15 ( CE, WEB,  A, OEB, CSB, I[15], O[15],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO16 ( CE, WEB,  A, OEB, CSB, I[16], O[16],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO17 ( CE, WEB,  A, OEB, CSB, I[17], O[17],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO18 ( CE, WEB,  A, OEB, CSB, I[18], O[18],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO19 ( CE, WEB,  A, OEB, CSB, I[19], O[19],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO20 ( CE, WEB,  A, OEB, CSB, I[20], O[20],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO21 ( CE, WEB,  A, OEB, CSB, I[21], O[21],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO22 ( CE, WEB,  A, OEB, CSB, I[22], O[22],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO23 ( CE, WEB,  A, OEB, CSB, I[23], O[23],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO24 ( CE, WEB,  A, OEB, CSB, I[24], O[24],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO25 ( CE, WEB,  A, OEB, CSB, I[25], O[25],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO26 ( CE, WEB,  A, OEB, CSB, I[26], O[26],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO27 ( CE, WEB,  A, OEB, CSB, I[27], O[27],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO28 ( CE, WEB,  A, OEB, CSB, I[28], O[28],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO29 ( CE, WEB,  A, OEB, CSB, I[29], O[29],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO30 ( CE, WEB,  A, OEB, CSB, I[30], O[30],SD,LS,DS);
   SRAMLP1RW64x32_1bit sram_IO31 ( CE, WEB,  A, OEB, CSB, I[31], O[31],SD,LS,DS);


endmodule


module SRAMLP1RW64x32_1bit (CE_i, WEB_i,  A_i, OEB_i, CSB_i, I_i, O_i,SD,LS,DS);
   input                       SD;
   input                       LS;
   input                       DS;
   integer 		       index;

   input 		       CSB_i;
   input 		       OEB_i;
   input 		       CE_i;
   input 		       WEB_i;

   input [`numAddr-1:0]        A_i;
   input [0:0] 		       I_i;

   output [0:0] 	       O_i;

   reg [0:0] 		       O_i;
   reg [0:0] 		       memory[`numWords-1:0];
   reg [0:0] 		       data_out;


   // Write Mode                                                                                                                                                 
   and u1 (RE, ~CSB_i,  WEB_i);
   and u2 (WE, ~CSB_i, ~WEB_i);

   always @ (posedge CE_i)
     if(~CSB_i)
       begin
          if (RE)
            begin
               data_out = memory[A_i];
               if (!OEB_i)
                 O_i = data_out;
	       else
                 O_i = 1'bz;
	    end
          else
            if (WE)
              begin
                 memory[A_i] = I_i;
		 if (!OEB_i)
                   O_i = data_out;
                 else
                   O_i = 1'bz;
	      end
       end
   always @ (SD or LS or DS)
     if(CSB_i)
       begin
          casez ({SD,DS,LS})
            3'b1??:
              begin
                 for(index=0;index<`numWords;index=index+1)
		   memory[index]=1'bx;
                 O_i=1'b0;
	      end
            3'b01?:
              begin
                 O_i=1'b0;
              end
	    3'b001:
              begin
                 if (!OEB_i)
                   O_i = data_out;
		 else
                   O_i = 1'bz;
              end
          endcase
       end



endmodule

