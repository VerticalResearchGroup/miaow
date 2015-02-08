module gpu_interface 
  (/*AUTOARG*/
   // Outputs
   gpu_interface_alloc_available, gpu_interface_dealloc_available,
   gpu_interface_cu_id, gpu_interface_dealloc_wg_id,
   dispatch2cu_wf_dispatch, dispatch2cu_wg_wf_count,
   dispatch2cu_wf_size_dispatch, dispatch2cu_sgpr_base_dispatch,
   dispatch2cu_vgpr_base_dispatch, dispatch2cu_wf_tag_dispatch,
   dispatch2cu_lds_base_dispatch, dispatch2cu_start_pc_dispatch,
   // Inputs
   clk, rst, inflight_wg_buffer_gpu_valid,
   inflight_wg_buffer_gpu_wf_size, inflight_wg_buffer_start_pc,
   inflight_wg_buffer_gpu_vgpr_size_per_wf,
   inflight_wg_buffer_gpu_sgpr_size_per_wf, allocator_wg_id_out,
   allocator_cu_id_out, allocator_wf_count, allocator_vgpr_start_out,
   allocator_sgpr_start_out, allocator_lds_start_out,
   allocator_gds_start_out, dis_controller_wg_alloc_valid,
   dis_controller_wg_dealloc_valid, cu2dispatch_wf_done,
   cu2dispatch_wf_tag_done
   ) ;

   parameter WG_ID_WIDTH = 6;

   parameter WF_COUNT_WIDTH = 4;
   parameter WG_SLOT_ID_WIDTH = 6;
   parameter NUMBER_WF_SLOTS = 40;

   parameter NUMBER_CU = 8;
   parameter CU_ID_WIDTH = 3;
   parameter VGPR_ID_WIDTH = 8;
   parameter SGPR_ID_WIDTH = 4;
   parameter LDS_ID_WIDTH = 10;

   parameter GDS_ID_WIDTH = 10;
   
   parameter TAG_WIDTH = 15;
   
   parameter MEM_ADDR_WIDTH = 32;
   parameter WAVE_ITEM_WIDTH = 6;

   parameter CU_VGPR_ID_WIDTH = 10;
   parameter CU_SGPR_ID_WIDTH = 9;
   parameter CU_LDS_ID_WIDTH = 16;
   parameter CU_GDS_ID_WIDTH = 16;
   
   input clk, rst;
   
   input 		       inflight_wg_buffer_gpu_valid;
   input [WAVE_ITEM_WIDTH-1:0] inflight_wg_buffer_gpu_wf_size;
   input [MEM_ADDR_WIDTH-1:0]  inflight_wg_buffer_start_pc;
   input [VGPR_ID_WIDTH :0]    inflight_wg_buffer_gpu_vgpr_size_per_wf;
   input [SGPR_ID_WIDTH :0]    inflight_wg_buffer_gpu_sgpr_size_per_wf;
   
   input [WG_ID_WIDTH-1:0]     allocator_wg_id_out;
   input [CU_ID_WIDTH-1 :0]    allocator_cu_id_out;
   input [WF_COUNT_WIDTH-1:0]  allocator_wf_count;   
   input [VGPR_ID_WIDTH-1 :0]  allocator_vgpr_start_out;
   input [SGPR_ID_WIDTH-1 :0]  allocator_sgpr_start_out;
   input [LDS_ID_WIDTH-1 :0]   allocator_lds_start_out;
   input [GDS_ID_WIDTH-1 :0]   allocator_gds_start_out;
   
   input 		       dis_controller_wg_alloc_valid;
   input 		       dis_controller_wg_dealloc_valid;
   
   output 		       gpu_interface_alloc_available, 
			       gpu_interface_dealloc_available;
   output [CU_ID_WIDTH-1:0]    gpu_interface_cu_id;
   output [WG_ID_WIDTH-1:0]    gpu_interface_dealloc_wg_id;
   


   // Interface with cus
   output [NUMBER_CU-1:0]      dispatch2cu_wf_dispatch;
   output [WF_COUNT_WIDTH-1:0] dispatch2cu_wg_wf_count;
   output [WAVE_ITEM_WIDTH-1:0] dispatch2cu_wf_size_dispatch;
   output [CU_SGPR_ID_WIDTH-1:0] dispatch2cu_sgpr_base_dispatch;
   output [CU_VGPR_ID_WIDTH-1:0] dispatch2cu_vgpr_base_dispatch;
   output [TAG_WIDTH-1:0] 	 dispatch2cu_wf_tag_dispatch;
   output [CU_LDS_ID_WIDTH-1:0]  dispatch2cu_lds_base_dispatch;
   output [MEM_ADDR_WIDTH-1:0] 	 dispatch2cu_start_pc_dispatch;
   
   input [NUMBER_CU-1:0]       cu2dispatch_wf_done;
   input [NUMBER_CU*TAG_WIDTH-1:0]    cu2dispatch_wf_tag_done;



   // Incomming finished wf -> increment finished count until all wf retire
   // Communicate back to utd
   // Deallocation registers
   reg 			       gpu_interface_dealloc_available_i;
   reg 			       dis_controller_wg_dealloc_valid_i;
   reg [NUMBER_CU-1:0] 	       handler_wg_done_ack;
   // Priority encoder
   reg 			       chosen_done_cu_valid,
			       chosen_done_cu_valid_comb;
   reg [CU_ID_WIDTH-1:0]       chosen_done_cu_id,
			       chosen_done_cu_id_comb;
   wire [NUMBER_CU-1:0]        handler_wg_done_valid;
   wire [NUMBER_CU*WG_ID_WIDTH-1:0] handler_wg_done_wg_id;

   reg [NUMBER_CU-1:0]       cu2dispatch_wf_done_i;
   reg [NUMBER_CU*TAG_WIDTH-1:0]    cu2dispatch_wf_tag_done_i;
   
   localparam NUM_DEALLOC_ST = 5;
   localparam ST_DEALLOC_IDLE = 1<<0;
   localparam ST_DEALLOC_WAIT_ACK = 1<<1;
   
   reg [NUM_DEALLOC_ST-1:0] 	    dealloc_st;
   
   // Incomming alloc wg -> get them a tag (find a free slot on the vector),
   // store wgid and wf count,
   // disparch them, one wf at a time
   // Allocation registters
   reg 				    dis_controller_wg_alloc_valid_i;
   reg 				    inflight_wg_buffer_gpu_valid_i;
   reg [WAVE_ITEM_WIDTH-1:0] 	    inflight_wg_buffer_gpu_wf_size_i;
   reg [MEM_ADDR_WIDTH-1:0] 	    inflight_wg_buffer_start_pc_i;
   reg [VGPR_ID_WIDTH :0] 	    inflight_wg_buffer_gpu_vgpr_size_per_wf_i;
   reg [SGPR_ID_WIDTH :0] 	    inflight_wg_buffer_gpu_sgpr_size_per_wf_i;
   
   
   reg [WG_ID_WIDTH-1:0] 	    allocator_wg_id_out_i;
   reg [CU_ID_WIDTH-1 :0] 	    allocator_cu_id_out_i;
   reg [WF_COUNT_WIDTH-1:0] 	    allocator_wf_count_i;   
   reg [VGPR_ID_WIDTH-1 :0] 	    allocator_vgpr_start_out_i;
   reg [SGPR_ID_WIDTH-1 :0] 	    allocator_sgpr_start_out_i;
   reg [LDS_ID_WIDTH-1 :0] 	    allocator_lds_start_out_i;
   reg [GDS_ID_WIDTH-1 :0] 	    allocator_gds_start_out_i;


   reg 				    gpu_interface_alloc_available_i;
   reg [CU_ID_WIDTH-1:0] 	    gpu_interface_cu_id_i;
   reg [WG_ID_WIDTH-1:0] 	    gpu_interface_dealloc_wg_id_i;
   
   wire [NUMBER_CU-1:0] 	    dispatch2cu_wf_dispatch_handlers;
   wire [NUMBER_CU*15-1:0] 	    dispatch2cu_wf_tag_dispatch_handlers;
   
   
   reg [NUMBER_CU-1:0] 		    handler_wg_alloc_en;
   reg [NUMBER_CU*WG_ID_WIDTH-1:0]  handler_wg_alloc_wg_id;
   reg [NUMBER_CU*(WF_COUNT_WIDTH)-1:0] handler_wg_alloc_wf_count;

   reg [NUMBER_CU-1:0] 			dispatch2cu_wf_dispatch_i;
   reg [WF_COUNT_WIDTH-1:0] 		dispatch2cu_wg_wf_count_i;
   reg [WAVE_ITEM_WIDTH-1:0] 		dispatch2cu_wf_size_dispatch_i;
   reg [SGPR_ID_WIDTH-1:0] 		dispatch2cu_sgpr_base_dispatch_i;
   reg [VGPR_ID_WIDTH-1:0] 		dispatch2cu_vgpr_base_dispatch_i;
   reg [TAG_WIDTH-1:0] 			dispatch2cu_wf_tag_dispatch_i;
   reg [LDS_ID_WIDTH-1:0] 		dispatch2cu_lds_base_dispatch_i;
   reg [MEM_ADDR_WIDTH-1:0] 		dispatch2cu_start_pc_dispatch_i;
   

   localparam NUM_ALLOC_ST = 4;
   localparam ST_ALLOC_IDLE = 1<<0;
   localparam ST_ALLOC_WAIT_BUFFER = 1<<1;
   localparam ST_ALLOC_WAIT_HANDLER = 1<<2;
   localparam ST_ALLOC_PASS_WF = 1<<3;
   reg [NUM_ALLOC_ST-1:0] 	       alloc_st;

   
   // cu handler
   // handles retired cus
   // table with wg_ids, wf_counters and wf_retired_counters for each cu
   // bitmaps with free slots
   cu_handler
     #(/*AUTOINSTPARAM*/
       // Parameters
       .WF_COUNT_WIDTH			(WF_COUNT_WIDTH),
       .WG_ID_WIDTH			(WG_ID_WIDTH),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS			(NUMBER_WF_SLOTS),
       .TAG_WIDTH			(TAG_WIDTH))
   handlers[NUMBER_CU-1:0]
     (
      // Outputs
      .dispatch2cu_wf_dispatch		(dispatch2cu_wf_dispatch_handlers),
      .dispatch2cu_wf_tag_dispatch	(dispatch2cu_wf_tag_dispatch_handlers),
      .wg_done_valid			(handler_wg_done_valid),
      .wg_done_wg_id			(handler_wg_done_wg_id),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .wg_alloc_en			(handler_wg_alloc_en),
      .wg_alloc_wg_id			(handler_wg_alloc_wg_id),
      .wg_alloc_wf_count		(handler_wg_alloc_wf_count),
      .cu2dispatch_wf_done_i		(cu2dispatch_wf_done_i),
      .cu2dispatch_wf_tag_done_i	(cu2dispatch_wf_tag_done_i),
      .wg_done_ack			(handler_wg_done_ack));

   
   always @( posedge clk or posedge rst ) begin
      if (rst) begin
	 alloc_st <= ST_ALLOC_IDLE;
	 dealloc_st <= ST_DEALLOC_IDLE;
      
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 allocator_cu_id_out_i <= {CU_ID_WIDTH{1'b0}};
	 allocator_gds_start_out_i <= {GDS_ID_WIDTH{1'b0}};
	 allocator_lds_start_out_i <= {LDS_ID_WIDTH{1'b0}};
	 allocator_sgpr_start_out_i <= {SGPR_ID_WIDTH{1'b0}};
	 allocator_vgpr_start_out_i <= {VGPR_ID_WIDTH{1'b0}};
	 allocator_wf_count_i <= {WF_COUNT_WIDTH{1'b0}};
	 allocator_wg_id_out_i <= {WG_ID_WIDTH{1'b0}};
	 chosen_done_cu_id <= {CU_ID_WIDTH{1'b0}};
	 chosen_done_cu_valid <= 1'h0;
	 cu2dispatch_wf_done_i <= {NUMBER_CU{1'b0}};
	 cu2dispatch_wf_tag_done_i <= {(1+(NUMBER_CU*TAG_WIDTH-1)){1'b0}};
	 dis_controller_wg_alloc_valid_i <= 1'h0;
	 dis_controller_wg_dealloc_valid_i <= 1'h0;
	 dispatch2cu_lds_base_dispatch_i <= 16'h0;
	 dispatch2cu_sgpr_base_dispatch_i <= 9'h0;
	 dispatch2cu_start_pc_dispatch_i <= {MEM_ADDR_WIDTH{1'b0}};
	 dispatch2cu_vgpr_base_dispatch_i <= 10'h0;
	 dispatch2cu_wf_dispatch_i <= {NUMBER_CU{1'b0}};
	 dispatch2cu_wf_size_dispatch_i <= {WAVE_ITEM_WIDTH{1'b0}};
	 dispatch2cu_wf_tag_dispatch_i <= {TAG_WIDTH{1'b0}};
	 dispatch2cu_wg_wf_count_i <= {WF_COUNT_WIDTH{1'b0}};
	 gpu_interface_alloc_available_i <= 1'h0;
	 gpu_interface_cu_id_i <= {CU_ID_WIDTH{1'b0}};
	 gpu_interface_dealloc_available_i <= 1'h0;
	 gpu_interface_dealloc_wg_id_i <= {WG_ID_WIDTH{1'b0}};
	 handler_wg_alloc_en <= {NUMBER_CU{1'b0}};
	 handler_wg_alloc_wf_count <= {(1+(NUMBER_CU*(WF_COUNT_WIDTH)-1)){1'b0}};
	 handler_wg_alloc_wg_id <= {(1+(NUMBER_CU*WG_ID_WIDTH-1)){1'b0}};
	 handler_wg_done_ack <= {NUMBER_CU{1'b0}};
	 inflight_wg_buffer_gpu_sgpr_size_per_wf_i <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	 inflight_wg_buffer_gpu_valid_i <= 1'h0;
	 inflight_wg_buffer_gpu_vgpr_size_per_wf_i <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	 inflight_wg_buffer_gpu_wf_size_i <= {WAVE_ITEM_WIDTH{1'b0}};
	 inflight_wg_buffer_start_pc_i <= {MEM_ADDR_WIDTH{1'b0}};
	 // End of automatics
   end // if (rst)
      else begin
	 dis_controller_wg_alloc_valid_i <= dis_controller_wg_alloc_valid;
	 inflight_wg_buffer_gpu_valid_i <= inflight_wg_buffer_gpu_valid;

	 if(inflight_wg_buffer_gpu_valid) begin
	    inflight_wg_buffer_gpu_wf_size_i <= inflight_wg_buffer_gpu_wf_size;
	    inflight_wg_buffer_start_pc_i <= inflight_wg_buffer_start_pc;
	    inflight_wg_buffer_gpu_vgpr_size_per_wf_i
	      <= inflight_wg_buffer_gpu_vgpr_size_per_wf;
	    inflight_wg_buffer_gpu_sgpr_size_per_wf_i 
	      <= inflight_wg_buffer_gpu_sgpr_size_per_wf;
	    
	 end

	 if(dis_controller_wg_alloc_valid) begin
	    allocator_wg_id_out_i <= allocator_wg_id_out;
	    allocator_cu_id_out_i <= allocator_cu_id_out;
	    allocator_wf_count_i <= allocator_wf_count;   
	    allocator_vgpr_start_out_i <= allocator_vgpr_start_out;
	    allocator_sgpr_start_out_i <= allocator_sgpr_start_out;
	    allocator_lds_start_out_i <= allocator_lds_start_out;
	    allocator_gds_start_out_i <= allocator_gds_start_out;
	 end
	 
	 // On allocation
	 // Receives wg_id, waits for sizes per wf
	 // Pass values to cu_handler -> for each dispatch in 1, pass one wf to cus
	 // after passing, sets itself as available again
	 handler_wg_alloc_en <= 0;
	 dispatch2cu_wf_dispatch_i <= 0;
	 case (alloc_st) 
	   ST_ALLOC_IDLE: begin
	      gpu_interface_alloc_available_i <= 1'b1;
	      if(dis_controller_wg_alloc_valid_i) begin
		 if(inflight_wg_buffer_gpu_valid_i) begin
		    handler_wg_alloc_en[allocator_cu_id_out_i] <= 1'b1;
		    handler_wg_alloc_wg_id[allocator_cu_id_out_i*WG_ID_WIDTH+:
					   WG_ID_WIDTH]
		      <= allocator_wg_id_out_i;
		    handler_wg_alloc_wf_count[allocator_cu_id_out_i*(WF_COUNT_WIDTH+1)+:
					      WF_COUNT_WIDTH]
		      <= allocator_wf_count_i;
		    gpu_interface_alloc_available_i <= 1'b0;
		    alloc_st <= ST_ALLOC_WAIT_HANDLER;
		 end else begin
		    gpu_interface_alloc_available_i <= 1'b0;
		    alloc_st <= ST_ALLOC_WAIT_BUFFER;
		 end
	      end // if (dis_controller_wg_alloc_valid_i)
	   end // case: ST_ALLOC_IDLE
	   
	   
	   ST_ALLOC_WAIT_BUFFER: begin
	      if(inflight_wg_buffer_gpu_valid_i) begin
		 handler_wg_alloc_en[allocator_cu_id_out_i] <= 1'b1;
		 handler_wg_alloc_wg_id[allocator_cu_id_out_i*(WG_ID_WIDTH)+:
					WG_ID_WIDTH]
		   <= allocator_wg_id_out_i;
		 handler_wg_alloc_wf_count[allocator_cu_id_out_i*(WF_COUNT_WIDTH)+:
					   WF_COUNT_WIDTH]
		   <= allocator_wf_count_i;

		 alloc_st <= ST_ALLOC_WAIT_HANDLER;
	      end // if (inflight_wg_buffer_gpu_valid_i)
	   end // case: ST_ALLOC_WAIT_BUFFER
	   
	   
	   ST_ALLOC_WAIT_HANDLER: begin
	      if(dispatch2cu_wf_dispatch_handlers[allocator_cu_id_out_i]) begin
		 dispatch2cu_wf_dispatch_i[allocator_cu_id_out_i] <= 1'b1;
		 dispatch2cu_wf_tag_dispatch_i
		   <= dispatch2cu_wf_tag_dispatch_handlers[allocator_cu_id_out_i*15+:
							   15];

		 dispatch2cu_wg_wf_count_i <= allocator_wf_count_i;
		 dispatch2cu_wf_size_dispatch_i <= inflight_wg_buffer_gpu_wf_size;
		 dispatch2cu_sgpr_base_dispatch_i <= allocator_sgpr_start_out_i;
		 dispatch2cu_vgpr_base_dispatch_i <= allocator_vgpr_start_out_i;
		 dispatch2cu_lds_base_dispatch_i <= allocator_lds_start_out_i;
		 dispatch2cu_start_pc_dispatch_i <= inflight_wg_buffer_start_pc_i;
		 alloc_st <= ST_ALLOC_PASS_WF;
	      end // if (dispatch2cu_wf_dispatch_handlers[allocator_cu_id_out_i])
	   end // case: ST_ALLOC_WAIT_HANDLER

	   ST_ALLOC_PASS_WF: begin
	      if(dispatch2cu_wf_dispatch_handlers[allocator_cu_id_out_i]) begin
		 dispatch2cu_wf_dispatch_i[allocator_cu_id_out_i]
									    <= 1'b1;
		 dispatch2cu_wf_tag_dispatch_i
		   <= dispatch2cu_wf_tag_dispatch_handlers[allocator_cu_id_out_i*15+:
							   15];
		 dispatch2cu_sgpr_base_dispatch_i 
		   <= dispatch2cu_sgpr_base_dispatch_i + 
		      inflight_wg_buffer_gpu_sgpr_size_per_wf_i;
		 dispatch2cu_vgpr_base_dispatch_i 
		   <= dispatch2cu_vgpr_base_dispatch_i  + 
		      inflight_wg_buffer_gpu_vgpr_size_per_wf_i;
	      end
	      else begin
		 gpu_interface_alloc_available_i <= 1'b1;
		 alloc_st <= ST_ALLOC_IDLE;
	      end
	   end
	   
	 endcase // case (alloc_st)
	 

	 cu2dispatch_wf_done_i <= cu2dispatch_wf_done;
	 cu2dispatch_wf_tag_done_i <= cu2dispatch_wf_tag_done;
	 
	 // On dealloc
	 // Ack to the handler
	 // pass info to the dispatcher
	 dis_controller_wg_dealloc_valid_i <= dis_controller_wg_dealloc_valid;
	 chosen_done_cu_valid <= chosen_done_cu_valid_comb;
	 chosen_done_cu_id <= chosen_done_cu_id_comb;
	 
	 gpu_interface_dealloc_available_i <= 1'b0;
	 handler_wg_done_ack <= 0;
	 case (dealloc_st) 
	   ST_DEALLOC_IDLE: begin
	      if(chosen_done_cu_valid) begin
		 gpu_interface_dealloc_available_i <= 1'b1;
		 gpu_interface_cu_id_i <= chosen_done_cu_id;
		 
		 handler_wg_done_ack[chosen_done_cu_id] <= 1'b1;
		 gpu_interface_dealloc_wg_id_i
		   <= handler_wg_done_wg_id[chosen_done_cu_id*WG_ID_WIDTH +:
					    WG_ID_WIDTH];
		 dealloc_st <= ST_DEALLOC_WAIT_ACK;
	      end
	   end
	   ST_DEALLOC_WAIT_ACK: begin
	      if(dis_controller_wg_dealloc_valid_i) begin
		 dealloc_st <= ST_DEALLOC_IDLE;
	      end
	      else begin
		 gpu_interface_dealloc_available_i <= 1'b1;
	      end
	      
	   end
	 endcase // case (dealloc_st)
	 
      end // else: !if(rst)
      
   end // always @ ( posedge clk or posedge rst )

   always @ ( /*AUTOSENSE*/handler_wg_done_valid) begin : PRI_ENC_DONE_WG
      integer i;
      reg cu_found_valid;
      reg [CU_ID_WIDTH-1:0] cu_found;

      cu_found_valid = 1'b0;
      cu_found = 0;
      
      for (i=0; i<NUMBER_CU; i=i+1) begin
	 if(handler_wg_done_valid[i] && !cu_found_valid) begin
	    cu_found_valid = 1'b1;
	    cu_found = i;
	 end
      end

      chosen_done_cu_valid_comb = cu_found_valid;
      chosen_done_cu_id_comb = cu_found;
      
   end // block: PRI_ENC_DONE_WG

   assign gpu_interface_dealloc_available = gpu_interface_dealloc_available_i;
   assign gpu_interface_dealloc_wg_id = gpu_interface_dealloc_wg_id_i;
   assign gpu_interface_cu_id = gpu_interface_cu_id_i;
   assign gpu_interface_alloc_available = gpu_interface_alloc_available_i;

   assign dispatch2cu_wf_dispatch = dispatch2cu_wf_dispatch_i;
   assign dispatch2cu_wf_tag_dispatch = dispatch2cu_wf_tag_dispatch_i;
   assign dispatch2cu_wg_wf_count = dispatch2cu_wg_wf_count_i;
   assign dispatch2cu_wf_size_dispatch = dispatch2cu_wf_size_dispatch_i;
   // Fill low bits with zeros
   localparam [CU_VGPR_ID_WIDTH-VGPR_ID_WIDTH-1:0] VGPR_LOW_BITS 
     = {(CU_VGPR_ID_WIDTH-VGPR_ID_WIDTH){1'b0}};
   localparam [CU_SGPR_ID_WIDTH-SGPR_ID_WIDTH-1:0] SGPR_LOW_BITS 
     = {(CU_SGPR_ID_WIDTH-SGPR_ID_WIDTH){1'b0}};
   localparam [CU_LDS_ID_WIDTH-LDS_ID_WIDTH-1:0] LDS_LOW_BITS 
     = {(CU_LDS_ID_WIDTH-LDS_ID_WIDTH){1'b0}};
   
   
   assign dispatch2cu_sgpr_base_dispatch 
     = {dispatch2cu_sgpr_base_dispatch_i, SGPR_LOW_BITS};
   assign dispatch2cu_vgpr_base_dispatch 
     = {dispatch2cu_vgpr_base_dispatch_i, VGPR_LOW_BITS};
   assign dispatch2cu_lds_base_dispatch 
     = {dispatch2cu_lds_base_dispatch_i, LDS_LOW_BITS};
   
   assign dispatch2cu_start_pc_dispatch = dispatch2cu_start_pc_dispatch_i;
   
endmodule // gpu_interface
