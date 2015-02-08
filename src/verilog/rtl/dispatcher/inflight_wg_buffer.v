module  inflight_wg_buffer 
  (/*AUTOARG*/
   // Outputs
   inflight_wg_buffer_host_rcvd_ack, inflight_wg_buffer_host_wf_done,
   inflight_wg_buffer_host_wf_done_wg_id,
   inflight_wg_buffer_alloc_valid, inflight_wg_buffer_alloc_available,
   inflight_wg_buffer_alloc_wg_id, inflight_wg_buffer_alloc_num_wf,
   inflight_wg_buffer_alloc_vgpr_size,
   inflight_wg_buffer_alloc_sgpr_size,
   inflight_wg_buffer_alloc_lds_size,
   inflight_wg_buffer_alloc_gds_size, inflight_wg_buffer_gpu_valid,
   inflight_wg_buffer_gpu_vgpr_size_per_wf,
   inflight_wg_buffer_gpu_sgpr_size_per_wf,
   inflight_wg_buffer_gpu_wf_size, inflight_wg_buffer_start_pc,
   // Inputs
   clk, rst, host_wg_valid, host_wg_id, host_num_wf, host_wf_size,
   host_vgpr_size_total, host_sgpr_size_total, host_lds_size_total,
   host_gds_size_total, host_vgpr_size_per_wf, host_sgpr_size_per_wf,
   host_start_pc, dis_controller_start_alloc,
   dis_controller_wg_alloc_valid, dis_controller_wg_dealloc_valid,
   dis_controller_wg_rejected_valid, allocator_wg_id_out,
   gpu_interface_dealloc_wg_id
   ) ;

   input clk,rst;

   parameter WG_ID_WIDTH = 6;
   parameter WG_SLOT_ID_WIDTH = 10;
   parameter WF_COUNT_WIDTH = 4;
   
   parameter CU_ID_WIDTH = 6;
   parameter VGPR_ID_WIDTH = 10;
   parameter SGPR_ID_WIDTH = 10;
   parameter LDS_ID_WIDTH = 10;
   parameter GDS_ID_WIDTH = 10;

   parameter ENTRY_ADDR_WIDTH = 6;
   parameter NUMBER_ENTRIES = 64;

   parameter WAVE_ITEM_WIDTH = 6;

   parameter MEM_ADDR_WIDTH = 32;

   
   localparam WAIT_ENTRY_WIDTH = ( WG_ID_WIDTH + WF_COUNT_WIDTH +
				                   (VGPR_ID_WIDTH +1) + (SGPR_ID_WIDTH + 1) + 
				                   (LDS_ID_WIDTH +1) + (GDS_ID_WIDTH + 1) );

   localparam READY_ENTRY_WIDTH = ( MEM_ADDR_WIDTH + WAVE_ITEM_WIDTH + WG_ID_WIDTH + 
				                    (VGPR_ID_WIDTH +1) + (SGPR_ID_WIDTH + 1));

   // Shared index between two tables
   localparam SGPR_SIZE_L = 0;
   localparam SGPR_SIZE_H = SGPR_SIZE_L + SGPR_ID_WIDTH;
   
   localparam VGPR_SIZE_L = SGPR_SIZE_H + 1;
   localparam VGPR_SIZE_H = VGPR_SIZE_L + VGPR_ID_WIDTH;

   localparam WG_ID_L = VGPR_SIZE_H + 1;
   localparam WG_ID_H = WG_ID_L + WG_ID_WIDTH - 1;

   // Indexes for table with waiting wg
   localparam GDS_SIZE_L = WG_ID_H + 1;
   localparam GDS_SIZE_H = GDS_SIZE_L + GDS_ID_WIDTH;
   
   localparam LDS_SIZE_L = GDS_SIZE_H + 1;
   localparam LDS_SIZE_H = LDS_SIZE_L + LDS_ID_WIDTH;
   

   localparam WG_COUNT_L = LDS_SIZE_H + 1;
   localparam WG_COUNT_H = WG_COUNT_L + WF_COUNT_WIDTH-1;

   // Index for table with read wg
   localparam WF_SIZE_L = WG_ID_H + 1;
   localparam WF_SIZE_H = WF_SIZE_L + WAVE_ITEM_WIDTH - 1;
   localparam START_PC_L = WF_SIZE_H + 1;
   localparam START_PC_H = START_PC_L + MEM_ADDR_WIDTH -1;
   
   input host_wg_valid;
   input [WG_ID_WIDTH-1:0] host_wg_id;
   input [WF_COUNT_WIDTH-1:0] host_num_wf;
   input [WAVE_ITEM_WIDTH-1:0] host_wf_size; // number of work itens in the last wf
   input [VGPR_ID_WIDTH :0]    host_vgpr_size_total;
   input [SGPR_ID_WIDTH :0]    host_sgpr_size_total;
   input [LDS_ID_WIDTH :0]     host_lds_size_total;
   input [GDS_ID_WIDTH :0]     host_gds_size_total;
   input [VGPR_ID_WIDTH :0]    host_vgpr_size_per_wf;
   input [SGPR_ID_WIDTH :0]    host_sgpr_size_per_wf;
   input [MEM_ADDR_WIDTH-1:0]  host_start_pc;   

   
   input                       dis_controller_start_alloc;
   input                       dis_controller_wg_alloc_valid;
   input                       dis_controller_wg_dealloc_valid;
   input                       dis_controller_wg_rejected_valid;

   input [WG_ID_WIDTH-1:0]     allocator_wg_id_out;
   input [WG_ID_WIDTH-1:0]     gpu_interface_dealloc_wg_id;

   // Output to the host interface
   output                      inflight_wg_buffer_host_rcvd_ack;
   output                      inflight_wg_buffer_host_wf_done;
   output [WG_ID_WIDTH-1:0]    inflight_wg_buffer_host_wf_done_wg_id;

   // Output to the allocator
   // Allocator informs that there are valid wg and then the gpu ask for it
   // after a wg is passed to the gpu, it is cleared from the table
   // the resource table has all information on running wg resources
   output                      inflight_wg_buffer_alloc_valid;
   output                      inflight_wg_buffer_alloc_available;
   output [WG_ID_WIDTH-1:0]    inflight_wg_buffer_alloc_wg_id;
   output [WF_COUNT_WIDTH-1:0] inflight_wg_buffer_alloc_num_wf;
   output [VGPR_ID_WIDTH :0]   inflight_wg_buffer_alloc_vgpr_size;
   output [SGPR_ID_WIDTH :0]   inflight_wg_buffer_alloc_sgpr_size;
   output [LDS_ID_WIDTH :0]    inflight_wg_buffer_alloc_lds_size;
   output [GDS_ID_WIDTH :0]    inflight_wg_buffer_alloc_gds_size;

   output                      inflight_wg_buffer_gpu_valid;
   output [VGPR_ID_WIDTH :0]   inflight_wg_buffer_gpu_vgpr_size_per_wf;
   output [SGPR_ID_WIDTH :0]   inflight_wg_buffer_gpu_sgpr_size_per_wf;
   output [WAVE_ITEM_WIDTH-1:0] inflight_wg_buffer_gpu_wf_size;
   output [MEM_ADDR_WIDTH-1:0]  inflight_wg_buffer_start_pc;   

   // table with all inflight wg
   // receives (sizes + start pc addr + id) from host

   // tables
   // flow control from host - gives ack
   // flow control to allocator
   // accepted/reject cu

   // how many entries (??)


   
   reg                          host_wg_valid_i;
   reg [WG_ID_WIDTH-1:0]        host_wg_id_i;
   reg [WF_COUNT_WIDTH-1:0]     host_num_wf_i;
   reg [WAVE_ITEM_WIDTH-1 :0]   host_wf_size_i;
   reg [VGPR_ID_WIDTH :0]       host_vgpr_size_total_i;
   reg [SGPR_ID_WIDTH :0]       host_sgpr_size_total_i;
   reg [LDS_ID_WIDTH :0]        host_lds_size_total_i;
   reg [GDS_ID_WIDTH :0]        host_gds_size_total_i;
   reg [VGPR_ID_WIDTH :0]       host_vgpr_size_per_wf_i;
   reg [SGPR_ID_WIDTH :0]       host_sgpr_size_per_wf_i;
   reg [MEM_ADDR_WIDTH-1:0]     host_start_pc_i;   

   reg                          dis_controller_start_alloc_i;
   reg                          dis_controller_wg_alloc_valid_i;
   reg                          dis_controller_wg_dealloc_valid_i;
   reg                          dis_controller_wg_rejected_valid_i;

   reg [WG_ID_WIDTH-1:0]        inflight_wg_buffer_alloc_wg_id_i;
   reg [WF_COUNT_WIDTH-1:0]     inflight_wg_buffer_alloc_num_wf_i;
   reg [VGPR_ID_WIDTH :0]       inflight_wg_buffer_alloc_vgpr_start_i;
   reg [SGPR_ID_WIDTH :0]       inflight_wg_buffer_alloc_sgpr_start_i;
   reg [LDS_ID_WIDTH :0]        inflight_wg_buffer_alloc_lds_start_i;
   reg [VGPR_ID_WIDTH :0]       inflight_wg_buffer_alloc_vgpr_size_i;
   reg [SGPR_ID_WIDTH :0]       inflight_wg_buffer_alloc_sgpr_size_i;
   reg [LDS_ID_WIDTH :0]        inflight_wg_buffer_alloc_lds_size_i;
   reg [GDS_ID_WIDTH :0]        inflight_wg_buffer_alloc_gds_size_i;

   reg                          inflight_wg_buffer_gpu_valid_i;
   reg [VGPR_ID_WIDTH :0]       inflight_wg_buffer_gpu_vgpr_size_per_wf_i;
   reg [SGPR_ID_WIDTH :0]       inflight_wg_buffer_gpu_sgpr_size_per_wf_i;
   reg [MEM_ADDR_WIDTH-1:0]     inflight_wg_buffer_start_pc_i;
   reg [WAVE_ITEM_WIDTH-1 :0]   inflight_wg_buffer_gpu_wf_size_i;

   
   reg [WG_ID_WIDTH-1:0]        allocator_wg_id_out_i;
   reg [WG_ID_WIDTH-1:0]        gpu_interface_dealloc_wg_id_i;

   reg                          wait_tbl_busy;
   
   reg [NUMBER_ENTRIES-1 : 0]   waiting_tbl_valid, waiting_tbl_pending;
   reg [ENTRY_ADDR_WIDTH-1:0]   new_index, new_index_comb;
   reg [ENTRY_ADDR_WIDTH-1:0]   chosen_entry, chosen_entry_comb, 
			                    last_chosen_entry_rr;
   
   reg [ENTRY_ADDR_WIDTH-1:0]   tbl_walk_idx;
   reg [WAIT_ENTRY_WIDTH-1:0]   new_entry_wr_reg;
   reg [READY_ENTRY_WIDTH-1:0]  ready_tbl_wr_reg;
   
   wire [WAIT_ENTRY_WIDTH-1:0]  table_walk_rd_reg;
   wire [READY_ENTRY_WIDTH-1:0] ready_tbl_rd_reg;
   
   reg [WG_ID_WIDTH-1:0]        tbl_walk_wg_id_searched;
   
   
   reg                          chosen_entry_is_valid, chosen_entry_is_valid_comb;
   reg                          wg_waiting_alloc_valid;
   
   
   reg                          new_index_wr_en, tbl_walk_rd_en,
				                tbl_walk_rd_valid;

   reg                          inflight_wg_buffer_host_wf_done_i;
   reg [WG_ID_WIDTH-1:0]        inflight_wg_buffer_host_wf_done_wg_id_i;
   reg                          inflight_wg_buffer_host_rcvd_ack_i;
   
   
   localparam INFLIGHT_TB_RD_HOST_NUM_STATES = 5;
   localparam ST_RD_HOST_IDLE = 1<<0;
   localparam ST_RD_HOST_GET_FROM_HOST = 1<<1;
   localparam ST_RD_HOST_ACK_TO_HOST = 1<<2;
   localparam ST_RD_HOST_PROPAG_ACK = 1<<3;
   localparam ST_RD_HOST_PROPAG_ACK2 = 1<<4;
   
   reg [INFLIGHT_TB_RD_HOST_NUM_STATES-1:0] inflight_tbl_rd_host_st;

   localparam INFLIGHT_TB_ALLOC_NUM_STATES = 8;
   localparam ST_ALLOC_IDLE = 1<<0;
   localparam ST_ALLOC_WAIT_RESULT = 1<<1;
   localparam ST_ALLOC_FIND_ACCEPTED = 1<<2;
   localparam ST_ALLOC_CLEAR_ACCEPTED = 1<<3;
   localparam ST_ALLOC_FIND_REJECTED = 1<<4;
   localparam ST_ALLOC_CLEAR_REJECTED = 1<<5;
   localparam ST_ALLOC_GET_ALLOC_WG = 1<<6;
   localparam ST_ALLOC_UP_ALLOC_WG = 1<<7;
   reg [INFLIGHT_TB_ALLOC_NUM_STATES-1:0]   inflight_tbl_alloc_st;
   
   reg                                      inflight_wg_buffer_full_i;
   
   
   
   // ram for size+start pc + id + alloc attemp
   // w port: host/alloc attemp // r port: allocator/cu (arbiter)
   ram_2_port
     #(
       // Parameters
       .WORD_SIZE			(WAIT_ENTRY_WIDTH),
       .ADDR_SIZE			(ENTRY_ADDR_WIDTH),
       .NUM_WORDS			(NUMBER_ENTRIES))
   ram_wg_waiting_allocation 
     (
      // Outputs
      .rd_word				(table_walk_rd_reg),
      // Inputs
      .rst				(rst),
      .clk				(clk),
      .wr_en				(new_index_wr_en),
      .wr_addr				(new_index),
      .wr_word				(new_entry_wr_reg),
      .rd_en				(tbl_walk_rd_en),
      .rd_addr				(tbl_walk_idx));

   // ram for wg_id + starts
   // w port: host // r port: cu
   ram_2_port
     #(
       // Parameters
       .WORD_SIZE			(READY_ENTRY_WIDTH),
       .ADDR_SIZE			(ENTRY_ADDR_WIDTH),
       .NUM_WORDS			(NUMBER_ENTRIES))
   ram_wg_ready_start 
     (
      // Outputs
      .rd_word				(ready_tbl_rd_reg),
      // Inputs
      .rst				(rst),
      .clk				(clk),
      .wr_en				(new_index_wr_en),
      .wr_addr				(new_index),
      .wr_word				(ready_tbl_wr_reg),
      .rd_en				(tbl_walk_rd_en),
      .rd_addr				(tbl_walk_idx));
   

   /**
    receives wg from host -> puts into waiting table
    if there are waiting wg -> signals to controller
    controller picks a wg -> clears entry from waiting table
    controllers rejects a picked wg -> increment rejected counter, puts back into waiting table
    cu finishes wg -> informs host
    
    table to convert wgid to index!! - think about this (table walker??)
    
    2 priority encoders:
    1 to find free index
    2 to find wg to chose - round robin on this
    **/
   // allocator -> state machine that choses between updating the allocated 
   //              wf or reading the done wf

   always @ (  posedge clk or posedge rst  ) begin
      if(rst) begin
	     inflight_tbl_alloc_st <= ST_ALLOC_IDLE;
	     inflight_tbl_rd_host_st <= ST_RD_HOST_IDLE;	     
	     last_chosen_entry_rr <= {ENTRY_ADDR_WIDTH{1'b1}};
	     /*AUTORESET*/
	     // Beginning of autoreset for uninitialized flops
	     allocator_wg_id_out_i <= {WG_ID_WIDTH{1'b0}};
	     chosen_entry <= {ENTRY_ADDR_WIDTH{1'b0}};
	     chosen_entry_is_valid <= 1'h0;
	     dis_controller_start_alloc_i <= 1'h0;
	     dis_controller_wg_alloc_valid_i <= 1'h0;
	     dis_controller_wg_dealloc_valid_i <= 1'h0;
	     dis_controller_wg_rejected_valid_i <= 1'h0;
	     gpu_interface_dealloc_wg_id_i <= {WG_ID_WIDTH{1'b0}};
	     host_gds_size_total_i <= {(1+(GDS_ID_WIDTH)){1'b0}};
	     host_lds_size_total_i <= {(1+(LDS_ID_WIDTH)){1'b0}};
	     host_num_wf_i <= {WF_COUNT_WIDTH{1'b0}};
	     host_sgpr_size_per_wf_i <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	     host_sgpr_size_total_i <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	     host_start_pc_i <= {MEM_ADDR_WIDTH{1'b0}};
	     host_vgpr_size_per_wf_i <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	     host_vgpr_size_total_i <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	     host_wf_size_i <= {WAVE_ITEM_WIDTH{1'b0}};
	     host_wg_id_i <= {WG_ID_WIDTH{1'b0}};
	     host_wg_valid_i <= 1'h0;
	     inflight_wg_buffer_alloc_gds_size_i <= {(1+(GDS_ID_WIDTH)){1'b0}};
	     inflight_wg_buffer_alloc_lds_size_i <= {(1+(LDS_ID_WIDTH)){1'b0}};
	     inflight_wg_buffer_alloc_num_wf_i <= {WF_COUNT_WIDTH{1'b0}};
	     inflight_wg_buffer_alloc_sgpr_size_i <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	     inflight_wg_buffer_alloc_vgpr_size_i <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	     inflight_wg_buffer_alloc_wg_id_i <= {WG_ID_WIDTH{1'b0}};
	     inflight_wg_buffer_gpu_sgpr_size_per_wf_i <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	     inflight_wg_buffer_gpu_valid_i <= 1'h0;
	     inflight_wg_buffer_gpu_vgpr_size_per_wf_i <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	     inflight_wg_buffer_gpu_wf_size_i <= {WAVE_ITEM_WIDTH{1'b0}};
	     inflight_wg_buffer_host_rcvd_ack_i <= 1'h0;
	     inflight_wg_buffer_host_wf_done_i <= 1'h0;
	     inflight_wg_buffer_host_wf_done_wg_id_i <= {WG_ID_WIDTH{1'b0}};
	     inflight_wg_buffer_start_pc_i <= {MEM_ADDR_WIDTH{1'b0}};
	     new_entry_wr_reg <= {WAIT_ENTRY_WIDTH{1'b0}};
	     new_index <= {ENTRY_ADDR_WIDTH{1'b0}};
	     new_index_wr_en <= 1'h0;
	     ready_tbl_wr_reg <= {READY_ENTRY_WIDTH{1'b0}};
	     tbl_walk_idx <= {ENTRY_ADDR_WIDTH{1'b0}};
	     tbl_walk_rd_en <= 1'h0;
	     tbl_walk_rd_valid <= 1'h0;
	     tbl_walk_wg_id_searched <= {WG_ID_WIDTH{1'b0}};
	     wait_tbl_busy <= 1'h0;
	     waiting_tbl_pending <= {NUMBER_ENTRIES{1'b0}};
	     waiting_tbl_valid = {NUMBER_ENTRIES{1'b0}};
	     wg_waiting_alloc_valid <= 1'h0;
	     // End of automatics

	     
      end
      else begin
	     // Input signals
	     host_wg_valid_i <= host_wg_valid;
	     host_wg_id_i <= host_wg_id;
	     host_num_wf_i <= host_num_wf;
	     host_wf_size_i <= host_wf_size;
	     host_vgpr_size_total_i <= host_vgpr_size_total;
	     host_sgpr_size_total_i <= host_sgpr_size_total;
	     host_lds_size_total_i <= host_lds_size_total;
	     host_gds_size_total_i <= host_gds_size_total;
	     host_vgpr_size_per_wf_i <= host_vgpr_size_per_wf;
	     host_sgpr_size_per_wf_i <= host_sgpr_size_per_wf;
	     host_start_pc_i <= host_start_pc;   

	     dis_controller_start_alloc_i <= dis_controller_start_alloc;

	     if(dis_controller_wg_alloc_valid) begin
	        dis_controller_wg_alloc_valid_i <= 1'b1;
	        allocator_wg_id_out_i <= allocator_wg_id_out;
	     end

	     if(dis_controller_wg_rejected_valid) begin
	        dis_controller_wg_rejected_valid_i <= 1'b1;
	        allocator_wg_id_out_i <= allocator_wg_id_out;
	     end
	     

	     dis_controller_wg_dealloc_valid_i <= dis_controller_wg_dealloc_valid;

	     gpu_interface_dealloc_wg_id_i <= gpu_interface_dealloc_wg_id;


	     // Deallocation logic
	     inflight_wg_buffer_host_wf_done_i <= 1'b0;
	     if(dis_controller_wg_dealloc_valid_i) begin
	        inflight_wg_buffer_host_wf_done_i <= 1'b1;
	        inflight_wg_buffer_host_wf_done_wg_id_i <= gpu_interface_dealloc_wg_id_i;
	     end

	     
	     inflight_wg_buffer_host_rcvd_ack_i <= 1'b0;
	     new_index <= new_index_comb;
	     new_index_wr_en <= 1'b0;
	     
	     case(inflight_tbl_rd_host_st)
	       ST_RD_HOST_IDLE: begin
	          if(host_wg_valid_i) begin
		         // Check if its full before getting the wg
		         if( !(&waiting_tbl_valid) ) begin
		            inflight_tbl_rd_host_st <= ST_RD_HOST_GET_FROM_HOST;
		         end
	          end
	       end

	       // Read wg from host and write it to table
	       // Ack wg
	       ST_RD_HOST_GET_FROM_HOST: begin
	          new_index_wr_en <= 1'b1;
	          new_entry_wr_reg <= { host_num_wf_i,
				                    host_lds_size_total_i, host_gds_size_total_i,
				                    host_wg_id_i,
				                    host_vgpr_size_total_i, host_sgpr_size_total_i };
	          ready_tbl_wr_reg <= {host_start_pc_i, host_wf_size_i, host_wg_id_i,
				                   host_vgpr_size_per_wf_i, host_sgpr_size_per_wf_i};
	          
	          inflight_tbl_rd_host_st <= ST_RD_HOST_ACK_TO_HOST;
	          inflight_wg_buffer_host_rcvd_ack_i <= 1'b1;
	       end

	       // Wait for the ack to propagate
	       ST_RD_HOST_ACK_TO_HOST: begin
	          waiting_tbl_valid[new_index] = 1'b1;
	          inflight_tbl_rd_host_st <= ST_RD_HOST_PROPAG_ACK;
	       end

	       ST_RD_HOST_PROPAG_ACK: begin
	          inflight_tbl_rd_host_st <= ST_RD_HOST_PROPAG_ACK2;
	       end

	       ST_RD_HOST_PROPAG_ACK2: begin
	          inflight_tbl_rd_host_st <= ST_RD_HOST_IDLE;
	       end
	       
	       
	     endcase // case (inflight_tbl_rd_host_st)
	     

	     // Reads the round robin output
	     chosen_entry_is_valid <= chosen_entry_is_valid_comb;
	     chosen_entry <= chosen_entry_comb;
	     // Updates the last read reg
	     if(dis_controller_start_alloc_i) begin
	        last_chosen_entry_rr <= chosen_entry;
	     end
	     tbl_walk_rd_valid <= tbl_walk_rd_en;

	     tbl_walk_rd_en <= 1'b0;
	     wait_tbl_busy <= 1'b1;
	     inflight_wg_buffer_gpu_valid_i <= 1'b0;
	     
	     case(inflight_tbl_alloc_st)
	       ST_ALLOC_IDLE: begin
	          // Start allocation if requested
	          if(dis_controller_start_alloc_i) begin
		         waiting_tbl_pending[chosen_entry] <= 1'b1;
		         wg_waiting_alloc_valid <= 1'b0;
		         inflight_tbl_alloc_st <= ST_ALLOC_WAIT_RESULT;
	          end
	          else if(!wg_waiting_alloc_valid && 
		              |(waiting_tbl_valid & ~waiting_tbl_pending) ) begin
		         inflight_tbl_alloc_st <= ST_ALLOC_GET_ALLOC_WG;
	          end
	          else begin
		         wait_tbl_busy <= 1'b0;
	          end

	       end

	       ST_ALLOC_WAIT_RESULT: begin
	          wait_tbl_busy <= 1'b0;
	          if(dis_controller_wg_alloc_valid_i) begin
		         dis_controller_wg_alloc_valid_i <= 1'b0;
		         tbl_walk_wg_id_searched <= allocator_wg_id_out_i;
		         tbl_walk_rd_en <= 1'b1;
		         tbl_walk_idx <= 0;
		         inflight_tbl_alloc_st <= ST_ALLOC_FIND_ACCEPTED;
	          end
	          else if(dis_controller_wg_rejected_valid_i) begin
		         dis_controller_wg_rejected_valid_i <= 1'b0;
		         tbl_walk_wg_id_searched <= allocator_wg_id_out_i;
		         tbl_walk_rd_en <= 1'b1;
		         tbl_walk_idx <= 0;
		         inflight_tbl_alloc_st <= ST_ALLOC_FIND_REJECTED;
	          end
	       end // case: ST_ALLOC_WAIT_RESULT
	       
	       
	       // Find the accepted wg in the table and get
	       // its index
	       ST_ALLOC_FIND_ACCEPTED: begin
	          if(tbl_walk_rd_valid) begin
		         // Move on if we found the correct entry
		         if( (table_walk_rd_reg[WG_ID_H:WG_ID_L] == 
		              tbl_walk_wg_id_searched)  &&
		             waiting_tbl_pending[tbl_walk_idx]) begin
		            
		            inflight_tbl_alloc_st <= ST_ALLOC_CLEAR_ACCEPTED;
		         end
		         else begin
		            tbl_walk_rd_en <= 1'b1;
		            tbl_walk_idx <= tbl_walk_idx + 1;
		         end
	          end // if (tbl_walk_rd_valid)
	          
	       end // case: ST_ALLOC_FIND_ACCEPTED
	       

	       // Clear the valid bit of the accepted wg
	       ST_ALLOC_CLEAR_ACCEPTED: begin
	          waiting_tbl_valid[tbl_walk_idx] = 1'b0;
	          waiting_tbl_pending[tbl_walk_idx] = 1'b0;

	          inflight_wg_buffer_gpu_valid_i <= 1'b1;
	          inflight_wg_buffer_gpu_vgpr_size_per_wf_i
		        <= ready_tbl_rd_reg[VGPR_SIZE_H:VGPR_SIZE_L];
	          inflight_wg_buffer_gpu_sgpr_size_per_wf_i
		        <= ready_tbl_rd_reg[SGPR_SIZE_H:SGPR_SIZE_L];
	          inflight_wg_buffer_gpu_wf_size_i
		        <= ready_tbl_rd_reg[WF_SIZE_H:WF_SIZE_L];
	          inflight_wg_buffer_start_pc_i 
		        <= ready_tbl_rd_reg[START_PC_H:START_PC_L];
	          
	          
			  
	          inflight_tbl_alloc_st <= ST_ALLOC_GET_ALLOC_WG;
	       end

	       // Find the rejected wg in the table and get
	       // its index
	       ST_ALLOC_FIND_REJECTED: begin
	          if(tbl_walk_rd_valid) begin
		         // Move on if we found the correct entry
		         if( (table_walk_rd_reg[WG_ID_H:WG_ID_L] == 
		              tbl_walk_wg_id_searched)  &&
		             waiting_tbl_pending[tbl_walk_idx]) begin
		            inflight_tbl_alloc_st <= ST_ALLOC_CLEAR_REJECTED;
		         end
		         else begin
		            tbl_walk_rd_en <= 1'b1;
		            tbl_walk_idx <= tbl_walk_idx + 1;
		         end
	          end

	          
	       end // case: ST_ALLOC_FIND_REJECTED
	       

	       // Clear the valid bit of the rejected wg
	       ST_ALLOC_CLEAR_REJECTED: begin
	          waiting_tbl_pending[tbl_walk_idx] = 1'b0;
	          inflight_tbl_alloc_st <= ST_ALLOC_GET_ALLOC_WG;
	       end
	       
	       ST_ALLOC_GET_ALLOC_WG: begin
	          if(chosen_entry_is_valid) begin
		         tbl_walk_rd_en <= 1'b1;
		         tbl_walk_idx <= chosen_entry;
		         inflight_tbl_alloc_st <= ST_ALLOC_UP_ALLOC_WG;
	          end 
	          else begin
		         inflight_tbl_alloc_st <= ST_ALLOC_IDLE;
	          end
	          
	       end // case: ST_ALLOC_GET_ALLOC_WG
	       
	       ST_ALLOC_UP_ALLOC_WG: begin
	          if(tbl_walk_rd_valid) begin
		         
		         wg_waiting_alloc_valid <= 1'b1;
		         inflight_wg_buffer_alloc_wg_id_i <= table_walk_rd_reg[WG_ID_H:WG_ID_L];
		         inflight_wg_buffer_alloc_num_wf_i
		           <= table_walk_rd_reg[WG_COUNT_H:WG_COUNT_L];
		         inflight_wg_buffer_alloc_vgpr_size_i
		           <= table_walk_rd_reg[VGPR_SIZE_H:VGPR_SIZE_L];
		         inflight_wg_buffer_alloc_sgpr_size_i
		           <= table_walk_rd_reg[SGPR_SIZE_H:SGPR_SIZE_L];
		         inflight_wg_buffer_alloc_lds_size_i
		           <= table_walk_rd_reg[LDS_SIZE_H:LDS_SIZE_L];
		         inflight_wg_buffer_alloc_gds_size_i
		           <= table_walk_rd_reg[GDS_SIZE_H:GDS_SIZE_L];
		         
		         inflight_tbl_alloc_st <= ST_ALLOC_IDLE;
	          end // if (tbl_walk_rd_valid)
	          
	       end // case: ST_ALLOC_UP_ALLOC_WG
	       
	       
	     endcase // case (inflight_tbl_alloc_st)

	     
      end // else: !if(rst)
   end // always @ (  posedge clk or posedge rst  )


   assign inflight_wg_buffer_host_rcvd_ack = inflight_wg_buffer_host_rcvd_ack_i;
   assign inflight_wg_buffer_host_wf_done = inflight_wg_buffer_host_wf_done_i;
   assign inflight_wg_buffer_host_wf_done_wg_id 
     = inflight_wg_buffer_host_wf_done_wg_id_i;
   assign inflight_wg_buffer_alloc_valid
     = wg_waiting_alloc_valid;
   
   assign inflight_wg_buffer_alloc_wg_id = inflight_wg_buffer_alloc_wg_id_i;
   assign inflight_wg_buffer_alloc_num_wf = inflight_wg_buffer_alloc_num_wf_i;
   assign inflight_wg_buffer_alloc_vgpr_size = inflight_wg_buffer_alloc_vgpr_size_i;
   assign inflight_wg_buffer_alloc_sgpr_size = inflight_wg_buffer_alloc_sgpr_size_i;
   assign inflight_wg_buffer_alloc_lds_size = inflight_wg_buffer_alloc_lds_size_i;
   assign inflight_wg_buffer_alloc_gds_size = inflight_wg_buffer_alloc_gds_size_i;

   assign inflight_wg_buffer_gpu_valid = inflight_wg_buffer_gpu_valid_i;
   assign inflight_wg_buffer_gpu_vgpr_size_per_wf
     = inflight_wg_buffer_gpu_vgpr_size_per_wf_i;
   assign inflight_wg_buffer_gpu_sgpr_size_per_wf
     = inflight_wg_buffer_gpu_sgpr_size_per_wf_i;
   assign inflight_wg_buffer_gpu_wf_size
     = inflight_wg_buffer_gpu_wf_size_i;
   assign inflight_wg_buffer_start_pc = inflight_wg_buffer_start_pc_i;
   assign inflight_wg_buffer_alloc_available = !wait_tbl_busy;

   // Finds a free spot for the next wg from the host
   always @ ( /*AUTOSENSE*/waiting_tbl_valid) 
     begin : NEXT_IDX_PRI_ENC
	    // waiting_tbl_valid new_index_comb
	    reg [ENTRY_ADDR_WIDTH:0] i;
	    reg [ENTRY_ADDR_WIDTH-1:0] idx_found_entry;
	    reg                        found_entry_valid;

	    found_entry_valid = 1'b0;
	    idx_found_entry = 0;
	    
	    for (i = 0; i<NUMBER_ENTRIES; i = i+1) begin
	       if(!found_entry_valid && !waiting_tbl_valid[i]) begin
	          found_entry_valid = 1'b1;
	          idx_found_entry = i[ENTRY_ADDR_WIDTH-1:0];
	       end
	    end

	    new_index_comb = idx_found_entry;
	    
     end // block: NEXT_IDX_PRI_ENC
   

   // Finds a waiting wg to issue, implements a round robin to avoid
   // giving too much tries to wg that are hard to allocate
   always @ ( /*AUTOSENSE*/last_chosen_entry_rr or waiting_tbl_pending
	          or waiting_tbl_valid)
     begin : CHOSEN_IDX_PRI_ENC
	    // waiting_tbl_valid chosen_entry chosen_entry_comb last_chosen_entry_rr
	    reg [ENTRY_ADDR_WIDTH:0] i;
	    reg [ENTRY_ADDR_WIDTH-1:0] idx_found_entry;
	    reg                        found_entry_valid;
	    reg [NUMBER_ENTRIES-1 : 0] waiting_tbl_valid_rotated, waiting_not_pending;

	    waiting_not_pending = waiting_tbl_valid  & ~waiting_tbl_pending;
	    
	    waiting_tbl_valid_rotated 
	      = (waiting_not_pending<<(NUMBER_ENTRIES-(last_chosen_entry_rr+1))) |
	        (waiting_not_pending>>(last_chosen_entry_rr+1));
	    
	    found_entry_valid = 1'b0;
	    idx_found_entry = 0;
	    
	    for (i = 0; i<NUMBER_ENTRIES; i = i+1) begin
	       if(!found_entry_valid && waiting_tbl_valid_rotated[i]) begin
	          found_entry_valid = 1'b1;
	          idx_found_entry = i[ENTRY_ADDR_WIDTH-1:0] + last_chosen_entry_rr + 1;
	       end
	    end

	    chosen_entry_is_valid_comb = found_entry_valid;
	    chosen_entry_comb = idx_found_entry;
     end
   
endmodule // inflight_wg_buffer
