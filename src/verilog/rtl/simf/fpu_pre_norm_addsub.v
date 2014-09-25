//////////////////////////////////////////////////////////////////////
////                                                              ////
////  fpu_pre_norm_addsub                                  ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://opencores.org/project,or1k                           ////
////                                                              ////
////  Description                                                 ////
////  pre-normalization entity for the addition/subtraction unit  ////
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

module fpu_pre_norm_addsub (

			    clk,
 			    rst,
			    opa_i,		
			    opb_i,		
			    fracta_28_o, 
			    fractb_28_o,
			    exp_o
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
   // carry(1) & hidden(1) & fraction(23) & guard(1) & round(1) & sticky(1)
   output reg [FRAC_WIDTH+4:0] fracta_28_o;
   output reg [FRAC_WIDTH+4:0] fractb_28_o;
   output reg [EXP_WIDTH-1:0]  exp_o;
   
   reg [EXP_WIDTH-1 : 0]       s_exp_o ;
   wire [FRAC_WIDTH+4 : 0]     s_fracta_28_o, s_fractb_28_o ;
   wire [EXP_WIDTH-1 : 0]      s_expa;
   wire [EXP_WIDTH-1 : 0]      s_expb ;
   wire [FRAC_WIDTH-1 : 0]     s_fracta;
   wire [FRAC_WIDTH-1 : 0]     s_fractb ;
   wire [FRAC_WIDTH+4 : 0]     s_fracta_28;

   wire [FRAC_WIDTH+4 : 0]     s_fractb_28 ;
   
   wire [FRAC_WIDTH+4 : 0]     s_fract_sm_28;
   wire [FRAC_WIDTH+4 : 0]     s_fract_shr_28 ;
   
   reg [EXP_WIDTH-1 : 0]       s_exp_diff ;
   reg [5 : 0] 		       s_rzeros ;
   wire 		       s_expa_eq_expb;
   wire 		       s_expa_gt_expb;
   wire 		       s_fracta_1;
   wire 		       s_fractb_1;
   wire 		       s_op_dn,s_opa_dn, s_opb_dn;
   wire [1 : 0] 	       s_mux_diff ;
   wire 		       s_mux_exp;
   wire 		       s_sticky;


   assign s_expa = opa_i[30:23];
   assign s_expb = opb_i[30:23];
   assign s_fracta = opa_i[22:0];
   assign s_fractb = opb_i[22:0];
   
   always @(posedge clk or posedge rst)
     if (rst)
       begin
	  exp_o <= 'd0;
	  fracta_28_o <= 'd0;
	  fractb_28_o <= 'd0;
       end
     else
       begin
	  exp_o <= s_exp_o;
	  fracta_28_o <= s_fracta_28_o;
	  fractb_28_o <= s_fractb_28_o;	
       end
   
   assign s_expa_eq_expb = (s_expa == s_expb);
   
   assign s_expa_gt_expb = (s_expa > s_expb);
   
   // '1' if fraction is not zero
   assign s_fracta_1 = |s_fracta;
   assign s_fractb_1 = |s_fractb; 
   
   // opa or Opb is denormalized
   assign s_opa_dn = !(|s_expa);
   assign s_opb_dn = !(|s_expb);
   assign s_op_dn = s_opa_dn | s_opb_dn; 

   // Output larger exponent
   assign s_mux_exp = s_expa_gt_expb;
   
   always @(posedge clk or posedge rst)
     if (rst)
       s_exp_o <= 'd0;
     else
       s_exp_o <= s_mux_exp ? s_expa : s_expb;
   
   // convert to an easy to handle floating-point format
   assign s_fracta_28 = s_opa_dn ? 
			{2'b00, s_fracta, 3'b000} : {2'b01, s_fracta, 3'b000};
   assign s_fractb_28 = s_opb_dn ? 
			{2'b00, s_fractb, 3'b000} : {2'b01, s_fractb, 3'b000};
   
   assign s_mux_diff = {s_expa_gt_expb, s_opa_dn ^ s_opb_dn};
   
   // calculate howmany postions the fraction will be shifted
   always @(posedge clk or posedge rst)
     if (rst)
       s_exp_diff <= 'd0;
     else
       begin
	  case(s_mux_diff)
	    2'b00: s_exp_diff <= s_expb - s_expa;
	    2'b01: s_exp_diff <= s_expb - (s_expa + 8'd1);
	    2'b10: s_exp_diff <= s_expa - s_expb;
	    2'b11: s_exp_diff <= s_expa - (s_expb + 8'd1);
	  endcase
       end
   
   assign s_fract_sm_28 =  s_expa_gt_expb ? s_fractb_28 : s_fracta_28;
   
   // shift-right the fraction if necessary
   assign s_fract_shr_28 = s_fract_sm_28 >> s_exp_diff;

   // count the zeros from right to check if result is inexact
   always @(s_fract_sm_28)
     casez(s_fract_sm_28) // synopsys full_case parallel_case
       28'b???????????????????????????1: s_rzeros = 0;
       28'b??????????????????????????10: s_rzeros = 1;
       28'b?????????????????????????100: s_rzeros = 2;
       28'b????????????????????????1000: s_rzeros = 3;
       28'b???????????????????????10000: s_rzeros = 4;
       28'b??????????????????????100000: s_rzeros = 5;
       28'b?????????????????????1000000: s_rzeros = 6;
       28'b????????????????????10000000: s_rzeros = 7;
       28'b???????????????????100000000: s_rzeros = 8;
       28'b??????????????????1000000000: s_rzeros = 9;
       28'b?????????????????10000000000: s_rzeros = 10;
       28'b????????????????100000000000: s_rzeros = 11;
       28'b???????????????1000000000000: s_rzeros = 12;
       28'b??????????????10000000000000: s_rzeros = 13;
       28'b?????????????100000000000000: s_rzeros = 14;
       28'b????????????1000000000000000: s_rzeros = 15;
       28'b???????????10000000000000000: s_rzeros = 16;
       28'b??????????100000000000000000: s_rzeros = 17;
       28'b?????????1000000000000000000: s_rzeros = 18;
       28'b????????10000000000000000000: s_rzeros = 19;
       28'b???????100000000000000000000: s_rzeros = 20;
       28'b??????1000000000000000000000: s_rzeros = 21;
       28'b?????10000000000000000000000: s_rzeros = 22;
       28'b????100000000000000000000000: s_rzeros = 23;
       28'b???1000000000000000000000000: s_rzeros = 24;
       28'b??10000000000000000000000000: s_rzeros = 25;
       28'b?100000000000000000000000000: s_rzeros = 26;
       28'b1000000000000000000000000000: s_rzeros = 27;
       28'b0000000000000000000000000000: s_rzeros = 28;
     endcase // casex (s_fract_sm_28)
   
   assign s_sticky = (s_exp_diff > {2'b00,s_rzeros}) & (|s_fract_sm_28);
   
   assign s_fracta_28_o = s_expa_gt_expb ?
			  s_fracta_28 :
			  {s_fract_shr_28[27:1],(s_sticky|s_fract_shr_28[0])};
   
   assign s_fractb_28_o =  s_expa_gt_expb ? 
			   {s_fract_shr_28[27:1],(s_sticky|s_fract_shr_28[0])} :
			   s_fractb_28;

endmodule // fpu_pre_norm_addsub


