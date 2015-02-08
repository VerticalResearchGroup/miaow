module cu_simulator (/*AUTOARG*/
   // Outputs
   cu2dispatch_wf_done, cu2dispatch_wf_tag_done,
   // Inputs
   clk, rst, all_wf_dispatched, dispatch2cu_wf_dispatch,
   dispatch2cu_lds_base_dispatch, dispatch2cu_sgpr_base_dispatch,
   dispatch2cu_start_pc_dispatch, dispatch2cu_vgpr_base_dispatch,
   dispatch2cu_wf_size_dispatch, dispatch2cu_wf_tag_dispatch,
   dispatch2cu_wg_wf_count
   ) ;
   parameter CU_ID_WIDTH = 3;
   parameter NUMBER_CU = 8;

   parameter TAG_WIDTH = 15;
   parameter WAVE_ITEM_WIDTH = 6;
   parameter WF_COUNT_WIDTH = 4;
   parameter MEM_ADDR_WIDTH = 32;
   
   parameter MAX_WF = 200;

   input clk, rst;
   
   input 		    all_wf_dispatched;
   
   input [NUMBER_CU-1:0]      dispatch2cu_wf_dispatch;
   input [15:0] 	      dispatch2cu_lds_base_dispatch;
   input [8:0] 		      dispatch2cu_sgpr_base_dispatch;
   input [MEM_ADDR_WIDTH-1:0] dispatch2cu_start_pc_dispatch;
   input [9:0] 		      dispatch2cu_vgpr_base_dispatch;
   input [WAVE_ITEM_WIDTH-1:0] dispatch2cu_wf_size_dispatch;
   input [TAG_WIDTH-1:0]       dispatch2cu_wf_tag_dispatch;
   input [WF_COUNT_WIDTH-1:0]  dispatch2cu_wg_wf_count;
   
   output reg [NUMBER_CU-1:0]     cu2dispatch_wf_done;
   output reg [NUMBER_CU*TAG_WIDTH-1:0] cu2dispatch_wf_tag_done;

   reg [MAX_WF-1:0] 	     running_wf_valid;
   reg [31:0] 		     running_wf_cycle_counter [MAX_WF-1:0];
   reg [14:0] 		     running_tag[MAX_WF-1:0];
   reg [CU_ID_WIDTH-1:0]     running_cu_id[MAX_WF-1:0];
   
   
   // Start wf
   initial begin : START_WF_BLOCK
      integer i;
      integer curr_dispatched;
      running_wf_valid = 0;
      curr_dispatched = 0;
      
      @(posedge clk);
      @(negedge rst);

      @(posedge clk);
      
      forever begin
	 for (i=0; i<NUMBER_CU; i=i+1) begin
	    if(dispatch2cu_wf_dispatch[i])begin
	       running_tag[curr_dispatched] = dispatch2cu_wf_tag_dispatch;
	       running_wf_cycle_counter[curr_dispatched] = {$random} % 500;
	       running_wf_valid[curr_dispatched] = 1'b1;
	       running_cu_id[curr_dispatched] = i;
 	       curr_dispatched = curr_dispatched + 1;
	    end
	 end
	 @(posedge clk);	    
      end
   end // initial begin
   
   // Run wf
   initial begin : RUN_WF_BLOCK
      integer i;

      @(posedge clk);
      @(negedge rst);

      @(posedge clk);

      forever begin
	 for (i=0; i<MAX_WF; i=i+1) begin
	    if(running_wf_valid[i]) begin
	       if(running_wf_cycle_counter[i] != 0) begin
		  running_wf_cycle_counter[i] = running_wf_cycle_counter[i]-1;
	       end
	    end
	 end
	 @(posedge clk);
      end
      
      @(posedge clk);
      
   end // initial begin
   

   // Finish wf
   initial begin : FINISH_WF_BLOCK
      integer i;
      cu2dispatch_wf_done = 0;
      
      @(posedge clk);
      @(negedge rst);

      @(posedge clk);

      while(!all_wf_dispatched ||
	    (|running_wf_valid) ) begin
	 for (i=0; i<MAX_WF; i=i+1) begin
	    if(running_wf_valid[i] &&
	       running_wf_cycle_counter[i]==0) begin
	       // Do not finish two wf on the same cycle in the same cu
	       if(!cu2dispatch_wf_done[running_cu_id[i]]) begin
		  cu2dispatch_wf_done[running_cu_id[i]] = 1'b1;
		  cu2dispatch_wf_tag_done[running_cu_id[i]*15+:15]
		    = running_tag[i];
		  running_wf_valid[i] = 1'b0;
	       end
	       
	       @(posedge clk);
	       cu2dispatch_wf_done = 0;
	    end // if (running_wf_valid[i] &&...
	 end // for (i=0; i<MAX_WF; i=i+1)
	 @(posedge clk);
      end // while (!all_wf_dispatched ||...
      

      repeat(100) @(posedge clk);
      $stop;
      
   end // initial begin
   
endmodule // cu_simulator
