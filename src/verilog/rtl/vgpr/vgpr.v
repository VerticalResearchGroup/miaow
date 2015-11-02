module vgpr( 
      simd0_source1_rd_en,
      simd1_source1_rd_en,
      simd2_source1_rd_en,
      simd3_source1_rd_en,
      simd0_source2_rd_en,
      simd1_source2_rd_en,
      simd2_source2_rd_en,
      simd3_source2_rd_en,
      simd0_source3_rd_en,
      simd1_source3_rd_en,
      simd2_source3_rd_en,
      simd3_source3_rd_en,
      simd0_source1_addr,
      simd1_source1_addr,
      simd2_source1_addr,
      simd3_source1_addr,
      simd0_source2_addr,
      simd1_source2_addr,
      simd2_source2_addr,
      simd3_source2_addr,
      simd0_source3_addr,
      simd1_source3_addr,
      simd2_source3_addr,
      simd3_source3_addr,
      simd0_dest_addr,
      simd1_dest_addr,
      simd2_dest_addr,
      simd3_dest_addr,
      simd0_dest_data,
      simd1_dest_data,
      simd2_dest_data,
      simd3_dest_data,
      simd0_wr_en,
      simd1_wr_en,
      simd2_wr_en,
      simd3_wr_en,
      simd0_wr_mask,
      simd1_wr_mask,
      simd2_wr_mask,
      simd3_wr_mask,
      simf0_source1_rd_en,
      simf1_source1_rd_en,
      simf2_source1_rd_en,
      simf3_source1_rd_en,
      simf0_source2_rd_en,
      simf1_source2_rd_en,
      simf2_source2_rd_en,
      simf3_source2_rd_en,
      simf0_source3_rd_en,
      simf1_source3_rd_en,
      simf2_source3_rd_en,
      simf3_source3_rd_en,
      simf0_source1_addr,
      simf1_source1_addr,
      simf2_source1_addr,
      simf3_source1_addr,
      simf0_source2_addr,
      simf1_source2_addr,
      simf2_source2_addr,
      simf3_source2_addr,
      simf0_source3_addr,
      simf1_source3_addr,
      simf2_source3_addr,
      simf3_source3_addr,
      simf0_dest_addr,
      simf1_dest_addr,
      simf2_dest_addr,
      simf3_dest_addr,
      simf0_dest_data,
      simf1_dest_data,
      simf2_dest_data,
      simf3_dest_data,
      simf0_wr_en,
      simf1_wr_en,
      simf2_wr_en,
      simf3_wr_en,
      simf0_wr_mask,
      simf1_wr_mask,
      simf2_wr_mask,
      simf3_wr_mask,
      lsu_source1_addr,
      lsu_source2_addr,
      lsu_dest_addr,
      lsu_dest_data,
      lsu_dest_wr_mask,
      lsu_dest_wr_en,
      lsu_instr_done_wfid,
      lsu_instr_done,
      lsu_source1_rd_en,
      lsu_source2_rd_en,
      simd0_instr_done_wfid,
      simd1_instr_done_wfid,
      simd2_instr_done_wfid,
      simd3_instr_done_wfid,
      simd0_instr_done,
      simd1_instr_done,
      simd2_instr_done,
      simd3_instr_done,
      simf0_instr_done_wfid,
      simf1_instr_done_wfid,
      simf2_instr_done_wfid,
      simf3_instr_done_wfid,
      simf0_instr_done,
      simf1_instr_done,
      simf2_instr_done,
      simf3_instr_done,
      rfa_select_fu,
      simd_source1_data,
      simd_source2_data,
      simd_source3_data,
      simf_source1_data,
      simf_source2_data,
      simf_source3_data,
      lsu_source1_data,
      lsu_source2_data,
      issue_alu_wr_done_wfid,
      issue_alu_wr_done,
      issue_alu_dest_reg_addr,
      issue_alu_dest_reg_valid,
      issue_lsu_wr_done_wfid,
      issue_lsu_wr_done,
      issue_lsu_dest_reg_addr,
      issue_lsu_dest_reg_valid,
      clk,
`ifdef FPGA
      clk_double,
`endif
      rst
 );

input clk;
`ifdef FPGA
input clk_double;
`endif

input rst;

input lsu_source1_rd_en, lsu_source2_rd_en;
input simd0_source1_rd_en, simd1_source1_rd_en, simd2_source1_rd_en,
         simd3_source1_rd_en, simd0_source2_rd_en, simd1_source2_rd_en, simd2_source2_rd_en,
         simd3_source2_rd_en, simd0_source3_rd_en, simd1_source3_rd_en, simd2_source3_rd_en,
         simd3_source3_rd_en, simd0_wr_en, simd1_wr_en, simd2_wr_en, simd3_wr_en,
         simf0_source1_rd_en, simf1_source1_rd_en, simf2_source1_rd_en, simf3_source1_rd_en,
         simf0_source2_rd_en, simf1_source2_rd_en, simf2_source2_rd_en, simf3_source2_rd_en,
         simf0_source3_rd_en, simf1_source3_rd_en, simf2_source3_rd_en, simf3_source3_rd_en,
         simf0_wr_en, simf1_wr_en, simf2_wr_en, simf3_wr_en, lsu_instr_done,
         simd0_instr_done, simd1_instr_done, simd2_instr_done, simd3_instr_done,
         simf0_instr_done, simf1_instr_done, simf2_instr_done, simf3_instr_done;
input[3:0] lsu_dest_wr_en;
input[5:0] lsu_instr_done_wfid, simd0_instr_done_wfid, simd1_instr_done_wfid,
         simd2_instr_done_wfid, simd3_instr_done_wfid, simf0_instr_done_wfid,
         simf1_instr_done_wfid, simf2_instr_done_wfid, simf3_instr_done_wfid;
input[9:0] simd0_source1_addr, simd1_source1_addr, simd2_source1_addr,
         simd3_source1_addr, simd0_source2_addr, simd1_source2_addr, simd2_source2_addr,
         simd3_source2_addr, simd0_source3_addr, simd1_source3_addr, simd2_source3_addr,
         simd3_source3_addr, simd0_dest_addr, simd1_dest_addr, simd2_dest_addr,
         simd3_dest_addr, simf0_source1_addr, simf1_source1_addr, simf2_source1_addr,
         simf3_source1_addr, simf0_source2_addr, simf1_source2_addr, simf2_source2_addr,
         simf3_source2_addr, simf0_source3_addr, simf1_source3_addr, simf2_source3_addr,
         simf3_source3_addr, simf0_dest_addr, simf1_dest_addr, simf2_dest_addr,
         simf3_dest_addr, lsu_source1_addr, lsu_source2_addr, lsu_dest_addr;
input[15:0] rfa_select_fu;
input[63:0] simd0_wr_mask, simd1_wr_mask, simd2_wr_mask, simd3_wr_mask,
         simf0_wr_mask, simf1_wr_mask, simf2_wr_mask, simf3_wr_mask, lsu_dest_wr_mask;
input[2047:0] simd0_dest_data, simd1_dest_data, simd2_dest_data, simd3_dest_data,
         simf0_dest_data, simf1_dest_data, simf2_dest_data, simf3_dest_data;
// S: changed from 8k to 2k for lsu bus
input[2047:0] lsu_dest_data;
output issue_alu_wr_done, issue_alu_dest_reg_valid, issue_lsu_wr_done;
output[3:0] issue_lsu_dest_reg_valid;
output[5:0] issue_alu_wr_done_wfid, issue_lsu_wr_done_wfid;
output[9:0] issue_alu_dest_reg_addr, issue_lsu_dest_reg_addr;
output[2047:0] simd_source1_data, simd_source2_data, simd_source3_data,
         simf_source1_data, simf_source2_data, simf_source3_data,lsu_source2_data;
// S: changed from 8k to 2k for lsu bus
output[2047:0] lsu_source1_data;
///////////////////////////////
//Your code goes here - beware: script does not recognize changes
// into files. It ovewrites everithing without mercy. Save your work before running the script
///////////////////////////////
wire dummy;
assign dummy = rst;

wire [9:0] muxed_simx_source1_rd_addr;
wire muxed_simx_source1_rd_en;
wire [2047:0] muxed_simx_source1_rd_data;
wire [9:0] muxed_simx_source2_rd_addr;
wire muxed_simx_source2_rd_en;
wire [2047:0] muxed_simx_source2_rd_data;
wire [9:0] muxed_simx_source3_rd_addr;
wire muxed_simx_source3_rd_en;
wire [2047:0] muxed_simx_source3_rd_data;

// simd/simf rdport 0 mux level 1
rd_port_mux_8to1 port_mux_simx_source1 (
  .port0_rd_en(simd0_source1_rd_en),
  .port0_rd_addr(simd0_source1_addr),
  .port1_rd_en(simd1_source1_rd_en),
  .port1_rd_addr(simd1_source1_addr),
  .port2_rd_en(simd2_source1_rd_en),
  .port2_rd_addr(simd2_source1_addr),
  .port3_rd_en(simd3_source1_rd_en),
  .port3_rd_addr(simd3_source1_addr),
  .port4_rd_en(simf0_source1_rd_en),
  .port4_rd_addr(simf0_source1_addr),
  .port5_rd_en(simf1_source1_rd_en),
  .port5_rd_addr(simf1_source1_addr),
  .port6_rd_en(simf2_source1_rd_en),
  .port6_rd_addr(simf2_source1_addr),
  .port7_rd_en(simf3_source1_rd_en),
  .port7_rd_addr(simf3_source1_addr),
  .rd_data(simd_source1_data),
  .muxed_port_rd_addr(muxed_simx_source1_rd_addr),
  .muxed_port_rd_data(muxed_simx_source1_rd_data),
  .muxed_port_rd_en(muxed_simx_source1_rd_en)
);
assign simf_source1_data = simd_source1_data;

// simd/simf rdport 1 mux
rd_port_mux_8to1 port_mux_simx_source2 (
  .port0_rd_en(simd0_source2_rd_en),
  .port0_rd_addr(simd0_source2_addr),
  .port1_rd_en(simd1_source2_rd_en),
  .port1_rd_addr(simd1_source2_addr),
  .port2_rd_en(simd2_source2_rd_en),
  .port2_rd_addr(simd2_source2_addr),
  .port3_rd_en(simd3_source2_rd_en),
  .port3_rd_addr(simd3_source2_addr),
  .port4_rd_en(simf0_source2_rd_en),
  .port4_rd_addr(simf0_source2_addr),
  .port5_rd_en(simf1_source2_rd_en),
  .port5_rd_addr(simf1_source2_addr),
  .port6_rd_en(simf2_source2_rd_en),
  .port6_rd_addr(simf2_source2_addr),
  .port7_rd_en(simf3_source2_rd_en),
  .port7_rd_addr(simf3_source2_addr),
  .rd_data(simd_source2_data),
  .muxed_port_rd_addr(muxed_simx_source2_rd_addr),
  .muxed_port_rd_data(muxed_simx_source2_rd_data),
  .muxed_port_rd_en(muxed_simx_source2_rd_en)
);
assign simf_source2_data = simd_source2_data;

// simd/simf rdport 2 mux
rd_port_mux_8to1 port_mux_simx_source3 (
  .port0_rd_en(simd0_source3_rd_en),
  .port0_rd_addr(simd0_source3_addr),
  .port1_rd_en(simd1_source3_rd_en),
  .port1_rd_addr(simd1_source3_addr),
  .port2_rd_en(simd2_source3_rd_en),
  .port2_rd_addr(simd2_source3_addr),
  .port3_rd_en(simd3_source3_rd_en),
  .port3_rd_addr(simd3_source3_addr),
  .port4_rd_en(simf0_source3_rd_en),
  .port4_rd_addr(simf0_source3_addr),
  .port5_rd_en(simf1_source3_rd_en),
  .port5_rd_addr(simf1_source3_addr),
  .port6_rd_en(simf2_source3_rd_en),
  .port6_rd_addr(simf2_source3_addr),
  .port7_rd_en(simf3_source3_rd_en),
  .port7_rd_addr(simf3_source3_addr),
  .rd_data(simd_source3_data),
  .muxed_port_rd_addr(muxed_simx_source3_rd_addr),
  .muxed_port_rd_data(muxed_simx_source3_rd_data),
  .muxed_port_rd_en(muxed_simx_source3_rd_en)
);
assign simf_source3_data = simd_source3_data;

wire [2047:0] distribute_source1_data;
wire [2047:0] final_source1_data;
wire [9:0] final_source1_addr;
// change mux width to 2048
// LSU changes pending
vgpr_2to1_rd_port_mux #(2048) source1_mux ( /// override the param
  .port0_rd_en(muxed_simx_source1_rd_en),
  .port0_rd_addr(muxed_simx_source1_rd_addr),
  .port1_rd_en(lsu_source1_rd_en),
  .port1_rd_addr(lsu_source1_addr),
  .port_rd_data(distribute_source1_data),
  .rd_addr(final_source1_addr),
  .rd_data(final_source1_data)
);
assign lsu_source1_data = distribute_source1_data;

// S: shrink 8k to 2k, so no need for veriperl assignment
assign muxed_simx_source1_rd_data = distribute_source1_data;

wire [2047:0] distribute_source2_data;
wire [2047:0] final_source2_data;
wire [9:0] final_source2_addr;
vgpr_2to1_rd_port_mux #(2048) source2_mux (
  .port0_rd_en(muxed_simx_source2_rd_en),
  .port0_rd_addr(muxed_simx_source2_rd_addr),
  .port1_rd_en(lsu_source2_rd_en),
  .port1_rd_addr(lsu_source2_addr),
  .port_rd_data(distribute_source2_data),
  .rd_addr(final_source2_addr),
  .rd_data(final_source2_data)
);
assign lsu_source2_data = distribute_source2_data;
assign muxed_simx_source2_rd_data = distribute_source2_data;

//////////////////////////////////
wire [3:0] muxed_simx_dest_wr_en;
wire [63:0] muxed_simx_dest_wr_mask;
wire [9:0] muxed_simx_dest_addr;

// S: shrink to 2k
wire [2047:0] muxed_simx_dest_data;

wr_port_mux_9to1 port_mux_simx_dest (
  .wr_port_select(rfa_select_fu),
  .port0_wr_en({ {3{1'b0}}, simd0_wr_en}),
  .port0_wr_mask(simd0_wr_mask),
  .port0_wr_addr(simd0_dest_addr),
  .port0_wr_data(simd0_dest_data),
  .port1_wr_en({ {3{1'b0}}, simd1_wr_en}),
  .port1_wr_mask(simd1_wr_mask),
  .port1_wr_addr(simd1_dest_addr),
  .port1_wr_data(simd1_dest_data),
  .port2_wr_en({ {3{1'b0}}, simd2_wr_en}),
  .port2_wr_mask(simd2_wr_mask),
  .port2_wr_addr(simd2_dest_addr),
  .port2_wr_data(simd2_dest_data),
  .port3_wr_en({ {3{1'b0}}, simd3_wr_en}),
  .port3_wr_mask(simd3_wr_mask),
  .port3_wr_addr(simd3_dest_addr),
  .port3_wr_data(simd3_dest_data),
  .port4_wr_en({ {3{1'b0}}, simf0_wr_en}),
  .port4_wr_mask(simf0_wr_mask),
  .port4_wr_addr(simf0_dest_addr),
  .port4_wr_data(simf0_dest_data),
  .port5_wr_en({ {3{1'b0}}, simf1_wr_en}),
  .port5_wr_mask(simf1_wr_mask),
  .port5_wr_addr(simf1_dest_addr),
  .port5_wr_data(simf1_dest_data),
  .port6_wr_en({ {3{1'b0}}, simf2_wr_en}),
  .port6_wr_mask(simf2_wr_mask),
  .port6_wr_addr(simf2_dest_addr),
  .port6_wr_data(simf2_dest_data),
  .port7_wr_en({ {3{1'b0}}, simf3_wr_en}),
  .port7_wr_mask(simf3_wr_mask),
  .port7_wr_addr(simf3_dest_addr),
  .port7_wr_data(simf3_dest_data),
  .port8_wr_en(lsu_dest_wr_en),
  .port8_wr_mask(lsu_dest_wr_mask),
  .port8_wr_addr(lsu_dest_addr),
  .port8_wr_data(lsu_dest_data),
  .muxed_port_wr_en(muxed_simx_dest_wr_en),
  .muxed_port_wr_mask(muxed_simx_dest_wr_mask),
  .muxed_port_wr_addr(muxed_simx_dest_addr),
  .muxed_port_wr_data(muxed_simx_dest_data)
);

assign issue_alu_dest_reg_addr = muxed_simx_dest_addr;
assign issue_alu_dest_reg_valid = (|muxed_simx_dest_wr_en) & (~|lsu_dest_wr_en);

`ifdef FPGA
reg_64page_1024x32b_3r_1w_fpga reg_file (
  .clk_double(clk_double),
`else
reg_64page_1024x32b_3r_1w reg_file (
`endif
  .rd0_addr(final_source1_addr),
  .rd0_data(final_source1_data),
  .rd1_addr(final_source2_addr),
  .rd1_data(final_source2_data),
  .rd2_addr(muxed_simx_source3_rd_addr),
  .rd2_data(muxed_simx_source3_rd_data),
  .wr0_en(muxed_simx_dest_wr_mask),
  .wr0_en_xoutof4(muxed_simx_dest_wr_en),
  .wr0_addr(muxed_simx_dest_addr),
  .wr0_data(muxed_simx_dest_data),
  .clk(clk)
);

// wfid_mux was hacked to output valid data in case
// rfa selects lsu.
wfid_mux_8to1 wfid_mux (
  .wr_port_select(rfa_select_fu),
  .wfid_done_0(simd0_instr_done),
  .wfid_0(simd0_instr_done_wfid),
  .wfid_done_1(simd1_instr_done),
  .wfid_1(simd1_instr_done_wfid),
  .wfid_done_2(simd2_instr_done),
  .wfid_2(simd2_instr_done_wfid),
  .wfid_done_3(simd3_instr_done),
  .wfid_3(simd3_instr_done_wfid),
  .wfid_done_4(simf0_instr_done),
  .wfid_4(simf0_instr_done_wfid),
  .wfid_done_5(simf1_instr_done),
  .wfid_5(simf1_instr_done_wfid),
  .wfid_done_6(simf2_instr_done),
  .wfid_6(simf2_instr_done_wfid),
  .wfid_done_7(simf3_instr_done),
  .wfid_7(simf3_instr_done_wfid),
  .muxed_wfid(issue_alu_wr_done_wfid),
  .muxed_wfid_done(issue_alu_wr_done)
);

assign issue_lsu_wr_done_wfid = lsu_instr_done_wfid;
assign issue_lsu_wr_done = lsu_instr_done;
assign issue_lsu_dest_reg_addr = lsu_dest_addr;
assign issue_lsu_dest_reg_valid = lsu_dest_wr_en;

///////////////////////////////
//Your code goes here - beware: script does not recognize changes
// into files. It ovewrites everithing without mercy. Save your work before running the script
///////////////////////////////
endmodule
