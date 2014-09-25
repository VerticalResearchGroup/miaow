module lsu_rd_stage_router
  (/*AUTOARG*/
   // Outputs
   out_vgpr_source1_rd_en, out_vgpr_source2_rd_en,
   out_sgpr_source1_rd_en, out_sgpr_source2_rd_en,
   out_vgpr_source1_addr, out_vgpr_source2_addr,
   out_sgpr_source1_addr, out_sgpr_source2_addr, out_vector_source_a,
   out_vector_source_b, out_scalar_source_a, out_scalar_source_b,
   out_rd_en, out_wr_en, out_lddst_stsrc_addr,
   // Inputs
   in_lsu_select, in_source_reg1, in_source_reg2, in_source_reg3,
   in_mem_sgpr, in_lsu_select_flopped, in_source_reg2_flopped,
   in_dest_reg, in_opcode, in_opcode_flopped, in_imm_value0,
   in_imm_value1, in_vgpr_source1_data, in_vgpr_source2_data,
   in_sgpr_source1_data, in_sgpr_source2_data
   );

   input in_lsu_select;
   input [11:0] in_source_reg1;
   input [11:0] in_source_reg2;
   input [11:0] in_source_reg3;
   input [11:0] in_mem_sgpr;
   input in_lsu_select_flopped;
   input [11:0] in_source_reg2_flopped;
   input [11:0] in_dest_reg;
   input [31:0] in_opcode;
   input [31:0] in_opcode_flopped;
   input [15:0] in_imm_value0;
   input [31:0] in_imm_value1;
   input [8191:0] in_vgpr_source1_data;
   input [2047:0] in_vgpr_source2_data;
   input [127:0]  in_sgpr_source1_data;
   input [31:0]   in_sgpr_source2_data;

   output 	  out_vgpr_source1_rd_en;
   output 	  out_vgpr_source2_rd_en;
   output 	  out_sgpr_source1_rd_en;
   output 	  out_sgpr_source2_rd_en;
   output [9:0]   out_vgpr_source1_addr;
   output [9:0]   out_vgpr_source2_addr;
   output [8:0]   out_sgpr_source1_addr;
   output [8:0]   out_sgpr_source2_addr;
   output [8191:0] out_vector_source_a;
   output [2047:0] out_vector_source_b;
   output [127:0]  out_scalar_source_a;
   output [31:0]   out_scalar_source_b;
   output [3:0]    out_rd_en;
   output [3:0]    out_wr_en;
   output [11:0]   out_lddst_stsrc_addr;

   reg [9:0] 	   out_vgpr_source1_addr;
   reg [9:0] 	   out_vgpr_source2_addr;
   reg [8:0] 	   out_sgpr_source1_addr;
   reg [8:0] 	   out_sgpr_source2_addr;
   reg [3:0] 	   out_rd_en;
   reg [3:0] 	   out_wr_en;

   wire [15:0] 	   dummy0;
   wire [31:0] 	   dummy1;
   assign dummy0 = in_imm_value0;
   assign dummy1 = in_imm_value1;

`define LSU_SMRD_OFFSET in_source_reg1[8:0]
`define LSU_SMRD_SBASE in_source_reg2[8:0]

`define LSU_DS_ADDR  in_source_reg1[9:0]
`define LSU_DS_DATA0 in_source_reg2[9:0]

`define LSU_MTBUF_SOFFSET  in_source_reg1[8:0]
`define LSU_MTBUF_VDATA in_source_reg2[9:0]
`define LSU_MTBUF_VADDR  in_source_reg3[9:0]
`define LSU_MTBUF_SRSRC in_mem_sgpr[8:0]

   assign out_vgpr_source1_rd_en = in_lsu_select;
   assign out_vgpr_source2_rd_en = in_lsu_select;
   assign out_sgpr_source1_rd_en = in_lsu_select;
   assign out_sgpr_source2_rd_en = in_lsu_select;


   always @*
     begin
	casex(in_opcode[31:24])
          `LSU_SMRD_FORMAT:
            begin
               out_vgpr_source1_addr <= 10'bx;
               out_vgpr_source2_addr <= 10'bx;
               out_sgpr_source1_addr <= `LSU_SMRD_SBASE;
               out_sgpr_source2_addr <= `LSU_SMRD_OFFSET;
            end
          `LSU_DS_FORMAT:
            begin
               out_vgpr_source1_addr <= `LSU_DS_DATA0;
               out_vgpr_source2_addr <= `LSU_DS_ADDR;
               out_sgpr_source1_addr <= 9'bx;
               out_sgpr_source2_addr <= 9'bx;
            end
          `LSU_MTBUF_FORMAT:
            begin
               out_vgpr_source1_addr <= `LSU_MTBUF_VDATA;
               out_vgpr_source2_addr <= `LSU_MTBUF_VADDR;
               out_sgpr_source1_addr <= `LSU_MTBUF_SRSRC;
               out_sgpr_source2_addr <= `LSU_MTBUF_SOFFSET;
            end
          default:
            begin
               out_vgpr_source1_addr <= 10'bx;
               out_vgpr_source2_addr <= 10'bx;
               out_sgpr_source1_addr <= 9'bx;
               out_sgpr_source2_addr <= 9'bx;
            end
	endcase
     end

   assign out_vector_source_a = in_vgpr_source1_data;
   assign out_vector_source_b = in_vgpr_source2_data;
   assign out_scalar_source_a = in_sgpr_source1_data;
   assign out_scalar_source_b = in_sgpr_source2_data;

   
   //assign out_lddst_stsrc_addr = in_dest_reg;
   reg [11:0] out_lddst_stsrc_addr;

   always @*
     begin
	casex({in_lsu_select_flopped, in_opcode_flopped[31:24], 
	       in_opcode_flopped[7:0]})
          {1'b0, 8'b?, 8'b?}: //inactive
            begin
               out_rd_en <= 4'b0000;
               out_wr_en <= 4'b0000;
               out_lddst_stsrc_addr <= {1'b0,{11{1'bx}}};
            end
          {1'b1, `LSU_SMRD_FORMAT, 8'h08}: //s_buffer_load_dword
            begin
               out_rd_en <= 4'b0001;
               out_wr_en <= 4'b0000;
               out_lddst_stsrc_addr <= in_dest_reg;
            end
          {1'b1, `LSU_SMRD_FORMAT, 8'h09}: //s_buffer_load_dwordx2
            begin
               out_rd_en <= 4'b0011;
               out_wr_en <= 4'b0000;
               out_lddst_stsrc_addr <= in_dest_reg;
            end
          {1'b1, `LSU_SMRD_FORMAT, 8'h02}: //s_load_dwordx4
            begin
               out_rd_en <= 4'b1111;
               out_wr_en <= 4'b0000;
               out_lddst_stsrc_addr <= in_dest_reg;
            end
          {1'b1, `LSU_DS_FORMAT, 8'h36}: //ds_read_b32
            begin
               out_rd_en <= 4'b0001;
               out_wr_en <= 4'b0000;
               out_lddst_stsrc_addr <= in_dest_reg;
            end
          {1'b1, `LSU_DS_FORMAT, 8'h0D}: //ds_write_b32
            begin
               out_rd_en <= 4'b0000;
               out_wr_en <= 4'b0001;
               out_lddst_stsrc_addr <= in_source_reg2_flopped;
            end
          {1'b1, `LSU_MTBUF_FORMAT, 8'h00}: //tbuffer_load_format_x
            begin
               out_rd_en <= 4'b0001;
               out_wr_en <= 4'b0000;
               out_lddst_stsrc_addr <= in_dest_reg;
            end
          {1'b1, `LSU_MTBUF_FORMAT, 8'h03}: //tbuffer_load_format_xyzw
            begin
               out_rd_en <= 4'b1111;
               out_wr_en <= 4'b0000;
               out_lddst_stsrc_addr <= in_dest_reg;
            end
          {1'b1, `LSU_MTBUF_FORMAT, 8'h04}: //tbuffer_store_format_x
            begin
               out_rd_en <= 4'b0000;
               out_wr_en <= 4'b0001;
               out_lddst_stsrc_addr <= in_source_reg2_flopped;
            end
          {1'b1, `LSU_MTBUF_FORMAT, 8'h07}: //tbuffer_store_format_xyzw
            begin
               out_rd_en <= 4'b0000;
               out_wr_en <= 4'b1111;
               out_lddst_stsrc_addr <= in_source_reg2_flopped;
            end
          default:
            begin
               out_rd_en <= 4'bxxxx;
               out_wr_en <= 4'bxxxx;
               out_lddst_stsrc_addr <= {1'b0,{11{1'bx}}};
            end
	endcase
     end
endmodule
