module lsu
(/*AUTOARG*/
    // Outputs
    issue_ready,
    vgpr_source1_rd_en, vgpr_source2_rd_en,
    sgpr_source1_rd_en, sgpr_source2_rd_en,
    mem_gm_or_lds, tracemon_gm_or_lds,
    vgpr_dest_wr_en,
    mem_rd_en, mem_wr_en,
    sgpr_dest_wr_en,
    exec_rd_wfid,
    mem_tag_req,
    sgpr_source1_addr, sgpr_source2_addr, sgpr_dest_addr,
    vgpr_source1_addr, vgpr_source2_addr, vgpr_dest_addr,
    vgpr_dest_wr_mask, mem_wr_mask,
    sgpr_dest_data,
    mem_addr,
    vgpr_dest_data, mem_wr_data, rfa_dest_wr_req,
    lsu_done, lsu_done_wfid,
    sgpr_instr_done, sgpr_instr_done_wfid,
    vgpr_instr_done, vgpr_instr_done_wfid,
    tracemon_retire_pc, tracemon_mem_addr, tracemon_idle,
    // Inputs
    clk, rst, issue_lsu_select, mem_ack, issue_wfid, mem_tag_resp,
    issue_source_reg1, issue_source_reg2, issue_source_reg3,
    issue_dest_reg, issue_mem_sgpr, issue_imm_value0, issue_lds_base,
    issue_imm_value1, issue_opcode, sgpr_source2_data,
    exec_rd_m0_value, issue_instr_pc, exec_exec_value,
    sgpr_source1_data, vgpr_source2_data, vgpr_source1_data,
    mem_rd_data, lsu_stall
);

parameter MEMORY_BUS_WIDTH = 32;
parameter MEM_SLOTS = 1;

input clk;
input rst;

input issue_lsu_select, mem_ack;
input [5:0] issue_wfid;
input [6:0] mem_tag_resp;
input [11:0] issue_source_reg1, issue_source_reg2, issue_source_reg3,
    issue_dest_reg, issue_mem_sgpr;
input [15:0] issue_imm_value0, issue_lds_base;
input [31:0] issue_imm_value1, issue_opcode, sgpr_source2_data, exec_rd_m0_value,
    issue_instr_pc;
input [63:0] exec_exec_value;
input [127:0] sgpr_source1_data;
input [2047:0] vgpr_source1_data;
input [2047:0] vgpr_source2_data;
input [MEMORY_BUS_WIDTH-1:0] mem_rd_data;
input lsu_stall;

output    issue_ready, vgpr_source1_rd_en, vgpr_source2_rd_en,
      sgpr_source1_rd_en, sgpr_source2_rd_en, mem_gm_or_lds,
      tracemon_gm_or_lds;
output vgpr_dest_wr_en, mem_rd_en, mem_wr_en;
output [3:0] sgpr_dest_wr_en;
output [5:0]   exec_rd_wfid;
output [6:0]   mem_tag_req;
output [8:0]   sgpr_source1_addr, sgpr_source2_addr, sgpr_dest_addr;
output [9:0]   vgpr_source1_addr, vgpr_source2_addr, vgpr_dest_addr;
output [63:0]  vgpr_dest_wr_mask, mem_wr_mask;
output [127:0] sgpr_dest_data;
output [31:0] mem_addr;
output [2047:0] vgpr_dest_data;
output [MEMORY_BUS_WIDTH-1:0] mem_wr_data;

output rfa_dest_wr_req;

output lsu_done;
output sgpr_instr_done;
output vgpr_instr_done;

output [5:0] lsu_done_wfid;
output [5:0] sgpr_instr_done_wfid;
output [5:0] vgpr_instr_done_wfid;

output [31:0]  tracemon_retire_pc;
output [2047:0] tracemon_mem_addr;
output tracemon_idle;

assign exec_rd_wfid = issue_wfid;

reg [31:0] issue_opcode_flopped;
reg [15:0] issue_lds_base_flopped;
reg [15:0] issue_imm_value0_flopped;

wire [2047:0] calc_mem_addr;
wire gm_or_lds;

wire decoded_sgpr_source1_rd_en;
wire decoded_sgpr_source2_rd_en;
wire [8:0] decoded_sgpr_source1_addr;
wire [8:0] decoded_sgpr_source2_addr;

//wire decoded_vgpr_source1_rd_en;
wire decoded_vgpr_source2_rd_en;
wire [9:0] decoded_vgpr_source1_addr;
wire [9:0] decoded_vgpr_source2_addr;

wire [5:0] mem_op_cnt;
wire mem_op_rd;
wire mem_op_wr;
wire mem_gpr;
wire [3:0] sgpr_wr_mask;

wire [1:0] gpr_op_depth;

always@(posedge clk) begin

    if(rst) begin
        issue_opcode_flopped <= 32'd0;
        issue_lds_base_flopped <= 16'd0;
        issue_imm_value0_flopped <= 16'd0;
    end
    else begin
        issue_opcode_flopped <= issue_opcode;
        issue_lds_base_flopped <= issue_lds_base;
        issue_imm_value0_flopped <= issue_imm_value0;
    end

end

// The decoder requires two cycles to receive the entire opcode. On the second
// cycle it generates register read operations for getting addres values from
// the GPRs.
lsu_opcode_decoder lsu_opcode_decoder0(
    .lsu_selected(issue_lsu_select),
    .lsu_opcode(issue_opcode),
    
    .issue_source_reg1(issue_source_reg1),
    .issue_source_reg2(issue_source_reg2),
    .issue_source_reg3(issue_source_reg3),
    .issue_mem_sgpr(issue_mem_sgpr),
    //.issue_dest_reg(issue_dest_reg_flopped),

    .sgpr_source1_rd_en(decoded_sgpr_source1_rd_en),
    .sgpr_source2_rd_en(decoded_sgpr_source2_rd_en),
    .sgpr_source1_addr(decoded_sgpr_source1_addr),
    .sgpr_source2_addr(decoded_sgpr_source2_addr),
    
    .vgpr_source2_rd_en(decoded_vgpr_source2_rd_en),
    .vgpr_source1_addr(decoded_vgpr_source1_addr),
    .vgpr_source2_addr(decoded_vgpr_source2_addr),
    
    // Signals to indicate a new memory request
    .mem_op_cnt(mem_op_cnt),
    .mem_op_rd(mem_op_rd),
    .mem_op_wr(mem_op_wr),
    .mem_gpr(mem_gpr),
    
    .sgpr_wr_mask(sgpr_wr_mask),
    
    .gpr_op_depth(gpr_op_depth)
);

lsu_op_manager lsu_op_manager0(
    .lsu_wfid(issue_wfid),
    .instr_pc(issue_instr_pc),
    
    // Signals to indicate a new memory request
    .mem_op_cnt(mem_op_cnt),
    .mem_op_rd(mem_op_rd),
    .mem_op_wr(mem_op_wr),
    .mem_gpr(mem_gpr),
    .gm_or_lds(gm_or_lds),
    
    .sgpr_wr_mask(sgpr_wr_mask),
    .gpr_op_depth(gpr_op_depth),
    .exec_mask(exec_exec_value),
    
    .mem_in_addr(calc_mem_addr),
    
    .mem_ack(mem_ack),
    .mem_rd_data(mem_rd_data),
    
    .vgpr_source1_data(vgpr_source1_data),
    
    .free_mem_slots(1'b0),
    
    .decoded_sgpr_source1_rd_en(decoded_sgpr_source1_rd_en),
    .decoded_sgpr_source2_rd_en(decoded_sgpr_source2_rd_en),
    .decoded_sgpr_source1_addr(decoded_sgpr_source1_addr),
    .decoded_sgpr_source2_addr(decoded_sgpr_source2_addr),

    //decoded_vgpr_source1_rd_en,
    .decoded_vgpr_source2_rd_en(decoded_vgpr_source2_rd_en),
    .decoded_vgpr_source1_addr(decoded_vgpr_source1_addr),
    .decoded_vgpr_source2_addr(decoded_vgpr_source2_addr),
    
    .decoded_dest_addr(issue_dest_reg),
    
    .sgpr_dest_data(sgpr_dest_data),
    .sgpr_dest_wr_en(sgpr_dest_wr_en),
    .sgpr_dest_addr(sgpr_dest_addr),
    
    .vgpr_dest_data(vgpr_dest_data),
    .vgpr_dest_wr_en(vgpr_dest_wr_en),
    .vgpr_wr_mask(vgpr_dest_wr_mask),
    .vgpr_dest_addr(vgpr_dest_addr),
    
    .lsu_rdy(issue_ready),
    
    .lsu_done(lsu_done),
    .sgpr_instr_done(sgpr_instr_done),
    .vgpr_instr_done(vgpr_instr_done),
    .lsu_done_wfid(lsu_done_wfid),
    .sgpr_instr_done_wfid(sgpr_instr_done_wfid),
    .vgpr_instr_done_wfid(vgpr_instr_done_wfid),
    
    .retire_pc(tracemon_retire_pc),
    .retire_gm_or_lds(tracemon_gm_or_lds),
    .tracemon_mem_addr(tracemon_mem_addr),
    
    .mem_rd_en(mem_rd_en),
    .mem_wr_en(mem_wr_en),
    .mem_out_addr(mem_addr),
    .mem_wr_data(mem_wr_data),
    .mem_tag_req(mem_tag_req),
    .mem_gm_or_lds(mem_gm_or_lds),
    
    .sgpr_source1_rd_en(sgpr_source1_rd_en),
    .sgpr_source2_rd_en(sgpr_source2_rd_en),
    .sgpr_source1_addr(sgpr_source1_addr),
    .sgpr_source2_addr(sgpr_source2_addr),
    
    .vgpr_source1_rd_en(vgpr_source1_rd_en),
    .vgpr_source2_rd_en(vgpr_source2_rd_en),
    .vgpr_source1_addr(vgpr_source1_addr),
    .vgpr_source2_addr(vgpr_source2_addr),
    
    .clk(clk),
    .rst(rst)
);

// Because the register read operations for the address values will take one
// cycle to complete the opcode needs to be flopped so that the opcode being
// used by the address calculator is properly aligned.
lsu_addr_calculator addr_calc(
    .in_vector_source_b(vgpr_source2_data),
    .in_scalar_source_a(sgpr_source1_data),
    .in_scalar_source_b(sgpr_source2_data),
    .in_opcode(issue_opcode_flopped),
    .in_lds_base(issue_lds_base_flopped),
    .in_imm_value0(issue_imm_value0_flopped),
    .out_ld_st_addr(calc_mem_addr),
    .out_gm_or_lds(gm_or_lds)
);

assign rfa_dest_wr_req = (|sgpr_dest_wr_en) | vgpr_dest_wr_en;

// Something of a hack, at this point it's not actually needed
assign mem_wr_mask = vgpr_dest_wr_mask;

assign tracemon_idle = issue_ready;

endmodule
