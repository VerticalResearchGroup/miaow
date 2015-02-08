// Local Variables:
// verilog-library-directories:("." "../../rtl/dispatcher" "../../src")
// End:
module dispatcher_hard (/*AUTOARG*/
   // Outputs
   dispatch2cu_wg_wf_count, dispatch2cu_wf_tag_dispatch,
   dispatch2cu_wf_size_dispatch, dispatch2cu_wf_dispatch,
   dispatch2cu_vgpr_base_dispatch, dispatch2cu_start_pc_dispatch,
   dispatch2cu_sgpr_base_dispatch, dispatch2cu_lds_base_dispatch,
   ldssize_out, vregsize_out, sregsize_out,
   // Inputs
   rst, cu2dispatch_wf_tag_done, cu2dispatch_wf_done, clk
   ) ;

   // Resource accounting parameters
   parameter NUMBER_CU = 1;
   parameter CU_ID_WIDTH = 2;

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
   parameter RES_TABLE_ADDR_WIDTH = 1;
   
   parameter ENTRY_ADDR_WIDTH = 6;
   parameter NUMBER_ENTRIES = 64;


   parameter CU_VGPR_ID_WIDTH = 10;
   parameter CU_SGPR_ID_WIDTH = 9;
   parameter CU_LDS_ID_WIDTH = 16;
   parameter CU_GDS_ID_WIDTH = 16;


   output [15:0]              ldssize_out;
   output [9:0]               vregsize_out;
   output [8:0]               sregsize_out;
   
   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input		clk;			// To HOST of dispatcher_hard_host.v, ...
   input [NUMBER_CU-1:0] cu2dispatch_wf_done;	// To DISPATCHER_INST of dispatcher.v
   input [NUMBER_CU*TAG_WIDTH-1:0] cu2dispatch_wf_tag_done;// To DISPATCHER_INST of dispatcher.v
   input		rst;			// To HOST of dispatcher_hard_host.v, ...
   // End of automatics

	/*AUTOOUTPUT*/
	// Beginning of automatic outputs (from unused autoinst outputs)
	output [CU_LDS_ID_WIDTH-1:0] dispatch2cu_lds_base_dispatch;// From DISPATCHER_INST of dispatcher.v
	output [CU_SGPR_ID_WIDTH-1:0] dispatch2cu_sgpr_base_dispatch;// From DISPATCHER_INST of dispatcher.v
	output [MEM_ADDR_WIDTH-1:0] dispatch2cu_start_pc_dispatch;// From DISPATCHER_INST of dispatcher.v
	output [CU_VGPR_ID_WIDTH-1:0] dispatch2cu_vgpr_base_dispatch;// From DISPATCHER_INST of dispatcher.v
	output [NUMBER_CU-1:0] dispatch2cu_wf_dispatch;// From DISPATCHER_INST of dispatcher.v
	output [WAVE_ITEM_WIDTH-1:0] dispatch2cu_wf_size_dispatch;// From DISPATCHER_INST of dispatcher.v
	output [TAG_WIDTH-1:0] dispatch2cu_wf_tag_dispatch;// From DISPATCHER_INST of dispatcher.v
	output [WF_COUNT_WIDTH-1:0] dispatch2cu_wg_wf_count;// From DISPATCHER_INST of dispatcher.v
	// End of automatics
   
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [GDS_ID_WIDTH:0] host_gds_size_total;	// From HOST of dispatcher_hard_host.v
   wire [LDS_ID_WIDTH:0] host_lds_size_total;	// From HOST of dispatcher_hard_host.v
   wire [WF_COUNT_WIDTH-1:0] host_num_wf;	// From HOST of dispatcher_hard_host.v
   wire [SGPR_ID_WIDTH:0] host_sgpr_size_per_wf;// From HOST of dispatcher_hard_host.v
   wire [SGPR_ID_WIDTH:0] host_sgpr_size_total;	// From HOST of dispatcher_hard_host.v
   wire [MEM_ADDR_WIDTH-1:0] host_start_pc;	// From HOST of dispatcher_hard_host.v
   wire [VGPR_ID_WIDTH:0] host_vgpr_size_per_wf;// From HOST of dispatcher_hard_host.v
   wire [VGPR_ID_WIDTH:0] host_vgpr_size_total;	// From HOST of dispatcher_hard_host.v
   wire [WAVE_ITEM_WIDTH-1:0] host_wf_size;	// From HOST of dispatcher_hard_host.v
   wire [WG_ID_WIDTH-1:0] host_wg_id;		// From HOST of dispatcher_hard_host.v
   wire			host_wg_valid;		// From HOST of dispatcher_hard_host.v
   wire			inflight_wg_buffer_host_rcvd_ack;// From DISPATCHER_INST of dispatcher.v
   wire			inflight_wg_buffer_host_wf_done;// From DISPATCHER_INST of dispatcher.v
   wire [WG_ID_WIDTH-1:0] inflight_wg_buffer_host_wf_done_wg_id;// From DISPATCHER_INST of dispatcher.v
   // End of automatics
   
   dispatcher_hard_host
     #(/*AUTOINSTPARAM*/
       // Parameters
       .WG_ID_WIDTH			(WG_ID_WIDTH),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .WF_COUNT_WIDTH			(WF_COUNT_WIDTH),
       .WAVE_ITEM_WIDTH			(WAVE_ITEM_WIDTH),
       .VGPR_ID_WIDTH			(VGPR_ID_WIDTH),
       .SGPR_ID_WIDTH			(SGPR_ID_WIDTH),
       .LDS_ID_WIDTH			(LDS_ID_WIDTH),
       .GDS_ID_WIDTH			(GDS_ID_WIDTH),
       .MEM_ADDR_WIDTH			(MEM_ADDR_WIDTH))
   HOST
     (/*AUTOINST*/
      // Outputs
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
      // Inputs
      .inflight_wg_buffer_host_rcvd_ack	(inflight_wg_buffer_host_rcvd_ack),
      .inflight_wg_buffer_host_wf_done	(inflight_wg_buffer_host_wf_done),
      .inflight_wg_buffer_host_wf_done_wg_id(inflight_wg_buffer_host_wf_done_wg_id[WG_ID_WIDTH-1:0]),
      .clk				(clk),
      .rst				(rst));

   dispatcher
     #(/*AUTOINSTPARAM*/
       // Parameters
       .NUMBER_CU			(NUMBER_CU),
       .CU_ID_WIDTH			(CU_ID_WIDTH),
       .WG_ID_WIDTH			(WG_ID_WIDTH),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS			(NUMBER_WF_SLOTS),
       .WF_COUNT_WIDTH			(WF_COUNT_WIDTH),
       .WAVE_ITEM_WIDTH			(WAVE_ITEM_WIDTH),
       .VGPR_ID_WIDTH			(VGPR_ID_WIDTH),
       .NUMBER_VGPR_SLOTS		(NUMBER_VGPR_SLOTS),
       .SGPR_ID_WIDTH			(SGPR_ID_WIDTH),
       .NUMBER_SGPR_SLOTS		(NUMBER_SGPR_SLOTS),
       .LDS_ID_WIDTH			(LDS_ID_WIDTH),
       .NUMBER_LDS_SLOTS		(NUMBER_LDS_SLOTS),
       .GDS_ID_WIDTH			(GDS_ID_WIDTH),
       .GDS_SIZE			(GDS_SIZE),
       .TAG_WIDTH			(TAG_WIDTH),
       .MEM_ADDR_WIDTH			(MEM_ADDR_WIDTH),
       .RES_TABLE_ADDR_WIDTH		(RES_TABLE_ADDR_WIDTH),
       .ENTRY_ADDR_WIDTH		(ENTRY_ADDR_WIDTH),
       .NUMBER_ENTRIES			(NUMBER_ENTRIES),
       .CU_VGPR_ID_WIDTH		(CU_VGPR_ID_WIDTH),
       .CU_SGPR_ID_WIDTH		(CU_SGPR_ID_WIDTH),
       .CU_LDS_ID_WIDTH			(CU_LDS_ID_WIDTH),
       .CU_GDS_ID_WIDTH			(CU_GDS_ID_WIDTH))
   DISPATCHER_INST
     (/*AUTOINST*/
      // Outputs
      .dispatch2cu_lds_base_dispatch	(dispatch2cu_lds_base_dispatch[CU_LDS_ID_WIDTH-1:0]),
      .dispatch2cu_sgpr_base_dispatch	(dispatch2cu_sgpr_base_dispatch[CU_SGPR_ID_WIDTH-1:0]),
      .dispatch2cu_start_pc_dispatch	(dispatch2cu_start_pc_dispatch[MEM_ADDR_WIDTH-1:0]),
      .dispatch2cu_vgpr_base_dispatch	(dispatch2cu_vgpr_base_dispatch[CU_VGPR_ID_WIDTH-1:0]),
      .dispatch2cu_wf_dispatch		(dispatch2cu_wf_dispatch[NUMBER_CU-1:0]),
      .dispatch2cu_wf_size_dispatch	(dispatch2cu_wf_size_dispatch[WAVE_ITEM_WIDTH-1:0]),
      .dispatch2cu_wf_tag_dispatch	(dispatch2cu_wf_tag_dispatch[TAG_WIDTH-1:0]),
      .dispatch2cu_wg_wf_count		(dispatch2cu_wg_wf_count[WF_COUNT_WIDTH-1:0]),
      .inflight_wg_buffer_host_rcvd_ack	(inflight_wg_buffer_host_rcvd_ack),
      .inflight_wg_buffer_host_wf_done	(inflight_wg_buffer_host_wf_done),
      .inflight_wg_buffer_host_wf_done_wg_id(inflight_wg_buffer_host_wf_done_wg_id[WG_ID_WIDTH-1:0]),
      // Inputs
      .clk				(clk),
      .cu2dispatch_wf_done		(cu2dispatch_wf_done[NUMBER_CU-1:0]),
      .cu2dispatch_wf_tag_done		(cu2dispatch_wf_tag_done[NUMBER_CU*TAG_WIDTH-1:0]),
      .host_gds_size_total		(host_gds_size_total[GDS_ID_WIDTH:0]),
      .host_lds_size_total		(host_lds_size_total[LDS_ID_WIDTH:0]),
      .host_num_wf			(host_num_wf[WF_COUNT_WIDTH-1:0]),
      .host_sgpr_size_per_wf		(host_sgpr_size_per_wf[SGPR_ID_WIDTH:0]),
      .host_sgpr_size_total		(host_sgpr_size_total[SGPR_ID_WIDTH:0]),
      .host_start_pc			(host_start_pc[MEM_ADDR_WIDTH-1:0]),
      .host_vgpr_size_per_wf		(host_vgpr_size_per_wf[VGPR_ID_WIDTH:0]),
      .host_vgpr_size_total		(host_vgpr_size_total[VGPR_ID_WIDTH:0]),
      .host_wf_size			(host_wf_size[WAVE_ITEM_WIDTH-1:0]),
      .host_wg_id			(host_wg_id[WG_ID_WIDTH-1:0]),
      .host_wg_valid			(host_wg_valid),
      .rst				(rst));
   


   assign ldssize_out = 0;
   assign vregsize_out = 0;
   assign sregsize_out = 0;
     
endmodule // dispatcher_hard
