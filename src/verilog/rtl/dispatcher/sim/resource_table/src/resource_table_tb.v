// Local Variables:
// verilog-library-directories:("." "../../../")
// End:
module resource_table_tb ();

   localparam		CU_ID_WIDTH = 1;
   localparam		NUMBER_CU = 2;
   localparam		WG_SLOT_ID_WIDTH =  4;
   localparam		NUMBER_WG_SLOTS_PER_CU = 4;
   localparam		RES_ID_WIDTH = 4;
   localparam		NUMBER_RES_SLOTS = 16;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [RES_ID_WIDTH-1:0] cam_biggest_space_addr;// From DUT of resource_table.v
   wire [RES_ID_WIDTH:0] cam_biggest_space_size;// From DUT of resource_table.v
   wire			res_table_done;		// From DUT of resource_table.v
   // End of automatics

   reg 			   clk;
   reg 			   rst;
   

   reg [CU_ID_WIDTH-1:0]   alloc_cu_id;		// To DUT of resource_table.v
   reg 			   alloc_res_en;		// To DUT of resource_table.v
   reg [RES_ID_WIDTH:0]  alloc_res_size;	// To DUT of resource_table.v
   reg [RES_ID_WIDTH-1:0]  alloc_res_start;	// To DUT of resource_table.v
   reg [WG_SLOT_ID_WIDTH-1:0] alloc_wg_slot_id;// To DUT of resource_table.v

   reg 			      dealloc_res_en;		// To DUT of resource_table.   
   reg [CU_ID_WIDTH-1:0]      dealloc_cu_id;	// To DUT of resource_table.v
   reg [WG_SLOT_ID_WIDTH-1:0] dealloc_wg_slot_id;// To DUT of resource_table.v
   resource_table #(/*AUTOINSTPARAM*/
		    // Parameters
		    .CU_ID_WIDTH	(CU_ID_WIDTH),
		    .NUMBER_CU		(NUMBER_CU),
		    .WG_SLOT_ID_WIDTH	(WG_SLOT_ID_WIDTH),
		    .NUMBER_WG_SLOTS_PER_CU(NUMBER_WG_SLOTS_PER_CU),
		    .RES_ID_WIDTH	(RES_ID_WIDTH),
		    .NUMBER_RES_SLOTS	(NUMBER_RES_SLOTS)) 
   DUT (/*AUTOINST*/
	// Outputs
	.res_table_done			(res_table_done),
	.cam_biggest_space_size		(cam_biggest_space_size[RES_ID_WIDTH:0]),
	.cam_biggest_space_addr		(cam_biggest_space_addr[RES_ID_WIDTH-1:0]),
	// Inputs
	.clk				(clk),
	.rst				(rst),
	.alloc_res_en			(alloc_res_en),
	.dealloc_res_en			(dealloc_res_en),
	.alloc_cu_id			(alloc_cu_id[CU_ID_WIDTH-1:0]),
	.dealloc_cu_id			(dealloc_cu_id[CU_ID_WIDTH-1:0]),
	.alloc_wg_slot_id		(alloc_wg_slot_id[WG_SLOT_ID_WIDTH-1:0]),
	.dealloc_wg_slot_id		(dealloc_wg_slot_id[WG_SLOT_ID_WIDTH-1:0]),
	.alloc_res_start		(alloc_res_start[RES_ID_WIDTH-1:0]),
	.alloc_res_size			(alloc_res_size[RES_ID_WIDTH:0]));
   

   task alloc_res;
      input [CU_ID_WIDTH-1:0] cu_id;
      input [WG_SLOT_ID_WIDTH-1:0] wg_slot_id;
      input [RES_ID_WIDTH-1:0]    res_start;
      input [RES_ID_WIDTH:0] 	   res_size;
      begin
	 alloc_res_en <= 1'b1;
	 alloc_cu_id <= cu_id;
	 alloc_wg_slot_id <= wg_slot_id;
	 alloc_res_start <= res_start;
	 alloc_res_size <= res_size;
	 @(posedge clk);
	 alloc_res_en <= 1'b0;
      end
   endtask //

   task dealloc_res;
      input [CU_ID_WIDTH-1:0] cu_id;
      input [WG_SLOT_ID_WIDTH-1:0] wg_slot_id;
      begin
	 dealloc_res_en <= 1'b1;
	 dealloc_cu_id <= cu_id;
	 dealloc_wg_slot_id <= wg_slot_id;
	 @(posedge clk);
	 dealloc_res_en <= 1'b0;
      end
   endtask //
   
   
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
      alloc_res_en <= 1'b0;
      dealloc_res_en <= 1'b0;
      @(posedge clk);
      @(posedge clk);
      rst = 1'b0;

      // Allocate some wf
      @(posedge clk);
      @(posedge clk);

      alloc_res(0,0,0,5);
      @(posedge res_table_done);
      @(posedge clk);

/* -----\/----- EXCLUDED -----\/-----
      alloc_res(0,1,5,5);
      @(posedge res_table_done);
      @(posedge clk);
      
      alloc_res(0,2,15,1);
      @(posedge res_table_done);
      @(posedge clk);
      
      alloc_res(0,3,10,5);
      @(posedge res_table_done);
      @(posedge clk);

      alloc_res(1,3,10,5);
      @(posedge res_table_done);
      @(posedge clk);
 -----/\----- EXCLUDED -----/\----- */
      
      // Deallocate some
      dealloc_res(0,0);
      @(posedge res_table_done);
      @(posedge clk);

/* -----\/----- EXCLUDED -----\/-----
      dealloc_res(0,1);
      @(posedge res_table_done);
      @(posedge clk);

      dealloc_res(0,3);
      @(posedge res_table_done);
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
 -----/\----- EXCLUDED -----/\----- */
      alloc_res(0,0,0,5);
      @(posedge res_table_done);
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);

      dealloc_res(0,0);
      @(posedge res_table_done);
      @(posedge clk);
      
      $stop;
      
      // Allocate some

      // Add control signals to trigger printing stuff
   end
   
endmodule // resource_table_tb
