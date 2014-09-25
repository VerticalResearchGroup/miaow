module barrier_wait
  (/*AUTOARG*/
   // Outputs
   tracemon_barrier_retire_en, fetch_wg_wfid, barrier_wait_arry,
   tracemon_barrier_retire_wf_bitmap, tracemon_barrier_retire_pc,
   // Inputs
   clk, rst, f_decode_valid, f_decode_barrier, f_decode_wfid,
   f_decode_instr_pc, fetch_wg_wgid, fetch_wg_wf_count
   );
   /**
    * Barrier wait has to recognize a barrier instruction
    * from decode and hold the wf that hits the barrier until
    * all wf from that wg are decoded.
    * for each workgroup:
    ** have a list (Bitmap) of wf that hit the barrier
    ** somehow keep track of the number of wf that hit the barrier
    * fore each wf
    ** 1 bit identifies wheather it hit or not the barrier
    ** clear bits from all wf when all wg hit the barrier
    **/

   input clk,rst;
   input f_decode_valid, f_decode_barrier;
   input [`WF_ID_LENGTH-1:0] f_decode_wfid;
   input [31:0] 	     f_decode_instr_pc;
   
   
   input [`WF_ID_LENGTH-1:0] fetch_wg_wgid;
   input [3:0] 		     fetch_wg_wf_count;

   wire 		     decode_barrier_valid;

   output 		     tracemon_barrier_retire_en;
   
   output [`WF_ID_LENGTH-1:0] fetch_wg_wfid;
   output [`WF_PER_CU-1:0]    barrier_wait_arry;
   output [`WF_PER_CU-1:0]    tracemon_barrier_retire_wf_bitmap;

   output [31:0] 	      tracemon_barrier_retire_pc;
   
   wire [`WF_PER_CU-1:0]      curr_wg_wf_waiting, next_curr_wg_wf_waiting;
   
   wire [`WF_PER_WG-1:0]      curr_wg_wf_count, next_curr_wg_wf_count;

   wire [`WF_PER_CU-1:0]      barrier_wait_arry, next_barrier_wait_arry;

   wire 		      all_wf_hit_barrier, first_wf_barrier;

   
   reg [`WF_PER_WG-1:0]       wf_count_mask;

   wire [`WF_PER_CU-1:0]      decode_barrier_valid_decoded;

   assign fetch_wg_wfid = f_decode_wfid;

   // The pc of the retired instruction is always the pc of the currently decoded instruction
   assign tracemon_barrier_retire_pc = f_decode_instr_pc;
      
   reg_40xX_1r_1w #(`WF_PER_CU + `WF_PER_WG) wg_info_reg
     ( 
       .rd_addr(fetch_wg_wgid),
       .rd_data({curr_wg_wf_waiting,curr_wg_wf_count}),
       .wr_en(decode_barrier_valid),
       .wr_addr(fetch_wg_wgid),
       .wr_data({next_curr_wg_wf_waiting,
		 next_curr_wg_wf_count}),

       .clk(clk),
       .rst(rst)
       );

   dff_en  waiting_wf_reg[`WF_PER_CU-1:0]
     (
      .q(barrier_wait_arry),
      .d(next_barrier_wait_arry),
      .en(decode_barrier_valid),
      .clk(clk),
      .rst(rst)
      );
   
   // Calculate next mask for wg
   always @ ( fetch_wg_wf_count ) begin
      case(fetch_wg_wf_count)
	4'd0  : wf_count_mask <= 16'b0000_0000_0000_0001;
	4'd1  : wf_count_mask <= 16'b1111_1111_1111_1111;
	4'd2  : wf_count_mask <= 16'b0111_1111_1111_1111;
	4'd3  : wf_count_mask <= 16'b0011_1111_1111_1111;
	4'd4  : wf_count_mask <= 16'b0001_1111_1111_1111;
	4'd5  : wf_count_mask <= 16'b0000_1111_1111_1111;
	4'd6  : wf_count_mask <= 16'b0000_0111_1111_1111;
	4'd7  : wf_count_mask <= 16'b0000_0011_1111_1111;
	4'd8  : wf_count_mask <= 16'b0000_0001_1111_1111;
	4'd9  : wf_count_mask <= 16'b0000_0000_1111_1111;
	4'd10 : wf_count_mask <= 16'b0000_0000_0111_1111;
	4'd11 : wf_count_mask <= 16'b0000_0000_0011_1111;
	4'd12 : wf_count_mask <= 16'b0000_0000_0001_1111;
	4'd13 : wf_count_mask <= 16'b0000_0000_0000_1111;
	4'd14 : wf_count_mask <= 16'b0000_0000_0000_0111;
	4'd15 : wf_count_mask <= 16'b0000_0000_0000_0011;
      endcase
   end
   
   decoder_6b_40b_en barrier_valid_decoder
     (
      .addr_in(f_decode_wfid),
      .en(decode_barrier_valid),
      .out(decode_barrier_valid_decoded)
      );

   assign decode_barrier_valid = f_decode_valid && f_decode_barrier;

   // Signal when all_wf hit the barrier and when the first
   // wf hit the barrier
   assign all_wf_hit_barrier 
     = ((curr_wg_wf_count == 16'h7fff) | (fetch_wg_wf_count == 4'd1) ) & 
       decode_barrier_valid ? 1'b1 : 1'b0;
   assign first_wf_barrier = (curr_wg_wf_count == 16'h0000)? 1'b1 : 1'b0;
   
   // Reset wf_count if all wf hit the barrier,
   // write the mask if it is the first wf
   // and shift if is another wf
   assign next_curr_wg_wf_count
     = (all_wf_hit_barrier)? 16'h0 :
       (first_wf_barrier)? wf_count_mask :
       {curr_wg_wf_count[`WF_PER_WG-2:0],1'b1};
   
   // Mark all wf of the curr wg waiting
   assign next_curr_wg_wf_waiting
     = (all_wf_hit_barrier)? 40'b0 :
       curr_wg_wf_waiting | decode_barrier_valid_decoded;

   assign tracemon_barrier_retire_wf_bitmap = curr_wg_wf_waiting | decode_barrier_valid_decoded;
   
   // Mark all wf waiting globally
   assign next_barrier_wait_arry
     = (all_wf_hit_barrier)? barrier_wait_arry & (~curr_wg_wf_waiting) :
       barrier_wait_arry | decode_barrier_valid_decoded;
   
   // Assign signals for tracemon
   assign tracemon_barrier_retire_en = all_wf_hit_barrier;
   
endmodule
