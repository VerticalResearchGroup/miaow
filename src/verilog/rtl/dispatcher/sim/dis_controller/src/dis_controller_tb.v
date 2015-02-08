// Local Variables:
// verilog-library-directories:("." "../../../")
// End:
module dis_controller_tb
  (/*AUTOARG*/);

   localparam NUMBER_CU = 8;
   localparam RES_TABLE_ADDR_WIDTH = 1;
   localparam CU_ID_WIDTH = 3;
   
   localparam WG_ID_WIDTH = 10;
   localparam WG_SLOT_ID_WIDTH = 6;
   localparam NUMBER_WF_SLOTS = 40;
   
   localparam VGPR_ID_WIDTH = 8;
   localparam NUMBER_VGPR_SLOTS = 256;
   
   localparam SGPR_ID_WIDTH = 8;
   localparam NUMBER_SGPR_SLOTS = 256;
   
   localparam LDS_ID_WIDTH = 7;
   localparam NUMBER_LDS_SLOTS = 128;
   
   localparam GDS_ID_WIDTH = 7;
   localparam GDS_SIZE = 128;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [CU_ID_WIDTH-1:0] allocator_cu_id_out;	// From ALLOC_DUT of allocator.v
   wire			allocator_cu_rejected;	// From ALLOC_DUT of allocator.v
   wire			allocator_cu_valid;	// From ALLOC_DUT of allocator.v
   wire [GDS_ID_WIDTH:0] allocator_gds_size_out;// From ALLOC_DUT of allocator.v
   wire [GDS_ID_WIDTH-1:0] allocator_gds_start_out;// From ALLOC_DUT of allocator.v
   wire [LDS_ID_WIDTH:0] allocator_lds_size_out;// From ALLOC_DUT of allocator.v
   wire [LDS_ID_WIDTH-1:0] allocator_lds_start_out;// From ALLOC_DUT of allocator.v
   wire [SGPR_ID_WIDTH:0] allocator_sgpr_size_out;// From ALLOC_DUT of allocator.v
   wire [SGPR_ID_WIDTH-1:0] allocator_sgpr_start_out;// From ALLOC_DUT of allocator.v
   wire [VGPR_ID_WIDTH:0] allocator_vgpr_size_out;// From ALLOC_DUT of allocator.v
   wire [VGPR_ID_WIDTH-1:0] allocator_vgpr_start_out;// From ALLOC_DUT of allocator.v
   wire [WG_SLOT_ID_WIDTH:0] allocator_wf_count;// From ALLOC_DUT of allocator.v
   wire [WG_ID_WIDTH-1:0] allocator_wg_id_out;	// From ALLOC_DUT of allocator.v
   wire			dis_controller_alloc_ack;// From DC_DUT of dis_controller.v
   wire [NUMBER_CU-1:0]	dis_controller_cu_busy;	// From DC_DUT of dis_controller.v
   wire			dis_controller_start_alloc;// From DC_DUT of dis_controller.v
   wire			dis_controller_wg_alloc_valid;// From DC_DUT of dis_controller.v
   wire			dis_controller_wg_dealloc_valid;// From DC_DUT of dis_controller.v
   wire			dis_controller_wg_rejected_valid;// From DC_DUT of dis_controller.v
   wire [CU_ID_WIDTH-1:0] grt_cam_up_cu_id;	// From GRT_DUT of global_resource_table.v
   wire [GDS_ID_WIDTH:0] grt_cam_up_gds_size;	// From GRT_DUT of global_resource_table.v
   wire [GDS_ID_WIDTH-1:0] grt_cam_up_gds_strt;	// From GRT_DUT of global_resource_table.v
   wire [LDS_ID_WIDTH:0] grt_cam_up_lds_size;	// From GRT_DUT of global_resource_table.v
   wire [LDS_ID_WIDTH-1:0] grt_cam_up_lds_strt;	// From GRT_DUT of global_resource_table.v
   wire [SGPR_ID_WIDTH:0] grt_cam_up_sgpr_size;	// From GRT_DUT of global_resource_table.v
   wire [SGPR_ID_WIDTH-1:0] grt_cam_up_sgpr_strt;// From GRT_DUT of global_resource_table.v
   wire			grt_cam_up_valid;	// From GRT_DUT of global_resource_table.v
   wire [VGPR_ID_WIDTH:0] grt_cam_up_vgpr_size;	// From GRT_DUT of global_resource_table.v
   wire [VGPR_ID_WIDTH-1:0] grt_cam_up_vgpr_strt;// From GRT_DUT of global_resource_table.v
   wire [WG_SLOT_ID_WIDTH:0] grt_cam_up_wg_count;// From GRT_DUT of global_resource_table.v
   wire [CU_ID_WIDTH-1:0] grt_wg_alloc_cu_id;	// From GRT_DUT of global_resource_table.v
   wire			grt_wg_alloc_done;	// From GRT_DUT of global_resource_table.v
   wire [WG_ID_WIDTH-1:0] grt_wg_alloc_wgid;	// From GRT_DUT of global_resource_table.v
   wire [CU_ID_WIDTH-1:0] grt_wg_dealloc_cu_id;	// From GRT_DUT of global_resource_table.v
   wire			grt_wg_dealloc_done;	// From GRT_DUT of global_resource_table.v
   wire [WG_ID_WIDTH-1:0] grt_wg_dealloc_wgid;	// From GRT_DUT of global_resource_table.v
   // End of automatics

   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg			clk;			// To GRT_DUT of global_resource_table.v, ...
   reg [CU_ID_WIDTH-1:0] gpu_interface_cu_id;	// To GRT_DUT of global_resource_table.v, ...
   reg			gpu_interface_dealloc_available;// To DC_DUT of dis_controller.v
   reg [WG_ID_WIDTH-1:0] gpu_interface_wg_id;	// To GRT_DUT of global_resource_table.v
   reg [GDS_ID_WIDTH:0]	inflight_wg_buffer_alloc_gds_size;// To ALLOC_DUT of allocator.v
   reg [LDS_ID_WIDTH:0]	inflight_wg_buffer_alloc_lds_size;// To ALLOC_DUT of allocator.v
   reg [WG_SLOT_ID_WIDTH:0] inflight_wg_buffer_alloc_num_wf;// To ALLOC_DUT of allocator.v
   reg [SGPR_ID_WIDTH:0] inflight_wg_buffer_alloc_sgpr_size;// To ALLOC_DUT of allocator.v
   reg			inflight_wg_buffer_alloc_valid;// To DC_DUT of dis_controller.v
   reg [VGPR_ID_WIDTH:0] inflight_wg_buffer_alloc_vgpr_size;// To ALLOC_DUT of allocator.v
   reg [WG_ID_WIDTH-1:0] inflight_wg_buffer_alloc_wg_id;// To ALLOC_DUT of allocator.v
   reg			rst;			// To GRT_DUT of global_resource_table.v, ...
   // End of automatics

   global_resource_table
     #(/*AUTOINSTPARAM*/
       // Parameters
       .NUMBER_CU			(NUMBER_CU),
       .CU_ID_WIDTH			(CU_ID_WIDTH),
       .RES_TABLE_ADDR_WIDTH		(RES_TABLE_ADDR_WIDTH),
       .VGPR_ID_WIDTH			(VGPR_ID_WIDTH),
       .NUMBER_VGPR_SLOTS		(NUMBER_VGPR_SLOTS),
       .SGPR_ID_WIDTH			(SGPR_ID_WIDTH),
       .NUMBER_SGPR_SLOTS		(NUMBER_SGPR_SLOTS),
       .LDS_ID_WIDTH			(LDS_ID_WIDTH),
       .NUMBER_LDS_SLOTS		(NUMBER_LDS_SLOTS),
       .WG_ID_WIDTH			(WG_ID_WIDTH),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS			(NUMBER_WF_SLOTS),
       .GDS_ID_WIDTH			(GDS_ID_WIDTH),
       .GDS_SIZE			(GDS_SIZE))
   GRT_DUT
     (/*AUTOINST*/
      // Outputs
      .grt_cam_up_valid			(grt_cam_up_valid),
      .grt_cam_up_wg_count		(grt_cam_up_wg_count[WG_SLOT_ID_WIDTH:0]),
      .grt_cam_up_cu_id			(grt_cam_up_cu_id[CU_ID_WIDTH-1:0]),
      .grt_cam_up_vgpr_strt		(grt_cam_up_vgpr_strt[VGPR_ID_WIDTH-1:0]),
      .grt_cam_up_vgpr_size		(grt_cam_up_vgpr_size[VGPR_ID_WIDTH:0]),
      .grt_cam_up_sgpr_strt		(grt_cam_up_sgpr_strt[SGPR_ID_WIDTH-1:0]),
      .grt_cam_up_sgpr_size		(grt_cam_up_sgpr_size[SGPR_ID_WIDTH:0]),
      .grt_cam_up_lds_strt		(grt_cam_up_lds_strt[LDS_ID_WIDTH-1:0]),
      .grt_cam_up_lds_size		(grt_cam_up_lds_size[LDS_ID_WIDTH:0]),
      .grt_cam_up_gds_strt		(grt_cam_up_gds_strt[GDS_ID_WIDTH-1:0]),
      .grt_cam_up_gds_size		(grt_cam_up_gds_size[GDS_ID_WIDTH:0]),
      .grt_wg_alloc_done		(grt_wg_alloc_done),
      .grt_wg_alloc_wgid		(grt_wg_alloc_wgid[WG_ID_WIDTH-1:0]),
      .grt_wg_alloc_cu_id		(grt_wg_alloc_cu_id[CU_ID_WIDTH-1:0]),
      .grt_wg_dealloc_done		(grt_wg_dealloc_done),
      .grt_wg_dealloc_wgid		(grt_wg_dealloc_wgid[WG_ID_WIDTH-1:0]),
      .grt_wg_dealloc_cu_id		(grt_wg_dealloc_cu_id[CU_ID_WIDTH-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .gpu_interface_cu_id		(gpu_interface_cu_id[CU_ID_WIDTH-1:0]),
      .gpu_interface_wg_id		(gpu_interface_wg_id[WG_ID_WIDTH-1:0]),
      .dis_controller_wg_alloc_valid	(dis_controller_wg_alloc_valid),
      .dis_controller_wg_dealloc_valid	(dis_controller_wg_dealloc_valid),
      .allocator_wg_id_out		(allocator_wg_id_out[WG_ID_WIDTH-1:0]),
      .allocator_wf_count		(allocator_wf_count[WG_SLOT_ID_WIDTH:0]),
      .allocator_cu_id_out		(allocator_cu_id_out[CU_ID_WIDTH-1:0]),
      .allocator_vgpr_start_out		(allocator_vgpr_start_out[VGPR_ID_WIDTH-1:0]),
      .allocator_sgpr_start_out		(allocator_sgpr_start_out[SGPR_ID_WIDTH-1:0]),
      .allocator_lds_start_out		(allocator_lds_start_out[LDS_ID_WIDTH-1:0]),
      .allocator_gds_start_out		(allocator_gds_start_out[GDS_ID_WIDTH-1:0]),
      .allocator_vgpr_size_out		(allocator_vgpr_size_out[VGPR_ID_WIDTH:0]),
      .allocator_sgpr_size_out		(allocator_sgpr_size_out[SGPR_ID_WIDTH:0]),
      .allocator_lds_size_out		(allocator_lds_size_out[LDS_ID_WIDTH:0]),
      .allocator_gds_size_out		(allocator_gds_size_out[GDS_ID_WIDTH:0]));

   allocator
     #(/*AUTOINSTPARAM*/
       // Parameters
       .WG_ID_WIDTH			(WG_ID_WIDTH),
       .CU_ID_WIDTH			(CU_ID_WIDTH),
       .NUMBER_CU			(NUMBER_CU),
       .VGPR_ID_WIDTH			(VGPR_ID_WIDTH),
       .NUMBER_VGPR_SLOTS		(NUMBER_VGPR_SLOTS),
       .SGPR_ID_WIDTH			(SGPR_ID_WIDTH),
       .NUMBER_SGPR_SLOTS		(NUMBER_SGPR_SLOTS),
       .LDS_ID_WIDTH			(LDS_ID_WIDTH),
       .NUMBER_LDS_SLOTS		(NUMBER_LDS_SLOTS),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS			(NUMBER_WF_SLOTS),
       .GDS_ID_WIDTH			(GDS_ID_WIDTH),
       .GDS_SIZE			(GDS_SIZE))
   ALLOC_DUT
     (/*AUTOINST*/
      // Outputs
      .allocator_cu_valid		(allocator_cu_valid),
      .allocator_cu_rejected		(allocator_cu_rejected),
      .allocator_wg_id_out		(allocator_wg_id_out[WG_ID_WIDTH-1:0]),
      .allocator_cu_id_out		(allocator_cu_id_out[CU_ID_WIDTH-1:0]),
      .allocator_wf_count		(allocator_wf_count[WG_SLOT_ID_WIDTH:0]),
      .allocator_vgpr_size_out		(allocator_vgpr_size_out[VGPR_ID_WIDTH:0]),
      .allocator_sgpr_size_out		(allocator_sgpr_size_out[SGPR_ID_WIDTH:0]),
      .allocator_lds_size_out		(allocator_lds_size_out[LDS_ID_WIDTH:0]),
      .allocator_gds_size_out		(allocator_gds_size_out[GDS_ID_WIDTH:0]),
      .allocator_vgpr_start_out		(allocator_vgpr_start_out[VGPR_ID_WIDTH-1:0]),
      .allocator_sgpr_start_out		(allocator_sgpr_start_out[SGPR_ID_WIDTH-1:0]),
      .allocator_lds_start_out		(allocator_lds_start_out[LDS_ID_WIDTH-1:0]),
      .allocator_gds_start_out		(allocator_gds_start_out[GDS_ID_WIDTH-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .inflight_wg_buffer_alloc_wg_id	(inflight_wg_buffer_alloc_wg_id[WG_ID_WIDTH-1:0]),
      .inflight_wg_buffer_alloc_num_wf	(inflight_wg_buffer_alloc_num_wf[WG_SLOT_ID_WIDTH:0]),
      .inflight_wg_buffer_alloc_vgpr_size(inflight_wg_buffer_alloc_vgpr_size[VGPR_ID_WIDTH:0]),
      .inflight_wg_buffer_alloc_sgpr_size(inflight_wg_buffer_alloc_sgpr_size[SGPR_ID_WIDTH:0]),
      .inflight_wg_buffer_alloc_lds_size(inflight_wg_buffer_alloc_lds_size[LDS_ID_WIDTH:0]),
      .inflight_wg_buffer_alloc_gds_size(inflight_wg_buffer_alloc_gds_size[GDS_ID_WIDTH:0]),
      .dis_controller_cu_busy		(dis_controller_cu_busy[NUMBER_CU-1:0]),
      .dis_controller_alloc_ack		(dis_controller_alloc_ack),
      .dis_controller_start_alloc	(dis_controller_start_alloc),
      .grt_cam_up_valid			(grt_cam_up_valid),
      .grt_cam_up_cu_id			(grt_cam_up_cu_id[CU_ID_WIDTH-1:0]),
      .grt_cam_up_vgpr_strt		(grt_cam_up_vgpr_strt[VGPR_ID_WIDTH-1:0]),
      .grt_cam_up_vgpr_size		(grt_cam_up_vgpr_size[VGPR_ID_WIDTH:0]),
      .grt_cam_up_sgpr_strt		(grt_cam_up_sgpr_strt[SGPR_ID_WIDTH-1:0]),
      .grt_cam_up_sgpr_size		(grt_cam_up_sgpr_size[SGPR_ID_WIDTH:0]),
      .grt_cam_up_lds_strt		(grt_cam_up_lds_strt[LDS_ID_WIDTH-1:0]),
      .grt_cam_up_lds_size		(grt_cam_up_lds_size[LDS_ID_WIDTH:0]),
      .grt_cam_up_gds_strt		(grt_cam_up_gds_strt[GDS_ID_WIDTH-1:0]),
      .grt_cam_up_gds_size		(grt_cam_up_gds_size[GDS_ID_WIDTH:0]),
      .grt_cam_up_wg_count		(grt_cam_up_wg_count[WG_SLOT_ID_WIDTH:0]));
   
   dis_controller
     #(/*AUTOINSTPARAM*/
       // Parameters
       .NUMBER_CU			(NUMBER_CU),
       .CU_ID_WIDTH			(CU_ID_WIDTH),
       .RES_TABLE_ADDR_WIDTH		(RES_TABLE_ADDR_WIDTH))
   DC_DUT
     (/*AUTOINST*/
      // Outputs
      .dis_controller_start_alloc	(dis_controller_start_alloc),
      .dis_controller_alloc_ack		(dis_controller_alloc_ack),
      .dis_controller_wg_alloc_valid	(dis_controller_wg_alloc_valid),
      .dis_controller_wg_dealloc_valid	(dis_controller_wg_dealloc_valid),
      .dis_controller_wg_rejected_valid	(dis_controller_wg_rejected_valid),
      .dis_controller_cu_busy		(dis_controller_cu_busy[NUMBER_CU-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .inflight_wg_buffer_alloc_valid	(inflight_wg_buffer_alloc_valid),
      .allocator_cu_valid		(allocator_cu_valid),
      .allocator_cu_rejected		(allocator_cu_rejected),
      .allocator_cu_id_out		(allocator_cu_id_out[CU_ID_WIDTH-1:0]),
      .grt_wg_alloc_done		(grt_wg_alloc_done),
      .grt_wg_dealloc_done		(grt_wg_dealloc_done),
      .grt_wg_alloc_wgid		(grt_wg_alloc_wgid[CU_ID_WIDTH-1:0]),
      .grt_wg_dealloc_wgid		(grt_wg_dealloc_wgid[CU_ID_WIDTH-1:0]),
      .grt_wg_alloc_cu_id		(grt_wg_alloc_cu_id[CU_ID_WIDTH-1:0]),
      .grt_wg_dealloc_cu_id		(grt_wg_dealloc_cu_id[CU_ID_WIDTH-1:0]),
      .gpu_interface_dealloc_available	(gpu_interface_dealloc_available),
      .gpu_interface_cu_id		(gpu_interface_cu_id[CU_ID_WIDTH-1:0]));


   // Signals to allow them to share data
   reg end_of_deallocations, end_of_allocations;
   localparam N_ALLOCS = 16;
   
   reg[WG_ID_WIDTH-1:0]  allocated_wf_id[N_ALLOCS-1 : 0];
   reg[CU_ID_WIDTH-1:0]  allocated_cu_id[N_ALLOCS-1 : 0];
   integer 		 curr_alloc, curr_dealloc, curr_alloc_cu_id;

   reg 			 dealloc_wait;
   

   // Clk block
   initial begin
      clk = 1'b0;
      forever begin
	 #5  clk =  ! clk;
      end
   end

   // rst block
   initial begin
      // Reset the design
      rst = 1'b1;
      end_of_deallocations = 1'b0;
      end_of_allocations = 1'b0;
      inflight_wg_buffer_alloc_valid <= 1'b0;
      gpu_interface_dealloc_available <= 1'b0;

      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      rst = 1'b0;
      
   end
   
   
   // Tasks
   task make_alloc_wg_available;
      input [WG_ID_WIDTH-1:0] alloc_wg_id;
      input [WG_SLOT_ID_WIDTH:0] alloc_num_wf;
      input [VGPR_ID_WIDTH:0] 	 alloc_vgpr_size;
      input [SGPR_ID_WIDTH:0] 	 alloc_sgpr_size;
      input [LDS_ID_WIDTH:0] 	 alloc_lds_size;
      input [GDS_ID_WIDTH:0] 	 alloc_gds_size;
      
      begin
	 inflight_wg_buffer_alloc_valid <= 1'b1;
	 inflight_wg_buffer_alloc_wg_id <= alloc_wg_id;
	 inflight_wg_buffer_alloc_num_wf <= alloc_num_wf;
	 inflight_wg_buffer_alloc_vgpr_size <= alloc_vgpr_size;
	 inflight_wg_buffer_alloc_sgpr_size <= alloc_sgpr_size;
	 inflight_wg_buffer_alloc_lds_size <= alloc_lds_size;
	 inflight_wg_buffer_alloc_gds_size <= alloc_gds_size;
	 curr_alloc = curr_alloc + 1;

	 while(!dis_controller_start_alloc) @(posedge clk);
	 @(posedge clk);	 
	 inflight_wg_buffer_alloc_valid <= 1'b0;

      end
   endtask // repeat
   
   // Block that simulates the inflight wg buffer
   initial begin
      curr_alloc = 0;
      dealloc_wait = 1'b1;
      @(negedge rst);
      @(posedge clk);
      // vgprs 256/cu
      // sgprs 256/cu
      // lds 128/cu
      // gds 128
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      dealloc_wait = 1'b0;
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);
      make_alloc_wg_available(curr_alloc,2,50,10,10,10);

      end_of_allocations = 1'b1;
      
   end // initial begin

   initial begin
      curr_alloc_cu_id = 0;
      @(negedge rst);
      @(posedge clk);
      
      forever begin
	 while(!allocator_cu_valid)  @(posedge clk);
	 if(!allocator_cu_rejected) begin
	    allocated_cu_id[curr_alloc_cu_id] <= allocator_cu_id_out;
	    allocated_wf_id[curr_alloc_cu_id] <= allocator_wg_id_out;
	    
	    curr_alloc_cu_id <= curr_alloc_cu_id + 1;
	 end
	 while(!dis_controller_alloc_ack)  @(posedge clk);
	 @(posedge clk);
	 @(posedge clk);
      end
      
   end
   
   
   task make_dealloc_wg_available;
      begin
	 while(curr_dealloc >= curr_alloc_cu_id) @(posedge clk);
	 repeat(100) @(posedge clk);
	 
	 gpu_interface_dealloc_available <= 1'b1;
	 gpu_interface_cu_id <= allocated_cu_id[curr_dealloc];
	 gpu_interface_wg_id <= allocated_wf_id[curr_dealloc];
	 curr_dealloc = curr_dealloc + 1;
	 while(!dis_controller_wg_dealloc_valid) @(posedge clk);
	 @(posedge clk);	 
	 gpu_interface_dealloc_available <= 1'b0;
      end
   endtask // while


   // Block that simulates the gpu interface
   initial begin
      curr_dealloc = 0;
      @(negedge rst);
      @(posedge clk);

      while(curr_dealloc != N_ALLOCS-1) begin
	 while(dealloc_wait) @(posedge clk);
	 make_dealloc_wg_available;
      end
      
      end_of_deallocations = 1'b1;

   end

   // Block to log data and kill simulation
   initial begin
      while(!(end_of_deallocations && end_of_allocations)) begin
	 // Conditionally log stuff
	 // Wait for clock
	 @(posedge clk);
      end
      
      // End of simulation
      repeat(100) @(posedge clk);
      $stop;
   end
   
endmodule // dis_controller_tb

   
