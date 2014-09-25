//////////////////////////////////////////////////////////////////////
////                                                              ////
////  fpu_pre_norm_div                                     ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://opencores.org/project,or1k                           ////
////                                                              ////
////  Description                                                 ////
////  pre-normalization entity for the division unit              ////
////                                                              ////
////  To Do:                                                      ////
////                                                              ////
////                                                              ////
////  Author(s):                                                  ////
////      - Original design (FPU100) -                            ////
////        Jidan Al-eryani, jidan@gmx.net                        ////
////      - Conv. to Verilog and inclusion in OR1200 -            ////
////        Julius Baxter, julius@opencores.org                   ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2006, 2010
//
//	This source file may be used and distributed without        
//	restriction provided that this copyright statement is not   
//	removed from the file and that any derivative work contains 
//	the original copyright notice and the associated disclaimer.
//                                                           
//		THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     
//	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   
//	TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   
//	FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      
//	OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         
//	INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   
//	GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        
//	BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  
//	LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  
//	OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         
//	POSSIBILITY OF SUCH DAMAGE. 
//

module fpu_pre_norm_div
  (
   clk,
   rst,
   opa_i,
   opb_i,
   exp_10_o,
   dvdnd_50_o,
   dvsor_27_o
   );

   
   parameter FP_WIDTH = 32;
   parameter MUL_SERIAL = 0; // 0 for parallel multiplier, 1 for serial
   parameter MUL_COUNT = 11; //11 for parallel multiplier, 34 for serial
   parameter FRAC_WIDTH = 23;
   parameter EXP_WIDTH = 8;
   parameter ZERO_VECTOR = 31'd0;
   parameter INF = 31'b1111111100000000000000000000000;
   parameter QNAN = 31'b1111111110000000000000000000000;
   parameter SNAN = 31'b1111111100000000000000000000001;

   input clk;
   input rst;
   
   input [FP_WIDTH-1:0] opa_i;
   input [FP_WIDTH-1:0] opb_i;
   output reg [EXP_WIDTH+1:0] exp_10_o;
   output [2*(FRAC_WIDTH+2)-1:0] dvdnd_50_o;
   output [FRAC_WIDTH+3:0] 	 dvsor_27_o;

   
   wire [EXP_WIDTH-1:0] 	 s_expa;
   wire [EXP_WIDTH-1:0] 	 s_expb;
   wire [FRAC_WIDTH-1:0] 	 s_fracta;
   wire [FRAC_WIDTH-1:0] 	 s_fractb;
   wire [2*(FRAC_WIDTH+2)-1:0] 	 s_dvdnd_50_o;
   wire [FRAC_WIDTH+3:0] 	 s_dvsor_27_o;
   reg [5:0] 			 s_dvd_zeros;
   reg [5:0] 			 s_div_zeros;
   reg [EXP_WIDTH+1:0] 		 s_exp_10_o;
   
   reg [EXP_WIDTH+1:0] 		 s_expa_in;
   reg [EXP_WIDTH+1:0] 		 s_expb_in;
   wire 			 s_opa_dn, s_opb_dn;
   
   wire [FRAC_WIDTH:0] 		 s_fracta_24;
   wire [FRAC_WIDTH:0] 		 s_fractb_24;

   
   assign s_expa = opa_i[30:23];
   assign s_expb = opb_i[30:23];
   assign s_fracta = opa_i[22:0];
   assign s_fractb = opb_i[22:0];
   assign dvdnd_50_o = s_dvdnd_50_o;
   assign dvsor_27_o	= s_dvsor_27_o;
   
   // Output Register
   always @(posedge clk or posedge rst)
     if (rst)
       exp_10_o <= 'd0;
     else
       exp_10_o <= s_exp_10_o;

   assign s_opa_dn = !(|s_expa);
   assign s_opb_dn = !(|s_expb);
   
   assign s_fracta_24 = {!s_opa_dn,s_fracta};
   assign s_fractb_24 = {!s_opb_dn,s_fractb};
   
   
   // count leading zeros
   //s_dvd_zeros <= count_l_zeros( s_fracta_24 );
   always @(s_fracta_24)
     casez(s_fracta_24)	// synopsys full_case parallel_case
       24'b1???????????????????????: s_dvd_zeros = 0;
       24'b01??????????????????????: s_dvd_zeros = 1;
       24'b001?????????????????????: s_dvd_zeros = 2;
       24'b0001????????????????????: s_dvd_zeros = 3;
       24'b00001???????????????????: s_dvd_zeros = 4;
       24'b000001??????????????????: s_dvd_zeros = 5;
       24'b0000001?????????????????: s_dvd_zeros = 6;
       24'b00000001????????????????: s_dvd_zeros = 7;
       24'b000000001???????????????: s_dvd_zeros = 8;
       24'b0000000001??????????????: s_dvd_zeros = 9;
       24'b00000000001?????????????: s_dvd_zeros = 10;
       24'b000000000001????????????: s_dvd_zeros = 11;
       24'b0000000000001???????????: s_dvd_zeros = 12;
       24'b00000000000001??????????: s_dvd_zeros = 13;
       24'b000000000000001?????????: s_dvd_zeros = 14;
       24'b0000000000000001????????: s_dvd_zeros = 15;
       24'b00000000000000001???????: s_dvd_zeros = 16;
       24'b000000000000000001??????: s_dvd_zeros = 17;
       24'b0000000000000000001?????: s_dvd_zeros = 18;
       24'b00000000000000000001????: s_dvd_zeros = 19;
       24'b000000000000000000001???: s_dvd_zeros = 20;
       24'b0000000000000000000001??: s_dvd_zeros = 21;
       24'b00000000000000000000001?: s_dvd_zeros = 22;
       24'b000000000000000000000001: s_dvd_zeros = 23;
       24'b000000000000000000000000: s_dvd_zeros = 24;
     endcase

   //s_div_zeros <= count_l_zeros( s_fractb_24 );
   always @(s_fractb_24)
     casez(s_fractb_24)	// synopsys full_case parallel_case
       24'b1???????????????????????: s_div_zeros = 0;
       24'b01??????????????????????: s_div_zeros = 1;
       24'b001?????????????????????: s_div_zeros = 2;
       24'b0001????????????????????: s_div_zeros = 3;
       24'b00001???????????????????: s_div_zeros = 4;
       24'b000001??????????????????: s_div_zeros = 5;
       24'b0000001?????????????????: s_div_zeros = 6;
       24'b00000001????????????????: s_div_zeros = 7;
       24'b000000001???????????????: s_div_zeros = 8;
       24'b0000000001??????????????: s_div_zeros = 9;
       24'b00000000001?????????????: s_div_zeros = 10;
       24'b000000000001????????????: s_div_zeros = 11;
       24'b0000000000001???????????: s_div_zeros = 12;
       24'b00000000000001??????????: s_div_zeros = 13;
       24'b000000000000001?????????: s_div_zeros = 14;
       24'b0000000000000001????????: s_div_zeros = 15;
       24'b00000000000000001???????: s_div_zeros = 16;
       24'b000000000000000001??????: s_div_zeros = 17;
       24'b0000000000000000001?????: s_div_zeros = 18;
       24'b00000000000000000001????: s_div_zeros = 19;
       24'b000000000000000000001???: s_div_zeros = 20;
       24'b0000000000000000000001??: s_div_zeros = 21;
       24'b00000000000000000000001?: s_div_zeros = 22;
       24'b000000000000000000000001: s_div_zeros = 23;
       24'b000000000000000000000000: s_div_zeros = 24;
     endcase

   // left-shift the dividend and divisor
   wire [FRAC_WIDTH:0] 		 fracta_lshift_intermediate;
   wire [FRAC_WIDTH:0] 		 fractb_lshift_intermediate;
   assign fracta_lshift_intermediate = s_fracta_24 << s_dvd_zeros;
   assign fractb_lshift_intermediate = s_fractb_24 << s_div_zeros;
   
   assign s_dvdnd_50_o = {fracta_lshift_intermediate,26'd0};
   
   assign s_dvsor_27_o = {3'd0,fractb_lshift_intermediate};
   
   always @(posedge clk or posedge rst)
     if (rst)
       begin
	  s_expa_in <= 'd0;
	  s_expb_in <= 'd0;
	  s_exp_10_o <= 'd0;
       end
     else
       begin
	  // pre-calculate exponent
	  s_expa_in <= {2'd0,s_expa} + {9'd0,s_opa_dn};
	  s_expb_in <= {2'd0,s_expb} + {9'd0,s_opb_dn};	
	  s_exp_10_o <= s_expa_in - s_expb_in + 10'b0001111111 - 
			{4'd0,s_dvd_zeros} + {4'd0,s_div_zeros};
       end

   
endmodule // fpu_pre_norm_div

