// add check for wg out of inflight wg buffer
module host_test (/*AUTOARG*/
   // Outputs
   host_wg_valid, host_wg_id, host_num_wf, host_vgpr_size_per_wf,
   host_vgpr_size_total, host_sgpr_size_per_wf, host_sgpr_size_total,
   host_lds_size_total, host_gds_size_total, host_wf_size,
   host_start_pc, all_wf_dispatched,
   // Inputs
   rst, clk, inflight_wg_buffer_host_rcvd_ack
   ) ;

   input			rst, clk;
   input 			inflight_wg_buffer_host_rcvd_ack;

   parameter WG_ID_WIDTH = 6;
   parameter WG_SLOT_ID_WIDTH = 6;
   parameter CU_ID_WIDTH = 2;
   parameter WAVE_ITEM_WIDTH = 6;
   parameter WF_COUNT_WIDTH = 4;
   localparam MAX_WF_PER_WG = 2**WF_COUNT_WIDTH;
   
   parameter MEM_ADDR_WIDTH = 32;
   
   parameter VGPR_ID_WIDTH = 8;
   parameter NUMBER_VGPR_SLOTS = 256;
   parameter SGPR_ID_WIDTH = 4;
   parameter NUMBER_SGPR_SLOTS = 13;
   parameter LDS_ID_WIDTH = 8;
   parameter NUMBER_LDS_SLOTS = 256;
   parameter GDS_ID_WIDTH = 14;
   parameter GDS_SIZE = 16384;
   
   output reg 			host_wg_valid;
   output reg [WG_ID_WIDTH-1:0]    host_wg_id;
   output reg [WF_COUNT_WIDTH-1:0] host_num_wf;
   output reg [VGPR_ID_WIDTH:0]    host_vgpr_size_per_wf;
   output reg [VGPR_ID_WIDTH:0]    host_vgpr_size_total;
   output reg [SGPR_ID_WIDTH:0]    host_sgpr_size_per_wf;
   output reg [SGPR_ID_WIDTH:0]    host_sgpr_size_total;
   output reg [LDS_ID_WIDTH:0] 	   host_lds_size_total;
   output reg [GDS_ID_WIDTH:0] 	   host_gds_size_total;
   output reg [WAVE_ITEM_WIDTH-1:0] 		   host_wf_size;
   output reg [MEM_ADDR_WIDTH-1:0] host_start_pc;

   output reg 			   all_wf_dispatched;
   
   localparam NUM_ADDED_WG = 10;
   reg [WG_ID_WIDTH-1:0]  sim_host_wg_id[NUM_ADDED_WG-1:0];

   reg [WAVE_ITEM_WIDTH-1:0]  sim_host_wf_size[NUM_ADDED_WG-1:0];
   
   reg [WF_COUNT_WIDTH-1:0] sim_host_num_wf[NUM_ADDED_WG-1:0];

   
   reg [VGPR_ID_WIDTH:0]  sim_host_vgpr_size_per_wf[NUM_ADDED_WG-1:0];
   reg [VGPR_ID_WIDTH:0]  sim_host_vgpr_size_total[NUM_ADDED_WG-1:0];
   
   reg [SGPR_ID_WIDTH:0]  sim_host_sgpr_size_per_wf[NUM_ADDED_WG-1:0];
			    
   reg [SGPR_ID_WIDTH:0]  sim_host_sgpr_size_total[NUM_ADDED_WG-1:0];
   
   reg [LDS_ID_WIDTH:0]   sim_host_lds_size_total[NUM_ADDED_WG-1:0];
   
   
   reg [GDS_ID_WIDTH:0]  sim_host_gds_size_total[NUM_ADDED_WG-1:0];

   reg [MEM_ADDR_WIDTH-1:0] sim_host_start_pc[NUM_ADDED_WG-1:0];

   reg [NUM_ADDED_WG-1:0] sim_wg_accepted
     = '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};

   reg [NUM_ADDED_WG-1:0] sim_wg_issued
     = '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };

   reg [NUM_ADDED_WG-1:0] sim_wg_ended 
     = '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };
   
   integer 		   host_curr_wg;

     

   initial begin : INITIALIZE_VALUES
      integer currInit;
      for (currInit = 0; currInit < NUM_ADDED_WG; currInit=currInit+1) begin
         sim_host_wg_id[currInit] = currInit;
         sim_host_wf_size[currInit] = ({$random}%(2**WAVE_ITEM_WIDTH)) + 1;
         sim_host_num_wf[currInit] = ({$random}%(MAX_WF_PER_WG-1))+1;
         sim_host_vgpr_size_per_wf[currInit] 
           = {$random}%(NUMBER_VGPR_SLOTS/sim_host_num_wf[currInit]);
         sim_host_vgpr_size_total[currInit] 
           = sim_host_vgpr_size_per_wf[currInit]*sim_host_num_wf[currInit];

         sim_host_sgpr_size_per_wf[currInit] 
           = {$random}%(NUMBER_SGPR_SLOTS/sim_host_num_wf[currInit]);
         sim_host_sgpr_size_total[currInit] 
           = sim_host_sgpr_size_per_wf[currInit]*sim_host_num_wf[currInit];

         sim_host_lds_size_total[currInit] 
           = {$random}%NUMBER_LDS_SLOTS;
         sim_host_gds_size_total[currInit]
           = {$random}%(GDS_SIZE/50);

         sim_host_start_pc[currInit] = {$random};
      end
   end
   
   task host_new_wf;
      input [WG_ID_WIDTH-1:0] wg_id;		
      input [WF_COUNT_WIDTH-1:0] num_wf;	
      input [WAVE_ITEM_WIDTH-1:0] wf_size;		
      input [VGPR_ID_WIDTH:0] 	  vgpr_size_total;	
      input [VGPR_ID_WIDTH:0] 	  vgpr_size_per_wf;	
      input [SGPR_ID_WIDTH:0] 	  sgpr_size_total;	
      input [SGPR_ID_WIDTH:0] 	  sgpr_size_per_wf;	
      input [LDS_ID_WIDTH:0] 	  lds_size_total;	
      input [GDS_ID_WIDTH:0] 	  gds_size_total;	
      input [MEM_ADDR_WIDTH-1:0]  start_pc;
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
	 host_start_pc = start_pc;
	 
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
      all_wf_dispatched = 1'b0;
      
      @(posedge clk);
      @(negedge rst);

      @(posedge clk);

      for (host_curr_wg = 0; host_curr_wg<NUM_ADDED_WG; 
	   host_curr_wg = host_curr_wg + 1) begin
	 host_new_wf(sim_host_wg_id[host_curr_wg], sim_host_num_wf[host_curr_wg], 
		     sim_host_wf_size[host_curr_wg],
		     sim_host_vgpr_size_total[host_curr_wg], 
		     sim_host_vgpr_size_per_wf[host_curr_wg],
		     sim_host_sgpr_size_total[host_curr_wg], 
		     sim_host_sgpr_size_per_wf[host_curr_wg],
		     sim_host_lds_size_total[host_curr_wg], 
		     sim_host_gds_size_total[host_curr_wg],
		     sim_host_start_pc[host_curr_wg]);
	 @(posedge clk);
      end

      @(posedge clk);
      @(posedge clk);
      all_wf_dispatched = 1'b1;
      
   end
   
endmodule // host_test
