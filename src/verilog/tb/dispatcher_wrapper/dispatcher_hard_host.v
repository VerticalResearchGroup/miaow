extern "C" int checkWgAvailable();
extern "C" void prepareNextWg();
extern "C" int hardDisGetWgId();
extern "C" int hardDisGetWfCnt();
extern "C" int hardDisGetWfNumThrds();
extern "C" int hardDisGetVregSize();
extern "C" int hardDisGetVregSizePerWf();
extern "C" int hardDisGetSregSize()    ;
extern "C" int hardDisGetSregSizePerWf();
extern "C" int hardDisGetLdsSize();
extern "C" int hardDisGetGdsSize();
extern "C" int hardDisGetPc();


module dispatcher_hard_host (/*AUTOARG*/
   // Outputs
   host_wg_valid, host_wg_id, host_num_wf, host_wf_size,
   host_vgpr_size_total, host_sgpr_size_total, host_lds_size_total,
   host_gds_size_total, host_vgpr_size_per_wf, host_sgpr_size_per_wf,
   host_start_pc,
   // Inputs
   inflight_wg_buffer_host_rcvd_ack, inflight_wg_buffer_host_wf_done,
   inflight_wg_buffer_host_wf_done_wg_id, clk, rst
   ) ;
   // Resource accounting parameters
   parameter WG_ID_WIDTH = 6;
   parameter WG_SLOT_ID_WIDTH = 6;
   parameter WF_COUNT_WIDTH = 4;
   parameter WAVE_ITEM_WIDTH = 6;

   parameter VGPR_ID_WIDTH = 8;
   parameter SGPR_ID_WIDTH = 4;
   parameter LDS_ID_WIDTH = 8;
   parameter GDS_ID_WIDTH = 14;
   parameter MEM_ADDR_WIDTH = 32;
   
   // Output from cu
   output host_wg_valid;
   output [WG_ID_WIDTH-1:0] host_wg_id;
   output [WF_COUNT_WIDTH-1:0] host_num_wf;
   output [WAVE_ITEM_WIDTH-1:0] host_wf_size; // number of work itens in the last wf
   output [VGPR_ID_WIDTH :0]    host_vgpr_size_total;
   output [SGPR_ID_WIDTH :0]    host_sgpr_size_total;
   output [LDS_ID_WIDTH :0]     host_lds_size_total;
   output [GDS_ID_WIDTH :0]     host_gds_size_total;
   output [VGPR_ID_WIDTH :0]    host_vgpr_size_per_wf;
   output [SGPR_ID_WIDTH :0]    host_sgpr_size_per_wf;
   output [MEM_ADDR_WIDTH-1:0]  host_start_pc;   

   // Input from CU
   input                      inflight_wg_buffer_host_rcvd_ack;
   input                      inflight_wg_buffer_host_wf_done;
   input [WG_ID_WIDTH-1:0]    inflight_wg_buffer_host_wf_done_wg_id;

   input                      clk,rst;
   
   reg                        host_wg_valid_i;
   reg [WG_ID_WIDTH-1:0]      host_wg_id_i;
   reg [WF_COUNT_WIDTH-1:0]   host_num_wf_i;
   reg [WAVE_ITEM_WIDTH-1:0]  host_wf_size_i; // number of work itens in the last wf
   reg [VGPR_ID_WIDTH :0]     host_vgpr_size_total_i;
   reg [SGPR_ID_WIDTH :0]     host_sgpr_size_total_i;
   reg [LDS_ID_WIDTH :0]      host_lds_size_total_i;
   reg [GDS_ID_WIDTH :0]      host_gds_size_total_i;
   reg [VGPR_ID_WIDTH :0]     host_vgpr_size_per_wf_i;
   reg [SGPR_ID_WIDTH :0]     host_sgpr_size_per_wf_i;
   reg [MEM_ADDR_WIDTH-1:0]   host_start_pc_i;   

   reg                        initialized;
   
   always @ (  posedge clk or posedge rst  ) begin
      if(rst) begin
         host_wg_valid_i = 0;
         host_wg_id_i = 0;
         host_num_wf_i = 0;
         host_wf_size_i = 0;
         host_vgpr_size_total_i = 0;
         host_sgpr_size_total_i = 0;
         host_lds_size_total_i = 0;
         host_gds_size_total_i = 0;
         host_vgpr_size_per_wf_i = 0;
         host_sgpr_size_per_wf_i = 0;
         host_start_pc_i = 0;
         initialized = 0;
         
      end
      else begin
         if(inflight_wg_buffer_host_rcvd_ack ||
            !initialized) begin
            if(checkWgAvailable()) begin
               host_wg_valid_i = 1'b1;
               host_wg_id_i = hardDisGetWgId();
               host_num_wf_i = hardDisGetWfCnt();
               host_wf_size_i = hardDisGetWfNumThrds();
               host_vgpr_size_total_i = hardDisGetVregSize();
               host_sgpr_size_total_i = hardDisGetSregSize();
               host_lds_size_total_i = hardDisGetLdsSize();
               host_gds_size_total_i = hardDisGetGdsSize();
               host_vgpr_size_per_wf_i = hardDisGetVregSizePerWf();
               host_sgpr_size_per_wf_i = hardDisGetSregSizePerWf();
               host_start_pc_i = hardDisGetPc();

               prepareNextWg();
               initialized = 1'b1;
            end
            else begin
               host_wg_valid_i = 1'b0;               
            end // else: !if(checkWgAvailable())
         end // if (inflight_wg_buffer_host_rcvd_ack ||...
      end // else: !if(rst)
   end // always @ (  posedge clk or posedge rst  )
   

   assign host_wg_valid = host_wg_valid_i;
   assign host_wg_id = host_wg_id_i;
   assign host_num_wf = host_num_wf_i;
   assign host_wf_size = host_wf_size_i;
   assign host_vgpr_size_total = host_vgpr_size_total_i;
   assign host_sgpr_size_total = host_sgpr_size_total_i;
   assign host_lds_size_total = host_lds_size_total_i;
   assign host_gds_size_total = host_gds_size_total_i;
   assign host_vgpr_size_per_wf = host_vgpr_size_per_wf_i;
   assign host_sgpr_size_per_wf = host_sgpr_size_per_wf_i;
   assign host_start_pc = host_start_pc_i;   
   
endmodule // dispatcher_hard_host
