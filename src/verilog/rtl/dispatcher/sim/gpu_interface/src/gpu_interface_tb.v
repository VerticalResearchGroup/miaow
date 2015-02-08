// Local Variables:
// verilog-library-directories:("." "../../../" "../../src")
// End:
module gpu_interface_tb (/*AUTOARG*/) ;

   localparam WG_ID_WIDTH = 15;
   localparam NUMBER_WG_ID = 2**WG_ID_WIDTH;
   
   localparam WF_COUNT_WIDTH = 4;
   localparam MAX_WF_PER_WG = 2**WF_COUNT_WIDTH;
   
   localparam WG_SLOT_ID_WIDTH = 6;
   localparam NUMBER_WF_SLOTS = 40;

   localparam CU_ID_WIDTH = 3;
   localparam NUMBER_CU = 8;

   localparam VGPR_ID_WIDTH = 8;
   localparam NUMBER_VGPR_SLOTS = 2**VGPR_ID_WIDTH;
   
   
   localparam SGPR_ID_WIDTH = 8;
   localparam NUMBER_SGPR_SLOTS = 2**SGPR_ID_WIDTH;

   localparam LDS_ID_WIDTH = 8;
   localparam NUMBER_LDS_SLOTS = 2**LDS_ID_WIDTH;

   localparam GDS_ID_WIDTH = 8;
   localparam NUMBER_GDS_SLOTS = 2**GDS_ID_WIDTH;
   
   localparam MEM_ADDR_WIDTH = 32;

   localparam WAVE_ITEM_WIDTH = 6;
   localparam NUMBER_ITENS_WF = 64;
   
   localparam TAG_WIDTH = 15;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [NUMBER_CU-1:0]	cu2dispatch_wf_done;	// From cus of cu_simulator.v
   wire [NUMBER_CU*TAG_WIDTH-1:0] cu2dispatch_wf_tag_done;// From cus of cu_simulator.v
   wire [15:0]		dispatch2cu_lds_base_dispatch;// From DUT of gpu_interface.v
   wire [8:0]		dispatch2cu_sgpr_base_dispatch;// From DUT of gpu_interface.v
   wire [MEM_ADDR_WIDTH-1:0] dispatch2cu_start_pc_dispatch;// From DUT of gpu_interface.v
   wire [9:0]		dispatch2cu_vgpr_base_dispatch;// From DUT of gpu_interface.v
   wire [NUMBER_CU-1:0]	dispatch2cu_wf_dispatch;// From DUT of gpu_interface.v
   wire [WAVE_ITEM_WIDTH-1:0] dispatch2cu_wf_size_dispatch;// From DUT of gpu_interface.v
   wire [TAG_WIDTH-1:0]	dispatch2cu_wf_tag_dispatch;// From DUT of gpu_interface.v
   wire [WF_COUNT_WIDTH-1:0] dispatch2cu_wg_wf_count;// From DUT of gpu_interface.v
   wire			gpu_interface_alloc_available;// From DUT of gpu_interface.v
   wire [CU_ID_WIDTH-1:0] gpu_interface_cu_id;	// From DUT of gpu_interface.v
   wire			gpu_interface_dealloc_available;// From DUT of gpu_interface.v
   wire [WG_ID_WIDTH-1:0] gpu_interface_dealloc_wg_id;// From DUT of gpu_interface.v
   // End of automatics

   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg [CU_ID_WIDTH-1:0] allocator_cu_id_out;	// To DUT of gpu_interface.v
   reg [GDS_ID_WIDTH-1:0] allocator_gds_start_out;// To DUT of gpu_interface.v
   reg [LDS_ID_WIDTH-1:0] allocator_lds_start_out;// To DUT of gpu_interface.v
   reg [SGPR_ID_WIDTH-1:0] allocator_sgpr_start_out;// To DUT of gpu_interface.v
   reg [VGPR_ID_WIDTH-1:0] allocator_vgpr_start_out;// To DUT of gpu_interface.v
   reg [WF_COUNT_WIDTH-1:0] allocator_wf_count;	// To DUT of gpu_interface.v
   reg [WG_ID_WIDTH-1:0] allocator_wg_id_out;	// To DUT of gpu_interface.v
   reg			clk;			// To DUT of gpu_interface.v, ...
   reg			dis_controller_wg_alloc_valid;// To DUT of gpu_interface.v
   reg			dis_controller_wg_dealloc_valid;// To DUT of gpu_interface.v
   reg [SGPR_ID_WIDTH:0] inflight_wg_buffer_gpu_sgpr_size_per_wf;// To DUT of gpu_interface.v
   reg			inflight_wg_buffer_gpu_valid;// To DUT of gpu_interface.v
   reg [VGPR_ID_WIDTH:0] inflight_wg_buffer_gpu_vgpr_size_per_wf;// To DUT of gpu_interface.v
   reg [WAVE_ITEM_WIDTH-1:0] inflight_wg_buffer_gpu_wf_size;// To DUT of gpu_interface.v
   reg [MEM_ADDR_WIDTH-1:0] inflight_wg_buffer_start_pc;// To DUT of gpu_interface.v
   reg			rst;			// To DUT of gpu_interface.v, ...
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
       .WAVE_ITEM_WIDTH			(WAVE_ITEM_WIDTH))
   DUT
     (/*AUTOINST*/
      // Outputs
      .gpu_interface_alloc_available	(gpu_interface_alloc_available),
      .gpu_interface_dealloc_available	(gpu_interface_dealloc_available),
      .gpu_interface_cu_id		(gpu_interface_cu_id[CU_ID_WIDTH-1:0]),
      .gpu_interface_dealloc_wg_id	(gpu_interface_dealloc_wg_id[WG_ID_WIDTH-1:0]),
      .dispatch2cu_wf_dispatch		(dispatch2cu_wf_dispatch[NUMBER_CU-1:0]),
      .dispatch2cu_wg_wf_count		(dispatch2cu_wg_wf_count[WF_COUNT_WIDTH-1:0]),
      .dispatch2cu_wf_size_dispatch	(dispatch2cu_wf_size_dispatch[WAVE_ITEM_WIDTH-1:0]),
      .dispatch2cu_sgpr_base_dispatch	(dispatch2cu_sgpr_base_dispatch[8:0]),
      .dispatch2cu_vgpr_base_dispatch	(dispatch2cu_vgpr_base_dispatch[9:0]),
      .dispatch2cu_wf_tag_dispatch	(dispatch2cu_wf_tag_dispatch[TAG_WIDTH-1:0]),
      .dispatch2cu_lds_base_dispatch	(dispatch2cu_lds_base_dispatch[15:0]),
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

      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      rst = 1'b0;
      
   end
   
   // allocated wg info - wg_id, sizes, starts, wf_count, pc_start
   localparam NUM_WG_DISPATCHED = 10;
   
   // running wf
   localparam MAX_WF = 200;
   integer 		     wf_to_be_dispatched;
   wire 		     all_wf_dispatched;
   
   assign all_wf_dispatched = (wf_to_be_dispatched==0);

   // dispatched wf info - tag only
   task dealloc_wg;
      
      begin
	 while(!gpu_interface_alloc_available) @(posedge clk);
	 dis_controller_wg_dealloc_valid = 1'b1;
	 @(posedge clk);	 
	 dis_controller_wg_dealloc_valid = 1'b0;
	 @(posedge clk);	 
	 @(posedge clk);	 
      end
   endtask // repeat
   
      
   
   // dispatcher controller
   task alloc_wg;
      input [CU_ID_WIDTH-1 :0] cu_id;
      input [WG_ID_WIDTH-1:0]  wg_id;
      input [WF_COUNT_WIDTH-1:0] wf_count;
      input [VGPR_ID_WIDTH-1 :0] vgpr_start;
      input [VGPR_ID_WIDTH :0] 	 vgpr_size_per_wf;
      input [SGPR_ID_WIDTH-1 :0] sgpr_start;
      input [SGPR_ID_WIDTH :0] 	 sgpr_size_per_wf;
      input [LDS_ID_WIDTH-1 :0]  lds_start;
      input [GDS_ID_WIDTH-1 :0]  gds_start;
      input [WAVE_ITEM_WIDTH-1:0] wf_size;
      input [MEM_ADDR_WIDTH-1:0]  start_pc;

      begin
	 while(!gpu_interface_alloc_available) @(posedge clk);
	 dis_controller_wg_alloc_valid = 1'b1;
	 allocator_wg_id_out = wg_id;
	 allocator_cu_id_out = cu_id;
	 allocator_vgpr_start_out = vgpr_start;
	 allocator_sgpr_start_out = sgpr_start;
	 allocator_lds_start_out = lds_start;
	 allocator_gds_start_out = gds_start;
	 allocator_wf_count = wf_count;
	 @(posedge clk);
	 dis_controller_wg_alloc_valid = 1'b0;
	 
	 repeat(2) @(posedge clk);
	 inflight_wg_buffer_gpu_valid = 1'b1;
	 inflight_wg_buffer_gpu_vgpr_size_per_wf = vgpr_size_per_wf;
	 inflight_wg_buffer_gpu_sgpr_size_per_wf = sgpr_size_per_wf;
	 inflight_wg_buffer_gpu_wf_size = wf_size;
	 inflight_wg_buffer_start_pc = start_pc;
	 @(posedge clk);
	 inflight_wg_buffer_gpu_valid = 1'b0;
      end
   endtask //

   
   initial begin : ALLOCATION_BLOCK
      integer random_delay;
      integer i;

      reg [WF_COUNT_WIDTH-1:0] alloc_wf_count;
      
      reg [VGPR_ID_WIDTH-1 :0] alloc_vgpr_start;
      reg [VGPR_ID_WIDTH :0]   alloc_vgpr_size_per_wf;
      reg [SGPR_ID_WIDTH-1 :0] alloc_sgpr_start;
      reg [SGPR_ID_WIDTH :0]   alloc_sgpr_size_per_wf;
      
      dis_controller_wg_alloc_valid = 1'b0;
      inflight_wg_buffer_gpu_valid = 1'b0;
      dis_controller_wg_dealloc_valid = 1'b0;
      wf_to_be_dispatched = NUM_WG_DISPATCHED;
      
      @(posedge clk);
      @(negedge rst);

      @(posedge clk);

      for (i = 0; i < NUM_WG_DISPATCHED; i = i+1) begin
	 repeat({$random}%20) @(posedge clk);

	 if(gpu_interface_dealloc_available) begin
	    dealloc_wg;
	 end

	 alloc_wf_count = ({$random}%(MAX_WF_PER_WG-1))+1;
	 alloc_vgpr_size_per_wf = {$random}%(NUMBER_VGPR_SLOTS/alloc_wf_count);
	 alloc_vgpr_start = {$random}%(NUMBER_VGPR_SLOTS-(alloc_vgpr_size_per_wf*
							  alloc_wf_count));

	 alloc_sgpr_size_per_wf = {$random}%(NUMBER_SGPR_SLOTS/alloc_wf_count);
	 alloc_sgpr_start = {$random}%(NUMBER_SGPR_SLOTS-(alloc_sgpr_size_per_wf*
							  alloc_wf_count));

	 
	 alloc_wg({$random}%NUMBER_CU,
		  {$random}%NUMBER_WG_ID,
		  alloc_wf_count,
		  alloc_vgpr_start,
		  alloc_vgpr_size_per_wf,
		  alloc_sgpr_start,
		  alloc_sgpr_size_per_wf,
		  {$random}%NUMBER_LDS_SLOTS,
		  {$random}%NUMBER_GDS_SLOTS,
		  {$random}%(NUMBER_ITENS_WF-1)+1,
		  {$random});
	 wf_to_be_dispatched = wf_to_be_dispatched - 1;
      end // for (i = 0; i < NUM_WG_DISPATCHED; i = i+1)
      

      // Dealloc other wg
      forever begin
	 if(gpu_interface_dealloc_available) begin
	    dealloc_wg;
	 end
	 else begin
	   @(posedge clk);
	 end
      end
      
   end // block: ALLOCATION_BLOCK
   
      
   cu_simulator
     #(/*AUTOINSTPARAM*/
       // Parameters
       .CU_ID_WIDTH			(CU_ID_WIDTH),
       .NUMBER_CU			(NUMBER_CU),
       .TAG_WIDTH			(TAG_WIDTH),
       .WAVE_ITEM_WIDTH			(WAVE_ITEM_WIDTH),
       .WF_COUNT_WIDTH			(WF_COUNT_WIDTH),
       .MEM_ADDR_WIDTH			(MEM_ADDR_WIDTH),
       .MAX_WF				(MAX_WF))
   cus
     (/*AUTOINST*/
      // Outputs
      .cu2dispatch_wf_done		(cu2dispatch_wf_done[NUMBER_CU-1:0]),
      .cu2dispatch_wf_tag_done		(cu2dispatch_wf_tag_done[NUMBER_CU*TAG_WIDTH-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .all_wf_dispatched		(all_wf_dispatched),
      .dispatch2cu_wf_dispatch		(dispatch2cu_wf_dispatch[NUMBER_CU-1:0]),
      .dispatch2cu_lds_base_dispatch	(dispatch2cu_lds_base_dispatch[15:0]),
      .dispatch2cu_sgpr_base_dispatch	(dispatch2cu_sgpr_base_dispatch[8:0]),
      .dispatch2cu_start_pc_dispatch	(dispatch2cu_start_pc_dispatch[MEM_ADDR_WIDTH-1:0]),
      .dispatch2cu_vgpr_base_dispatch	(dispatch2cu_vgpr_base_dispatch[9:0]),
      .dispatch2cu_wf_size_dispatch	(dispatch2cu_wf_size_dispatch[WAVE_ITEM_WIDTH-1:0]),
      .dispatch2cu_wf_tag_dispatch	(dispatch2cu_wf_tag_dispatch[TAG_WIDTH-1:0]),
      .dispatch2cu_wg_wf_count		(dispatch2cu_wg_wf_count[WF_COUNT_WIDTH-1:0]));
   

   dispatcher_checker
     #(/*AUTOINSTPARAM*/
       // Parameters
       .WG_ID_WIDTH			(WG_ID_WIDTH),
       .NUMBER_WG_ID			(NUMBER_WG_ID),
       .WF_COUNT_WIDTH			(WF_COUNT_WIDTH),
       .MAX_WF_PER_WG			(MAX_WF_PER_WG),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS			(NUMBER_WF_SLOTS),
       .CU_ID_WIDTH			(CU_ID_WIDTH),
       .NUMBER_CU			(NUMBER_CU),
       .VGPR_ID_WIDTH			(VGPR_ID_WIDTH),
       .NUMBER_VGPR_SLOTS		(NUMBER_VGPR_SLOTS),
       .SGPR_ID_WIDTH			(SGPR_ID_WIDTH),
       .NUMBER_SGPR_SLOTS		(NUMBER_SGPR_SLOTS),
       .LDS_ID_WIDTH			(LDS_ID_WIDTH),
       .NUMBER_LDS_SLOTS		(NUMBER_LDS_SLOTS),
       .GDS_ID_WIDTH			(GDS_ID_WIDTH),
       .NUMBER_GDS_SLOTS		(NUMBER_GDS_SLOTS),
       .MEM_ADDR_WIDTH			(MEM_ADDR_WIDTH),
       .WAVE_ITEM_WIDTH			(WAVE_ITEM_WIDTH),
       .NUMBER_ITENS_WF			(NUMBER_ITENS_WF),
       .TAG_WIDTH			(TAG_WIDTH),
       .MAX_WF				(MAX_WF))
   dis_checker
     (
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .dispatch2cu_wf_dispatch		(dispatch2cu_wf_dispatch[NUMBER_CU-1:0]),
      .dispatch2cu_lds_base_dispatch	(dispatch2cu_lds_base_dispatch[15:0]),
      .dispatch2cu_sgpr_base_dispatch	(dispatch2cu_sgpr_base_dispatch[8:0]),
      .dispatch2cu_start_pc_dispatch	(dispatch2cu_start_pc_dispatch[MEM_ADDR_WIDTH-1:0]),
      .dispatch2cu_vgpr_base_dispatch	(dispatch2cu_vgpr_base_dispatch[9:0]),
      .dispatch2cu_wf_size_dispatch	(dispatch2cu_wf_size_dispatch[WAVE_ITEM_WIDTH-1:0]),
      .dispatch2cu_wf_tag_dispatch	(dispatch2cu_wf_tag_dispatch[TAG_WIDTH-1:0]),
      .dispatch2cu_wg_wf_count		(dispatch2cu_wg_wf_count[WF_COUNT_WIDTH-1:0]),
      .alloc_valid			(dis_controller_wg_alloc_valid),
      .inflight_buffer_valid		(inflight_wg_buffer_gpu_valid),
      .cu_id				(allocator_cu_id_out),
      .wg_id				(allocator_wg_id_out),
      .wf_count				(allocator_wf_count),
      .vgpr_start			(allocator_vgpr_start_out),
      .vgpr_size_per_wf			(inflight_wg_buffer_gpu_vgpr_size_per_wf),
      .sgpr_start			(allocator_sgpr_start_out),
      .sgpr_size_per_wf			(inflight_wg_buffer_gpu_sgpr_size_per_wf),
      .lds_start			(allocator_lds_start_out),
      .gds_start			(allocator_gds_start_out),
      .wf_size				(inflight_wg_buffer_gpu_wf_size),
      .start_pc				(inflight_wg_buffer_start_pc));
   
      
endmodule // gpu_interface_tb
