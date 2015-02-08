module cu_handler (/*AUTOARG*/
   // Outputs
   dispatch2cu_wf_dispatch, dispatch2cu_wf_tag_dispatch,
   wg_done_valid, wg_done_wg_id,
   // Inputs
   clk, rst, wg_alloc_en, wg_alloc_wg_id, wg_alloc_wf_count,
   cu2dispatch_wf_done_i, cu2dispatch_wf_tag_done_i, wg_done_ack
   ) ;

   parameter WF_COUNT_WIDTH = 4;
   parameter WG_ID_WIDTH = 6;
   parameter WG_SLOT_ID_WIDTH = 6;
   parameter NUMBER_WF_SLOTS = 40;

   parameter TAG_WIDTH = 15;
   
   input clk, rst;
   
   input 	wg_alloc_en;
   input [WG_ID_WIDTH-1:0] wg_alloc_wg_id;
   input [WF_COUNT_WIDTH-1:0] wg_alloc_wf_count;

   output 		      dispatch2cu_wf_dispatch;
   output [TAG_WIDTH-1:0]     dispatch2cu_wf_tag_dispatch;
   
   input 			   cu2dispatch_wf_done_i;
   input [TAG_WIDTH-1:0] 	   cu2dispatch_wf_tag_done_i;

   localparam TAG_WF_COUNT_L = 0;
   localparam TAG_WF_COUNT_H = TAG_WF_COUNT_L + WF_COUNT_WIDTH - 1;

   localparam TAG_WG_SLOT_ID_L = TAG_WF_COUNT_H + 1;
   localparam TAG_WG_SLOT_ID_H = TAG_WG_SLOT_ID_L + WG_SLOT_ID_WIDTH - 1;

   
   input 		   wg_done_ack;
   output 		   wg_done_valid;
   output [WG_ID_WIDTH-1:0] wg_done_wg_id;
   
   // On alloc:
   // Get first wf free slot, slot of first wf is slot of cu
   // zero counter, store wf_id and wf_count
   // outpus tag of each cu

   reg [WG_SLOT_ID_WIDTH-1:0] next_free_slot, next_free_slot_comb;
   reg [NUMBER_WF_SLOTS-1:0]  used_slot_bitmap, pending_wg_bitmap;
   reg [2**WF_COUNT_WIDTH-1:0] pending_wf_bitmap[NUMBER_WF_SLOTS-1:0];
   
   reg [WF_COUNT_WIDTH-1:0]   curr_alloc_wf_count;
   localparam [WF_COUNT_WIDTH-1:0] WF_COUNT_ONE = 1;
   
   reg [WG_SLOT_ID_WIDTH-1:0] 	      curr_alloc_wf_slot;

   reg 				      dispatch2cu_wf_dispatch_i;
   reg [TAG_WIDTH-1:0] 		      dispatch2cu_wf_tag_dispatch_i;
   
// Deallocations
   // On dealloc:
   // Look up counter
   // Check if wg finished
   // Notify gpu_interface

   
   reg 				      next_served_dealloc_valid, 
				      next_served_dealloc_valid_comb;
   
   reg [WG_SLOT_ID_WIDTH-1:0] next_served_dealloc, next_served_dealloc_comb;
   
   localparam INFO_RAM_WORD_WIDTH = ( WG_ID_WIDTH +
				      WF_COUNT_WIDTH);
   localparam INFO_RAM_WG_COUNT_L = 0;
   localparam INFO_RAM_WG_COUNT_H = INFO_RAM_WG_COUNT_L + WF_COUNT_WIDTH -1;
   localparam INFO_RAM_WG_ID_L = INFO_RAM_WG_COUNT_H + 1;
   localparam INFO_RAM_WG_ID_H = INFO_RAM_WG_ID_L + WG_ID_WIDTH - 1;
   
   
   reg [WG_SLOT_ID_WIDTH-1:0] curr_dealloc_wg_slot;
   reg [WF_COUNT_WIDTH-1:0] curr_dealloc_wf_counter;
   reg [WG_ID_WIDTH-1:0] curr_dealloc_wf_id;
   
   reg 			 info_ram_rd_en, info_ram_rd_valid;
   wire [INFO_RAM_WORD_WIDTH-1:0] info_ram_rd_reg;

   reg 				  info_ram_wr_en;
   reg [WG_SLOT_ID_WIDTH-1:0] 	  info_ram_wr_addr;
   reg [INFO_RAM_WORD_WIDTH-1:0] info_ram_wr_reg;

   reg 				 wg_done_valid_i;
   reg [WG_ID_WIDTH-1:0] 	 wg_done_wg_id_i;
   
   localparam NUM_ALLOC_ST = 2;
   localparam ST_ALLOC_IDLE = 1<<0;
   localparam ST_ALLOCATING = 1<<1;
   reg [NUM_ALLOC_ST-1:0] 	 alloc_st;
   

   localparam NUM_DEALLOC_ST = 3;
   localparam ST_DEALLOC_IDLE = 1<<0;
   localparam ST_DEALLOC_READ_RAM = 1<<1;
   localparam ST_DEALLOC_PROPAGATE = 1<<2;
   reg [NUM_DEALLOC_ST-1:0] 	 dealloc_st;
   

   function [2**WF_COUNT_WIDTH-1:0] get_wf_mask;
      input [WF_COUNT_WIDTH-1:0] wf_count;
      integer 			 i;
      reg [2**WF_COUNT_WIDTH-1:0] wf_mask;
      
      begin
	 wf_mask = 0;
	 
	 for(i=0; i<2**WF_COUNT_WIDTH; i=i+1) begin
	    if(i>=wf_count) wf_mask[i] = 1'b1;
	    else wf_mask[i] = 1'b0;
	 end

	 get_wf_mask = wf_mask;
      end
   endfunction // WORD_SIZE
   
   ram_2_port
     #(
       // Parameters
       .WORD_SIZE			(INFO_RAM_WORD_WIDTH),
       .ADDR_SIZE			(WG_SLOT_ID_WIDTH),
       .NUM_WORDS			(NUMBER_WF_SLOTS))
   info_ram 
     (
      // Outputs
      .rd_word				(info_ram_rd_reg),
      // Inputs
      .rst				(rst),
      .clk				(clk),
      .wr_en				(info_ram_wr_en),
      .wr_addr				(info_ram_wr_addr),
      .wr_word				(info_ram_wr_reg),
      .rd_en				(info_ram_rd_en),
      .rd_addr				(curr_dealloc_wg_slot));
   
   always @( posedge clk or posedge rst ) begin
      if (rst) begin
	 alloc_st <= ST_ALLOC_IDLE;
	 dealloc_st <= ST_DEALLOC_IDLE;
      
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 curr_alloc_wf_count <= {WF_COUNT_WIDTH{1'b0}};
	 curr_alloc_wf_slot <= {WG_SLOT_ID_WIDTH{1'b0}};
	 curr_dealloc_wg_slot <= {WG_SLOT_ID_WIDTH{1'b0}};
	 dispatch2cu_wf_dispatch_i <= 1'h0;
	 dispatch2cu_wf_tag_dispatch_i <= {TAG_WIDTH{1'b0}};
	 used_slot_bitmap <= {NUMBER_WF_SLOTS{1'b0}};
	 info_ram_rd_en <= 1'h0;
	 info_ram_rd_valid <= 1'h0;
	 info_ram_wr_addr <= {WG_SLOT_ID_WIDTH{1'b0}};
	 info_ram_wr_en <= 1'h0;
	 info_ram_wr_reg <= {INFO_RAM_WORD_WIDTH{1'b0}};
	 next_free_slot <= {WG_SLOT_ID_WIDTH{1'b0}};
	 next_served_dealloc <= {WG_SLOT_ID_WIDTH{1'b0}};
	 next_served_dealloc_valid <= 1'h0;
	 pending_wg_bitmap <= {NUMBER_WF_SLOTS{1'b0}};
	 wg_done_valid_i <= 1'h0;
	 wg_done_wg_id_i <= {WG_ID_WIDTH{1'b0}};
	 // End of automatics
      end
      else begin

	 // Allocation logic
	 info_ram_wr_en <= 1'b0;
	 next_free_slot <= next_free_slot_comb;
	 dispatch2cu_wf_dispatch_i <= 1'b0;

	 case (alloc_st) 
	   ST_ALLOC_IDLE: begin
	      if(wg_alloc_en) begin
		 info_ram_wr_en <= 1'b1;
		 info_ram_wr_addr <= next_free_slot;
		 info_ram_wr_reg <= {wg_alloc_wg_id, wg_alloc_wf_count};
		 curr_alloc_wf_count <= wg_alloc_wf_count;
		 curr_alloc_wf_slot <= next_free_slot;
		 used_slot_bitmap[next_free_slot] <= 1'b1;

		 pending_wf_bitmap[next_free_slot] <= get_wf_mask(wg_alloc_wf_count);
		 
		 alloc_st <= ST_ALLOCATING;
	      end
	   end // case: ST_ALLOC_IDLE
	   
	   
	   ST_ALLOCATING: begin
	      if(curr_alloc_wf_count != 0) begin
		 dispatch2cu_wf_dispatch_i <= 1'b1;
		 // Send the counter just to make sure the cu does not have
		 // two wf with the same tag
		 dispatch2cu_wf_tag_dispatch_i
		   <= {{15-WF_COUNT_WIDTH-WG_SLOT_ID_WIDTH{1'b0}}, 
		       curr_alloc_wf_slot, curr_alloc_wf_count- WF_COUNT_ONE};		   
		 curr_alloc_wf_count <= curr_alloc_wf_count - 1;
	      end
	      else begin
		 alloc_st <= ST_ALLOC_IDLE;
	      end
	   end // case: ST_ALLOCATING
	   
	 endcase // case (alloc_st)

	 // Deallocation logic
	 if(cu2dispatch_wf_done_i) begin
	    pending_wg_bitmap[cu2dispatch_wf_tag_done_i[TAG_WG_SLOT_ID_H:
							TAG_WG_SLOT_ID_L]]
				     <= 1'b1;
	    pending_wf_bitmap
	      [cu2dispatch_wf_tag_done_i[TAG_WG_SLOT_ID_H:
					 TAG_WG_SLOT_ID_L]]
	      [cu2dispatch_wf_tag_done_i[TAG_WF_COUNT_H:
					 TAG_WF_COUNT_L]] <= 1'b1;
	 end
	 
	 next_served_dealloc_valid <= next_served_dealloc_valid_comb;
	 next_served_dealloc <= next_served_dealloc_comb;
	 info_ram_rd_en <= 1'b0;
	 info_ram_rd_valid <= info_ram_rd_en;
	 wg_done_valid_i <= 1'b0;
	 
	 case (dealloc_st) 
	   ST_DEALLOC_IDLE: begin
	      if(next_served_dealloc_valid) begin
		 info_ram_rd_en <= 1'b1;
		 curr_dealloc_wg_slot <= next_served_dealloc;
		 pending_wg_bitmap[next_served_dealloc] <= 1'b0;
		 dealloc_st <= ST_DEALLOC_READ_RAM;
	      end
	   end
	   
	   ST_DEALLOC_READ_RAM: begin
	      if(info_ram_rd_valid) begin
		 // Finished wf
		 if(&pending_wf_bitmap[curr_dealloc_wg_slot]) begin
		    wg_done_valid_i <= 1'b1;
		    wg_done_wg_id_i
		      <= info_ram_rd_reg[INFO_RAM_WG_ID_H:INFO_RAM_WG_ID_L];
		    used_slot_bitmap[curr_dealloc_wg_slot] <= 1'b0;
		    dealloc_st <= ST_DEALLOC_PROPAGATE;
		 end
		 else begin
		    dealloc_st <= ST_DEALLOC_IDLE;
		 end
	      end // if (info_ram_rd_valid)
	   end // case: ST_DEALLOC_DECREM_COUNTER
	   
	   
	   ST_DEALLOC_PROPAGATE: begin
	      if(wg_done_ack) begin
		 dealloc_st <= ST_DEALLOC_IDLE;
	      end
	      else begin
		 wg_done_valid_i <= 1'b1;
	      end
	   end
	 endcase // case (dealloc_st)
	 
      end // else: !if(rst)
   end // always @ ( posedge clk or posedge rst )


   assign dispatch2cu_wf_dispatch = dispatch2cu_wf_dispatch_i;
   assign dispatch2cu_wf_tag_dispatch = dispatch2cu_wf_tag_dispatch_i;

   assign wg_done_valid = wg_done_valid_i;
   assign wg_done_wg_id = wg_done_wg_id_i;
   
   // Block that finds the next served deallocation
   always @ ( /*AUTOSENSE*/pending_wg_bitmap) begin : NEXT_SERVED_DEALLOC_BLOCK
      integer i;
      reg     found_free_slot_valid;
      reg [WG_SLOT_ID_WIDTH-1:0] found_free_slot_id;

      found_free_slot_valid = 1'b0;
      found_free_slot_id = 0;

      for (i=0; i<NUMBER_WF_SLOTS; i= i+1) begin
	 if(pending_wg_bitmap[i] && !found_free_slot_valid) begin
	    found_free_slot_valid = 1'b1;
	    found_free_slot_id = i;
	 end
      end
      
      next_served_dealloc_valid_comb = found_free_slot_valid;
      next_served_dealloc_comb = found_free_slot_id;
   end // block: NEXT_SERVED_DEALLOC_BLOCK
   
   

   // Block that finds next free slot
   always @ ( /*AUTOSENSE*/used_slot_bitmap or next_free_slot) begin : NEXT_FREE_SLOT_BLOCK
      integer i;
      reg     found_free_slot_valid;
      reg [WG_SLOT_ID_WIDTH-1:0] found_free_slot_id;
      
      next_free_slot_comb = next_free_slot;

      found_free_slot_valid = 1'b0;
      found_free_slot_id = 0;
      
      for (i=0; i<NUMBER_WF_SLOTS; i=i+1) begin
	 if(!found_free_slot_valid && !used_slot_bitmap[i]) begin
	    found_free_slot_valid = 1'b1;
	    found_free_slot_id = i;
	 end
      end

      next_free_slot_comb = found_free_slot_id;
   end // block: NEXT_FREE_SLOT_BLOCK
   
      
endmodule // cu_handler
