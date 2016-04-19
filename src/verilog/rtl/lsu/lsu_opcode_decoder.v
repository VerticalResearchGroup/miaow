module lsu_opcode_decoder(
    lsu_selected,
    lsu_opcode,
    
    issue_source_reg1,
    issue_source_reg2,
    issue_source_reg3,
    issue_mem_sgpr,

    sgpr_source1_rd_en,
    sgpr_source2_rd_en,
    sgpr_source1_addr,
    sgpr_source2_addr,
    
    vgpr_source2_rd_en,
    vgpr_source1_addr,
    vgpr_source2_addr,
    
    mem_op_cnt,
    mem_op_rd,
    mem_op_wr,
    mem_gpr,
    
    sgpr_wr_mask,
    
    gpr_op_depth
);

input lsu_selected;
input [31:0] lsu_opcode;

input [11:0] issue_source_reg1;
input [11:0] issue_source_reg2;
input [11:0] issue_source_reg3;
input [11:0] issue_mem_sgpr;

output sgpr_source1_rd_en;
output sgpr_source2_rd_en;
output [8:0] sgpr_source1_addr;
output [8:0] sgpr_source2_addr;

output vgpr_source2_rd_en;
output [9:0] vgpr_source1_addr;
output [9:0] vgpr_source2_addr;

output [5:0] mem_op_cnt;
output mem_op_rd;
output mem_op_wr;
output mem_gpr; // Indicates whether the operation is for SGPR (0) or VGPR (1)
output [3:0] sgpr_wr_mask;

output [1:0] gpr_op_depth;

`define LSU_SMRD_OFFSET issue_source_reg1[8:0]
`define LSU_SMRD_SBASE issue_source_reg2[8:0]
`define LSU_SMRD_IMM_POS 23

`define LSU_DS_DATA0 issue_source_reg2[9:0]
`define LSU_DS_ADDR  issue_source_reg1[9:0]

`define LSU_MTBUF_SOFFSET  issue_source_reg1[8:0]
`define LSU_MTBUF_VDATA issue_source_reg2[9:0]
`define LSU_MTBUF_VADDR  issue_source_reg3[9:0]
`define LSU_MTBUF_SRSRC issue_mem_sgpr[8:0]

reg sgpr_source1_rd_en_reg;
reg sgpr_source2_rd_en_reg;
reg [8:0] sgpr_source1_addr_reg;
reg [8:0] sgpr_source2_addr_reg;
reg [3:0] sgpr_wr_mask_reg;

reg [9:0] vgpr_source1_addr_reg;
reg vgpr_source2_rd_en_reg;
reg [9:0] vgpr_source2_addr_reg;

reg [5:0] mem_op_cnt_reg;
reg mem_op_rd_reg;
reg mem_op_wr_reg;
reg mem_gpr_reg;

reg [1:0] gpr_op_depth_reg;

// Notes
// SGPR_S2 is the base address, S1 is the offset address if there is an offset address
// Intermediary value has the actual intermediary value. Don't bother routing that through
// for now, it'd be just a pass through anyway

always@(*) begin
    
    sgpr_source1_rd_en_reg <= 1'b0;
    sgpr_source2_rd_en_reg <= 1'b0;
    sgpr_source1_addr_reg <= 9'bxxxxxxxxx;
    sgpr_source2_addr_reg <= 9'bxxxxxxxxx;
    sgpr_wr_mask_reg <= 4'bxxxx;
    
    vgpr_source1_addr_reg <= 10'bxxxxxxxxxx;
    vgpr_source2_rd_en_reg <= 1'b0;
    vgpr_source2_addr_reg <= 10'bxxxxxxxxxx;
    
    mem_op_cnt_reg <= 6'bxxxxxx;
    mem_op_rd_reg <= 1'b0;
    mem_op_wr_reg <= 1'b0;
    mem_gpr_reg <= 1'b0;

    gpr_op_depth_reg <= 2'd0;
    
    // There is an inconsistency here between the decode_core and how we use
    // the SGPR ports here. The decode unit has register 2 as the BASE value,
    //  which doesn't work as the second SGPR port to the LSU is only 32bits
    //  wide, so we have to flip the registers in here. Don't get confused by
    // the inconsistency.
    case({lsu_selected, lsu_opcode[31:24]})
        
        // The SMRD instructions are different as there no write data from the
        // SGPR to memory instructions.
        {1'b1, `LSU_SMRD_FORMAT}:
        begin
            sgpr_source1_addr_reg <= `LSU_SMRD_SBASE;
            sgpr_source2_addr_reg <= `LSU_SMRD_OFFSET;
            sgpr_source1_rd_en_reg <= 1'b1;
            if(lsu_opcode[`LSU_SMRD_IMM_POS] == 0) begin
                sgpr_source2_rd_en_reg <= 1'b1;
            end
            
            // NOTE: S_DCACHE_INV instruction not supported, that instruction
            // does NOT perform a memory read
            
        end
        {1'b1,`LSU_DS_FORMAT}:
        begin
            vgpr_source1_addr_reg <= `LSU_DS_DATA0;
            vgpr_source2_addr_reg <= `LSU_DS_ADDR;
            vgpr_source2_rd_en_reg <= 1'b1;
            mem_gpr_reg <= 1'b1;
        end
        {1'b1, `LSU_MTBUF_FORMAT}:
        begin
            vgpr_source1_addr_reg <= `LSU_MTBUF_VDATA;
            vgpr_source2_addr_reg <= `LSU_MTBUF_VADDR;
            sgpr_source1_addr_reg <= `LSU_MTBUF_SRSRC;
            sgpr_source2_addr_reg <= `LSU_MTBUF_SOFFSET;
            vgpr_source2_rd_en_reg <= 1'b1;
            sgpr_source1_rd_en_reg <= 1'b1;
            sgpr_source2_rd_en_reg <= 1'b1;
            mem_gpr_reg <= 1'b1;
        end
    endcase
    
    casex({lsu_selected, lsu_opcode[31:24], lsu_opcode[7:0]})
        {1'b1, `LSU_SMRD_FORMAT, 8'h00}: //s_load_dword
        begin
            mem_op_rd_reg <= 1'b1;
            mem_op_cnt_reg <= 6'd0;
            sgpr_wr_mask_reg <= 4'b0001;
        end
        {1'b1, `LSU_SMRD_FORMAT, 8'h01}: //s_load_dwordx2
        begin
            mem_op_rd_reg <= 1'b1;
            mem_op_cnt_reg <= 6'd1;
            sgpr_wr_mask_reg <= 4'b0011;
        end
        {1'b1, `LSU_SMRD_FORMAT, 8'h02}: //s_load_dwordx4
        begin
            mem_op_rd_reg <= 1'b1;
            mem_op_cnt_reg <= 7'd3;
            sgpr_wr_mask_reg <= 4'b1111;
        end
        {1'b1, `LSU_SMRD_FORMAT, 8'h03}: //s_load_dwordx8
        begin
            gpr_op_depth_reg <= 2'b01;
            mem_op_rd_reg <= 1'b1;
            mem_op_cnt_reg <= 6'd3;
            sgpr_wr_mask_reg <= 4'b1111;
        end
        {1'b1, `LSU_SMRD_FORMAT, 8'h04}: //s_load_dwordx16
        begin
            gpr_op_depth_reg <= 2'b10;
            mem_op_rd_reg <= 1'b1;
            mem_op_cnt_reg <= 6'd3;
            sgpr_wr_mask_reg <= 4'b1111;
        end
        // Buffered loads aren't actually properly implemented, the necessary
        // infrastructure just isn't there in the rest of the LSU. Conversely
        // the documentation for the buffered instructions is extremely
        // confusing as it is not clear for SI at least how num_records or
        // stride is used in the memory operation beyond clamping.
        {1'b1, `LSU_SMRD_FORMAT, 8'h08}: //s_buffer_load_dword
        begin
            mem_op_rd_reg <= 1'b1;
            mem_op_cnt_reg <= 6'd0;
            sgpr_wr_mask_reg <= 4'b0001;
        end
        {1'b1, `LSU_SMRD_FORMAT, 8'h09}: //s_buffer_load_dwordx2
        begin
            mem_op_rd_reg <= 1'b1;
            mem_op_cnt_reg <= 6'd1;
            sgpr_wr_mask_reg <= 4'b0011;
        end
        {1'b1, `LSU_DS_FORMAT, 8'h36}: //ds_read_b32
        begin
            mem_op_rd_reg <= 1'b1;
        end
        {1'b1, `LSU_DS_FORMAT, 8'h0D}: //ds_write_b32
        begin
            mem_op_wr_reg <= 1'b1;
        end
        {1'b1, `LSU_MTBUF_FORMAT, 8'h00}: //tbuffer_load_format_x
        begin
            mem_op_rd_reg <= 1'b1;
            mem_op_cnt_reg <= 7'd63;
        end
        ///////// ADDED XY & XYZ support
        {1'b1, `LSU_MTBUF_FORMAT, 8'h01}: //tbuffer_load_format_xy
        begin
            gpr_op_depth_reg <= 2'b01;
            mem_op_rd_reg <= 1'b1;
            mem_op_cnt_reg <= 6'd63;
        end
        {1'b1, `LSU_MTBUF_FORMAT, 8'h02}: //tbuffer_load_format_xyz
        begin
            gpr_op_depth_reg <= 2'b10;
            mem_op_rd_reg <= 1'b1;
            mem_op_cnt_reg <= 6'd63;
        end
        //////////////////////////////////////
        {1'b1, `LSU_MTBUF_FORMAT, 8'h03}: //tbuffer_load_format_xyzw
        begin
            gpr_op_depth_reg <= 2'b11;
            mem_op_rd_reg <= 1'b1;
            mem_op_cnt_reg <= 6'd63;
        end
        {1'b1, `LSU_MTBUF_FORMAT, 8'h04}: //tbuffer_store_format_x
        begin
            mem_op_wr_reg <= 1'b1;
            mem_op_cnt_reg <= 6'd63;
        end
        ///////// ADDED XY & XYZ support
        {1'b1, `LSU_MTBUF_FORMAT, 8'h05}: //tbuffer_store_format_xy
        begin
            gpr_op_depth_reg <= 2'b01;
            mem_op_wr_reg <= 1'b1;
            mem_op_cnt_reg <= 6'd63;
        end
        {1'b1, `LSU_MTBUF_FORMAT, 8'h06}: //tbuffer_store_format_xyz
        begin
            gpr_op_depth_reg <= 2'b10;
            mem_op_wr_reg <= 1'b1;
            mem_op_cnt_reg <= 6'd63;
        end
        ////////////////////////////////
        {1'b1, `LSU_MTBUF_FORMAT, 8'h07}: //tbuffer_store_format_xyzw
        begin
            gpr_op_depth_reg <= 2'b11;
            mem_op_wr_reg <= 1'b1;
            mem_op_cnt_reg <= 6'd63;
        end
    endcase
end

assign sgpr_source1_rd_en = sgpr_source1_rd_en_reg;
assign sgpr_source2_rd_en = sgpr_source2_rd_en_reg;
assign sgpr_source1_addr = sgpr_source1_addr_reg;
assign sgpr_source2_addr = sgpr_source2_addr_reg;
assign sgpr_wr_mask = sgpr_wr_mask_reg;

assign vgpr_source2_rd_en = vgpr_source2_rd_en_reg;
assign vgpr_source1_addr = vgpr_source1_addr_reg;
assign vgpr_source2_addr = vgpr_source2_addr_reg;

assign mem_op_cnt = mem_op_cnt_reg;
assign mem_op_rd = mem_op_rd_reg;
assign mem_op_wr = mem_op_wr_reg;
assign mem_gpr = mem_gpr_reg;

assign gpr_op_depth = gpr_op_depth_reg;

endmodule
