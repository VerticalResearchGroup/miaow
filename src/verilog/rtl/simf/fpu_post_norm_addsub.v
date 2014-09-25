//////////////////////////////////////////////////////////////////////
////                                                              ////
////  fpu_post_norm_addsub                                 ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://opencores.org/project,or1k                           ////
////                                                              ////
////  Description                                                 ////
////  post-normalization entity for the addition/subtraction unit ////
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

module fpu_post_norm_addsub
  (
   clk,
   rst,
   opa_i,
   opb_i,
   fract_28_i,
   exp_i,
   sign_i,
   fpu_op_i,
   rmode_i,
   output_o,
   ine_o
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

   input     clk;
   input     rst;
   
   input [FP_WIDTH-1:0] opa_i;   
   input [FP_WIDTH-1:0] opb_i;
   input [FRAC_WIDTH+4:0] fract_28_i;   
   input [EXP_WIDTH-1:0]  exp_i;
   input 		  sign_i;
   input 		  fpu_op_i;
   input [1:0] 		  rmode_i;
   output reg [FP_WIDTH-1:0] output_o;
   output reg 		     ine_o;
   
   wire [FP_WIDTH-1:0] 	     s_opa_i;   
   wire [FP_WIDTH-1:0] 	     s_opb_i;
   wire [FRAC_WIDTH+4:0]     s_fract_28_i;	
   wire [EXP_WIDTH-1:0]      s_exp_i;
   wire 		     s_sign_i;
   wire 		     s_fpu_op_i;
   wire [1:0] 		     s_rmode_i;   
   wire [FP_WIDTH-1:0] 	     s_output_o;
   wire 		     s_ine_o;
   wire 		     s_overflow;
   
   wire [5:0] 		     s_zeros;
   reg [5:0] 		     s_shr1;
   reg [5:0] 		     s_shl1;
   wire 		     s_shr2, s_carry;

   wire [9:0] 		     s_exp10;
   reg [EXP_WIDTH:0] 	     s_expo9_1;
   wire [EXP_WIDTH:0] 	     s_expo9_2;
   wire [EXP_WIDTH:0] 	     s_expo9_3;
   
   reg [FRAC_WIDTH+4:0]      s_fracto28_1;
   wire [FRAC_WIDTH+4:0]     s_fracto28_2;
   wire [FRAC_WIDTH+4:0]     s_fracto28_rnd;

   wire 		     s_roundup;
   wire 		     s_sticky;
   
   wire 		     s_zero_fract;	
   wire 		     s_lost;
   wire 		     s_infa, s_infb;
   wire 		     s_nan_in, s_nan_op, s_nan_a, s_nan_b, s_nan_sign;
   
   assign s_opa_i = opa_i;
   assign s_opb_i = opb_i;
   assign s_fract_28_i = fract_28_i;
   assign s_exp_i = exp_i;
   assign s_sign_i = sign_i;
   assign s_fpu_op_i = fpu_op_i;
   assign s_rmode_i = rmode_i;
   
   // Output Register
   always @(posedge clk or posedge rst)
     if (rst)
       begin
	  output_o <= 'd0;
	  ine_o <= 1'b0;
       end
     else
       begin
	  output_o <= s_output_o;
	  ine_o <= s_ine_o;
       end
   //*** Stage 1 ****
   // figure out the output exponent and how much the fraction has to be 
   // shiftd right/left
   
   assign s_carry = s_fract_28_i[27];

   reg [5:0] lzeroes;
   
   always @(s_fract_28_i)
     casez(s_fract_28_i[26:0])	// synopsys full_case parallel_case
       27'b1??????????????????????????: lzeroes = 0;
       27'b01?????????????????????????: lzeroes = 1;
       27'b001????????????????????????: lzeroes = 2;
       27'b0001???????????????????????: lzeroes = 3;
       27'b00001??????????????????????: lzeroes = 4;
       27'b000001?????????????????????: lzeroes = 5;
       27'b0000001????????????????????: lzeroes = 6;
       27'b00000001???????????????????: lzeroes = 7;
       27'b000000001??????????????????: lzeroes = 8;
       27'b0000000001?????????????????: lzeroes = 9;
       27'b00000000001????????????????: lzeroes = 10;
       27'b000000000001???????????????: lzeroes = 11;
       27'b0000000000001??????????????: lzeroes = 12;
       27'b00000000000001?????????????: lzeroes = 13;
       27'b000000000000001????????????: lzeroes = 14;
       27'b0000000000000001???????????: lzeroes = 15;
       27'b00000000000000001??????????: lzeroes = 16;
       27'b000000000000000001?????????: lzeroes = 17;
       27'b0000000000000000001????????: lzeroes = 18;
       27'b00000000000000000001???????: lzeroes = 19;
       27'b000000000000000000001??????: lzeroes = 20;
       27'b0000000000000000000001?????: lzeroes = 21;
       27'b00000000000000000000001????: lzeroes = 22;
       27'b000000000000000000000001???: lzeroes = 23;
       27'b0000000000000000000000001??: lzeroes = 24;
       27'b00000000000000000000000001?: lzeroes = 25;
       27'b000000000000000000000000001: lzeroes = 26;
       27'b000000000000000000000000000: lzeroes = 27;
     endcase

   assign s_zeros = s_fract_28_i[27] ? 6'd0 : lzeroes;
   
   // negative flag & large flag & exp		
   assign s_exp10 = {2'd0,s_exp_i} + {9'd0,s_carry} - {4'd0,s_zeros}; 
   
   always @(posedge clk or posedge rst)
     if (rst)
       begin
	  s_shr1 <= 0;
	  s_shl1 <= 0;
	  s_expo9_1 <= 'd0;
       end
     else
       begin
	  if (s_exp10[9] | !(|s_exp10))
	    begin
	       s_shr1 <= 0;
	       s_expo9_1 <= 9'd1;
	       
	       if (|s_exp_i)
		 s_shl1 <= s_exp_i[5:0] - 6'd1;
	       else
		 s_shl1 <= 0;
	       
	    end
	  else if (s_exp10[8])
	    begin
	       s_shr1 <= 0;
	       s_shl1 <= 0;
	       s_expo9_1 <= 9'b011111111;
	    end
	  else
	    begin
	       s_shr1 <= {5'd0,s_carry};
	       s_shl1 <= s_zeros;
	       s_expo9_1 <= s_exp10[8:0];
	    end // else: !if(s_exp10[8])
       end // always @ (posedge clk or posedge rst)
   
   //-
   // *** Stage 2 ***
   // Shifting the fraction and rounding
   
   always @(posedge clk or posedge rst)
     if (rst)
       s_fracto28_1 <= 'd0;
     else
       if (|s_shr1)
	 s_fracto28_1 <= s_fract_28_i >> s_shr1;
       else 
	 s_fracto28_1 <= s_fract_28_i << s_shl1; 
   
   assign s_expo9_2 = (s_fracto28_1[27:26]==2'b00) ? 
		      s_expo9_1 - 9'd1 : s_expo9_1;
   
   // round
   //check last bit, before and after right-shift
   assign s_sticky = s_fracto28_1[0] | (s_fract_28_i[0] & s_fract_28_i[27]); 
   
   assign s_roundup = s_rmode_i==2'b00 ?
		      // round to nearset even
		      s_fracto28_1[2] & ((s_fracto28_1[1] | s_sticky) | 
					 s_fracto28_1[3]) :
		      s_rmode_i==2'b10 ?
		      // round up
		      (s_fracto28_1[2] | s_fracto28_1[1] | s_sticky) & !s_sign_i:
		      s_rmode_i==2'b11 ?
		      // round down
		      (s_fracto28_1[2] | s_fracto28_1[1] | s_sticky) & s_sign_i :
		      // round to zero(truncate = no rounding)
		      1'b0;
   
   assign s_fracto28_rnd = s_roundup ? 
			   s_fracto28_1+28'b0000_0000_0000_0000_0000_0000_1000 :
			   s_fracto28_1;
   
   // ***Stage 3***
   // right-shift after rounding (if necessary)
   assign s_shr2 = s_fracto28_rnd[27]; 

   assign s_expo9_3 = (s_shr2 &  s_expo9_2!=9'b011111111) ?
		      s_expo9_2 + 9'b000000001 : s_expo9_2;

   assign s_fracto28_2 = s_shr2 ? {1'b0,s_fracto28_rnd[27:1]} : s_fracto28_rnd;

   ////-
   
   assign s_infa = &s_opa_i[30:23];
   assign s_infb = &s_opb_i[30:23];
   
   assign s_nan_a = s_infa &  (|s_opa_i[22:0]);
   assign s_nan_b = s_infb &  (|s_opb_i[22:0]);
   
   assign s_nan_in = s_nan_a | s_nan_b;

   // inf-inf=Nan
   assign s_nan_op = (s_infa & s_infb) & 
		     (s_opa_i[31] ^ (s_fpu_op_i ^ s_opb_i[31]));
   
   assign s_nan_sign = (s_nan_a & s_nan_b) ? s_sign_i :
		       s_nan_a ? 
		       s_opa_i[31] : s_opb_i[31];
   
   // check if result is inexact;
   assign s_lost = (s_shr1[0] & s_fract_28_i[0]) | 
		   (s_shr2 & s_fracto28_rnd[0]) | (|s_fracto28_2[2:0]);

   assign s_ine_o = (s_lost | s_overflow) & !(s_infa | s_infb);
   
   assign s_overflow = s_expo9_3==9'b011111111 & !(s_infa | s_infb);

   // '1' if fraction result is zero
   assign s_zero_fract = s_zeros==27 & !s_fract_28_i[27];
   

   // Generate result
   assign s_output_o = (s_nan_in | s_nan_op) ?
		       {s_nan_sign,QNAN} :
		       (s_infa | s_infb) | s_overflow ?
		       {s_sign_i,INF} :
		       s_zero_fract ?
		       {s_sign_i,ZERO_VECTOR} :
		       {s_sign_i,s_expo9_3[7:0],s_fracto28_2[25:3]};

endmodule // fpu_post_norm_addsub


