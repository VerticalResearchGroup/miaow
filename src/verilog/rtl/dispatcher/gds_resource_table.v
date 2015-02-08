module gds_resource_table (/*AUTOARG*/
   // Outputs
   gds_res_tbl_wg_gds_size,
   // Inputs
   rst, clk, gds_res_tbl_alloc_en, gds_res_tbl_dealloc_en,
   gds_res_tbl_cu_id, gds_res_tbl_wg_id, gds_res_tbl_alloc_gds_size,
   gds_res_tbl_inflight_res_tbl_id
   ) ;

   parameter NUMBER_CU = 64;
   parameter CU_ID_WIDTH = 6;
   parameter RES_TABLE_ADDR_WIDTH = 3;

   parameter WG_SLOT_ID_WIDTH = 6;
   parameter NUMBER_WF_SLOTS = 40;

   parameter GDS_ID_WIDTH = 10;
   parameter GDS_SIZE = 1024;
   localparam NUMBER_RES_TABLES = 2**RES_TABLE_ADDR_WIDTH;
   
   input rst, clk;
   input gds_res_tbl_alloc_en, gds_res_tbl_dealloc_en;
   input [CU_ID_WIDTH-1:0] gds_res_tbl_cu_id;
   input [WG_SLOT_ID_WIDTH-1:0] gds_res_tbl_wg_id;
   input [GDS_ID_WIDTH:0] gds_res_tbl_alloc_gds_size;

   input [RES_TABLE_ADDR_WIDTH-1:0] gds_res_tbl_inflight_res_tbl_id;
   output [GDS_ID_WIDTH:0] 	    gds_res_tbl_wg_gds_size;

   wire [GDS_ID_WIDTH:0] 	    gds_dealloc_amount;
   reg [GDS_ID_WIDTH:0] 	    gds_res_tbl_wg_gds_size;
   
   // Group of rams that keep track resources used by each slot
   ram_2_port
     #(
       // Parameters
       .WORD_SIZE			(GDS_ID_WIDTH+1),
       .ADDR_SIZE			(WG_SLOT_ID_WIDTH+CU_ID_WIDTH),
       .NUM_WORDS			(NUMBER_WF_SLOTS*NUMBER_CU))
   wf_slot_gds_space_ram 
     (
      // Outputs
      .rd_word				(gds_dealloc_amount),
      // Inputs
      .rst				(rst),
      .clk				(clk),
      .wr_en				(gds_res_tbl_alloc_en),
      .wr_addr				({gds_res_tbl_wg_id,gds_res_tbl_cu_id}),
      .wr_word				(gds_res_tbl_alloc_gds_size),
      .rd_en				(gds_res_tbl_dealloc_en),
      .rd_addr				({gds_res_tbl_wg_id,gds_res_tbl_cu_id}));


   
   // reg that keeps track of the mount of gds space used
   reg[GDS_ID_WIDTH:0] 				    gds_used_space_reg;
   reg 						    gds_dealloc_en_delay;
   
   
   always @ ( posedge clk or posedge rst ) begin
      if (rst) begin
	 gds_used_space_reg <= 0;
	 gds_dealloc_en_delay <= 1'b0;
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 gds_res_tbl_wg_gds_size <= {(1+(GDS_ID_WIDTH)){1'b0}};
	 // End of automatics
      end
      else begin
	 gds_dealloc_en_delay <= gds_res_tbl_dealloc_en;
	 gds_res_tbl_wg_gds_size <= GDS_SIZE - gds_used_space_reg;
	 
	 if(gds_res_tbl_alloc_en && gds_dealloc_en_delay) begin
	    gds_used_space_reg <= gds_used_space_reg + gds_res_tbl_alloc_gds_size -
				  gds_dealloc_amount;
	 end
	 else if(gds_res_tbl_alloc_en) begin
	    gds_used_space_reg <= gds_used_space_reg + gds_res_tbl_alloc_gds_size;
	 end 
	 else if(gds_dealloc_en_delay) begin
	    gds_used_space_reg <= gds_used_space_reg - gds_dealloc_amount;
	 end
	 
      end
   end
   
endmodule // gds_resource_table
