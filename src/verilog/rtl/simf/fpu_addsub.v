//////////////////////////////////////////////////////////////////////
////                                                              ////
////  fpu_addsub                                                  ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://opencores.org/project,or1k                           ////
////                                                              ////
////  Description                                                 ////
////  addition/subtraction entity for the addition/subtraction    ////
////  unit                                                        ////
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

module fpu_addsub(
		  clk,
		  rst,
		  fpu_op_i,
		  fracta_i,
		  fractb_i,
		  signa_i,
		  signb_i,
		  fract_o,
		  sign_o);

   
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
   
   input fpu_op_i;   
   input [FRAC_WIDTH+4:0] fracta_i;
   input [FRAC_WIDTH+4:0] fractb_i;
   input 		  signa_i;
   input 		  signb_i;
   output reg [FRAC_WIDTH+4:0] fract_o;
   output reg 		       sign_o;
   
   wire [FRAC_WIDTH+4:0]       s_fracta_i;
   wire [FRAC_WIDTH+4:0]       s_fractb_i;
   wire [FRAC_WIDTH+4:0]       s_fract_o;
   wire 		       s_signa_i, s_signb_i, s_sign_o;   
   wire 		       s_fpu_op_i;
   
   wire 		       fracta_gt_fractb;
   wire 		       s_addop;
   
   assign s_fracta_i = fracta_i;
   assign s_fractb_i = fractb_i;
   assign s_signa_i  = signa_i;
   assign s_signb_i  = signb_i;
   assign s_fpu_op_i = fpu_op_i;
   
   always @(posedge clk or posedge rst)
     if (rst)
       begin
	  fract_o <= 'd0;
	  sign_o <= 1'b0;
       end
     else
       begin
	  fract_o <= s_fract_o;
	  sign_o <= s_sign_o;	
       end
   
   assign fracta_gt_fractb = s_fracta_i > s_fractb_i;
   
   // check if its a subtraction or an addition operation
   assign s_addop = ((s_signa_i ^ s_signb_i) & !s_fpu_op_i) |
		    ((s_signa_i ^~ s_signb_i) & s_fpu_op_i);
   
   // sign of result
   assign s_sign_o = ((s_fract_o == 28'd0) & !(s_signa_i & s_signb_i)) ? 1'b0 :
		     (!s_signa_i & (!fracta_gt_fractb & (fpu_op_i^s_signb_i)))|
		     (s_signa_i & (fracta_gt_fractb | (fpu_op_i^s_signb_i)));
   
   // add/substract
   assign s_fract_o = s_addop ?
		      (fracta_gt_fractb ? s_fracta_i - s_fractb_i :
		       s_fractb_i - s_fracta_i) :
		      s_fracta_i + s_fractb_i;
   
   
endmodule // fpu_addsub



