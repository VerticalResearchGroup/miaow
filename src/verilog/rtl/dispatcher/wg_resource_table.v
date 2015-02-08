module wg_resource_table (/*AUTOARG*/
   // Outputs
   wg_res_tbl_wg_slot_id, wg_res_tbl_wg_count_out,
   // Inputs
   rst, clk, wg_res_tbl_alloc_en, wg_res_tbl_dealloc_en,
   wg_res_tbl_cu_id, wg_res_tbl_wg_id, wg_res_tbl_alloc_wg_wf_count,
   wg_res_tbl_inflight_res_tbl_id
   ) ;

   parameter NUMBER_CU = 64;
   parameter CU_ID_WIDTH = 6;
   parameter WG_ID_WIDTH = 10;
   parameter WF_COUNT_WIDTH = 4;

   
   parameter WG_SLOT_ID_WIDTH = 6;
   parameter NUMBER_WF_SLOTS = 40;

   parameter RES_TABLE_ADDR_WIDTH = 3;
   localparam NUMBER_RES_TABLES = 2**RES_TABLE_ADDR_WIDTH;
   
   input rst,clk;
   input wg_res_tbl_alloc_en, wg_res_tbl_dealloc_en;
   input [CU_ID_WIDTH-1:0] wg_res_tbl_cu_id;
   input [WG_ID_WIDTH-1:0] wg_res_tbl_wg_id;
   input [WF_COUNT_WIDTH-1:0] wg_res_tbl_alloc_wg_wf_count;
   
   output [WG_SLOT_ID_WIDTH-1:0] wg_res_tbl_wg_slot_id;

   input [RES_TABLE_ADDR_WIDTH-1:0] wg_res_tbl_inflight_res_tbl_id;
   output [WG_SLOT_ID_WIDTH:0] 	    wg_res_tbl_wg_count_out;

   reg [NUMBER_CU-1:0] 		    cu_initialized;
   
   wire [NUMBER_WF_SLOTS-1:0] 	    wg_slot_bitmap_out;


   // Deallocation searching for the wg_slot_id
   wire [WG_SLOT_ID_WIDTH-1:0] 	    wg_slot_tbl_rd_data;

   // allocation calculating wg_slot_id
   reg 				    alloc_calculated_wg_slot_valid;
   reg [WG_SLOT_ID_WIDTH-1:0] 	    alloc_calculated_wg_slot_id;
   reg [CU_ID_WIDTH-1:0] 	    alloc_calc_cu_id_calc, 
				    alloc_calc_cu_id;
   reg [WF_COUNT_WIDTH-1:0] 	    alloc_calc_wf_count_calc, 
				    alloc_calc_wf_count;

   reg 				    alloc_calc_wr_en;
   reg [WG_ID_WIDTH-1:0] 	    alloc_calc_wg_id, alloc_calc_wg_id_calc;
   reg [WG_SLOT_ID_WIDTH-1:0] 	    alloc_calc_wg_slot_data;

   // Bitmap update
   reg 				    bitmap_update_allocating, 
				    bitmap_update_deallocating;
   
   reg [CU_ID_WIDTH-1:0] 	    bitmap_update_cu_id_calc, bitmap_update_cu_id;
   reg 				    bitmap_update_wr_en;
   reg [NUMBER_WF_SLOTS-1:0] 	    bitmap_update_data_comb, bitmap_update_data ;

   // wf count update
   reg 				    wf_count_update_alloc_en_calc,
				    wf_count_update_alloc_en_f1,
				    wf_count_update_alloc_en_f2,
				    wf_count_update_dealloc_en_calc,
				    wf_count_update_dealloc_en_f1,
				    wf_count_update_dealloc_en_f2;
   
   reg 				    wf_count_update_wr_en;

   reg [CU_ID_WIDTH-1:0] 	    wf_count_update_cu_id_calc,
				    wf_count_update_cu_id_f1,
				    wf_count_update_cu_id_f2,
				    wf_count_update_cu_id_f3;
   
   reg [WG_SLOT_ID_WIDTH-1:0] 	    wf_count_wg_slot_id_f1,
				    wf_count_wg_slot_id_f2,
				    wf_count_wg_slot_id_f3;
   
   reg [WG_SLOT_ID_WIDTH:0] 	    wf_count_update_wr_data, 
				    wf_count_update_inflight_wr_data;
   reg [WF_COUNT_WIDTH-1:0] 	    wf_count_alloc_count_f1, wf_count_alloc_count_f2,
				    wf_count_alloc_count_calc;

   
   wire [WF_COUNT_WIDTH-1:0] 	    wf_count_dealloc_count;
   
   wire [WG_SLOT_ID_WIDTH:0] 	    wf_count_update_rd_data;

   // ram that keeps information for inflight wf allocations/deallocations
   // this is because there is a pipeline concurrent with this block that
   // does not have a fixed number of cycles for execution
   ram_2_port
     #(
       // Parameters
       .WORD_SIZE			(WG_SLOT_ID_WIDTH+1),
       .ADDR_SIZE			(RES_TABLE_ADDR_WIDTH),
       .NUM_WORDS			(NUMBER_RES_TABLES))
   wf_slot_count_inflight_ram
     (
      // Outputs
      .rd_word				(wg_res_tbl_wg_count_out),
      // Inputs
      .rst				(rst),
      .clk				(clk),
      .wr_en				(wf_count_update_wr_en),
      .wr_addr				(wf_count_update_cu_id_f3
					 [CU_ID_WIDTH-1:CU_ID_WIDTH-RES_TABLE_ADDR_WIDTH]),
      .wr_word				(wf_count_update_inflight_wr_data),
      .rd_en				(1'b1),
      .rd_addr				(wg_res_tbl_inflight_res_tbl_id));


   // ram that keeps track of the amount of wf currently allocated on each cu for
   // each workgroup
   ram_2_port
     #(
       // Parameters
       .WORD_SIZE			(WF_COUNT_WIDTH),
       .ADDR_SIZE			(WG_SLOT_ID_WIDTH+CU_ID_WIDTH),
       .NUM_WORDS			(NUMBER_WF_SLOTS*NUMBER_CU))
   wf_slot_count_ram1
     (
      // Outputs
      .rd_word				(wf_count_dealloc_count),
      // Inputs
      .rst				(rst),
      .clk				(clk),
      .wr_en				(alloc_calc_wr_en),
      .wr_addr				({alloc_calc_wg_slot_data,
					  alloc_calc_cu_id}),
      .wr_word				(alloc_calc_wf_count),
      .rd_en				(wf_count_update_dealloc_en_f1),
      .rd_addr				({wf_count_wg_slot_id_f1, 
					  wf_count_update_cu_id_f1}));

   // ram that keeps track of the amount of free resources on each cu
   ram_2_port
     #(
       // Parameters
       .WORD_SIZE			(WG_SLOT_ID_WIDTH+1),
       .ADDR_SIZE			(CU_ID_WIDTH),
       .NUM_WORDS			(NUMBER_CU))
   wf_slot_used
     (
      // Outputs
      .rd_word				(wf_count_update_rd_data),
      // Inputs
      .rst				(rst),
      .clk				(clk),
      .wr_en				(wf_count_update_wr_en),
      .wr_addr				(wf_count_update_cu_id_f3),
      .wr_word				(wf_count_update_wr_data),
      .rd_en				( wf_count_update_alloc_en_f1 |
					  wf_count_update_dealloc_en_f1),
      .rd_addr				(wf_count_update_cu_id_f1));
   
   
   // Ram that keeps the wg slot bitmap
   // A bit on the bitmap is set on allocation and cleared on deallocation
   // Allocation reads it to generate a new wg_slot_id
   ram_2_port
     #(
       // Parameters
       .WORD_SIZE			(NUMBER_WF_SLOTS),
       .ADDR_SIZE			(CU_ID_WIDTH),
       .NUM_WORDS			(NUMBER_CU))
   wg_slot_bitmap_ram
     (
      // Outputs
      .rd_word				(wg_slot_bitmap_out),
      // Inputs
      .rst				(rst),
      .clk				(clk),
      .wr_en				(bitmap_update_wr_en),
      .wr_addr				(bitmap_update_cu_id),
      .wr_word				(bitmap_update_data),
      .rd_en				(wg_res_tbl_alloc_en | wg_res_tbl_dealloc_en),
      .rd_addr				(wg_res_tbl_cu_id));
   
   // Ram to convert wg_id to wg_slot_id
   // written on allocation and read by deallocation
   ram_2_port
     #(
       // Parameters
       .WORD_SIZE			(WG_SLOT_ID_WIDTH),
       .ADDR_SIZE			(WG_ID_WIDTH),
       .NUM_WORDS			(2**WG_ID_WIDTH))
   wg_id_to_wg_slot_id_ram
     (
      // Outputs
      .rd_word				(wg_slot_tbl_rd_data),
      // Inputs
      .rst				(rst),
      .clk				(clk),
      .wr_en				(alloc_calc_wr_en),
      .wr_addr				(alloc_calc_wg_id),
      .wr_word				(alloc_calc_wg_slot_data),
      .rd_en				(wg_res_tbl_dealloc_en),
      .rd_addr				(wg_res_tbl_wg_id));

   //////////////////////////////////////////////////////////
       // clocked always block
   //////////////////////////////////////////////////////////
   always @( posedge clk or posedge rst ) begin
      if (rst) begin
	 alloc_calculated_wg_slot_valid <= 0;
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 alloc_calc_cu_id <= {CU_ID_WIDTH{1'b0}};
	 alloc_calc_cu_id_calc <= {CU_ID_WIDTH{1'b0}};
	 alloc_calc_wf_count <= {WF_COUNT_WIDTH{1'b0}};
	 alloc_calc_wf_count_calc <= {WF_COUNT_WIDTH{1'b0}};
	 alloc_calc_wg_id <= {WG_ID_WIDTH{1'b0}};
	 alloc_calc_wg_id_calc <= {WG_ID_WIDTH{1'b0}};
	 alloc_calc_wg_slot_data <= {WG_SLOT_ID_WIDTH{1'b0}};
	 alloc_calc_wr_en <= 1'h0;
	 bitmap_update_allocating <= 1'h0;
	 bitmap_update_cu_id <= {CU_ID_WIDTH{1'b0}};
	 bitmap_update_cu_id_calc <= {CU_ID_WIDTH{1'b0}};
	 bitmap_update_data <= {NUMBER_WF_SLOTS{1'b0}};
	 bitmap_update_deallocating <= 1'h0;
	 bitmap_update_wr_en <= 1'h0;
	 cu_initialized <= {NUMBER_CU{1'b0}};
	 wf_count_alloc_count_calc <= {WF_COUNT_WIDTH{1'b0}};
	 wf_count_alloc_count_f1 <= {WF_COUNT_WIDTH{1'b0}};
	 wf_count_alloc_count_f2 <= {WF_COUNT_WIDTH{1'b0}};
	 wf_count_update_alloc_en_calc <= 1'h0;
	 wf_count_update_alloc_en_f1 <= 1'h0;
	 wf_count_update_alloc_en_f2 <= 1'h0;
	 wf_count_update_cu_id_calc <= {CU_ID_WIDTH{1'b0}};
	 wf_count_update_cu_id_f1 <= {CU_ID_WIDTH{1'b0}};
	 wf_count_update_cu_id_f2 <= {CU_ID_WIDTH{1'b0}};
	 wf_count_update_cu_id_f3 <= {CU_ID_WIDTH{1'b0}};
	 wf_count_update_dealloc_en_calc <= 1'h0;
	 wf_count_update_dealloc_en_f1 <= 1'h0;
	 wf_count_update_dealloc_en_f2 <= 1'h0;
	 wf_count_update_inflight_wr_data <= {(1+(WG_SLOT_ID_WIDTH)){1'b0}};
	 wf_count_update_wr_data <= {(1+(WG_SLOT_ID_WIDTH)){1'b0}};
	 wf_count_update_wr_en <= 1'h0;
	 wf_count_wg_slot_id_f1 <= {WG_SLOT_ID_WIDTH{1'b0}};
	 wf_count_wg_slot_id_f2 <= {WG_SLOT_ID_WIDTH{1'b0}};
	 wf_count_wg_slot_id_f3 <= {WG_SLOT_ID_WIDTH{1'b0}};
	 // End of automatics
      end
      else begin
	 alloc_calculated_wg_slot_valid <= wg_res_tbl_alloc_en;
	 alloc_calc_wg_id_calc <= wg_res_tbl_wg_id;
	 alloc_calc_cu_id_calc <= wg_res_tbl_cu_id;
	 alloc_calc_wf_count_calc <= wg_res_tbl_alloc_wg_wf_count;
	 
	 
	 alloc_calc_wr_en <= alloc_calculated_wg_slot_valid;
	 alloc_calc_wg_id <= alloc_calc_wg_id_calc;
	 alloc_calc_cu_id <= alloc_calc_cu_id_calc;
	 alloc_calc_wg_slot_data <= alloc_calculated_wg_slot_id;
	 alloc_calc_wf_count <= alloc_calc_wf_count_calc;
	 
	 bitmap_update_allocating <= wg_res_tbl_alloc_en;
	 bitmap_update_deallocating <= wg_res_tbl_dealloc_en;
	 bitmap_update_wr_en <= bitmap_update_allocating | 
				bitmap_update_deallocating;
	 
	 // extra cycle delay to wait for wg_slot_id calculation
	 bitmap_update_cu_id_calc <= wg_res_tbl_cu_id;
	 bitmap_update_cu_id <= bitmap_update_cu_id_calc;
	 bitmap_update_data <= bitmap_update_data_comb;

	 
	 // wf count logic - we can only update the wf count reg after we
	 // have calculated/searched the wf_id.
	 // extra cycle delay to wait for wg_slot_id calculation
	 wf_count_update_alloc_en_calc <= wg_res_tbl_alloc_en;
	 wf_count_update_dealloc_en_calc <= wg_res_tbl_dealloc_en;
	 wf_count_update_cu_id_calc <= wg_res_tbl_cu_id;
	 wf_count_alloc_count_calc <= wg_res_tbl_alloc_wg_wf_count;
	 
	 // cycle when the wg_slots id are calculated
	 wf_count_update_alloc_en_f1 <= wf_count_update_alloc_en_calc;
	 wf_count_update_dealloc_en_f1 <= wf_count_update_dealloc_en_calc;
	 wf_count_update_cu_id_f1 <= wf_count_update_cu_id_calc;
	 if(wf_count_update_alloc_en_calc) begin
	    wf_count_wg_slot_id_f1 <= alloc_calculated_wg_slot_id;
	 end else begin
	    wf_count_wg_slot_id_f1 <= wg_slot_tbl_rd_data;
	 end // else: !if(wf_count_update_alloc_en_calc)
	 wf_count_alloc_count_f1 <= wf_count_alloc_count_calc;

	 // cycle when old data is read
	 wf_count_update_alloc_en_f2 <= wf_count_update_alloc_en_f1;
	 wf_count_update_dealloc_en_f2 <= wf_count_update_dealloc_en_f1;
	 wf_count_update_cu_id_f2 <= wf_count_update_cu_id_f1;
	 wf_count_wg_slot_id_f2 <= wf_count_wg_slot_id_f1;
	 wf_count_alloc_count_f2 <= wf_count_alloc_count_f1;
	    
	 // cycle when update data is written
	 wf_count_update_cu_id_f3 <= wf_count_update_cu_id_f2;
	 wf_count_wg_slot_id_f3 <= wf_count_wg_slot_id_f2;
	 
	 wf_count_update_wr_en <= wf_count_update_alloc_en_f2 |
				  wf_count_update_dealloc_en_f2;
	 
	 if(wf_count_update_alloc_en_f2) begin
	    if(cu_initialized[wf_count_update_cu_id_f2]) begin
	       wf_count_update_inflight_wr_data <= NUMBER_WF_SLOTS -  
						   (wf_count_update_rd_data + wf_count_alloc_count_f2);
	       
	       wf_count_update_wr_data <= wf_count_update_rd_data + 
					  wf_count_alloc_count_f2;
	    end
	    else begin
	       cu_initialized[wf_count_update_cu_id_f2] <= 1'b1;
	       wf_count_update_inflight_wr_data	<= NUMBER_WF_SLOTS - wf_count_alloc_count_f2;
	       wf_count_update_wr_data <= wf_count_alloc_count_f2;
	    end
	 end
	 else begin
	    // No need to check for initialization here, if we are deallocing, 
	    // we must have allocated at some point
	    wf_count_update_inflight_wr_data <= NUMBER_WF_SLOTS - 
						(wf_count_update_rd_data - wf_count_dealloc_count);
	    wf_count_update_wr_data <= wf_count_update_rd_data - 
				       wf_count_dealloc_count;
	 end // else: !if(wf_count_update_alloc_en_f2)
	 
      end // else: !if(rst)
   end // always @ ( posedge clk or posedge rst )

   assign wg_res_tbl_wg_slot_id = (alloc_calculated_wg_slot_valid)? 
				  alloc_calculated_wg_slot_id :
				  wg_slot_tbl_rd_data;
   //////////////////////////////////////////////////////////
   // priority encoder that generates the next wf_slot_id
   //////////////////////////////////////////////////////////
   always @ ( /*AUTOSENSE*/bitmap_update_allocating
	     or bitmap_update_cu_id_calc or bitmap_update_deallocating
	     or cu_initialized or wg_slot_bitmap_out
	     or wg_slot_tbl_rd_data) begin : PRI_ENC_NEXT_WF_SLOT_ID
      integer wg_slot_i;
      reg [WG_SLOT_ID_WIDTH-1:0] wg_slot_found;
      reg 			 wg_slot_valid;

      reg [NUMBER_WF_SLOTS-1:0]  wg_slot_bitmap_set, wg_slot_bitmap_clear;

      wg_slot_bitmap_set = 0;
      wg_slot_bitmap_clear = 0;
      wg_slot_found = 0;
      
      alloc_calculated_wg_slot_id = 0;
      bitmap_update_data_comb = 0;
      
      // clear the flag if it is deallocating the current wg
      if(bitmap_update_deallocating)
	wg_slot_bitmap_clear[wg_slot_tbl_rd_data] =  1'b1;

      // priority encoder that takes the output of the bitmap table
      // and generates the wg_slot_id
      wg_slot_valid = 1'b0;
      for (wg_slot_i = 0; wg_slot_i < NUMBER_WF_SLOTS; wg_slot_i = wg_slot_i + 1) begin
	 if((~wg_slot_bitmap_out[wg_slot_i]) && !wg_slot_valid) begin
	    wg_slot_valid = 1'b1;
	    wg_slot_found = wg_slot_i;
	 end
      end
      

      
      if(cu_initialized[bitmap_update_cu_id_calc]) begin
	 // set the flat if it is allocating the curreng wg
	 if(bitmap_update_allocating)
	   wg_slot_bitmap_set[wg_slot_found] =  1'b1;

	 // do the set and clear
	 bitmap_update_data_comb = (wg_slot_bitmap_out | wg_slot_bitmap_set) &
				   ~wg_slot_bitmap_clear;

	 alloc_calculated_wg_slot_id = wg_slot_found;
      end // if (cu_initialized[bitmap_update_cu_id_calc])
      else begin
	 if(bitmap_update_allocating)
	   wg_slot_bitmap_set[0] = 1'b1;
	 // do the set and clear
	 bitmap_update_data_comb = wg_slot_bitmap_set;
	 alloc_calculated_wg_slot_id = 0;
      end // else: !if(cu_initialized[bitmap_update_cu_id_calc])
      
   end // block: PRI_ENC_NEXT_WF_SLOT_ID
   

endmodule // wg_resource_table
