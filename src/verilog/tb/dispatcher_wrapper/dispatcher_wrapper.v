module dispatcher_wrapper (/*AUTOARG*/
   // Outputs
   dispatch2cu_wf_dispatch, dispatch2cu_wg_wf_count,
   dispatch2cu_wf_size_dispatch, dispatch2cu_sgpr_base_dispatch,
   dispatch2cu_vgpr_base_dispatch, dispatch2cu_wf_tag_dispatch,
   dispatch2cu_lds_base_dispatch, dispatch2cu_start_pc_dispatch,
   ldssize_out, vregsize_out, sregsize_out,
   // Inputs
   cu2dispatch_wf_done, cu2dispatch_wf_tag_done, clk, rst
   ) ;

   parameter NUMOFCU = 1;
   localparam CU_ID_WIDTH = 2;

   output [(NUMOFCU-1):0] dispatch2cu_wf_dispatch;
   output [3:0]           dispatch2cu_wg_wf_count;
   output [5:0]           dispatch2cu_wf_size_dispatch;
   output [8:0]           dispatch2cu_sgpr_base_dispatch;
   output [9:0]           dispatch2cu_vgpr_base_dispatch;
   output [14:0]          dispatch2cu_wf_tag_dispatch;
   output [15:0]          dispatch2cu_lds_base_dispatch;
   output [31:0]          dispatch2cu_start_pc_dispatch;

   output [15:0]          ldssize_out;
   output [9:0]           vregsize_out;
   output [8:0]           sregsize_out;
   
   input [NUMOFCU-1:0]    cu2dispatch_wf_done;
   input [NUMOFCU*15 - 1:0] cu2dispatch_wf_tag_done;

   input 		    clk,rst;
   
`ifdef HARD_DISPATCHER

   localparam NUMBER_CU = NUMOFCU;
   
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

   localparam TAG_WIDTH = 15;
   localparam MEM_ADDR_WIDTH = 32;

   // Dispatcher internal localparams
   localparam RES_TABLE_ADDR_WIDTH = 1;
   
   localparam ENTRY_ADDR_WIDTH = 6;
   localparam NUMBER_ENTRIES = 64;


   localparam CU_VGPR_ID_WIDTH = 10;
   localparam CU_SGPR_ID_WIDTH = 9;
   localparam CU_LDS_ID_WIDTH = 16;
   localparam CU_GDS_ID_WIDTH = 16;
   
   dispatcher_hard
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
   DISPATCHER
     (/*AUTOINST*/
      // Outputs
      .ldssize_out			(ldssize_out[15:0]),
      .vregsize_out			(vregsize_out[9:0]),
      .sregsize_out			(sregsize_out[8:0]),
      .dispatch2cu_lds_base_dispatch	(dispatch2cu_lds_base_dispatch[CU_LDS_ID_WIDTH-1:0]),
      .dispatch2cu_sgpr_base_dispatch	(dispatch2cu_sgpr_base_dispatch[CU_SGPR_ID_WIDTH-1:0]),
      .dispatch2cu_start_pc_dispatch	(dispatch2cu_start_pc_dispatch[MEM_ADDR_WIDTH-1:0]),
      .dispatch2cu_vgpr_base_dispatch	(dispatch2cu_vgpr_base_dispatch[CU_VGPR_ID_WIDTH-1:0]),
      .dispatch2cu_wf_dispatch		(dispatch2cu_wf_dispatch[NUMBER_CU-1:0]),
      .dispatch2cu_wf_size_dispatch	(dispatch2cu_wf_size_dispatch[WAVE_ITEM_WIDTH-1:0]),
      .dispatch2cu_wf_tag_dispatch	(dispatch2cu_wf_tag_dispatch[TAG_WIDTH-1:0]),
      .dispatch2cu_wg_wf_count		(dispatch2cu_wg_wf_count[WF_COUNT_WIDTH-1:0]),
      // Inputs
      .clk				(clk),
      .cu2dispatch_wf_done		(cu2dispatch_wf_done[NUMBER_CU-1:0]),
      .cu2dispatch_wf_tag_done		(cu2dispatch_wf_tag_done[NUMBER_CU*TAG_WIDTH-1:0]),
      .rst				(rst));
`endif

`ifndef HARD_DISPATCHER   
   dispatcher_soft
     #(/*AUTOINSTPARAM*/
       // Parameters
       .NUMOFCU				(NUMOFCU))
   DISPATCHER
     (/*AUTOINST*/
      // Outputs
      .dispatch2cu_wf_dispatch		(dispatch2cu_wf_dispatch[(NUMOFCU-1):0]),
      .dispatch2cu_wg_wf_count		(dispatch2cu_wg_wf_count[3:0]),
      .dispatch2cu_wf_size_dispatch	(dispatch2cu_wf_size_dispatch[5:0]),
      .dispatch2cu_sgpr_base_dispatch	(dispatch2cu_sgpr_base_dispatch[8:0]),
      .dispatch2cu_vgpr_base_dispatch	(dispatch2cu_vgpr_base_dispatch[9:0]),
      .dispatch2cu_wf_tag_dispatch	(dispatch2cu_wf_tag_dispatch[14:0]),
      .dispatch2cu_lds_base_dispatch	(dispatch2cu_lds_base_dispatch[15:0]),
      .dispatch2cu_start_pc_dispatch	(dispatch2cu_start_pc_dispatch[31:0]),
      .ldssize_out			(ldssize_out[15:0]),
      .vregsize_out			(vregsize_out[9:0]),
      .sregsize_out			(sregsize_out[8:0]),
      // Inputs
      .cu2dispatch_wf_done		(cu2dispatch_wf_done[NUMOFCU-1:0]),
      .cu2dispatch_wf_tag_done		(cu2dispatch_wf_tag_done[NUMOFCU*15-1:0]),
      .rst				(rst),
      .clk				(clk));
`endif
   
endmodule // dispatcher_wrapper

