// Local Variables:
// verilog-library-directories:("." "../../../" "../../src")
// End:
module dispatcher_tb (/*AUTOARG*/) ;

   // Resource accounting localparams
   localparam NUMBER_CU = 8;
   localparam CU_ID_WIDTH = 3;

   localparam WG_ID_WIDTH = 6;
   localparam WG_SLOT_ID_WIDTH = 6;
   localparam NUMBER_WF_SLOTS = 40;
   localparam WF_COUNT_WIDTH = 4;
   localparam WAVE_ITEM_WIDTH = 6;

   localparam VGPR_ID_WIDTH = 8;
   localparam NUMBER_VGPR_SLOTS = 256;
   localparam SGPR_ID_WIDTH = 4;
   localparam NUMBER_SGPR_SLOTS = 13;
   localparam LDS_ID_WIDTH = 8;
   localparam NUMBER_LDS_SLOTS = 256;
   localparam GDS_ID_WIDTH = 14;
   localparam GDS_SIZE = 16384;

   localparam CU_VGPR_ID_WIDTH = 10;
   localparam CU_SGPR_ID_WIDTH = 9;
   localparam CU_LDS_ID_WIDTH = 16;
   localparam CU_GDS_ID_WIDTH = 16;
   
   localparam TAG_WIDTH = 15;
   localparam MEM_ADDR_WIDTH = 32;

   // Dispatcher internal localparams
   localparam RES_TABLE_ADDR_WIDTH = 1;
   
   localparam ENTRY_ADDR_WIDTH = 6;
   localparam NUMBER_ENTRIES = 64;


   localparam MAX_WF = 200;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 all_wf_dispatched;      // From HOST of host_test.v
   wire [NUMBER_CU-1:0] cu2dispatch_wf_done;    // From CUS of cu_simulator.v
   wire [NUMBER_CU*TAG_WIDTH-1:0] cu2dispatch_wf_tag_done;// From CUS of cu_simulator.v
   wire [CU_LDS_ID_WIDTH-1:0] dispatch2cu_lds_base_dispatch;// From DUT of dispatcher.v
   wire [CU_SGPR_ID_WIDTH-1:0] dispatch2cu_sgpr_base_dispatch;// From DUT of dispatcher.v
   wire [MEM_ADDR_WIDTH-1:0] dispatch2cu_start_pc_dispatch;// From DUT of dispatcher.v
   wire [CU_VGPR_ID_WIDTH-1:0] dispatch2cu_vgpr_base_dispatch;// From DUT of dispatcher.v
   wire [NUMBER_CU-1:0] dispatch2cu_wf_dispatch;// From DUT of dispatcher.v
   wire [WAVE_ITEM_WIDTH-1:0] dispatch2cu_wf_size_dispatch;// From DUT of dispatcher.v
   wire [TAG_WIDTH-1:0] dispatch2cu_wf_tag_dispatch;// From DUT of dispatcher.v
   wire [WF_COUNT_WIDTH-1:0] dispatch2cu_wg_wf_count;// From DUT of dispatcher.v
   wire [GDS_ID_WIDTH:0] host_gds_size_total;   // From HOST of host_test.v
   wire [LDS_ID_WIDTH:0] host_lds_size_total;   // From HOST of host_test.v
   wire [WF_COUNT_WIDTH-1:0] host_num_wf;       // From HOST of host_test.v
   wire [SGPR_ID_WIDTH:0] host_sgpr_size_per_wf;// From HOST of host_test.v
   wire [SGPR_ID_WIDTH:0] host_sgpr_size_total; // From HOST of host_test.v
   wire [MEM_ADDR_WIDTH-1:0] host_start_pc;     // From HOST of host_test.v
   wire [VGPR_ID_WIDTH:0] host_vgpr_size_per_wf;// From HOST of host_test.v
   wire [VGPR_ID_WIDTH:0] host_vgpr_size_total; // From HOST of host_test.v
   wire [WAVE_ITEM_WIDTH-1:0] host_wf_size;     // From HOST of host_test.v
   wire [WG_ID_WIDTH-1:0] host_wg_id;           // From HOST of host_test.v
   wire                 host_wg_valid;          // From HOST of host_test.v
   wire                 inflight_wg_buffer_host_rcvd_ack;// From DUT of dispatcher.v
   wire                 inflight_wg_buffer_host_wf_done;// From DUT of dispatcher.v
   wire [WG_ID_WIDTH-1:0] inflight_wg_buffer_host_wf_done_wg_id;// From DUT of dispatcher.v
   // End of automatics

   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg                  clk;                    // To DUT of dispatcher.v, ...
   reg                  rst;                    // To DUT of dispatcher.v, ...
   // End of automatics

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
   
   dispatcher
     #(/*AUTOINSTPARAM*/
       // Parameters
       .NUMBER_CU                       (NUMBER_CU),
       .CU_ID_WIDTH                     (CU_ID_WIDTH),
       .WG_ID_WIDTH                     (WG_ID_WIDTH),
       .WG_SLOT_ID_WIDTH                (WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS                 (NUMBER_WF_SLOTS),
       .WF_COUNT_WIDTH                  (WF_COUNT_WIDTH),
       .WAVE_ITEM_WIDTH                 (WAVE_ITEM_WIDTH),
       .VGPR_ID_WIDTH                   (VGPR_ID_WIDTH),
       .NUMBER_VGPR_SLOTS               (NUMBER_VGPR_SLOTS),
       .SGPR_ID_WIDTH                   (SGPR_ID_WIDTH),
       .NUMBER_SGPR_SLOTS               (NUMBER_SGPR_SLOTS),
       .LDS_ID_WIDTH                    (LDS_ID_WIDTH),
       .NUMBER_LDS_SLOTS                (NUMBER_LDS_SLOTS),
       .GDS_ID_WIDTH                    (GDS_ID_WIDTH),
       .GDS_SIZE                        (GDS_SIZE),
       .TAG_WIDTH                       (TAG_WIDTH),
       .MEM_ADDR_WIDTH                  (MEM_ADDR_WIDTH),
       .RES_TABLE_ADDR_WIDTH            (RES_TABLE_ADDR_WIDTH),
       .ENTRY_ADDR_WIDTH                (ENTRY_ADDR_WIDTH),
       .NUMBER_ENTRIES                  (NUMBER_ENTRIES),
       .CU_VGPR_ID_WIDTH                (CU_VGPR_ID_WIDTH),
       .CU_SGPR_ID_WIDTH                (CU_SGPR_ID_WIDTH),
       .CU_LDS_ID_WIDTH                 (CU_LDS_ID_WIDTH),
       .CU_GDS_ID_WIDTH                 (CU_GDS_ID_WIDTH))
   DUT
     (/*AUTOINST*/
      // Outputs
      .dispatch2cu_lds_base_dispatch    (dispatch2cu_lds_base_dispatch[CU_LDS_ID_WIDTH-1:0]),
      .dispatch2cu_sgpr_base_dispatch   (dispatch2cu_sgpr_base_dispatch[CU_SGPR_ID_WIDTH-1:0]),
      .dispatch2cu_start_pc_dispatch    (dispatch2cu_start_pc_dispatch[MEM_ADDR_WIDTH-1:0]),
      .dispatch2cu_vgpr_base_dispatch   (dispatch2cu_vgpr_base_dispatch[CU_VGPR_ID_WIDTH-1:0]),
      .dispatch2cu_wf_dispatch          (dispatch2cu_wf_dispatch[NUMBER_CU-1:0]),
      .dispatch2cu_wf_size_dispatch     (dispatch2cu_wf_size_dispatch[WAVE_ITEM_WIDTH-1:0]),
      .dispatch2cu_wf_tag_dispatch      (dispatch2cu_wf_tag_dispatch[TAG_WIDTH-1:0]),
      .dispatch2cu_wg_wf_count          (dispatch2cu_wg_wf_count[WF_COUNT_WIDTH-1:0]),
      .inflight_wg_buffer_host_rcvd_ack (inflight_wg_buffer_host_rcvd_ack),
      .inflight_wg_buffer_host_wf_done  (inflight_wg_buffer_host_wf_done),
      .inflight_wg_buffer_host_wf_done_wg_id(inflight_wg_buffer_host_wf_done_wg_id[WG_ID_WIDTH-1:0]),
      // Inputs
      .clk                              (clk),
      .cu2dispatch_wf_done              (cu2dispatch_wf_done[NUMBER_CU-1:0]),
      .cu2dispatch_wf_tag_done          (cu2dispatch_wf_tag_done[NUMBER_CU*TAG_WIDTH-1:0]),
      .host_gds_size_total              (host_gds_size_total[GDS_ID_WIDTH:0]),
      .host_lds_size_total              (host_lds_size_total[LDS_ID_WIDTH:0]),
      .host_num_wf                      (host_num_wf[WF_COUNT_WIDTH-1:0]),
      .host_sgpr_size_per_wf            (host_sgpr_size_per_wf[SGPR_ID_WIDTH:0]),
      .host_sgpr_size_total             (host_sgpr_size_total[SGPR_ID_WIDTH:0]),
      .host_start_pc                    (host_start_pc[MEM_ADDR_WIDTH-1:0]),
      .host_vgpr_size_per_wf            (host_vgpr_size_per_wf[VGPR_ID_WIDTH:0]),
      .host_vgpr_size_total             (host_vgpr_size_total[VGPR_ID_WIDTH:0]),
      .host_wf_size                     (host_wf_size[WAVE_ITEM_WIDTH-1:0]),
      .host_wg_id                       (host_wg_id[WG_ID_WIDTH-1:0]),
      .host_wg_valid                    (host_wg_valid),
      .rst                              (rst));

   host_test
     #(/*AUTOINSTPARAM*/
       // Parameters
       .WG_ID_WIDTH                     (WG_ID_WIDTH),
       .WG_SLOT_ID_WIDTH                (WG_SLOT_ID_WIDTH),
       .CU_ID_WIDTH                     (CU_ID_WIDTH),
       .WAVE_ITEM_WIDTH                 (WAVE_ITEM_WIDTH),
       .WF_COUNT_WIDTH                  (WF_COUNT_WIDTH),
       .MEM_ADDR_WIDTH                  (MEM_ADDR_WIDTH),
       .VGPR_ID_WIDTH                   (VGPR_ID_WIDTH),
       .NUMBER_VGPR_SLOTS               (NUMBER_VGPR_SLOTS),
       .SGPR_ID_WIDTH                   (SGPR_ID_WIDTH),
       .NUMBER_SGPR_SLOTS               (NUMBER_SGPR_SLOTS),
       .LDS_ID_WIDTH                    (LDS_ID_WIDTH),
       .NUMBER_LDS_SLOTS                (NUMBER_LDS_SLOTS),
       .GDS_ID_WIDTH                    (GDS_ID_WIDTH),
       .GDS_SIZE                        (GDS_SIZE))
   HOST
     (/*AUTOINST*/
      // Outputs
      .host_wg_valid                    (host_wg_valid),
      .host_wg_id                       (host_wg_id[WG_ID_WIDTH-1:0]),
      .host_num_wf                      (host_num_wf[WF_COUNT_WIDTH-1:0]),
      .host_vgpr_size_per_wf            (host_vgpr_size_per_wf[VGPR_ID_WIDTH:0]),
      .host_vgpr_size_total             (host_vgpr_size_total[VGPR_ID_WIDTH:0]),
      .host_sgpr_size_per_wf            (host_sgpr_size_per_wf[SGPR_ID_WIDTH:0]),
      .host_sgpr_size_total             (host_sgpr_size_total[SGPR_ID_WIDTH:0]),
      .host_lds_size_total              (host_lds_size_total[LDS_ID_WIDTH:0]),
      .host_gds_size_total              (host_gds_size_total[GDS_ID_WIDTH:0]),
      .host_wf_size                     (host_wf_size[WAVE_ITEM_WIDTH-1:0]),
      .host_start_pc                    (host_start_pc[MEM_ADDR_WIDTH-1:0]),
      .all_wf_dispatched                (all_wf_dispatched),
      // Inputs
      .rst                              (rst),
      .clk                              (clk),
      .inflight_wg_buffer_host_rcvd_ack (inflight_wg_buffer_host_rcvd_ack));
   
   
   cu_simulator
     #(/*AUTOINSTPARAM*/
       // Parameters
       .CU_ID_WIDTH                     (CU_ID_WIDTH),
       .NUMBER_CU                       (NUMBER_CU),
       .TAG_WIDTH                       (TAG_WIDTH),
       .WAVE_ITEM_WIDTH                 (WAVE_ITEM_WIDTH),
       .WF_COUNT_WIDTH                  (WF_COUNT_WIDTH),
       .MEM_ADDR_WIDTH                  (MEM_ADDR_WIDTH),
       .MAX_WF                          (MAX_WF))
   CUS
     (/*AUTOINST*/
      // Outputs
      .cu2dispatch_wf_done              (cu2dispatch_wf_done[NUMBER_CU-1:0]),
      .cu2dispatch_wf_tag_done          (cu2dispatch_wf_tag_done[NUMBER_CU*TAG_WIDTH-1:0]),
      // Inputs
      .clk                              (clk),
      .rst                              (rst),
      .all_wf_dispatched                (all_wf_dispatched),
      .dispatch2cu_wf_dispatch          (dispatch2cu_wf_dispatch[NUMBER_CU-1:0]),
      .dispatch2cu_lds_base_dispatch    (dispatch2cu_lds_base_dispatch[15:0]),
      .dispatch2cu_sgpr_base_dispatch   (dispatch2cu_sgpr_base_dispatch[8:0]),
      .dispatch2cu_start_pc_dispatch    (dispatch2cu_start_pc_dispatch[MEM_ADDR_WIDTH-1:0]),
      .dispatch2cu_vgpr_base_dispatch   (dispatch2cu_vgpr_base_dispatch[9:0]),
      .dispatch2cu_wf_size_dispatch     (dispatch2cu_wf_size_dispatch[WAVE_ITEM_WIDTH-1:0]),
      .dispatch2cu_wf_tag_dispatch      (dispatch2cu_wf_tag_dispatch[TAG_WIDTH-1:0]),
      .dispatch2cu_wg_wf_count          (dispatch2cu_wg_wf_count[WF_COUNT_WIDTH-1:0]));

   dispatcher_checker
     #(/*AUTOINSTPARAM*/
       // Parameters
       .WG_ID_WIDTH                     (WG_ID_WIDTH),
       .WF_COUNT_WIDTH                  (WF_COUNT_WIDTH),
       .WG_SLOT_ID_WIDTH                (WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS                 (NUMBER_WF_SLOTS),
       .CU_ID_WIDTH                     (CU_ID_WIDTH),
       .NUMBER_CU                       (NUMBER_CU),
       .VGPR_ID_WIDTH                   (VGPR_ID_WIDTH),
       .NUMBER_VGPR_SLOTS               (NUMBER_VGPR_SLOTS),
       .SGPR_ID_WIDTH                   (SGPR_ID_WIDTH),
       .NUMBER_SGPR_SLOTS               (NUMBER_SGPR_SLOTS),
       .LDS_ID_WIDTH                    (LDS_ID_WIDTH),
       .NUMBER_LDS_SLOTS                (NUMBER_LDS_SLOTS),
       .GDS_ID_WIDTH                    (GDS_ID_WIDTH),
       .GDS_SIZE                        (GDS_SIZE),
       .CU_VGPR_ID_WIDTH                (CU_VGPR_ID_WIDTH),
       .CU_SGPR_ID_WIDTH                (CU_SGPR_ID_WIDTH),
       .CU_LDS_ID_WIDTH                 (CU_LDS_ID_WIDTH),
       .CU_GDS_ID_WIDTH                 (CU_GDS_ID_WIDTH),
       .MEM_ADDR_WIDTH                  (MEM_ADDR_WIDTH),
       .WAVE_ITEM_WIDTH                 (WAVE_ITEM_WIDTH),
       .TAG_WIDTH                       (TAG_WIDTH),
       .MAX_WF                          (MAX_WF))
   CHECKER
     (
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .inflight_wg_buffer_host_rcvd_ack	(inflight_wg_buffer_host_rcvd_ack),
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
      .alloc_valid			(DUT.allocator_cu_valid),
      .inflight_buffer_valid		(DUT.inflight_wg_buffer_gpu_valid),
      .cu_id				(DUT.allocator_cu_id_out),
      .wg_id				(DUT.allocator_wg_id_out),
      .wf_count				(DUT.allocator_wf_count),
      .vgpr_start			(DUT.allocator_vgpr_start_out),
      .vgpr_size_per_wf			(DUT.inflight_wg_buffer_gpu_vgpr_size_per_wf),
      .sgpr_start			(DUT.allocator_sgpr_start_out),
      .sgpr_size_per_wf			(DUT.inflight_wg_buffer_gpu_sgpr_size_per_wf),
      .lds_start			(DUT.allocator_lds_start_out),
      .gds_start			(DUT.allocator_gds_start_out),
      .wf_size				(DUT.inflight_wg_buffer_gpu_wf_size),
      .start_pc             (DUT.inflight_wg_buffer_start_pc),
      .dispatch2cu_wf_dispatch		(dispatch2cu_wf_dispatch[NUMBER_CU-1:0]),
      .dispatch2cu_lds_base_dispatch	(dispatch2cu_lds_base_dispatch[15:0]),
      .dispatch2cu_sgpr_base_dispatch	(dispatch2cu_sgpr_base_dispatch[8:0]),
      .dispatch2cu_start_pc_dispatch	(dispatch2cu_start_pc_dispatch[MEM_ADDR_WIDTH-1:0]),
      .dispatch2cu_vgpr_base_dispatch	(dispatch2cu_vgpr_base_dispatch[9:0]),
      .dispatch2cu_wf_size_dispatch	(dispatch2cu_wf_size_dispatch[WAVE_ITEM_WIDTH-1:0]),
      .dispatch2cu_wf_tag_dispatch	(dispatch2cu_wf_tag_dispatch[TAG_WIDTH-1:0]),
      .dispatch2cu_wg_wf_count		(dispatch2cu_wg_wf_count[WF_COUNT_WIDTH-1:0]),
      .cu2dispatch_wf_done		(cu2dispatch_wf_done[NUMBER_CU-1:0]),
      .cu2dispatch_wf_tag_done		(cu2dispatch_wf_tag_done[NUMBER_CU*TAG_WIDTH-1:0]));
   


/*
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
      .alloc_valid			(DUT.allocator_cu_valid),
      .inflight_buffer_valid		(DUT.inflight_wg_buffer_gpu_valid),
      .cu_id				(DUT.allocator_cu_id_out),
      .wg_id				(DUT.allocator_wg_id_out),
      .wf_count				(DUT.allocator_wf_count),
      .vgpr_start			(DUT.allocator_vgpr_start_out),
      .vgpr_size_per_wf			(DUT.inflight_wg_buffer_gpu_vgpr_size_per_wf),
      .sgpr_start			(DUT.allocator_sgpr_start_out),
      .sgpr_size_per_wf			(DUT.inflight_wg_buffer_gpu_sgpr_size_per_wf),
      .lds_start			(DUT.allocator_lds_start_out),
      .gds_start			(DUT.allocator_gds_start_out),
      .wf_size				(DUT.inflight_wg_buffer_gpu_wf_size),
*/   
endmodule // dispatcher_tb
