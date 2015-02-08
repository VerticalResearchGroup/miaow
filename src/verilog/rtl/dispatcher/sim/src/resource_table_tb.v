// Local Variables:
// verilog-library-directories:("." "../../")
// End:
module resource_table_tb ();

   localparam		CU_ID_WIDTH = 1;
   localparam		NUMBER_CU = 2;
   localparam		WF_SLOT_ID_WIDTH =  4;
   localparam		NUMBER_WF_SLOTS_PER_CU = 4;
   localparam		RES_ID_WIDTH = 4;
   localparam		NUMBER_RES_SLOTS = 16;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [RES_ID_WIDTH-1:0] cam_biggest_space_addr;// From DUT of resource_table.v
   wire [RES_ID_WIDTH-1:0] cam_biggest_space_size;// From DUT of resource_table.v
   wire 		   res_table_done;		// From DUT of resource_table.v
   // End of automatics

   reg 			   clk;
   reg 			   rst;
   

   reg [CU_ID_WIDTH-1:0]   alloc_cu_id;		// To DUT of resource_table.v
   reg 			   alloc_res_en;		// To DUT of resource_table.v
   reg [RES_ID_WIDTH-1:0]  alloc_res_size;	// To DUT of resource_table.v
   reg [RES_ID_WIDTH-1:0]  alloc_res_start;	// To DUT of resource_table.v
   reg [WF_SLOT_ID_WIDTH-1:0] alloc_wf_slot_id;// To DUT of resource_table.v

   reg 			      dealloc_res_en;		// To DUT of resource_table.   
   reg [CU_ID_WIDTH-1:0]      dealloc_cu_id;	// To DUT of resource_table.v
   reg [WF_SLOT_ID_WIDTH-1:0] dealloc_wf_slot_id;// To DUT of resource_table.v
   resource_table #(/*AUTOINSTPARAM*/
		    // Parameters
		    .CU_ID_WIDTH	(CU_ID_WIDTH),
		    .WF_SLOT_ID_WIDTH	(WF_SLOT_ID_WIDTH),
		    .NUMBER_CU		(NUMBER_CU),
		    .NUMBER_WF_SLOTS_PER_CU(NUMBER_WF_SLOTS_PER_CU),
		    .NUMBER_RES_SLOTS	(NUMBER_RES_SLOTS),
		    .RES_ID_WIDTH	(RES_ID_WIDTH)) 
   DUT (/*AUTOINST*/
	// Outputs
	.res_table_done			(res_table_done),
	.cam_biggest_space_size		(cam_biggest_space_size[RES_ID_WIDTH-1:0]),
	.cam_biggest_space_addr		(cam_biggest_space_addr[RES_ID_WIDTH-1:0]),
	// Inputs
	.clk				(clk),
	.rst				(rst),
	.alloc_res_en			(alloc_res_en),
	.dealloc_res_en			(dealloc_res_en),
	.alloc_cu_id			(alloc_cu_id[CU_ID_WIDTH-1:0]),
	.dealloc_cu_id			(dealloc_cu_id[CU_ID_WIDTH-1:0]),
	.alloc_wf_slot_id		(alloc_wf_slot_id[WF_SLOT_ID_WIDTH-1:0]),
	.dealloc_wf_slot_id		(dealloc_wf_slot_id[WF_SLOT_ID_WIDTH-1:0]),
	.alloc_res_size			(alloc_res_size[RES_ID_WIDTH-1:0]),
	.alloc_res_start		(alloc_res_start[RES_ID_WIDTH-1:0]));
   

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
      alloc_res_en <= 1'b1;

      alloc_cu_id <= 2'h0;
      alloc_wf_slot_id <= 4'h0;

      alloc_res_start <= 0;
      alloc_res_size <= 4'h5;
      @(posedge clk);
      alloc_res_en <= 1'b0;
      
      @(posedge res_table_done);
      @(posedge clk);
      alloc_res_en <= 1'b1;

      alloc_cu_id <= 2'h0;
      alloc_wf_slot_id <= 4'h1;

      alloc_res_start <= 4'h5;
      alloc_res_size <= 4'h5;
      @(posedge clk);
      alloc_res_en <= 1'b0;
      
      @(posedge res_table_done);
      @(posedge clk);
      
      alloc_res_en <= 1'b1;

      alloc_cu_id <= 2'h0;
      alloc_wf_slot_id <= 4'h2;

      alloc_res_start <= 4'hf;
      alloc_res_size <= 4'h1;
      @(posedge clk);
      alloc_res_en <= 1'b0;
      
      @(posedge res_table_done);
      @(posedge clk);
      
      alloc_res_en <= 1'b1;

      alloc_cu_id <= 2'h0;
      alloc_wf_slot_id <= 4'h3;

      alloc_res_start <= 4'ha;
      alloc_res_size <= 4'h5;
      @(posedge clk);
      alloc_res_en <= 1'b0;
      
      @(posedge res_table_done);
      @(posedge clk);

      alloc_res_en <= 1'b1;

      alloc_cu_id <= 1'h1;
      alloc_wf_slot_id <= 4'h3;

      alloc_res_start <= 4'ha;
      alloc_res_size <= 4'h5;
      @(posedge clk);
      alloc_res_en <= 1'b0;
      
      @(posedge res_table_done);
      @(posedge clk);
      
      // Deallocate some
      dealloc_res_en <= 1'b1;
      dealloc_cu_id <= 2'h0;
      dealloc_wf_slot_id <= 4'h0;
      @(posedge clk);
      dealloc_res_en <= 1'b0;
      @(posedge res_table_done);
      @(posedge clk);

      dealloc_res_en <= 1'b1;
      dealloc_cu_id <= 2'h0;
      dealloc_wf_slot_id <= 4'h1;
      @(posedge clk);
      dealloc_res_en <= 1'b0;
      @(posedge res_table_done);
      @(posedge clk);

      dealloc_res_en <= 1'b1;
      dealloc_cu_id <= 2'h0;
      dealloc_wf_slot_id <= 4'h3;
      @(posedge clk);
      dealloc_res_en <= 1'b0;
      @(posedge res_table_done);
      @(posedge clk);
      
      // Allocate some

      // Add control signals to trigger printing stuff
   end
   
endmodule // resource_table_tb
