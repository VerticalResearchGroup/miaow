module lsu_op_manager
(
    lsu_wfid,
    instr_pc,
    
    mem_op_cnt,
    mem_op_rd,
    mem_op_wr,
    mem_gpr,
    gm_or_lds,
    
    sgpr_wr_mask,
    gpr_op_depth,
    exec_mask,
    
    mem_in_addr,
    
    mem_ack,
    mem_rd_data,
    
    vgpr_source1_data,
    
    free_mem_slots,
    
    decoded_sgpr_source1_rd_en,
    decoded_sgpr_source2_rd_en,
    decoded_sgpr_source1_addr,
    decoded_sgpr_source2_addr,
    
    decoded_vgpr_source2_rd_en,
    decoded_vgpr_source1_addr,
    decoded_vgpr_source2_addr,
    
    decoded_dest_addr,
    
    sgpr_dest_data, sgpr_dest_wr_en, sgpr_dest_addr,
    
    vgpr_dest_data,
    vgpr_dest_wr_en,
    vgpr_wr_mask,
    vgpr_dest_addr,
    
    lsu_rdy,
    lsu_done, lsu_done_wfid,
    sgpr_instr_done, sgpr_instr_done_wfid,
    vgpr_instr_done, vgpr_instr_done_wfid,
    retire_pc,
    retire_gm_or_lds,
    tracemon_mem_addr,
    
    mem_rd_en,
    mem_wr_en,
    mem_out_addr,
    mem_wr_data,
    mem_tag_req,
    mem_gm_or_lds,
    
    sgpr_source1_rd_en,
    sgpr_source2_rd_en,
    sgpr_source1_addr,
    sgpr_source2_addr,
    
    vgpr_source1_rd_en,
    vgpr_source2_rd_en,
    vgpr_source1_addr,
    vgpr_source2_addr,
    
    clk,
    rst
);

parameter MEMORY_BUS_WIDTH = 32;
parameter MEM_SLOTS = 1;

input [5:0] lsu_wfid;   // wavefront ID, need to figure out what I'm going to do with it
input [31:0] instr_pc;

input [5:0] mem_op_cnt; // Number of memory operations needed per register row
input mem_op_rd;    // Indicates this is a memory read operation
input mem_op_wr;    // Indicates this is a memory write operation
input mem_gpr; // Indicates whether to write to SGPR (0) or VGPR (1)
input gm_or_lds;

input [3:0] sgpr_wr_mask;   // Indicates how wide the write to the SGPR will be

input [1:0] gpr_op_depth;   // Indicates how many GPR rows need to be operated on

input [63:0] exec_mask; // Indicates whether to skip a particular address

input [2047:0] mem_in_addr;
input mem_ack;
input [MEMORY_BUS_WIDTH-1:0] mem_rd_data;

input [2047:0] vgpr_source1_data;

input [MEM_SLOTS-1:0] free_mem_slots;

input decoded_sgpr_source1_rd_en;
input decoded_sgpr_source2_rd_en;
input [8:0] decoded_sgpr_source1_addr;
input [8:0] decoded_sgpr_source2_addr;

//input decoded_vgpr_source1_rd_en;
input decoded_vgpr_source2_rd_en;
input [9:0] decoded_vgpr_source1_addr;
input [9:0] decoded_vgpr_source2_addr;

input [11:0] decoded_dest_addr;

input clk;
input rst;

output sgpr_source1_rd_en;
output sgpr_source2_rd_en;
output [8:0] sgpr_source1_addr;
output [8:0] sgpr_source2_addr;

output vgpr_source1_rd_en;
output vgpr_source2_rd_en;
output [9:0] vgpr_source1_addr;
output [9:0] vgpr_source2_addr;

output [127:0] sgpr_dest_data;
output [8:0] sgpr_dest_addr;
output [3:0] sgpr_dest_wr_en;

output [2047:0] vgpr_dest_data;
output [9:0] vgpr_dest_addr;
output vgpr_dest_wr_en;
output [63:0] vgpr_wr_mask;

output mem_rd_en;
output mem_wr_en;
output [31:0] mem_out_addr;
output [MEMORY_BUS_WIDTH-1:0] mem_wr_data;
output [6:0] mem_tag_req;
output mem_gm_or_lds;

output lsu_rdy;
output lsu_done;
output sgpr_instr_done;
output vgpr_instr_done;

output [5:0] lsu_done_wfid;
output [5:0] sgpr_instr_done_wfid;
output [5:0] vgpr_instr_done_wfid;

output [31:0] retire_pc;
output retire_gm_or_lds;
output [2047:0] tracemon_mem_addr;

localparam IDLE_STATE = 4'b0000;
localparam ADDR_CALC_STATE = 4'b0001;
localparam RD_STATE = 4'b0010;              // Read from memory, write to register
localparam RD_REG_WR_STATE = 4'b0011;       // Write the data we've read from memory to the registers
localparam WR_REG_INIT_RD_STATE = 4'b0100;  // Due to the cycle delay need to initiate a read first
localparam WR_REG_RD_STATE = 4'b0101;       // Before we can write to memory we need to read data in from the registers
localparam WR_STATE = 4'b0110;              // Read from register, write to memory
localparam WR_REG_INC_STATE = 4'b0111;      // Increment to next register row
localparam SIGNAL_DONE_STATE = 4'b1000;

reg [5:0] current_wfid;
reg [5:0] current_wfid_next;
reg [31:0] current_pc;
reg [31:0] current_pc_next;

reg [3:0] lsu_state;
reg [3:0] lsu_state_next;
reg lsu_rd_wr; // 0 for read, 1 for write
reg lsu_rd_wr_next;

reg [5:0] mem_op_cnt_reg;
reg [5:0] mem_op_cnt_reg_next;
reg [6:0] mem_op_cnter;
reg [6:0] mem_op_cnter_next;

reg [2047:0] mem_in_addr_reg;
reg [2047:0] mem_in_addr_reg_next;
reg [2047:0] mem_base_addr_reg;
reg [2047:0] mem_base_addr_reg_next;

reg [31:0] mem_addr_offset;
reg [31:0] mem_addr_offset_next;

reg [2047:0] tracemon_mem_addr_reg;
reg [2047:0] tracemon_mem_addr_reg_next;

reg gm_or_lds_reg;
reg gm_or_lds_reg_next;

reg [1:0] gpr_op_depth_reg;
reg [1:0] gpr_op_depth_next;
reg [1:0] gpr_op_depth_cntr;
reg [1:0] gpr_op_depth_cntr_next;

reg [2047:0] mem_data_buffer;
reg [2047:0] mem_data_buffer_next_flat;
reg [31:0] mem_data_buffer_next [0:63];

reg [5:0] mem_data_offset;
reg [5:0] mem_data_offset_next;

reg mem_rd_en_reg;
reg mem_wr_en_reg;

reg sgpr_op;
reg sgpr_op_next;
reg vgpr_op;
reg vgpr_op_next;
reg gpr_wr;

// This module also handles routing of read requests to the VGPR and SGPR
reg muxed_sgpr_source1_rd_en;
reg muxed_sgpr_source2_rd_en;
reg [8:0] muxed_sgpr_source1_addr;
reg [8:0] muxed_sgpr_source2_addr;

reg muxed_vgpr_source1_rd_en;
reg muxed_vgpr_source2_rd_en;
reg [9:0] muxed_vgpr_source1_addr;
reg [9:0] muxed_vgpr_source2_addr;

reg [9:0] vgpr_source1_addr_reg;
reg [9:0] vgpr_source1_addr_reg_next;

reg [11:0] gpr_dest_addr;
reg [11:0] gpr_dest_addr_next;
reg [3:0] sgpr_wr_mask_reg;
reg [3:0] sgpr_wr_mask_reg_next;

reg [63:0] exec_mask_reg;
reg [63:0] exec_mask_reg_next;
reg [63:0] exec_mask_base_reg;
reg [63:0] exec_mask_base_reg_next;

always@(posedge clk) begin
    if(rst) begin
        current_wfid <= 6'd0;
        current_pc <= 32'd0;
        lsu_state <= IDLE_STATE;
        lsu_rd_wr <= 1'b0;
        mem_op_cnt_reg <= 6'd0;
        mem_op_cnter <= 7'd0;
        mem_in_addr_reg <= 2048'd0;
        mem_base_addr_reg <= 2048'd0;
        mem_addr_offset <= 32'd0;
        mem_data_buffer <= 2048'd0;
        mem_data_offset <= 6'd0;
        tracemon_mem_addr_reg <= 2048'd0;
        sgpr_op <= 1'b0;
        vgpr_op <= 1'b0;
        gpr_dest_addr <= 12'd0;
        gpr_op_depth_reg <= 2'd0;
        gpr_op_depth_cntr <= 2'd0;
        sgpr_wr_mask_reg <= 4'd0;
        exec_mask_reg <= 64'd0;
        exec_mask_base_reg <= 64'd0;
        vgpr_source1_addr_reg <= 10'd0;
        gm_or_lds_reg <= 1'b0;
    end
    else begin
        current_wfid <= current_wfid_next;
        current_pc <= current_pc_next;
        lsu_state <= lsu_state_next;
        lsu_rd_wr <= lsu_rd_wr_next;
        mem_op_cnt_reg <= mem_op_cnt_reg_next;
        mem_op_cnter <= mem_op_cnter_next;
        mem_in_addr_reg <= mem_in_addr_reg_next;
        mem_base_addr_reg <= mem_base_addr_reg_next;
        mem_addr_offset <= mem_addr_offset_next;
        mem_data_buffer <= mem_data_buffer_next_flat;
        tracemon_mem_addr_reg <= tracemon_mem_addr_reg_next;
        sgpr_op <= sgpr_op_next;
        vgpr_op <= vgpr_op_next;
        gpr_dest_addr <= gpr_dest_addr_next;
        gpr_op_depth_reg <= gpr_op_depth_next;
        gpr_op_depth_cntr <= gpr_op_depth_cntr_next;
        sgpr_wr_mask_reg <= sgpr_wr_mask_reg_next;
        exec_mask_reg <= exec_mask_reg_next;
        exec_mask_base_reg <= exec_mask_base_reg_next;
        vgpr_source1_addr_reg <= vgpr_source1_addr_reg_next;
        gm_or_lds_reg <= gm_or_lds_reg_next;
    end
end

always@(*) begin
    // LSU state/operation signals
    lsu_state_next <= lsu_state;
    lsu_rd_wr_next <= lsu_rd_wr;
    
    mem_op_cnt_reg_next <= mem_op_cnt_reg;
    mem_op_cnter_next <= mem_op_cnter;
    
    // Memory interface signals
    mem_in_addr_reg_next <= mem_in_addr_reg;
    mem_base_addr_reg_next <= mem_base_addr_reg;
    mem_addr_offset_next <= mem_addr_offset;
    mem_rd_en_reg <= 1'b0;
    mem_wr_en_reg <= 1'b0;
    
    tracemon_mem_addr_reg_next <= tracemon_mem_addr_reg;
    
    begin : MEM_BUFFER_MAP
        integer i;
        for(i = 0; i < 64; i = i + 1) begin
            mem_data_buffer_next[i] <= mem_data_buffer[32 * i+:32];
            mem_data_buffer_next_flat[32 * i+:32] <= mem_data_buffer_next[i];
        end
    end
    
    // Register bank control signals
    sgpr_wr_mask_reg_next <= sgpr_wr_mask_reg;
    exec_mask_reg_next <= exec_mask_reg;
    exec_mask_base_reg_next <= exec_mask_base_reg;
    
    sgpr_op_next <= sgpr_op;
    vgpr_op_next <= vgpr_op;
    gpr_wr <= 1'b0;
    current_wfid_next <= current_wfid;
    current_pc_next <= current_pc;
    gpr_op_depth_next <= gpr_op_depth_reg;
    gpr_op_depth_cntr_next <= gpr_op_depth_cntr;
    
    vgpr_source1_addr_reg_next <= vgpr_source1_addr_reg;
    
    muxed_sgpr_source1_rd_en <= 1'b0;
    muxed_sgpr_source2_rd_en <= 1'b0;
    muxed_sgpr_source1_addr <= 9'bXXXXXXXXX;
    muxed_sgpr_source2_addr <= 9'bXXXXXXXXX;
    //muxed_sgpr_dest_addr <= 9'bXXXXXXXXX;

    muxed_vgpr_source1_rd_en <= 1'b0;
    muxed_vgpr_source2_rd_en <= 1'b0;
    muxed_vgpr_source1_addr <= 10'bXXXXXXXXXX;
    muxed_vgpr_source2_addr <= 10'bXXXXXXXXXX;
    
    gpr_dest_addr_next <= gpr_dest_addr;
    
    gm_or_lds_reg_next <= gm_or_lds_reg;
    
    case(lsu_state)
        IDLE_STATE: begin
            lsu_rd_wr_next <= 1'b0;
            if(mem_op_rd | mem_op_wr) begin
                current_wfid_next <= lsu_wfid;
                current_pc_next <= instr_pc;
                lsu_state_next <= ADDR_CALC_STATE;
                mem_op_cnt_reg_next <= mem_op_cnt;
                mem_op_cnter_next <= 6'd0;
                mem_addr_offset_next <= 32'd0;
                
                // Route SGPR read signals from opcode decoder
                muxed_sgpr_source1_rd_en <= decoded_sgpr_source1_rd_en;
                muxed_sgpr_source2_rd_en <= decoded_sgpr_source2_rd_en;
                muxed_sgpr_source1_addr <= decoded_sgpr_source1_addr;
                muxed_sgpr_source2_addr <= decoded_sgpr_source2_addr;
                
                // Route VGPR read signals from opcode decoder
                muxed_vgpr_source2_rd_en <= decoded_vgpr_source2_rd_en;
                muxed_vgpr_source2_addr <= decoded_vgpr_source2_addr;
                
                gpr_op_depth_next <= gpr_op_depth;
            end
            
            // There are no SGPR to memory instructions so don't need to check
            // where the data is coming from, it's always the VGPR for writes.
            if(mem_op_wr) begin
                lsu_rd_wr_next <= 1'b1;
                vgpr_source1_addr_reg_next <= decoded_vgpr_source1_addr;
            end
            
            // These signals technically could be only updated when we get a
            // memory operation, but there's no real point to conditionalize
            // them.
            exec_mask_reg_next <= exec_mask;
            exec_mask_base_reg_next <= exec_mask;
            sgpr_wr_mask_reg_next <= sgpr_wr_mask;
            
            if(mem_op_rd) begin
                sgpr_op_next <= ~mem_gpr;
                vgpr_op_next <= mem_gpr;
                gpr_dest_addr_next <= decoded_dest_addr;
            end
        end
        // Get calculated address values
        ADDR_CALC_STATE: begin
            lsu_state_next <= RD_STATE;
            mem_in_addr_reg_next <= mem_in_addr;
            mem_base_addr_reg_next <= mem_in_addr;
            tracemon_mem_addr_reg_next <= mem_in_addr;
            gpr_op_depth_cntr_next <= 2'd0;
            mem_op_cnter_next <= 6'd0;
            if(lsu_rd_wr) begin
                lsu_state_next <= WR_REG_INIT_RD_STATE;
            end
            gm_or_lds_reg_next <= gm_or_lds;
        end
        
        RD_STATE: begin
            mem_rd_en_reg <= 1'b1;
            if(vgpr_op & ~exec_mask_reg[0]) begin
                // Stop trying to load
                lsu_state_next <= RD_REG_WR_STATE;
                mem_rd_en_reg <= 1'b0;
            end
            else if(mem_ack) begin
                // Need to verify how SGPR addresses are generated, whether
                // I'm supposed to just increment by 4's or if the offsets
                // are part of the generated address bank.
                mem_rd_en_reg <= 1'b0;
                mem_op_cnter_next <= mem_op_cnter + 6'd1;
                if(sgpr_op) begin
                    mem_addr_offset_next <= mem_addr_offset + 32'd4;
                end
                if(vgpr_op) begin
                    mem_in_addr_reg_next[2015:0] <= mem_in_addr_reg[2047:32];
                end
                mem_data_buffer_next[mem_op_cnter] <= mem_rd_data;
                exec_mask_reg_next[62:0] <= exec_mask_reg[63:1];
                if(mem_op_cnter == mem_op_cnt_reg) begin
                    lsu_state_next <= RD_REG_WR_STATE;
                end
            end
        end
        
        RD_REG_WR_STATE: begin
            gpr_wr <= 1'b1;
            gpr_op_depth_cntr_next <= gpr_op_depth_cntr + 2'd1;
            lsu_state_next <= RD_STATE;
            mem_op_cnter_next <= 6'd0;
            mem_in_addr_reg_next <= mem_base_addr_reg;
            exec_mask_reg_next <= exec_mask_base_reg;
            gpr_dest_addr_next <= gpr_dest_addr + 12'd1;
            if(vgpr_op) begin
                mem_addr_offset_next <= mem_addr_offset + 32'd4;
            end
            if(gpr_op_depth_cntr == gpr_op_depth_reg) begin
                // Signal done somehow
                lsu_state_next <= SIGNAL_DONE_STATE;
            end
        end
        
        WR_REG_INIT_RD_STATE: begin
            // There is literally no mechanism to actually write SGPR data
            // out to memory, so ignoring that case for now.
            muxed_vgpr_source1_rd_en <= 1'b1;
            muxed_vgpr_source1_addr <= vgpr_source1_addr_reg;
            lsu_state_next <= WR_REG_RD_STATE;
        end
        
        WR_REG_RD_STATE: begin
            mem_data_buffer_next_flat <= vgpr_source1_data;
            lsu_state_next <= WR_STATE;
        end
        
        WR_STATE: begin
            mem_wr_en_reg <= 1'b1;
            if(vgpr_op & ~exec_mask_reg[0]) begin
                // Stop trying to load
                lsu_state_next <= WR_REG_INC_STATE;
                mem_wr_en_reg <= 1'b0;
            end
            else if(mem_ack) begin
                mem_wr_en_reg <= 1'b0;
                mem_op_cnter_next <= mem_op_cnter + 6'd1;
                mem_in_addr_reg_next[2015:0] <= mem_in_addr_reg[2047:32];
                mem_data_buffer_next_flat[2015:0] <= mem_data_buffer[2047:32];
                exec_mask_reg_next[62:0] <= exec_mask_reg[63:1];
                if(mem_op_cnter == mem_op_cnt_reg) begin
                    lsu_state_next <= WR_REG_INC_STATE;
                end
            end
        end
        
        WR_REG_INC_STATE: begin
            lsu_state_next <= WR_REG_INIT_RD_STATE;
            gpr_op_depth_cntr_next <= gpr_op_depth_cntr + 2'd1;
            vgpr_source1_addr_reg_next <= vgpr_source1_addr_reg + 10'd1;
            if(gpr_op_depth_cntr == gpr_op_depth_reg) begin
                // Signal done somehow
                lsu_state_next <= SIGNAL_DONE_STATE;
            end
        end
        
        SIGNAL_DONE_STATE: begin
            lsu_state_next <= IDLE_STATE;
        end
    endcase
end

assign lsu_rdy = (lsu_state == IDLE_STATE) ? 1'b1 : 1'b0;
assign lsu_done = (lsu_state == SIGNAL_DONE_STATE) ? 1'b1 : 1'b0;
assign lsu_done_wfid = current_wfid;

assign retire_pc = (lsu_state == SIGNAL_DONE_STATE) ? current_pc : 32'd0;
assign retire_gm_or_lds = (lsu_state == SIGNAL_DONE_STATE) ? gm_or_lds_reg : 1'b0;

assign sgpr_instr_done = (lsu_state == SIGNAL_DONE_STATE) ? sgpr_op : 1'b0;
assign vgpr_instr_done = (lsu_state == SIGNAL_DONE_STATE) ? vgpr_op : 1'b0;

assign sgpr_instr_done_wfid = current_wfid;
assign vgpr_instr_done_wfid = current_wfid;

assign sgpr_dest_data = mem_data_buffer[127:0];
assign sgpr_dest_wr_en = {4{sgpr_op & gpr_wr}} & sgpr_wr_mask_reg;
assign sgpr_dest_addr = gpr_dest_addr[8:0];

assign vgpr_dest_data = mem_data_buffer;
assign vgpr_dest_wr_en = vgpr_op & gpr_wr;
assign vgpr_wr_mask = exec_mask_base_reg;
assign vgpr_dest_addr = gpr_dest_addr[9:0];

assign sgpr_source1_rd_en = muxed_sgpr_source1_rd_en;
assign sgpr_source2_rd_en = muxed_sgpr_source2_rd_en;
assign sgpr_source1_addr = muxed_sgpr_source1_addr;
assign sgpr_source2_addr = muxed_sgpr_source2_addr;

assign vgpr_source1_rd_en = muxed_vgpr_source1_rd_en;
assign vgpr_source2_rd_en = muxed_vgpr_source2_rd_en;
assign vgpr_source1_addr = muxed_vgpr_source1_addr;
assign vgpr_source2_addr = muxed_vgpr_source2_addr;

assign mem_rd_en = mem_rd_en_reg;
assign mem_wr_en = mem_wr_en_reg;
assign mem_out_addr = mem_in_addr_reg[31:0] + mem_addr_offset;
assign mem_wr_data = mem_data_buffer[31:0];
assign mem_tag_req = {current_wfid, mem_rd_en_reg};
assign mem_gm_or_lds = gm_or_lds_reg;

assign tracemon_mem_addr = tracemon_mem_addr_reg;

endmodule
