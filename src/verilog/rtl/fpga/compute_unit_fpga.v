
`timescale 1 ns / 1 ps

module compute_unit_fpga #
(
  // Users to add parameters here

  // User parameters ends
  // Do not modify the parameters beyond this line

  // Width of S_AXI data bus
  parameter integer C_S_AXI_DATA_WIDTH	= 32,
  // Width of S_AXI address bus
  parameter integer C_S_AXI_ADDR_WIDTH	= 9
)
(
  input wire [C_S_AXI_DATA_WIDTH-1:0] waveID_out,
  input wire [C_S_AXI_DATA_WIDTH-1:0] baseVGPR_out,
  input wire [C_S_AXI_DATA_WIDTH-1:0] baseSGPR_out,
  input wire [C_S_AXI_DATA_WIDTH-1:0] baseLDS_out,
  input wire [C_S_AXI_DATA_WIDTH-1:0] waveCount_out,
  input wire [C_S_AXI_DATA_WIDTH-1:0] pcStart_out,
  input wire [C_S_AXI_DATA_WIDTH-1:0] instrAddrReg_out,
  output wire [C_S_AXI_DATA_WIDTH-1:0] instruction_buff_out_a_in,
  output wire cu2dispatch_wf_done_in,
  output wire [C_S_AXI_DATA_WIDTH-1:0] resultsReadyTag_in,
  
  input wire [3:0] lsu2sgpr_dest_wr_en_out,
  input wire [9:0] quadBaseAddress_out,
  input wire [31:0] quadData0_out,
  input wire [31:0] quadData1_out,
  input wire [31:0] quadData2_out,
  input wire [31:0] quadData3_out,
  output wire [127:0] quadData_in,
  output wire [2047:0] singleVectorData_in,
  input wire [9:0] singleVectorBaseAddress_out,
  
  input wire execute_out,
  input wire executeStart_out,
  
  input wire [3:0] instrBuffWrEn_out,
  
  input wire [31:0] axi_data_out,
  
  input wire [31:0] mb2fpgamem_data_in,
  input wire mb2fpgamem_data_we,
  input wire mb2fpgamem_ack,
  input wire mb2fpgamem_done,
  
  output wire [3:0] fpgamem2mb_op,
  output wire [31:0] fpgamem2mb_data,
  output wire [31:0] fpgamem2mb_addr,
  
  output wire [31:0] pc_value,
  input wire  reset_out,
  input wire clk_50
);

// Example-specific design signals
// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
// ADDR_LSB is used for addressing 32/64 bit registers/memories
// ADDR_LSB = 2 for 32 bits (n downto 2)
// ADDR_LSB = 3 for 64 bits (n downto 3)
localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
localparam integer OPT_MEM_ADDR_BITS = 6;
//----------------------------------------------
//-- Signals for user logic register space example
//------------------------------------------------
//-- Number of Slave Registers 128

wire rst_signal;
wire clk;

assign clk = clk_50;

reg fetch2buff_rd_en_reg;
reg [38:0] fetch2buff_tag_reg;

wire [31:0] instruction_buff_out_b;

// SGPR registers
reg [31:0] gprCommand;
wire [15:0] sgpr_select_fu;
wire [3:0] lsu2sgpr_dest_wr_en_thru;

wire  buff2fetchwave_ack, cu2dispatch_wf_done, decode2issue_barrier,
      decode2issue_branch, decode2issue_exec_rd, decode2issue_exec_wr, decode2issue_m0_rd,
      decode2issue_m0_wr, decode2issue_scc_rd, decode2issue_scc_wr, decode2issue_valid,
      decode2issue_vcc_rd, decode2issue_vcc_wr, decode2issue_waitcnt, decode2issue_wf_halt,
      decode2tracemon_colldone, decode2wave_ins_half_rqd, dispatch2cu_wf_dispatch,
      exec2issue_salu_wr_exec_en, exec2issue_salu_wr_m0_en, exec2issue_salu_wr_scc_en,
      exec2issue_salu_wr_vcc_en, exec2issue_valu_wr_vcc_en, exec2salu_rd_scc_value,
      exec2simd_rd_scc_value, exec2simf_rd_scc_value, fetch2buff_rd_en, fetch2exec_init_wf_en,
      fetch2tracemon_dispatch, fetch2wave_basereg_wr, fetch2wave_reserve_valid,
      issue2fetchwave_wf_done_en, issue2lsu_lsu_select, issue2salu_alu_select,
      issue2simd0_alu_select, issue2simd1_alu_select, issue2simd2_alu_select,
      issue2simd3_alu_select, issue2simf0_alu_select, issue2simf1_alu_select,
      issue2simf2_alu_select, issue2simf3_alu_select, issue2tracemon_barrier_retire_en,
      issue2tracemon_waitcnt_retire_en, lsu2issue_ready, lsu2mem_gm_or_lds,
      lsu2sgpr_instr_done, lsu2sgpr_source1_rd_en, lsu2sgpr_source2_rd_en,
      lsu2tracemon_gm_or_lds, lsu2vgpr_instr_done, lsu2vgpr_source1_rd_en,
      lsu2vgpr_source2_rd_en, lsu2rfa_dest_wr_req, mem2lsu_ack, rfa2simd0_queue_entry_serviced,
      rfa2simd1_queue_entry_serviced, rfa2simd2_queue_entry_serviced, rfa2simd3_queue_entry_serviced,
      rfa2simf0_queue_entry_serviced, rfa2simf1_queue_entry_serviced, rfa2simf2_queue_entry_serviced,
      rfa2simf3_queue_entry_serviced, salu2exec_rd_en, salu2exec_wr_exec_en,
      salu2exec_wr_m0_en, salu2exec_wr_scc_en, salu2exec_wr_scc_value, salu2exec_wr_vcc_en,
      salu2fetchwaveissue_branch_en, salu2fetchwaveissue_branch_taken, salu2issue_alu_ready,
      salu2sgpr_instr_done, salu2sgpr_source1_rd_en, salu2sgpr_source2_rd_en,
      sgpr2issue_alu_wr_done, sgpr2issue_lsu_instr_done, sgpr2issue_valu_dest_reg_valid,
      simd0_2exec_rd_en, simd0_2exec_wr_vcc_en, simd0_2issue_alu_ready, simd0_2rfa_queue_entry_valid,
      simd0_2sgpr_rd_en, simd0_2sgpr_wr_en, simd0_2vgpr_instr_done, simd0_2vgpr_source1_rd_en,
      simd0_2vgpr_source2_rd_en, simd0_2vgpr_source3_rd_en, simd0_2vgpr_wr_en,
      simd1_2exec_rd_en, simd1_2exec_wr_vcc_en, simd1_2issue_alu_ready, simd1_2rfa_queue_entry_valid,
      simd1_2sgpr_rd_en, simd1_2sgpr_wr_en, simd1_2vgpr_instr_done, simd1_2vgpr_source1_rd_en,
      simd1_2vgpr_source2_rd_en, simd1_2vgpr_source3_rd_en, simd1_2vgpr_wr_en,
      simd2_2exec_rd_en, simd2_2exec_wr_vcc_en, simd2_2issue_alu_ready, simd2_2rfa_queue_entry_valid,
      simd2_2sgpr_rd_en, simd2_2sgpr_wr_en, simd2_2vgpr_instr_done, simd2_2vgpr_source1_rd_en,
      simd2_2vgpr_source2_rd_en, simd2_2vgpr_source3_rd_en, simd2_2vgpr_wr_en,
      simd3_2exec_rd_en, simd3_2exec_wr_vcc_en, simd3_2issue_alu_ready, simd3_2rfa_queue_entry_valid,
      simd3_2sgpr_rd_en, simd3_2sgpr_wr_en, simd3_2vgpr_instr_done, simd3_2vgpr_source1_rd_en,
      simd3_2vgpr_source2_rd_en, simd3_2vgpr_source3_rd_en, simd3_2vgpr_wr_en,
      simf0_2exec_rd_en, simf0_2exec_wr_vcc_en, simf0_2issue_alu_ready, simf0_2rfa_queue_entry_valid,
      simf0_2sgpr_rd_en, simf0_2sgpr_wr_en, simf0_2vgpr_instr_done, simf0_2vgpr_source1_rd_en,
      simf0_2vgpr_source2_rd_en, simf0_2vgpr_source3_rd_en, simf0_2vgpr_wr_en,
      simf1_2exec_rd_en, simf1_2exec_wr_vcc_en, simf1_2issue_alu_ready, simf1_2rfa_queue_entry_valid,
      simf1_2sgpr_rd_en, simf1_2sgpr_wr_en, simf1_2vgpr_instr_done, simf1_2vgpr_source1_rd_en,
      simf1_2vgpr_source2_rd_en, simf1_2vgpr_source3_rd_en, simf1_2vgpr_wr_en,
      simf2_2exec_rd_en, simf2_2exec_wr_vcc_en, simf2_2issue_alu_ready, simf2_2rfa_queue_entry_valid,
      simf2_2sgpr_rd_en, simf2_2sgpr_wr_en, simf2_2vgpr_instr_done, simf2_2vgpr_source1_rd_en,
      simf2_2vgpr_source2_rd_en, simf2_2vgpr_source3_rd_en, simf2_2vgpr_wr_en,
      simf3_2exec_rd_en, simf3_2exec_wr_vcc_en, simf3_2issue_alu_ready, simf3_2rfa_queue_entry_valid,
      simf3_2sgpr_rd_en, simf3_2sgpr_wr_en, simf3_2vgpr_instr_done, simf3_2vgpr_source1_rd_en,
      simf3_2vgpr_source2_rd_en, simf3_2vgpr_source3_rd_en, simf3_2vgpr_wr_en,
      vgpr2issue_alu_dest_reg_valid, vgpr2issue_alu_wr_done, vgpr2issue_lsu_wr_done,
      wave2decode_instr_valid;
wire [1:0] 	decode2issue_fu, salu2sgpr_dest_wr_en, salu2tracemon_exec_word_sel,
            salu2tracemon_vcc_word_sel, sgpr2issue_alu_dest_reg_valid;
wire [3:0] 	dispatch2cu_wg_wf_count, fetch2issue_wg_wf_count, lsu2mem_rd_en,
            lsu2mem_wr_en, lsu2sgpr_dest_wr_en, lsu2vgpr_dest_wr_en, sgpr2issue_lsu_dest_reg_valid,
            vgpr2issue_lsu_dest_reg_valid;
wire [5:0] 	decode2issue_wfid, decode2wave_ins_half_wfid, dispatch2cu_wf_size_dispatch,
            exec2issue_salu_wr_wfid, exec2issue_valu_wr_vcc_wfid, fetch2exec_init_wf_id,
            fetch2issue_wg_wgid, fetch2tracemon_new_wfid, fetch2wave_basereg_wfid,
            fetch2wave_reserve_slotid, issue2alu_wfid, issue2fetch_wg_wfid, issue2fetchwave_wf_done_wf_id,
            issue2lsu_wfid, issue2tracemon_waitcnt_retire_wfid, lsu2exec_rd_wfid,
            lsu2sgpr_instr_done_wfid, lsu2vgpr_instr_done_wfid, salu2exec_rd_wfid,
            salu2exec_wr_wfid, salu2fetchwaveissue_branch_wfid, salu2sgpr_instr_done_wfid,
            sgpr2issue_alu_wr_done_wfid, sgpr2issue_lsu_instr_done_wfid, simd0_2exec_rd_wfid,
            simd0_2exec_wr_vcc_wfid, simd0_2vgpr_instr_done_wfid, simd1_2exec_rd_wfid,
            simd1_2exec_wr_vcc_wfid, simd1_2vgpr_instr_done_wfid, simd2_2exec_rd_wfid,
            simd2_2exec_wr_vcc_wfid, simd2_2vgpr_instr_done_wfid, simd3_2exec_rd_wfid,
            simd3_2exec_wr_vcc_wfid, simd3_2vgpr_instr_done_wfid, simf0_2exec_rd_wfid,
            simf0_2exec_wr_vcc_wfid, simf0_2vgpr_instr_done_wfid, simf1_2exec_rd_wfid,
            simf1_2exec_wr_vcc_wfid, simf1_2vgpr_instr_done_wfid, simf2_2exec_rd_wfid,
            simf2_2exec_wr_vcc_wfid, simf2_2vgpr_instr_done_wfid, simf3_2exec_rd_wfid,
            simf3_2exec_wr_vcc_wfid, simf3_2vgpr_instr_done_wfid, vgpr2issue_alu_wr_done_wfid,
            vgpr2issue_lsu_wr_done_wfid, wave2decode_wfid;
wire [6:0] 	lsu2mem_tag_req, mem2lsu_tag_resp;
wire [8:0] 	dispatch2cu_sgpr_base_dispatch, fetch2wave_sgpr_base, lsu2sgpr_dest_addr,
            lsu2sgpr_source1_addr, lsu2sgpr_source2_addr, salu2sgpr_dest_addr, salu2sgpr_source1_addr,
            salu2sgpr_source2_addr, sgpr2issue_alu_dest_reg_addr, sgpr2issue_lsu_dest_reg_addr,
            sgpr2issue_valu_dest_addr, simd0_2sgpr_rd_addr, simd0_2sgpr_wr_addr,
            simd1_2sgpr_rd_addr, simd1_2sgpr_wr_addr, simd2_2sgpr_rd_addr, simd2_2sgpr_wr_addr,
            simd3_2sgpr_rd_addr, simd3_2sgpr_wr_addr, simf0_2sgpr_rd_addr, simf0_2sgpr_wr_addr,
            simf1_2sgpr_rd_addr, simf1_2sgpr_wr_addr, simf2_2sgpr_rd_addr, simf2_2sgpr_wr_addr,
            simf3_2sgpr_rd_addr, simf3_2sgpr_wr_addr, wave2decode_sgpr_base;
wire [9:0] 	dispatch2cu_vgpr_base_dispatch, fetch2wave_vgpr_base, lsu2vgpr_dest_addr,
            lsu2vgpr_source1_addr, lsu2vgpr_source2_addr, simd0_2vgpr_dest_addr,
            simd0_2vgpr_source1_addr, simd0_2vgpr_source2_addr, simd0_2vgpr_source3_addr,
            simd1_2vgpr_dest_addr, simd1_2vgpr_source1_addr, simd1_2vgpr_source2_addr,
            simd1_2vgpr_source3_addr, simd2_2vgpr_dest_addr, simd2_2vgpr_source1_addr,
            simd2_2vgpr_source2_addr, simd2_2vgpr_source3_addr, simd3_2vgpr_dest_addr,
            simd3_2vgpr_source1_addr, simd3_2vgpr_source2_addr, simd3_2vgpr_source3_addr,
            simf0_2vgpr_dest_addr, simf0_2vgpr_source1_addr, simf0_2vgpr_source2_addr,
            simf0_2vgpr_source3_addr, simf1_2vgpr_dest_addr, simf1_2vgpr_source1_addr,
            simf1_2vgpr_source2_addr, simf1_2vgpr_source3_addr, simf2_2vgpr_dest_addr,
            simf2_2vgpr_source1_addr, simf2_2vgpr_source2_addr, simf2_2vgpr_source3_addr,
            simf3_2vgpr_dest_addr, simf3_2vgpr_source1_addr, simf3_2vgpr_source2_addr,
            simf3_2vgpr_source3_addr, vgpr2issue_alu_dest_reg_addr, vgpr2issue_lsu_dest_reg_addr,
            wave2decode_vgpr_base;
wire [11:0] issue2alu_dest_reg1, issue2alu_dest_reg2, issue2alu_source_reg1,
            issue2alu_source_reg2, issue2alu_source_reg3, issue2lsu_dest_reg, issue2lsu_mem_sgpr,
            issue2lsu_source_reg1, issue2lsu_source_reg2, issue2lsu_source_reg3;
wire [12:0] decode2issue_dest_reg2, decode2issue_source_reg2, decode2issue_source_reg3;
wire [13:0] decode2issue_dest_reg1, decode2issue_source_reg1, decode2issue_source_reg4;
wire [14:0] cu2dispatch_wf_tag_done, dispatch2cu_wf_tag_dispatch, fetch2tracemon_wf_tag;
wire [15:0] decode2issue_imm_value0, decode2issue_lds_base, dispatch2cu_lds_base_dispatch,
            fetch2wave_lds_base, issue2alu_imm_value0, issue2lsu_imm_value0, issue2lsu_lds_base,
            rfa2execvgprsgpr_select_fu, wave2decode_lds_base;
wire [31:0] buff2wave_instr, decode2issue_imm_value1, decode2issue_instr_pc,
            decode2issue_opcode, dispatch2cu_start_pc_dispatch, exec2lsu_rd_m0_value,
            exec2salu_rd_m0_value, exec2simd_rd_m0_value, exec2simf_rd_m0_value,
            fetch2buff_addr, issue2alu_imm_value1, issue2alu_instr_pc, issue2alu_opcode,
            issue2lsu_imm_value1, issue2lsu_instr_pc, issue2lsu_opcode, issue2tracemon_barrier_retire_pc,
            issue2tracemon_waitcnt_retire_pc, lsu2tracemon_retire_pc, salu2exec_wr_m0_value,
            salu2fetch_branch_pc_value, salu2tracemon_retire_pc, sgpr2lsu_source2_data,
            sgpr2simd_rd_data, sgpr2simf_rd_data, simd0_2tracemon_retire_pc, simd1_2tracemon_retire_pc,
            simd2_2tracemon_retire_pc, simd3_2tracemon_retire_pc, simf0_2tracemon_retire_pc,
            simf1_2tracemon_retire_pc, simf2_2tracemon_retire_pc, simf3_2tracemon_retire_pc,
            wave2decode_instr, wave2decode_instr_pc;
wire [38:0] buff2wave_tag, fetch2buff_tag;
wire [39:0] issue2tracemon_barrier_retire_wf_bitmap, issue2wave_valid_entries,
            wave2fetch_stop_fetch;
wire [63:0] decode2tracemon_collinstr, exec2lsu_exec_value, exec2salu_rd_exec_value,
            exec2salu_rd_vcc_value, exec2simd_rd_exec_value, exec2simd_rd_vcc_value,
            exec2simf_rd_exec_value, exec2simf_rd_vcc_value, fetch2exec_init_value,
            lsu2mem_wr_mask, lsu2vgpr_dest_wr_mask, salu2exec_wr_exec_value, salu2exec_wr_vcc_value,
            salu2sgpr_dest_data, sgpr2salu_source1_data, sgpr2salu_source2_data,
            simd0_2exec_wr_vcc_value, simd0_2sgpr_wr_data, simd0_2sgpr_wr_mask,
            simd0_2vgpr_wr_mask, simd1_2exec_wr_vcc_value, simd1_2sgpr_wr_data,
            simd1_2sgpr_wr_mask, simd1_2vgpr_wr_mask, simd2_2exec_wr_vcc_value,
            simd2_2sgpr_wr_data, simd2_2sgpr_wr_mask, simd2_2vgpr_wr_mask, simd3_2exec_wr_vcc_value,
            simd3_2sgpr_wr_data, simd3_2sgpr_wr_mask, simd3_2vgpr_wr_mask, simf0_2exec_wr_vcc_value,
            simf0_2sgpr_wr_data, simf0_2sgpr_wr_mask, simf0_2vgpr_wr_mask, simf1_2exec_wr_vcc_value,
            simf1_2sgpr_wr_data, simf1_2sgpr_wr_mask, simf1_2vgpr_wr_mask, simf2_2exec_wr_vcc_value,
            simf2_2sgpr_wr_data, simf2_2sgpr_wr_mask, simf2_2vgpr_wr_mask, simf3_2exec_wr_vcc_value,
            simf3_2sgpr_wr_data, simf3_2sgpr_wr_mask, simf3_2vgpr_wr_mask;
wire [127:0]    lsu2sgpr_dest_data, sgpr2lsu_source1_data;
wire [2047:0]   simd0_2vgpr_dest_data, simd1_2vgpr_dest_data,
                simd2_2vgpr_dest_data, simd3_2vgpr_dest_data, simf0_2vgpr_dest_data,
                simf1_2vgpr_dest_data, simf2_2vgpr_dest_data, simf3_2vgpr_dest_data,
                vgpr2lsu_source2_data, vgpr2simd_source1_data, vgpr2simd_source2_data,
                vgpr2simd_source3_data, vgpr2simf_source1_data, vgpr2simf_source2_data,
                vgpr2simf_source3_data;

wire salu_request, lsu_stall;
wire [31:0]   lsu2mem_wr_data, mem2lsu_rd_data, lsu2mem_addr;
wire [2047:0] lsu2vgpr_dest_data, vgpr2lsu_source1_data;

wire [9:0] lsu2sgpr_source1_addr_thru;
wire [9:0] lsu2sgpr_dest_addr_thru;
wire [127:0] lsu2sgpr_dest_data_thru;
wire lsu2sgpr_source1_rd_en_thru;

wire lsu2vgpr_source1_rd_en_thru;
wire [9:0] lsu2vgpr_source1_addr_thru;

assign dispatch2cu_vgpr_base_dispatch = baseVGPR_out[9:0];
assign dispatch2cu_sgpr_base_dispatch = baseSGPR_out[8:0];
assign dispatch2cu_lds_base_dispatch = baseLDS_out[15:0];
assign dispatch2cu_wf_size_dispatch = waveCount_out[5:0];
assign dispatch2cu_start_pc_dispatch = pcStart_out;
assign dispatch2cu_wg_wf_count = 4'd1;
assign dispatch2cu_wf_tag_dispatch = waveID_out[14:0];
assign dispatch2cu_wf_dispatch = executeStart_out;

assign rst_signal = ~reset_out;

assign cu2dispatch_wf_done_in = cu2dispatch_wf_done;

assign quadData_in = sgpr2lsu_source1_data;
assign singleVectorData_in = vgpr2lsu_source1_data;
// I/O Connections assignments

assign buff2wave_tag = fetch2buff_tag_reg;
assign buff2fetchwave_ack = fetch2buff_rd_en_reg;
assign buff2wave_instr = instruction_buff_out_b;

always @( posedge clk) begin
  fetch2buff_tag_reg <= fetch2buff_tag;
  fetch2buff_rd_en_reg <= fetch2buff_rd_en;
  //buff2wave_instr_reg <= instruction_buff_out_b;
end

assign pc_value = fetch2buff_addr;

block_ram instruction_buffer
(
  .clka(clk), // input clka
  //.rsta(rst), // input rsta
  .wea(instrBuffWrEn_out[0]), // input [3 : 0] wea
  .addra(instrAddrReg_out[9:0]), // input [31 : 0] addra
  .dina(axi_data_out), // input [31 : 0] dina
  .douta(instruction_buff_out_a_in), // output [31 : 0] douta
  .clkb(clk), // input clkb
  //.rstb(rst), // input rstb
  .web(1'b0), // input [3 : 0] web
  .addrb(fetch2buff_addr[11:2]), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(instruction_buff_out_b) // output [31 : 0] doutb
);

assign sgpr_select_fu = execute_out ? rfa2execvgprsgpr_select_fu : {7'd0, lsu2sgpr_dest_wr_en_thru[0], 8'd0};

assign lsu2sgpr_source1_addr_thru = execute_out ? lsu2sgpr_source1_addr : quadBaseAddress_out;
assign lsu2sgpr_dest_addr_thru = execute_out ? lsu2sgpr_dest_addr : quadBaseAddress_out;

assign lsu2sgpr_source1_rd_en_thru = execute_out ? lsu2sgpr_source1_rd_en : ~(|lsu2sgpr_dest_wr_en_out);
assign lsu2sgpr_dest_wr_en_thru = execute_out ? lsu2sgpr_dest_wr_en : lsu2sgpr_dest_wr_en_out;
assign lsu2sgpr_dest_data_thru = execute_out ? lsu2sgpr_dest_data : {quadData3_out, quadData2_out, quadData1_out, quadData0_out};

assign lsu2vgpr_source1_rd_en_thru = execute_out ? lsu2vgpr_source1_rd_en : 1'b1;
assign lsu2vgpr_source1_addr_thru  = execute_out ? lsu2vgpr_source1_addr : singleVectorBaseAddress_out;

fetch fetch0 (
  // Unit that fetches instructions from a wavefront chosen by the wavepool
  .clk(clk),
  .rst(rst_signal),
  //  Inputs
  .dispatch2cu_wf_dispatch(dispatch2cu_wf_dispatch),
  .dispatch2cu_wf_tag_dispatch(dispatch2cu_wf_tag_dispatch),
  .dispatch2cu_start_pc_dispatch(dispatch2cu_start_pc_dispatch),
  .dispatch2cu_vgpr_base_dispatch(dispatch2cu_vgpr_base_dispatch),
  .dispatch2cu_sgpr_base_dispatch(dispatch2cu_sgpr_base_dispatch),
  .dispatch2cu_lds_base_dispatch(dispatch2cu_lds_base_dispatch),
  .dispatch2cu_wf_size_dispatch(dispatch2cu_wf_size_dispatch),
  .dispatch2cu_wg_wf_count(dispatch2cu_wg_wf_count),
  .buff_ack(buff2fetchwave_ack),
  .wave_stop_fetch(wave2fetch_stop_fetch),
  .issue_wf_done_en(issue2fetchwave_wf_done_en),
  .issue_wf_done_wf_id(issue2fetchwave_wf_done_wf_id),
  .issue_wg_wfid(issue2fetch_wg_wfid),
  .salu_branch_wfid(salu2fetchwaveissue_branch_wfid),
  .salu_branch_en(salu2fetchwaveissue_branch_en),
  .salu_branch_taken(salu2fetchwaveissue_branch_taken),
  .salu_branch_pc_value(salu2fetch_branch_pc_value),
  //  Outputs
  .cu2dispatch_wf_tag_done(cu2dispatch_wf_tag_done),
  .cu2dispatch_wf_done(cu2dispatch_wf_done),
  .buff_addr(fetch2buff_addr),
  .buff_tag(fetch2buff_tag),
  .buff_rd_en(fetch2buff_rd_en),
  .wave_reserve_slotid(fetch2wave_reserve_slotid),
  .wave_reserve_valid(fetch2wave_reserve_valid),
  .wave_basereg_wr(fetch2wave_basereg_wr),
  .wave_basereg_wfid(fetch2wave_basereg_wfid),
  .wave_vgpr_base(fetch2wave_vgpr_base),
  .wave_sgpr_base(fetch2wave_sgpr_base),
  .wave_lds_base(fetch2wave_lds_base),
  .exec_init_wf_en(fetch2exec_init_wf_en),
  .exec_init_wf_id(fetch2exec_init_wf_id),
  .exec_init_value(fetch2exec_init_value),
  .issue_wg_wgid(fetch2issue_wg_wgid),
  .issue_wg_wf_count(fetch2issue_wg_wf_count),
  .tracemon_dispatch(fetch2tracemon_dispatch),
  .tracemon_wf_tag_dispatch(fetch2tracemon_wf_tag),
  .tracemon_new_wfid(fetch2tracemon_new_wfid)
);

  vgpr vgpr0 (
  // A set of vector general purpose registers
  .clk(clk),
  .rst(rst_signal),
  //  Inputs
  .simd0_source1_rd_en(simd0_2vgpr_source1_rd_en),
  .simd1_source1_rd_en(simd1_2vgpr_source1_rd_en),
  .simd2_source1_rd_en(simd2_2vgpr_source1_rd_en),
  .simd3_source1_rd_en(simd3_2vgpr_source1_rd_en),
  .simd0_source2_rd_en(simd0_2vgpr_source2_rd_en),
  .simd1_source2_rd_en(simd1_2vgpr_source2_rd_en),
  .simd2_source2_rd_en(simd2_2vgpr_source2_rd_en),
  .simd3_source2_rd_en(simd3_2vgpr_source2_rd_en),
  .simd0_source3_rd_en(simd0_2vgpr_source3_rd_en),
  .simd1_source3_rd_en(simd1_2vgpr_source3_rd_en),
  .simd2_source3_rd_en(simd2_2vgpr_source3_rd_en),
  .simd3_source3_rd_en(simd3_2vgpr_source3_rd_en),
  .simd0_source1_addr(simd0_2vgpr_source1_addr),
  .simd1_source1_addr(simd1_2vgpr_source1_addr),
  .simd2_source1_addr(simd2_2vgpr_source1_addr),
  .simd3_source1_addr(simd3_2vgpr_source1_addr),
  .simd0_source2_addr(simd0_2vgpr_source2_addr),
  .simd1_source2_addr(simd1_2vgpr_source2_addr),
  .simd2_source2_addr(simd2_2vgpr_source2_addr),
  .simd3_source2_addr(simd3_2vgpr_source2_addr),
  .simd0_source3_addr(simd0_2vgpr_source3_addr),
  .simd1_source3_addr(simd1_2vgpr_source3_addr),
  .simd2_source3_addr(simd2_2vgpr_source3_addr),
  .simd3_source3_addr(simd3_2vgpr_source3_addr),
  .simd0_dest_addr(simd0_2vgpr_dest_addr),
  .simd1_dest_addr(simd1_2vgpr_dest_addr),
  .simd2_dest_addr(simd2_2vgpr_dest_addr),
  .simd3_dest_addr(simd3_2vgpr_dest_addr),
  .simd0_dest_data(simd0_2vgpr_dest_data),
  .simd1_dest_data(simd1_2vgpr_dest_data),
  .simd2_dest_data(simd2_2vgpr_dest_data),
  .simd3_dest_data(simd3_2vgpr_dest_data),
  .simd0_wr_en(simd0_2vgpr_wr_en),
  .simd1_wr_en(simd1_2vgpr_wr_en),
  .simd2_wr_en(simd2_2vgpr_wr_en),
  .simd3_wr_en(simd3_2vgpr_wr_en),
  .simd0_wr_mask(simd0_2vgpr_wr_mask),
  .simd1_wr_mask(simd1_2vgpr_wr_mask),
  .simd2_wr_mask(simd2_2vgpr_wr_mask),
  .simd3_wr_mask(simd3_2vgpr_wr_mask),
  .simf0_source1_rd_en(simf0_2vgpr_source1_rd_en),
  .simf1_source1_rd_en(simf1_2vgpr_source1_rd_en),
  .simf2_source1_rd_en(simf2_2vgpr_source1_rd_en),
  .simf3_source1_rd_en(simf3_2vgpr_source1_rd_en),
  .simf0_source2_rd_en(simf0_2vgpr_source2_rd_en),
  .simf1_source2_rd_en(simf1_2vgpr_source2_rd_en),
  .simf2_source2_rd_en(simf2_2vgpr_source2_rd_en),
  .simf3_source2_rd_en(simf3_2vgpr_source2_rd_en),
  .simf0_source3_rd_en(simf0_2vgpr_source3_rd_en),
  .simf1_source3_rd_en(simf1_2vgpr_source3_rd_en),
  .simf2_source3_rd_en(simf2_2vgpr_source3_rd_en),
  .simf3_source3_rd_en(simf3_2vgpr_source3_rd_en),
  .simf0_source1_addr(simf0_2vgpr_source1_addr),
  .simf1_source1_addr(simf1_2vgpr_source1_addr),
  .simf2_source1_addr(simf2_2vgpr_source1_addr),
  .simf3_source1_addr(simf3_2vgpr_source1_addr),
  .simf0_source2_addr(simf0_2vgpr_source2_addr),
  .simf1_source2_addr(simf1_2vgpr_source2_addr),
  .simf2_source2_addr(simf2_2vgpr_source2_addr),
  .simf3_source2_addr(simf3_2vgpr_source2_addr),
  .simf0_source3_addr(simf0_2vgpr_source3_addr),
  .simf1_source3_addr(simf1_2vgpr_source3_addr),
  .simf2_source3_addr(simf2_2vgpr_source3_addr),
  .simf3_source3_addr(simf3_2vgpr_source3_addr),
  .simf0_dest_addr(simf0_2vgpr_dest_addr),
  .simf1_dest_addr(simf1_2vgpr_dest_addr),
  .simf2_dest_addr(simf2_2vgpr_dest_addr),
  .simf3_dest_addr(simf3_2vgpr_dest_addr),
  .simf0_dest_data(simf0_2vgpr_dest_data),
  .simf1_dest_data(simf1_2vgpr_dest_data),
  .simf2_dest_data(simf2_2vgpr_dest_data),
  .simf3_dest_data(simf3_2vgpr_dest_data),
  .simf0_wr_en(simf0_2vgpr_wr_en),
  .simf1_wr_en(simf1_2vgpr_wr_en),
  .simf2_wr_en(simf2_2vgpr_wr_en),
  .simf3_wr_en(simf3_2vgpr_wr_en),
  .simf0_wr_mask(simf0_2vgpr_wr_mask),
  .simf1_wr_mask(simf1_2vgpr_wr_mask),
  .simf2_wr_mask(simf2_2vgpr_wr_mask),
  .simf3_wr_mask(simf3_2vgpr_wr_mask),
  .lsu_source1_addr(lsu2vgpr_source1_addr_thru),
  .lsu_source2_addr(lsu2vgpr_source2_addr),
  .lsu_dest_addr(lsu2vgpr_dest_addr),
  .lsu_dest_data(lsu2vgpr_dest_data),
  .lsu_dest_wr_en(lsu2vgpr_dest_wr_en),
  .lsu_dest_wr_mask(lsu2vgpr_dest_wr_mask),
  .lsu_instr_done_wfid(lsu2vgpr_instr_done_wfid),
  .lsu_instr_done(lsu2vgpr_instr_done),
  .lsu_source1_rd_en(lsu2vgpr_source1_rd_en_thru),
  .lsu_source2_rd_en(lsu2vgpr_source2_rd_en),
  .simd0_instr_done_wfid(simd0_2vgpr_instr_done_wfid),
  .simd1_instr_done_wfid(simd1_2vgpr_instr_done_wfid),
  .simd2_instr_done_wfid(simd2_2vgpr_instr_done_wfid),
  .simd3_instr_done_wfid(simd3_2vgpr_instr_done_wfid),
  .simd0_instr_done(simd0_2vgpr_instr_done),
  .simd1_instr_done(simd1_2vgpr_instr_done),
  .simd2_instr_done(simd2_2vgpr_instr_done),
  .simd3_instr_done(simd3_2vgpr_instr_done),
  .simf0_instr_done_wfid(simf0_2vgpr_instr_done_wfid),
  .simf1_instr_done_wfid(simf1_2vgpr_instr_done_wfid),
  .simf2_instr_done_wfid(simf2_2vgpr_instr_done_wfid),
  .simf3_instr_done_wfid(simf3_2vgpr_instr_done_wfid),
  .simf0_instr_done(simf0_2vgpr_instr_done),
  .simf1_instr_done(simf1_2vgpr_instr_done),
  .simf2_instr_done(simf2_2vgpr_instr_done),
  .simf3_instr_done(simf3_2vgpr_instr_done),
  .rfa_select_fu(rfa2execvgprsgpr_select_fu),
  //  Outputs
  .simd_source1_data(vgpr2simd_source1_data),
  .simd_source2_data(vgpr2simd_source2_data),
  .simd_source3_data(vgpr2simd_source3_data),
  .simf_source1_data(vgpr2simf_source1_data),
  .simf_source2_data(vgpr2simf_source2_data),
  .simf_source3_data(vgpr2simf_source3_data),
  .lsu_source1_data(vgpr2lsu_source1_data),
  .lsu_source2_data(vgpr2lsu_source2_data),
  .issue_alu_wr_done_wfid(vgpr2issue_alu_wr_done_wfid),
  .issue_alu_wr_done(vgpr2issue_alu_wr_done),
  .issue_alu_dest_reg_addr(vgpr2issue_alu_dest_reg_addr),
  .issue_alu_dest_reg_valid(vgpr2issue_alu_dest_reg_valid),
  .issue_lsu_wr_done_wfid(vgpr2issue_lsu_wr_done_wfid),
  .issue_lsu_wr_done(vgpr2issue_lsu_wr_done),
  .issue_lsu_dest_reg_addr(vgpr2issue_lsu_dest_reg_addr),
  .issue_lsu_dest_reg_valid(vgpr2issue_lsu_dest_reg_valid)
  );

wavepool wavepool0 (
  // Unit that choses wavefronts fetched and keeps control of a instruction queue.
  .clk(clk),
  .rst(rst_signal),
  //  Inputs
  .fetch_reserve_slotid(fetch2wave_reserve_slotid),
  .fetch_reserve_valid(fetch2wave_reserve_valid),
  .fetch_basereg_wr(fetch2wave_basereg_wr),
  .fetch_basereg_wfid(fetch2wave_basereg_wfid),
  .fetch_vgpr_base(fetch2wave_vgpr_base),
  .fetch_sgpr_base(fetch2wave_sgpr_base),
  .fetch_lds_base(fetch2wave_lds_base),
  .issue_valid_entries(issue2wave_valid_entries),
  .buff_tag(buff2wave_tag),
  .buff_instr(buff2wave_instr),
  .buff2fetchwave_ack(buff2fetchwave_ack),
  .issue_wf_done_en(issue2fetchwave_wf_done_en),
  .issue_wf_done_wf_id(issue2fetchwave_wf_done_wf_id),
  .salu_branch_wfid(salu2fetchwaveissue_branch_wfid),
  .salu_branch_en(salu2fetchwaveissue_branch_en),
  .salu_branch_taken(salu2fetchwaveissue_branch_taken),
  .decode_ins_half_rqd(decode2wave_ins_half_rqd),
  .decode_ins_half_wfid(decode2wave_ins_half_wfid),
  //  Outputs
  .fetch_stop_fetch(wave2fetch_stop_fetch),
  .decode_instr_valid(wave2decode_instr_valid),
  .decode_instr(wave2decode_instr),
  .decode_wfid(wave2decode_wfid),
  .decode_vgpr_base(wave2decode_vgpr_base),
  .decode_sgpr_base(wave2decode_sgpr_base),
  .decode_lds_base(wave2decode_lds_base),
  .decode_instr_pc(wave2decode_instr_pc)
);

decode decode0 (
  // Unit that decodes instructions and passes them to issue.
  .clk(clk),
  .rst(rst_signal),
  //  Inputs
  .wave_instr_pc(wave2decode_instr_pc),
  .wave_instr_valid(wave2decode_instr_valid),
  .wave_instr(wave2decode_instr),
  .wave_wfid(wave2decode_wfid),
  .wave_vgpr_base(wave2decode_vgpr_base),
  .wave_sgpr_base(wave2decode_sgpr_base),
  .wave_lds_base(wave2decode_lds_base),
  //  Outputs
  .issue_wf_halt(decode2issue_wf_halt),
  .issue_fu(decode2issue_fu),
  .issue_wfid(decode2issue_wfid),
  .issue_opcode(decode2issue_opcode),
  .issue_source_reg1(decode2issue_source_reg1),
  .issue_source_reg2(decode2issue_source_reg2),
  .issue_source_reg3(decode2issue_source_reg3),
  .issue_source_reg4(decode2issue_source_reg4),
  .issue_dest_reg1(decode2issue_dest_reg1),
  .issue_dest_reg2(decode2issue_dest_reg2),
  .issue_imm_value0(decode2issue_imm_value0),
  .issue_imm_value1(decode2issue_imm_value1),
  .issue_valid(decode2issue_valid),
  .issue_instr_pc(decode2issue_instr_pc),
  .issue_vcc_wr(decode2issue_vcc_wr),
  .issue_vcc_rd(decode2issue_vcc_rd),
  .issue_scc_wr(decode2issue_scc_wr),
  .issue_scc_rd(decode2issue_scc_rd),
  .issue_exec_rd(decode2issue_exec_rd),
  .issue_exec_wr(decode2issue_exec_wr),
  .issue_m0_rd(decode2issue_m0_rd),
  .issue_m0_wr(decode2issue_m0_wr),
  .issue_barrier(decode2issue_barrier),
  .issue_branch(decode2issue_branch),
  .issue_lds_base(decode2issue_lds_base),
  .issue_waitcnt(decode2issue_waitcnt),
  .wave_ins_half_rqd(decode2wave_ins_half_rqd),
  .wave_ins_half_wfid(decode2wave_ins_half_wfid),
  .tracemon_collinstr(decode2tracemon_collinstr),
  .tracemon_colldone(decode2tracemon_colldone)
);

issue issue0 (
  // Unit that does scoreboarding and choses from which wavefront to issue at a cycle.
  .clk(clk),
  .rst(rst_signal),
  //  Inputs
  .decode_branch(decode2issue_branch),
  .decode_barrier(decode2issue_barrier),
  .decode_vcc_wr(decode2issue_vcc_wr),
  .decode_vcc_rd(decode2issue_vcc_rd),
  .decode_scc_wr(decode2issue_scc_wr),
  .decode_scc_rd(decode2issue_scc_rd),
  .decode_exec_rd(decode2issue_exec_rd),
  .decode_exec_wr(decode2issue_exec_wr),
  .decode_m0_rd(decode2issue_m0_rd),
  .decode_m0_wr(decode2issue_m0_wr),
  .decode_instr_pc(decode2issue_instr_pc),
  .decode_wf_halt(decode2issue_wf_halt),
  .decode_fu(decode2issue_fu),
  .decode_wfid(decode2issue_wfid),
  .decode_opcode(decode2issue_opcode),
  .decode_source_reg1(decode2issue_source_reg1),
  .decode_source_reg2(decode2issue_source_reg2),
  .decode_source_reg3(decode2issue_source_reg3),
  .decode_source_reg4(decode2issue_source_reg4),
  .decode_dest_reg1(decode2issue_dest_reg1),
  .decode_dest_reg2(decode2issue_dest_reg2),
  .decode_imm_value0(decode2issue_imm_value0),
  .decode_imm_value1(decode2issue_imm_value1),
  .decode_lds_base(decode2issue_lds_base),
  .decode_waitcnt(decode2issue_waitcnt),
  .decode_valid(decode2issue_valid),
  .vgpr_alu_wr_done_wfid(vgpr2issue_alu_wr_done_wfid),
  .vgpr_alu_wr_done(vgpr2issue_alu_wr_done),
  .vgpr_alu_dest_reg_addr(vgpr2issue_alu_dest_reg_addr),
  .vgpr_alu_dest_reg_valid(vgpr2issue_alu_dest_reg_valid),
  .vgpr_lsu_wr_done_wfid(vgpr2issue_lsu_wr_done_wfid),
  .vgpr_lsu_wr_done(vgpr2issue_lsu_wr_done),
  .vgpr_lsu_dest_reg_addr(vgpr2issue_lsu_dest_reg_addr),
  .vgpr_lsu_dest_reg_valid(vgpr2issue_lsu_dest_reg_valid),
  .sgpr_alu_wr_done_wfid(sgpr2issue_alu_wr_done_wfid),
  .sgpr_alu_wr_done(sgpr2issue_alu_wr_done),
  .sgpr_alu_dest_reg_addr(sgpr2issue_alu_dest_reg_addr),
  .sgpr_alu_dest_reg_valid(sgpr2issue_alu_dest_reg_valid),
  .sgpr_lsu_instr_done_wfid(sgpr2issue_lsu_instr_done_wfid),
  .sgpr_lsu_instr_done(sgpr2issue_lsu_instr_done),
  .sgpr_lsu_dest_reg_addr(sgpr2issue_lsu_dest_reg_addr),
  .sgpr_lsu_dest_reg_valid(sgpr2issue_lsu_dest_reg_valid),
  .sgpr_valu_dest_reg_valid(sgpr2issue_valu_dest_reg_valid),
  .sgpr_valu_dest_addr(sgpr2issue_valu_dest_addr),
  .simd0_alu_ready(simd0_2issue_alu_ready),
  .simd1_alu_ready(simd1_2issue_alu_ready),
  .simd2_alu_ready(simd2_2issue_alu_ready),
  .simd3_alu_ready(simd3_2issue_alu_ready),
  .simf0_alu_ready(simf0_2issue_alu_ready),
  .simf1_alu_ready(simf1_2issue_alu_ready),
  .simf2_alu_ready(simf2_2issue_alu_ready),
  .simf3_alu_ready(simf3_2issue_alu_ready),
  .salu_alu_ready(salu2issue_alu_ready),
  .lsu_ready(lsu2issue_ready),
  .exec_salu_wr_wfid(exec2issue_salu_wr_wfid),
  .exec_salu_wr_vcc_en(exec2issue_salu_wr_vcc_en),
  .exec_salu_wr_exec_en(exec2issue_salu_wr_exec_en),
  .exec_salu_wr_scc_en(exec2issue_salu_wr_scc_en),
  .exec_salu_wr_m0_en(exec2issue_salu_wr_m0_en),
  .exec_valu_wr_vcc_wfid(exec2issue_valu_wr_vcc_wfid),
  .exec_valu_wr_vcc_en(exec2issue_valu_wr_vcc_en),
  .fetch_wg_wgid(fetch2issue_wg_wgid),
  .fetch_wg_wf_count(fetch2issue_wg_wf_count),
  .salu_branch_wfid(salu2fetchwaveissue_branch_wfid),
  .salu_branch_en(salu2fetchwaveissue_branch_en),
  .salu_branch_taken(salu2fetchwaveissue_branch_taken),
  //  Outputs
  .wave_valid_entries(issue2wave_valid_entries),
  .salu_alu_select(issue2salu_alu_select),
  .simd0_alu_select(issue2simd0_alu_select),
  .simd1_alu_select(issue2simd1_alu_select),
  .simd2_alu_select(issue2simd2_alu_select),
  .simd3_alu_select(issue2simd3_alu_select),
  .simf0_alu_select(issue2simf0_alu_select),
  .simf1_alu_select(issue2simf1_alu_select),
  .simf2_alu_select(issue2simf2_alu_select),
  .simf3_alu_select(issue2simf3_alu_select),
  .lsu_lsu_select(issue2lsu_lsu_select),
  .lsu_source_reg1(issue2lsu_source_reg1),
  .lsu_source_reg2(issue2lsu_source_reg2),
  .lsu_source_reg3(issue2lsu_source_reg3),
  .lsu_dest_reg(issue2lsu_dest_reg),
  .lsu_imm_value0(issue2lsu_imm_value0),
  .lsu_imm_value1(issue2lsu_imm_value1),
  .lsu_opcode(issue2lsu_opcode),
  .lsu_mem_sgpr(issue2lsu_mem_sgpr),
  .lsu_wfid(issue2lsu_wfid),
  .lsu_lds_base(issue2lsu_lds_base),
  .alu_source_reg1(issue2alu_source_reg1),
  .alu_source_reg2(issue2alu_source_reg2),
  .alu_source_reg3(issue2alu_source_reg3),
  .alu_dest_reg1(issue2alu_dest_reg1),
  .alu_dest_reg2(issue2alu_dest_reg2),
  .alu_imm_value0(issue2alu_imm_value0),
  .alu_imm_value1(issue2alu_imm_value1),
  .alu_opcode(issue2alu_opcode),
  .alu_wfid(issue2alu_wfid),
  .alu_instr_pc(issue2alu_instr_pc),
  .lsu_instr_pc(issue2lsu_instr_pc),
  .fetchwave_wf_done_en(issue2fetchwave_wf_done_en),
  .fetchwave_wf_done_wf_id(issue2fetchwave_wf_done_wf_id),
  .fetch_wg_wfid(issue2fetch_wg_wfid),
  .tracemon_barrier_retire_en(issue2tracemon_barrier_retire_en),
  .tracemon_barrier_retire_wf_bitmap(issue2tracemon_barrier_retire_wf_bitmap),
  .tracemon_barrier_retire_pc(issue2tracemon_barrier_retire_pc),
  .tracemon_waitcnt_retire_en(issue2tracemon_waitcnt_retire_en),
  .tracemon_waitcnt_retire_wfid(issue2tracemon_waitcnt_retire_wfid),
  .tracemon_waitcnt_retire_pc(issue2tracemon_waitcnt_retire_pc)
);

exec exec0 (
  // Exec flag, used to choose which wave items inside a wavefront will retire and which will not.
  .clk(clk),
  .rst(rst_signal),
  //  Inputs
  .lsu_rd_wfid(lsu2exec_rd_wfid),
  .salu_wr_exec_en(salu2exec_wr_exec_en),
  .salu_wr_vcc_en(salu2exec_wr_vcc_en),
  .salu_wr_exec_value(salu2exec_wr_exec_value),
  .salu_wr_vcc_value(salu2exec_wr_vcc_value),
  .salu_wr_wfid(salu2exec_wr_wfid),
  .salu_rd_en(salu2exec_rd_en),
  .salu_rd_wfid(salu2exec_rd_wfid),
  .salu_wr_m0_en(salu2exec_wr_m0_en),
  .salu_wr_m0_value(salu2exec_wr_m0_value),
  .salu_wr_scc_en(salu2exec_wr_scc_en),
  .salu_wr_scc_value(salu2exec_wr_scc_value),
  .simd0_rd_wfid(simd0_2exec_rd_wfid),
  .simd1_rd_wfid(simd1_2exec_rd_wfid),
  .simd2_rd_wfid(simd2_2exec_rd_wfid),
  .simd3_rd_wfid(simd3_2exec_rd_wfid),
  .simd0_rd_en(simd0_2exec_rd_en),
  .simd1_rd_en(simd1_2exec_rd_en),
  .simd2_rd_en(simd2_2exec_rd_en),
  .simd3_rd_en(simd3_2exec_rd_en),
  .simd0_vcc_wr_wfid(simd0_2exec_wr_vcc_wfid),
  .simd1_vcc_wr_wfid(simd1_2exec_wr_vcc_wfid),
  .simd2_vcc_wr_wfid(simd2_2exec_wr_vcc_wfid),
  .simd3_vcc_wr_wfid(simd3_2exec_wr_vcc_wfid),
  .simd0_vcc_wr_en(simd0_2exec_wr_vcc_en),
  .simd1_vcc_wr_en(simd1_2exec_wr_vcc_en),
  .simd2_vcc_wr_en(simd2_2exec_wr_vcc_en),
  .simd3_vcc_wr_en(simd3_2exec_wr_vcc_en),
  .simd0_vcc_value(simd0_2exec_wr_vcc_value),
  .simd1_vcc_value(simd1_2exec_wr_vcc_value),
  .simd2_vcc_value(simd2_2exec_wr_vcc_value),
  .simd3_vcc_value(simd3_2exec_wr_vcc_value),
  .simf0_rd_wfid(simf0_2exec_rd_wfid),
  .simf1_rd_wfid(simf1_2exec_rd_wfid),
  .simf2_rd_wfid(simf2_2exec_rd_wfid),
  .simf3_rd_wfid(simf3_2exec_rd_wfid),
  .simf0_rd_en(simf0_2exec_rd_en),
  .simf1_rd_en(simf1_2exec_rd_en),
  .simf2_rd_en(simf2_2exec_rd_en),
  .simf3_rd_en(simf3_2exec_rd_en),
  .simf0_vcc_wr_wfid(simf0_2exec_wr_vcc_wfid),
  .simf1_vcc_wr_wfid(simf1_2exec_wr_vcc_wfid),
  .simf2_vcc_wr_wfid(simf2_2exec_wr_vcc_wfid),
  .simf3_vcc_wr_wfid(simf3_2exec_wr_vcc_wfid),
  .simf0_vcc_wr_en(simf0_2exec_wr_vcc_en),
  .simf1_vcc_wr_en(simf1_2exec_wr_vcc_en),
  .simf2_vcc_wr_en(simf2_2exec_wr_vcc_en),
  .simf3_vcc_wr_en(simf3_2exec_wr_vcc_en),
  .simf0_vcc_value(simf0_2exec_wr_vcc_value),
  .simf1_vcc_value(simf1_2exec_wr_vcc_value),
  .simf2_vcc_value(simf2_2exec_wr_vcc_value),
  .simf3_vcc_value(simf3_2exec_wr_vcc_value),
  .fetch_init_wf_en(fetch2exec_init_wf_en),
  .fetch_init_wf_id(fetch2exec_init_wf_id),
  .fetch_init_value(fetch2exec_init_value),
  .rfa_select_fu(rfa2execvgprsgpr_select_fu),
  //  Outputs
  .lsu_exec_value(exec2lsu_exec_value),
  .lsu_rd_m0_value(exec2lsu_rd_m0_value),
  .simd_rd_exec_value(exec2simd_rd_exec_value),
  .simd_rd_vcc_value(exec2simd_rd_vcc_value),
  .simd_rd_m0_value(exec2simd_rd_m0_value),
  .simd_rd_scc_value(exec2simd_rd_scc_value),
  .simf_rd_exec_value(exec2simf_rd_exec_value),
  .simf_rd_vcc_value(exec2simf_rd_vcc_value),
  .simf_rd_m0_value(exec2simf_rd_m0_value),
  .simf_rd_scc_value(exec2simf_rd_scc_value),
  .salu_rd_exec_value(exec2salu_rd_exec_value),
  .salu_rd_vcc_value(exec2salu_rd_vcc_value),
  .salu_rd_m0_value(exec2salu_rd_m0_value),
  .salu_rd_scc_value(exec2salu_rd_scc_value),
  .issue_salu_wr_vcc_wfid(exec2issue_salu_wr_wfid),
  .issue_salu_wr_vcc_en(exec2issue_salu_wr_vcc_en),
  .issue_salu_wr_exec_en(exec2issue_salu_wr_exec_en),
  .issue_salu_wr_m0_en(exec2issue_salu_wr_m0_en),
  .issue_salu_wr_scc_en(exec2issue_salu_wr_scc_en),
  .issue_valu_wr_vcc_wfid(exec2issue_valu_wr_vcc_wfid),
  .issue_valu_wr_vcc_en(exec2issue_valu_wr_vcc_en)
);

salu salu0 (
  // The scalar alu for scalar operations
  .clk(clk),
  .rst(rst_signal),
  //  Inputs
  .issue_source_reg1(issue2alu_source_reg1),
  .issue_source_reg2(issue2alu_source_reg2),
  .issue_dest_reg(issue2alu_dest_reg1),
  .issue_imm_value0(issue2alu_imm_value0),
  .issue_imm_value1(issue2alu_imm_value1),
  .issue_opcode(issue2alu_opcode),
  .issue_wfid(issue2alu_wfid),
  .issue_alu_select(issue2salu_alu_select),
  .exec_rd_exec_value(exec2salu_rd_exec_value),
  .exec_rd_vcc_value(exec2salu_rd_vcc_value),
  .exec_rd_m0_value(exec2salu_rd_m0_value),
  .exec_rd_scc_value(exec2salu_rd_scc_value),
  .sgpr_source2_data(sgpr2salu_source2_data),
  .sgpr_source1_data(sgpr2salu_source1_data),
  .issue_instr_pc(issue2alu_instr_pc),
  //  Outputs
  .exec_wr_exec_en(salu2exec_wr_exec_en),
  .exec_wr_vcc_en(salu2exec_wr_vcc_en),
  .exec_wr_m0_en(salu2exec_wr_m0_en),
  .exec_wr_scc_en(salu2exec_wr_scc_en),
  .exec_wr_exec_value(salu2exec_wr_exec_value),
  .exec_wr_vcc_value(salu2exec_wr_vcc_value),
  .exec_wr_m0_value(salu2exec_wr_m0_value),
  .exec_wr_scc_value(salu2exec_wr_scc_value),
  .exec_wr_wfid(salu2exec_wr_wfid),
  .exec_rd_en(salu2exec_rd_en),
  .exec_rd_wfid(salu2exec_rd_wfid),
  .sgpr_dest_data(salu2sgpr_dest_data),
  .sgpr_dest_addr(salu2sgpr_dest_addr),
  .sgpr_dest_wr_en(salu2sgpr_dest_wr_en),
  .sgpr_source2_addr(salu2sgpr_source2_addr),
  .sgpr_source1_addr(salu2sgpr_source1_addr),
  .sgpr_source1_rd_en(salu2sgpr_source1_rd_en),
  .sgpr_source2_rd_en(salu2sgpr_source2_rd_en),
  .issue_alu_ready(salu2issue_alu_ready),
  .sgpr_instr_done_wfid(salu2sgpr_instr_done_wfid),
  .sgpr_instr_done(salu2sgpr_instr_done),
  .fetchwaveissue_branch_wfid(salu2fetchwaveissue_branch_wfid),
  .fetchwaveissue_branch_en(salu2fetchwaveissue_branch_en),
  .fetchwaveissue_branch_taken(salu2fetchwaveissue_branch_taken),
  .fetch_branch_pc_value(salu2fetch_branch_pc_value),
  .tracemon_retire_pc(salu2tracemon_retire_pc),
  .tracemon_exec_word_sel(salu2tracemon_exec_word_sel),
  .tracemon_vcc_word_sel(salu2tracemon_vcc_word_sel),
  .rfa2sgpr_request(salu_request)//**change
);

sgpr sgpr0(
  .clk(clk),
  .rst(rst_signal),
  //  Inputs
  .lsu_source1_addr(lsu2sgpr_source1_addr_thru),
  .lsu_source2_addr(lsu2sgpr_source2_addr),
  .lsu_dest_addr(lsu2sgpr_dest_addr_thru),
  .lsu_dest_data(lsu2sgpr_dest_data_thru),
  .lsu_dest_wr_en(lsu2sgpr_dest_wr_en_thru),
  .lsu_instr_done_wfid(lsu2sgpr_instr_done_wfid),
  .lsu_instr_done(lsu2sgpr_instr_done),
  .lsu_source1_rd_en(lsu2sgpr_source1_rd_en_thru),
  .lsu_source2_rd_en(lsu2sgpr_source2_rd_en),
  .simd0_rd_addr(simd0_2sgpr_rd_addr),
  .simd0_rd_en(simd0_2sgpr_rd_en),
  .simd1_rd_addr(simd1_2sgpr_rd_addr),
  .simd1_rd_en(simd1_2sgpr_rd_en),
  .simd2_rd_addr(simd2_2sgpr_rd_addr),
  .simd2_rd_en(simd2_2sgpr_rd_en),
  .simd3_rd_addr(simd3_2sgpr_rd_addr),
  .simd3_rd_en(simd3_2sgpr_rd_en),
  .simd0_wr_addr(simd0_2sgpr_wr_addr),
  .simd0_wr_en(simd0_2sgpr_wr_en),
  .simd0_wr_data(simd0_2sgpr_wr_data),
  .simd1_wr_addr(simd1_2sgpr_wr_addr),
  .simd1_wr_en(simd1_2sgpr_wr_en),
  .simd1_wr_data(simd1_2sgpr_wr_data),
  .simd2_wr_addr(simd2_2sgpr_wr_addr),
  .simd2_wr_en(simd2_2sgpr_wr_en),
  .simd2_wr_data(simd2_2sgpr_wr_data),
  .simd3_wr_addr(simd3_2sgpr_wr_addr),
  .simd3_wr_en(simd3_2sgpr_wr_en),
  .simd3_wr_data(simd3_2sgpr_wr_data),
  .simd0_wr_mask(simd0_2sgpr_wr_mask),
  .simd1_wr_mask(simd1_2sgpr_wr_mask),
  .simd2_wr_mask(simd2_2sgpr_wr_mask),
  .simd3_wr_mask(simd3_2sgpr_wr_mask),
  .simf0_rd_addr(simf0_2sgpr_rd_addr),
  .simf0_rd_en(simf0_2sgpr_rd_en),
  .simf1_rd_addr(simf1_2sgpr_rd_addr),
  .simf1_rd_en(simf1_2sgpr_rd_en),
  .simf2_rd_addr(simf2_2sgpr_rd_addr),
  .simf2_rd_en(simf2_2sgpr_rd_en),
  .simf3_rd_addr(simf3_2sgpr_rd_addr),
  .simf3_rd_en(simf3_2sgpr_rd_en),
  .simf0_wr_addr(simf0_2sgpr_wr_addr),
  .simf0_wr_en(simf0_2sgpr_wr_en),
  .simf0_wr_data(simf0_2sgpr_wr_data),
  .simf1_wr_addr(simf1_2sgpr_wr_addr),
  .simf1_wr_en(simf1_2sgpr_wr_en),
  .simf1_wr_data(simf1_2sgpr_wr_data),
  .simf2_wr_addr(simf2_2sgpr_wr_addr),
  .simf2_wr_en(simf2_2sgpr_wr_en),
  .simf2_wr_data(simf2_2sgpr_wr_data),
  .simf3_wr_addr(simf3_2sgpr_wr_addr),
  .simf3_wr_en(simf3_2sgpr_wr_en),
  .simf3_wr_data(simf3_2sgpr_wr_data),
  .simf0_wr_mask(simf0_2sgpr_wr_mask),
  .simf1_wr_mask(simf1_2sgpr_wr_mask),
  .simf2_wr_mask(simf2_2sgpr_wr_mask),
  .simf3_wr_mask(simf3_2sgpr_wr_mask),
  .salu_dest_data(salu2sgpr_dest_data),
  .salu_dest_addr(salu2sgpr_dest_addr),
  .salu_dest_wr_en(salu2sgpr_dest_wr_en),
  .salu_source2_addr(salu2sgpr_source2_addr),
  .salu_source1_addr(salu2sgpr_source1_addr),
  .salu_instr_done_wfid(salu2sgpr_instr_done_wfid),
  .salu_instr_done(salu2sgpr_instr_done),
  .salu_source1_rd_en(salu2sgpr_source1_rd_en),
  .salu_source2_rd_en(salu2sgpr_source2_rd_en),
  //.rfa_select_fu(rfa2execvgprsgpr_select_fu),
  .rfa_select_fu(sgpr_select_fu),
  //  Outputs
  .lsu_source1_data(sgpr2lsu_source1_data),
  .lsu_source2_data(sgpr2lsu_source2_data),
  .simd_rd_data(sgpr2simd_rd_data),
  .simf_rd_data(sgpr2simf_rd_data),
  .salu_source2_data(sgpr2salu_source2_data),
  .salu_source1_data(sgpr2salu_source1_data),
  .issue_alu_wr_done_wfid(sgpr2issue_alu_wr_done_wfid),
  .issue_alu_wr_done(sgpr2issue_alu_wr_done),
  .issue_alu_dest_reg_addr(sgpr2issue_alu_dest_reg_addr),
  .issue_alu_dest_reg_valid(sgpr2issue_alu_dest_reg_valid),
  .issue_lsu_instr_done_wfid(sgpr2issue_lsu_instr_done_wfid),
  .issue_lsu_instr_done(sgpr2issue_lsu_instr_done),
  .issue_lsu_dest_reg_addr(sgpr2issue_lsu_dest_reg_addr),
  .issue_lsu_dest_reg_valid(sgpr2issue_lsu_dest_reg_valid),
  .issue_valu_dest_reg_valid(sgpr2issue_valu_dest_reg_valid),
  .issue_valu_dest_addr(sgpr2issue_valu_dest_addr)
);

lsu lsu0 (
  // unit to handle loads and stores
  .clk(clk),//
  .rst(rst_signal),//
  //  Inputs
  .issue_lsu_select(issue2lsu_lsu_select),//
  .issue_source_reg1(issue2lsu_source_reg1),//
  .issue_source_reg2(issue2lsu_source_reg2),//
  .issue_source_reg3(issue2lsu_source_reg3),//
  .issue_dest_reg(issue2lsu_dest_reg),//
  .issue_imm_value0(issue2lsu_imm_value0),//
  .issue_imm_value1(issue2lsu_imm_value1),//
  .issue_opcode(issue2lsu_opcode),//
  .issue_mem_sgpr(issue2lsu_mem_sgpr),//
  .issue_wfid(issue2lsu_wfid),//
  .issue_lds_base(issue2lsu_lds_base),//
  .vgpr_source1_data(vgpr2lsu_source1_data),//
  .vgpr_source2_data(vgpr2lsu_source2_data),//
  .mem_rd_data(mem2lsu_rd_data),//
  .mem_tag_resp(mem2lsu_tag_resp),//
  .mem_ack(mem2lsu_ack),//
  .sgpr_source1_data(sgpr2lsu_source1_data),//
  .sgpr_source2_data(sgpr2lsu_source2_data),//
  .exec_exec_value(exec2lsu_exec_value),//
  .exec_rd_m0_value(exec2lsu_rd_m0_value),//
  .issue_instr_pc(issue2lsu_instr_pc),//
       .lsu_stall(lsu_stall),//**CHANGE
  //  Outputs
  .issue_ready(lsu2issue_ready),
  .vgpr_source1_addr(lsu2vgpr_source1_addr),
  .vgpr_source2_addr(lsu2vgpr_source2_addr),
  .vgpr_dest_addr(lsu2vgpr_dest_addr),
  .vgpr_dest_data(lsu2vgpr_dest_data),
  .vgpr_dest_wr_en(lsu2vgpr_dest_wr_en),
  .vgpr_dest_wr_mask(lsu2vgpr_dest_wr_mask),
  .vgpr_instr_done_wfid(lsu2vgpr_instr_done_wfid),
  .vgpr_instr_done(lsu2vgpr_instr_done),
  .vgpr_source1_rd_en(lsu2vgpr_source1_rd_en),
  .vgpr_source2_rd_en(lsu2vgpr_source2_rd_en),
  .exec_rd_wfid(lsu2exec_rd_wfid),
  .mem_rd_en(lsu2mem_rd_en),
  .mem_wr_en(lsu2mem_wr_en),
  .mem_addr(lsu2mem_addr),
  .mem_wr_data(lsu2mem_wr_data),
  .mem_tag_req(lsu2mem_tag_req),
  .mem_wr_mask(lsu2mem_wr_mask),
  .sgpr_source1_addr(lsu2sgpr_source1_addr),
  .sgpr_source2_addr(lsu2sgpr_source2_addr),
  .sgpr_dest_addr(lsu2sgpr_dest_addr),
  .sgpr_dest_data(lsu2sgpr_dest_data),
  .sgpr_dest_wr_en(lsu2sgpr_dest_wr_en),
  .sgpr_instr_done_wfid(lsu2sgpr_instr_done_wfid),
  .sgpr_instr_done(lsu2sgpr_instr_done),
  .sgpr_source1_rd_en(lsu2sgpr_source1_rd_en),
  .sgpr_source2_rd_en(lsu2sgpr_source2_rd_en),
  .tracemon_retire_pc(lsu2tracemon_retire_pc),
  .mem_gm_or_lds(lsu2mem_gm_or_lds),
  .tracemon_gm_or_lds(lsu2tracemon_gm_or_lds),
  .rfa_dest_wr_req(lsu2rfa_dest_wr_req)
  );
  
fpga_memory fpga_memory0(
  .mem_wr_en(lsu2mem_wr_en),
  .mem_rd_en(lsu2mem_rd_en),
  .mem_addr(lsu2mem_addr),
  .mem_wr_data(lsu2mem_wr_data),
  .mem_tag_req(lsu2mem_tag_req),
  
  // MB
  .mb_data_in(mb2fpgamem_data_in),
  .mb_data_we(mb2fpgamem_data_we),
  .mb_ack(mb2fpgamem_ack),
  .mb_done(mb2fpgamem_done),
  
  .clk(clk),
  .rst(rst_signal),
  // output
  // LSU
  .mem_tag_resp(mem2lsu_tag_resp),
  .mem_rd_data(mem2lsu_rd_data),
  .mem_ack(mem2lsu_ack),
  
  // MB
  .mb_op(fpgamem2mb_op),
  .mb_data_out(fpgamem2mb_data),
  .mb_addr(fpgamem2mb_addr)
);

rfa rfa0 (
  // Unit that controls access to register file
  .clk(clk),
  .rst(rst_signal),
  //  Inputs
  .lsu_dest_wr_req(lsu2rfa_dest_wr_req),
  .simd0_queue_entry_valid(simd0_2rfa_queue_entry_valid),
  .simd1_queue_entry_valid(simd1_2rfa_queue_entry_valid),
  .simd2_queue_entry_valid(simd2_2rfa_queue_entry_valid),
  .simd3_queue_entry_valid(simd3_2rfa_queue_entry_valid),
  .simf0_queue_entry_valid(simf0_2rfa_queue_entry_valid),
  .simf1_queue_entry_valid(simf1_2rfa_queue_entry_valid),
  .simf2_queue_entry_valid(simf2_2rfa_queue_entry_valid),
  .simf3_queue_entry_valid(simf3_2rfa_queue_entry_valid),
  //  Outputs
  .simd0_queue_entry_serviced(rfa2simd0_queue_entry_serviced),
  .simd1_queue_entry_serviced(rfa2simd1_queue_entry_serviced),
  .simd2_queue_entry_serviced(rfa2simd2_queue_entry_serviced),
  .simd3_queue_entry_serviced(rfa2simd3_queue_entry_serviced),
  .simf0_queue_entry_serviced(rfa2simf0_queue_entry_serviced),
  .simf1_queue_entry_serviced(rfa2simf1_queue_entry_serviced),
  .simf2_queue_entry_serviced(rfa2simf2_queue_entry_serviced),
  .simf3_queue_entry_serviced(rfa2simf3_queue_entry_serviced),
  .execvgprsgpr_select_fu(rfa2execvgprsgpr_select_fu),
  .lsu_wait(lsu_stall), //**change,
  .salu_req(salu_request) //**change
);

simd simd0 (
  // Contains a 16 wide vector alu for vector operations
  .clk(clk),
  .rst(rst_signal),
  //  Inputs
  .issue_source_reg1(issue2alu_source_reg1),
  .issue_source_reg2(issue2alu_source_reg2),
  .issue_source_reg3(issue2alu_source_reg3),
  .issue_dest_reg1(issue2alu_dest_reg1),
  .issue_dest_reg2(issue2alu_dest_reg2),
  .issue_imm_value0(issue2alu_imm_value0),
  .issue_imm_value1(issue2alu_imm_value1),
  .issue_opcode(issue2alu_opcode),
  .issue_wfid(issue2alu_wfid),
  .issue_alu_select(issue2simd0_alu_select),
  .vgpr_source1_data(vgpr2simd_source1_data),
  .vgpr_source2_data(vgpr2simd_source2_data),
  .vgpr_source3_data(vgpr2simd_source3_data),
  .sgpr_rd_data(sgpr2simd_rd_data),
  .exec_rd_exec_value(exec2simd_rd_exec_value),
  .exec_rd_vcc_value(exec2simd_rd_vcc_value),
  .exec_rd_m0_value(exec2simd_rd_m0_value),
  .exec_rd_scc_value(exec2simd_rd_scc_value),
  .issue_instr_pc(issue2alu_instr_pc),
  .rfa_queue_entry_serviced(rfa2simd0_queue_entry_serviced),
  //  Outputs
  .vgpr_source1_rd_en(simd0_2vgpr_source1_rd_en),
  .vgpr_source2_rd_en(simd0_2vgpr_source2_rd_en),
  .vgpr_source3_rd_en(simd0_2vgpr_source3_rd_en),
  .vgpr_source1_addr(simd0_2vgpr_source1_addr),
  .vgpr_source2_addr(simd0_2vgpr_source2_addr),
  .vgpr_source3_addr(simd0_2vgpr_source3_addr),
  .vgpr_dest_addr(simd0_2vgpr_dest_addr),
  .vgpr_dest_data(simd0_2vgpr_dest_data),
  .vgpr_wr_en(simd0_2vgpr_wr_en),
  .vgpr_wr_mask(simd0_2vgpr_wr_mask),
  .exec_rd_wfid(simd0_2exec_rd_wfid),
  .exec_rd_en(simd0_2exec_rd_en),
  .exec_wr_vcc_wfid(simd0_2exec_wr_vcc_wfid),
  .exec_wr_vcc_en(simd0_2exec_wr_vcc_en),
  .exec_wr_vcc_value(simd0_2exec_wr_vcc_value),
  .sgpr_rd_en(simd0_2sgpr_rd_en),
  .sgpr_rd_addr(simd0_2sgpr_rd_addr),
  .sgpr_wr_addr(simd0_2sgpr_wr_addr),
  .sgpr_wr_en(simd0_2sgpr_wr_en),
  .sgpr_wr_data(simd0_2sgpr_wr_data),
  .sgpr_wr_mask(simd0_2sgpr_wr_mask),
  .issue_alu_ready(simd0_2issue_alu_ready),
  .vgpr_instr_done_wfid(simd0_2vgpr_instr_done_wfid),
  .vgpr_instr_done(simd0_2vgpr_instr_done),
  .rfa_queue_entry_valid(simd0_2rfa_queue_entry_valid),
  .tracemon_retire_pc(simd0_2tracemon_retire_pc)
  );

simf simf0 (
  // Contains a 16 wide floating point vector alu for vector operations
  .clk(clk),
  .rst(rst_signal),
  //  Inputs
  .issue_source_reg1(issue2alu_source_reg1),
  .issue_source_reg2(issue2alu_source_reg2),
  .issue_source_reg3(issue2alu_source_reg3),
  .issue_dest_reg1(issue2alu_dest_reg1),
  .issue_dest_reg2(issue2alu_dest_reg2),
  .issue_imm_value0(issue2alu_imm_value0),
  .issue_imm_value1(issue2alu_imm_value1),
  .issue_opcode(issue2alu_opcode),
  .issue_wfid(issue2alu_wfid),
  .issue_alu_select(issue2simf0_alu_select),
  .vgpr_source1_data(vgpr2simf_source1_data),
  .vgpr_source2_data(vgpr2simf_source2_data),
  .vgpr_source3_data(vgpr2simf_source3_data),
  .sgpr_rd_data(sgpr2simf_rd_data),
  .exec_rd_exec_value(exec2simf_rd_exec_value),
  .exec_rd_vcc_value(exec2simf_rd_vcc_value),
  .exec_rd_m0_value(exec2simf_rd_m0_value),
  .exec_rd_scc_value(exec2simf_rd_scc_value),
  .issue_instr_pc(issue2alu_instr_pc),
  .rfa_queue_entry_serviced(rfa2simf0_queue_entry_serviced),
  //  Outputs
  .vgpr_source1_rd_en(simf0_2vgpr_source1_rd_en),
  .vgpr_source2_rd_en(simf0_2vgpr_source2_rd_en),
  .vgpr_source3_rd_en(simf0_2vgpr_source3_rd_en),
  .vgpr_source1_addr(simf0_2vgpr_source1_addr),
  .vgpr_source2_addr(simf0_2vgpr_source2_addr),
  .vgpr_source3_addr(simf0_2vgpr_source3_addr),
  .vgpr_dest_addr(simf0_2vgpr_dest_addr),
  .vgpr_dest_data(simf0_2vgpr_dest_data),
  .vgpr_wr_en(simf0_2vgpr_wr_en),
  .vgpr_wr_mask(simf0_2vgpr_wr_mask),
  .exec_rd_wfid(simf0_2exec_rd_wfid),
  .exec_rd_en(simf0_2exec_rd_en),
  .exec_wr_vcc_wfid(simf0_2exec_wr_vcc_wfid),
  .exec_wr_vcc_en(simf0_2exec_wr_vcc_en),
  .exec_wr_vcc_value(simf0_2exec_wr_vcc_value),
  .sgpr_rd_en(simf0_2sgpr_rd_en),
  .sgpr_rd_addr(simf0_2sgpr_rd_addr),
  .sgpr_wr_addr(simf0_2sgpr_wr_addr),
  .sgpr_wr_en(simf0_2sgpr_wr_en),
  .sgpr_wr_data(simf0_2sgpr_wr_data),
  .sgpr_wr_mask(simf0_2sgpr_wr_mask),
  .issue_alu_ready(simf0_2issue_alu_ready),
  .vgpr_instr_done_wfid(simf0_2vgpr_instr_done_wfid),
  .vgpr_instr_done(simf0_2vgpr_instr_done),
  .rfa_queue_entry_valid(simf0_2rfa_queue_entry_valid),
  .tracemon_retire_pc(simf0_2tracemon_retire_pc)
  );
// User logic ends

endmodule
