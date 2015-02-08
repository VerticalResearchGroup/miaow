module resource_table
  (/*AUTOARG*/
   // Outputs
   res_table_done, cam_biggest_space_size, cam_biggest_space_addr,
   // Inputs
   clk, rst, alloc_res_en, dealloc_res_en, alloc_cu_id, dealloc_cu_id,
   alloc_wg_slot_id, dealloc_wg_slot_id, alloc_res_size,
   alloc_res_start
   );
   parameter CU_ID_WIDTH = 1;
   parameter NUMBER_CU = 2;

   parameter WG_SLOT_ID_WIDTH = 6;
   parameter NUMBER_WF_SLOTS_PER_CU = 40;

   parameter RES_ID_WIDTH = 10;
   parameter NUMBER_RES_SLOTS = 1024;
   

   localparam TABLE_ADDR_WIDTH = WG_SLOT_ID_WIDTH + CU_ID_WIDTH;
   localparam TABLE_ENTRY_WIDTH = 2*WG_SLOT_ID_WIDTH + 2*RES_ID_WIDTH+1;

   input 	 			      clk, rst;
   input 			      alloc_res_en, dealloc_res_en;
   input [CU_ID_WIDTH-1:0] 	      alloc_cu_id, dealloc_cu_id;
   input [WG_SLOT_ID_WIDTH-1:0]       alloc_wg_slot_id, dealloc_wg_slot_id;
   input [RES_ID_WIDTH :0] 	      alloc_res_size;
   input [RES_ID_WIDTH-1 :0] 	      alloc_res_start;
   
   output reg			      res_table_done;
   output [RES_ID_WIDTH :0] 	      cam_biggest_space_size;
   output [RES_ID_WIDTH-1 :0] 	      cam_biggest_space_addr;

   reg 				      alloc_res_en_i, dealloc_res_en_i;
   reg [CU_ID_WIDTH-1:0] 	      alloc_cu_id_i, dealloc_cu_id_i;
   reg [WG_SLOT_ID_WIDTH-1:0] 	      alloc_wg_slot_id_i, dealloc_wg_slot_id_i;
   reg [RES_ID_WIDTH :0] 	      alloc_res_start_i;
   reg [RES_ID_WIDTH-1 :0] 	      alloc_res_size_i;

   function[TABLE_ENTRY_WIDTH-1 : 0] get_new_entry;
      input [RES_ID_WIDTH-1 :0]       res_start;
      input [RES_ID_WIDTH :0] 	      res_size;
      input [WG_SLOT_ID_WIDTH-1:0]    prev_entry, next_entry;

      get_new_entry = {next_entry, prev_entry, res_size, res_start};
   endfunction // if

   // Put here localparams for items location
   localparam RES_STRT_L = 0;
   localparam RES_STRT_H = RES_ID_WIDTH-1;
   localparam RES_SIZE_L = RES_STRT_H+1;
   localparam RES_SIZE_H = RES_SIZE_L+RES_ID_WIDTH;
   localparam PREV_ENTRY_L = RES_SIZE_H+1;
   localparam PREV_ENTRY_H = PREV_ENTRY_L + WG_SLOT_ID_WIDTH-1;
   localparam NEXT_ENTRY_L = PREV_ENTRY_H + 1;
   localparam NEXT_ENTRY_H = NEXT_ENTRY_L + WG_SLOT_ID_WIDTH-1;
   
   function[TABLE_ADDR_WIDTH-1 : 0] calc_table_addr;
      input [CU_ID_WIDTH-1:0] 	      cu_id;
      input [WG_SLOT_ID_WIDTH-1:0]    wg_slot_id;
      calc_table_addr = NUMBER_WF_SLOTS_PER_CU*cu_id + wg_slot_id;
   endfunction // calc_table_addr

   function[WG_SLOT_ID_WIDTH-1 : 0] get_prev_item_wg_slot;
      input [TABLE_ENTRY_WIDTH-1 : 0] table_entry;

      get_prev_item_wg_slot = table_entry[PREV_ENTRY_H:PREV_ENTRY_L];
   endfunction // if
   

   function[WG_SLOT_ID_WIDTH-1 : 0] get_next_item_wg_slot;
      input [TABLE_ENTRY_WIDTH-1 : 0] table_entry;

      get_next_item_wg_slot = table_entry[NEXT_ENTRY_H:NEXT_ENTRY_L];
   endfunction // if

   function[RES_ID_WIDTH-1 : 0] get_res_start;
      input [TABLE_ENTRY_WIDTH-1 : 0] table_entry;

      get_res_start = table_entry[RES_STRT_H:RES_STRT_L];
   endfunction // if

   function[RES_ID_WIDTH : 0] get_res_size;
      input [TABLE_ENTRY_WIDTH-1 : 0] table_entry;

      get_res_size = table_entry[RES_SIZE_H:RES_SIZE_L];
   endfunction // if
   

   function[TABLE_ENTRY_WIDTH-1 : 0] set_prev_item_wg_slot;
      input [WG_SLOT_ID_WIDTH-1:0]    prev_item_wg_slot;
      input [TABLE_ENTRY_WIDTH-1 : 0] table_entry;

      set_prev_item_wg_slot
	= {table_entry[NEXT_ENTRY_H:NEXT_ENTRY_L],
	   prev_item_wg_slot,
	   table_entry[RES_SIZE_H:RES_SIZE_L],
	   table_entry[RES_STRT_H:RES_STRT_L]};
      
   endfunction // if
   
   function[TABLE_ENTRY_WIDTH-1 : 0] set_next_item_wg_slot;
      input [WG_SLOT_ID_WIDTH-1:0]    next_item_wg_slot;
      input [TABLE_ENTRY_WIDTH-1 : 0] table_entry;

      set_next_item_wg_slot
	= {next_item_wg_slot,
	   table_entry[PREV_ENTRY_H:PREV_ENTRY_L],
	   table_entry[RES_SIZE_H:RES_SIZE_L],
	   table_entry[RES_STRT_H:RES_STRT_L]};

   endfunction // if

   function[RES_ID_WIDTH-1 : 0] get_free_res_start;
      input [TABLE_ENTRY_WIDTH-1 : 0] table_entry;

      get_free_res_start = get_res_start(table_entry) + get_res_size(table_entry);
   endfunction // if
   
   
   function[RES_ID_WIDTH:0] get_free_res_size;
      input [TABLE_ENTRY_WIDTH-1 : 0] last_table_entry, table_entry;

      get_free_res_size 
	= (table_entry[RES_STRT_H:RES_STRT_L]) - 
	  (last_table_entry[RES_STRT_H:RES_STRT_L]+
	   last_table_entry[RES_SIZE_H:RES_SIZE_L]);
      
   endfunction // if
   
   function[RES_ID_WIDTH:0] get_free_res_size_last;
      input [TABLE_ENTRY_WIDTH-1 : 0] table_entry;

      get_free_res_size_last
	= NUMBER_RES_SLOTS - 
	  (table_entry[RES_STRT_H:RES_STRT_L]+table_entry[RES_SIZE_H:RES_SIZE_L]);
      
   endfunction // if
   
   
   // Ram to implement the table
   localparam NUM_ENTRIES = NUMBER_CU*(NUMBER_WF_SLOTS_PER_CU+1);
   localparam[WG_SLOT_ID_WIDTH-1:0] RES_TABLE_END_TABLE = 2**WG_SLOT_ID_WIDTH-1;
   localparam[WG_SLOT_ID_WIDTH-1:0] RES_TABLE_HEAD_POINTER = 2**WG_SLOT_ID_WIDTH-2;

   reg [TABLE_ENTRY_WIDTH-1 : 0]      resource_table_ram[NUM_ENTRIES-1:0];
   reg [WG_SLOT_ID_WIDTH-1 : 0]       table_head_pointer[NUMBER_CU-1:0];
   reg [WG_SLOT_ID_WIDTH-1 : 0]       table_head_pointer_i;

   wire [RES_ID_WIDTH-1 : 0] 	      rtwr_res_strt, rtrr_res_strt, 
				      rtne_res_strt, rtlrr_res_strt;
   wire [RES_ID_WIDTH : 0] 	      rtwr_res_size, rtrr_res_size, 
				      rtne_res_size, rtlrr_res_size;
   wire [TABLE_ENTRY_WIDTH-1 : 0]     rtwr_prev_item, rtrr_prev_item, 
				      rtne_prev_item, rtlrr_prev_item;
   wire [RES_ID_WIDTH-1 : 0] 	      rtwr_next_item, rtrr_next_item, 
				      rtne_next_item, rtlrr_next_item;
			     
   // State machines
   // Main state machine
   localparam ST_M_IDLE = 1;
   localparam ST_M_ALLOC = 2;
   localparam ST_M_DEALLOC = 4;
   localparam ST_M_FIND_MAX = 8;
   reg [3:0] 			      m_state;

   // Alloc state machine
   localparam ST_A_IDLE = 1;
   localparam ST_A_FIND_POSITION = 2;
   localparam ST_A_UPDATE_PREV_ENTRY = 4;
   localparam ST_A_WRITE_NEW_ENTRY = 8;
   reg [3:0] 			      a_state;
   // Dealloc state machine
   localparam ST_D_IDLE = 1;
   localparam ST_D_READ_PREV_ENTRY = 2;
   localparam ST_D_READ_NEXT_ENTRY = 4;
   localparam ST_D_UPDATE_PREV_ENTRY = 8;
   localparam ST_D_UPDATE_NEXT_ENTRY = 16;
   reg [4:0] 			      d_state;
   
   // Find max state machine
   localparam ST_F_IDLE = 1;
   localparam ST_F_FIRST_ITEM = 2;
   localparam ST_F_SEARCHING = 4;
   localparam ST_F_LAST_ITEM = 8;
   reg [3:0] 			      f_state;
   
   // Datapath regs
   reg [TABLE_ENTRY_WIDTH-1 : 0]      res_table_wr_reg, res_table_rd_reg;
   reg [TABLE_ENTRY_WIDTH-1 : 0]      res_table_last_rd_reg;
   reg [CU_ID_WIDTH-1:0] 	      res_addr_cu_id;
   reg [WG_SLOT_ID_WIDTH-1 : 0]       res_addr_wg_slot;
   reg 				      res_table_rd_en, res_table_wr_en;
   reg 				      res_table_rd_valid;
   reg [RES_ID_WIDTH : 0] 	      res_table_max_size;
   reg [RES_ID_WIDTH-1 : 0] 	      res_table_max_start;
   
   // Control signals
   reg 				      alloc_start, dealloc_start, find_max_start;
   reg 				      alloc_done, dealloc_done,  find_max_done;
   reg 				      new_entry_is_last, new_entry_is_first;
   reg 				      rem_entry_is_last, rem_entry_is_first;
   reg [NUMBER_CU-1:0] 		      cu_initialized;
   reg 				      cu_initialized_i;
   
   assign rtwr_res_strt = get_res_start(res_table_wr_reg);
   assign rtrr_res_strt = get_res_start(res_table_rd_reg);
   assign rtlrr_res_strt = get_res_start(res_table_last_rd_reg);
   
   assign rtwr_res_size = get_res_size(res_table_wr_reg);
   assign rtrr_res_size = get_res_size(res_table_rd_reg);
   assign rtlrr_res_size = get_res_size(res_table_last_rd_reg);
   
   assign rtwr_prev_item = get_prev_item_wg_slot(res_table_wr_reg);
   assign rtrr_prev_item = get_prev_item_wg_slot(res_table_rd_reg);
   assign rtlrr_prev_item = get_prev_item_wg_slot(res_table_last_rd_reg);
       
   assign rtwr_next_item = get_next_item_wg_slot(res_table_wr_reg);
   assign rtrr_next_item = get_next_item_wg_slot(res_table_rd_reg);
   assign rtlrr_next_item = get_next_item_wg_slot(res_table_last_rd_reg);
     
   // Implements the resouce table
   always @(posedge clk or rst) begin
      if(rst) begin
	 m_state = ST_M_IDLE;
	 a_state = ST_A_IDLE;
	 d_state = ST_D_IDLE;
	 f_state = ST_F_IDLE;

	 alloc_res_en_i <= 0;
	 alloc_cu_id_i <= 0;
	 alloc_res_start_i <= 0;
	 alloc_res_size_i <= 0;

	 alloc_start <= 0;
	 alloc_done <= 0;

	 new_entry_is_first <= 0;
	 new_entry_is_last <= 0;
	 
	 dealloc_res_en_i <= 0;
	 dealloc_cu_id_i <= 0;
	 dealloc_wg_slot_id_i <= 0;

	 dealloc_start <= 0;
	 dealloc_done <= 0;

	 find_max_start <= 0;
	 find_max_done <=0;
	 
	 rem_entry_is_first <= 0;
	 rem_entry_is_last <= 0;
	 
	 find_max_done <= 0;
	 find_max_start <= 0;

	 res_table_max_size <= 0;
	 res_table_max_start <= 0;
	 
	 res_addr_cu_id <= 0;
	 res_addr_wg_slot <= 0;
	 table_head_pointer_i <= 0;

	 res_table_rd_reg <= 0;
	 res_table_last_rd_reg <= 0;
	 res_table_rd_en <= 0;
	 res_table_rd_valid <=0;

	 res_table_wr_en <= 0;
	 res_table_wr_reg <= 0;

	 cu_initialized <= 0;
	 cu_initialized_i <= 0;
	 
      end else begin
	 // Flop input signals
	 alloc_res_en_i <= alloc_res_en;
	 if(alloc_res_en) begin
	    alloc_cu_id_i <= alloc_cu_id;
	    alloc_wg_slot_id_i <= alloc_wg_slot_id;
	    alloc_res_start_i <= alloc_res_start;
	    alloc_res_size_i <= alloc_res_size;

	    res_addr_cu_id <= alloc_cu_id;
	 end

	 dealloc_res_en_i <= dealloc_res_en;
	 if(dealloc_res_en) begin
	    dealloc_cu_id_i <= dealloc_cu_id;
	    dealloc_wg_slot_id_i <= dealloc_wg_slot_id;

	    res_addr_cu_id <= dealloc_cu_id;
	 end


	 // Main state machine of the resource table
	 alloc_start <= 1'b0;
	 dealloc_start <= 1'b0;
	 find_max_start <= 1'b0;
	 res_table_done <= 1'b0;
	 case(m_state)

	   ST_M_IDLE : begin
	      if(1'b1 == alloc_res_en_i) begin
		 alloc_start <= 1'b1;
		 m_state <= ST_M_ALLOC;
	      end else if(1'b1 == dealloc_res_en_i) begin
		 dealloc_start <= 1'b1;
		 m_state <= ST_M_DEALLOC;
	      end
	      
	   end
	   /////////////////////////////////////////////////

	   ST_M_ALLOC : begin
	      if(1'b1 == alloc_done) begin
		 find_max_start <= 1'b1;
		 m_state <= ST_M_FIND_MAX;
	      end
	      
	   end
	   /////////////////////////////////////////////////
	   
	   ST_M_DEALLOC : begin
	      if(1'b1 == dealloc_done) begin
		 find_max_start <= 1'b1;
		 m_state <= ST_M_FIND_MAX;
	      end
	      
	   end
	   /////////////////////////////////////////////////

	   ST_M_FIND_MAX : begin
	      if(1'b1 == find_max_done) begin
		 res_table_done <= 1'b1;
		 m_state <= ST_M_IDLE;
	      end
	      
	   end
	   /////////////////////////////////////////////////

	 endcase // case (m_state)

	 // All state machines share the same resource (the table) so,
	 // there can be onle one machine out of IDLE state at a given time.

	 res_table_rd_en <= 1'b0;
	 res_table_wr_en <= 1'b0;
	 alloc_done <= 1'b0;
	 
	 // Alloc state machine
	 case(a_state)
	   ST_A_IDLE : begin
	      // Start looking for the new entry positon on
	      // head_position
	      if( alloc_start ) begin
		 // Table is clear or cu was not initialized
		 if( (table_head_pointer_i == RES_TABLE_END_TABLE) ||
		     !cu_initialized_i) begin
		    new_entry_is_first <= 1'b1;
		    new_entry_is_last <= 1'b1;
		    a_state <= ST_A_WRITE_NEW_ENTRY;
		    // Otherwise we have to find a position
		 end else begin
		    new_entry_is_last <= 1'b0;
		    new_entry_is_first <= 1'b0;
		    res_table_rd_en <= 1'b1;
		    res_addr_wg_slot <= table_head_pointer_i;
		    a_state <= ST_A_FIND_POSITION;
		 end
		 
	      end // if ( alloc_start )
	      
	   end // case: ST_A_IDLE
	   

	   ST_A_FIND_POSITION : begin
	      // Look for the entry postion
	      if( res_table_rd_valid ) begin
		 // Found the entry that will be after the new one
		 if( get_res_start(res_table_rd_reg) > alloc_res_start_i ) begin
		    // if new entry will be the first entry
		    if( get_prev_item_wg_slot(res_table_rd_reg) ==
			RES_TABLE_HEAD_POINTER) begin
		       new_entry_is_first <= 1'b1;
		       res_table_wr_en <= 1'b1;
		       res_table_wr_reg 
			 <= set_prev_item_wg_slot(alloc_wg_slot_id_i,
						  res_table_rd_reg);
		       a_state <= ST_A_WRITE_NEW_ENTRY;
		    end
		    // Normal case
		    else begin
		       
		       // Update this entry
		       res_table_wr_en <= 1'b1;
		       res_table_wr_reg 
			 <= set_prev_item_wg_slot(alloc_wg_slot_id_i,
						  res_table_rd_reg);
		       a_state <= ST_A_UPDATE_PREV_ENTRY;
		    end // else: !if( get_prev_item_wg_slot(res_table_rd_reg) ==...
		    
		 end // if ( get_res_start(res_table_rd_reg) > alloc_res_start_i )
		 // The new entry will be the last entry		 
		 else if( get_next_item_wg_slot(res_table_rd_reg) == 
			  RES_TABLE_END_TABLE ) begin
		    res_table_wr_en <= 1'b1;
		    res_table_wr_reg 
		      <= set_next_item_wg_slot(alloc_wg_slot_id_i,res_table_rd_reg);
		    new_entry_is_last <= 1'b1;
		    a_state <= ST_A_WRITE_NEW_ENTRY;
		 end
		 
		 // Keep looking for the entry postion
		 else begin
		    res_table_rd_en <= 1'b1;
		    res_addr_wg_slot <= get_next_item_wg_slot(res_table_rd_reg);
		 end // else: !if( get_next_item_wg_slot(res_table_rd_reg) ==...
		 
	      end // if ( res_table_rd_valid )
	      
	      
	   end // case: ST_A_FIND_POSITION
	   

	   ST_A_UPDATE_PREV_ENTRY : begin
	      // Update the entry that will be before the new one
	      res_table_wr_en <= 1'b1;
	      res_table_wr_reg 
		<= set_next_item_wg_slot(alloc_wg_slot_id_i,
					 res_table_last_rd_reg);
	      res_addr_wg_slot <= get_prev_item_wg_slot(res_table_rd_reg);
	      a_state <= ST_A_WRITE_NEW_ENTRY;
	   end
	   

	   ST_A_WRITE_NEW_ENTRY : begin
	      if( new_entry_is_first ) begin
		 table_head_pointer_i <= alloc_wg_slot_id_i;
	      end
	      
	      // Write the new entry
	      res_table_wr_en <= 1'b1;
	      res_addr_wg_slot <= alloc_wg_slot_id_i;
	      if( new_entry_is_first && new_entry_is_last ) begin
		 res_table_wr_reg 
		   <= get_new_entry(alloc_res_start_i, alloc_res_size_i,
				    RES_TABLE_HEAD_POINTER,
				    RES_TABLE_END_TABLE);
	      end
	      
	      else if( new_entry_is_last ) begin
		 res_table_wr_reg 
		   <= get_new_entry(alloc_res_start_i, alloc_res_size_i,
				    res_addr_wg_slot,
				    RES_TABLE_END_TABLE);
	      end
	      
	      else if(new_entry_is_first) begin
		 res_table_wr_reg 
		   <= get_new_entry(alloc_res_start_i, alloc_res_size_i,
				    RES_TABLE_HEAD_POINTER,
				    res_addr_wg_slot);
	      end
	      
	      else begin
		 res_table_wr_reg 
		   <= get_new_entry(alloc_res_start_i, alloc_res_size_i,
				    res_addr_wg_slot,
				    get_next_item_wg_slot(res_table_last_rd_reg));
	      end // else: !if( new_entry_is_last )
	      

	      alloc_done <= 1'b1;
	      a_state <= ST_A_IDLE;
	   end 
	 endcase // case (a_state)


	 
	 // Dealloc state machine
	 dealloc_done <= 1'b0;
	 case(d_state)
	   ST_D_IDLE: begin
	      if( dealloc_start ) begin
		 rem_entry_is_last <= 1'b0;
		 rem_entry_is_first <= 1'b0;
		 res_table_rd_en <= 1'b1;
		 res_addr_wg_slot <= dealloc_wg_slot_id_i;
		 d_state <= ST_D_READ_PREV_ENTRY;
	      end 
	   end
	   
	   ST_D_READ_PREV_ENTRY : begin
	      if (res_table_rd_valid ) begin
		 // We are removing the last remaining entry on the table
		 if( (get_prev_item_wg_slot(res_table_rd_reg) 
		      == RES_TABLE_HEAD_POINTER) &&
		     (get_next_item_wg_slot(res_table_rd_reg)
		      == RES_TABLE_END_TABLE)) begin
		    table_head_pointer_i <= RES_TABLE_END_TABLE;
		    dealloc_done <= 1'b1;
		    d_state <= ST_D_IDLE;
		 // We are removing the first entry on the table
		 end else if(get_prev_item_wg_slot(res_table_rd_reg) 
		    == RES_TABLE_HEAD_POINTER) begin
		    rem_entry_is_first <= 1'b1;
		    d_state <= ST_D_READ_NEXT_ENTRY;
		 // We are removing the last entry on the table
		 end else if (get_next_item_wg_slot(res_table_rd_reg)
			      == RES_TABLE_END_TABLE) begin
		    rem_entry_is_last <= 1'b1;
		    res_table_rd_en <= 1'b1;
		    res_addr_wg_slot <= get_prev_item_wg_slot(res_table_rd_reg);
		    d_state <= ST_D_UPDATE_PREV_ENTRY;
		 // We are a normal entry
		 end else begin
		    res_table_rd_en <= 1'b1;
		    res_addr_wg_slot <= get_prev_item_wg_slot(res_table_rd_reg);
		    d_state <= ST_D_READ_NEXT_ENTRY;
		 end
	      end // if (res_table_rd_valid )
	      
	   end // case: ST_D_READ_PREV_ENTRY
	   
	   
	   ST_D_READ_NEXT_ENTRY : begin
	      res_table_rd_en <= 1'b1;
	      res_addr_wg_slot <= get_next_item_wg_slot(res_table_rd_reg);
	      d_state <= ST_D_UPDATE_PREV_ENTRY;
	   end
	   
	   ST_D_UPDATE_PREV_ENTRY : begin
	      // In this cycle it is reading the next entry, so we can use the
	      // the addr_reg to get our the next entry addr
	      // Single cycle delay to complete reading if the entry if the entry
	      // is the first or the last
	      if(rem_entry_is_first) begin
		 d_state <= ST_D_UPDATE_NEXT_ENTRY;
	      end else if(rem_entry_is_last) begin
		 d_state <= ST_D_UPDATE_NEXT_ENTRY;
	      end else begin
		 res_table_wr_en <= 1'b1;
		 res_addr_wg_slot <= get_prev_item_wg_slot(res_table_last_rd_reg);
		 res_table_wr_reg 
		   <= set_next_item_wg_slot(res_addr_wg_slot,
					    res_table_rd_reg);
		 d_state <= ST_D_UPDATE_NEXT_ENTRY;
	      end // else: !if(rem_entry_is_last)
	      
	   end // case: ST_D_UPDATE_PREV_ENTRY
	   
	   
	   ST_D_UPDATE_NEXT_ENTRY : begin
	      // In this cycle it is writing the previous entry, so we can use the
	      // the addr_reg to get our the next entry addr
	      res_table_wr_en <= 1'b1;
	      if( rem_entry_is_first ) begin
		 table_head_pointer_i <= res_addr_wg_slot;
		 res_table_wr_reg 
		   <= set_prev_item_wg_slot(RES_TABLE_HEAD_POINTER,
					    res_table_rd_reg);
	      end else if ( rem_entry_is_last ) begin
		 res_table_wr_en <= 1'b1;
		 // No need to update addr, we are writing the
		 // entry we just read
		 res_table_wr_reg 
		   <= set_next_item_wg_slot(RES_TABLE_END_TABLE,
					    res_table_rd_reg);
	      end else begin
		 res_addr_wg_slot <= get_next_item_wg_slot(res_table_wr_reg);
		 res_table_wr_reg 
		   <= set_prev_item_wg_slot(res_addr_wg_slot,
					    res_table_rd_reg);
	      end
	      
	      dealloc_done <= 1'b1;
	      d_state <= ST_D_IDLE;
	   end // case: ST_D_UPDATE_NEXT_ENTRY
	   
	 endcase
	 
	 // Find max state machine
	 find_max_done <= 1'b0;
	 case(f_state)
	   ST_F_IDLE : begin
              if( find_max_start ) begin
		 // Zero the max res size reg
		 res_table_max_size <= 0;
		 
		 // In case table is clear, return 0 and finish
		 if(table_head_pointer_i == RES_TABLE_END_TABLE) begin
		    res_table_max_size 
		      <= NUMBER_RES_SLOTS;
		    res_table_max_start 
		      <= 0;
		    find_max_done <= 1'b1;
		    // otherwise start searching
		 end else begin
		    res_table_rd_en <= 1'b1;
		    res_addr_wg_slot <= table_head_pointer_i;
		    f_state <= ST_F_FIRST_ITEM;
		 end
		 
	      end // if ( find_max_start )
	      
	   end // case: ST_F_IDLE
	   

	   ST_F_FIRST_ITEM: begin
	      // only read first item. If it is alst the last, skip
	      // the searching state
	      if( res_table_rd_valid ) begin
		 res_table_max_size 
		   <= get_res_start(res_table_rd_reg);
		 res_table_max_start 
		   <= 0;
		 
		 // check if it is in the end o of the table
		 if( get_next_item_wg_slot(res_table_rd_reg) != 
		     RES_TABLE_END_TABLE) begin
		    res_table_rd_en <= 1'b1;
		    res_addr_wg_slot <= get_next_item_wg_slot(res_table_rd_reg);
		    f_state <= ST_F_SEARCHING;
		 end else begin
		    f_state <= ST_F_LAST_ITEM;
		 end
	      end // if ( res_table_rd_valid )
	      
	   end // case: ST_F_FIRST_ITEM

	   ST_F_SEARCHING : begin
	      if( res_table_rd_valid ) begin
		 // check if it is in the end o of the table
		 if( get_next_item_wg_slot(res_table_rd_reg) != 
		     RES_TABLE_END_TABLE) begin
		    res_table_rd_en <= 1'b1;
		    res_addr_wg_slot <= get_next_item_wg_slot(res_table_rd_reg);
		 end else begin
		    f_state <= ST_F_LAST_ITEM;
		 end

		 // check if this is the max res size
		 if( get_free_res_size(res_table_last_rd_reg, res_table_rd_reg) >
		     res_table_max_size) begin
		    res_table_max_size 
		      <= get_free_res_size(res_table_last_rd_reg, res_table_rd_reg);
		    res_table_max_start 
		      <= get_free_res_start(res_table_last_rd_reg);
		 end
	      end // if ( res_table_rd_valid )
	      
	      
	   end // case: ST_F_SEARCHING
	   
	   ST_F_LAST_ITEM : begin
	      // calculate the free space for the last item
	      if( get_free_res_size_last(res_table_rd_reg) > 
		  res_table_max_size) begin
		 
		 res_table_max_size 
		   <= get_free_res_size_last(res_table_rd_reg);
		 res_table_max_start 
		   <= get_free_res_start(res_table_rd_reg);
	      end
	      find_max_done <= 1'b1;
	      f_state <= ST_F_IDLE;
	   end // case: ST_F_LAST_ITEM
	   
	 endcase  
	 
	 // Data path of the resource table
	 if( alloc_res_en_i || dealloc_res_en_i ) begin
	    // Read the head pointer at the start
	    cu_initialized_i <= cu_initialized[res_addr_cu_id];
	    table_head_pointer_i <= table_head_pointer[res_addr_cu_id];
	 end else if (alloc_done || dealloc_done) begin
	    // Write at the end
	    table_head_pointer[res_addr_cu_id] <= table_head_pointer_i;
	    cu_initialized[res_addr_cu_id] <= 1'b1;
	 end
	 
	 
	 
	 res_table_rd_valid <= res_table_rd_en;
	 
	 if( res_table_rd_en ) begin
	    res_table_rd_reg 
	      <= resource_table_ram[calc_table_addr(res_addr_cu_id, 
						    res_addr_wg_slot)];
	    res_table_last_rd_reg <= res_table_rd_reg;
	 end else if (res_table_wr_en) begin
	    resource_table_ram[calc_table_addr(res_addr_cu_id, res_addr_wg_slot)]
					 <= res_table_wr_reg;
         end
	 
      end // else: !if(rst)

   end // always @ (posedge clk or rst)

   assign cam_biggest_space_size = res_table_max_size;
   assign cam_biggest_space_addr = res_table_max_start;

endmodule   


