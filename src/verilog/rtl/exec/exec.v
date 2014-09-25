module exec(
      lsu_rd_wfid,
      salu_wr_exec_en,
      salu_wr_vcc_en,
      salu_wr_exec_value,
      salu_wr_vcc_value,
      salu_wr_wfid,
      salu_rd_en,
      salu_rd_wfid,
      salu_wr_m0_en,
      salu_wr_m0_value,
      salu_wr_scc_en,
      salu_wr_scc_value,
      simd0_rd_wfid,
      simd1_rd_wfid,
      simd2_rd_wfid,
      simd3_rd_wfid,
      simd0_rd_en,
      simd1_rd_en,
      simd2_rd_en,
      simd3_rd_en,
      simd0_vcc_wr_wfid,
      simd1_vcc_wr_wfid,
      simd2_vcc_wr_wfid,
      simd3_vcc_wr_wfid,
      simd0_vcc_wr_en,
      simd1_vcc_wr_en,
      simd2_vcc_wr_en,
      simd3_vcc_wr_en,
      simd0_vcc_value,
      simd1_vcc_value,
      simd2_vcc_value,
      simd3_vcc_value,
      simf0_rd_wfid,
      simf1_rd_wfid,
      simf2_rd_wfid,
      simf3_rd_wfid,
      simf0_rd_en,
      simf1_rd_en,
      simf2_rd_en,
      simf3_rd_en,
      simf0_vcc_wr_wfid,
      simf1_vcc_wr_wfid,
      simf2_vcc_wr_wfid,
      simf3_vcc_wr_wfid,
      simf0_vcc_wr_en,
      simf1_vcc_wr_en,
      simf2_vcc_wr_en,
      simf3_vcc_wr_en,
      simf0_vcc_value,
      simf1_vcc_value,
      simf2_vcc_value,
      simf3_vcc_value,
      fetch_init_wf_en,
      fetch_init_wf_id,
      fetch_init_value,
      rfa_select_fu,
      lsu_exec_value,
      lsu_rd_m0_value,
      simd_rd_exec_value,
      simd_rd_vcc_value,
      simd_rd_m0_value,
      simd_rd_scc_value,
      simf_rd_exec_value,
      simf_rd_vcc_value,
      simf_rd_m0_value,
      simf_rd_scc_value,
      salu_rd_exec_value,
      salu_rd_vcc_value,
      salu_rd_m0_value,
      salu_rd_scc_value,
      issue_salu_wr_vcc_wfid,
      issue_salu_wr_vcc_en,
      issue_salu_wr_exec_en,
      issue_salu_wr_m0_en,
      issue_salu_wr_scc_en,
      issue_valu_wr_vcc_wfid,
      issue_valu_wr_vcc_en,
      clk,
      rst
 );

input clk;

input rst;

input salu_wr_exec_en, salu_wr_vcc_en, salu_rd_en, salu_wr_m0_en, salu_wr_scc_en,
         salu_wr_scc_value, simd0_rd_en, simd1_rd_en, simd2_rd_en, simd3_rd_en,
         simd0_vcc_wr_en, simd1_vcc_wr_en, simd2_vcc_wr_en, simd3_vcc_wr_en,
         simf0_rd_en, simf1_rd_en, simf2_rd_en, simf3_rd_en, simf0_vcc_wr_en,
         simf1_vcc_wr_en, simf2_vcc_wr_en, simf3_vcc_wr_en, fetch_init_wf_en;
input[5:0] lsu_rd_wfid, salu_wr_wfid, salu_rd_wfid, simd0_rd_wfid, simd1_rd_wfid,
         simd2_rd_wfid, simd3_rd_wfid, simd0_vcc_wr_wfid, simd1_vcc_wr_wfid,
         simd2_vcc_wr_wfid, simd3_vcc_wr_wfid, simf0_rd_wfid, simf1_rd_wfid,
         simf2_rd_wfid, simf3_rd_wfid, simf0_vcc_wr_wfid, simf1_vcc_wr_wfid,
         simf2_vcc_wr_wfid, simf3_vcc_wr_wfid, fetch_init_wf_id;
input[15:0] rfa_select_fu;
input[31:0] salu_wr_m0_value;
input[63:0] salu_wr_exec_value, salu_wr_vcc_value, simd0_vcc_value,
         simd1_vcc_value, simd2_vcc_value, simd3_vcc_value, simf0_vcc_value,
         simf1_vcc_value, simf2_vcc_value, simf3_vcc_value, fetch_init_value;

output simd_rd_scc_value, simf_rd_scc_value, salu_rd_scc_value, issue_salu_wr_vcc_en,
         issue_salu_wr_exec_en, issue_salu_wr_m0_en, issue_salu_wr_scc_en, issue_valu_wr_vcc_en;
output[5:0] issue_salu_wr_vcc_wfid, issue_valu_wr_vcc_wfid;
output[31:0] lsu_rd_m0_value, simd_rd_m0_value, simf_rd_m0_value, salu_rd_m0_value;
output[63:0] lsu_exec_value, simd_rd_exec_value, simd_rd_vcc_value,
         simf_rd_exec_value, simf_rd_vcc_value, salu_rd_exec_value, salu_rd_vcc_value;

wire[5:0] alu_rd_wfid;

wire vcc_simd_wr_en;
wire[5:0] vcc_simd_wr_addr;
wire[63:0] vcc_simd_wr_data;

wire lsu_rd_scc_value; //if needed in future
wire[63:0] lsu_rd_vcc_value; //if needed in future

assign salu_rd_exec_value = simd_rd_exec_value;
assign salu_rd_vcc_value = simd_rd_vcc_value;
assign salu_rd_m0_value = simd_rd_m0_value;
assign salu_rd_scc_value = simd_rd_scc_value;

assign simf_rd_exec_value = simd_rd_exec_value;
assign simf_rd_vcc_value = simd_rd_vcc_value;
assign simf_rd_m0_value = simd_rd_m0_value;
assign simf_rd_scc_value = simd_rd_scc_value;

rd_port_9_to_1 #(6) alu_rd_port_mux(
  .port0_rd_en(simd0_rd_en),
  .port0_rd_addr(simd0_rd_wfid),
  .port1_rd_en(simd1_rd_en),
  .port1_rd_addr(simd1_rd_wfid),
  .port2_rd_en(simd2_rd_en),
  .port2_rd_addr(simd2_rd_wfid),
  .port3_rd_en(simd3_rd_en),
  .port3_rd_addr(simd3_rd_wfid),
  .port4_rd_en(simf0_rd_en),
  .port4_rd_addr(simf0_rd_wfid),
  .port5_rd_en(simf1_rd_en),
  .port5_rd_addr(simf1_rd_wfid),
  .port6_rd_en(simf2_rd_en),
  .port6_rd_addr(simf2_rd_wfid),
  .port7_rd_en(simf3_rd_en),
  .port7_rd_addr(simf3_rd_wfid),
  .port8_rd_en(salu_rd_en),
  .port8_rd_addr(salu_rd_wfid),
  .rd_addr(alu_rd_wfid)
);

wr_port_40x64b_8_to_1 vcc_wr_port_mux(
  .select(rfa_select_fu[7:0]),
  .port0_wr_en(simd0_vcc_wr_en),
  .port0_wr_addr(simd0_vcc_wr_wfid),
  .port0_wr_data(simd0_vcc_value),
  .port1_wr_en(simd1_vcc_wr_en),
  .port1_wr_addr(simd1_vcc_wr_wfid),
  .port1_wr_data(simd1_vcc_value),
  .port2_wr_en(simd2_vcc_wr_en),
  .port2_wr_addr(simd2_vcc_wr_wfid),
  .port2_wr_data(simd2_vcc_value),
  .port3_wr_en(simd3_vcc_wr_en),
  .port3_wr_addr(simd3_vcc_wr_wfid),
  .port3_wr_data(simd3_vcc_value),
  .port4_wr_en(simf0_vcc_wr_en),
  .port4_wr_addr(simf0_vcc_wr_wfid),
  .port4_wr_data(simf0_vcc_value),
  .port5_wr_en(simf1_vcc_wr_en),
  .port5_wr_addr(simf1_vcc_wr_wfid),
  .port5_wr_data(simf1_vcc_value),
  .port6_wr_en(simf2_vcc_wr_en),
  .port6_wr_addr(simf2_vcc_wr_wfid),
  .port6_wr_data(simf2_vcc_value),
  .port7_wr_en(simf3_vcc_wr_en),
  .port7_wr_addr(simf3_vcc_wr_wfid),
  .port7_wr_data(simf3_vcc_value),
  .muxed_port_wr_en(vcc_simd_wr_en),
  .muxed_port_wr_addr(vcc_simd_wr_addr),
  .muxed_port_wr_data(vcc_simd_wr_data)
);

// m0
reg_40xX_2r_2w #(32) m0_file(
  .rd0_addr(alu_rd_wfid),
  .rd0_data(simd_rd_m0_value),
  .rd1_addr(lsu_rd_wfid),
  .rd1_data(lsu_rd_m0_value),
  .wr0_en(fetch_init_wf_en),
  .wr0_addr(fetch_init_wf_id),
  .wr0_data(32'd0),
  .wr1_en(salu_wr_m0_en),
  .wr1_addr(salu_wr_wfid),
  .wr1_data(salu_wr_m0_value),
  .clk(clk),
  .rst(rst)
);

// scc
reg_40xX_2r_2w #(1) scc_file(
  .rd0_addr(alu_rd_wfid),
  .rd0_data(simd_rd_scc_value),
  .rd1_addr(lsu_rd_wfid),
  .rd1_data(lsu_rd_scc_value),
  .wr0_en(fetch_init_wf_en),
  .wr0_addr(fetch_init_wf_id),
  .wr0_data(1'b0),
  .wr1_en(salu_wr_scc_en),
  .wr1_addr(salu_wr_wfid),
  .wr1_data(salu_wr_scc_value),
  .clk(clk),
  .rst(rst)
);

// vcc
reg_40xX_2r_3w #(64) vcc_file(
  .rd0_addr(alu_rd_wfid),
  .rd0_data(simd_rd_vcc_value),
  .rd1_addr(lsu_rd_wfid),
  .rd1_data(lsu_rd_vcc_value),
  .wr0_en(fetch_init_wf_en),
  .wr0_addr(fetch_init_wf_id),
  .wr0_data(64'd0),
  .wr1_en(vcc_simd_wr_en),
  .wr1_addr(vcc_simd_wr_addr),
  .wr1_data(vcc_simd_wr_data),
  .wr2_en(salu_wr_vcc_en),
  .wr2_addr(salu_wr_wfid),
  .wr2_data(salu_wr_vcc_value),
  .clk(clk),
  .rst(rst)
);

// exec
reg_40xX_2r_2w #(64) exec_file(
  .rd0_addr(alu_rd_wfid),
  .rd0_data(simd_rd_exec_value),
  .rd1_addr(lsu_rd_wfid),
  .rd1_data(lsu_exec_value),
  .wr0_en(fetch_init_wf_en),
  .wr0_addr(fetch_init_wf_id),
  .wr0_data(fetch_init_value),
  .wr1_en(salu_wr_exec_en),
  .wr1_addr(salu_wr_wfid),
  .wr1_data(salu_wr_exec_value),
  .clk(clk),
  .rst(rst)
);

///////////////////////////////

assign issue_salu_wr_vcc_wfid = salu_wr_wfid;
assign issue_salu_wr_vcc_en = salu_wr_vcc_en;
assign issue_valu_wr_vcc_wfid = vcc_simd_wr_addr;
assign issue_valu_wr_vcc_en = vcc_simd_wr_en;
assign issue_salu_wr_exec_en = salu_wr_exec_en;
assign issue_salu_wr_m0_en = salu_wr_m0_en;
assign issue_salu_wr_scc_en = salu_wr_scc_en;
///////////////////////////////

endmodule
