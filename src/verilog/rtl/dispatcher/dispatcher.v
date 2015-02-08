module dispatcher 
  (/*AUTOARG*/
   // Outputs
   inflight_wg_buffer_host_wf_done_wg_id,
   inflight_wg_buffer_host_wf_done, inflight_wg_buffer_host_rcvd_ack,
   dispatch2cu_lds_base_dispatch, dispatch2cu_sgpr_base_dispatch,
   dispatch2cu_start_pc_dispatch, dispatch2cu_vgpr_base_dispatch,
   dispatch2cu_wf_dispatch, dispatch2cu_wf_size_dispatch,
   dispatch2cu_wf_tag_dispatch, dispatch2cu_wg_wf_count,
   // Inputs
   rst, host_wg_valid, host_wg_id, host_wf_size, host_vgpr_size_total,
   host_vgpr_size_per_wf, host_start_pc, host_sgpr_size_total,
   host_sgpr_size_per_wf, host_num_wf, host_lds_size_total,
   host_gds_size_total, cu2dispatch_wf_tag_done, cu2dispatch_wf_done,
   clk
   ) ;

   // Resource accounting parameters
   parameter NUMBER_CU = 8;
   parameter CU_ID_WIDTH = 3;

   parameter WG_ID_WIDTH = 6;
   parameter WG_SLOT_ID_WIDTH = 6;
   parameter NUMBER_WF_SLOTS = 40;
   parameter WF_COUNT_WIDTH = 4;
   parameter WAVE_ITEM_WIDTH = 6;

   parameter VGPR_ID_WIDTH = 8;
   parameter NUMBER_VGPR_SLOTS = 256;
   parameter SGPR_ID_WIDTH = 4;
   parameter NUMBER_SGPR_SLOTS = 13;
   parameter LDS_ID_WIDTH = 8;
   parameter NUMBER_LDS_SLOTS = 256;
   parameter GDS_ID_WIDTH = 14;
   parameter GDS_SIZE = 16384;

   parameter TAG_WIDTH = 15;
   parameter MEM_ADDR_WIDTH = 32;

   // Dispatcher internal parameters
   parameter RES_TABLE_ADDR_WIDTH = 2;
   
   parameter ENTRY_ADDR_WIDTH = 6;
   parameter NUMBER_ENTRIES = 64;


   parameter CU_VGPR_ID_WIDTH = 10;
   parameter CU_SGPR_ID_WIDTH = 9;
   parameter CU_LDS_ID_WIDTH = 16;
   parameter CU_GDS_ID_WIDTH = 16;
   
   output [CU_LDS_ID_WIDTH-1:0]		dispatch2cu_lds_base_dispatch;
   output [CU_SGPR_ID_WIDTH-1:0] 	dispatch2cu_sgpr_base_dispatch;
   output [MEM_ADDR_WIDTH-1:0] 		dispatch2cu_start_pc_dispatch;
   output [CU_VGPR_ID_WIDTH-1:0] 	dispatch2cu_vgpr_base_dispatch;
   output [NUMBER_CU-1:0] 		dispatch2cu_wf_dispatch;
   output [WAVE_ITEM_WIDTH-1:0] 	dispatch2cu_wf_size_dispatch;
   output [TAG_WIDTH-1:0] 		dispatch2cu_wf_tag_dispatch;
   output [WF_COUNT_WIDTH-1:0] 		dispatch2cu_wg_wf_count;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [CU_ID_WIDTH-1:0] allocator_cu_id_out;	// From allocator_inst of allocator.v
   wire			allocator_cu_rejected;	// From allocator_inst of allocator.v
   wire			allocator_cu_valid;	// From allocator_inst of allocator.v
   wire [GDS_ID_WIDTH:0] allocator_gds_size_out;// From allocator_inst of allocator.v
   wire [GDS_ID_WIDTH-1:0] allocator_gds_start_out;// From allocator_inst of allocator.v
   wire [LDS_ID_WIDTH:0] allocator_lds_size_out;// From allocator_inst of allocator.v
   wire [LDS_ID_WIDTH-1:0] allocator_lds_start_out;// From allocator_inst of allocator.v
   wire [SGPR_ID_WIDTH:0] allocator_sgpr_size_out;// From allocator_inst of allocator.v
   wire [SGPR_ID_WIDTH-1:0] allocator_sgpr_start_out;// From allocator_inst of allocator.v
   wire [VGPR_ID_WIDTH:0] allocator_vgpr_size_out;// From allocator_inst of allocator.v
   wire [VGPR_ID_WIDTH-1:0] allocator_vgpr_start_out;// From allocator_inst of allocator.v
   wire [WF_COUNT_WIDTH-1:0] allocator_wf_count;// From allocator_inst of allocator.v
   wire [WG_ID_WIDTH-1:0] allocator_wg_id_out;	// From allocator_inst of allocator.v
   wire			dis_controller_alloc_ack;// From dis_controller_inst of dis_controller.v
   wire [NUMBER_CU-1:0]	dis_controller_cu_busy;	// From dis_controller_inst of dis_controller.v
   wire			dis_controller_start_alloc;// From dis_controller_inst of dis_controller.v
   wire			dis_controller_wg_alloc_valid;// From dis_controller_inst of dis_controller.v
   wire			dis_controller_wg_dealloc_valid;// From dis_controller_inst of dis_controller.v
   wire			dis_controller_wg_rejected_valid;// From dis_controller_inst of dis_controller.v
   wire			gpu_interface_alloc_available;// From gpu_interface_inst of gpu_interface.v
   wire [CU_ID_WIDTH-1:0] gpu_interface_cu_id;	// From gpu_interface_inst of gpu_interface.v
   wire			gpu_interface_dealloc_available;// From gpu_interface_inst of gpu_interface.v
   wire [WG_ID_WIDTH-1:0] gpu_interface_dealloc_wg_id;// From gpu_interface_inst of gpu_interface.v
   wire [CU_ID_WIDTH-1:0] grt_cam_up_cu_id;	// From global_resource_table_inst of global_resource_table.v
   wire [GDS_ID_WIDTH:0] grt_cam_up_gds_size;	// From global_resource_table_inst of global_resource_table.v
   wire [GDS_ID_WIDTH-1:0] grt_cam_up_gds_strt;	// From global_resource_table_inst of global_resource_table.v
   wire [LDS_ID_WIDTH:0] grt_cam_up_lds_size;	// From global_resource_table_inst of global_resource_table.v
   wire [LDS_ID_WIDTH-1:0] grt_cam_up_lds_strt;	// From global_resource_table_inst of global_resource_table.v
   wire [SGPR_ID_WIDTH:0] grt_cam_up_sgpr_size;	// From global_resource_table_inst of global_resource_table.v
   wire [SGPR_ID_WIDTH-1:0] grt_cam_up_sgpr_strt;// From global_resource_table_inst of global_resource_table.v
   wire			grt_cam_up_valid;	// From global_resource_table_inst of global_resource_table.v
   wire [VGPR_ID_WIDTH:0] grt_cam_up_vgpr_size;	// From global_resource_table_inst of global_resource_table.v
   wire [VGPR_ID_WIDTH-1:0] grt_cam_up_vgpr_strt;// From global_resource_table_inst of global_resource_table.v
   wire [WG_SLOT_ID_WIDTH:0] grt_cam_up_wg_count;// From global_resource_table_inst of global_resource_table.v
   wire [CU_ID_WIDTH-1:0] grt_wg_alloc_cu_id;	// From global_resource_table_inst of global_resource_table.v
   wire			grt_wg_alloc_done;	// From global_resource_table_inst of global_resource_table.v
   wire [WG_ID_WIDTH-1:0] grt_wg_alloc_wgid;	// From global_resource_table_inst of global_resource_table.v
   wire [CU_ID_WIDTH-1:0] grt_wg_dealloc_cu_id;	// From global_resource_table_inst of global_resource_table.v
   wire			grt_wg_dealloc_done;	// From global_resource_table_inst of global_resource_table.v
   wire [WG_ID_WIDTH-1:0] grt_wg_dealloc_wgid;	// From global_resource_table_inst of global_resource_table.v
   wire			inflight_wg_buffer_alloc_available;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   wire [GDS_ID_WIDTH:0] inflight_wg_buffer_alloc_gds_size;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   wire [LDS_ID_WIDTH:0] inflight_wg_buffer_alloc_lds_size;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   wire [WF_COUNT_WIDTH-1:0] inflight_wg_buffer_alloc_num_wf;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   wire [SGPR_ID_WIDTH:0] inflight_wg_buffer_alloc_sgpr_size;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   wire			inflight_wg_buffer_alloc_valid;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   wire [VGPR_ID_WIDTH:0] inflight_wg_buffer_alloc_vgpr_size;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   wire [WG_ID_WIDTH-1:0] inflight_wg_buffer_alloc_wg_id;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   wire [SGPR_ID_WIDTH:0] inflight_wg_buffer_gpu_sgpr_size_per_wf;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   wire			inflight_wg_buffer_gpu_valid;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   wire [VGPR_ID_WIDTH:0] inflight_wg_buffer_gpu_vgpr_size_per_wf;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   wire [WAVE_ITEM_WIDTH-1:0] inflight_wg_buffer_gpu_wf_size;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   wire [MEM_ADDR_WIDTH-1:0] inflight_wg_buffer_start_pc;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   // End of automatics

   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input		clk;			// To gpu_interface_inst of gpu_interface.v, ...
   input [NUMBER_CU-1:0] cu2dispatch_wf_done;	// To gpu_interface_inst of gpu_interface.v
   input [NUMBER_CU*TAG_WIDTH-1:0] cu2dispatch_wf_tag_done;// To gpu_interface_inst of gpu_interface.v
   input [GDS_ID_WIDTH:0] host_gds_size_total;	// To inflight_wg_buffer_inst of inflight_wg_buffer.v
   input [LDS_ID_WIDTH:0] host_lds_size_total;	// To inflight_wg_buffer_inst of inflight_wg_buffer.v
   input [WF_COUNT_WIDTH-1:0] host_num_wf;	// To inflight_wg_buffer_inst of inflight_wg_buffer.v
   input [SGPR_ID_WIDTH:0] host_sgpr_size_per_wf;// To inflight_wg_buffer_inst of inflight_wg_buffer.v
   input [SGPR_ID_WIDTH:0] host_sgpr_size_total;// To inflight_wg_buffer_inst of inflight_wg_buffer.v
   input [MEM_ADDR_WIDTH-1:0] host_start_pc;	// To inflight_wg_buffer_inst of inflight_wg_buffer.v
   input [VGPR_ID_WIDTH:0] host_vgpr_size_per_wf;// To inflight_wg_buffer_inst of inflight_wg_buffer.v
   input [VGPR_ID_WIDTH:0] host_vgpr_size_total;// To inflight_wg_buffer_inst of inflight_wg_buffer.v
   input [WAVE_ITEM_WIDTH-1:0] host_wf_size;	// To inflight_wg_buffer_inst of inflight_wg_buffer.v
   input [WG_ID_WIDTH-1:0] host_wg_id;		// To inflight_wg_buffer_inst of inflight_wg_buffer.v
   input		host_wg_valid;		// To inflight_wg_buffer_inst of inflight_wg_buffer.v
   input		rst;			// To gpu_interface_inst of gpu_interface.v, ...
   // End of automatics

   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output		inflight_wg_buffer_host_rcvd_ack;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   output		inflight_wg_buffer_host_wf_done;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   output [WG_ID_WIDTH-1:0] inflight_wg_buffer_host_wf_done_wg_id;// From inflight_wg_buffer_inst of inflight_wg_buffer.v
   // End of automatics

   
   gpu_interface
     #(/*AUTOINSTPARAM*/
       // Parameters
       .WG_ID_WIDTH			(WG_ID_WIDTH),
       .WF_COUNT_WIDTH			(WF_COUNT_WIDTH),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS			(NUMBER_WF_SLOTS),
       .NUMBER_CU			(NUMBER_CU),
       .CU_ID_WIDTH			(CU_ID_WIDTH),
       .VGPR_ID_WIDTH			(VGPR_ID_WIDTH),
       .SGPR_ID_WIDTH			(SGPR_ID_WIDTH),
       .LDS_ID_WIDTH			(LDS_ID_WIDTH),
       .GDS_ID_WIDTH			(GDS_ID_WIDTH),
       .TAG_WIDTH			(TAG_WIDTH),
       .MEM_ADDR_WIDTH			(MEM_ADDR_WIDTH),
       .WAVE_ITEM_WIDTH			(WAVE_ITEM_WIDTH),
       .CU_VGPR_ID_WIDTH		(CU_VGPR_ID_WIDTH),
       .CU_SGPR_ID_WIDTH		(CU_SGPR_ID_WIDTH),
       .CU_LDS_ID_WIDTH			(CU_LDS_ID_WIDTH),
       .CU_GDS_ID_WIDTH			(CU_GDS_ID_WIDTH))
   gpu_interface_inst
     (/*AUTOINST*/
      // Outputs
      .gpu_interface_alloc_available	(gpu_interface_alloc_available),
      .gpu_interface_dealloc_available	(gpu_interface_dealloc_available),
      .gpu_interface_cu_id		(gpu_interface_cu_id[CU_ID_WIDTH-1:0]),
      .gpu_interface_dealloc_wg_id	(gpu_interface_dealloc_wg_id[WG_ID_WIDTH-1:0]),
      .dispatch2cu_wf_dispatch		(dispatch2cu_wf_dispatch[NUMBER_CU-1:0]),
      .dispatch2cu_wg_wf_count		(dispatch2cu_wg_wf_count[WF_COUNT_WIDTH-1:0]),
      .dispatch2cu_wf_size_dispatch	(dispatch2cu_wf_size_dispatch[WAVE_ITEM_WIDTH-1:0]),
      .dispatch2cu_sgpr_base_dispatch	(dispatch2cu_sgpr_base_dispatch[CU_SGPR_ID_WIDTH-1:0]),
      .dispatch2cu_vgpr_base_dispatch	(dispatch2cu_vgpr_base_dispatch[CU_VGPR_ID_WIDTH-1:0]),
      .dispatch2cu_wf_tag_dispatch	(dispatch2cu_wf_tag_dispatch[TAG_WIDTH-1:0]),
      .dispatch2cu_lds_base_dispatch	(dispatch2cu_lds_base_dispatch[CU_LDS_ID_WIDTH-1:0]),
      .dispatch2cu_start_pc_dispatch	(dispatch2cu_start_pc_dispatch[MEM_ADDR_WIDTH-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .inflight_wg_buffer_gpu_valid	(inflight_wg_buffer_gpu_valid),
      .inflight_wg_buffer_gpu_wf_size	(inflight_wg_buffer_gpu_wf_size[WAVE_ITEM_WIDTH-1:0]),
      .inflight_wg_buffer_start_pc	(inflight_wg_buffer_start_pc[MEM_ADDR_WIDTH-1:0]),
      .inflight_wg_buffer_gpu_vgpr_size_per_wf(inflight_wg_buffer_gpu_vgpr_size_per_wf[VGPR_ID_WIDTH:0]),
      .inflight_wg_buffer_gpu_sgpr_size_per_wf(inflight_wg_buffer_gpu_sgpr_size_per_wf[SGPR_ID_WIDTH:0]),
      .allocator_wg_id_out		(allocator_wg_id_out[WG_ID_WIDTH-1:0]),
      .allocator_cu_id_out		(allocator_cu_id_out[CU_ID_WIDTH-1:0]),
      .allocator_wf_count		(allocator_wf_count[WF_COUNT_WIDTH-1:0]),
      .allocator_vgpr_start_out		(allocator_vgpr_start_out[VGPR_ID_WIDTH-1:0]),
      .allocator_sgpr_start_out		(allocator_sgpr_start_out[SGPR_ID_WIDTH-1:0]),
      .allocator_lds_start_out		(allocator_lds_start_out[LDS_ID_WIDTH-1:0]),
      .allocator_gds_start_out		(allocator_gds_start_out[GDS_ID_WIDTH-1:0]),
      .dis_controller_wg_alloc_valid	(dis_controller_wg_alloc_valid),
      .dis_controller_wg_dealloc_valid	(dis_controller_wg_dealloc_valid),
      .cu2dispatch_wf_done		(cu2dispatch_wf_done[NUMBER_CU-1:0]),
      .cu2dispatch_wf_tag_done		(cu2dispatch_wf_tag_done[NUMBER_CU*TAG_WIDTH-1:0]));

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
       .GDS_SIZE			(GDS_SIZE),
       .WF_COUNT_WIDTH			(WF_COUNT_WIDTH))
   allocator_inst
     (/*AUTOINST*/
      // Outputs
      .allocator_cu_valid		(allocator_cu_valid),
      .allocator_cu_rejected		(allocator_cu_rejected),
      .allocator_wg_id_out		(allocator_wg_id_out[WG_ID_WIDTH-1:0]),
      .allocator_cu_id_out		(allocator_cu_id_out[CU_ID_WIDTH-1:0]),
      .allocator_wf_count		(allocator_wf_count[WF_COUNT_WIDTH-1:0]),
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
      .inflight_wg_buffer_alloc_num_wf	(inflight_wg_buffer_alloc_num_wf[WF_COUNT_WIDTH-1:0]),
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
   dis_controller_inst
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
      .inflight_wg_buffer_alloc_available(inflight_wg_buffer_alloc_available),
      .allocator_cu_valid		(allocator_cu_valid),
      .allocator_cu_rejected		(allocator_cu_rejected),
      .allocator_cu_id_out		(allocator_cu_id_out[CU_ID_WIDTH-1:0]),
      .grt_wg_alloc_done		(grt_wg_alloc_done),
      .grt_wg_dealloc_done		(grt_wg_dealloc_done),
      .grt_wg_alloc_wgid		(grt_wg_alloc_wgid[CU_ID_WIDTH-1:0]),
      .grt_wg_dealloc_wgid		(grt_wg_dealloc_wgid[CU_ID_WIDTH-1:0]),
      .grt_wg_alloc_cu_id		(grt_wg_alloc_cu_id[CU_ID_WIDTH-1:0]),
      .grt_wg_dealloc_cu_id		(grt_wg_dealloc_cu_id[CU_ID_WIDTH-1:0]),
      .gpu_interface_alloc_available	(gpu_interface_alloc_available),
      .gpu_interface_dealloc_available	(gpu_interface_dealloc_available),
      .gpu_interface_cu_id		(gpu_interface_cu_id[CU_ID_WIDTH-1:0]));

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
       .WF_COUNT_WIDTH			(WF_COUNT_WIDTH),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS			(NUMBER_WF_SLOTS),
       .GDS_ID_WIDTH			(GDS_ID_WIDTH),
       .GDS_SIZE			(GDS_SIZE))
   global_resource_table_inst
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
      .gpu_interface_dealloc_wg_id	(gpu_interface_dealloc_wg_id[WG_ID_WIDTH-1:0]),
      .dis_controller_wg_alloc_valid	(dis_controller_wg_alloc_valid),
      .dis_controller_wg_dealloc_valid	(dis_controller_wg_dealloc_valid),
      .allocator_wg_id_out		(allocator_wg_id_out[WG_ID_WIDTH-1:0]),
      .allocator_wf_count		(allocator_wf_count[WF_COUNT_WIDTH-1:0]),
      .allocator_cu_id_out		(allocator_cu_id_out[CU_ID_WIDTH-1:0]),
      .allocator_vgpr_start_out		(allocator_vgpr_start_out[VGPR_ID_WIDTH-1:0]),
      .allocator_sgpr_start_out		(allocator_sgpr_start_out[SGPR_ID_WIDTH-1:0]),
      .allocator_lds_start_out		(allocator_lds_start_out[LDS_ID_WIDTH-1:0]),
      .allocator_gds_start_out		(allocator_gds_start_out[GDS_ID_WIDTH-1:0]),
      .allocator_vgpr_size_out		(allocator_vgpr_size_out[VGPR_ID_WIDTH:0]),
      .allocator_sgpr_size_out		(allocator_sgpr_size_out[SGPR_ID_WIDTH:0]),
      .allocator_lds_size_out		(allocator_lds_size_out[LDS_ID_WIDTH:0]),
      .allocator_gds_size_out		(allocator_gds_size_out[GDS_ID_WIDTH:0]));

   inflight_wg_buffer
     #(/*AUTOINSTPARAM*/
       // Parameters
       .WG_ID_WIDTH			(WG_ID_WIDTH),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .WF_COUNT_WIDTH			(WF_COUNT_WIDTH),
       .CU_ID_WIDTH			(CU_ID_WIDTH),
       .VGPR_ID_WIDTH			(VGPR_ID_WIDTH),
       .SGPR_ID_WIDTH			(SGPR_ID_WIDTH),
       .LDS_ID_WIDTH			(LDS_ID_WIDTH),
       .GDS_ID_WIDTH			(GDS_ID_WIDTH),
       .ENTRY_ADDR_WIDTH		(ENTRY_ADDR_WIDTH),
       .NUMBER_ENTRIES			(NUMBER_ENTRIES),
       .WAVE_ITEM_WIDTH			(WAVE_ITEM_WIDTH),
       .MEM_ADDR_WIDTH			(MEM_ADDR_WIDTH))
   inflight_wg_buffer_inst
     (/*AUTOINST*/
      // Outputs
      .inflight_wg_buffer_host_rcvd_ack	(inflight_wg_buffer_host_rcvd_ack),
      .inflight_wg_buffer_host_wf_done	(inflight_wg_buffer_host_wf_done),
      .inflight_wg_buffer_host_wf_done_wg_id(inflight_wg_buffer_host_wf_done_wg_id[WG_ID_WIDTH-1:0]),
      .inflight_wg_buffer_alloc_valid	(inflight_wg_buffer_alloc_valid),
      .inflight_wg_buffer_alloc_available(inflight_wg_buffer_alloc_available),
      .inflight_wg_buffer_alloc_wg_id	(inflight_wg_buffer_alloc_wg_id[WG_ID_WIDTH-1:0]),
      .inflight_wg_buffer_alloc_num_wf	(inflight_wg_buffer_alloc_num_wf[WF_COUNT_WIDTH-1:0]),
      .inflight_wg_buffer_alloc_vgpr_size(inflight_wg_buffer_alloc_vgpr_size[VGPR_ID_WIDTH:0]),
      .inflight_wg_buffer_alloc_sgpr_size(inflight_wg_buffer_alloc_sgpr_size[SGPR_ID_WIDTH:0]),
      .inflight_wg_buffer_alloc_lds_size(inflight_wg_buffer_alloc_lds_size[LDS_ID_WIDTH:0]),
      .inflight_wg_buffer_alloc_gds_size(inflight_wg_buffer_alloc_gds_size[GDS_ID_WIDTH:0]),
      .inflight_wg_buffer_gpu_valid	(inflight_wg_buffer_gpu_valid),
      .inflight_wg_buffer_gpu_vgpr_size_per_wf(inflight_wg_buffer_gpu_vgpr_size_per_wf[VGPR_ID_WIDTH:0]),
      .inflight_wg_buffer_gpu_sgpr_size_per_wf(inflight_wg_buffer_gpu_sgpr_size_per_wf[SGPR_ID_WIDTH:0]),
      .inflight_wg_buffer_gpu_wf_size	(inflight_wg_buffer_gpu_wf_size[WAVE_ITEM_WIDTH-1:0]),
      .inflight_wg_buffer_start_pc	(inflight_wg_buffer_start_pc[MEM_ADDR_WIDTH-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .host_wg_valid			(host_wg_valid),
      .host_wg_id			(host_wg_id[WG_ID_WIDTH-1:0]),
      .host_num_wf			(host_num_wf[WF_COUNT_WIDTH-1:0]),
      .host_wf_size			(host_wf_size[WAVE_ITEM_WIDTH-1:0]),
      .host_vgpr_size_total		(host_vgpr_size_total[VGPR_ID_WIDTH:0]),
      .host_sgpr_size_total		(host_sgpr_size_total[SGPR_ID_WIDTH:0]),
      .host_lds_size_total		(host_lds_size_total[LDS_ID_WIDTH:0]),
      .host_gds_size_total		(host_gds_size_total[GDS_ID_WIDTH:0]),
      .host_vgpr_size_per_wf		(host_vgpr_size_per_wf[VGPR_ID_WIDTH:0]),
      .host_sgpr_size_per_wf		(host_sgpr_size_per_wf[SGPR_ID_WIDTH:0]),
      .host_start_pc			(host_start_pc[MEM_ADDR_WIDTH-1:0]),
      .dis_controller_start_alloc	(dis_controller_start_alloc),
      .dis_controller_wg_alloc_valid	(dis_controller_wg_alloc_valid),
      .dis_controller_wg_dealloc_valid	(dis_controller_wg_dealloc_valid),
      .dis_controller_wg_rejected_valid	(dis_controller_wg_rejected_valid),
      .allocator_wg_id_out		(allocator_wg_id_out[WG_ID_WIDTH-1:0]),
      .gpu_interface_dealloc_wg_id	(gpu_interface_dealloc_wg_id[WG_ID_WIDTH-1:0]));


endmodule // dispatcher
