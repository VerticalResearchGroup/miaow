// Local Variables:
// verilog-library-directories:("." "../../../")
// End:
module inflight_wg_buffer_tb
  (/*AUTOARG*/);

   localparam WG_ID_WIDTH = 6;
   localparam WG_SLOT_ID_WIDTH = 6;
   localparam CU_ID_WIDTH = 2;
   
   localparam VGPR_ID_WIDTH = 8;
   localparam SGPR_ID_WIDTH = 8;
   
   localparam  LDS_ID_WIDTH = 8;
   localparam GDS_ID_WIDTH = 8;
   localparam ENTRY_ADDR_WIDTH = 3;
   localparam NUMBER_ENTRIES = 8;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			inflight_wg_buffer_alloc_available;// From DUT_IWB of inflight_wg_buffer.v
   wire [GDS_ID_WIDTH:0] inflight_wg_buffer_alloc_gds_size;// From DUT_IWB of inflight_wg_buffer.v
   wire [LDS_ID_WIDTH:0] inflight_wg_buffer_alloc_lds_size;// From DUT_IWB of inflight_wg_buffer.v
   wire [WG_ID_WIDTH-1:0] inflight_wg_buffer_alloc_num_wf;// From DUT_IWB of inflight_wg_buffer.v
   wire [SGPR_ID_WIDTH:0] inflight_wg_buffer_alloc_sgpr_size;// From DUT_IWB of inflight_wg_buffer.v
   wire			inflight_wg_buffer_alloc_valid;// From DUT_IWB of inflight_wg_buffer.v
   wire [VGPR_ID_WIDTH:0] inflight_wg_buffer_alloc_vgpr_size;// From DUT_IWB of inflight_wg_buffer.v
   wire [WG_ID_WIDTH-1:0] inflight_wg_buffer_alloc_wg_id;// From DUT_IWB of inflight_wg_buffer.v
   wire [SGPR_ID_WIDTH:0] inflight_wg_buffer_gpu_sgpr_size_per_wf;// From DUT_IWB of inflight_wg_buffer.v
   wire			inflight_wg_buffer_gpu_valid;// From DUT_IWB of inflight_wg_buffer.v
   wire [VGPR_ID_WIDTH:0] inflight_wg_buffer_gpu_vgpr_size_per_wf;// From DUT_IWB of inflight_wg_buffer.v
   wire [5:0]		inflight_wg_buffer_gpu_wf_size;// From DUT_IWB of inflight_wg_buffer.v
   wire			inflight_wg_buffer_host_rcvd_ack;// From DUT_IWB of inflight_wg_buffer.v
   wire			inflight_wg_buffer_host_wf_done;// From DUT_IWB of inflight_wg_buffer.v
   wire [WG_ID_WIDTH-1:0] inflight_wg_buffer_host_wf_done_wg_id;// From DUT_IWB of inflight_wg_buffer.v
   // End of automatics

   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg [WG_ID_WIDTH-1:0] allocator_wg_id_out;	// To DUT_IWB of inflight_wg_buffer.v
   reg			clk;			// To DUT_IWB of inflight_wg_buffer.v
   reg			dis_controller_start_alloc;// To DUT_IWB of inflight_wg_buffer.v
   reg			dis_controller_wg_alloc_valid;// To DUT_IWB of inflight_wg_buffer.v
   reg			dis_controller_wg_dealloc_valid;// To DUT_IWB of inflight_wg_buffer.v
   reg			dis_controller_wg_rejected_valid;// To DUT_IWB of inflight_wg_buffer.v
   reg [WG_ID_WIDTH-1:0] gpu_interface_dealloc_wg_id;	// To DUT_IWB of inflight_wg_buffer.v
   reg [GDS_ID_WIDTH:0]	host_gds_size_total;	// To DUT_IWB of inflight_wg_buffer.v
   reg [LDS_ID_WIDTH:0]	host_lds_size_total;	// To DUT_IWB of inflight_wg_buffer.v
   reg [WG_SLOT_ID_WIDTH:0] host_num_wf;	// To DUT_IWB of inflight_wg_buffer.v
   reg [SGPR_ID_WIDTH:0] host_sgpr_size_per_wf;	// To DUT_IWB of inflight_wg_buffer.v
   reg [SGPR_ID_WIDTH:0] host_sgpr_size_total;	// To DUT_IWB of inflight_wg_buffer.v
   reg [VGPR_ID_WIDTH:0] host_vgpr_size_per_wf;	// To DUT_IWB of inflight_wg_buffer.v
   reg [VGPR_ID_WIDTH:0] host_vgpr_size_total;	// To DUT_IWB of inflight_wg_buffer.v
   reg [5:0]		host_wf_size;		// To DUT_IWB of inflight_wg_buffer.v
   reg [WG_ID_WIDTH-1:0] host_wg_id;		// To DUT_IWB of inflight_wg_buffer.v
   reg			host_wg_valid;		// To DUT_IWB of inflight_wg_buffer.v
   reg			rst;			// To DUT_IWB of inflight_wg_buffer.v
   // End of automatics


   inflight_wg_buffer
     #(/*AUTOINSTPARAM*/
       // Parameters
       .WG_ID_WIDTH			(WG_ID_WIDTH),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .CU_ID_WIDTH			(CU_ID_WIDTH),
       .VGPR_ID_WIDTH			(VGPR_ID_WIDTH),
       .SGPR_ID_WIDTH			(SGPR_ID_WIDTH),
       .LDS_ID_WIDTH			(LDS_ID_WIDTH),
       .GDS_ID_WIDTH			(GDS_ID_WIDTH),
       .ENTRY_ADDR_WIDTH		(ENTRY_ADDR_WIDTH),
       .NUMBER_ENTRIES			(NUMBER_ENTRIES))
   DUT_IWB
     (/*AUTOINST*/
      // Outputs
      .inflight_wg_buffer_host_rcvd_ack	(inflight_wg_buffer_host_rcvd_ack),
      .inflight_wg_buffer_host_wf_done	(inflight_wg_buffer_host_wf_done),
      .inflight_wg_buffer_host_wf_done_wg_id(inflight_wg_buffer_host_wf_done_wg_id[WG_ID_WIDTH-1:0]),
      .inflight_wg_buffer_alloc_valid	(inflight_wg_buffer_alloc_valid),
      .inflight_wg_buffer_alloc_available(inflight_wg_buffer_alloc_available),
      .inflight_wg_buffer_alloc_wg_id	(inflight_wg_buffer_alloc_wg_id[WG_ID_WIDTH-1:0]),
      .inflight_wg_buffer_alloc_num_wf	(inflight_wg_buffer_alloc_num_wf[WG_ID_WIDTH-1:0]),
      .inflight_wg_buffer_alloc_vgpr_size(inflight_wg_buffer_alloc_vgpr_size[VGPR_ID_WIDTH:0]),
      .inflight_wg_buffer_alloc_sgpr_size(inflight_wg_buffer_alloc_sgpr_size[SGPR_ID_WIDTH:0]),
      .inflight_wg_buffer_alloc_lds_size(inflight_wg_buffer_alloc_lds_size[LDS_ID_WIDTH:0]),
      .inflight_wg_buffer_alloc_gds_size(inflight_wg_buffer_alloc_gds_size[GDS_ID_WIDTH:0]),
      .inflight_wg_buffer_gpu_valid	(inflight_wg_buffer_gpu_valid),
      .inflight_wg_buffer_gpu_vgpr_size_per_wf(inflight_wg_buffer_gpu_vgpr_size_per_wf[VGPR_ID_WIDTH:0]),
      .inflight_wg_buffer_gpu_sgpr_size_per_wf(inflight_wg_buffer_gpu_sgpr_size_per_wf[SGPR_ID_WIDTH:0]),
      .inflight_wg_buffer_gpu_wf_size	(inflight_wg_buffer_gpu_wf_size[5:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .host_wg_valid			(host_wg_valid),
      .host_wg_id			(host_wg_id[WG_ID_WIDTH-1:0]),
      .host_num_wf			(host_num_wf[WG_SLOT_ID_WIDTH:0]),
      .host_wf_size			(host_wf_size[5:0]),
      .host_vgpr_size_total		(host_vgpr_size_total[VGPR_ID_WIDTH:0]),
      .host_sgpr_size_total		(host_sgpr_size_total[SGPR_ID_WIDTH:0]),
      .host_lds_size_total		(host_lds_size_total[LDS_ID_WIDTH:0]),
      .host_gds_size_total		(host_gds_size_total[GDS_ID_WIDTH:0]),
      .host_vgpr_size_per_wf		(host_vgpr_size_per_wf[VGPR_ID_WIDTH:0]),
      .host_sgpr_size_per_wf		(host_sgpr_size_per_wf[SGPR_ID_WIDTH:0]),
      .dis_controller_start_alloc	(dis_controller_start_alloc),
      .dis_controller_wg_alloc_valid	(dis_controller_wg_alloc_valid),
      .dis_controller_wg_dealloc_valid	(dis_controller_wg_dealloc_valid),
      .dis_controller_wg_rejected_valid	(dis_controller_wg_rejected_valid),
      .allocator_wg_id_out		(allocator_wg_id_out[WG_ID_WIDTH-1:0]),
      .gpu_interface_dealloc_wg_id		(gpu_interface_dealloc_wg_id[WG_ID_WIDTH-1:0]));   


   localparam NUM_ADDED_WG = 10;
   localparam [WG_ID_WIDTH-1:0]  sim_host_wg_id[NUM_ADDED_WG-1:0] 
     = '{ 6'd0, 6'd1, 6'd2, 6'd3, 6'd4, 6'd5, 6'd6, 6'd7, 6'd8, 6'd9 };

   localparam [5:0]  sim_host_wf_size[NUM_ADDED_WG-1:0] 
     = '{ 6'd54, 6'd55, 6'd56, 6'd57, 6'd58, 6'd59, 6'd60, 6'd61, 6'd62, 6'd63 };
   
   localparam [WG_SLOT_ID_WIDTH:0] sim_host_num_wf[NUM_ADDED_WG-1:0] 
     = '{ 6'd2,6'd 4,6'd 6,6'd 8, 6'd10, 6'd12, 6'd14, 6'd16, 6'd18, 6'd20};

   
   localparam [VGPR_ID_WIDTH:0]  sim_host_vgpr_size_per_wf[NUM_ADDED_WG-1:0] 
     = '{  9'd2, 9'd4, 9'd6, 9'd8, 9'd10, 9'd2, 9'd4, 9'd6, 9'd8, 9'd10 };
   localparam [VGPR_ID_WIDTH:0]  sim_host_vgpr_size_total[NUM_ADDED_WG-1:0] 
     = '{ 9'd4, 9'd16, 9'd36, 9'd72, 9'd100, 9'd4, 9'd16, 9'd36, 9'd72, 9'd100 };
   
   localparam [SGPR_ID_WIDTH:0]  sim_host_sgpr_size_per_wf[NUM_ADDED_WG-1:0] 
     = '{ 9'd1, 9'd3, 9'd5, 9'd7, 9'd9, 9'd1, 9'd3, 9'd5, 9'd7, 9'd9 };
			    
   localparam [SGPR_ID_WIDTH:0]  sim_host_sgpr_size_total[NUM_ADDED_WG-1:0] 
     = '{ 9'd2, 9'd12, 9'd30, 9'd56, 9'd90, 9'd2, 9'd12, 9'd30, 9'd56, 9'd90 };
   
   localparam [LDS_ID_WIDTH:0]   sim_host_lds_size_total[NUM_ADDED_WG-1:0] 
     = '{ 9'd10, 9'd20, 9'd30, 9'd40, 9'd50, 9'd60, 9'd70, 9'd80, 9'd90, 9'd100 };
   
   
   localparam [GDS_ID_WIDTH:0]  sim_host_gds_size_total[NUM_ADDED_WG-1:0] 
     = '{ 9'd5, 9'd10, 9'd15, 9'd20, 9'd25, 9'd30, 9'd35, 9'd40, 9'd45, 9'd50 };

   reg [NUM_ADDED_WG-1:0] sim_wg_accepted
     = '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};

   reg [NUM_ADDED_WG-1:0] sim_wg_issued
     = '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };

   reg [NUM_ADDED_WG-1:0] sim_wg_ended 
     = '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };
   
   integer 		   host_curr_wg;
   integer 		   curr_alloc_wg;
   integer 		   curr_end_wg;

   localparam MAX_RUNNING_WG = 5;
   
   reg [WG_ID_WIDTH-1:0]   running_wg_id[MAX_RUNNING_WG-1:0];
   reg 			   running_wg_valid[MAX_RUNNING_WG-1:0];
   
     
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


   task gpu_end_execution;
      input [WG_ID_WIDTH-1:0] wg_id;
      
      begin
	 dis_controller_wg_dealloc_valid = 1'b1;
	 gpu_interface_dealloc_wg_id = wg_id;
	 @(posedge clk);
	 dis_controller_wg_dealloc_valid = 1'b0;
      end
   endtask //

   // End execution of wf
   initial begin
      dis_controller_wg_dealloc_valid = 1'b0;
      @(posedge clk);
      @(negedge rst);

      @(posedge clk);

      while(!(&sim_wg_ended)) begin
	 for(curr_end_wg = 0; curr_end_wg < NUM_ADDED_WG; curr_end_wg = curr_end_wg + 1) begin
	    if(sim_wg_issued[curr_end_wg] && !sim_wg_ended[curr_end_wg]) begin
	       repeat({$random} % 100 + 100) @(posedge clk);
	       gpu_end_execution(sim_host_wg_id[curr_end_wg]);
	       @(posedge clk);
	       sim_wg_ended[curr_end_wg] = 1'b1;
	    end
	 end
	 @(posedge clk);
      end // while (!(&sim_wg_ended))

      repeat(200) @(posedge clk);
      $stop;
   end // initial begin
   
   
   task dis_controller_start_wg;
      input accepted;
      reg [WG_ID_WIDTH-1:0] wg_id;
      begin

	 while(!inflight_wg_buffer_alloc_valid) @(posedge clk);
	 
	 dis_controller_start_alloc = 1'b1;
	 wg_id = inflight_wg_buffer_alloc_wg_id;
	 allocator_wg_id_out = inflight_wg_buffer_alloc_wg_id;
	@(posedge clk);
	 dis_controller_start_alloc = 1'b0;
	 repeat(4) @(posedge clk);

	 while (!inflight_wg_buffer_alloc_available) @(posedge clk);	 
	 if(!accepted) begin
	    dis_controller_wg_rejected_valid = 1'b1;
	    @(posedge clk);
	    dis_controller_wg_rejected_valid = 1'b0;
	 end
	 else begin
	    // First controller starts the wg id
	    dis_controller_wg_alloc_valid = 1'b1;
	    @(posedge clk);
	    dis_controller_wg_alloc_valid = 1'b0;	    
	    while(!inflight_wg_buffer_gpu_valid) @(posedge clk);
	    
	    @(posedge clk);	    
	 end

	 
      end
   endtask //

   
   // Start wg block
   initial begin : START_WG_BLOCK
      reg[31:0] curr_accepted;
      
      dis_controller_start_alloc = 1'b0;
      dis_controller_wg_rejected_valid = 1'b0;
      dis_controller_wg_alloc_valid = 1'b0;
      @(posedge clk);
      @(negedge rst);

      @(posedge clk);

      while(!(&sim_wg_accepted)) begin
	 for(curr_alloc_wg = 0; curr_alloc_wg < NUM_ADDED_WG; curr_alloc_wg = curr_alloc_wg + 1) begin
	    if(!sim_wg_accepted[curr_alloc_wg]) begin
	       curr_accepted = {$random}%100;
	       dis_controller_start_wg(curr_accepted[0]);
	       sim_wg_accepted[curr_alloc_wg] = curr_accepted[0];
	       repeat({$random} % 50) @(posedge clk);
	       sim_wg_issued[curr_alloc_wg] = curr_accepted[0];
	    end
	 end
	 @(posedge clk);
      end // while (!&sim_wg_accepted)
   end // initial begin
   
   
   task host_new_wf;
      input [WG_ID_WIDTH-1:0] wg_id;		
      input [WG_SLOT_ID_WIDTH:0] num_wf;	
      input [5:0] 	    wf_size;		
      input [VGPR_ID_WIDTH:0] vgpr_size_total;	
      input [VGPR_ID_WIDTH:0] vgpr_size_per_wf;	
      input [SGPR_ID_WIDTH:0] sgpr_size_total;	
      input [SGPR_ID_WIDTH:0] sgpr_size_per_wf;	
      input [LDS_ID_WIDTH:0] lds_size_total;	
      input [GDS_ID_WIDTH:0] gds_size_total;	
      
      begin
	 host_wg_valid = 1'b1;
	 host_wg_id = wg_id;
	 host_num_wf = num_wf;
	 host_wf_size = wf_size;
	 host_gds_size_total = gds_size_total;
	 host_lds_size_total= lds_size_total;
	 host_sgpr_size_per_wf = sgpr_size_per_wf;
	 host_sgpr_size_total = sgpr_size_total;
	 host_vgpr_size_per_wf = vgpr_size_per_wf;
	 host_vgpr_size_total = vgpr_size_total;
	 @(posedge clk);
	 while(!inflight_wg_buffer_host_rcvd_ack) @(posedge clk);
	 @(posedge clk);
	 host_wg_valid = 1'b0;
      end
   endtask //
   
   // Host block
   initial begin
      host_curr_wg = 0;
      host_wg_valid = 1'b0;
     
      @(posedge clk);
      @(negedge rst);

      @(posedge clk);

      for (host_curr_wg = 0; host_curr_wg<NUM_ADDED_WG; host_curr_wg = host_curr_wg + 1) begin
	 host_new_wf(sim_host_wg_id[host_curr_wg], sim_host_num_wf[host_curr_wg], 
		     sim_host_wf_size[host_curr_wg],
		     sim_host_vgpr_size_total[host_curr_wg], sim_host_vgpr_size_per_wf[host_curr_wg],
		     sim_host_sgpr_size_total[host_curr_wg], sim_host_sgpr_size_per_wf[host_curr_wg],
		     sim_host_lds_size_total[host_curr_wg], sim_host_gds_size_total[host_curr_wg]);
	 @(posedge clk);
      end
      
   end
   
   
endmodule
