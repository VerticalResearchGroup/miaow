/////////////////////////////////////////////////////////////////////
////                                                             ////
////  fpu_post_norm_intfloat_conv                         ////
////  Floating Point Post Normalisation Unit                     ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
//// Modified by Julius Baxter, July, 2010                       ////
////             julius.baxter@orsoc.se                          ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2000 Rudolf Usselmann                         ////
////                    rudi@asics.ws                            ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////


module fpu_post_norm_intfloat_conv 
  ( 
    clk, rst, fpu_op, opas, sign, rmode, fract_in, 
    exp_in, opa_dn, opa_nan, opa_inf, opb_dn,  out,
    ine, inv, overflow, underflow, f2i_out_sign
    );
   input		clk;
   input 		rst;
   
   input [2:0] 		fpu_op;
   input		opas;
   input		sign;
   input [1:0] 		rmode;
   input [47:0] 	fract_in;
   input [7:0] 		exp_in;
   input		opa_dn, opb_dn;
   input 		opa_nan, opa_inf;
   
   output [30:0] 	out;
   output		ine, inv;
   output		overflow, underflow;
   output		f2i_out_sign;

   ////////////////////////////////////////////////////////////////////////
   //
   // Local Wires and registers
   //

   /*wire*/ reg [22:0] 		fract_out;
   /*wire*/reg [7:0] 		exp_out;
   wire [30:0] 		out;
   wire 		exp_out1_co, overflow, underflow;
   wire [22:0] 		fract_out_final;
   reg [22:0] 		fract_out_rnd;
   wire [8:0] 		exp_next_mi;
   wire 		dn;
   wire 		exp_rnd_adj;
   wire [7:0] 		exp_out_final;
   reg [7:0] 		exp_out_rnd;
   wire 		op_dn = opa_dn | opb_dn;
   wire 		op_mul = fpu_op[2:0]==3'b010;
   wire 		op_div = fpu_op[2:0]==3'b011;
   wire 		op_i2f = fpu_op[2:0]==3'b100;
   wire 		op_f2i = fpu_op[2:0]==3'b101;
   reg [5:0] 		fi_ldz;

   wire 		g, r, s;
   wire 		round, round2, round2a, round2_fasu, round2_fmul;
   wire [7:0] 		exp_out_rnd0, exp_out_rnd1, exp_out_rnd2, exp_out_rnd2a;
   wire [22:0] 		fract_out_rnd0, fract_out_rnd1, fract_out_rnd2, 
			fract_out_rnd2a;
   wire 		exp_rnd_adj0, exp_rnd_adj2a;
   wire 		r_sign;
   wire 		ovf0, ovf1;
   wire [23:0] 		fract_out_pl1;
   wire [7:0] 		exp_out_pl1, exp_out_mi1;
   wire 		exp_out_00, exp_out_fe, exp_out_ff, exp_in_00, 
			exp_in_ff;
   wire 		exp_out_final_ff, fract_out_7fffff;
   /*wire*/reg [24:0] 		fract_trunc;
   wire [7:0] 		exp_out1;
   wire 		grs_sel;
   wire 		fract_out_00;
   reg 			fract_in_00;
   wire 		shft_co;
   wire [8:0] 		exp_in_pl1, exp_in_mi1;
   wire [47:0] 		fract_in_shftr;
   wire [47:0] 		fract_in_shftl;

   wire [7:0] 		shft2;
   wire [7:0] 		exp_out1_mi1;

   wire [6:0] 		fi_ldz_2a;
   wire [7:0] 		fi_ldz_2;

   wire 		left_right;   
   wire [7:0] 		shift_right;
   wire [7:0] 		shift_left;   
   wire [7:0] 		fasu_shift;

   wire [5:0] 		fi_ldz_mi1;
   wire [5:0] 		fi_ldz_mi22;
   wire [6:0] 		ldz_all;

   wire [7:0] 		f2i_shft;
   wire [55:0] 		exp_f2i_1;
   wire 		f2i_zero, f2i_max;
   wire [7:0] 		f2i_emin;
   wire 		f2i_exp_gt_max ,f2i_exp_lt_min;
   wire [7:0] 		conv_shft;
   wire [7:0] 		exp_i2f, exp_f2i, conv_exp;
   wire 		round2_f2i;

   ////////////////////////////////////////////////////////////////////////
   //
   // Normalize and Round Logic
   //

   // ---------------------------------------------------------------------
   // Count Leading zeros in fraction

   always @(/*fract_in*/ posedge clk or posedge rst)
     if (rst)
       fi_ldz <= 0;
     else
       casez(fract_in)	// synopsys full_case parallel_case
	 48'b1???????????????????????????????????????????????: fi_ldz <=  1;
	 48'b01??????????????????????????????????????????????: fi_ldz <=  2;
	 48'b001?????????????????????????????????????????????: fi_ldz <=  3;
	 48'b0001????????????????????????????????????????????: fi_ldz <=  4;
	 48'b00001???????????????????????????????????????????: fi_ldz <=  5;
	 48'b000001??????????????????????????????????????????: fi_ldz <=  6;
	 48'b0000001?????????????????????????????????????????: fi_ldz <=  7;
	 48'b00000001????????????????????????????????????????: fi_ldz <=  8;
	 48'b000000001???????????????????????????????????????: fi_ldz <=  9;
	 48'b0000000001??????????????????????????????????????: fi_ldz <=  10;
	 48'b00000000001?????????????????????????????????????: fi_ldz <=  11;
	 48'b000000000001????????????????????????????????????: fi_ldz <=  12;
	 48'b0000000000001???????????????????????????????????: fi_ldz <=  13;
	 48'b00000000000001??????????????????????????????????: fi_ldz <=  14;
	 48'b000000000000001?????????????????????????????????: fi_ldz <=  15;
	 48'b0000000000000001????????????????????????????????: fi_ldz <=  16;
	 48'b00000000000000001???????????????????????????????: fi_ldz <=  17;
	 48'b000000000000000001??????????????????????????????: fi_ldz <=  18;
	 48'b0000000000000000001?????????????????????????????: fi_ldz <=  19;
	 48'b00000000000000000001????????????????????????????: fi_ldz <=  20;
	 48'b000000000000000000001???????????????????????????: fi_ldz <=  21;
	 48'b0000000000000000000001??????????????????????????: fi_ldz <=  22;
	 48'b00000000000000000000001?????????????????????????: fi_ldz <=  23;
	 48'b000000000000000000000001????????????????????????: fi_ldz <=  24;
	 48'b0000000000000000000000001???????????????????????: fi_ldz <=  25;
	 48'b00000000000000000000000001??????????????????????: fi_ldz <=  26;
	 48'b000000000000000000000000001?????????????????????: fi_ldz <=  27;
	 48'b0000000000000000000000000001????????????????????: fi_ldz <=  28;
	 48'b00000000000000000000000000001???????????????????: fi_ldz <=  29;
	 48'b000000000000000000000000000001??????????????????: fi_ldz <=  30;
	 48'b0000000000000000000000000000001?????????????????: fi_ldz <=  31;
	 48'b00000000000000000000000000000001????????????????: fi_ldz <=  32;
	 48'b000000000000000000000000000000001???????????????: fi_ldz <=  33;
	 48'b0000000000000000000000000000000001??????????????: fi_ldz <=  34;
	 48'b00000000000000000000000000000000001?????????????: fi_ldz <=  35;
	 48'b000000000000000000000000000000000001????????????: fi_ldz <=  36;
	 48'b0000000000000000000000000000000000001???????????: fi_ldz <=  37;
	 48'b00000000000000000000000000000000000001??????????: fi_ldz <=  38;
	 48'b000000000000000000000000000000000000001?????????: fi_ldz <=  39;
	 48'b0000000000000000000000000000000000000001????????: fi_ldz <=  40;
	 48'b00000000000000000000000000000000000000001???????: fi_ldz <=  41;
	 48'b000000000000000000000000000000000000000001??????: fi_ldz <=  42;
	 48'b0000000000000000000000000000000000000000001?????: fi_ldz <=  43;
	 48'b00000000000000000000000000000000000000000001????: fi_ldz <=  44;
	 48'b000000000000000000000000000000000000000000001???: fi_ldz <=  45;
	 48'b0000000000000000000000000000000000000000000001??: fi_ldz <=  46;
	 48'b00000000000000000000000000000000000000000000001?: fi_ldz <=  47;
	 48'b00000000000000000000000000000000000000000000000?: fi_ldz <=  48;
       endcase


   // ---------------------------------------------------------------------
   // Normalize

   wire 		exp_in_80;
   wire 		rmode_00, rmode_01, rmode_10, rmode_11;

   // Misc common signals
   assign exp_in_ff        = &exp_in;
   assign exp_in_00        = !(|exp_in);
   assign exp_in_80	= exp_in[7] & !(|exp_in[6:0]);
   assign exp_out_ff       = &exp_out;
   assign exp_out_00       = !(|exp_out);
   assign exp_out_fe       = &exp_out[7:1] & !exp_out[0];
   assign exp_out_final_ff = &exp_out_final;

   assign fract_out_7fffff = &fract_out;
   assign fract_out_00     = !(|fract_out);
   //assign fract_in_00      = !(|fract_in);
   always @(posedge clk or posedge rst)
     if (rst)
       fract_in_00 <= 1'b0;
     else
       fract_in_00  <= !(|fract_in);

   assign rmode_00 = (rmode==2'b00);
   assign rmode_01 = (rmode==2'b01);
   assign rmode_10 = (rmode==2'b10);
   assign rmode_11 = (rmode==2'b11);

   // Fasu Output will be denormalized ...
   assign dn = !op_mul & !op_div & 
	       (exp_in_00 | (exp_next_mi[8] & !fract_in[47]) );

   // ---------------------------------------------------------------------
   // Fraction Normalization
   parameter	f2i_emax = 8'h9d;

   // Special Signals for f2i
   assign f2i_emin = rmode_00 ? 8'h7e : 8'h7f;
   
   assign f2i_exp_gt_max = (exp_in > f2i_emax);
   assign f2i_exp_lt_min = (exp_in < f2i_emin);
   
   // Incremented fraction for rounding
   assign fract_out_pl1 = fract_out + 24'd1;

   /*
    assign f2i_zero = (!opas & (exp_in<f2i_emin)) | 
    (opas & (exp_in>f2i_emax)) | 
    (opas & (exp_in<f2i_emin) & (fract_in_00 | !rmode_11));

    assign f2i_max = (!opas & (exp_in>f2i_emax)) | 
    (opas & (exp_in<f2i_emin) & !fract_in_00 & rmode_11);
    */
   // Zero when :
   // a) too small exp. and positive sign - result will be 0
   // b) too big exp. and negative sign - result will be largest possible -int
   // c) -infinity: largest possible -int
   // d) -0.0: give positive 0
   assign f2i_zero = (
		      ( (f2i_exp_lt_min & (opas & (!rmode_11 | fract_in_00))) |
			(f2i_exp_lt_min & !opas) |
			(f2i_exp_gt_max & opas) )
		      & !(&exp_in)
		      ) |
		     // -inf case
		     (opa_inf & opas) |
		       // -0.0 case
		       (fract_in_00 & exp_in_00);

   // Maximum :
   // a) too big exp and positive sign - result will be maximum int.
   // b) rounding negative down and less than minimum expon. for int = -1
   // c) +/- NaN or +inf - result will be maximum int
   // d) disabled when the -0.0 case comes up
   assign f2i_max = (
		     ( ((!opas & f2i_exp_gt_max) | 
			(f2i_exp_lt_min & !fract_in_00 & rmode_11 & opas)) 
		       & !(&exp_in)) |
		     // Either +/- NaN, or +inf
		     (opa_nan | (opa_inf & !opas))) &
		    // .. and NOT -0.0( 0x80000000)
                    !(opas & fract_in_00 & exp_in_00);
   
   // Claculate various shifting options
   assign f2i_shft  = exp_in-8'h7d;

   assign conv_shft = op_f2i ? f2i_shft : {2'h0, fi_ldz};

   assign fract_in_shftl   = (|conv_shft[7:6] | (f2i_zero & op_f2i)) ? 
			     0 : fract_in<<conv_shft[5:0];

   // Final fraction output
   always @(posedge clk or posedge rst)
     if (rst)
       begin
	  fract_out <= 1'b0;
	  fract_trunc <= 'd0;
       end
     else
       {fract_out,fract_trunc} <= fract_in_shftl;
   

   // ---------------------------------------------------------------------
   // Exponent Normalization

   assign fi_ldz_mi1    = fi_ldz - 6'd1;
   assign fi_ldz_mi22   = fi_ldz - 6'd22;
   assign exp_out_pl1   = exp_out + 8'd1;
   assign exp_out_mi1   = exp_out - 8'd1;
   assign exp_in_pl1    = exp_in  + 9'd1;	// 9 bits - includes carry out
   assign exp_in_mi1    = exp_in  - 9'd1;	// 9 bits - includes carry out
   assign exp_out1_mi1  = exp_out1 - 8'd1;

   assign exp_next_mi  = exp_in_pl1 - 
			 {3'd0,fi_ldz_mi1}; // 9 bits - includes carry out

   assign {exp_out1_co, exp_out1} = fract_in[47] ? exp_in_pl1 : exp_next_mi;
   
   // Only ever force positive if:
   // i) It's a NaN
   // ii) It's zero and not -inf
   // iii) We've rounded to 0 (both fract and exp out are 0 and not forced)
   // Force to 1 (negative) when have negative sign with too big exponent
   assign f2i_out_sign = (opas & (exp_in>f2i_emax) & f2i_zero) ?
			 1'b1 : opa_nan | (f2i_zero & !f2i_max & !(opa_inf & opas))
			   | (!(|out) & !f2i_zero)
			     ? 
			 1'b0 :opas;

   assign exp_i2f   = fract_in_00 ? (opas ? 8'h9e : 1'b0) : (8'h9e-{2'd0,fi_ldz});
   assign exp_f2i_1 = {{8{fract_in[47]}}, fract_in }<<f2i_shft;
   assign exp_f2i   = f2i_zero ? 1'b0 : f2i_max ? 8'hff : exp_f2i_1[55:48];
   assign conv_exp  = op_f2i ? exp_f2i : exp_i2f;

   //assign exp_out = conv_exp;
   always @(posedge clk or posedge rst)
     if (rst)
       exp_out <= 'd0;
     else
       exp_out <= conv_exp;
   

   assign ldz_all   = {1'b0,fi_ldz};
   assign fi_ldz_2a = 6'd23 - fi_ldz;
   assign fi_ldz_2  = {fi_ldz_2a[6], fi_ldz_2a[6:0]};


   // ---------------------------------------------------------------------
   // Round

   // Extract rounding (GRS) bits
   assign g = fract_out[0];
   assign r = fract_trunc[24];
   assign s = |fract_trunc[23:0];

   // Round to nearest even
   assign round = (g & r) | (r & s) ;
   assign {exp_rnd_adj0, fract_out_rnd0} = round ? 
					   fract_out_pl1 : {1'b0, fract_out};
   
   assign exp_out_rnd0 =  exp_rnd_adj0 ? exp_out_pl1 : exp_out;
   
   assign ovf0 = exp_out_final_ff & !rmode_01 & !op_f2i;

   // round to zero
   // Added detection of sign and rounding up in case of negative ftoi! - JPB
   assign fract_out_rnd1 = (exp_out_ff  & !dn & !op_f2i) ? 
			   23'h7fffff : 
			   (op_f2i & (|fract_trunc) & opas) ? 
			   fract_out_pl1[22:0] : fract_out ;

   assign exp_out_rnd1 = (g & r & s & exp_in_ff) ? 
			 exp_next_mi[7:0] : (exp_out_ff & !op_f2i) ? 
			 exp_in : 
			 (op_f2i & opas & (|fract_trunc) & fract_out_pl1[23]) ? 
			 exp_out_pl1: exp_out;

   assign ovf1 = exp_out_ff & !dn;

   // round to +inf (UP) and -inf (DOWN)
   assign r_sign = sign;

   assign round2a = !exp_out_fe | !fract_out_7fffff | 
		    (exp_out_fe & fract_out_7fffff);

   assign round2_fasu = ((r | s) & !r_sign) & (!exp_out[7] | 
					       (exp_out[7] & round2a));

   assign round2_f2i = rmode_10 & 
		       (( |fract_in[23:0] & !opas & (exp_in<8'h80 )) | 
			(|fract_trunc));
   
   assign round2 = op_f2i ? round2_f2i : round2_fasu;

   assign {exp_rnd_adj2a, fract_out_rnd2a} = round2 ? fract_out_pl1 : 
					     {1'b0, fract_out};
   
   assign exp_out_rnd2a  = exp_rnd_adj2a ?  exp_out_pl1 : exp_out;

   assign fract_out_rnd2 = (r_sign & exp_out_ff & !op_div & !dn & !op_f2i) ? 
			   23'h7fffff : fract_out_rnd2a;
   
   assign exp_out_rnd2   = (r_sign & exp_out_ff & !op_f2i) ? 
			   8'hfe      : exp_out_rnd2a;


   // Choose rounding mode
   always @(rmode or exp_out_rnd0 or exp_out_rnd1 or exp_out_rnd2)
     case(rmode)	// synopsys full_case parallel_case
       0: exp_out_rnd = exp_out_rnd0;
       1: exp_out_rnd = exp_out_rnd1;
       2,3: exp_out_rnd = exp_out_rnd2;
     endcase

   always @(rmode or fract_out_rnd0 or fract_out_rnd1 or fract_out_rnd2)
     case(rmode)	// synopsys full_case parallel_case
       0: fract_out_rnd = fract_out_rnd0;
       1: fract_out_rnd = fract_out_rnd1;
       2,3: fract_out_rnd = fract_out_rnd2;
     endcase
   
   // ---------------------------------------------------------------------
   // Final Output Mux
   // Fix Output for denormalized and special numbers

   assign fract_out_final = ovf0 ? 23'h0 :
			    (f2i_max & op_f2i) ? 23'h7fffff :
			    fract_out_rnd;
   
   assign exp_out_final = (f2i_max & op_f2i) ? 8'hff :  exp_out_rnd;

   // ---------------------------------------------------------------------
   // Pack Result
   
   assign out = {exp_out_final, fract_out_final};
   
   // ---------------------------------------------------------------------
   // Exceptions
   
   
   assign underflow = (!fract_in[47] & exp_out1_co) & !dn;
   
   
   assign overflow  = ovf0 | ovf1;
   
   wire 		f2i_ine;
   wire 		exp_in_lt_half = (exp_in<8'h80);
   
   assign f2i_ine = (f2i_zero & !fract_in_00 & !opas) |
		    (|fract_trunc) |
		    (f2i_zero & exp_in_lt_half  & opas & !fract_in_00) |
		    (f2i_max & rmode_11 & (exp_in<8'h80));

   assign ine =	op_f2i ? f2i_ine :
	       op_i2f ? (|fract_trunc) :
	       ((r & !dn) | (s & !dn) );

   assign inv = op_f2i & (exp_in > f2i_emax);
   
   

endmodule // fpu_post_norm_intfloat_conv

