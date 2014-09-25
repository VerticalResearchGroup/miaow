//////////////////////////////////////////////////////////////////////
////                                                              ////
////  fpu_post_norm_div                                    ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://opencores.org/project,or1k                           ////
////                                                              ////
////  Description                                                 ////
////  post-normalization entity for the division unit             ////
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


module fpu_post_norm_div
  (
   clk,
   rst,
   opa_i,
   opb_i,
   qutnt_i,
   rmndr_i,
   exp_10_i,
   sign_i,
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
   
   input clk;
   input rst;
   
   input [FP_WIDTH-1:0] opa_i;
   input [FP_WIDTH-1:0] opb_i;
   input [FRAC_WIDTH+3:0] qutnt_i;
   input [FRAC_WIDTH+3:0] rmndr_i;
   input [EXP_WIDTH+1:0]  exp_10_i;
   input 		  sign_i;
   input [1:0] 		  rmode_i;
   output reg [FP_WIDTH-1:0] output_o;
   output reg 		     ine_o;
   
   // input&output register wires
   reg [FP_WIDTH-1:0] 	     s_opa_i;
   reg [FP_WIDTH-1:0] 	     s_opb_i;
   reg [EXP_WIDTH-1:0] 	     s_expa;
   reg [EXP_WIDTH-1:0] 	     s_expb;
   reg [FRAC_WIDTH+3:0]      s_qutnt_i;
   reg [FRAC_WIDTH+3:0]      s_rmndr_i;
   reg [5:0] 		     s_r_zeros;
   reg [EXP_WIDTH+1:0] 	     s_exp_10_i;
   reg 			     s_sign_i;
   reg [1:0] 		     s_rmode_i;
   wire [FP_WIDTH-1:0] 	     s_output_o;
   
   wire 		     s_ine_o, s_overflow;
   wire 		     s_opa_dn, s_opb_dn;
   wire 		     s_qutdn;
   wire [9:0] 		     s_exp_10b;
   reg [5:0] 		     s_shr1;
   reg [5:0] 		     s_shl1;
   wire 		     s_shr2;
   reg [8:0] 		     s_expo1;
   wire [8:0] 		     s_expo2;
   reg [8:0] 		     s_expo3;
   reg [26:0] 		     s_fraco1;
   wire [24:0] 		     s_frac_rnd;
   reg [24:0] 		     s_fraco2;
   wire 		     s_guard, s_round, s_sticky, s_roundup;
   wire 		     s_lost;
   wire 		     s_op_0, s_opab_0, s_opb_0;
   wire 		     s_infa, s_infb;
   wire 		     s_nan_in, s_nan_op, s_nan_a, s_nan_b;
   wire 		     s_inf_result;
   
   always @(posedge clk or posedge rst)
     if (rst)
       begin
	  s_opa_i <= 'd0;
	  s_opb_i <= 'd0;
	  s_expa <= 'd0;
	  s_expb <= 'd0;
	  s_qutnt_i <= 1'b0;
	  s_rmndr_i <= 1'b0;
	  s_exp_10_i <= 1'b0;
	  s_sign_i <= 1'b0;
	  s_rmode_i <= 1'b0;
       end
     else
       begin
	  s_opa_i <= opa_i;
	  s_opb_i <= opb_i;	
	  s_expa <= opa_i[30:23];
	  s_expb <= opb_i[30:23];
	  s_qutnt_i <= qutnt_i;
	  s_rmndr_i <= rmndr_i;
	  s_exp_10_i <= exp_10_i;			
	  s_sign_i <= sign_i;
	  s_rmode_i <= rmode_i;
       end

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
	  ine_o	<= s_ine_o;
       end
   
   // qutnt_i
   // 26 25                    3
   // |  |                     | 
   // h  fffffffffffffffffffffff grs

   //*** Stage 1 ****
   // figure out the exponent and how far the fraction has to be shifted 
   // right or left
   
   assign s_opa_dn = !(|s_expa) & (|opa_i[22:0]);
   assign s_opb_dn = !(|s_expb) & (|opb_i[22:0]);
   
   assign s_qutdn =  !s_qutnt_i[26];

   assign s_exp_10b = s_exp_10_i - {9'd0,s_qutdn};
   
   wire [9:0] v_shr;
   wire [9:0] v_shl;
   
   assign v_shr = (s_exp_10b[9] | !(|s_exp_10b)) ?
		  (10'd1 - s_exp_10b) - {9'd0,s_qutdn} : 6'd0;
   
   assign v_shl = (s_exp_10b[9] | !(|s_exp_10b)) ?
		  10'd0 :
		  s_exp_10b[8] ?   
		  10'd0 : {9'd0,s_qutdn};

   always @(posedge clk or posedge rst)
     if (rst)
       s_expo1 <= 'd0;
     else
       if (s_exp_10b[9] | !(|s_exp_10b))
	 s_expo1 <= 9'd1;
       else
	 s_expo1 <= s_exp_10b[8:0];
   
   always @(posedge clk or posedge rst)
     if (rst)
       s_shr1 <= 'd0;
     else
       s_shr1 <= v_shr[6] ? 6'b111111 : v_shr[5:0];

   always @(posedge clk or posedge rst)
     if (rst)
       s_shl1 <= 'd0;
     else
       s_shl1 <= v_shl[5:0];
   
   // *** Stage 2 ***
   // Shifting the fraction and rounding
   
   // shift the fraction
   always @(posedge clk or posedge rst)
     if (rst)
       s_fraco1 <= 'd0;
     else
       if (|s_shr1)
	 s_fraco1 <= s_qutnt_i >> s_shr1;
       else
	 s_fraco1 <= s_qutnt_i << s_shl1;
   
   assign s_expo2 = s_fraco1[26] ? s_expo1 : s_expo1 - 9'd1;
   
   //s_r_zeros <= count_r_zeros(s_qutnt_i);
   always @(s_qutnt_i)
     casez(s_qutnt_i) // synopsys full_case parallel_case
       27'b??????????????????????????1: s_r_zeros = 0;
       27'b?????????????????????????10: s_r_zeros = 1;
       27'b????????????????????????100: s_r_zeros = 2;
       27'b???????????????????????1000: s_r_zeros = 3;
       27'b??????????????????????10000: s_r_zeros = 4;
       27'b?????????????????????100000: s_r_zeros = 5;
       27'b????????????????????1000000: s_r_zeros = 6;
       27'b???????????????????10000000: s_r_zeros = 7;
       27'b??????????????????100000000: s_r_zeros = 8;
       27'b?????????????????1000000000: s_r_zeros = 9;
       27'b????????????????10000000000: s_r_zeros = 10;
       27'b???????????????100000000000: s_r_zeros = 11;
       27'b??????????????1000000000000: s_r_zeros = 12;
       27'b?????????????10000000000000: s_r_zeros = 13;
       27'b????????????100000000000000: s_r_zeros = 14;
       27'b???????????1000000000000000: s_r_zeros = 15;
       27'b??????????10000000000000000: s_r_zeros = 16;
       27'b?????????100000000000000000: s_r_zeros = 17;
       27'b????????1000000000000000000: s_r_zeros = 18;
       27'b???????10000000000000000000: s_r_zeros = 19;
       27'b??????100000000000000000000: s_r_zeros = 20;
       27'b?????1000000000000000000000: s_r_zeros = 21;
       27'b????10000000000000000000000: s_r_zeros = 22;
       27'b???100000000000000000000000: s_r_zeros = 23;
       27'b??1000000000000000000000000: s_r_zeros = 24;
       27'b?10000000000000000000000000: s_r_zeros = 25;
       27'b100000000000000000000000000: s_r_zeros = 26;
       27'b000000000000000000000000000: s_r_zeros = 27;
     endcase // casex (s_qutnt_i)
   
   assign s_lost = (s_shr1+{5'd0,s_shr2}) > s_r_zeros;
   
   // ***Stage 3***
   // Rounding
   
   assign s_guard = s_fraco1[2];
   assign s_round = s_fraco1[1];
   assign s_sticky = s_fraco1[0] | (|s_rmndr_i);

   assign s_roundup = s_rmode_i==2'b00 ? // round to nearest even
		      s_guard & ((s_round | s_sticky) | s_fraco1[3]) :
		      s_rmode_i==2'b10 ? // round up
		      (s_guard | s_round | s_sticky) & !s_sign_i :
		      s_rmode_i==2'b11 ? // round down
		      (s_guard | s_round | s_sticky) & s_sign_i : 
		      1'b0; // round to zero(truncate = no rounding)

   assign s_frac_rnd = s_roundup ?{1'b0,s_fraco1[26:3]} + 25'd1 : 
		       {1'b0,s_fraco1[26:3]};
   assign s_shr2 = s_frac_rnd[24];

   always @(posedge clk or posedge rst)
     if (rst)
       begin
	  s_expo3 <= 1'b0;
	  s_fraco2 <= 'd0;
       end
     else
       begin
	  s_expo3 <= s_shr2 ? s_expo2 + "1" : s_expo2;
	  s_fraco2 <= s_shr2 ? {1'b0,s_frac_rnd[24:1]} : s_frac_rnd;
       end
   //
   // ***Stage 4****
   // Output
   
   assign s_op_0 = !((|s_opa_i[30:0]) & (|s_opb_i[30:0]));

   assign s_opab_0 = !((|s_opa_i[30:0]) | (|s_opb_i[30:0]));

   assign s_opb_0 = !(|s_opb_i[30:0]);
   
   assign s_infa = &s_expa;
   
   assign s_infb = &s_expb;
   
   assign s_nan_a = s_infa & (|s_opa_i[22:0]);
   
   assign s_nan_b = s_infb & (|s_opb_i[22:0]);
   
   assign s_nan_in = s_nan_a | s_nan_b;
   
   assign s_nan_op = (s_infa & s_infb) | s_opab_0; // 0 / 0, inf / inf

   assign s_inf_result = (&s_expo3[7:0]) | s_expo3[8] | s_opb_0;

   assign s_overflow =  s_inf_result & !(s_infa) & !s_opb_0;
   
   assign s_ine_o =  !s_op_0 & 
		     (s_lost | (|s_fraco1[2:0]) | s_overflow | (|s_rmndr_i));
   
   assign s_output_o = (s_nan_in | s_nan_op) ?
		       {s_sign_i,QNAN} :
		       s_infa  | s_overflow | s_inf_result ?
		       {s_sign_i,INF} :
		       s_op_0 | s_infb ?
		       {s_sign_i,ZERO_VECTOR} :
		       {s_sign_i,s_expo3[7:0],s_fraco2[22:0]};

endmodule // fpu_post_norm_div



