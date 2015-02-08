// Local Variables:
// verilog-library-directories:("." "../../../")
// End:
module global_resource_table_tb (/*AUTOARG*/) ;

   localparam NUMBER_CU = 8;
   localparam CU_ID_WIDTH = 3;
   localparam WG_ID_WIDTH = 10;
   localparam WF_ID_WIDTH = 15;
   localparam WG_SLOT_ID_WIDTH = 6;
   localparam NUMBER_WF_SLOTS = 40;
   localparam RES_TABLE_ADDR_WIDTH = 1;
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
   wire [CU_ID_WIDTH-1:0] grt_cam_up_cu_id;	// From DUT of global_resource_table.v
   wire [GDS_ID_WIDTH:0] grt_cam_up_gds_size;	// From DUT of global_resource_table.v
   wire [LDS_ID_WIDTH:0] grt_cam_up_lds_size;	// From DUT of global_resource_table.v
   wire [LDS_ID_WIDTH-1:0] grt_cam_up_lds_strt;	// From DUT of global_resource_table.v
   wire [SGPR_ID_WIDTH:0] grt_cam_up_sgpr_size;	// From DUT of global_resource_table.v
   wire [SGPR_ID_WIDTH-1:0] grt_cam_up_sgpr_strt;// From DUT of global_resource_table.v
   wire			grt_cam_up_valid;	// From DUT of global_resource_table.v
   wire [VGPR_ID_WIDTH:0] grt_cam_up_vgpr_size;	// From DUT of global_resource_table.v
   wire [VGPR_ID_WIDTH-1:0] grt_cam_up_vgpr_strt;// From DUT of global_resource_table.v
   wire [WG_SLOT_ID_WIDTH:0] grt_cam_up_wg_count;// From DUT of global_resource_table.v
   wire			grt_wg_alloc_done;	// From DUT of global_resource_table.v
   wire [WG_ID_WIDTH-1:0] grt_wg_alloc_wgid;	// From DUT of global_resource_table.v
   wire			grt_wg_dealloc_done;	// From DUT of global_resource_table.v
   wire [WG_ID_WIDTH-1:0] grt_wg_dealloc_wgid;	// From DUT of global_resource_table.v
   // End of automatics

   reg 			     clk, rst;
   
   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg [CU_ID_WIDTH-1:0] allocator_cu_id_out;	// To DUT of global_resource_table.v
   reg [GDS_ID_WIDTH:0]	allocator_gds_size_out;	// To DUT of global_resource_table.v
   reg [GDS_ID_WIDTH-1:0] allocator_gds_start_out;// To DUT of global_resource_table.v
   reg [LDS_ID_WIDTH:0]	allocator_lds_size_out;	// To DUT of global_resource_table.v
   reg [LDS_ID_WIDTH-1:0] allocator_lds_start_out;// To DUT of global_resource_table.v
   reg [SGPR_ID_WIDTH:0] allocator_sgpr_size_out;// To DUT of global_resource_table.v
   reg [SGPR_ID_WIDTH-1:0] allocator_sgpr_start_out;// To DUT of global_resource_table.v
   reg [VGPR_ID_WIDTH:0] allocator_vgpr_size_out;// To DUT of global_resource_table.v
   reg [VGPR_ID_WIDTH-1:0] allocator_vgpr_start_out;// To DUT of global_resource_table.v
   reg [WG_SLOT_ID_WIDTH:0] allocator_wf_count;	// To DUT of global_resource_table.v
   reg [WG_ID_WIDTH-1:0] allocator_wg_id_out;	// To DUT of global_resource_table.v
   reg			dis_controller_wg_alloc_valid;// To DUT of global_resource_table.v
   reg			dis_controller_wg_dealloc_valid;// To DUT of global_resource_table.v
   reg [CU_ID_WIDTH-1:0] gpu_interface_cu_id;	// To DUT of global_resource_table.v
   reg [WG_ID_WIDTH-1:0] gpu_interface_wg_id;	// To DUT of global_resource_table.v
   // End of automatics

   reg [VGPR_ID_WIDTH-1:0] next_vgpr_start[NUMBER_CU-1:0];
   reg [SGPR_ID_WIDTH-1:0] next_sgpr_start[NUMBER_CU-1:0];
   reg [LDS_ID_WIDTH-1:0] next_lds_start[NUMBER_CU-1:0];
   
   task allocate_wg;
      input [CU_ID_WIDTH-1:0] cu_id;
      input [WG_ID_WIDTH-1:0] wg_id;
      input [WG_SLOT_ID_WIDTH-1:0] wf_count;
      input [VGPR_ID_WIDTH:0] 	   vgpr_size;
      input [SGPR_ID_WIDTH:0] 	   sgpr_size;
      input [LDS_ID_WIDTH:0] 	   lds_size;
      input [GDS_ID_WIDTH-1:0] 	   gds_size;
      begin
 	 dis_controller_wg_alloc_valid <= 1'b1;
	 allocator_cu_id_out <= cu_id;
	 allocator_wg_id_out <= wg_id;
	 allocator_wf_count <= wf_count;

	 allocator_vgpr_size_out <= vgpr_size;
	 allocator_vgpr_start_out <= next_vgpr_start[cu_id];
	 next_vgpr_start[cu_id] = next_vgpr_start[cu_id] + vgpr_size;
	 
	 allocator_sgpr_size_out <= sgpr_size;
	 allocator_sgpr_start_out <= next_sgpr_start[cu_id];
	 next_sgpr_start[cu_id] = next_sgpr_start[cu_id] + sgpr_size;
	 
	 allocator_lds_size_out <= lds_size;
	 allocator_lds_start_out <= next_lds_start[cu_id];
	 next_lds_start[cu_id] = next_lds_start[cu_id] + lds_size;

	 allocator_gds_size_out <= gds_size;
	 @(posedge clk);
 	 dis_controller_wg_alloc_valid <= 1'b0;

      end
   endtask // NUMBER_CU

   task deallocate_wg;
      input [CU_ID_WIDTH-1:0] cu_id;
      input [WG_ID_WIDTH-1:0] wg_id;
      
      begin
	 dis_controller_wg_dealloc_valid <= 1'b1;
	 gpu_interface_cu_id <= cu_id;
	 gpu_interface_wg_id <= wg_id;
	 @(posedge clk);
 	 dis_controller_wg_dealloc_valid <= 1'b0;
      end
   endtask // NUMBER_CU
   
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
   DUT
     (/*AUTOINST
       */
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
      .grt_cam_up_gds_size		(grt_cam_up_gds_size[GDS_ID_WIDTH:0]),
      .grt_wg_alloc_done		(grt_wg_alloc_done),
      .grt_wg_alloc_wgid		(grt_wg_alloc_wgid[WG_ID_WIDTH-1:0]),
      .grt_wg_dealloc_done		(grt_wg_dealloc_done),
      .grt_wg_dealloc_wgid		(grt_wg_dealloc_wgid[WG_ID_WIDTH-1:0]),
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

   // Clk block
   initial begin
      clk = 1'b0;
      forever begin
	 #5  clk =  ! clk;
      end
   end

   initial begin : TEST_BLOCK
      integer i;
      for(i=0; i<NUMBER_CU; i=i+1) begin
	 next_vgpr_start[i] = 0;
	 next_sgpr_start[i] = 0;
	 next_lds_start[i] = 0;
      end
      
      // Reset the design
      rst = 1'b1;

      dis_controller_wg_alloc_valid <= 1'b0;
      dis_controller_wg_dealloc_valid <= 1'b0;
      allocate_wg(0,0,0,0,0,0,0);
      deallocate_wg(0,0);

      @(posedge clk);
      @(posedge clk);
      rst = 1'b0;

      @(posedge clk);
      @(posedge clk);
      
      allocate_wg(0,0,8,32,4,8,16);
      allocate_wg(4,1,8,10,2,4,20);

      repeat(100) @(posedge clk);
      allocate_wg(1,2,8,32,4,8,16);
      allocate_wg(5,3,8,10,2,4,20);
      repeat(100) @(posedge clk);
      allocate_wg(0,4,8,32,4,8,16);
      allocate_wg(4,5,8,10,2,4,20);
      repeat(100) @(posedge clk);

      allocate_wg(1,6,8,32,4,8,16);
      allocate_wg(4,7,8,10,2,4,20);
      repeat(100) @(posedge clk);

      deallocate_wg(4,1);
      deallocate_wg(0,4);
      repeat(100) @(posedge clk);

      deallocate_wg(0,0);
      repeat(100) @(posedge clk);

      allocate_wg(0,0,8,32,4,8,16);
      allocate_wg(4,1,4,10,2,4,20);

      repeat(100) @(posedge clk);
      deallocate_wg(4,1);
      deallocate_wg(0,0);
      
      repeat(100) @(posedge clk);
      $stop;
      
   end // initial begin
   
endmodule // global_resource_table_tb

