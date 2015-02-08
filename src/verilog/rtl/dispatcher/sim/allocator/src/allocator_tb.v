// Local Variables:
// verilog-library-directories:("." "../../../")
// End:
module allocator_tb();

   localparam WG_ID_WIDTH = 8;
   localparam CU_ID_WIDTH = 2;
   localparam NUMBER_CU = 4;
   localparam VGPR_ID_WIDTH = 8;
   localparam NUMBER_VGPR_SLOTS = 256;
   localparam SGPR_ID_WIDTH = 8;
   localparam NUMBER_SGPR_SLOTS = 256;
   localparam LDS_ID_WIDTH = 7;
   localparam NUMBER_LDS_SLOTS = 128;
   localparam WG_SLOT_ID_WIDTH = 6;
   localparam NUMBER_WF_SLOTS = 40;
   localparam GDS_ID_WIDTH = 7;
   localparam GDS_SIZE = 128;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [CU_ID_WIDTH-1:0] allocator_cu_id_out;	// From DUT of allocator.v
   wire			allocator_cu_rejected;	// From DUT of allocator.v
   wire			allocator_cu_valid;	// From DUT of allocator.v
   wire [GDS_ID_WIDTH:0] allocator_gds_size_out;// From DUT of allocator.v
   wire [GDS_ID_WIDTH-1:0] allocator_gds_start_out;// From DUT of allocator.v
   wire [LDS_ID_WIDTH:0] allocator_lds_size_out;// From DUT of allocator.v
   wire [LDS_ID_WIDTH-1:0] allocator_lds_start_out;// From DUT of allocator.v
   wire [SGPR_ID_WIDTH:0] allocator_sgpr_size_out;// From DUT of allocator.v
   wire [SGPR_ID_WIDTH-1:0] allocator_sgpr_start_out;// From DUT of allocator.v
   wire [VGPR_ID_WIDTH:0] allocator_vgpr_size_out;// From DUT of allocator.v
   wire [VGPR_ID_WIDTH-1:0] allocator_vgpr_start_out;// From DUT of allocator.v
   wire [WG_ID_WIDTH-1:0] allocator_wg_id_out;	// From DUT of allocator.v
   // End of automatics

   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg			clk;			// To DUT of allocator.v
   reg			dis_controller_alloc_ack;// To DUT of allocator.v
   reg [NUMBER_CU-1:0]	dis_controller_cu_busy;	// To DUT of allocator.v
   reg			dis_controller_start_alloc;// To DUT of allocator.v
   reg [CU_ID_WIDTH-1:0] grt_cam_up_cu_id;	// To DUT of allocator.v
   reg [GDS_ID_WIDTH:0]	grt_cam_up_gds_size;	// To DUT of allocator.v
   reg [GDS_ID_WIDTH-1:0] grt_cam_up_gds_strt;	// To DUT of allocator.v
   reg [LDS_ID_WIDTH:0]	grt_cam_up_lds_size;	// To DUT of allocator.v
   reg [LDS_ID_WIDTH-1:0] grt_cam_up_lds_strt;	// To DUT of allocator.v
   reg [SGPR_ID_WIDTH:0] grt_cam_up_sgpr_size;	// To DUT of allocator.v
   reg [SGPR_ID_WIDTH-1:0] grt_cam_up_sgpr_strt;// To DUT of allocator.v
   reg			grt_cam_up_valid;	// To DUT of allocator.v
   reg [VGPR_ID_WIDTH:0] grt_cam_up_vgpr_size;	// To DUT of allocator.v
   reg [VGPR_ID_WIDTH-1:0] grt_cam_up_vgpr_strt;// To DUT of allocator.v
   reg [WG_SLOT_ID_WIDTH-1:0] grt_cam_up_wg_count;// To DUT of allocator.v
   reg [GDS_ID_WIDTH:0]	inflight_wg_buffer_alloc_gds_size;// To DUT of allocator.v
   reg [LDS_ID_WIDTH:0]	inflight_wg_buffer_alloc_lds_size;// To DUT of allocator.v
   reg [WG_SLOT_ID_WIDTH:0] inflight_wg_buffer_alloc_num_wf;// To DUT of allocator.v
   reg [SGPR_ID_WIDTH:0] inflight_wg_buffer_alloc_sgpr_size;// To DUT of allocator.v
   reg [VGPR_ID_WIDTH:0] inflight_wg_buffer_alloc_vgpr_size;// To DUT of allocator.v
   reg [WG_ID_WIDTH-1:0] inflight_wg_buffer_alloc_wg_id;// To DUT of allocator.v
   reg			rst;			// To DUT of allocator.v
   // End of automatics

   
   /***
    * Use a procedure to set:
    * * Search info
    * * Cam update info
    ***/

   // Allocates a wg
   task alloc_wg;
      input [WG_SLOT_ID_WIDTH:0]  num_wf;
      input [VGPR_ID_WIDTH:0] vgpr_size;
      input [SGPR_ID_WIDTH:0] sgpr_size;
      input [LDS_ID_WIDTH:0] lds_size;
      input [GDS_ID_WIDTH:0] gds_size;
      begin
	 dis_controller_start_alloc <= 1'b1;
	 inflight_wg_buffer_alloc_wg_id <= inflight_wg_buffer_alloc_wg_id + 1;
	 inflight_wg_buffer_alloc_vgpr_size <= vgpr_size;
	 inflight_wg_buffer_alloc_sgpr_size <= sgpr_size;
	 inflight_wg_buffer_alloc_lds_size <= lds_size;
	 inflight_wg_buffer_alloc_gds_size <= gds_size;
	 inflight_wg_buffer_alloc_num_wf <= num_wf;
	 @(posedge clk);
	 dis_controller_start_alloc <= 1'b0;
      end
   endtask

   task wait_allocation;
      begin
	 while(!allocator_cu_valid) @(posedge clk);
	 dis_controller_cu_busy[allocator_cu_id_out] <= 1'b1;
	 
	 @(posedge clk);
	 @(posedge clk);
	 dis_controller_alloc_ack <= 1'b1;
	 @(posedge clk);
	 dis_controller_alloc_ack <= 1'b0;
	 @(posedge clk);
      end
   endtask
   
   // Do a cam update
   task cam_up;
      input [CU_ID_WIDTH-1:0] cu_id;
      input [VGPR_ID_WIDTH:0]   vgpr_size;
      input [VGPR_ID_WIDTH-1:0] vgpr_strt;
      input [SGPR_ID_WIDTH:0]  sgpr_size;
      input [SGPR_ID_WIDTH-1:0] sgpr_strt;
      input [LDS_ID_WIDTH:0]   lds_size;
      input [LDS_ID_WIDTH-1:0] lds_strt;
      input [GDS_ID_WIDTH:0]  gds_size;
      input [GDS_ID_WIDTH-1:0] gds_strt;
      input [WG_SLOT_ID_WIDTH:0]  num_wf;
      begin
	 dis_controller_cu_busy[grt_cam_up_cu_id] <= 1'b0;

	 grt_cam_up_valid <= 1'b1;
	 grt_cam_up_cu_id <= cu_id;
	 grt_cam_up_vgpr_size <= vgpr_size;
	 grt_cam_up_vgpr_strt <= vgpr_strt;

	 grt_cam_up_sgpr_size <= sgpr_size;
	 grt_cam_up_sgpr_strt <= sgpr_strt;

	 grt_cam_up_lds_size <= lds_size;
	 grt_cam_up_lds_strt <= lds_strt;

	 grt_cam_up_gds_size <= gds_size;
	 grt_cam_up_gds_strt <= gds_strt;

	 grt_cam_up_wg_count <= num_wf;
	 @(posedge clk);

	 grt_cam_up_valid <= 1'b0;
      end
   endtask
   
   
   allocator #(/*AUTOINSTPARAM*/
	       // Parameters
	       .WG_ID_WIDTH		(WG_ID_WIDTH),
	       .CU_ID_WIDTH		(CU_ID_WIDTH),
	       .NUMBER_CU		(NUMBER_CU),
	       .VGPR_ID_WIDTH		(VGPR_ID_WIDTH),
	       .NUMBER_VGPR_SLOTS	(NUMBER_VGPR_SLOTS),
	       .SGPR_ID_WIDTH		(SGPR_ID_WIDTH),
	       .NUMBER_SGPR_SLOTS	(NUMBER_SGPR_SLOTS),
	       .LDS_ID_WIDTH		(LDS_ID_WIDTH),
	       .NUMBER_LDS_SLOTS	(NUMBER_LDS_SLOTS),
	       .WG_SLOT_ID_WIDTH	(WG_SLOT_ID_WIDTH),
	       .NUMBER_WF_SLOTS		(NUMBER_WF_SLOTS),
	       .GDS_ID_WIDTH		(GDS_ID_WIDTH),
	       .GDS_SIZE		(GDS_SIZE))
   DUT (/*AUTOINST*/
	// Outputs
	.allocator_cu_valid		(allocator_cu_valid),
	.allocator_cu_rejected		(allocator_cu_rejected),
	.allocator_wg_id_out		(allocator_wg_id_out[WG_ID_WIDTH-1:0]),
	.allocator_cu_id_out		(allocator_cu_id_out[CU_ID_WIDTH-1:0]),
	.allocator_vgpr_start_out	(allocator_vgpr_start_out[VGPR_ID_WIDTH-1:0]),
	.allocator_sgpr_start_out	(allocator_sgpr_start_out[SGPR_ID_WIDTH-1:0]),
	.allocator_lds_start_out	(allocator_lds_start_out[LDS_ID_WIDTH-1:0]),
	.allocator_gds_start_out	(allocator_gds_start_out[GDS_ID_WIDTH-1:0]),
	.allocator_vgpr_size_out	(allocator_vgpr_size_out[VGPR_ID_WIDTH:0]),
	.allocator_sgpr_size_out	(allocator_sgpr_size_out[SGPR_ID_WIDTH:0]),
	.allocator_lds_size_out		(allocator_lds_size_out[LDS_ID_WIDTH:0]),
	.allocator_gds_size_out		(allocator_gds_size_out[GDS_ID_WIDTH:0]),
	// Inputs
	.clk				(clk),
	.rst				(rst),
	.inflight_wg_buffer_alloc_wg_id	(inflight_wg_buffer_alloc_wg_id[WG_ID_WIDTH-1:0]),
	.inflight_wg_buffer_alloc_num_wf(inflight_wg_buffer_alloc_num_wf[WG_SLOT_ID_WIDTH:0]),
	.inflight_wg_buffer_alloc_vgpr_size(inflight_wg_buffer_alloc_vgpr_size[VGPR_ID_WIDTH:0]),
	.inflight_wg_buffer_alloc_sgpr_size(inflight_wg_buffer_alloc_sgpr_size[SGPR_ID_WIDTH:0]),
	.inflight_wg_buffer_alloc_lds_size(inflight_wg_buffer_alloc_lds_size[LDS_ID_WIDTH:0]),
	.inflight_wg_buffer_alloc_gds_size(inflight_wg_buffer_alloc_gds_size[GDS_ID_WIDTH:0]),
	.dis_controller_cu_busy		(dis_controller_cu_busy[NUMBER_CU-1:0]),
	.dis_controller_alloc_ack	(dis_controller_alloc_ack),
	.dis_controller_start_alloc	(dis_controller_start_alloc),
	.grt_cam_up_valid		(grt_cam_up_valid),
	.grt_cam_up_cu_id		(grt_cam_up_cu_id[CU_ID_WIDTH-1:0]),
	.grt_cam_up_vgpr_strt		(grt_cam_up_vgpr_strt[VGPR_ID_WIDTH-1:0]),
	.grt_cam_up_vgpr_size		(grt_cam_up_vgpr_size[VGPR_ID_WIDTH:0]),
	.grt_cam_up_sgpr_strt		(grt_cam_up_sgpr_strt[SGPR_ID_WIDTH-1:0]),
	.grt_cam_up_sgpr_size		(grt_cam_up_sgpr_size[SGPR_ID_WIDTH:0]),
	.grt_cam_up_lds_strt		(grt_cam_up_lds_strt[LDS_ID_WIDTH-1:0]),
	.grt_cam_up_lds_size		(grt_cam_up_lds_size[LDS_ID_WIDTH:0]),
	.grt_cam_up_gds_strt		(grt_cam_up_gds_strt[GDS_ID_WIDTH-1:0]),
	.grt_cam_up_gds_size		(grt_cam_up_gds_size[GDS_ID_WIDTH:0]),
	.grt_cam_up_wg_count		(grt_cam_up_wg_count[WG_SLOT_ID_WIDTH-1:0]));


   // Clk block
   initial begin
      clk = 1'b0;
      forever begin
	 #5  clk =  ! clk;
      end
   end

   initial begin
      // Reset the design
      rst = 1'b1;
      dis_controller_start_alloc <= 0;
      inflight_wg_buffer_alloc_wg_id <= 0;
      dis_controller_alloc_ack <= 0;

      dis_controller_cu_busy <= 0;
      
      grt_cam_up_valid <= 0;
      
      @(posedge clk);
      @(posedge clk);
      rst = 1'b0;

      // Do search in the empty allocator (it should return ok).
      alloc_wg(2, 32, 16, 8, 8);
      wait_allocation();
      alloc_wg(2, 256, 16, 8, 8);
      wait_allocation();
      dis_controller_cu_busy[0] <= 1'b1;
      
      
      // Write stuff to cam
      cam_up(0,0,0,16,0,8,0,8,0,30);
      cam_up(1,0,0,16,0,8,0,8,0,30);
      cam_up(2,0,0,16,0,8,0,8,0,30);
      cam_up(3,224,0,16,0,8,0,8,0,30);
      
      // Do search after write stuff
      alloc_wg(2, 32, 16, 8, 8);
      wait_allocation();
      // Write more stuf
      cam_up(3,0,0,16,0,8,0,8,0,20);


      alloc_wg(2, 32, 16, 8, 8);
      wait_allocation();
   end
   
endmodule // allocator_tb
