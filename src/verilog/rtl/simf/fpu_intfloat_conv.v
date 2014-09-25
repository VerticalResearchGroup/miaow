/////////////////////////////////////////////////////////////////////
////                                                             ////
////  fpu_intfloat_conv                                   ////
////  Only conversion between 32-bit integer and single          ////
////  precision floating point format                            ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
//// Modified by Julius Baxter, July, 2010                       ////
////             julius.baxter@orsoc.se                          ////
////                                                             ////
//// TODO: Fix bug where 1.0f in round up goes to integer 2      ////
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

/*

 FPU Operations (fpu_op):
 ========================

 0 = 
 1 = 
 2 = 
 3 = 
 4 = int to float
 5 = float to int
 6 =
 7 =

 Rounding Modes (rmode):
 =======================

 0 = round_nearest_even
 1 = round_to_zero
 2 = round_up
 3 = round_down

 */


module fpu_intfloat_conv
  ( 
    clk, rst, rmode, fpu_op, opa, out, snan, ine, inv,
    overflow, underflow, zero
    );
   input		clk;
   input 		rst;
   
   input [1:0] 		rmode;
   input [2:0] 		fpu_op;
   input [31:0] 	opa;
   output [31:0] 	out;
   output		snan;   
   output		ine;
   output 		inv;   
   output 		overflow;
   output 		underflow;   
   output		zero;


   parameter	INF  = 31'h7f800000,
		  QNAN = 31'h7fc00001,
		  SNAN = 31'h7f800001;

   ////////////////////////////////////////////////////////////////////////
   //
   // Local Wires
   //
   reg 			zero;
   reg [31:0] 		opa_r;	// Input operand registers
   reg [31:0] 		out;		// Output register
   reg 			div_by_zero;	// Divide by zero output register
   wire [7:0] 		exp_fasu;	// Exponent output from EQU block
   reg [7:0] 		exp_r;		// Exponent output (registerd)
   wire 		co;		// carry output
   wire [30:0] 		out_d;		// Intermediate final result output
   wire 		overflow_d, underflow_d;// Overflow/Underflow
   reg 			inf, snan, qnan;// Output Registers for INF, S/QNAN
   reg 			ine;		// Output Registers for INE
   reg [1:0] 		rmode_r1, rmode_r2,// Pipeline registers for round mode
			rmode_r3;
   reg [2:0] 		fpu_op_r1, fpu_op_r2,// Pipeline registers for fp 
			// operation
			fpu_op_r3;

   ////////////////////////////////////////////////////////////////////////
     //
   // Input Registers
   //

   always @(posedge clk or posedge rst) 
     if (rst) 
       opa_r <= 'd0; 
     else
       opa_r <=  opa;


   always @(posedge clk or posedge rst) 
     if (rst) 
       rmode_r1 <= 'd0; 
     else
       rmode_r1 <=  rmode;

   always @(posedge clk or posedge rst) 
     if (rst) 
       rmode_r2 <= 'd0; 
     else
       rmode_r2 <=  rmode_r1;

   always @(posedge clk or posedge rst) 
     if (rst) 
       rmode_r3 <= 'd0; 
     else
       rmode_r3 <=  rmode_r2;

   always @(posedge clk or posedge rst) 
     if (rst) 
       fpu_op_r1 <= 1'b0; 
     else
       fpu_op_r1 <=  fpu_op;

   always @(posedge clk or posedge rst) 
     if (rst) 
       fpu_op_r2 <= 1'b0; 
     else
       fpu_op_r2 <=  fpu_op_r1;

   always @(posedge clk or posedge rst) 
     if (rst) 
       fpu_op_r3 <= 1'b0; 
     else
       fpu_op_r3 <=  fpu_op_r2;

   ////////////////////////////////////////////////////////////////////////
   //
   // Exceptions block
   //
   wire 		inf_d, ind_d, qnan_d, snan_d, opa_nan;
   wire 		opa_00;   
   wire 		opa_inf;
   wire 		opa_dn;

   fpu_intfloat_conv_except u0
     (	.clk(clk),
	.rst(rst),
	.opa(opa_r), 
	.opb(),
	.inf(inf_d), 
	.ind(ind_d),
	.qnan(qnan_d), 
	.snan(snan_d),
	.opa_nan(opa_nan), 
	.opb_nan(),
	.opa_00(opa_00),   
	.opb_00(),
	.opa_inf(opa_inf), 
	.opb_inf(),
	.opa_dn(opa_dn), 
	.opb_dn()
	);

   ////////////////////////////////////////////////////////////////////////
   //
   // Pre-Normalize block
   // - Adjusts the numbers to equal exponents and sorts them
   // - determine result sign
   // - determine actual operation to perform (add or sub)
   //

   wire 		nan_sign_d, result_zero_sign_d;
   reg 			sign_fasu_r;
   wire [1:0] 		exp_ovf;
   reg [1:0] 		exp_ovf_r;
   
   // This is all we need from post-norm module for int-float conversion
   reg 			opa_sign_r;
   always @(posedge clk or posedge rst) 
     if (rst) 
       opa_sign_r <= 1'b0;
     else
       opa_sign_r <= opa_r[31];
   
   always @(posedge clk or posedge rst) 
     if (rst) 
       sign_fasu_r <= 1'b0; 
     else
       sign_fasu_r <=  opa_sign_r; //sign_fasu;


   ////////////////////////////////////////////////////////////////////////
   //
   // Normalize Result
   //
   wire 		ine_d;
   wire 		inv_d;   
   wire 		sign_d;
   reg 			sign;
   reg [30:0] 		opa_r1;
   reg [47:0] 		fract_i2f;
   reg 			opas_r1, opas_r2;
   wire 		f2i_out_sign;
   wire [47:0] 		fract_denorm;

   always @(posedge clk or posedge rst) 
     if (rst) 
       exp_r <= 'd0; 
     else  // Exponent must be once cycle delayed
       case(fpu_op_r2)
	 //4:	exp_r <=  0;
	 5:	exp_r <=  opa_r1[30:23];
	 default: exp_r <=  0;
       endcase

   always @(posedge clk or posedge rst) 
     if (rst) 
       opa_r1 <= 'd0; 
     else
       opa_r1 <=  opa_r[30:0];
   
   always @(posedge clk or posedge rst) 
     if (rst) 
       fract_i2f <= 'd0; 
     else
       fract_i2f <=  (fpu_op_r2==5) ?
		     (sign_d ?  1-{24'h00, (|opa_r1[30:23]), opa_r1[22:0]}-1 : 
		      {24'h0, (|opa_r1[30:23]), opa_r1[22:0]})
	 : (sign_d ? 1 - {opa_r1, 17'h01} : {opa_r1, 17'h0});

   assign fract_denorm = fract_i2f;
   
   always @(posedge clk or posedge rst) 
     if (rst) 
       opas_r1 <= 1'b0;
     else
       opas_r1 <=  opa_r[31];

   always @(posedge clk or posedge rst) 
     if (rst) 
       opas_r2 <= 1'b0; 
     else
       opas_r2 <= opas_r1;

   assign sign_d = opa_sign_r; //sign_fasu;

   always @(posedge clk or posedge rst) 
     if (rst)
       sign <= 1'b0;
     else
       sign <=  (rmode_r2==2'h3) ? !sign_d : sign_d;


   // Special case of largest negative integer we can convert to - usually
   // gets picked up as invalid, but really it's not, so deal with it as a
   // special case.
   wire 		f2i_special_case_no_inv;
   assign f2i_special_case_no_inv = (opa == 32'hcf000000);
   

   fpu_post_norm_intfloat_conv u4
     (
      .clk(clk),			// System Clock
      .rst(rst),
      .fpu_op(fpu_op_r3),		// Floating Point Operation
      .opas(opas_r2),			// OPA Sign
      .sign(sign),			// Sign of the result
      .rmode(rmode_r3),		// Rounding mode
      .fract_in(fract_denorm),	// Fraction Input

      .exp_in(exp_r),			// Exponent Input
      .opa_dn(opa_dn),		// Operand A Denormalized
      .opa_nan(opa_nan),
      .opa_inf(opa_inf),
      
      .opb_dn(),		// Operand B Denormalized
      .out(out_d),		// Normalized output (un-registered)
      .ine(ine_d),		// Result Inexact output (un-registered)
      .inv(inv_d),            // Invalid input for f2i operation
      .overflow(overflow_d),	// Overflow output (un-registered)
      .underflow(underflow_d),// Underflow output (un-registered)
      .f2i_out_sign(f2i_out_sign)	// F2I Output Sign
      );

   ////////////////////////////////////////////////////////////////////////
     //
   // FPU Outputs
   //
   reg 			fasu_op_r1, fasu_op_r2;
   wire [30:0] 		out_fixed;
   wire 		output_zero_fasu;
   wire 		overflow_fasu;
   wire 		out_d_00;
   wire 		ine_fasu;
   wire 		underflow_fasu;   


   /*
    always @(posedge clk or posedge rst) if (rst) <= 1'b0; else
    fasu_op_r1 <=  fasu_op;

    always @(posedge clk or posedge rst) if (rst) <= 1'b0; else
    fasu_op_r2 <=  fasu_op_r1;
    */
   // Force pre-set values for non numerical output

   assign out_fixed = (	(qnan_d | snan_d) |
			(ind_d /*& !fasu_op_r2*/))  ? QNAN : INF;

   always @(posedge clk or posedge rst) 
     if (rst)
       out [30:0] <= 'd0; 
     else
       out[30:0] <=  /*((inf_d & (fpu_op_r3!=3'b101)) | snan_d | qnan_d) 
		      & fpu_op_r3!=3'b100 ? out_fixed :*/ out_d;

   assign out_d_00 = !(|out_d);


   always @(posedge clk or posedge rst) 
     if (rst) 
       out[31] <= 1'b0; 
     else
       out[31] <= (fpu_op_r3==3'b101) ? f2i_out_sign : sign_fasu_r; 
   
   
   
   // Exception Outputs
   assign ine_fasu = (ine_d | overflow_d | underflow_d) & 
		     !(snan_d | qnan_d | inf_d);

   always @(posedge clk or posedge rst)
     if (rst)
       ine <= 1'b0;
     else
       ine <= fpu_op_r3[2] ? ine_d : ine_fasu;

   assign overflow = overflow_d & !(snan_d | qnan_d | inf_d);
   assign underflow = underflow_d & !(inf_d | snan_d | qnan_d);

   always @(posedge clk or posedge rst) 
     if (rst) 
       snan <= 1'b0; 
     else
       snan <=  snan_d & (fpu_op_r3==3'b101);  // Only signal sNaN when ftoi

   // Status Outputs   
   assign output_zero_fasu = out_d_00 & !(inf_d | snan_d | qnan_d);

   always @(posedge clk or posedge rst) 
     if (rst) 
       zero <= 1'b0; 
     else
       zero <= 	fpu_op_r3==3'b101 ? out_d_00 & !(snan_d | qnan_d) :
	       output_zero_fasu ;
   
   assign inv = inv_d & !f2i_special_case_no_inv;
   
endmodule // fpu_intfloat_conv
