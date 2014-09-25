//////////////////////////////////////////////////////////////////////
////                                                              ////
////  fpu_pre_norm_mul                                     ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://opencores.org/project,or1k                           ////
////                                                              ////
////  Description                                                 ////
////  pre-normalization entity for the multiplication unit        ////
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

module fpu_pre_norm_mul (
			 clk,
			 rst,
			 opa_i,
			 opb_i,
			 exp_10_o,
			 fracta_24_o,
			 fractb_24_o
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
   output [FRAC_WIDTH:0]      fracta_24_o;
   output [FRAC_WIDTH:0]      fractb_24_o; 

   
   wire [EXP_WIDTH-1:0]       s_expa;
   wire [EXP_WIDTH-1:0]       s_expb;
   
   wire [FRAC_WIDTH-1:0]      s_fracta;
   wire [FRAC_WIDTH-1:0]      s_fractb;

   wire [EXP_WIDTH+1:0]       s_exp_10_o;
   wire [EXP_WIDTH+1:0]       s_expa_in;
   wire [EXP_WIDTH+1:0]       s_expb_in;
   
   wire 		      s_opa_dn, s_opb_dn;

   assign s_expa = opa_i[30:23];
   assign s_expb = opb_i[30:23];
   assign s_fracta = opa_i[22:0];
   assign s_fractb = opb_i[22:0];
   
   // Output Register
   always @(posedge clk or posedge rst)
     if (rst)
       exp_10_o <= 'd0;
     else
       exp_10_o <= s_exp_10_o;
   
   // opa or opb is denormalized
   assign s_opa_dn = !(|s_expa);
   assign s_opb_dn = !(|s_expb);
   
   assign fracta_24_o = {!s_opa_dn, s_fracta};
   assign fractb_24_o = {!s_opb_dn, s_fractb};
   
   assign s_expa_in = {2'd0, s_expa} + {9'd0, s_opa_dn};
   assign s_expb_in = {2'd0, s_expb} + {9'd0, s_opb_dn};
   
   assign s_exp_10_o = s_expa_in + s_expb_in - 10'b0001111111;		

endmodule // fpu_pre_norm_mul


