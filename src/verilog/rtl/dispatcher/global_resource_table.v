module global_resource_table
  (/*AUTOARG*/
   // Outputs
   grt_cam_up_valid, grt_cam_up_wg_count, grt_cam_up_cu_id,
   grt_cam_up_vgpr_strt, grt_cam_up_vgpr_size, grt_cam_up_sgpr_strt,
   grt_cam_up_sgpr_size, grt_cam_up_lds_strt, grt_cam_up_lds_size,
   grt_cam_up_gds_strt, grt_cam_up_gds_size, grt_wg_alloc_done,
   grt_wg_alloc_wgid, grt_wg_alloc_cu_id, grt_wg_dealloc_done,
   grt_wg_dealloc_wgid, grt_wg_dealloc_cu_id,
   // Inputs
   clk, rst, gpu_interface_cu_id, gpu_interface_dealloc_wg_id,
   dis_controller_wg_alloc_valid, dis_controller_wg_dealloc_valid,
   allocator_wg_id_out, allocator_wf_count, allocator_cu_id_out,
   allocator_vgpr_start_out, allocator_sgpr_start_out,
   allocator_lds_start_out, allocator_gds_start_out,
   allocator_vgpr_size_out, allocator_sgpr_size_out,
   allocator_lds_size_out, allocator_gds_size_out
   );
   parameter NUMBER_CU = 64;
   parameter CU_ID_WIDTH = 6;
   parameter RES_TABLE_ADDR_WIDTH = 3;

   parameter VGPR_ID_WIDTH = 10;
   parameter NUMBER_VGPR_SLOTS = 1024;

   parameter SGPR_ID_WIDTH = 10;
   parameter NUMBER_SGPR_SLOTS = 1024;

   parameter LDS_ID_WIDTH = 10;
   parameter NUMBER_LDS_SLOTS = 1024;

   parameter WG_ID_WIDTH = 10;
   parameter WF_COUNT_WIDTH = 4;

   parameter WG_SLOT_ID_WIDTH = 6;
   parameter NUMBER_WF_SLOTS = 40;

   parameter GDS_ID_WIDTH = 10;
   parameter GDS_SIZE = 1024;

   localparam NUMBER_RES_TABLES = 2**RES_TABLE_ADDR_WIDTH;
   localparam CU_PER_RES_TABLES = NUMBER_CU/NUMBER_RES_TABLES;
   
   // width of all parameters same for start and size
   
   input clk, rst;
   input [CU_ID_WIDTH-1:0] gpu_interface_cu_id;
   input [WG_ID_WIDTH-1:0] gpu_interface_dealloc_wg_id;
   
   input 		   dis_controller_wg_alloc_valid;
   input 		   dis_controller_wg_dealloc_valid;
   input [WG_ID_WIDTH-1:0] allocator_wg_id_out;
   input [WF_COUNT_WIDTH-1:0] allocator_wf_count;
   input [CU_ID_WIDTH-1 :0]   allocator_cu_id_out;
   input [VGPR_ID_WIDTH-1 :0] allocator_vgpr_start_out;
   input [SGPR_ID_WIDTH-1 :0] allocator_sgpr_start_out;
   input [LDS_ID_WIDTH-1 :0]  allocator_lds_start_out;
   input [GDS_ID_WIDTH-1 :0]  allocator_gds_start_out;
   input [VGPR_ID_WIDTH :0]   allocator_vgpr_size_out;
   input [SGPR_ID_WIDTH :0]   allocator_sgpr_size_out;
   input [LDS_ID_WIDTH :0]    allocator_lds_size_out;
   input [GDS_ID_WIDTH :0]    allocator_gds_size_out;

   output 		      grt_cam_up_valid;
   output [WG_SLOT_ID_WIDTH:0] grt_cam_up_wg_count;
   output [CU_ID_WIDTH-1 :0]   grt_cam_up_cu_id;
   output [VGPR_ID_WIDTH-1 :0] grt_cam_up_vgpr_strt;
   output [VGPR_ID_WIDTH :0]   grt_cam_up_vgpr_size;
   output [SGPR_ID_WIDTH-1 :0] grt_cam_up_sgpr_strt;
   output [SGPR_ID_WIDTH :0]   grt_cam_up_sgpr_size;
   output [LDS_ID_WIDTH-1 :0]  grt_cam_up_lds_strt;
   output [LDS_ID_WIDTH :0]    grt_cam_up_lds_size;
   output [GDS_ID_WIDTH-1 :0]    grt_cam_up_gds_strt;
   output [GDS_ID_WIDTH :0]    grt_cam_up_gds_size;
   
   // Outputs to controller - allocated wf
   output 		       grt_wg_alloc_done;
   output [WG_ID_WIDTH-1:0]    grt_wg_alloc_wgid;
   output [CU_ID_WIDTH-1 :0]   grt_wg_alloc_cu_id;

   output 		       grt_wg_dealloc_done;
   output [WG_ID_WIDTH-1:0]    grt_wg_dealloc_wgid;
   output [CU_ID_WIDTH-1 :0]   grt_wg_dealloc_cu_id;

   // Input flop
   reg [CU_ID_WIDTH-1:0]       gpu_interface_cu_id_i;
   reg [WG_ID_WIDTH-1:0]       gpu_interface_dealloc_wg_id_i;
   
   reg 			       dis_controller_wg_alloc_valid_i;
   reg 			       dis_controller_wg_dealloc_valid_i;
   reg [WF_COUNT_WIDTH-1:0]    allocator_wf_count_i;
   reg [WG_ID_WIDTH-1:0]       allocator_wg_id_out_i;
   reg [CU_ID_WIDTH-1 :0]      allocator_cu_id_out_i;
   reg [VGPR_ID_WIDTH-1 :0]    allocator_vgpr_start_out_i;
   reg [SGPR_ID_WIDTH-1 :0]    allocator_sgpr_start_out_i;
   reg [LDS_ID_WIDTH-1 :0]     allocator_lds_start_out_i;
   reg [GDS_ID_WIDTH-1 :0]     allocator_gds_start_out_i;
   reg [VGPR_ID_WIDTH :0]      allocator_vgpr_size_out_i;
   reg [SGPR_ID_WIDTH :0]      allocator_sgpr_size_out_i;
   reg [LDS_ID_WIDTH :0]       allocator_lds_size_out_i;
   reg [GDS_ID_WIDTH :0]       allocator_gds_size_out_i;

   reg 			       alloc_res_en_dec;
   reg 			       dealloc_res_en_dec;
   
   reg [CU_ID_WIDTH-RES_TABLE_ADDR_WIDTH-1:0] cu_id_dec,
					      cu_id_dec_comb;
   
   reg [WG_ID_WIDTH-1:0] 		      wg_id_dec,
					      wg_id_dec_comb;

   reg [WF_COUNT_WIDTH-1:0] 		      allocator_wf_count_dec;
   reg [VGPR_ID_WIDTH-1 :0] 		      allocator_vgpr_start_out_dec;
   reg [SGPR_ID_WIDTH-1 :0] 		      allocator_sgpr_start_out_dec;
   reg [LDS_ID_WIDTH-1 :0] 		      allocator_lds_start_out_dec;
   reg [GDS_ID_WIDTH-1 :0] 		      allocator_gds_start_out_dec;
   reg [VGPR_ID_WIDTH :0] 		      allocator_vgpr_size_out_dec;
   reg [SGPR_ID_WIDTH :0] 		      allocator_sgpr_size_out_dec;
   reg [LDS_ID_WIDTH :0] 		      allocator_lds_size_out_dec;
   reg [GDS_ID_WIDTH :0] 		      allocator_gds_size_out_dec;

   
   reg [RES_TABLE_ADDR_WIDTH-1:0] 	      res_tbl_selected_addr,
					      res_tbl_selected_addr_comb;
   
   reg [NUMBER_RES_TABLES-1:0] 		      res_tbl_selected_dec;
   reg [NUMBER_RES_TABLES-1:0] 		      res_tbl_selected_dec_comb;

   // stage for wg_slot_id calculation
   reg 					      res_tbl_in_is_allocating, res_tbl_in_is_deallocating;
   
   reg [NUMBER_RES_TABLES-1:0] 		      res_tbl_in_alloc_res_en,
 					      res_tbl_in_dealloc_res_en;
   
   reg [RES_TABLE_ADDR_WIDTH-1:0] 	      res_tbl_in_tbl_addr;
   reg [CU_ID_WIDTH-RES_TABLE_ADDR_WIDTH-1:0] res_tbl_in_cu_id;
   
   wire [WG_SLOT_ID_WIDTH-1:0] 		      res_tbl_in_wg_slot_id;

   reg [VGPR_ID_WIDTH-1 :0] 		      res_tbl_in_vgpr_start_out;
   reg [SGPR_ID_WIDTH-1 :0] 		      res_tbl_in_sgpr_start_out;
   reg [LDS_ID_WIDTH-1 :0] 		      res_tbl_in_lds_start_out;
   reg [VGPR_ID_WIDTH :0] 		      res_tbl_in_vgpr_size_out;
   reg [SGPR_ID_WIDTH :0] 		      res_tbl_in_sgpr_size_out;
   reg [LDS_ID_WIDTH :0] 		      res_tbl_in_lds_size_out;
   reg [GDS_ID_WIDTH :0] 		      res_tbl_in_gds_size_out;

   
   // Output from res table/pri encoder
   wire [NUMBER_RES_TABLES-1:0] 	      vgpr_res_table_done, 
					      vgpr_res_table_waiting;
   wire [(VGPR_ID_WIDTH+1)*NUMBER_RES_TABLES-1:0] vgpr_biggest_space_size;
   wire [VGPR_ID_WIDTH*NUMBER_RES_TABLES-1:0] 	  vgpr_biggest_space_addr;
   
   wire [NUMBER_RES_TABLES-1:0] 		  sgpr_res_table_done,
						  sgpr_res_table_waiting;
   wire [(SGPR_ID_WIDTH+1)*NUMBER_RES_TABLES-1:0] sgpr_biggest_space_size;
   wire [SGPR_ID_WIDTH*NUMBER_RES_TABLES-1:0] 	  sgpr_biggest_space_addr;

   wire [NUMBER_RES_TABLES-1:0] 		  lds_res_table_done,
						  lds_res_table_waiting;
   
   wire [(LDS_ID_WIDTH+1)*NUMBER_RES_TABLES-1:0]  lds_biggest_space_size;
   wire [LDS_ID_WIDTH*NUMBER_RES_TABLES-1:0] 	  lds_biggest_space_addr;

   reg [NUMBER_RES_TABLES-1:0] 			  all_res_done_array,
						  res_done_array_select_comb,
						  res_done_array_select;
  
   reg 						  res_done_valid,
						  res_done_valid_comb,
						  res_done_valid_final;
   

   reg [RES_TABLE_ADDR_WIDTH-1:0] 		  res_done_tbl_addr,
						  res_done_tbl_addr_comb;

   // output of the res_tbl mux
   wire [WG_SLOT_ID_WIDTH-1:0] 			  mux_tbl_wg_slot_id;
   wire [WG_SLOT_ID_WIDTH:0] 			  mux_tbl_wf_count;
   
   
   wire [VGPR_ID_WIDTH:0] 			  mux_tbl_vgpr_biggest_space_size;
   wire [VGPR_ID_WIDTH-1:0] 			  mux_tbl_vgpr_biggest_space_addr;
   wire [SGPR_ID_WIDTH:0] 			  mux_tbl_sgpr_biggest_space_size;
   wire [SGPR_ID_WIDTH-1:0] 			  mux_tbl_sgpr_biggest_space_addr;
   wire [LDS_ID_WIDTH:0] 			  mux_tbl_lds_biggest_space_size;
   wire [LDS_ID_WIDTH-1:0] 			  mux_tbl_lds_biggest_space_addr;
   wire [GDS_ID_WIDTH:0] 			  mux_tbl_gds_biggest_space_size;
   reg [RES_TABLE_ADDR_WIDTH-1:0] 		  mux_tbl_tbl_addr;
   
   // inflight info
   localparam INFLIGHT_OP_WIDTH = CU_ID_WIDTH-RES_TABLE_ADDR_WIDTH+WG_ID_WIDTH+2;
   wire 					  inflight_alloc_en, inflight_dealloc_en;
   
   wire [CU_ID_WIDTH-RES_TABLE_ADDR_WIDTH-1:0] 	  inflight_cu_id;
   wire [WG_ID_WIDTH-1:0] 			  inflight_wg_id;
   
   /////////////////////////////////////////////////////////////////////////////////
   // Output assignments
   /////////////////////////////////////////////////////////////////////////////////
   assign grt_cam_up_valid = (inflight_alloc_en | inflight_dealloc_en) & 
			     res_done_valid_final;
   assign grt_cam_up_wg_count = mux_tbl_wf_count;
   assign grt_cam_up_cu_id = {mux_tbl_tbl_addr,inflight_cu_id};
   assign grt_cam_up_vgpr_strt = mux_tbl_vgpr_biggest_space_addr;
   assign grt_cam_up_vgpr_size = mux_tbl_vgpr_biggest_space_size;
   assign grt_cam_up_sgpr_strt = mux_tbl_sgpr_biggest_space_addr;
   assign grt_cam_up_sgpr_size = mux_tbl_sgpr_biggest_space_size;
   assign grt_cam_up_lds_strt = mux_tbl_lds_biggest_space_addr;
   assign grt_cam_up_lds_size = mux_tbl_lds_biggest_space_size;
   assign grt_cam_up_gds_size = mux_tbl_gds_biggest_space_size;
   
   // Assigns to controller - allocated wf
   assign grt_wg_alloc_done = inflight_alloc_en & res_done_valid_final;
   assign grt_wg_alloc_wgid = inflight_wg_id;
   assign grt_wg_alloc_cu_id = {mux_tbl_tbl_addr,inflight_cu_id};
   
   assign grt_wg_dealloc_done = inflight_dealloc_en & res_done_valid_final ;
   assign grt_wg_dealloc_wgid = inflight_wg_id;
   assign grt_wg_dealloc_cu_id = {mux_tbl_tbl_addr,inflight_cu_id};
   

   /////////////////////////////////////////////////////////////////////////////////
   // inflight op table
   /////////////////////////////////////////////////////////////////////////////////

   ram_2_port
     #(
       // Parameters
       .WORD_SIZE			(INFLIGHT_OP_WIDTH),
       .ADDR_SIZE			(RES_TABLE_ADDR_WIDTH),
       .NUM_WORDS			(NUMBER_RES_TABLES))
   inflight_op_table 
     (
      // Outputs
      .rd_word				({inflight_cu_id,inflight_wg_id,
					  inflight_alloc_en,inflight_dealloc_en}),
      // Inputs
      .rst				(rst),
      .clk				(clk),
      .wr_en				(alloc_res_en_dec |
					 dealloc_res_en_dec),
      .wr_addr				(res_tbl_selected_addr),
      .wr_word				({cu_id_dec,wg_id_dec,
					  alloc_res_en_dec,
					  dealloc_res_en_dec} ),
      .rd_en				(1'b1),
      .rd_addr				(res_done_tbl_addr));


   
   /////////////////////////////////////////////////////////////////////////////////
       // tables for each resource
   /////////////////////////////////////////////////////////////////////////////////
   wg_resource_table
     #(
       // Parameters
       .NUMBER_CU			(NUMBER_CU),
       .CU_ID_WIDTH			(CU_ID_WIDTH),
       .WG_ID_WIDTH			(WG_ID_WIDTH),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS			(NUMBER_WF_SLOTS),
       .RES_TABLE_ADDR_WIDTH		(RES_TABLE_ADDR_WIDTH))
   wg_res_tbl
     (
      // Outputs
      .wg_res_tbl_wg_slot_id		(res_tbl_in_wg_slot_id),
      .wg_res_tbl_wg_count_out		(mux_tbl_wf_count),
      // Inputs
      .rst				(rst),
      .clk				(clk),
      .wg_res_tbl_alloc_en		(alloc_res_en_dec),
      .wg_res_tbl_dealloc_en		(dealloc_res_en_dec),
      .wg_res_tbl_cu_id			({res_tbl_selected_addr,
					  cu_id_dec}),
      .wg_res_tbl_wg_id			(wg_id_dec),
      .wg_res_tbl_alloc_wg_wf_count	(allocator_wf_count_dec),
      .wg_res_tbl_inflight_res_tbl_id	(res_done_tbl_addr));

   gds_resource_table
     #(
       // Parameters
       .NUMBER_CU			(NUMBER_CU),
       .CU_ID_WIDTH			(CU_ID_WIDTH),
       .RES_TABLE_ADDR_WIDTH		(RES_TABLE_ADDR_WIDTH),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS			(NUMBER_WF_SLOTS),
       .GDS_ID_WIDTH			(GDS_ID_WIDTH),
       .GDS_SIZE			(GDS_SIZE))
   gds_res_tbl
     (
      // Outputs
      .gds_res_tbl_wg_gds_size		(mux_tbl_gds_biggest_space_size),
      // Inputs
      .rst				(rst),
      .clk				(clk),
      .gds_res_tbl_alloc_en		(|res_tbl_in_alloc_res_en),
      .gds_res_tbl_dealloc_en		(|res_tbl_in_dealloc_res_en),
      .gds_res_tbl_cu_id		({res_tbl_in_tbl_addr,res_tbl_in_cu_id}),
      .gds_res_tbl_wg_id		(res_tbl_in_wg_slot_id),
      .gds_res_tbl_alloc_gds_size	(res_tbl_in_gds_size_out),
      .gds_res_tbl_inflight_res_tbl_id	(res_done_tbl_addr));
   

   resource_table
     #(
       // Parameters
       .CU_ID_WIDTH			(CU_ID_WIDTH-RES_TABLE_ADDR_WIDTH),
       .NUMBER_CU			(CU_PER_RES_TABLES),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS_PER_CU		(NUMBER_WF_SLOTS),
       .RES_ID_WIDTH			(VGPR_ID_WIDTH),
       .NUMBER_RES_SLOTS		(NUMBER_VGPR_SLOTS))
   vgpr_table [NUMBER_RES_TABLES-1:0]
     (
      // Outputs
      .res_table_done			(vgpr_res_table_done),
      .cam_biggest_space_size		(vgpr_biggest_space_size),
      .cam_biggest_space_addr		(vgpr_biggest_space_addr),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .alloc_res_en			(res_tbl_in_alloc_res_en),
      .dealloc_res_en			(res_tbl_in_dealloc_res_en),
      .alloc_cu_id			(res_tbl_in_cu_id),
      .dealloc_cu_id			(res_tbl_in_cu_id),
      .alloc_wg_slot_id			(res_tbl_in_wg_slot_id),
      .dealloc_wg_slot_id		(res_tbl_in_wg_slot_id),
      .alloc_res_size			(res_tbl_in_vgpr_size_out),
      .alloc_res_start			(res_tbl_in_vgpr_start_out));
   
   resource_update_buffer
     #(
       // Parameters
       .RES_ID_WIDTH			(VGPR_ID_WIDTH),
       .RES_TABLE_ADDR_WIDTH		(RES_TABLE_ADDR_WIDTH),
       .NUMBER_RES_TABLES		(NUMBER_RES_TABLES))
   vgpr_up_buffer
     (
      // Outputs
      .res_table_waiting			(vgpr_res_table_waiting),
      .serviced_cam_biggest_space_size	(mux_tbl_vgpr_biggest_space_size),
      .serviced_cam_biggest_space_addr	(mux_tbl_vgpr_biggest_space_addr),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .res_table_done			(vgpr_res_table_done),
      .res_tbl_cam_biggest_space_size	(vgpr_biggest_space_size),
      .res_tbl_cam_biggest_space_addr	(vgpr_biggest_space_addr),
      .serviced_table			(res_done_array_select));
   
   
   resource_table
     #(
       // Parameters
       .CU_ID_WIDTH			(CU_ID_WIDTH-RES_TABLE_ADDR_WIDTH),
       .NUMBER_CU			(CU_PER_RES_TABLES),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS_PER_CU		(NUMBER_WF_SLOTS),
       .RES_ID_WIDTH			(SGPR_ID_WIDTH),
       .NUMBER_RES_SLOTS		(NUMBER_SGPR_SLOTS))
   sgpr_table [NUMBER_RES_TABLES-1:0]
     (
      // Outputs
      .res_table_done			(sgpr_res_table_done),
      .cam_biggest_space_size		(sgpr_biggest_space_size),
      .cam_biggest_space_addr		(sgpr_biggest_space_addr),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .alloc_res_en			(res_tbl_in_alloc_res_en),
      .dealloc_res_en			(res_tbl_in_dealloc_res_en),
      .alloc_cu_id			(res_tbl_in_cu_id),
      .dealloc_cu_id			(res_tbl_in_cu_id),
      .alloc_wg_slot_id			(res_tbl_in_wg_slot_id),
      .dealloc_wg_slot_id		(res_tbl_in_wg_slot_id),
      .alloc_res_size			(res_tbl_in_sgpr_size_out),
      .alloc_res_start			(res_tbl_in_sgpr_start_out));

   resource_update_buffer
     #(
       // Parameters
       .RES_ID_WIDTH			(SGPR_ID_WIDTH),
       .RES_TABLE_ADDR_WIDTH		(RES_TABLE_ADDR_WIDTH),
       .NUMBER_RES_TABLES		(NUMBER_RES_TABLES))
   sgpr_up_buffer
     (
      // Outputs
      .res_table_waiting			(sgpr_res_table_waiting),
      .serviced_cam_biggest_space_size	(mux_tbl_sgpr_biggest_space_size),
      .serviced_cam_biggest_space_addr	(mux_tbl_sgpr_biggest_space_addr),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .res_table_done			(sgpr_res_table_done),
      .res_tbl_cam_biggest_space_size	(sgpr_biggest_space_size),
      .res_tbl_cam_biggest_space_addr	(sgpr_biggest_space_addr),
      .serviced_table			(res_done_array_select));
   
   
   
   resource_table
     #(
       // Parameters
       .CU_ID_WIDTH			(CU_ID_WIDTH-RES_TABLE_ADDR_WIDTH),
       .NUMBER_CU			(CU_PER_RES_TABLES),
       .WG_SLOT_ID_WIDTH		(WG_SLOT_ID_WIDTH),
       .NUMBER_WF_SLOTS_PER_CU		(NUMBER_WF_SLOTS),
       .RES_ID_WIDTH			(LDS_ID_WIDTH),
       .NUMBER_RES_SLOTS		(NUMBER_LDS_SLOTS))
   lds_table [NUMBER_RES_TABLES-1:0]
     (
      // Outputs
      .res_table_done			(lds_res_table_done),
      .cam_biggest_space_size		(lds_biggest_space_size),
      .cam_biggest_space_addr		(lds_biggest_space_addr),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .alloc_res_en			(res_tbl_in_alloc_res_en),
      .dealloc_res_en			(res_tbl_in_dealloc_res_en),
      .alloc_cu_id			(res_tbl_in_cu_id),
      .dealloc_cu_id			(res_tbl_in_cu_id),
      .alloc_wg_slot_id			(res_tbl_in_wg_slot_id),
      .dealloc_wg_slot_id		(res_tbl_in_wg_slot_id),
      .alloc_res_size			(res_tbl_in_lds_size_out),
      .alloc_res_start			(res_tbl_in_lds_start_out));

   resource_update_buffer
     #(
       // Parameters
       .RES_ID_WIDTH			(LDS_ID_WIDTH),
       .RES_TABLE_ADDR_WIDTH		(RES_TABLE_ADDR_WIDTH),
       .NUMBER_RES_TABLES		(NUMBER_RES_TABLES))
   lds_up_buffer
     (
      // Outputs
      .res_table_waiting			(lds_res_table_waiting),
      .serviced_cam_biggest_space_size	(mux_tbl_lds_biggest_space_size),
      .serviced_cam_biggest_space_addr	(mux_tbl_lds_biggest_space_addr),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .res_table_done			(lds_res_table_done),
      .res_tbl_cam_biggest_space_size	(lds_biggest_space_size),
      .res_tbl_cam_biggest_space_addr	(lds_biggest_space_addr),
      .serviced_table			(res_done_array_select));
   
   
   
   always @( posedge clk or posedge rst ) begin
      if (rst) begin
	 // Input flops
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 all_res_done_array <= {NUMBER_RES_TABLES{1'b0}};
	 alloc_res_en_dec <= 1'h0;
	 allocator_cu_id_out_i <= {CU_ID_WIDTH{1'b0}};
	 allocator_gds_size_out_dec <= {(1+(GDS_ID_WIDTH)){1'b0}};
	 allocator_gds_size_out_i <= {(1+(GDS_ID_WIDTH)){1'b0}};
	 allocator_gds_start_out_dec <= {GDS_ID_WIDTH{1'b0}};
	 allocator_gds_start_out_i <= {GDS_ID_WIDTH{1'b0}};
	 allocator_lds_size_out_dec <= {(1+(LDS_ID_WIDTH)){1'b0}};
	 allocator_lds_size_out_i <= {(1+(LDS_ID_WIDTH)){1'b0}};
	 allocator_lds_start_out_dec <= {LDS_ID_WIDTH{1'b0}};
	 allocator_lds_start_out_i <= {LDS_ID_WIDTH{1'b0}};
	 allocator_sgpr_size_out_dec <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	 allocator_sgpr_size_out_i <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	 allocator_sgpr_start_out_dec <= {SGPR_ID_WIDTH{1'b0}};
	 allocator_sgpr_start_out_i <= {SGPR_ID_WIDTH{1'b0}};
	 allocator_vgpr_size_out_dec <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	 allocator_vgpr_size_out_i <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	 allocator_vgpr_start_out_dec <= {VGPR_ID_WIDTH{1'b0}};
	 allocator_vgpr_start_out_i <= {VGPR_ID_WIDTH{1'b0}};
	 allocator_wf_count_dec <= {(1+(WG_SLOT_ID_WIDTH)){1'b0}};
	 allocator_wf_count_i <= {(1+(WG_SLOT_ID_WIDTH)){1'b0}};
	 allocator_wg_id_out_i <= {WG_ID_WIDTH{1'b0}};
	 cu_id_dec <= {(1+(CU_ID_WIDTH-RES_TABLE_ADDR_WIDTH-1)){1'b0}};
	 dealloc_res_en_dec <= 1'h0;
	 dis_controller_wg_alloc_valid_i <= 1'h0;
	 dis_controller_wg_dealloc_valid_i <= 1'h0;
	 gpu_interface_cu_id_i <= {CU_ID_WIDTH{1'b0}};
	 gpu_interface_dealloc_wg_id_i <= {WG_ID_WIDTH{1'b0}};
	 mux_tbl_tbl_addr <= {RES_TABLE_ADDR_WIDTH{1'b0}};
	 res_done_array_select <= {NUMBER_RES_TABLES{1'b0}};
	 res_done_tbl_addr <= {RES_TABLE_ADDR_WIDTH{1'b0}};
	 res_done_valid <= 1'h0;
	 res_done_valid_final <= 1'h0;
	 res_tbl_in_alloc_res_en <= {NUMBER_RES_TABLES{1'b0}};
	 res_tbl_in_cu_id <= {(1+(CU_ID_WIDTH-RES_TABLE_ADDR_WIDTH-1)){1'b0}};
	 res_tbl_in_dealloc_res_en <= {NUMBER_RES_TABLES{1'b0}};
	 res_tbl_in_gds_size_out <= {(1+(GDS_ID_WIDTH)){1'b0}};
	 res_tbl_in_lds_size_out <= {(1+(LDS_ID_WIDTH)){1'b0}};
	 res_tbl_in_lds_start_out <= {LDS_ID_WIDTH{1'b0}};
	 res_tbl_in_sgpr_size_out <= {(1+(SGPR_ID_WIDTH)){1'b0}};
	 res_tbl_in_sgpr_start_out <= {SGPR_ID_WIDTH{1'b0}};
	 res_tbl_in_tbl_addr <= {RES_TABLE_ADDR_WIDTH{1'b0}};
	 res_tbl_in_vgpr_size_out <= {(1+(VGPR_ID_WIDTH)){1'b0}};
	 res_tbl_in_vgpr_start_out <= {VGPR_ID_WIDTH{1'b0}};
	 res_tbl_selected_addr <= {RES_TABLE_ADDR_WIDTH{1'b0}};
	 res_tbl_selected_dec <= {NUMBER_RES_TABLES{1'b0}};
	 wg_id_dec <= {WG_ID_WIDTH{1'b0}};
	 // End of automatics
   end
      else begin
	 
	 ///////////////////////////////
	 // Input flop
	 ///////////////////////////////
	 gpu_interface_cu_id_i <= gpu_interface_cu_id;
	 gpu_interface_dealloc_wg_id_i <= gpu_interface_dealloc_wg_id;
	 
	 dis_controller_wg_alloc_valid_i <= dis_controller_wg_alloc_valid;
	 dis_controller_wg_dealloc_valid_i <= dis_controller_wg_dealloc_valid;
	 allocator_wg_id_out_i <= allocator_wg_id_out;
	 allocator_cu_id_out_i <= allocator_cu_id_out;
	 allocator_wf_count_i <= allocator_wf_count;
	 allocator_vgpr_start_out_i <= allocator_vgpr_start_out;
	 allocator_sgpr_start_out_i <= allocator_sgpr_start_out;
	 allocator_lds_start_out_i <= allocator_lds_start_out;
	 allocator_gds_start_out_i <= allocator_gds_start_out;
	 allocator_vgpr_size_out_i <= allocator_vgpr_size_out;
	 allocator_sgpr_size_out_i <= allocator_sgpr_size_out;
	 allocator_lds_size_out_i <= allocator_lds_size_out;
	 allocator_gds_size_out_i <= allocator_gds_size_out;

	 // decoder flops
	 alloc_res_en_dec <= dis_controller_wg_alloc_valid_i;
	 dealloc_res_en_dec <= dis_controller_wg_dealloc_valid_i;
	 

	 cu_id_dec <= cu_id_dec_comb;
	 wg_id_dec <= wg_id_dec_comb;

	 allocator_wf_count_dec <= allocator_wf_count_i;
	 allocator_vgpr_start_out_dec <= allocator_vgpr_start_out_i;
	 allocator_sgpr_start_out_dec <= allocator_sgpr_start_out_i;
	 allocator_lds_start_out_dec <= allocator_lds_start_out_i;
	 allocator_gds_start_out_dec <= allocator_gds_start_out_i;
	 allocator_vgpr_size_out_dec <= allocator_vgpr_size_out_i;
	 allocator_sgpr_size_out_dec <= allocator_sgpr_size_out_i;
	 allocator_lds_size_out_dec <= allocator_lds_size_out_i;
	 allocator_gds_size_out_dec <= allocator_gds_size_out_i;
	 
	 res_tbl_selected_dec <= res_tbl_selected_dec_comb;
	 res_tbl_selected_addr <= res_tbl_selected_addr_comb;

	 // Inputs for the resource tables
	 res_tbl_in_alloc_res_en <= {NUMBER_RES_TABLES{alloc_res_en_dec}} & res_tbl_selected_dec;
 	 res_tbl_in_dealloc_res_en <= {NUMBER_RES_TABLES{dealloc_res_en_dec}} & res_tbl_selected_dec;
	 res_tbl_in_cu_id <= cu_id_dec;
	 res_tbl_in_tbl_addr <= res_tbl_selected_addr;
	 res_tbl_in_vgpr_start_out <= allocator_vgpr_start_out_dec;
	 res_tbl_in_sgpr_start_out <= allocator_sgpr_start_out_dec;
	 res_tbl_in_lds_start_out <= allocator_lds_start_out_dec;
	 res_tbl_in_vgpr_size_out <= allocator_vgpr_size_out_dec;
	 res_tbl_in_sgpr_size_out <= allocator_sgpr_size_out_dec;
	 res_tbl_in_lds_size_out <= allocator_lds_size_out_dec;
	 res_tbl_in_gds_size_out <= allocator_gds_size_out_dec;
	 
	 ///////////////////////////////////////
	 // resource_tables output
	 ///////////////////////////////////////

	 // All that are waiting except the one that we selected last
	 all_res_done_array <= vgpr_res_table_waiting & sgpr_res_table_waiting &
			       lds_res_table_waiting & (~res_done_array_select);
	 res_done_tbl_addr <= res_done_tbl_addr_comb;
	 res_done_array_select <= res_done_array_select_comb;
	 res_done_valid <= res_done_valid_comb;

	 // Last stage
	 res_done_valid_final <= res_done_valid;
	 
	 // used to reconstruct the cuid
	 mux_tbl_tbl_addr <= res_done_tbl_addr;



      end // else: !if(rst)
      
   end // always @ ( posedge clk or posedge rst )
   

   // Several always blocks for a faster simulation
   //////////////////////////////////////////////////////////
   // CU id decoder for the resource table en
   //////////////////////////////////////////////////////////
   always @ ( /*AUTOSENSE*/allocator_cu_id_out_i
	     or allocator_wg_id_out_i
	     or dis_controller_wg_alloc_valid_i
	     or dis_controller_wg_dealloc_valid_i
	     or gpu_interface_cu_id_i or gpu_interface_dealloc_wg_id_i) begin : CU_DECODER_TABLE_IN
      reg [RES_TABLE_ADDR_WIDTH-1:0] 	      tbl_addr_dec_comb;

      tbl_addr_dec_comb = 0;
      cu_id_dec_comb = 0;
      wg_id_dec_comb = 0;
      
      res_tbl_selected_dec_comb  = 0;
      
      if(dis_controller_wg_alloc_valid_i) begin
	 
	 cu_id_dec_comb = allocator_cu_id_out_i[CU_ID_WIDTH-
					       RES_TABLE_ADDR_WIDTH-1:0];
	 tbl_addr_dec_comb = allocator_cu_id_out_i[CU_ID_WIDTH-1:
						  CU_ID_WIDTH-RES_TABLE_ADDR_WIDTH];
	 wg_id_dec_comb = allocator_wg_id_out_i;

	 res_tbl_selected_dec_comb[tbl_addr_dec_comb] =  1'b1;
	 res_tbl_selected_addr_comb = tbl_addr_dec_comb;
      end 
      else if(dis_controller_wg_dealloc_valid_i) begin
	 cu_id_dec_comb = gpu_interface_cu_id_i[CU_ID_WIDTH-
					       RES_TABLE_ADDR_WIDTH-1:0];
	 tbl_addr_dec_comb = gpu_interface_cu_id_i[CU_ID_WIDTH-1:
						  CU_ID_WIDTH-RES_TABLE_ADDR_WIDTH];
	 
	 wg_id_dec_comb = gpu_interface_dealloc_wg_id_i;
	 res_tbl_selected_dec_comb[tbl_addr_dec_comb] =  1'b1;
	 res_tbl_selected_addr_comb = tbl_addr_dec_comb;
	 
      end
      else begin
	 cu_id_dec_comb = 0;
	 wg_id_dec_comb = 0;
	 res_tbl_selected_dec_comb = 0;
	 res_tbl_selected_addr_comb = 0;
      end

      
   end // always @ (...

   
   //////////////////////////////////////////////////////////
   // priority encoder that selects the res table to service
   //////////////////////////////////////////////////////////
   always @ ( /*AUTOSENSE*/all_res_done_array or res_done_array_select) begin : PRI_ENC_SERVICED_TABLE
      
      integer res_done_pri_enc_i;
      reg [RES_TABLE_ADDR_WIDTH-1:0] res_done_found_tbl;
      reg 			     res_done_found_tbl_valid;

      res_done_array_select_comb = 0;
      res_done_tbl_addr_comb = 0;
      res_done_valid_comb = 1'b0;
      
      res_done_found_tbl_valid = 1'b0;
      res_done_found_tbl = 0;
      
      // priority encoder to to select the serviced table and
      // encoder to calculate the cu_id
      for (res_done_pri_enc_i=0; res_done_pri_enc_i<NUMBER_RES_TABLES; 
	   res_done_pri_enc_i = res_done_pri_enc_i + 1) begin

	 if(all_res_done_array[res_done_pri_enc_i] & 
	    !res_done_array_select[res_done_pri_enc_i]) begin
	    if(!res_done_found_tbl_valid) begin
	       res_done_found_tbl = res_done_pri_enc_i;
	       res_done_found_tbl_valid = 1'b1;
	    end
	 end
	 
      end // for (res_done_pri_enc_i=; res_done_pri_enc_i<NUMBER_RES_TABLES;...

      res_done_valid_comb = res_done_found_tbl_valid;
      if( res_done_found_tbl_valid ) begin
	 res_done_tbl_addr_comb = res_done_found_tbl;
	 res_done_array_select_comb[res_done_found_tbl] = 1'b1;
      end
      
   end // always @ (...
   
endmodule // global_resource_table
