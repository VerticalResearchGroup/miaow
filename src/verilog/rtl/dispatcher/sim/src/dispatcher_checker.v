module dispatcher_checker (/*AUTOARG*/
                           // Inputs
                           clk, rst, inflight_wg_buffer_host_rcvd_ack, host_wg_id,
                           host_num_wf, host_wf_size, host_vgpr_size_total,
                           host_sgpr_size_total, host_lds_size_total, host_gds_size_total,
                           host_vgpr_size_per_wf, host_sgpr_size_per_wf, host_start_pc,
                           alloc_valid, inflight_buffer_valid, cu_id, wg_id, wf_count,
                           vgpr_start, vgpr_size_per_wf, sgpr_start, sgpr_size_per_wf,
                           lds_start, gds_start, wf_size, start_pc, dispatch2cu_wf_dispatch,
                           dispatch2cu_lds_base_dispatch, dispatch2cu_sgpr_base_dispatch,
                           dispatch2cu_start_pc_dispatch, dispatch2cu_vgpr_base_dispatch,
                           dispatch2cu_wf_size_dispatch, dispatch2cu_wf_tag_dispatch,
                           dispatch2cu_wg_wf_count, cu2dispatch_wf_done,
                           cu2dispatch_wf_tag_done
                           ) ;

   // Checks if given wg matche dispatched ones
   // Does not check any resource allocation data
   
   parameter WG_ID_WIDTH = 15;
   
   parameter WF_COUNT_WIDTH = 4;

   parameter WG_SLOT_ID_WIDTH = 6;
   parameter NUMBER_WF_SLOTS = 40;

   parameter CU_ID_WIDTH = 3;
   parameter NUMBER_CU = 8;

   parameter VGPR_ID_WIDTH = 8;
   parameter NUMBER_VGPR_SLOTS = 256;
   parameter SGPR_ID_WIDTH = 4;
   parameter NUMBER_SGPR_SLOTS = 13;
   parameter LDS_ID_WIDTH = 8;
   parameter NUMBER_LDS_SLOTS = 256;
   parameter GDS_ID_WIDTH = 14;
   parameter GDS_SIZE = 16384;

   parameter CU_VGPR_ID_WIDTH = 10;
   parameter CU_SGPR_ID_WIDTH = 9;
   parameter CU_LDS_ID_WIDTH = 16;
   parameter CU_GDS_ID_WIDTH = 16;
   
   parameter MEM_ADDR_WIDTH = 32;

   parameter WAVE_ITEM_WIDTH = 6;
   
   parameter TAG_WIDTH = 15;

   parameter MAX_WF = 200;

   input clk, rst;
   
   // Add HOST data

   input inflight_wg_buffer_host_rcvd_ack;
   input [WG_ID_WIDTH-1:0] host_wg_id;
   input [WF_COUNT_WIDTH-1:0] host_num_wf;
   input [WAVE_ITEM_WIDTH-1:0] host_wf_size; // number of work itens in the last wf
   input [VGPR_ID_WIDTH :0]    host_vgpr_size_total;
   input [SGPR_ID_WIDTH :0]    host_sgpr_size_total;
   input [LDS_ID_WIDTH :0]     host_lds_size_total;
   input [GDS_ID_WIDTH :0]     host_gds_size_total;
   input [VGPR_ID_WIDTH :0]    host_vgpr_size_per_wf;
   input [SGPR_ID_WIDTH :0]    host_sgpr_size_per_wf;
   input [MEM_ADDR_WIDTH-1:0]  host_start_pc;   

   
   input                       alloc_valid;
   input                       inflight_buffer_valid;
   input [CU_ID_WIDTH-1 :0]    cu_id;
   input [WG_ID_WIDTH-1:0]     wg_id;
   input [WF_COUNT_WIDTH-1:0]  wf_count;
   input [VGPR_ID_WIDTH-1 :0]  vgpr_start;
   input [VGPR_ID_WIDTH :0]    vgpr_size_per_wf;
   input [SGPR_ID_WIDTH-1 :0]  sgpr_start;
   input [SGPR_ID_WIDTH :0]    sgpr_size_per_wf;
   input [LDS_ID_WIDTH-1 :0]   lds_start;
   input [GDS_ID_WIDTH-1 :0]   gds_start;
   input [WAVE_ITEM_WIDTH-1:0] wf_size;
   input [MEM_ADDR_WIDTH-1:0]  start_pc;

   input [NUMBER_CU-1:0]       dispatch2cu_wf_dispatch;
   input [CU_LDS_ID_WIDTH-1:0] dispatch2cu_lds_base_dispatch;
   input [CU_SGPR_ID_WIDTH-1:0] dispatch2cu_sgpr_base_dispatch;
   input [MEM_ADDR_WIDTH-1:0]   dispatch2cu_start_pc_dispatch;
   input [CU_VGPR_ID_WIDTH-1:0] dispatch2cu_vgpr_base_dispatch;
   input [WAVE_ITEM_WIDTH-1:0]  dispatch2cu_wf_size_dispatch;
   input [TAG_WIDTH-1:0]        dispatch2cu_wf_tag_dispatch;
   input [WF_COUNT_WIDTH-1:0]   dispatch2cu_wg_wf_count;

   input [NUMBER_CU-1:0]        cu2dispatch_wf_done;
   input [NUMBER_CU*TAG_WIDTH-1:0] cu2dispatch_wf_tag_done;

   wire [CU_LDS_ID_WIDTH-1:0]      dispatch2cu_lds_base_dispatch_i;
   wire [CU_SGPR_ID_WIDTH-1:0]     dispatch2cu_sgpr_base_dispatch_i;
   wire [CU_VGPR_ID_WIDTH-1:0]     dispatch2cu_vgpr_base_dispatch_i;


   integer                         stored_tag_to_idx[2**TAG_WIDTH-1:0];
   reg [MAX_WF-1:0]                stored_wf_valid, stored_wf_allocated;
   
   reg [CU_ID_WIDTH-1 :0]          stored_cu_id[MAX_WF-1:0];
   reg [WG_ID_WIDTH-1:0]           stored_wg_id[MAX_WF-1:0];
   reg [WF_COUNT_WIDTH-1:0]        stored_wf_count[MAX_WF-1:0];
   reg [VGPR_ID_WIDTH-1 :0]        stored_vgpr_start[MAX_WF-1:0];
   reg [VGPR_ID_WIDTH :0]          stored_vgpr_size_per_wf[MAX_WF-1:0];
   reg [VGPR_ID_WIDTH :0]          stored_vgpr_size_total[MAX_WF-1:0];
   reg [SGPR_ID_WIDTH-1 :0]        stored_sgpr_start[MAX_WF-1:0];
   reg [SGPR_ID_WIDTH :0]          stored_sgpr_size_per_wf[MAX_WF-1:0];
   reg [SGPR_ID_WIDTH :0]          stored_sgpr_size_total[MAX_WF-1:0];
   reg [LDS_ID_WIDTH-1 :0]         stored_lds_start[MAX_WF-1:0];
   reg [LDS_ID_WIDTH :0]           stored_lds_size[MAX_WF-1:0];
   reg [GDS_ID_WIDTH-1 :0]         stored_gds_start[MAX_WF-1:0];
   reg [GDS_ID_WIDTH :0]           stored_gds_size[MAX_WF-1:0];
   reg [WAVE_ITEM_WIDTH-1:0]       stored_wf_size[MAX_WF-1:0];
   reg [MEM_ADDR_WIDTH-1:0]        stored_start_pc[MAX_WF-1:0];

   reg [63:0]                      cycle_counter;
   
   assign dispatch2cu_lds_base_dispatch_i 
     = dispatch2cu_lds_base_dispatch[CU_LDS_ID_WIDTH-1-:LDS_ID_WIDTH];
   assign dispatch2cu_sgpr_base_dispatch_i 
     = dispatch2cu_sgpr_base_dispatch[CU_SGPR_ID_WIDTH-1-:SGPR_ID_WIDTH];
   assign dispatch2cu_vgpr_base_dispatch_i 
     = dispatch2cu_vgpr_base_dispatch[CU_VGPR_ID_WIDTH-1-:VGPR_ID_WIDTH];

   initial begin
      cycle_counter = 0;
      
      forever begin
	     @(posedge clk);
	     cycle_counter = cycle_counter + 1;
      end
      
   end
   
   // Fill table
   initial begin : FILL_TABLE_HOST
      integer 		       curr_alloc;
      curr_alloc = 0;
      stored_wf_valid = 0;
      
      @(posedge clk);
      @(negedge rst);

      @(posedge clk);

      forever begin
	     if(inflight_wg_buffer_host_rcvd_ack) begin
	        stored_wf_valid[curr_alloc] = 1'b1;
	        
	        stored_wg_id[curr_alloc] = host_wg_id;
	        stored_wf_count[curr_alloc] = host_num_wf;
	        stored_vgpr_size_per_wf[curr_alloc] = host_vgpr_size_per_wf;
	        stored_vgpr_size_total[curr_alloc] = host_vgpr_size_total;
	        stored_sgpr_size_per_wf[curr_alloc] = host_sgpr_size_per_wf;
	        stored_sgpr_size_total[curr_alloc] = host_sgpr_size_total;
	        stored_lds_size[curr_alloc] = host_lds_size_total;
	        stored_gds_size[curr_alloc] = host_gds_size_total;
	        stored_start_pc[curr_alloc] = host_start_pc;
	        stored_wf_size[curr_alloc] = host_wf_size;

	        curr_alloc = curr_alloc + 1;
	        
	        // inform that wf with id XX and pc XX was allocated
	        $display("host_passed_wf wg_id:%d starting pc:%h",
		             host_wg_id,host_start_pc);
	        
	     end
	     @(posedge clk);
      end
   end

   function [31:0] get_curr_alloc_per_wg_id;
      input [WG_ID_WIDTH-1:0]     curr_wg_id;
      integer                     i;
      begin
	     for (i=0; i<MAX_WF; i=i+1) begin
	        if(stored_wg_id[i] == curr_wg_id) begin
	           get_curr_alloc_per_wg_id = i;
	        end
	     end
      end
   endfunction // if

   // Res util data: wg, vgpr, sgpr, lds, gds (global)
   reg [VGPR_ID_WIDTH :0]    res_vgpr_free[NUMBER_CU-1:0];
   reg [SGPR_ID_WIDTH :0]    res_sgpr_free[NUMBER_CU-1:0];
   reg [LDS_ID_WIDTH :0]     res_lds_free[NUMBER_CU-1:0];
   reg [GDS_ID_WIDTH :0]     res_gds_free;
   reg [WG_SLOT_ID_WIDTH-1:0] res_wg_slots_free[NUMBER_CU-1:0];

   task init_res;
      integer i;
      
      begin
	     res_gds_free = GDS_SIZE;
	     
	     for (i=0; i<NUMBER_CU; i=i+1) begin
	        res_wg_slots_free[i] = NUMBER_WF_SLOTS;
	        res_vgpr_free[i] = NUMBER_VGPR_SLOTS;
	        res_sgpr_free[i] = NUMBER_SGPR_SLOTS;
	        res_lds_free[i] = NUMBER_LDS_SLOTS;
	     end
      end
   endtask // if

   function check_value;
      input [31:0] expected_value;
      input [31:0] observed_value;
      input [8*64-1:0] check_name;
      input [8*64-1:0] value_name;

      integer 	       i;
      begin
	     for (i=0; i<32; i=i+1) begin
	        if(expected_value[i] === 1'bx) expected_value[i] = 1'b0;
	        if(observed_value[i] === 1'bx) observed_value[i] = 1'b0;
	        
	     end
	     
	     
	     if(expected_value != observed_value) begin
	        $display(" >> Error in %0s\t%0s expected:%0d\tread:%0d @%0d",
		             check_name, value_name, expected_value, observed_value,
		             cycle_counter);
	        check_value = 1'b1;
	     end
	     else begin
	        check_value = 1'b0;
	     end
	     
      end
   endfunction // if

   function check_value_smaller_than;
      input [31:0] expected_value;
      input [31:0] observed_value;
      input [8*64-1:0] check_name;
      input [8*64-1:0] value_name;

      integer 	       i;
      
      begin
	     for (i=0; i<32; i=i+1) begin
	        if(expected_value[i] === 1'bx) expected_value[i] = 1'b0;
	        if(observed_value[i] === 1'bx) observed_value[i] = 1'b0;
	        
	     end
	     
	     if(observed_value > expected_value) begin
	        $display(" >> Error in %0s\t%0s read value:%0d\t higher than expected:%0d @%0d",
		             check_name, value_name, observed_value, expected_value,
		             cycle_counter);
	        check_value_smaller_than = 1'b1;
	     end
	     else begin
	        check_value_smaller_than = 1'b0;
	     end
	     
      end
   endfunction // if
   
   task check_res;
      input [CU_ID_WIDTH-1 :0] 	  alloc_cu_id;
      input integer               curr_alloc;
      
      reg                         res_error;
      
      begin
	     // Check if there are enougth free resources
	     res_error = check_value_smaller_than(res_wg_slots_free[alloc_cu_id],
					                          stored_wf_count[curr_alloc],
					                          "resource_check",
					                          "wf_count");
	     res_error = res_error | 
		             check_value_smaller_than(res_vgpr_free[alloc_cu_id],
					                          stored_vgpr_size_total[curr_alloc],
					                          "resource_check",
					                          "vgpr");
	     
	     res_error = res_error | 
		             check_value_smaller_than(res_sgpr_free[alloc_cu_id],
					                          stored_sgpr_size_total[curr_alloc],
					                          "resource_check",
					                          "sgpr");

	     res_error = res_error | 
		             check_value_smaller_than(res_lds_free[alloc_cu_id],
					                          stored_lds_size[curr_alloc],
					                          "resource_check",
					                          "lds");

	     res_error = res_error | 
		             check_value_smaller_than(res_gds_free,
					                          stored_gds_size[curr_alloc],
					                          "resource_check",
					                          "gds");

	     // Updates resource utilization
	     if(!res_error) begin
	        res_wg_slots_free[alloc_cu_id] = res_wg_slots_free[alloc_cu_id] -
					                         stored_wf_count[curr_alloc];
	        res_vgpr_free[alloc_cu_id] = res_vgpr_free[alloc_cu_id] - 
					                     stored_vgpr_size_total[curr_alloc];
	        res_sgpr_free[alloc_cu_id] = res_sgpr_free[alloc_cu_id] - 
					                     stored_sgpr_size_total[curr_alloc];

	        res_lds_free[alloc_cu_id] = res_lds_free[alloc_cu_id] - 
					                    stored_lds_size[curr_alloc];

	        res_gds_free = res_gds_free - 
			               stored_gds_size[curr_alloc];
	        
	     end
	     else begin
	        $display(" >>> Error: resource overflow in cu %d @%0d" ,
		             alloc_cu_id, cycle_counter);
	     end
	     
      end
   endtask // if

   
   // Check allocation - find wg using wg_id
   // Check if resource utilization is OK
   initial begin : CHECK_ALLOC
      integer 		       curr_alloc;
      reg                  alloc_error;

      alloc_error = 0;
      stored_wf_allocated = 0;
      init_res;
      
      @(posedge clk);
      @(negedge rst);

      @(posedge clk);

      forever begin
	     if(alloc_valid) begin
	        // Account dealocations
	        
	        curr_alloc = get_curr_alloc_per_wg_id(wg_id);
	        stored_wf_allocated[curr_alloc] = 1'b1;

	        
	        stored_cu_id[curr_alloc] = cu_id;
	        stored_vgpr_start[curr_alloc] = vgpr_start;
	        stored_sgpr_start[curr_alloc] = sgpr_start;
	        stored_lds_start[curr_alloc] = lds_start;
	        stored_gds_start[curr_alloc] = gds_start;

	        // 
	        alloc_error = check_value(stored_wf_count[curr_alloc],wf_count,
			                          "allocation","wf_count");
	        while(!inflight_buffer_valid) @(posedge clk);
	        // Check 
	        alloc_error = alloc_error | 
			              check_value(stored_vgpr_size_per_wf[curr_alloc],
				                      vgpr_size_per_wf,
				                      "allocation","vgpr_size_per_wf");
	        alloc_error = alloc_error | 
			              check_value(stored_sgpr_size_per_wf[curr_alloc],
				                      sgpr_size_per_wf,
				                      "allocation","sgpr_size_per_wf");
	        alloc_error = alloc_error | 
			              check_value(stored_start_pc[curr_alloc],start_pc,
				                      "allocation","start_pc");
	        alloc_error = alloc_error | 
			              check_value(stored_wf_size[curr_alloc],wf_size,
				                      "allocation","wf_size");
	        
	        // Check resource utilization in CU
	        check_res(stored_cu_id[curr_alloc], curr_alloc);
	        
	        // inform that wf with id XX and pc XX was allocated
	        if(!alloc_error) begin
	           $display("allocated wg_id:%d to cu_id:%d starting pc:%h",
			            wg_id,cu_id,start_pc);
	        end
	        else begin
	           $display(" >>> Error allocating wg_id:%d to cu_id:%d starting pc:%h @%0d",
			            wg_id,cu_id,start_pc,cycle_counter);
	        end
	        
	     end
	     @(posedge clk);
      end
   end

   task get_dispatched_cu_id;
      output 			task_one_wf_dispatching;
      output 			task_multiple_wf_dispaching;
      output [CU_ID_WIDTH-1 :0] task_dispatching_cu_id;
      integer                   i;
      
      begin
	     task_one_wf_dispatching = 1'b0;
	     task_multiple_wf_dispaching = 1'b0;
	     task_dispatching_cu_id = 0;
	     
	     for(i = 0; i<NUMBER_CU; i = i+1) begin
	        if(dispatch2cu_wf_dispatch[i]) begin
	           if(task_one_wf_dispatching) begin
		          task_multiple_wf_dispaching = 1'b1;
	           end
	           task_one_wf_dispatching = 1'b1;
	           task_dispatching_cu_id = i;
	        end
	     end

	     if(task_multiple_wf_dispaching) begin
	        task_one_wf_dispatching = 1'b0;
	     end
	     
      end
   endtask // for
   
   // Check dispatches - identify wf by pc
   initial begin : CHECK_DISPATCHES
      integer i;
      integer curr_wf;
      reg [CU_ID_WIDTH-1 :0] curr_cu_id;

      reg                    multiple_wf_dispaching;
      reg                    one_wf_dispatching;
      reg                    error_wf;
      reg                    end_wg;
      
      reg [VGPR_ID_WIDTH-1 :0] next_start_vgpr;
      reg [SGPR_ID_WIDTH-1 :0] next_start_sgpr;
      
      reg [CU_ID_WIDTH-1 :0]   dispatching_cu_id;
      
      reg                      found_wf_valid;
      integer                  found_wf_idx;
      reg [CU_ID_WIDTH-1 :0]   found_cu_id;
      
      reg [WF_COUNT_WIDTH-1:0] curr_dispatched_wf;
      
      @(posedge clk);
      @(negedge rst);

      @(posedge clk);

      forever begin
	     // Check if it is dispatching 2 wf and get the cu_id
	     one_wf_dispatching = 1'b0;
	     multiple_wf_dispaching = 1'b0;

	     get_dispatched_cu_id(one_wf_dispatching, multiple_wf_dispaching,
			                  dispatching_cu_id);

	     if(multiple_wf_dispaching) begin
	        $display(">>> Error: multiple wf dispatching @%0d", cycle_counter);
	     end
	     

	     if(one_wf_dispatching) begin
	        // Get the idx of the dispatched wg
	        for(curr_wf=0; curr_wf < MAX_WF; curr_wf = curr_wf +1) begin
	           if(stored_wf_allocated[curr_wf] &&
		          stored_start_pc[curr_wf] == dispatch2cu_start_pc_dispatch) begin
		          found_wf_valid = 1'b1;
		          found_wf_idx =  curr_wf;
		          
	           end
	        end

	        if(found_wf_valid) begin
	           // Inform user of dispatched wg
	           $display(">>> dispatch: start_pc:%h\tcu_id:%d\ttag:%d",
			            stored_start_pc[found_wf_idx], dispatching_cu_id,
			            dispatch2cu_wf_tag_dispatch);
	           curr_dispatched_wf = 0;
	           stored_tag_to_idx[dispatch2cu_wf_tag_dispatch] = found_wf_idx;
	           
	           next_start_vgpr = stored_vgpr_start[found_wf_idx];
	           next_start_sgpr = stored_sgpr_start[found_wf_idx];
	           
	           // Wait for each dispatch and inform user of any errors
	           end_wg = 1'b0;
	           while(!end_wg) begin
		          get_dispatched_cu_id(one_wf_dispatching, multiple_wf_dispaching,
				                       dispatching_cu_id);

		          error_wf = 1'b0;
		          if(one_wf_dispatching) begin
		             // Check pc, cu_id, starts, 
		             // get next wf if everything is ok
		             if(stored_cu_id[found_wf_idx] != dispatching_cu_id) begin
			            error_wf = 1'b1;
			            $display(">>> Error: expected cu:%d\tfound cu:%d @%0d",
				                 stored_cu_id[found_wf_idx],
				                 dispatching_cu_id,
				                 cycle_counter);
		             end

		             if(stored_start_pc[found_wf_idx] != 
			            dispatch2cu_start_pc_dispatch) begin
			            error_wf = 1'b1;
			            $display(">>> Error: expected pc:%d\tfound pc:%d @%0d",
				                 stored_start_pc[found_wf_idx],
				                 dispatch2cu_start_pc_dispatch,
				                 cycle_counter);
			            
		             end
		             
		             if(stored_wf_count[found_wf_idx] <= 
			            curr_dispatched_wf) begin
			            error_wf = 1'b1;
			            $display(">>> Error: dispatched too many wf @%0d",
				                 cycle_counter);
		             end

		             if(next_start_vgpr != 
			            dispatch2cu_vgpr_base_dispatch_i) begin
			            error_wf = 1'b1;
			            $display(">>> Error: expected vgpr_start:%d\tfound vgpr_start:%d @%0d",
				                 next_start_vgpr,
				                 dispatch2cu_vgpr_base_dispatch_i,
				                 cycle_counter);
			            
		             end

		             if(next_start_sgpr != 
			            dispatch2cu_sgpr_base_dispatch_i) begin
			            error_wf = 1'b1;
			            $display(">>> Error: expected sgpr_start:%d\tfound sgpr_start:%d @%0d",
				                 next_start_sgpr,
				                 dispatch2cu_sgpr_base_dispatch_i,cycle_counter);
			            
		             end

		             if(stored_lds_start[found_wf_idx] != 
			            dispatch2cu_lds_base_dispatch_i) begin
			            error_wf = 1'b1;
			            $display(">>> Error: expected lds_start:%d\tfound lds_start:%d @%0d",
				                 stored_lds_start[found_wf_idx],
				                 dispatch2cu_lds_base_dispatch_i,
				                 cycle_counter);
			            
		             end

		             if(stored_wf_size[found_wf_idx] != 
			            dispatch2cu_wf_size_dispatch) begin
			            error_wf = 1'b1;
			            $display(">>> Error: expected wf_size:%d\tfound wf_size:%d @%0d",
				                 stored_wf_size[found_wf_idx],
				                 dispatch2cu_wf_size_dispatch,
				                 cycle_counter);
			            
		             end

		             if(stored_wf_count[found_wf_idx] != 
			            dispatch2cu_wg_wf_count) begin
			            error_wf = 1'b1;
			            $display(">>> Error: expected wf_count:%d\tfound wf_count:%d @%0d",
				                 stored_wf_count[found_wf_idx],
				                 dispatch2cu_wg_wf_count,
				                 cycle_counter);
			            
		             end

		             if(!error_wf) begin
			            $display(">>> WF dispached OK tag:%d",
				                 dispatch2cu_wf_tag_dispatch);
		             end

		             
		             curr_dispatched_wf = curr_dispatched_wf+1;
		             next_start_vgpr = next_start_vgpr + 
				                       stored_vgpr_size_per_wf[found_wf_idx];
		             next_start_sgpr = next_start_sgpr + 
				                       stored_sgpr_size_per_wf[found_wf_idx];
		             
		             
		             if(error_wf) begin
			            end_wg = 1'b1;
		             end

		             if(curr_dispatched_wf == stored_wf_count[found_wf_idx]) begin
			            end_wg = 1'b1;
		             end
		             
		          end // if (one_wf_dispatching)
		          else if(multiple_wf_dispaching) begin
		             $display(">>> Error: multiple wf dispatching @%0d",
			                  cycle_counter);
		             end_wg = 1'b1;
		          end
		          else begin
		             $display(">>> Error: Expected %d wf but dispatcher only dispatched %d @%0d",
			                  stored_wf_count[found_wf_idx],
			                  curr_dispatched_wf,
			                  cycle_counter);
		             end_wg = 1'b1;
		          end
		          @(posedge clk);
		          
	           end // while (!end_wg)
	           
	           
	        end // if (found_wf_valid)
	        else begin
	           $display(">>> Error: Unknown wg\tstart_pc:%h @%0d",
			            dispatch2cu_start_pc_dispatch,
			            cycle_counter);
	           @(posedge clk);
	        end // else: !if(found_wf_valid)
	        
		    
	     end // if (one_wf_dispatching)
	     else begin
	        @(posedge clk);
	     end // else: !if(one_wf_dispatching)
	     
      end // forever begin
      
   end // block: CHECK_DISPATCHES

endmodule // dispatcher_checker
