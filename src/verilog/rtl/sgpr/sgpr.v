module sgpr( 
	     lsu_source1_addr,
	     lsu_source2_addr,
	     lsu_dest_addr,
	     lsu_dest_data,
	     lsu_dest_wr_en,
	     lsu_instr_done_wfid,
	     lsu_instr_done,
	     lsu_source1_rd_en,
	     lsu_source2_rd_en,
	     simd0_rd_addr,
	     simd0_rd_en,
	     simd1_rd_addr,
	     simd1_rd_en,
	     simd2_rd_addr,
	     simd2_rd_en,
	     simd3_rd_addr,
	     simd3_rd_en,
	     simd0_wr_addr,
	     simd0_wr_en,
	     simd0_wr_data,
	     simd1_wr_addr,
	     simd1_wr_en,
	     simd1_wr_data,
	     simd2_wr_addr,
	     simd2_wr_en,
	     simd2_wr_data,
	     simd3_wr_addr,
	     simd3_wr_en,
	     simd3_wr_data,
	     simd0_wr_mask,
	     simd1_wr_mask,
	     simd2_wr_mask,
	     simd3_wr_mask,
	     simf0_rd_addr,
	     simf0_rd_en,
	     simf1_rd_addr,
	     simf1_rd_en,
	     simf2_rd_addr,
	     simf2_rd_en,
	     simf3_rd_addr,
	     simf3_rd_en,
	     simf0_wr_addr,
	     simf0_wr_en,
	     simf0_wr_data,
	     simf1_wr_addr,
	     simf1_wr_en,
	     simf1_wr_data,
	     simf2_wr_addr,
	     simf2_wr_en,
	     simf2_wr_data,
	     simf3_wr_addr,
	     simf3_wr_en,
	     simf3_wr_data,
	     simf0_wr_mask,
	     simf1_wr_mask,
	     simf2_wr_mask,
	     simf3_wr_mask,
	     salu_dest_data,
	     salu_dest_addr,
	     salu_dest_wr_en,
	     salu_source2_addr,
	     salu_source1_addr,
	     salu_instr_done_wfid,
	     salu_instr_done,
	     salu_source1_rd_en,
	     salu_source2_rd_en,
	     rfa_select_fu,
	     lsu_source1_data,
	     lsu_source2_data,
	     simd_rd_data,
	     simf_rd_data,
	     salu_source2_data,
	     salu_source1_data,
	     issue_alu_wr_done_wfid,
	     issue_alu_wr_done,
	     issue_alu_dest_reg_addr,
	     issue_alu_dest_reg_valid,
	     issue_lsu_instr_done_wfid,
	     issue_lsu_instr_done,
	     issue_lsu_dest_reg_addr,
	     issue_lsu_dest_reg_valid,
	     issue_valu_dest_reg_valid,
	     issue_valu_dest_addr,
	     clk,
	     rst
	     );

   input clk;

   input rst;
   input salu_source1_rd_en,
	 salu_source2_rd_en,
	 lsu_source1_rd_en,
	 lsu_source2_rd_en;

   input lsu_instr_done, simd0_rd_en, simd1_rd_en, simd2_rd_en,
         simd3_rd_en, simd0_wr_en, simd1_wr_en, simd2_wr_en, simd3_wr_en, simf0_rd_en,
         simf1_rd_en, simf2_rd_en, simf3_rd_en, simf0_wr_en, simf1_wr_en, simf2_wr_en,
         simf3_wr_en, salu_instr_done;
   input [1:0] salu_dest_wr_en;
   input [3:0] lsu_dest_wr_en;
   input [5:0] lsu_instr_done_wfid, salu_instr_done_wfid;
   input [8:0] lsu_source1_addr, lsu_source2_addr, lsu_dest_addr, simd0_rd_addr,
               simd1_rd_addr, simd2_rd_addr, simd3_rd_addr, simd0_wr_addr, simd1_wr_addr,
               simd2_wr_addr, simd3_wr_addr, simf0_rd_addr, simf1_rd_addr, simf2_rd_addr,
               simf3_rd_addr, simf0_wr_addr, simf1_wr_addr, simf2_wr_addr, simf3_wr_addr,
               salu_dest_addr, salu_source2_addr, salu_source1_addr;
   input [15:0] rfa_select_fu;
   input [127:0] lsu_dest_data;
   input [63:0]  simd0_wr_data, simd1_wr_data, simd2_wr_data, simd3_wr_data,
		 simf0_wr_data, simf1_wr_data, simf2_wr_data, simf3_wr_data, 
		 salu_dest_data,
		 simd0_wr_mask, simd1_wr_mask, simd2_wr_mask, simd3_wr_mask,
		 simf0_wr_mask, simf1_wr_mask, simf2_wr_mask, simf3_wr_mask;

   output 	 issue_alu_wr_done, issue_lsu_instr_done, issue_valu_dest_reg_valid;
   output [3:0]  issue_lsu_dest_reg_valid;
   output [1:0]  issue_alu_dest_reg_valid;
   output [5:0]  issue_alu_wr_done_wfid, issue_lsu_instr_done_wfid;
   output [8:0]  issue_alu_dest_reg_addr, issue_lsu_dest_reg_addr, issue_valu_dest_addr;
   output [31:0] lsu_source2_data, simd_rd_data, simf_rd_data;
   output [63:0] salu_source2_data, salu_source1_data;
   output [127:0] lsu_source1_data;

   ///////////////////////////////
   //Your code goes here - beware: script does not recognize changes
   // into files. It ovewrites everithing without mercy. Save your work before running the script
   ///////////////////////////////
   wire 	  dummy;
   assign dummy = rst;

   wire [31:0] 	  simx_rd_data;

   wire [8:0] 	  simx_muxed_rd_addr;
   wire [31:0] 	  simx_muxed_rd_data;
   wire 	  simx_muxed_rd_en;

   wire [3:0] 	  simxlsu_muxed_wr_en;
   wire [8:0] 	  simxlsu_muxed_wr_addr;
   wire [127:0]   simxlsu_muxed_wr_data;
   wire [63:0] 	  simx_rd_old_data;
   wire [127:0]   simxlsu_wr_merged_data;
   wire [127:0] 	  simxlsu_muxed_wr_mask;

   wire [3:0] 	  simxlsu_muxed_wr_en_i;
   wire [8:0] 	  simxlsu_muxed_wr_addr_i;
   wire [127:0]   simxlsu_muxed_wr_data_i;
   wire [127:0] 	  simxlsu_muxed_wr_mask_i;
   
   wire [8:0] 	  final_port0_addr;
   wire [8:0] 	  final_port1_addr;

   wire [127:0]   final_port0_data;
   wire [63:0] 	  final_port1_data;
   wire [127:0]   port0_distribute_data;
   wire [127:0]   port1_distribute_data;

   wire [127:0]   simd0_wr_data_i, simd1_wr_data_i, simd2_wr_data_i, simd3_wr_data_i,
		  simf0_wr_data_i, simf1_wr_data_i, simf2_wr_data_i, simf3_wr_data_i;

   wire [127:0]   simd0_wr_mask_i, simd1_wr_mask_i, simd2_wr_mask_i, simd3_wr_mask_i,
		  simf0_wr_mask_i, simf1_wr_mask_i, simf2_wr_mask_i, simf3_wr_mask_i;
   
   wire [3:0]	  simd0_wr_en_i, simd1_wr_en_i, simd2_wr_en_i, simd3_wr_en_i, 
		  simf0_wr_en_i, simf1_wr_en_i, simf2_wr_en_i, simf3_wr_en_i;

   
   assign simd0_wr_data_i = {simd0_wr_data, simd0_wr_data};
   assign simd1_wr_data_i = {simd1_wr_data, simd1_wr_data};
   assign simd2_wr_data_i = {simd2_wr_data, simd2_wr_data};
   assign simd3_wr_data_i = {simd3_wr_data, simd3_wr_data};

   assign simf0_wr_data_i = {simf0_wr_data, simf0_wr_data};
   assign simf1_wr_data_i = {simf1_wr_data, simf1_wr_data};
   assign simf2_wr_data_i = {simf2_wr_data, simf2_wr_data};
   assign simf3_wr_data_i = {simf3_wr_data, simf3_wr_data};

   assign simd0_wr_mask_i = {simd0_wr_mask, simd0_wr_mask};
   assign simd1_wr_mask_i = {simd1_wr_mask, simd1_wr_mask};
   assign simd2_wr_mask_i = {simd2_wr_mask, simd2_wr_mask};
   assign simd3_wr_mask_i = {simd3_wr_mask, simd3_wr_mask};

   assign simf0_wr_mask_i = {simf0_wr_mask, simf0_wr_mask};
   assign simf1_wr_mask_i = {simf1_wr_mask, simf1_wr_mask};
   assign simf2_wr_mask_i = {simf2_wr_mask, simf2_wr_mask};
   assign simf3_wr_mask_i = {simf3_wr_mask, simf3_wr_mask};
   
   assign simd0_wr_en_i = {4{simd0_wr_en}} & 4'b0011;
   
   assign simd1_wr_en_i = {4{simd1_wr_en}} & 4'b0011;

   assign simd2_wr_en_i = {4{simd2_wr_en}} & 4'b0011;

   assign simd3_wr_en_i = {4{simd3_wr_en}} & 4'b0011;

   assign simf0_wr_en_i = {4{simf0_wr_en}} & 4'b0011;

   assign simf1_wr_en_i = {4{simf1_wr_en}} & 4'b0011;

   assign simf2_wr_en_i = {4{simf2_wr_en}} & 4'b0011;

   assign simf3_wr_en_i = {4{simf3_wr_en}} & 4'b0011;
   
   assign issue_alu_wr_done_wfid = salu_instr_done_wfid;
   assign issue_alu_wr_done = salu_instr_done;
   assign issue_alu_dest_reg_addr = salu_dest_addr;
   assign issue_alu_dest_reg_valid = salu_dest_wr_en;

   assign issue_lsu_instr_done_wfid = lsu_instr_done_wfid;
   assign issue_lsu_instr_done = lsu_instr_done;
   assign issue_lsu_dest_reg_addr = lsu_dest_addr;
   assign issue_lsu_dest_reg_valid = lsu_dest_wr_en;

   //For writes from simx, read the old value using a ead port and modify only
   //the bits specified by the wr mask
   assign simxlsu_wr_merged_data = (simxlsu_muxed_wr_data_i & 
				    simxlsu_muxed_wr_mask_i) | 
				   ({2{simx_rd_old_data}} & 
				    (~simxlsu_muxed_wr_mask_i));

   dff  wr0_delay_flop[4+9+128+128-1:0]
     (.q({simxlsu_muxed_wr_en_i, simxlsu_muxed_wr_addr_i,
	  simxlsu_muxed_wr_data_i,simxlsu_muxed_wr_mask_i}),
      .d({simxlsu_muxed_wr_en, simxlsu_muxed_wr_addr,
	  simxlsu_muxed_wr_data,simxlsu_muxed_wr_mask}),
      .clk(clk),
      .rst(rst));
   
   reg_512x32b_3r_2w sgpr_reg_file
     (
      .rd0_addr(final_port0_addr),
      .rd0_data(final_port0_data),
      .rd1_addr(final_port1_addr),
      .rd1_data(final_port1_data),
      .rd2_addr(simxlsu_muxed_wr_addr),
      .rd2_data(simx_rd_old_data),
      .wr0_en(simxlsu_muxed_wr_en_i),
      .wr0_addr(simxlsu_muxed_wr_addr_i),
      .wr0_data(simxlsu_wr_merged_data),
      //**CHANGE [PSP]
      //**pretend we have one single port only
      //so keep wr1_en low [disable wr1 port write]
      .wr1_en(2'b00),//salu_dest_wr_en),
      .wr1_addr(salu_dest_addr),
      .wr1_data(salu_dest_data),
      //**
      .clk(clk)
      );

   sgpr_simx_rd_port_mux simx_rd_port_mux
     (
      .port0_rd_en(simd0_rd_en),
      .port0_rd_addr(simd0_rd_addr),
      .port1_rd_en(simd1_rd_en),
      .port1_rd_addr(simd1_rd_addr),
      .port2_rd_en(simd2_rd_en),
      .port2_rd_addr(simd2_rd_addr),
      .port3_rd_en(simd3_rd_en),
      .port3_rd_addr(simd3_rd_addr),
      .port4_rd_en(simf0_rd_en),
      .port4_rd_addr(simf0_rd_addr),
      .port5_rd_en(simf1_rd_en),
      .port5_rd_addr(simf1_rd_addr),
      .port6_rd_en(simf2_rd_en),
      .port6_rd_addr(simf2_rd_addr),
      .port7_rd_en(simf3_rd_en),
      .port7_rd_addr(simf3_rd_addr),
      .port_rd_data(simx_rd_data),
      .rd_addr(simx_muxed_rd_addr),
      .rd_data(simx_muxed_rd_data),
      .rd_en(simx_muxed_rd_en)
      );
   assign simd_rd_data = simx_rd_data;
   assign simf_rd_data = simx_rd_data;

   sgpr_3to1_rd_port_mux rd_port0_mux
     (
      .port0_rd_en(lsu_source1_rd_en),
      .port0_rd_addr(lsu_source1_addr),
      .port1_rd_en(1'b0),
      .port1_rd_addr(9'b0),
      .port2_rd_en(salu_source1_rd_en),
      .port2_rd_addr(salu_source1_addr),
      .port_rd_data(port0_distribute_data),
      .rd_addr(final_port0_addr),
      .rd_data(final_port0_data)
      );
   assign lsu_source1_data = port0_distribute_data;
   assign salu_source1_data = port0_distribute_data[63:0];

   sgpr_3to1_rd_port_mux rd_port1_mux
     (
      .port0_rd_en(lsu_source2_rd_en),
      .port0_rd_addr(lsu_source2_addr),
      .port1_rd_en(simx_muxed_rd_en),
      .port1_rd_addr(simx_muxed_rd_addr),
      .port2_rd_en(salu_source2_rd_en),
      .port2_rd_addr(salu_source2_addr),
      .port_rd_data(port1_distribute_data),
      .rd_addr(final_port1_addr),
      .rd_data({64'b0,final_port1_data})
      );
   assign lsu_source2_data = port1_distribute_data[31:0];
   assign simx_muxed_rd_data = port1_distribute_data[31:0];
   assign salu_source2_data = port1_distribute_data[63:0];

   ///////////////////////////////////////////
   //**CHANGE [PSP]**
   //simxlsu will now also take in the salu ports
   sgpr_simxlsu_wr_port_mux simx_wr_port_mux
     (
      .wr_port_select(rfa_select_fu),
      .port0_wr_en(simd0_wr_en_i),
      .port0_wr_addr(simd0_wr_addr),
      .port0_wr_data(simd0_wr_data_i),
      .port0_wr_mask(simd0_wr_mask_i),
      .port1_wr_en(simd1_wr_en_i),
      .port1_wr_addr(simd1_wr_addr),
      .port1_wr_data(simd1_wr_data_i),
      .port1_wr_mask(simd1_wr_mask_i),
      .port2_wr_en(simd2_wr_en_i),
      .port2_wr_addr(simd2_wr_addr),
      .port2_wr_data(simd2_wr_data_i),
      .port2_wr_mask(simd2_wr_mask_i),
      .port3_wr_en(simd3_wr_en_i),
      .port3_wr_addr(simd3_wr_addr),
      .port3_wr_data(simd3_wr_data_i),
      .port3_wr_mask(simd3_wr_mask_i),
      .port4_wr_en(simf0_wr_en_i),
      .port4_wr_addr(simf0_wr_addr),
      .port4_wr_data(simf0_wr_data_i),
      .port4_wr_mask(simf0_wr_mask_i),
      .port5_wr_en(simf1_wr_en_i),
      .port5_wr_addr(simf1_wr_addr),
      .port5_wr_data(simf1_wr_data_i),
      .port5_wr_mask(simf1_wr_mask_i),
      .port6_wr_en(simf2_wr_en_i),
      .port6_wr_addr(simf2_wr_addr),
      .port6_wr_data(simf2_wr_data_i),
      .port6_wr_mask(simf2_wr_mask_i),
      .port7_wr_en(simf3_wr_en_i),
      .port7_wr_addr(simf3_wr_addr),
      .port7_wr_data(simf3_wr_data_i),
      .port7_wr_mask(simf3_wr_mask_i),
      .port8_wr_en(lsu_dest_wr_en),
      .port8_wr_addr(lsu_dest_addr),
      .port8_wr_data(lsu_dest_data),
      .port8_wr_mask({128{1'b1}}),

      //**
      .port9_wr_en(salu_dest_wr_en),
      .port9_wr_addr(salu_dest_addr),
      .port9_wr_data(salu_dest_data),
      .port9_wr_mask({128{1'b1}}),
      //**

      .muxed_port_wr_en(simxlsu_muxed_wr_en),
      .muxed_port_wr_addr(simxlsu_muxed_wr_addr),
      .muxed_port_wr_data(simxlsu_muxed_wr_data),
      .muxed_port_wr_mask(simxlsu_muxed_wr_mask)
      );

   assign issue_valu_dest_reg_valid = (|simxlsu_muxed_wr_en) & (~|lsu_dest_wr_en);
   assign issue_valu_dest_addr = simxlsu_muxed_wr_addr;

endmodule
