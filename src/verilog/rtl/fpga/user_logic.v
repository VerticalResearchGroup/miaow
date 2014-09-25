//----------------------------------------------------------------------------
// user_logic.v - module
//----------------------------------------------------------------------------
//
// ***************************************************************************
// ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
// **                                                                       **
// ** Xilinx, Inc.                                                          **
// ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
// ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
// ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
// ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
// ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
// ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
// ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
// ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
// ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
// ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
// ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
// ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
// ** FOR A PARTICULAR PURPOSE.                                             **
// **                                                                       **
// ***************************************************************************
//
//----------------------------------------------------------------------------
// Filename:          user_logic.v
// Version:           1.00.a
// Description:       User logic module.
// Date:              Tue Feb 18 15:43:39 2014 (by Create and Import Peripheral Wizard)
// Verilog Standard:  Verilog-2001
//----------------------------------------------------------------------------
// Naming Conventions:
//   active low signals:                    "*_n"
//   clock signals:                         "clk", "clk_div#", "clk_#x"
//   reset signals:                         "rst", "rst_n"
//   generics:                              "C_*"
//   user defined types:                    "*_TYPE"
//   state machine next state:              "*_ns"
//   state machine current state:           "*_cs"
//   combinatorial signals:                 "*_com"
//   pipelined or register delay signals:   "*_d#"
//   counter signals:                       "*cnt*"
//   clock enable signals:                  "*_ce"
//   internal version of output port:       "*_i"
//   device pins:                           "*_pin"
//   ports:                                 "- Names begin with Uppercase"
//   processes:                             "*_PROCESS"
//   component instantiations:              "<ENTITY_>I_<#|FUNC>"
//----------------------------------------------------------------------------

module user_logic
(
  // -- ADD USER PORTS BELOW THIS LINE ---------------
  // --USER ports added here 
  Double_Clk,
  // -- ADD USER PORTS ABOVE THIS LINE ---------------

  // -- DO NOT EDIT BELOW THIS LINE ------------------
  // -- Bus protocol ports, do not add to or delete 
  Bus2IP_Clk,                     // Bus to IP clock
  Bus2IP_Resetn,                  // Bus to IP reset
  Bus2IP_Addr,                    // Bus to IP address bus
  Bus2IP_CS,                      // Bus to IP chip select for user logic memory selection
  Bus2IP_RNW,                     // Bus to IP read/not write
  Bus2IP_Data,                    // Bus to IP data bus
  Bus2IP_BE,                      // Bus to IP byte enables
  Bus2IP_RdCE,                    // Bus to IP read chip enable
  Bus2IP_WrCE,                    // Bus to IP write chip enable
  Bus2IP_Burst,                   // Bus to IP burst-mode qualifier
  Bus2IP_BurstLength,             // Bus to IP burst length
  Bus2IP_RdReq,                   // Bus to IP read request
  Bus2IP_WrReq,                   // Bus to IP write request
  IP2Bus_AddrAck,                 // IP to Bus address acknowledgement
  IP2Bus_Data,                    // IP to Bus data bus
  IP2Bus_RdAck,                   // IP to Bus read transfer acknowledgement
  IP2Bus_WrAck,                   // IP to Bus write transfer acknowledgement
  IP2Bus_Error,                   // IP to Bus error response
  Type_of_xfer                    // Transfer Type
  // -- DO NOT EDIT ABOVE THIS LINE ------------------
); // user_logic

// -- ADD USER PARAMETERS BELOW THIS LINE ------------
// --USER parameters added here 
// -- ADD USER PARAMETERS ABOVE THIS LINE ------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol parameters, do not add to or delete
parameter C_SLV_AWIDTH                   = 32;
parameter C_SLV_DWIDTH                   = 32;
parameter C_NUM_MEM                      = 5;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

// -- ADD USER PORTS BELOW THIS LINE -----------------
// --USER ports added here 
input Double_Clk;
// -- ADD USER PORTS ABOVE THIS LINE -----------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol ports, do not add to or delete
input                                     Bus2IP_Clk;
input                                     Bus2IP_Resetn;
input      [C_SLV_AWIDTH-1 : 0]           Bus2IP_Addr;
input      [C_NUM_MEM-1 : 0]              Bus2IP_CS;
input                                     Bus2IP_RNW;
input      [C_SLV_DWIDTH-1 : 0]           Bus2IP_Data;
input      [C_SLV_DWIDTH/8-1 : 0]         Bus2IP_BE;
input      [C_NUM_MEM-1 : 0]              Bus2IP_RdCE;
input      [C_NUM_MEM-1 : 0]              Bus2IP_WrCE;
input                                     Bus2IP_Burst;
input      [7 : 0]                        Bus2IP_BurstLength;
input                                     Bus2IP_RdReq;
input                                     Bus2IP_WrReq;
output                                    IP2Bus_AddrAck;
output     [C_SLV_DWIDTH-1 : 0]           IP2Bus_Data;
output                                    IP2Bus_RdAck;
output                                    IP2Bus_WrAck;
output                                    IP2Bus_Error;
output                                    Type_of_xfer;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------

// Internal interconnect registers
reg [C_SLV_DWIDTH-1:0] Output_Reg;

wire rst_signal;

  // --USER nets declarations added here, as needed for user logic
reg [C_SLV_DWIDTH-1:0] waveID;
reg [C_SLV_DWIDTH-1:0] baseVGPR;
reg [C_SLV_DWIDTH-1:0] baseSGPR;
reg [C_SLV_DWIDTH-1:0] baseLDS;
reg [C_SLV_DWIDTH-1:0] waveCount;
reg [C_SLV_DWIDTH-1:0] pcStart;
reg [C_SLV_DWIDTH-1:0] resultsReady;
reg [C_SLV_DWIDTH-1:0] resultsReadyTag;

reg execute;
reg executeStart;

// SGPR registers
reg [31:0] gprCommand;
reg [8:0] quadBaseAddress;
reg [8:0] dualBaseAddress;
reg [1:0] dualWriteEn;
reg [31:0] quadData0;
reg [31:0] quadData1;
reg [31:0] quadData2;
reg [31:0] quadData3;
reg [31:0] quadWriteEn;

reg [31:0] vgprPlaceholder;

reg [31:0] regOperationDone;

//wire [3:0] register_port0_wr_enable;

wire [31:0] sgpr_data1_out;
wire [31:0] sgpr_data2_out;
wire [31:0] sgpr_data3_out;

wire [31:0] dualData0_out;
wire [31:0] dualData1_out;
wire [31:0] dualData2_out;
wire [31:0] dualData3_out;


 wire 	   buff2fetchwave_ack, cu2dispatch_wf_done, decode2issue_barrier,
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
   wire [1:0] 	   decode2issue_fu, salu2sgpr_dest_wr_en, salu2tracemon_exec_word_sel,
		   salu2tracemon_vcc_word_sel, sgpr2issue_alu_dest_reg_valid;
   wire [3:0] 	   dispatch2cu_wg_wf_count, fetch2issue_wg_wf_count, lsu2mem_rd_en,
		   lsu2mem_wr_en, lsu2sgpr_dest_wr_en, lsu2vgpr_dest_wr_en, sgpr2issue_lsu_dest_reg_valid,
		   vgpr2issue_lsu_dest_reg_valid;
   wire [5:0] 	   decode2issue_wfid, decode2wave_ins_half_wfid, dispatch2cu_wf_size_dispatch,
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
   wire [6:0] 	   lsu2mem_tag_req, mem2lsu_tag_resp;
   wire [8:0] 	   dispatch2cu_sgpr_base_dispatch, fetch2wave_sgpr_base, lsu2sgpr_dest_addr,
		   lsu2sgpr_source1_addr, lsu2sgpr_source2_addr, salu2sgpr_dest_addr, salu2sgpr_source1_addr,
		   salu2sgpr_source2_addr, sgpr2issue_alu_dest_reg_addr, sgpr2issue_lsu_dest_reg_addr,
		   sgpr2issue_valu_dest_addr, simd0_2sgpr_rd_addr, simd0_2sgpr_wr_addr,
		   simd1_2sgpr_rd_addr, simd1_2sgpr_wr_addr, simd2_2sgpr_rd_addr, simd2_2sgpr_wr_addr,
		   simd3_2sgpr_rd_addr, simd3_2sgpr_wr_addr, simf0_2sgpr_rd_addr, simf0_2sgpr_wr_addr,
		   simf1_2sgpr_rd_addr, simf1_2sgpr_wr_addr, simf2_2sgpr_rd_addr, simf2_2sgpr_wr_addr,
		   simf3_2sgpr_rd_addr, simf3_2sgpr_wr_addr, wave2decode_sgpr_base;
   wire [9:0] 	   dispatch2cu_vgpr_base_dispatch, fetch2wave_vgpr_base, lsu2vgpr_dest_addr,
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
   wire [11:0] 	   issue2alu_dest_reg1, issue2alu_dest_reg2, issue2alu_source_reg1,
		   issue2alu_source_reg2, issue2alu_source_reg3, issue2lsu_dest_reg, issue2lsu_mem_sgpr,
		   issue2lsu_source_reg1, issue2lsu_source_reg2, issue2lsu_source_reg3;
   wire [12:0] 	   decode2issue_dest_reg2, decode2issue_source_reg2, decode2issue_source_reg3;
   wire [13:0] 	   decode2issue_dest_reg1, decode2issue_source_reg1, decode2issue_source_reg4;
   wire [14:0] 	   cu2dispatch_wf_tag_done, dispatch2cu_wf_tag_dispatch, fetch2tracemon_wf_tag;
   wire [15:0] 	   decode2issue_imm_value0, decode2issue_lds_base, dispatch2cu_lds_base_dispatch,
		   fetch2wave_lds_base, issue2alu_imm_value0, issue2lsu_imm_value0, issue2lsu_lds_base,
		   rfa2execvgprsgpr_select_fu, wave2decode_lds_base;
   wire [31:0] 	   buff2wave_instr, decode2issue_imm_value1, decode2issue_instr_pc,
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
   wire [38:0] 	   buff2wave_tag, fetch2buff_tag;
   wire [39:0] 	   issue2tracemon_barrier_retire_wf_bitmap, issue2wave_valid_entries,
		   wave2fetch_stop_fetch;
   wire [63:0] 	   decode2tracemon_collinstr, exec2lsu_exec_value, exec2salu_rd_exec_value,
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
   wire [2047:0]   lsu2mem_addr, simd0_2vgpr_dest_data, simd1_2vgpr_dest_data,
		   simd2_2vgpr_dest_data, simd3_2vgpr_dest_data, simf0_2vgpr_dest_data,
		   simf1_2vgpr_dest_data, simf2_2vgpr_dest_data, simf3_2vgpr_dest_data,
		   vgpr2lsu_source2_data, vgpr2simd_source1_data, vgpr2simd_source2_data,
		   vgpr2simd_source3_data, vgpr2simf_source1_data, vgpr2simf_source2_data,
		   vgpr2simf_source3_data;
   wire [8191:0]   lsu2mem_wr_data, lsu2vgpr_dest_data, mem2lsu_rd_data, vgpr2lsu_source1_data;


wire lsu2sgpr_source1_addr_thru;
wire lsu2sgpr_dest_addr_thru;
wire [127:0] lsu2sgpr_dest_data_thru;
wire lsu2sgpr_source1_rd_en_thru;
reg [3:0] lsu2sgpr_dest_wr_en_reg;

parameter IDLE_STATE = 4'd0;
parameter DISPATCH_STATE = 4'd1;
parameter EXECUTE_STATE = 4'd2;
parameter RESULT_STATE = 4'd3;
reg [3:0] executeState;
reg [3:0] executeStateNext;

assign dispatch2cu_start_pc_dispatch = pcStart;
assign dispatch2cu_vgpr_base_dispatch = baseVGPR[9:0];
assign dispatch2cu_sgpr_base_dispatch = baseSGPR[8:0];
assign dispatch2cu_lds_base_dispatch = baseLDS[15:0];
assign dispatch2cu_wf_size_dispatch = waveCount[5:0];
assign dispatch2cu_wg_wf_count = 4'd1;
assign dispatch2cu_wf_tag_dispatch = waveID[14:0];
assign dispatch2cu_wf_dispatch = executeStart;

assign rst_signal = ~Bus2IP_Resetn;

fetch fetch0 (
		 // Unit that fetches instructions from a wavefront chosen by the wavepool
		 .clk(Bus2IP_Clk),
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

wavepool wavepool0 (
		       // Unit that choses wavefronts fetched and keeps control of a instruction queue.
		       .clk(Bus2IP_Clk),
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
		   .clk(Bus2IP_Clk),
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
		 .clk(Bus2IP_Clk),
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
	       .clk(Bus2IP_Clk),
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
         

//assign sgpr2salu_source2_data = sgpr2lsu_source1_data[63:0];


salu salu0 (
	       // The scalar alu for scalar operations
	       .clk(Bus2IP_Clk),
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
	       .tracemon_vcc_word_sel(salu2tracemon_vcc_word_sel)
	       );

simd simd0 (
	       // Contains a 16 wide vector alu for vector operations
	       .clk(Bus2IP_Clk),
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
/*
   simd simd1 (
	       // Contains a 16 wide vector alu for vector operations
	       .clk(Bus2IP_Clk),
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
	       .issue_alu_select(issue2simd1_alu_select),
	       .vgpr_source1_data(vgpr2simd_source1_data),
	       .vgpr_source2_data(vgpr2simd_source2_data),
	       .vgpr_source3_data(vgpr2simd_source3_data),
	       .sgpr_rd_data(sgpr2simd_rd_data),
	       .exec_rd_exec_value(exec2simd_rd_exec_value),
	       .exec_rd_vcc_value(exec2simd_rd_vcc_value),
	       .exec_rd_m0_value(exec2simd_rd_m0_value),
	       .exec_rd_scc_value(exec2simd_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simd1_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simd1_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simd1_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simd1_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simd1_2vgpr_source1_addr),
	       .vgpr_source2_addr(simd1_2vgpr_source2_addr),
	       .vgpr_source3_addr(simd1_2vgpr_source3_addr),
	       .vgpr_dest_addr(simd1_2vgpr_dest_addr),
	       .vgpr_dest_data(simd1_2vgpr_dest_data),
	       .vgpr_wr_en(simd1_2vgpr_wr_en),
	       .vgpr_wr_mask(simd1_2vgpr_wr_mask),
	       .exec_rd_wfid(simd1_2exec_rd_wfid),
	       .exec_rd_en(simd1_2exec_rd_en),
	       .exec_wr_vcc_wfid(simd1_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simd1_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simd1_2exec_wr_vcc_value),
	       .sgpr_rd_en(simd1_2sgpr_rd_en),
	       .sgpr_rd_addr(simd1_2sgpr_rd_addr),
	       .sgpr_wr_addr(simd1_2sgpr_wr_addr),
	       .sgpr_wr_en(simd1_2sgpr_wr_en),
	       .sgpr_wr_data(simd1_2sgpr_wr_data),
	       .sgpr_wr_mask(simd1_2sgpr_wr_mask),
	       .issue_alu_ready(simd1_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simd1_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simd1_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simd1_2rfa_queue_entry_valid)
	       );

   simd simd2 (
	       // Contains a 16 wide vector alu for vector operations
	       .clk(Bus2IP_Clk),
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
	       .issue_alu_select(issue2simd2_alu_select),
	       .vgpr_source1_data(vgpr2simd_source1_data),
	       .vgpr_source2_data(vgpr2simd_source2_data),
	       .vgpr_source3_data(vgpr2simd_source3_data),
	       .sgpr_rd_data(sgpr2simd_rd_data),
	       .exec_rd_exec_value(exec2simd_rd_exec_value),
	       .exec_rd_vcc_value(exec2simd_rd_vcc_value),
	       .exec_rd_m0_value(exec2simd_rd_m0_value),
	       .exec_rd_scc_value(exec2simd_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simd2_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simd2_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simd2_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simd2_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simd2_2vgpr_source1_addr),
	       .vgpr_source2_addr(simd2_2vgpr_source2_addr),
	       .vgpr_source3_addr(simd2_2vgpr_source3_addr),
	       .vgpr_dest_addr(simd2_2vgpr_dest_addr),
	       .vgpr_dest_data(simd2_2vgpr_dest_data),
	       .vgpr_wr_en(simd2_2vgpr_wr_en),
	       .vgpr_wr_mask(simd2_2vgpr_wr_mask),
	       .exec_rd_wfid(simd2_2exec_rd_wfid),
	       .exec_rd_en(simd2_2exec_rd_en),
	       .exec_wr_vcc_wfid(simd2_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simd2_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simd2_2exec_wr_vcc_value),
	       .sgpr_rd_en(simd2_2sgpr_rd_en),
	       .sgpr_rd_addr(simd2_2sgpr_rd_addr),
	       .sgpr_wr_addr(simd2_2sgpr_wr_addr),
	       .sgpr_wr_en(simd2_2sgpr_wr_en),
	       .sgpr_wr_data(simd2_2sgpr_wr_data),
	       .sgpr_wr_mask(simd2_2sgpr_wr_mask),
	       .issue_alu_ready(simd2_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simd2_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simd2_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simd2_2rfa_queue_entry_valid)
	       );

   simd simd3 (
	       // Contains a 16 wide vector alu for vector operations
	       .clk(Bus2IP_Clk),
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
	       .issue_alu_select(issue2simd3_alu_select),
	       .vgpr_source1_data(vgpr2simd_source1_data),
	       .vgpr_source2_data(vgpr2simd_source2_data),
	       .vgpr_source3_data(vgpr2simd_source3_data),
	       .sgpr_rd_data(sgpr2simd_rd_data),
	       .exec_rd_exec_value(exec2simd_rd_exec_value),
	       .exec_rd_vcc_value(exec2simd_rd_vcc_value),
	       .exec_rd_m0_value(exec2simd_rd_m0_value),
	       .exec_rd_scc_value(exec2simd_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simd3_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simd3_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simd3_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simd3_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simd3_2vgpr_source1_addr),
	       .vgpr_source2_addr(simd3_2vgpr_source2_addr),
	       .vgpr_source3_addr(simd3_2vgpr_source3_addr),
	       .vgpr_dest_addr(simd3_2vgpr_dest_addr),
	       .vgpr_dest_data(simd3_2vgpr_dest_data),
	       .vgpr_wr_en(simd3_2vgpr_wr_en),
	       .vgpr_wr_mask(simd3_2vgpr_wr_mask),
	       .exec_rd_wfid(simd3_2exec_rd_wfid),
	       .exec_rd_en(simd3_2exec_rd_en),
	       .exec_wr_vcc_wfid(simd3_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simd3_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simd3_2exec_wr_vcc_value),
	       .sgpr_rd_en(simd3_2sgpr_rd_en),
	       .sgpr_rd_addr(simd3_2sgpr_rd_addr),
	       .sgpr_wr_addr(simd3_2sgpr_wr_addr),
	       .sgpr_wr_en(simd3_2sgpr_wr_en),
	       .sgpr_wr_data(simd3_2sgpr_wr_data),
	       .sgpr_wr_mask(simd3_2sgpr_wr_mask),
	       .issue_alu_ready(simd3_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simd3_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simd3_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simd3_2rfa_queue_entry_valid)
	       );
*/
   simf simf0 (
	       // Contains a 16 wide floating point vector alu for vector operations
	       .clk(Bus2IP_Clk),
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
/*
   simf simf1 (
	       // Contains a 16 wide floating point vector alu for vector operations
	       .clk(Bus2IP_Clk),
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
	       .issue_alu_select(issue2simf1_alu_select),
	       .vgpr_source1_data(vgpr2simf_source1_data),
	       .vgpr_source2_data(vgpr2simf_source2_data),
	       .vgpr_source3_data(vgpr2simf_source3_data),
	       .sgpr_rd_data(sgpr2simf_rd_data),
	       .exec_rd_exec_value(exec2simf_rd_exec_value),
	       .exec_rd_vcc_value(exec2simf_rd_vcc_value),
	       .exec_rd_m0_value(exec2simf_rd_m0_value),
	       .exec_rd_scc_value(exec2simf_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simf1_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simf1_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simf1_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simf1_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simf1_2vgpr_source1_addr),
	       .vgpr_source2_addr(simf1_2vgpr_source2_addr),
	       .vgpr_source3_addr(simf1_2vgpr_source3_addr),
	       .vgpr_dest_addr(simf1_2vgpr_dest_addr),
	       .vgpr_dest_data(simf1_2vgpr_dest_data),
	       .vgpr_wr_en(simf1_2vgpr_wr_en),
	       .vgpr_wr_mask(simf1_2vgpr_wr_mask),
	       .exec_rd_wfid(simf1_2exec_rd_wfid),
	       .exec_rd_en(simf1_2exec_rd_en),
	       .exec_wr_vcc_wfid(simf1_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simf1_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simf1_2exec_wr_vcc_value),
	       .sgpr_rd_en(simf1_2sgpr_rd_en),
	       .sgpr_rd_addr(simf1_2sgpr_rd_addr),
	       .sgpr_wr_addr(simf1_2sgpr_wr_addr),
	       .sgpr_wr_en(simf1_2sgpr_wr_en),
	       .sgpr_wr_data(simf1_2sgpr_wr_data),
	       .sgpr_wr_mask(simf1_2sgpr_wr_mask),
	       .issue_alu_ready(simf1_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simf1_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simf1_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simf1_2rfa_queue_entry_valid),
	       .tracemon_retire_pc(simf1_2tracemon_retire_pc)
	       );

   simf simf2 (
	       // Contains a 16 wide floating point vector alu for vector operations
	       .clk(Bus2IP_Clk),
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
	       .issue_alu_select(issue2simf2_alu_select),
	       .vgpr_source1_data(vgpr2simf_source1_data),
	       .vgpr_source2_data(vgpr2simf_source2_data),
	       .vgpr_source3_data(vgpr2simf_source3_data),
	       .sgpr_rd_data(sgpr2simf_rd_data),
	       .exec_rd_exec_value(exec2simf_rd_exec_value),
	       .exec_rd_vcc_value(exec2simf_rd_vcc_value),
	       .exec_rd_m0_value(exec2simf_rd_m0_value),
	       .exec_rd_scc_value(exec2simf_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simf2_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simf2_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simf2_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simf2_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simf2_2vgpr_source1_addr),
	       .vgpr_source2_addr(simf2_2vgpr_source2_addr),
	       .vgpr_source3_addr(simf2_2vgpr_source3_addr),
	       .vgpr_dest_addr(simf2_2vgpr_dest_addr),
	       .vgpr_dest_data(simf2_2vgpr_dest_data),
	       .vgpr_wr_en(simf2_2vgpr_wr_en),
	       .vgpr_wr_mask(simf2_2vgpr_wr_mask),
	       .exec_rd_wfid(simf2_2exec_rd_wfid),
	       .exec_rd_en(simf2_2exec_rd_en),
	       .exec_wr_vcc_wfid(simf2_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simf2_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simf2_2exec_wr_vcc_value),
	       .sgpr_rd_en(simf2_2sgpr_rd_en),
	       .sgpr_rd_addr(simf2_2sgpr_rd_addr),
	       .sgpr_wr_addr(simf2_2sgpr_wr_addr),
	       .sgpr_wr_en(simf2_2sgpr_wr_en),
	       .sgpr_wr_data(simf2_2sgpr_wr_data),
	       .sgpr_wr_mask(simf2_2sgpr_wr_mask),
	       .issue_alu_ready(simf2_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simf2_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simf2_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simf2_2rfa_queue_entry_valid),
	       .tracemon_retire_pc(simf2_2tracemon_retire_pc)
	       );

   simf simf3 (
	       // Contains a 16 wide floating point vector alu for vector operations
	       .clk(Bus2IP_Clk),
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
	       .issue_alu_select(issue2simf3_alu_select),
	       .vgpr_source1_data(vgpr2simf_source1_data),
	       .vgpr_source2_data(vgpr2simf_source2_data),
	       .vgpr_source3_data(vgpr2simf_source3_data),
	       .sgpr_rd_data(sgpr2simf_rd_data),
	       .exec_rd_exec_value(exec2simf_rd_exec_value),
	       .exec_rd_vcc_value(exec2simf_rd_vcc_value),
	       .exec_rd_m0_value(exec2simf_rd_m0_value),
	       .exec_rd_scc_value(exec2simf_rd_scc_value),
	       .issue_instr_pc(issue2alu_instr_pc),
	       .rfa_queue_entry_serviced(rfa2simf3_queue_entry_serviced),
	       //  Outputs
	       .vgpr_source1_rd_en(simf3_2vgpr_source1_rd_en),
	       .vgpr_source2_rd_en(simf3_2vgpr_source2_rd_en),
	       .vgpr_source3_rd_en(simf3_2vgpr_source3_rd_en),
	       .vgpr_source1_addr(simf3_2vgpr_source1_addr),
	       .vgpr_source2_addr(simf3_2vgpr_source2_addr),
	       .vgpr_source3_addr(simf3_2vgpr_source3_addr),
	       .vgpr_dest_addr(simf3_2vgpr_dest_addr),
	       .vgpr_dest_data(simf3_2vgpr_dest_data),
	       .vgpr_wr_en(simf3_2vgpr_wr_en),
	       .vgpr_wr_mask(simf3_2vgpr_wr_mask),
	       .exec_rd_wfid(simf3_2exec_rd_wfid),
	       .exec_rd_en(simf3_2exec_rd_en),
	       .exec_wr_vcc_wfid(simf3_2exec_wr_vcc_wfid),
	       .exec_wr_vcc_en(simf3_2exec_wr_vcc_en),
	       .exec_wr_vcc_value(simf3_2exec_wr_vcc_value),
	       .sgpr_rd_en(simf3_2sgpr_rd_en),
	       .sgpr_rd_addr(simf3_2sgpr_rd_addr),
	       .sgpr_wr_addr(simf3_2sgpr_wr_addr),
	       .sgpr_wr_en(simf3_2sgpr_wr_en),
	       .sgpr_wr_data(simf3_2sgpr_wr_data),
	       .sgpr_wr_mask(simf3_2sgpr_wr_mask),
	       .issue_alu_ready(simf3_2issue_alu_ready),
	       .vgpr_instr_done_wfid(simf3_2vgpr_instr_done_wfid),
	       .vgpr_instr_done(simf3_2vgpr_instr_done),
	       .rfa_queue_entry_valid(simf3_2rfa_queue_entry_valid),
	       .tracemon_retire_pc(simf3_2tracemon_retire_pc)
	       );
*/
wire [8:0] sgpr_salu_2_addr;
wire sgpr_salu2_rd_en;
reg [31:0] sgpr_dispatch_2_addr;

wire [15:0] sgpr_select_fu;

assign sgpr_salu_2_addr = execute ? salu2sgpr_source2_addr : sgpr_dispatch_2_addr[8:0];
assign lsu2sgpr_dest_data_thru = execute ? lsu2sgpr_dest_data : {quadData3, quadData2, quadData1, quadData0};
assign sgpr_salu2_rd_en = execute ? salu2sgpr_source2_rd_en : 1'b1;

assign sgpr_select_fu = execute ? rfa2execvgprsgpr_select_fu : {7'd0, lsu2sgpr_dest_wr_en[0], 8'd0};

wire [8:0] 	  final_port0_addr_out;
wire [8:0] 	  final_port1_addr_out;
wire [31:0]    final_port0_data_out;
wire [31:0] 	 final_port1_data_out;
wire [3:0] simxlsu_muxed_wr_en_out;

wire [6:0] rd0_addr_bank1_out;
wire [6:0] rd1_addr_bank1_out;
wire wr0_en_bank1_out;
wire wr1_en_bank1_out;
wire [31:0] rd0_data_bank1_out;

assign lsu2sgpr_source1_rd_en_thru = execute ? lsu2sgpr_source1_rd_en : ~(|lsu2sgpr_dest_wr_en);
assign lsu2sgpr_dest_wr_en_thru = execute ? lsu2sgpr_dest_wr_en : lsu2sgpr_dest_wr_en_reg;

sgpr sgpr0(
.clk_double(Double_Clk),
.clk(Bus2IP_Clk),
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
         ,.final_port0_addr_out(final_port0_addr_out),
         .final_port1_addr_out(final_port1_addr_out),
         .final_port0_data_out(final_port0_data_out),
         .final_port1_data_out(final_port1_data_out),
         .simxlsu_muxed_wr_en_out(simxlsu_muxed_wr_en_out),
         .rd0_addr_bank1_out(rd0_addr_bank1_out),
      .rd1_addr_bank1_out(rd1_addr_bank1_out),
      .wr0_en_bank1_out(wr0_en_bank1_out),
      .wr1_en_bank1_out(wr1_en_bank1_out),
      .rd0_data_bank1_out(rd0_data_bank1_out)
	       );
/*
lsu lsu0 (
	     // unit to handle loads and stores
	     .clk(clk),
	     .rst(rst),
	     //  Inputs
	     .issue_lsu_select(issue2lsu_lsu_select),
	     .issue_source_reg1(issue2lsu_source_reg1),
	     .issue_source_reg2(issue2lsu_source_reg2),
	     .issue_source_reg3(issue2lsu_source_reg3),
	     .issue_dest_reg(issue2lsu_dest_reg),
	     .issue_imm_value0(issue2lsu_imm_value0),
	     .issue_imm_value1(issue2lsu_imm_value1),
	     .issue_opcode(issue2lsu_opcode),
	     .issue_mem_sgpr(issue2lsu_mem_sgpr),
	     .issue_wfid(issue2lsu_wfid),
	     .issue_lds_base(issue2lsu_lds_base),
	     .vgpr_source1_data(vgpr2lsu_source1_data),
	     .vgpr_source2_data(vgpr2lsu_source2_data),
	     .mem_rd_data(mem2lsu_rd_data),
	     .mem_tag_resp(mem2lsu_tag_resp),
	     .mem_ack(mem2lsu_ack),
	     .sgpr_source1_data(sgpr2lsu_source1_data),
	     .sgpr_source2_data(sgpr2lsu_source2_data),
	     .exec_exec_value(exec2lsu_exec_value),
	     .exec_rd_m0_value(exec2lsu_rd_m0_value),
	     .issue_instr_pc(issue2lsu_instr_pc),
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
*/
rfa rfa0 (
	     // Unit that controls access to register file
	     .clk(Bus2IP_Clk),
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
	     .execvgprsgpr_select_fu(rfa2execvgprsgpr_select_fu)
	     );

reg [31:0] lsu2vgpr_dest_addr_reg;
reg [31:0] lsu2vgpr_dest_data_reg;
reg [3:0] lsu2vgpr_dest_wr_en_reg;

wire [3:0] lsu2vgpr_dest_wr_en_thru;
wire [9:0] lsu2vgpr_dest_addr_thru;
wire [8191:0] lsu2vgpr_dest_data_thru;
wire [63:0] lsu2vgpr_dest_wr_mask_thru;

wire [9:0] lsu2vgpr_source1_addr_thru;
wire lsu2vgpr_source1_rd_en_thru;
wire [15:0] vgpr_select_fu;

assign lsu2vgpr_dest_wr_en_thru = execute ? lsu2vgpr_dest_wr_en : lsu2vgpr_dest_wr_en_reg;
assign lsu2vgpr_dest_addr_thru = execute ? lsu2vgpr_dest_addr : lsu2vgpr_dest_addr_reg[9:0];
assign lsu2vgpr_dest_data_thru = execute ? lsu2vgpr_dest_data : {256{lsu2vgpr_dest_data_reg}};

assign lsu2vgpr_source1_addr_thru = execute ? lsu2vgpr_source1_addr : lsu2vgpr_dest_addr_reg[9:0];
assign lsu2vgpr_source1_rd_en_thru = execute ? lsu2vgpr_source1_rd_en : 1'b1;

assign vgpr_select_fu = execute ? rfa2execvgprsgpr_select_fu : {7'd0, lsu2vgpr_dest_wr_en[0], 8'd0};
assign lsu2vgpr_dest_wr_mask_thru = execute ? lsu2vgpr_dest_wr_mask : {64{lsu2vgpr_dest_wr_en[0]}};

reg [2047:0] simd0_2vgpr_dest_data_reg;

always @( posedge Bus2IP_Clk) begin

  if(simd0_2vgpr_wr_en) begin
    simd0_2vgpr_dest_data_reg <= simd0_2vgpr_dest_data;
  end
  else begin
    simd0_2vgpr_dest_data_reg <= simd0_2vgpr_dest_data_reg;
  end

end


   vgpr vgpr0 (
	       // A set of vector general purpose registers
	       .clk(Bus2IP_Clk),
	       .rst(rst_signal),
         .clk_double(Double_Clk),
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
	       .lsu_dest_addr(lsu2vgpr_dest_addr_thru),
	       .lsu_dest_data(lsu2vgpr_dest_data_thru),
	       .lsu_dest_wr_en(lsu2vgpr_dest_wr_en_thru),
	       .lsu_dest_wr_mask(lsu2vgpr_dest_wr_mask_thru),
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
	       //.rfa_select_fu(rfa2execvgprsgpr_select_fu),
         .rfa_select_fu(vgpr_select_fu),
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


reg [31:0] mem_addr;
reg [31:0] mem_wr_data;
reg [3:0] mem_wr_reg;

wire [2047:0] mem_addr_muxed;
wire [8191:0] mem_wr_data_muxed;
wire [3:0] mem_wr_muxed;

assign mem_addr_muxed = execute ? lsu2mem_addr : {64{mem_addr}};
assign mem_wr_data_muxed = execute ? lsu2mem_wr_data : {256{mem_wr_data}};
assign mem_wr_muxed = execute ? lsu2mem_wr_en : mem_wr_reg;

always @ (*)  begin

if(Bus2IP_Addr[15:0] == 16'h4000 && Bus2IP_WrReq && executeState == IDLE_STATE) begin

  if(Bus2IP_Data == 32'h00000001) begin
    mem_wr_reg <= 4'b1111;
  end
  else begin
    mem_wr_reg <= 4'd0;
  end

end
else begin
  mem_wr_reg <= 4'd0;
end

end
/*
memory memory_0
(
  .clk(Bus2IP_Clk),
  .rst(rst_signal),
  .mem_gm_or_lds(lsu2mem_gm_or_lds),
  .mem_rd_en(lsu2mem_rd_en),
  .mem_wr_en(mem_wr_muxed),
  .mem_tag_req(lsu2mem_tag_req),
  .mem_tag_resp(mem2lsu_tag_resp),
  .mem_wr_mask(lsu2mem_wr_mask),
  .mem_addr(mem_addr_muxed),
  .mem_wr_data(mem_wr_data_muxed),
  .mem_rd_data(mem2lsu_rd_data),
  .mem_ack(mem2lsu_ack)
);
*/
assign lsu2sgpr_source1_addr_thru = execute ? lsu2sgpr_source1_addr : quadBaseAddress;
assign lsu2sgpr_dest_addr_thru = execute ? lsu2sgpr_dest_addr : quadBaseAddress;

always @ (*)  begin

if(Bus2IP_Addr[15:0] == 16'h2000 && Bus2IP_WrReq && executeState == IDLE_STATE) begin
  if(Bus2IP_Data == 32'h00000001) begin
    lsu2sgpr_dest_wr_en_reg <= 4'b1111;
  end
  else begin
    lsu2sgpr_dest_wr_en_reg <= 4'd0;
  end
end
else begin
  lsu2sgpr_dest_wr_en_reg <= 4'd0;
end


if(Bus2IP_Addr[15:0] == 16'h2000 && Bus2IP_WrReq && executeState == IDLE_STATE) begin
  if(Bus2IP_Data == 32'h00000002) begin
    lsu2vgpr_dest_wr_en_reg <= 4'b1111;
  end
  else begin
    lsu2vgpr_dest_wr_en_reg <= 4'd0;
  end
end
else begin
  lsu2vgpr_dest_wr_en_reg <= 4'd0;
end

end

reg [3:0] cu_state_pcounter_wr_en;
reg [31:0] cu_state_pcounter_addr_a;
reg [31:0] cu_state_pcounter_addr_b;
wire [31:0] cu_state_pcounter_out;

reg [3:0] state_wr_en;
reg [31:0] state_wr_addr;
reg [31:0] state_rd_addr;
reg [31:0] state_addr_inc;
reg [31:0] state_addr_cnt;

always @ (*)  begin

if(executeState == IDLE_STATE) begin
  execute <= 1'b0;
  cu_state_pcounter_wr_en <= 4'd0;
end
else begin
  execute <= 1'b1;
  cu_state_pcounter_wr_en <= 4'b1111;
end

if(executeState == IDLE_STATE) begin
  executeStart <= 1'b0;
  if((Bus2IP_Addr[15:0]) == 16'h0018 && Bus2IP_WrReq) begin
    executeStateNext <= DISPATCH_STATE;
  end
  else begin
    executeStateNext <= executeState;
  end
end
else if(executeState == DISPATCH_STATE) begin
  executeStart <= 1'b1;
  executeStateNext <= EXECUTE_STATE;
end
else if(executeState == EXECUTE_STATE) begin
  executeStart <= 1'b0;
  if(cu2dispatch_wf_done == 1'b1) begin
    executeStateNext <= RESULT_STATE;
  end
  else begin
    executeStateNext <= executeState;
  end
end
else if(executeState == RESULT_STATE) begin
  executeStart <= 1'b0;
  if(Bus2IP_Addr[15:0] == 16'h001C && Bus2IP_RdReq) begin
    executeStateNext <= IDLE_STATE;
  end
  else begin
    executeStateNext <= executeState;
  end
end
else begin
  executeStart <= 1'b0;
  executeStateNext <= executeState;
end

if(executeState == RESULT_STATE) begin
  resultsReady <= 32'd1;
end
else begin
  resultsReady <= 32'd0;
end

if(executeState != IDLE_STATE && executeState != RESULT_STATE && state_addr_cnt == state_addr_inc) begin
  state_wr_en <= 4'b1111;
end
else begin
  state_wr_en <= 4'd0;
end

end

always @( posedge Bus2IP_Clk) begin
  executeState <= executeStateNext;
  
  if(executeState == IDLE_STATE) begin
    cu_state_pcounter_addr_a <= 32'd0;
    state_wr_addr <= 32'd0;
    state_addr_cnt <= 32'd0;
  end
  else begin
    if(executeState != RESULT_STATE) begin
      if(state_addr_cnt == state_addr_inc) begin
        cu_state_pcounter_addr_a <= cu_state_pcounter_addr_a + 32'd4;
        state_addr_cnt <= 32'd0;
        state_wr_addr <= state_wr_addr + 32'd4;
      end
      else begin
        state_addr_cnt <= state_addr_cnt + 32'd1;
        state_wr_addr <= state_wr_addr;
      end
    end
    else begin
      cu_state_pcounter_addr_a <= 32'd0;
      state_wr_addr <= 32'd0;
      state_addr_cnt <= 32'd0;
    end
  end
end

reg rdAckReg;
reg wrAckReg;
reg addrAckReg;
reg [31:0] outputReg;

assign IP2Bus_RdAck = rdAckReg;
assign IP2Bus_WrAck = wrAckReg;
assign IP2Bus_AddrAck = addrAckReg;

assign IP2Bus_Data = outputReg;

wire[31:0] state0_out;
wire[31:0] state1_out;
wire[31:0] state2_out;
wire[31:0] state3_out;
wire[31:0] state4_out;
wire[31:0] state5_out;
wire[31:0] state6_out;
wire[31:0] state7_out;
wire[31:0] state8_out;
wire[31:0] state9_out;
wire[31:0] state10_out;
wire[31:0] state11_out;
wire[31:0] state12_out;
wire[31:0] state13_out;
wire[31:0] state14_out;
wire[31:0] state15_out;
wire[31:0] state16_out;
wire[31:0] state17_out;
wire[31:0] state18_out;
wire[31:0] state19_out;
wire[31:0] state20_out;
wire[31:0] state21_out;
wire[31:0] state22_out;
wire[31:0] state23_out;
wire[31:0] state24_out;
wire[31:0] state25_out;
wire[31:0] state26_out;
wire[31:0] state27_out;

block_ram state0
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(fetch2tracemon_dispatch), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state0_out) // output [31 : 0] doutb
);

block_ram state1
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(fetch2tracemon_wf_tag), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state1_out) // output [31 : 0] doutb
);

block_ram state2
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(fetch2tracemon_new_wfid), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state2_out) // output [31 : 0] doutb
);

block_ram state3
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(decode2tracemon_collinstr[31:0]), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state3_out) // output [31 : 0] doutb
);

block_ram state4
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(decode2tracemon_collinstr[63:32]), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state4_out) // output [31 : 0] doutb
);

block_ram state5
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(decode2tracemon_colldone), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state5_out) // output [31 : 0] doutb
);

block_ram state6
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(issue2tracemon_barrier_retire_en), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state6_out) // output [31 : 0] doutb
);

block_ram state7
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(issue2tracemon_barrier_retire_wf_bitmap[31:0]), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state7_out) // output [31 : 0] doutb
);

block_ram state8
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(issue2tracemon_barrier_retire_wf_bitmap[39:32]), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state8_out) // output [31 : 0] doutb
);

block_ram state9
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(issue2tracemon_barrier_retire_pc), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state9_out) // output [31 : 0] doutb
);

block_ram state10
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(issue2tracemon_waitcnt_retire_en), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state10_out) // output [31 : 0] doutb
);

block_ram state11
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(issue2tracemon_waitcnt_retire_wfid), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state11_out) // output [31 : 0] doutb
);

block_ram state12
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(issue2tracemon_waitcnt_retire_pc), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state12_out) // output [31 : 0] doutb
);

block_ram state13
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(simd0_2tracemon_retire_pc), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state13_out) // output [31 : 0] doutb
);

block_ram state14
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(simf0_2tracemon_retire_pc), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state14_out) // output [31 : 0] doutb
);

block_ram state15
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(simd0_2vgpr_source1_addr), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state15_out) // output [31 : 0] doutb
);

block_ram state16
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(simd0_2vgpr_source2_addr), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state16_out) // output [31 : 0] doutb
);

block_ram state17
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(simd0_2vgpr_source3_addr), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state17_out) // output [31 : 0] doutb
);

block_ram state18
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(simf0_2vgpr_source1_addr), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state18_out) // output [31 : 0] doutb
);


block_ram state19
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(simf0_2vgpr_source2_addr), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state19_out) // output [31 : 0] doutb
);

block_ram state20
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(salu2sgpr_source1_addr), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state20_out) // output [31 : 0] doutb
);

block_ram state21
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(salu2sgpr_source2_addr), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state21_out) // output [31 : 0] doutb
);

block_ram state22
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(salu2sgpr_dest_addr), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state22_out) // output [31 : 0] doutb
);

block_ram state23
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(simxlsu_muxed_wr_en_out), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state23_out) // output [31 : 0] doutb
);

block_ram state24
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(final_port0_addr_out), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state24_out) // output [31 : 0] doutb
);

block_ram state25
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(salu2sgpr_source1_rd_en), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state25_out) // output [31 : 0] doutb
);

block_ram state26
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(final_port0_data_out), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state26_out) // output [31 : 0] doutb
);

block_ram state27
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(state_wr_en), // input [3 : 0] wea
  .addra(state_wr_addr), // input [31 : 0] addra
  .dina(salu2sgpr_dest_wr_en), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(state_rd_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(state27_out) // output [31 : 0] doutb
);


reg Double_Clk_reg;

reg [38:0] fetch2buff_tag_reg;
reg fetch2buff_rd_en_reg;
//reg [31:0] buff2wave_instr_reg;
reg [3:0] instrBuffWrEn;
reg [31:0] instrAddrReg;

wire [31:0] instruction_buff_out_a;
wire [31:0] instruction_buff_out_b;

assign buff2wave_tag = fetch2buff_tag_reg;
assign buff2fetchwave_ack = fetch2buff_rd_en_reg;
assign buff2wave_instr = instruction_buff_out_b;

always @( posedge Bus2IP_Clk) begin
  fetch2buff_tag_reg <= fetch2buff_tag;
  fetch2buff_rd_en_reg <= fetch2buff_rd_en;
  //buff2wave_instr_reg <= instruction_buff_out_b;
end

always @ (*)  begin

if(Bus2IP_Addr[15:0] == 16'h1000 && Bus2IP_WrReq) begin
  instrBuffWrEn <= 4'b1111;
end
else begin
  instrBuffWrEn <= 4'd0;
end

end

block_ram instruction_buffer
(
  .clka(Bus2IP_Clk), // input clka
  //.rsta(rst), // input rsta
  .wea(instrBuffWrEn), // input [3 : 0] wea
  .addra(instrAddrReg), // input [31 : 0] addra
  .dina(Bus2IP_Data), // input [31 : 0] dina
  .douta(instruction_buff_out_a), // output [31 : 0] douta
  .clkb(Bus2IP_Clk), // input clkb
  //.rstb(rst), // input rstb
  .web(4'd0), // input [3 : 0] web
  .addrb(fetch2buff_addr), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(instruction_buff_out_b) // output [31 : 0] doutb
);

always @( posedge Bus2IP_Clk) begin
  if(Bus2IP_Resetn == 1'b0) begin
    outputReg <= 32'd0;
    instrAddrReg <= 32'd0;
    
    waveID <= 32'd0;
    baseVGPR <= 32'd0;
    baseSGPR <= 32'd0;
    baseLDS <= 32'd0;
    waveCount <= 32'd0;
    pcStart <= 32'd0;
    resultsReadyTag <= 32'd0;
    
    state_rd_addr <= 32'd0;
    sgpr_dispatch_2_addr <= 32'd0;
    
    lsu2vgpr_dest_addr_reg <= 32'd0;
    lsu2vgpr_dest_data_reg <= 32'd0;
    
    state_addr_inc <= 32'd0;
    Double_Clk_reg <= 1'b0;
  end
  else begin
    Double_Clk_reg <= Double_Clk;
    if(~Bus2IP_RNW & Bus2IP_WrReq) begin
      rdAckReg <= 1'b0;
      wrAckReg <= 1'b1;
      addrAckReg <= 1'b1;
      outputReg <= outputReg;
      
      case(Bus2IP_Addr[15:0])
        // Control Interface
        16'h0000: waveID <= Bus2IP_Data;
        16'h0004: baseVGPR <= Bus2IP_Data;
        16'h0008: baseSGPR <= Bus2IP_Data;
        16'h000C: baseLDS <= Bus2IP_Data;
        16'h0010: waveCount <= Bus2IP_Data;
        16'h0014: pcStart <= Bus2IP_Data;
        
        // Instruction loading
        16'h1004: instrAddrReg <= Bus2IP_Data;
        
        // Register loading
        16'h2004: quadBaseAddress <= Bus2IP_Data[8:0];
        16'h2008: quadData0 <= Bus2IP_Data;
        16'h200C: quadData1 <= Bus2IP_Data;
        16'h2010: quadData2 <= Bus2IP_Data;
        16'h2014: quadData3 <= Bus2IP_Data;
        16'h2018: sgpr_dispatch_2_addr <= Bus2IP_Data;
        16'h201C:  lsu2vgpr_dest_addr_reg <= Bus2IP_Data;
        16'h2020:  lsu2vgpr_dest_data_reg <= Bus2IP_Data;
        
        // State Interface
        16'h3000: state_rd_addr <= Bus2IP_Data;
        16'h3004: state_addr_inc <= Bus2IP_Data;
        
        // Memory Interface
        16'h4004: mem_addr <= Bus2IP_Data;
        16'h4008: mem_wr_data <= Bus2IP_Data;
      endcase
      
    end
    else if(Bus2IP_RNW & Bus2IP_RdReq) begin
      rdAckReg <= 1'b1;
      wrAckReg <= 1'b0;
      addrAckReg <= 1'b1;
      
      case(Bus2IP_Addr[15:0])
        // Control Interface
        16'h0000: outputReg <= waveID;
        16'h0004: outputReg <= baseVGPR;
        16'h0008: outputReg <= baseSGPR;
        16'h000C: outputReg <= baseLDS;
        16'h0010: outputReg <= waveCount;
        16'h0014: outputReg <= pcStart;
        16'h001C: outputReg <= resultsReady;
        16'h0020: outputReg <= Double_Clk_reg;
        
        // Instruction loading
        16'h1000: outputReg <= instruction_buff_out_a;
        16'h1004: outputReg <= instrAddrReg;
        
        // Register Interface
        16'h2004: outputReg <= quadBaseAddress;
        16'h2008: outputReg <= sgpr2lsu_source1_data[31:0];
        16'h200C: outputReg <= sgpr2lsu_source1_data[63:32];
        16'h2010: outputReg <= sgpr2lsu_source1_data[95:64];
        16'h2014: outputReg <= sgpr2lsu_source1_data[127:96];
        16'h2018: outputReg <= sgpr_dispatch_2_addr;
        16'h201C: outputReg <= sgpr2salu_source2_data[31:0];
        16'h2020: outputReg <= sgpr2salu_source2_data[63:32];
        
        16'h2024: outputReg <= vgpr2lsu_source1_data[31:0];
        16'h2028: outputReg <= vgpr2lsu_source1_data[63:32];
        16'h202C: outputReg <= vgpr2lsu_source1_data[95:64];
        16'h2030: outputReg <= vgpr2lsu_source1_data[127:96];
        16'h2034: outputReg <= vgpr2lsu_source1_data[159:128];
        16'h2038: outputReg <= vgpr2lsu_source1_data[191:160];
        16'h203C: outputReg <= vgpr2lsu_source1_data[223:192];
        16'h2040: outputReg <= vgpr2lsu_source1_data[255:224];
        16'h2044: outputReg <= vgpr2lsu_source1_data[287:256];
        16'h2048: outputReg <= vgpr2lsu_source1_data[319:288];
        16'h204C: outputReg <= vgpr2lsu_source1_data[351:320];
        16'h2050: outputReg <= vgpr2lsu_source1_data[383:352];
        16'h2054: outputReg <= vgpr2lsu_source1_data[415:384];
        16'h2058: outputReg <= vgpr2lsu_source1_data[447:416];
        16'h205C: outputReg <= vgpr2lsu_source1_data[480:448];
        16'h2060: outputReg <= vgpr2lsu_source1_data[511:480];
        16'h2064: outputReg <= vgpr2lsu_source1_data[543:512];
        16'h2068: outputReg <= vgpr2lsu_source1_data[575:544];
        16'h206C: outputReg <= vgpr2lsu_source1_data[607:576];
        16'h2070: outputReg <= vgpr2lsu_source1_data[639:608];
        16'h2074: outputReg <= vgpr2lsu_source1_data[671:640];
        16'h2078: outputReg <= vgpr2lsu_source1_data[703:672];
        16'h207C: outputReg <= vgpr2lsu_source1_data[735:704];
        16'h2080: outputReg <= vgpr2lsu_source1_data[767:736];
        16'h2084: outputReg <= vgpr2lsu_source1_data[799:768];
        16'h2088: outputReg <= vgpr2lsu_source1_data[831:800];
        16'h208C: outputReg <= vgpr2lsu_source1_data[863:832];
        16'h2090: outputReg <= vgpr2lsu_source1_data[895:864];
        16'h2094: outputReg <= vgpr2lsu_source1_data[927:896];
        16'h2098: outputReg <= vgpr2lsu_source1_data[959:928];
        16'h209C: outputReg <= vgpr2lsu_source1_data[991:960];
        16'h2100: outputReg <= vgpr2lsu_source1_data[1023:992];
        16'h2104: outputReg <= vgpr2lsu_source1_data[1055:1024];
        16'h2108: outputReg <= vgpr2lsu_source1_data[1087:1056];
        16'h210C: outputReg <= vgpr2lsu_source1_data[1119:1088];
        16'h2110: outputReg <= vgpr2lsu_source1_data[1151:1120];
        16'h2114: outputReg <= vgpr2lsu_source1_data[1183:1152];
        16'h2118: outputReg <= vgpr2lsu_source1_data[1215:1184];
        16'h211C: outputReg <= vgpr2lsu_source1_data[1247:1216];
        16'h2120: outputReg <= vgpr2lsu_source1_data[1279:1248];
        16'h2124: outputReg <= vgpr2lsu_source1_data[1311:1280];
        16'h2128: outputReg <= vgpr2lsu_source1_data[1343:1312];
        16'h212C: outputReg <= vgpr2lsu_source1_data[1375:1344];
        16'h2120: outputReg <= vgpr2lsu_source1_data[1407:1376];
        16'h2124: outputReg <= vgpr2lsu_source1_data[1439:1408];
        16'h2128: outputReg <= vgpr2lsu_source1_data[1471:1440];
        16'h212C: outputReg <= vgpr2lsu_source1_data[1503:1472];
        16'h2130: outputReg <= vgpr2lsu_source1_data[1535:1504];
        16'h2134: outputReg <= vgpr2lsu_source1_data[1567:1536];
        16'h2138: outputReg <= vgpr2lsu_source1_data[1599:1568];
        16'h213C: outputReg <= vgpr2lsu_source1_data[1631:1600];
        16'h2140: outputReg <= vgpr2lsu_source1_data[1663:1632];
        16'h2144: outputReg <= vgpr2lsu_source1_data[1695:1664];
        16'h2148: outputReg <= vgpr2lsu_source1_data[1727:1696];
        16'h214C: outputReg <= vgpr2lsu_source1_data[1759:1728];
        16'h2150: outputReg <= vgpr2lsu_source1_data[1791:1760];
        16'h2154: outputReg <= vgpr2lsu_source1_data[1823:1792];
        16'h2158: outputReg <= vgpr2lsu_source1_data[1855:1824];
        16'h215C: outputReg <= vgpr2lsu_source1_data[1887:1856];
        16'h2160: outputReg <= vgpr2lsu_source1_data[1919:1888];
        16'h2164: outputReg <= vgpr2lsu_source1_data[1951:1920];
        16'h2168: outputReg <= vgpr2lsu_source1_data[1983:1952];
        16'h216C: outputReg <= vgpr2lsu_source1_data[2015:1984];
        16'h2170: outputReg <= vgpr2lsu_source1_data[2047:2016];
        
        // State Interface
        16'h3000: outputReg <= state0_out;
        16'h3004: outputReg <= state1_out;
        16'h3008: outputReg <= state2_out;
        16'h300C: outputReg <= state3_out;
        16'h3010: outputReg <= state4_out;
        16'h3014: outputReg <= state5_out;
        16'h3018: outputReg <= state6_out;
        16'h301C: outputReg <= state7_out;
        16'h3020: outputReg <= state8_out;
        16'h3024: outputReg <= state9_out;
        16'h3028: outputReg <= state10_out;
        16'h302C: outputReg <= state11_out;
        16'h3030: outputReg <= state12_out;
        16'h3034: outputReg <= state13_out;
        16'h3038: outputReg <= state14_out;
        16'h303C: outputReg <= state15_out;
        16'h3040: outputReg <= state16_out;
        16'h3044: outputReg <= state17_out;
        16'h3048: outputReg <= state18_out;
        16'h304C: outputReg <= state19_out;
        16'h3050: outputReg <= state20_out;
        16'h3054: outputReg <= state21_out;
        16'h3058: outputReg <= state22_out;
        16'h305C: outputReg <= state23_out;
        16'h3060: outputReg <= state24_out;
        16'h3064: outputReg <= state25_out;
        16'h3068: outputReg <= state26_out;
        16'h306C: outputReg <= state27_out;
        /*
        16'h3070: outputReg <= state_out_27;
        16'h3074: outputReg <= state_out_28;
        16'h3078: outputReg <= state_out_29;
        16'h307C: outputReg <= state_out_30;
        16'h3080: outputReg <= state_out_31;
        16'h3084: outputReg <= state_out_32;
        16'h3088: outputReg <= state_out_33;
        16'h308C: outputReg <= state_out_34;
        16'h3090: outputReg <= state_out_35;
        16'h3094: outputReg <= state_out_36;
        16'h3098: outputReg <= state_out_37;
        16'h309C: outputReg <= state_out_38;
        16'h3100: outputReg <= state_out_39;
        16'h3104: outputReg <= state_out_40;
        16'h3108: outputReg <= state_out_41;
        16'h310C: outputReg <= state_out_42;
        16'h3110: outputReg <= state_out_43;
        16'h3114: outputReg <= state_out_44;
        //16'h3118: outputReg <= rst_state_out;
        */
        16'h4000: outputReg <= mem2lsu_rd_data[31:0];
        16'h4004: outputReg <= mem2lsu_rd_data[63:32];
        16'h4008: outputReg <= mem2lsu_rd_data[95:64];
        16'h400c: outputReg <= mem2lsu_rd_data[127:96];
        16'h4010: outputReg <= mem2lsu_rd_data[159:128];
        16'h4014: outputReg <= mem2lsu_rd_data[191:160];
        16'h4018: outputReg <= mem2lsu_rd_data[223:192];
        16'h401c: outputReg <= mem2lsu_rd_data[255:224];
        16'h4020: outputReg <= mem2lsu_rd_data[287:256];
        16'h4024: outputReg <= mem2lsu_rd_data[319:288];
        16'h4028: outputReg <= mem2lsu_rd_data[351:320];
        16'h402c: outputReg <= mem2lsu_rd_data[383:352];
        16'h4030: outputReg <= mem2lsu_rd_data[415:384];
        16'h4034: outputReg <= mem2lsu_rd_data[447:416];
        16'h4038: outputReg <= mem2lsu_rd_data[479:448];
        16'h403c: outputReg <= mem2lsu_rd_data[511:480];
        16'h4040: outputReg <= mem2lsu_rd_data[543:512];
        16'h4044: outputReg <= mem2lsu_rd_data[575:544];
        16'h4048: outputReg <= mem2lsu_rd_data[607:576];
        16'h404c: outputReg <= mem2lsu_rd_data[639:608];
        16'h4050: outputReg <= mem2lsu_rd_data[671:640];
        16'h4054: outputReg <= mem2lsu_rd_data[703:672];
        16'h4058: outputReg <= mem2lsu_rd_data[735:704];
        16'h405c: outputReg <= mem2lsu_rd_data[767:736];
        16'h4060: outputReg <= mem2lsu_rd_data[799:768];
        16'h4064: outputReg <= mem2lsu_rd_data[831:800];
        16'h4068: outputReg <= mem2lsu_rd_data[863:832];
        16'h406c: outputReg <= mem2lsu_rd_data[895:864];
        16'h4070: outputReg <= mem2lsu_rd_data[927:896];
        16'h4074: outputReg <= mem2lsu_rd_data[959:928];
        16'h4078: outputReg <= mem2lsu_rd_data[991:960];
        16'h407c: outputReg <= mem2lsu_rd_data[1023:992];
        16'h4080: outputReg <= mem2lsu_rd_data[1055:1024];
        16'h4084: outputReg <= mem2lsu_rd_data[1087:1056];
        16'h4088: outputReg <= mem2lsu_rd_data[1119:1088];
        16'h408c: outputReg <= mem2lsu_rd_data[1151:1120];
        16'h4090: outputReg <= mem2lsu_rd_data[1183:1152];
        16'h4094: outputReg <= mem2lsu_rd_data[1215:1184];
        16'h4098: outputReg <= mem2lsu_rd_data[1247:1216];
        16'h409c: outputReg <= mem2lsu_rd_data[1279:1248];
        16'h40a0: outputReg <= mem2lsu_rd_data[1311:1280];
        16'h40a4: outputReg <= mem2lsu_rd_data[1343:1312];
        16'h40a8: outputReg <= mem2lsu_rd_data[1375:1344];
        16'h40ac: outputReg <= mem2lsu_rd_data[1407:1376];
        16'h40b0: outputReg <= mem2lsu_rd_data[1439:1408];
        16'h40b4: outputReg <= mem2lsu_rd_data[1471:1440];
        16'h40b8: outputReg <= mem2lsu_rd_data[1503:1472];
        16'h40bc: outputReg <= mem2lsu_rd_data[1535:1504];
        16'h40c0: outputReg <= mem2lsu_rd_data[1567:1536];
        16'h40c4: outputReg <= mem2lsu_rd_data[1599:1568];
        16'h40c8: outputReg <= mem2lsu_rd_data[1631:1600];
        16'h40cc: outputReg <= mem2lsu_rd_data[1663:1632];
        16'h40d0: outputReg <= mem2lsu_rd_data[1695:1664];
        16'h40d4: outputReg <= mem2lsu_rd_data[1727:1696];
        16'h40d8: outputReg <= mem2lsu_rd_data[1759:1728];
        16'h40dc: outputReg <= mem2lsu_rd_data[1791:1760];
        16'h40e0: outputReg <= mem2lsu_rd_data[1823:1792];
        16'h40e4: outputReg <= mem2lsu_rd_data[1855:1824];
        16'h40e8: outputReg <= mem2lsu_rd_data[1887:1856];
        16'h40ec: outputReg <= mem2lsu_rd_data[1919:1888];
        16'h40f0: outputReg <= mem2lsu_rd_data[1951:1920];
        16'h40f4: outputReg <= mem2lsu_rd_data[1983:1952];
        16'h40f8: outputReg <= mem2lsu_rd_data[2015:1984];
        16'h40fc: outputReg <= mem2lsu_rd_data[2047:2016];
        16'h4100: outputReg <= mem2lsu_rd_data[2079:2048];
        16'h4104: outputReg <= mem2lsu_rd_data[2111:2080];
        16'h4108: outputReg <= mem2lsu_rd_data[2143:2112];
        16'h410c: outputReg <= mem2lsu_rd_data[2175:2144];
        16'h4110: outputReg <= mem2lsu_rd_data[2207:2176];
        16'h4114: outputReg <= mem2lsu_rd_data[2239:2208];
        16'h4118: outputReg <= mem2lsu_rd_data[2271:2240];
        16'h411c: outputReg <= mem2lsu_rd_data[2303:2272];
        16'h4120: outputReg <= mem2lsu_rd_data[2335:2304];
        16'h4124: outputReg <= mem2lsu_rd_data[2367:2336];
        16'h4128: outputReg <= mem2lsu_rd_data[2399:2368];
        16'h412c: outputReg <= mem2lsu_rd_data[2431:2400];
        16'h4130: outputReg <= mem2lsu_rd_data[2463:2432];
        16'h4134: outputReg <= mem2lsu_rd_data[2495:2464];
        16'h4138: outputReg <= mem2lsu_rd_data[2527:2496];
        16'h413c: outputReg <= mem2lsu_rd_data[2559:2528];
        16'h4140: outputReg <= mem2lsu_rd_data[2591:2560];
        16'h4144: outputReg <= mem2lsu_rd_data[2623:2592];
        16'h4148: outputReg <= mem2lsu_rd_data[2655:2624];
        16'h414c: outputReg <= mem2lsu_rd_data[2687:2656];
        16'h4150: outputReg <= mem2lsu_rd_data[2719:2688];
        16'h4154: outputReg <= mem2lsu_rd_data[2751:2720];
        16'h4158: outputReg <= mem2lsu_rd_data[2783:2752];
        16'h415c: outputReg <= mem2lsu_rd_data[2815:2784];
        16'h4160: outputReg <= mem2lsu_rd_data[2847:2816];
        16'h4164: outputReg <= mem2lsu_rd_data[2879:2848];
        16'h4168: outputReg <= mem2lsu_rd_data[2911:2880];
        16'h416c: outputReg <= mem2lsu_rd_data[2943:2912];
        16'h4170: outputReg <= mem2lsu_rd_data[2975:2944];
        16'h4174: outputReg <= mem2lsu_rd_data[3007:2976];
        16'h4178: outputReg <= mem2lsu_rd_data[3039:3008];
        16'h417c: outputReg <= mem2lsu_rd_data[3071:3040];
        16'h4180: outputReg <= mem2lsu_rd_data[3103:3072];
        16'h4184: outputReg <= mem2lsu_rd_data[3135:3104];
        16'h4188: outputReg <= mem2lsu_rd_data[3167:3136];
        16'h418c: outputReg <= mem2lsu_rd_data[3199:3168];
        16'h4190: outputReg <= mem2lsu_rd_data[3231:3200];
        16'h4194: outputReg <= mem2lsu_rd_data[3263:3232];
        16'h4198: outputReg <= mem2lsu_rd_data[3295:3264];
        16'h419c: outputReg <= mem2lsu_rd_data[3327:3296];
        16'h41a0: outputReg <= mem2lsu_rd_data[3359:3328];
        16'h41a4: outputReg <= mem2lsu_rd_data[3391:3360];
        16'h41a8: outputReg <= mem2lsu_rd_data[3423:3392];
        16'h41ac: outputReg <= mem2lsu_rd_data[3455:3424];
        16'h41b0: outputReg <= mem2lsu_rd_data[3487:3456];
        16'h41b4: outputReg <= mem2lsu_rd_data[3519:3488];
        16'h41b8: outputReg <= mem2lsu_rd_data[3551:3520];
        16'h41bc: outputReg <= mem2lsu_rd_data[3583:3552];
        16'h41c0: outputReg <= mem2lsu_rd_data[3615:3584];
        16'h41c4: outputReg <= mem2lsu_rd_data[3647:3616];
        16'h41c8: outputReg <= mem2lsu_rd_data[3679:3648];
        16'h41cc: outputReg <= mem2lsu_rd_data[3711:3680];
        16'h41d0: outputReg <= mem2lsu_rd_data[3743:3712];
        16'h41d4: outputReg <= mem2lsu_rd_data[3775:3744];
        16'h41d8: outputReg <= mem2lsu_rd_data[3807:3776];
        16'h41dc: outputReg <= mem2lsu_rd_data[3839:3808];
        16'h41e0: outputReg <= mem2lsu_rd_data[3871:3840];
        16'h41e4: outputReg <= mem2lsu_rd_data[3903:3872];
        16'h41e8: outputReg <= mem2lsu_rd_data[3935:3904];
        16'h41ec: outputReg <= mem2lsu_rd_data[3967:3936];
        16'h41f0: outputReg <= mem2lsu_rd_data[3999:3968];
        16'h41f4: outputReg <= mem2lsu_rd_data[4031:4000];
        16'h41f8: outputReg <= mem2lsu_rd_data[4063:4032];
        16'h41fc: outputReg <= mem2lsu_rd_data[4095:4064];
        16'h4200: outputReg <= mem2lsu_rd_data[4127:4096];
        16'h4204: outputReg <= mem2lsu_rd_data[4159:4128];
        16'h4208: outputReg <= mem2lsu_rd_data[4191:4160];
        16'h420c: outputReg <= mem2lsu_rd_data[4223:4192];
        16'h4210: outputReg <= mem2lsu_rd_data[4255:4224];
        16'h4214: outputReg <= mem2lsu_rd_data[4287:4256];
        16'h4218: outputReg <= mem2lsu_rd_data[4319:4288];
        16'h421c: outputReg <= mem2lsu_rd_data[4351:4320];
        16'h4220: outputReg <= mem2lsu_rd_data[4383:4352];
        16'h4224: outputReg <= mem2lsu_rd_data[4415:4384];
        16'h4228: outputReg <= mem2lsu_rd_data[4447:4416];
        16'h422c: outputReg <= mem2lsu_rd_data[4479:4448];
        16'h4230: outputReg <= mem2lsu_rd_data[4511:4480];
        16'h4234: outputReg <= mem2lsu_rd_data[4543:4512];
        16'h4238: outputReg <= mem2lsu_rd_data[4575:4544];
        16'h423c: outputReg <= mem2lsu_rd_data[4607:4576];
        16'h4240: outputReg <= mem2lsu_rd_data[4639:4608];
        16'h4244: outputReg <= mem2lsu_rd_data[4671:4640];
        16'h4248: outputReg <= mem2lsu_rd_data[4703:4672];
        16'h424c: outputReg <= mem2lsu_rd_data[4735:4704];
        16'h4250: outputReg <= mem2lsu_rd_data[4767:4736];
        16'h4254: outputReg <= mem2lsu_rd_data[4799:4768];
        16'h4258: outputReg <= mem2lsu_rd_data[4831:4800];
        16'h425c: outputReg <= mem2lsu_rd_data[4863:4832];
        16'h4260: outputReg <= mem2lsu_rd_data[4895:4864];
        16'h4264: outputReg <= mem2lsu_rd_data[4927:4896];
        16'h4268: outputReg <= mem2lsu_rd_data[4959:4928];
        16'h426c: outputReg <= mem2lsu_rd_data[4991:4960];
        16'h4270: outputReg <= mem2lsu_rd_data[5023:4992];
        16'h4274: outputReg <= mem2lsu_rd_data[5055:5024];
        16'h4278: outputReg <= mem2lsu_rd_data[5087:5056];
        16'h427c: outputReg <= mem2lsu_rd_data[5119:5088];
        16'h4280: outputReg <= mem2lsu_rd_data[5151:5120];
        16'h4284: outputReg <= mem2lsu_rd_data[5183:5152];
        16'h4288: outputReg <= mem2lsu_rd_data[5215:5184];
        16'h428c: outputReg <= mem2lsu_rd_data[5247:5216];
        16'h4290: outputReg <= mem2lsu_rd_data[5279:5248];
        16'h4294: outputReg <= mem2lsu_rd_data[5311:5280];
        16'h4298: outputReg <= mem2lsu_rd_data[5343:5312];
        16'h429c: outputReg <= mem2lsu_rd_data[5375:5344];
        16'h42a0: outputReg <= mem2lsu_rd_data[5407:5376];
        16'h42a4: outputReg <= mem2lsu_rd_data[5439:5408];
        16'h42a8: outputReg <= mem2lsu_rd_data[5471:5440];
        16'h42ac: outputReg <= mem2lsu_rd_data[5503:5472];
        16'h42b0: outputReg <= mem2lsu_rd_data[5535:5504];
        16'h42b4: outputReg <= mem2lsu_rd_data[5567:5536];
        16'h42b8: outputReg <= mem2lsu_rd_data[5599:5568];
        16'h42bc: outputReg <= mem2lsu_rd_data[5631:5600];
        16'h42c0: outputReg <= mem2lsu_rd_data[5663:5632];
        16'h42c4: outputReg <= mem2lsu_rd_data[5695:5664];
        16'h42c8: outputReg <= mem2lsu_rd_data[5727:5696];
        16'h42cc: outputReg <= mem2lsu_rd_data[5759:5728];
        16'h42d0: outputReg <= mem2lsu_rd_data[5791:5760];
        16'h42d4: outputReg <= mem2lsu_rd_data[5823:5792];
        16'h42d8: outputReg <= mem2lsu_rd_data[5855:5824];
        16'h42dc: outputReg <= mem2lsu_rd_data[5887:5856];
        16'h42e0: outputReg <= mem2lsu_rd_data[5919:5888];
        16'h42e4: outputReg <= mem2lsu_rd_data[5951:5920];
        16'h42e8: outputReg <= mem2lsu_rd_data[5983:5952];
        16'h42ec: outputReg <= mem2lsu_rd_data[6015:5984];
        16'h42f0: outputReg <= mem2lsu_rd_data[6047:6016];
        16'h42f4: outputReg <= mem2lsu_rd_data[6079:6048];
        16'h42f8: outputReg <= mem2lsu_rd_data[6111:6080];
        16'h42fc: outputReg <= mem2lsu_rd_data[6143:6112];
        16'h4300: outputReg <= mem2lsu_rd_data[6175:6144];
        16'h4304: outputReg <= mem2lsu_rd_data[6207:6176];
        16'h4308: outputReg <= mem2lsu_rd_data[6239:6208];
        16'h430c: outputReg <= mem2lsu_rd_data[6271:6240];
        16'h4310: outputReg <= mem2lsu_rd_data[6303:6272];
        16'h4314: outputReg <= mem2lsu_rd_data[6335:6304];
        16'h4318: outputReg <= mem2lsu_rd_data[6367:6336];
        16'h431c: outputReg <= mem2lsu_rd_data[6399:6368];
        16'h4320: outputReg <= mem2lsu_rd_data[6431:6400];
        16'h4324: outputReg <= mem2lsu_rd_data[6463:6432];
        16'h4328: outputReg <= mem2lsu_rd_data[6495:6464];
        16'h432c: outputReg <= mem2lsu_rd_data[6527:6496];
        16'h4330: outputReg <= mem2lsu_rd_data[6559:6528];
        16'h4334: outputReg <= mem2lsu_rd_data[6591:6560];
        16'h4338: outputReg <= mem2lsu_rd_data[6623:6592];
        16'h433c: outputReg <= mem2lsu_rd_data[6655:6624];
        16'h4340: outputReg <= mem2lsu_rd_data[6687:6656];
        16'h4344: outputReg <= mem2lsu_rd_data[6719:6688];
        16'h4348: outputReg <= mem2lsu_rd_data[6751:6720];
        16'h434c: outputReg <= mem2lsu_rd_data[6783:6752];
        16'h4350: outputReg <= mem2lsu_rd_data[6815:6784];
        16'h4354: outputReg <= mem2lsu_rd_data[6847:6816];
        16'h4358: outputReg <= mem2lsu_rd_data[6879:6848];
        16'h435c: outputReg <= mem2lsu_rd_data[6911:6880];
        16'h4360: outputReg <= mem2lsu_rd_data[6943:6912];
        16'h4364: outputReg <= mem2lsu_rd_data[6975:6944];
        16'h4368: outputReg <= mem2lsu_rd_data[7007:6976];
        16'h436c: outputReg <= mem2lsu_rd_data[7039:7008];
        16'h4370: outputReg <= mem2lsu_rd_data[7071:7040];
        16'h4374: outputReg <= mem2lsu_rd_data[7103:7072];
        16'h4378: outputReg <= mem2lsu_rd_data[7135:7104];
        16'h437c: outputReg <= mem2lsu_rd_data[7167:7136];
        16'h4380: outputReg <= mem2lsu_rd_data[7199:7168];
        16'h4384: outputReg <= mem2lsu_rd_data[7231:7200];
        16'h4388: outputReg <= mem2lsu_rd_data[7263:7232];
        16'h438c: outputReg <= mem2lsu_rd_data[7295:7264];
        16'h4390: outputReg <= mem2lsu_rd_data[7327:7296];
        16'h4394: outputReg <= mem2lsu_rd_data[7359:7328];
        16'h4398: outputReg <= mem2lsu_rd_data[7391:7360];
        16'h439c: outputReg <= mem2lsu_rd_data[7423:7392];
        16'h43a0: outputReg <= mem2lsu_rd_data[7455:7424];
        16'h43a4: outputReg <= mem2lsu_rd_data[7487:7456];
        16'h43a8: outputReg <= mem2lsu_rd_data[7519:7488];
        16'h43ac: outputReg <= mem2lsu_rd_data[7551:7520];
        16'h43b0: outputReg <= mem2lsu_rd_data[7583:7552];
        16'h43b4: outputReg <= mem2lsu_rd_data[7615:7584];
        16'h43b8: outputReg <= mem2lsu_rd_data[7647:7616];
        16'h43bc: outputReg <= mem2lsu_rd_data[7679:7648];
        16'h43c0: outputReg <= mem2lsu_rd_data[7711:7680];
        16'h43c4: outputReg <= mem2lsu_rd_data[7743:7712];
        16'h43c8: outputReg <= mem2lsu_rd_data[7775:7744];
        16'h43cc: outputReg <= mem2lsu_rd_data[7807:7776];
        16'h43d0: outputReg <= mem2lsu_rd_data[7839:7808];
        16'h43d4: outputReg <= mem2lsu_rd_data[7871:7840];
        16'h43d8: outputReg <= mem2lsu_rd_data[7903:7872];
        16'h43dc: outputReg <= mem2lsu_rd_data[7935:7904];
        16'h43e0: outputReg <= mem2lsu_rd_data[7967:7936];
        16'h43e4: outputReg <= mem2lsu_rd_data[7999:7968];
        16'h43e8: outputReg <= mem2lsu_rd_data[8031:8000];
        16'h43ec: outputReg <= mem2lsu_rd_data[8063:8032];
        16'h43f0: outputReg <= mem2lsu_rd_data[8095:8064];
        16'h43f4: outputReg <= mem2lsu_rd_data[8127:8096];
        16'h43f8: outputReg <= mem2lsu_rd_data[8159:8128];
        16'h43fc: outputReg <= mem2lsu_rd_data[8191:8160];
        default: outputReg <= outputReg;
      endcase
    end
    else begin
      rdAckReg <= 1'b0;
      wrAckReg <= 1'b0;
      addrAckReg <= 1'b0;
      outputReg <= outputReg;
    end
  end
end

endmodule
