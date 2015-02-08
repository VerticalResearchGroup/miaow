module allocator
  (/*AUTOARG*/
   // Outputs
   allocator_cu_valid, allocator_cu_rejected, allocator_wg_id_out,
   allocator_cu_id_out, allocator_wf_count, allocator_vgpr_size_out,
   allocator_sgpr_size_out, allocator_lds_size_out,
   allocator_gds_size_out, allocator_vgpr_start_out,
   allocator_sgpr_start_out, allocator_lds_start_out,
   allocator_gds_start_out,
   // Inputs
   clk, rst, inflight_wg_buffer_alloc_wg_id,
   inflight_wg_buffer_alloc_num_wf,
   inflight_wg_buffer_alloc_vgpr_size,
   inflight_wg_buffer_alloc_sgpr_size,
   inflight_wg_buffer_alloc_lds_size,
   inflight_wg_buffer_alloc_gds_size, dis_controller_cu_busy,
   dis_controller_alloc_ack, dis_controller_start_alloc,
   grt_cam_up_valid, grt_cam_up_cu_id, grt_cam_up_vgpr_strt,
   grt_cam_up_vgpr_size, grt_cam_up_sgpr_strt, grt_cam_up_sgpr_size,
   grt_cam_up_lds_strt, grt_cam_up_lds_size, grt_cam_up_gds_strt,
   grt_cam_up_gds_size, grt_cam_up_wg_count
   );

   parameter WG_ID_WIDTH = 6;
   
   parameter CU_ID_WIDTH = 6;
   parameter NUMBER_CU = 64;

   parameter VGPR_ID_WIDTH = 10;
   parameter NUMBER_VGPR_SLOTS = 1024;

   parameter SGPR_ID_WIDTH = 10;
   parameter NUMBER_SGPR_SLOTS = 1024;

   parameter LDS_ID_WIDTH = 10;
   parameter NUMBER_LDS_SLOTS = 1024;

   parameter WG_SLOT_ID_WIDTH = 10;
   parameter NUMBER_WF_SLOTS = 40;

   parameter GDS_ID_WIDTH = 10;
   parameter GDS_SIZE = 1024;

   parameter WF_COUNT_WIDTH = 4;
   
   // Allocation input port
   input clk,rst;

   input [WG_ID_WIDTH-1:0] inflight_wg_buffer_alloc_wg_id;
   input [WF_COUNT_WIDTH-1:0] inflight_wg_buffer_alloc_num_wf;
   input [VGPR_ID_WIDTH :0]    inflight_wg_buffer_alloc_vgpr_size;
   input [SGPR_ID_WIDTH :0]    inflight_wg_buffer_alloc_sgpr_size;
   input [LDS_ID_WIDTH :0]     inflight_wg_buffer_alloc_lds_size;
   input [GDS_ID_WIDTH :0]     inflight_wg_buffer_alloc_gds_size;
   input [NUMBER_CU-1:0]       dis_controller_cu_busy;
   input 		       dis_controller_alloc_ack;
   input 		       dis_controller_start_alloc;
   
   // Allocation output port
   output 		       allocator_cu_valid;
   output 		       allocator_cu_rejected;
   output [WG_ID_WIDTH-1:0]    allocator_wg_id_out;
   output [CU_ID_WIDTH-1 :0]   allocator_cu_id_out;
   output [WF_COUNT_WIDTH-1:0]   allocator_wf_count;   
   output [VGPR_ID_WIDTH :0]   allocator_vgpr_size_out;
   output [SGPR_ID_WIDTH :0]   allocator_sgpr_size_out;
   output [LDS_ID_WIDTH :0]    allocator_lds_size_out;
   output [GDS_ID_WIDTH :0]    allocator_gds_size_out;
   output [VGPR_ID_WIDTH-1 :0] allocator_vgpr_start_out;
   output [SGPR_ID_WIDTH-1 :0] allocator_sgpr_start_out;
   output [LDS_ID_WIDTH-1 :0]  allocator_lds_start_out;
   output [GDS_ID_WIDTH-1 :0]  allocator_gds_start_out;
   
   
   // CAM update port
   input 		       grt_cam_up_valid;
   input [CU_ID_WIDTH-1 :0]    grt_cam_up_cu_id;
   input [VGPR_ID_WIDTH-1 :0]  grt_cam_up_vgpr_strt;
   input [VGPR_ID_WIDTH :0]    grt_cam_up_vgpr_size;
   input [SGPR_ID_WIDTH-1 :0]  grt_cam_up_sgpr_strt;
   input [SGPR_ID_WIDTH :0]    grt_cam_up_sgpr_size;
   input [LDS_ID_WIDTH-1 :0]   grt_cam_up_lds_strt;
   input [LDS_ID_WIDTH :0]     grt_cam_up_lds_size;
   input [GDS_ID_WIDTH-1 :0]   grt_cam_up_gds_strt;
   input [GDS_ID_WIDTH :0]     grt_cam_up_gds_size;
   input [WG_SLOT_ID_WIDTH:0] grt_cam_up_wg_count;
   
   
   // Flop inputs
   reg 				 alloc_valid_i;
   reg [WG_ID_WIDTH-1:0] 	 alloc_wg_id_i;
   reg [WF_COUNT_WIDTH-1:0] 	 alloc_num_wf_i;
   reg [VGPR_ID_WIDTH :0] 	 alloc_vgpr_size_i;
   reg [SGPR_ID_WIDTH :0] 	 alloc_sgpr_size_i;
   reg [LDS_ID_WIDTH :0] 	 alloc_lds_size_i;
   reg [GDS_ID_WIDTH :0] 	 alloc_gds_size_i;
   reg [NUMBER_CU-1:0] 		 dis_controller_cu_busy_i;

   reg 				 cam_up_valid_i;
   reg [CU_ID_WIDTH-1 :0] 	 cam_up_cu_id_i;   
   reg [VGPR_ID_WIDTH-1 :0] 	 cam_up_vgpr_strt_i;
   reg [VGPR_ID_WIDTH :0] 	 cam_up_vgpr_size_i;
   reg [SGPR_ID_WIDTH-1 :0] 	 cam_up_sgpr_strt_i;
   reg [SGPR_ID_WIDTH :0] 	 cam_up_sgpr_size_i;
   reg [LDS_ID_WIDTH-1 :0] 	 cam_up_lds_strt_i;
   reg [LDS_ID_WIDTH :0] 	 cam_up_lds_size_i;
   reg [GDS_ID_WIDTH-1 :0] 	 cam_up_gds_strt_i;
   reg [GDS_ID_WIDTH :0] 	 cam_up_gds_size_i;
   reg [WG_SLOT_ID_WIDTH:0] 	 cam_up_wg_count_i;
   

   // cam outputs
   reg 				 cam_out_valid;
   wire [NUMBER_CU-1 :0] 	 vgpr_search_out, sgpr_search_out, lds_search_out,
				 wg_search_out;
   reg 			 gds_valid;

   // Signals that bypass the cam
   reg 			 cam_wait_valid;
   reg [WG_ID_WIDTH-1 : 0] cam_wait_wg_id;
   reg [WF_COUNT_WIDTH-1: 0] cam_wait_wf_count;
   reg [VGPR_ID_WIDTH:0] 	cam_wait_vgpr_size;
   reg [SGPR_ID_WIDTH:0] 	cam_wait_sgpr_size;
   reg [LDS_ID_WIDTH:0] 	cam_wait_lds_size;
   reg [GDS_ID_WIDTH:0] 	cam_wait_gds_size;
   reg [GDS_ID_WIDTH-1:0] 	cam_wait_gds_strt;
   reg [NUMBER_CU-1:0] 		cam_wait_dis_controller_cu_busy;

   // And cam outputs to check if there is anything we can use, choose the right cu
   reg 				 anded_cam_out_valid;
   reg [NUMBER_CU-1: 0] 	 anded_cam_out;
   reg [WG_ID_WIDTH-1 :0] 	 anded_cam_wg_id;
   reg [WF_COUNT_WIDTH-1: 0]  anded_cam_wf_count;
   reg [VGPR_ID_WIDTH :0] 	 anded_cam_vgpr_size;
   reg [SGPR_ID_WIDTH :0] 	 anded_cam_sgpr_size;
   reg [LDS_ID_WIDTH :0] 	 anded_cam_lds_size;
   reg [GDS_ID_WIDTH :0] 	 anded_cam_gds_size;
   reg [GDS_ID_WIDTH-1 :0] 	 anded_cam_gds_strt;
   
   // Output encoder and find if we can use any cu, also addr the res start ram
   reg 				 encoded_cu_out_valid, 
				 encoded_cu_found_valid, encoded_cu_found_valid_comb;
   reg [CU_ID_WIDTH-1:0] 	 encoded_cu_id, encoded_cu_id_comb;
   reg [WG_ID_WIDTH-1 :0] 	 encoded_cu_wg_id;
   reg [WF_COUNT_WIDTH-1: 0]  encoded_wf_count;
   reg [VGPR_ID_WIDTH :0] 	 encoded_vgpr_size;
   reg [SGPR_ID_WIDTH :0] 	 encoded_sgpr_size;
   reg [LDS_ID_WIDTH :0] 	 encoded_lds_size;
   reg [GDS_ID_WIDTH :0] 	 encoded_gds_size;
   reg [GDS_ID_WIDTH-1 :0] 	 encoded_gds_strt;
   
   // res size ram lookup
   reg 				 size_ram_valid, size_ram_cu_id_found;
   reg [CU_ID_WIDTH-1:0] 	 cu_id_out;
   reg [VGPR_ID_WIDTH-1:0] 	 vgpr_start_out;
   reg [SGPR_ID_WIDTH-1:0] 	 sgpr_start_out;
   reg [LDS_ID_WIDTH-1:0] 	 lds_start_out;
   reg [GDS_ID_WIDTH-1:0] 	 gds_start_out;
   reg [WG_ID_WIDTH-1 :0] 	 wg_id_out;
   reg [VGPR_ID_WIDTH :0] 	 vgpr_size_out;
   reg [SGPR_ID_WIDTH :0] 	 sgpr_size_out;
   reg [LDS_ID_WIDTH :0] 	 lds_size_out;
   reg [GDS_ID_WIDTH :0] 	 gds_size_out;
   reg [WF_COUNT_WIDTH-1: 0]  wf_count_out;
   
   
   localparam RAM_SIZE_WIDTH
     = VGPR_ID_WIDTH + SGPR_ID_WIDTH + LDS_ID_WIDTH +GDS_ID_WIDTH;
   localparam RES_SIZE_VGPR_START = 0;
   localparam RES_SIZE_VGPR_END = RES_SIZE_VGPR_START+ VGPR_ID_WIDTH-1;

   localparam RES_SIZE_SGPR_START = RES_SIZE_VGPR_END + 1;
   localparam RES_SIZE_SGPR_END = RES_SIZE_SGPR_START+ SGPR_ID_WIDTH-1;

   localparam RES_SIZE_LDS_START = RES_SIZE_SGPR_END + 1;
   localparam RES_SIZE_LDS_END = RES_SIZE_LDS_START+ LDS_ID_WIDTH-1;

   localparam RES_SIZE_GDS_START = RES_SIZE_LDS_END + 1;
   localparam RES_SIZE_GDS_END = RES_SIZE_GDS_START+ GDS_ID_WIDTH-1;
   
   
   wire [RAM_SIZE_WIDTH-1 :0] 	 res_size_rd_wire, res_size_wr_wire;

   reg [GDS_ID_WIDTH:0] 	 gds_free;
   reg [GDS_ID_WIDTH-1:0] 	 gds_strt;

   reg [NUMBER_CU-1:0] 		 cu_initialized;
   
   reg 				 pipeline_waiting;
   
   
   // Instantiate cams
   cam_allocator 
     #(.CU_ID_WIDTH(CU_ID_WIDTH),
       .NUMBER_CU(NUMBER_CU),
       .RES_ID_WIDTH(VGPR_ID_WIDTH),
       .NUMBER_RES_SLOTS(NUMBER_VGPR_SLOTS))
   vgpr_cam 
     (.clk(clk),
      .rst(rst),
      // Search port in
      .res_search_en(alloc_valid_i),
      .res_search_size(alloc_vgpr_size_i),
      // Search port out
      .res_search_out(vgpr_search_out),
      // Update port
      .cam_wr_en(cam_up_valid_i),
      .cam_wr_addr(cam_up_cu_id_i),
      .cam_wr_data(cam_up_vgpr_size_i));

   cam_allocator 
     #(.CU_ID_WIDTH(CU_ID_WIDTH),
       .NUMBER_CU(NUMBER_CU),
       .RES_ID_WIDTH(SGPR_ID_WIDTH),
       .NUMBER_RES_SLOTS(NUMBER_SGPR_SLOTS))
   sgpr_cam 
     (.clk(clk),
      .rst(rst),
      // Search port in
      .res_search_en(alloc_valid_i),
      .res_search_size(alloc_sgpr_size_i),
      // Search port out
      .res_search_out(sgpr_search_out),
      // Update port
      .cam_wr_en(cam_up_valid_i),
      .cam_wr_addr(cam_up_cu_id_i),
      .cam_wr_data(cam_up_sgpr_size_i));
   
   
   cam_allocator 
     #(.CU_ID_WIDTH(CU_ID_WIDTH),
       .NUMBER_CU(NUMBER_CU),
       .RES_ID_WIDTH(LDS_ID_WIDTH),
       .NUMBER_RES_SLOTS(NUMBER_LDS_SLOTS))
   lds_cam 
     (.clk(clk),
      .rst(rst),
      // Search port in
      .res_search_en(alloc_valid_i),
      .res_search_size(alloc_lds_size_i),
      // Search port out
      .res_search_out(lds_search_out),
      // Update port
      .cam_wr_en(cam_up_valid_i),
      .cam_wr_addr(cam_up_cu_id_i),
      .cam_wr_data(cam_up_lds_size_i));

   cam_allocator 
     #(.CU_ID_WIDTH(CU_ID_WIDTH),
       .NUMBER_CU(NUMBER_CU),
       .RES_ID_WIDTH(WG_SLOT_ID_WIDTH),
       .NUMBER_RES_SLOTS(NUMBER_WF_SLOTS))
   wf_cam 
     (.clk(clk),
      .rst(rst),
      // Search port in
      .res_search_en(alloc_valid_i),
      .res_search_size({{(WG_SLOT_ID_WIDTH+1-(WF_COUNT_WIDTH)){1'b0}},
			alloc_num_wf_i}),
      // Search port out
      .res_search_out(wg_search_out),
      // Update port
      .cam_wr_en(cam_up_valid_i),
      .cam_wr_addr(cam_up_cu_id_i),
      .cam_wr_data(cam_up_wg_count_i));
   
   ram_2_port
     #(.WORD_SIZE(RAM_SIZE_WIDTH),
       .ADDR_SIZE(CU_ID_WIDTH),
       .NUM_WORDS(NUMBER_CU))
   res_start_cam
     (// Outputs
      .rd_word				(res_size_rd_wire),
      // Inputs
      .rst				(rst),
      .clk				(clk),
      .wr_en				(cam_up_valid_i),
      .wr_addr				(cam_up_cu_id_i),
      .wr_word				(res_size_wr_wire),
      .rd_en				(encoded_cu_out_valid && 
					 encoded_cu_found_valid),
      .rd_addr				(encoded_cu_id));
   assign res_size_wr_wire = { cam_up_lds_strt_i,
			       cam_up_sgpr_strt_i, cam_up_vgpr_strt_i };
   
   
   
   always @(posedge clk or rst) begin
      if(rst) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 alloc_gds_size_i <= {(1+(GDS_ID_WIDTH)){1'b0}};
	 alloc_lds_size_i <= {(1+(LDS_ID_WIDTH)){1'b0}};
	 alloc_num_wf_i <= {WF_COUNT_WIDTH{1'b0}};
	 alloc_sgpr_size_i <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	 alloc_valid_i <= 1'h0;
	 alloc_vgpr_size_i <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	 alloc_wg_id_i <= {WG_ID_WIDTH{1'b0}};
	 anded_cam_gds_size <= {(1+(GDS_ID_WIDTH)){1'b0}};
	 anded_cam_gds_strt <= {GDS_ID_WIDTH{1'b0}};
	 anded_cam_lds_size <= {(1+(LDS_ID_WIDTH)){1'b0}};
	 anded_cam_out <= {NUMBER_CU{1'b0}};
	 anded_cam_out_valid <= 1'h0;
	 anded_cam_sgpr_size <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	 anded_cam_vgpr_size <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	 anded_cam_wf_count <= {WF_COUNT_WIDTH{1'b0}};
	 anded_cam_wg_id <= {WG_ID_WIDTH{1'b0}};
	 cam_up_cu_id_i <= {CU_ID_WIDTH{1'b0}};
	 cam_up_gds_size_i <= {(1+(GDS_ID_WIDTH)){1'b0}};
	 cam_up_gds_strt_i <= {GDS_ID_WIDTH{1'b0}};
	 cam_up_lds_size_i <= {(1+(LDS_ID_WIDTH)){1'b0}};
	 cam_up_lds_strt_i <= {LDS_ID_WIDTH{1'b0}};
	 cam_up_sgpr_size_i <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	 cam_up_sgpr_strt_i <= {SGPR_ID_WIDTH{1'b0}};
	 cam_up_valid_i <= 1'h0;
	 cam_up_vgpr_size_i <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	 cam_up_vgpr_strt_i <= {VGPR_ID_WIDTH{1'b0}};
	 cam_up_wg_count_i <= {(1+(WG_SLOT_ID_WIDTH)){1'b0}};
	 cam_wait_dis_controller_cu_busy <= {NUMBER_CU{1'b0}};
	 cam_wait_gds_size <= {(1+(GDS_ID_WIDTH)){1'b0}};
	 cam_wait_gds_strt <= {GDS_ID_WIDTH{1'b0}};
	 cam_wait_lds_size <= {(1+(LDS_ID_WIDTH)){1'b0}};
	 cam_wait_sgpr_size <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	 cam_wait_valid <= 1'h0;
	 cam_wait_vgpr_size <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	 cam_wait_wf_count <= {WF_COUNT_WIDTH{1'b0}};
	 cam_wait_wg_id <= {WG_ID_WIDTH{1'b0}};
	 cu_id_out <= {CU_ID_WIDTH{1'b0}};
	 cu_initialized <= {NUMBER_CU{1'b0}};
	 dis_controller_cu_busy_i <= {NUMBER_CU{1'b0}};
	 encoded_cu_found_valid <= 1'h0;
	 encoded_cu_id <= {CU_ID_WIDTH{1'b0}};
	 encoded_cu_out_valid <= 1'h0;
	 encoded_cu_wg_id <= {WG_ID_WIDTH{1'b0}};
	 encoded_gds_size <= {(1+(GDS_ID_WIDTH)){1'b0}};
	 encoded_gds_strt <= {GDS_ID_WIDTH{1'b0}};
	 encoded_lds_size <= {(1+(LDS_ID_WIDTH)){1'b0}};
	 encoded_sgpr_size <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	 encoded_vgpr_size <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	 encoded_wf_count <= {WF_COUNT_WIDTH{1'b0}};
	 gds_free <= {(1+(GDS_ID_WIDTH)){1'b0}};
	 gds_size_out <= {(1+(GDS_ID_WIDTH)){1'b0}};
	 gds_start_out <= {GDS_ID_WIDTH{1'b0}};
	 gds_strt <= {GDS_ID_WIDTH{1'b0}};
	 gds_valid <= 1'h0;
	 lds_size_out <= {(1+(LDS_ID_WIDTH)){1'b0}};
	 pipeline_waiting <= 1'h0;
	 sgpr_size_out <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	 size_ram_cu_id_found <= 1'h0;
	 size_ram_valid <= 1'h0;
	 vgpr_size_out <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	 wf_count_out <= {WF_COUNT_WIDTH{1'b0}};
	 wg_id_out <= {WG_ID_WIDTH{1'b0}};
	 // End of automatics

      	 gds_free <= GDS_SIZE;

   end 
      else begin // if (rst)
	 // Locks the pipeline until an ack arrive from the controller
	 if(encoded_cu_out_valid && !pipeline_waiting) begin
	    pipeline_waiting <= 1'b1;
	 end

	 if(dis_controller_alloc_ack) begin
	    pipeline_waiting <= 1'b0;
	 end
	 
	 if(!pipeline_waiting) begin
	    //////////////////////////////////
	    // Cam search pipeline
	    //////////////////////////////////
	    
	    alloc_valid_i <= dis_controller_start_alloc;
	    alloc_wg_id_i <= inflight_wg_buffer_alloc_wg_id;
	    alloc_num_wf_i <= inflight_wg_buffer_alloc_num_wf;
	    alloc_vgpr_size_i <= inflight_wg_buffer_alloc_vgpr_size;
	    alloc_sgpr_size_i <= inflight_wg_buffer_alloc_sgpr_size;
	    alloc_lds_size_i <= inflight_wg_buffer_alloc_lds_size;
	    alloc_gds_size_i <= inflight_wg_buffer_alloc_gds_size;
	    dis_controller_cu_busy_i <= dis_controller_cu_busy;

	    //  Wait for cam search
	    cam_wait_valid <= alloc_valid_i;
	    cam_wait_wg_id <= alloc_wg_id_i;
	    cam_wait_wf_count <= alloc_num_wf_i;
	    cam_wait_vgpr_size <= alloc_vgpr_size_i;
	    cam_wait_sgpr_size <= alloc_sgpr_size_i;
	    cam_wait_lds_size <= alloc_lds_size_i;
	    cam_wait_gds_size <= alloc_gds_size_i;
	    cam_wait_gds_strt <= gds_strt;
	    cam_wait_dis_controller_cu_busy <= dis_controller_cu_busy_i;
	    if(gds_free >= alloc_gds_size_i)
	      gds_valid <= 1'b1;
	    else
	      gds_valid <= 1'b0;
	    
	    // AND all cam outs
	    anded_cam_out_valid <= cam_wait_valid;
	    anded_cam_out <= vgpr_search_out & sgpr_search_out & lds_search_out &
			     wg_search_out & {NUMBER_CU{gds_valid}} & 
			     (~cam_wait_dis_controller_cu_busy);
	    
	    anded_cam_wg_id <= cam_wait_wg_id;
	    anded_cam_wf_count <= cam_wait_wf_count;
	    anded_cam_vgpr_size <= cam_wait_vgpr_size;
	    anded_cam_sgpr_size <= cam_wait_sgpr_size;
	    anded_cam_lds_size <= cam_wait_lds_size;
	    anded_cam_gds_size <= cam_wait_gds_size;
	    anded_cam_gds_strt <= cam_wait_gds_strt;
	    
	    
	    // Use the encoded output to find the start of the resources
	    encoded_cu_out_valid <=  anded_cam_out_valid;
	    encoded_cu_found_valid <= encoded_cu_found_valid_comb;
	    encoded_cu_id <= encoded_cu_id_comb;
	    encoded_wf_count <= anded_cam_wf_count;
	    encoded_cu_wg_id <= anded_cam_wg_id;
	    encoded_vgpr_size <= anded_cam_vgpr_size;
	    encoded_sgpr_size <= anded_cam_sgpr_size;
	    encoded_lds_size <= anded_cam_lds_size;
	    encoded_gds_size <= anded_cam_gds_size;
	    encoded_gds_strt <= anded_cam_gds_strt;
	    
	    
	    // Output the starts and the cu id
	    size_ram_valid <= encoded_cu_out_valid;
	    size_ram_cu_id_found <= encoded_cu_found_valid;
	    cu_id_out <= encoded_cu_id;
	    wg_id_out <= encoded_cu_wg_id;
	    wf_count_out <= encoded_wf_count;
	    vgpr_size_out <= encoded_vgpr_size;
	    sgpr_size_out <= encoded_sgpr_size;
	    lds_size_out <= encoded_lds_size;
	    gds_size_out <= encoded_gds_size;
	    gds_start_out <= encoded_gds_strt;


	 end // if (pipeline_waiting)
	 
	 //////////////////////////////////
	 // Cam write
	 //////////////////////////////////
	 cam_up_valid_i <= grt_cam_up_valid;
	 cam_up_cu_id_i <= grt_cam_up_cu_id;
	 cam_up_vgpr_strt_i <= grt_cam_up_vgpr_strt;
	 cam_up_sgpr_strt_i <= grt_cam_up_sgpr_strt;
	 cam_up_lds_strt_i <= grt_cam_up_lds_strt;
	 cam_up_gds_strt_i <= grt_cam_up_gds_strt;
	 cam_up_wg_count_i <= grt_cam_up_wg_count;
	 if(cam_up_valid_i) begin
	    cu_initialized[cam_up_cu_id_i] <= 1'b1;
	 end
	 
	 //////////////////////////////////
	 // Size ram write
	 //////////////////////////////////
	 cam_up_vgpr_size_i <= grt_cam_up_vgpr_size;
	 cam_up_sgpr_size_i <= grt_cam_up_sgpr_size;
	 cam_up_lds_size_i <= grt_cam_up_lds_size;
	 cam_up_gds_size_i <= grt_cam_up_gds_size;

	 if(cam_up_valid_i) begin
	    gds_free <= cam_up_gds_size_i;
	    gds_strt <= cam_up_gds_strt_i;
	 end
	 else if(alloc_valid_i && (gds_free >= alloc_gds_size_i) && !pipeline_waiting) begin
	    gds_free <= gds_free - alloc_gds_size_i;
	    gds_strt <= gds_strt + alloc_gds_size_i;
	 end
	 
	 
	 
      end // else: !if(rst)
      
   end // always @ (posedge clk or rst)


   assign allocator_cu_valid = size_ram_valid;
   assign allocator_cu_rejected = ~size_ram_cu_id_found;
   assign allocator_wg_id_out = wg_id_out;
   assign allocator_cu_id_out = cu_id_out;

   assign allocator_vgpr_size_out = vgpr_size_out;
   assign allocator_sgpr_size_out = sgpr_size_out;
   assign allocator_lds_size_out = lds_size_out;
   assign allocator_gds_size_out = gds_size_out;

   assign allocator_vgpr_start_out = (!cu_initialized[cu_id_out])? 0 :
				     res_size_rd_wire[RES_SIZE_VGPR_END:RES_SIZE_VGPR_START];
   assign allocator_sgpr_start_out = (!cu_initialized[cu_id_out])? 0 :
				     res_size_rd_wire[RES_SIZE_SGPR_END:RES_SIZE_SGPR_START];
   assign allocator_lds_start_out = (!cu_initialized[cu_id_out])? 0 :
				     res_size_rd_wire[RES_SIZE_LDS_END:RES_SIZE_LDS_START];
   assign allocator_gds_start_out = (!cu_initialized[cu_id_out])? 0 :
				     gds_start_out;
   assign allocator_wf_count = wf_count_out;
   
   
   always @ ( /*AUTOSENSE*/anded_cam_out) begin : PRI_ENCODER_CAM_OUT
      integer i;
      reg     found_valid;
      found_valid = 1'b0;
      encoded_cu_id_comb = 0;
      
      for (i=0; i<NUMBER_CU; i = i+1) begin
	 if(~found_valid && anded_cam_out[i]) begin
	    found_valid = 1'b1;
	    encoded_cu_id_comb = i;
	 end
	 
      end
      
      encoded_cu_found_valid_comb = found_valid;
      
   end   
   
   
endmodule // allocator

