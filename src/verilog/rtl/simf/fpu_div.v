//////////////////////////////////////////////////////////////////////
////                                                              ////
////  fpu_div                                              ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://opencores.org/project,or1k                           ////
////                                                              ////
////  Description                                                 ////
////  division entity for the division unit                       ////
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

module fpu_div
  (
   clk,
   rst,
   dvdnd_i,
   dvsor_i,
   sign_dvd_i,
   sign_div_i,
   start_i,
   ready_o,
   qutnt_o,
   rmndr_o,
   sign_o,
   div_zero_o
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
   input [2*(FRAC_WIDTH+2)-1:0] dvdnd_i;
   input [FRAC_WIDTH+3:0] 	dvsor_i;
   input 			sign_dvd_i;
   input 			sign_div_i;
   input 			start_i;
   output 			ready_o;
   output [FRAC_WIDTH+3:0] 	qutnt_o;
   output [FRAC_WIDTH+3:0] 	rmndr_o;
   output 			sign_o;
   output 			div_zero_o;
   
   parameter t_state_waiting = 1'b0,
	       t_state_busy = 1'b1;
   
   reg [FRAC_WIDTH+3:0] 	s_qutnt_o;
   reg [FRAC_WIDTH+3:0] 	s_rmndr_o;   
   reg [2*(FRAC_WIDTH+2)-1:0] 	s_dvdnd_i;   
   reg [FRAC_WIDTH+3:0] 	s_dvsor_i;
   reg 				s_sign_dvd_i, s_sign_div_i;
   wire 			s_sign_o;
   wire 			s_div_zero_o;
   reg 				s_start_i;
   reg 				s_ready_o;
   reg 				s_state;
   reg [4:0] 			s_count;
   reg [FRAC_WIDTH+3:0] 	s_dvd;

   // Input Register
   always @(posedge clk or posedge rst)
     if (rst)
       begin
          s_dvdnd_i <= 'd0;
	  s_dvsor_i <= 'd0;
	  s_sign_dvd_i<= 1'b0;
	  s_sign_div_i<= 1'b0;
	  s_start_i <= 1'b0;
       end
     else
       begin
	  s_dvdnd_i <= dvdnd_i;
	  s_dvsor_i <= dvsor_i;
	  s_sign_dvd_i<= sign_dvd_i;
	  s_sign_div_i<= sign_div_i;
	  s_start_i <= start_i;
       end
   
   assign qutnt_o = s_qutnt_o;
   assign rmndr_o = s_rmndr_o;
   assign sign_o = s_sign_o;	
   assign ready_o = s_ready_o;
   assign div_zero_o = s_div_zero_o;

   assign s_sign_o = sign_dvd_i ^ sign_div_i;
   assign s_div_zero_o = !(|s_dvsor_i) & (|s_dvdnd_i);
   

   always @(posedge clk or posedge rst)
     if (rst)
       begin
	  s_state <= t_state_waiting;
	  s_count <= 0;
	  s_ready_o <= 0;
       end
     else
       if (s_start_i)
	 begin
	    s_state <= t_state_busy;
	    s_count <= 26;
	 end
       else if (!(|s_count) & s_state==t_state_busy)
	 begin
	    s_state <= t_state_waiting;
	    s_ready_o <= 1;
	    s_count <=26;
	 end
       else if (s_state==t_state_busy)
	 s_count <= s_count - 1;
       else
	 begin
	    s_state <= t_state_waiting;
	    s_ready_o <= 0;
	 end

   wire [26:0] v_div;
   assign v_div = (s_count==26) ? {3'd0,s_dvdnd_i[49:26]} : s_dvd;
   wire [26:0] v_div_minus_s_dvsor_i;
   assign v_div_minus_s_dvsor_i = v_div - s_dvsor_i;
   

   always @(posedge clk or posedge rst)
     begin
	if (rst)
	  begin
	     s_qutnt_o <= 0;
	     s_rmndr_o <= 0;
	  end
	else
	  if (s_start_i)
	    begin
	       s_qutnt_o <= 0;
	       s_rmndr_o <= 0;
	    end
	  else if (s_state==t_state_busy)
	    begin
	       
	       if (v_div < s_dvsor_i)
		 begin
		    s_qutnt_o[s_count] <= 1'b0;
		    s_dvd <= {v_div[25:0],1'b0};		  
		 end
	       else
		 begin
		    s_qutnt_o[s_count] <= 1'b1;
		    s_dvd <= {v_div_minus_s_dvsor_i[25:0],1'b0};		  
		 end
	       
	       s_rmndr_o <= v_div;
	       
	    end // if (s_state==t_state_busy)
     end // always @ (posedge clk or posedge rst)
   
endmodule // fpu_div

