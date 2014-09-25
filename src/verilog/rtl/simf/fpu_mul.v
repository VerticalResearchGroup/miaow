//////////////////////////////////////////////////////////////////////
////                                                              ////
////  fpu_mul                                              ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://opencores.org/project,or1k                           ////
////                                                              ////
////  Description                                                 ////
////  Serial multiplication entity for the multiplication unit    ////
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

module fpu_mul 
  (  
     clk,
     rst,
     fracta_i,
     fractb_i,
     signa_i,
     signb_i,
     start_i,
     fract_o,
     sign_o,
     ready_o
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
   
   input [FRAC_WIDTH:0] fracta_i;   
   input [FRAC_WIDTH:0] fractb_i;   
   input 		signa_i;
   input 		signb_i;
   input 		start_i;
   output reg [2*FRAC_WIDTH+1:0] fract_o;
   output reg 			 sign_o;
   output reg 			 ready_o;
   
   parameter t_state_waiting = 1'b0,
	       t_state_busy = 1'b1;

   reg [47:0] 			 s_fract_o;
   reg [23:0] 			 s_fracta_i;
   reg [23:0] 			 s_fractb_i;
   reg 				 s_signa_i, s_signb_i;
   wire 			 s_sign_o;
   reg 				 s_start_i;
   reg 				 s_ready_o;
   reg 				 s_state;
   reg [4:0] 			 s_count;
   wire [23:0] 			 s_tem_prod;

   // Input Register
   always @(posedge clk or posedge rst) 
     if (rst)
       begin 
	  s_fracta_i <= 'd0;
	  s_fractb_i <= 'd0;
	  s_signa_i <= 1'b0;
	  s_signb_i <= 1'b0;
	  s_start_i <= 1'b0;
       end
     else 
       begin
	  s_fracta_i <= fracta_i;
	  s_fractb_i <= fractb_i;
	  s_signa_i<= signa_i;
	  s_signb_i<= signb_i;
	  s_start_i <= start_i;
       end
   
   // Output Register
   always @(posedge clk or posedge rst) 
     if (rst) 
       begin
	  fract_o <= 'd0;
	  sign_o <= 1'b0;
	  ready_o <= 1'b0;
       end
     else 
       begin
	  fract_o <= s_fract_o;
	  sign_o <= s_sign_o;	
	  ready_o <= s_ready_o;
       end

   assign s_sign_o = signa_i ^ signb_i;

   // FSM
   always @(posedge clk or posedge rst) 
     if (rst)
       begin
	  s_state <= t_state_waiting;
	  s_count <= 0;
       end
     else 
       if (s_start_i)
	 begin
	    s_state <= t_state_busy;
	    s_count <= 0;
	 end
       else if (s_count==23)
	 begin
	    s_state <= t_state_waiting;
	    s_ready_o <= 1;
	    s_count <=0;
	 end
       else if (s_state==t_state_busy)
	 s_count <= s_count + 1;
       else
	 begin
	    s_state <= t_state_waiting;
	    s_ready_o <= 0;
	 end
   
   assign s_tem_prod[0] = s_fracta_i[0] & s_fractb_i[s_count];
   assign s_tem_prod[1] = s_fracta_i[1] & s_fractb_i[s_count];
   assign s_tem_prod[2] = s_fracta_i[2] & s_fractb_i[s_count];
   assign s_tem_prod[3] = s_fracta_i[3] & s_fractb_i[s_count];
   assign s_tem_prod[4] = s_fracta_i[4] & s_fractb_i[s_count];
   assign s_tem_prod[5] = s_fracta_i[5] & s_fractb_i[s_count];
   assign s_tem_prod[6] = s_fracta_i[6] & s_fractb_i[s_count];
   assign s_tem_prod[7] = s_fracta_i[7] & s_fractb_i[s_count];
   assign s_tem_prod[8] = s_fracta_i[8] & s_fractb_i[s_count];
   assign s_tem_prod[9] = s_fracta_i[9] & s_fractb_i[s_count];
   assign s_tem_prod[10] = s_fracta_i[10] & s_fractb_i[s_count];
   assign s_tem_prod[11] = s_fracta_i[11] & s_fractb_i[s_count];
   assign s_tem_prod[12] = s_fracta_i[12] & s_fractb_i[s_count];
   assign s_tem_prod[13] = s_fracta_i[13] & s_fractb_i[s_count];
   assign s_tem_prod[14] = s_fracta_i[14] & s_fractb_i[s_count];
   assign s_tem_prod[15] = s_fracta_i[15] & s_fractb_i[s_count];
   assign s_tem_prod[16] = s_fracta_i[16] & s_fractb_i[s_count];
   assign s_tem_prod[17] = s_fracta_i[17] & s_fractb_i[s_count];
   assign s_tem_prod[18] = s_fracta_i[18] & s_fractb_i[s_count];
   assign s_tem_prod[19] = s_fracta_i[19] & s_fractb_i[s_count];
   assign s_tem_prod[20] = s_fracta_i[20] & s_fractb_i[s_count];
   assign s_tem_prod[21] = s_fracta_i[21] & s_fractb_i[s_count];
   assign s_tem_prod[22] = s_fracta_i[22] & s_fractb_i[s_count];
   assign s_tem_prod[23] = s_fracta_i[23] & s_fractb_i[s_count];
   
   wire [47:0] v_prod_shl;
   assign v_prod_shl = {24'd0,s_tem_prod} << s_count[4:0];

   always @(posedge clk or posedge rst) 
     if (rst)
       s_fract_o <= 'd0; 
     else
       if (s_state==t_state_busy)
	 begin
	    if (|s_count)
	      s_fract_o <= v_prod_shl + s_fract_o;
	    else
	      s_fract_o <= v_prod_shl;
	 end
   
endmodule // fpu_mul

