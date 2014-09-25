
module instr_info_table
  (/*AUTOARG*/
   // Outputs
   vgpr_alu_rd_data, vgpr_lsu_rd_data, sgpr_alu_rd_data,
   sgpr_lsu_rd_data, issued_rd_data,
   // Inputs
   f_decode_valid, clk, rst, f_decode_wfid, decode_wr_data,
   f_vgpr_alu_wr_done_wfid, f_vgpr_lsu_wr_done_wfid,
   f_sgpr_alu_wr_done_wfid, f_sgpr_lsu_instr_done_wfid, issued_wfid
   );

   input f_decode_valid;
   input clk, rst;
   
   input [`WF_ID_LENGTH-1:0] f_decode_wfid;
   input [`ISSUE_INSTR_INFO_LENGTH-1:0] decode_wr_data;

   input [`WF_ID_LENGTH-1:0] 	       f_vgpr_alu_wr_done_wfid, f_vgpr_lsu_wr_done_wfid, 
				       f_sgpr_alu_wr_done_wfid, f_sgpr_lsu_instr_done_wfid, 
				       issued_wfid;
   output [`ISSUE_INSTR_INFO_LENGTH-1:0] vgpr_alu_rd_data, vgpr_lsu_rd_data, 
					sgpr_alu_rd_data, sgpr_lsu_rd_data, 
					issued_rd_data;

   wire [`ISSUE_INSTR_INFO_LENGTH-1:0] vgpr_alu_rd_data_tbl, vgpr_lsu_rd_data_tbl, 
					 sgpr_alu_rd_data_tbl, sgpr_lsu_rd_data_tbl;

   wire [`WF_PER_CU-1:0] 		reg_wr_en;
   wire [`ISSUE_INSTR_INFO_LENGTH*`WF_PER_CU-1:0] reg_in, reg_out;

   assign vgpr_alu_rd_data = (f_decode_valid && f_decode_wfid == f_vgpr_alu_wr_done_wfid)?
			     decode_wr_data : vgpr_alu_rd_data_tbl;

   assign vgpr_lsu_rd_data = (f_decode_valid && f_decode_wfid == f_vgpr_lsu_wr_done_wfid)?
			     decode_wr_data : vgpr_lsu_rd_data_tbl;

   assign sgpr_alu_rd_data = (f_decode_valid && f_decode_wfid == f_sgpr_alu_wr_done_wfid)?
			     decode_wr_data : sgpr_alu_rd_data_tbl;

   assign sgpr_lsu_rd_data = (f_decode_valid && f_decode_wfid == f_sgpr_lsu_instr_done_wfid)?
			     decode_wr_data : sgpr_lsu_rd_data_tbl;
   
   
   // Decoder for the write port. Does not enable any port if wr_en is 0
   decoder_6b_40b_en wr_port_decoder
     (.out(reg_wr_en), .addr_in(f_decode_wfid), .en(f_decode_valid) );

   // Muxes for the read ports
   mux_40xPARAMb_to_1xPARAMb #(`ISSUE_INSTR_INFO_LENGTH) mux_rd0 
     (.out(vgpr_alu_rd_data_tbl), .in(reg_out), .select(f_vgpr_alu_wr_done_wfid));
   mux_40xPARAMb_to_1xPARAMb #(`ISSUE_INSTR_INFO_LENGTH) mux_rd1 
     (.out(vgpr_lsu_rd_data_tbl), .in(reg_out), .select(f_vgpr_lsu_wr_done_wfid));
   mux_40xPARAMb_to_1xPARAMb #(`ISSUE_INSTR_INFO_LENGTH) mux_rd2 
     (.out(sgpr_alu_rd_data_tbl), .in(reg_out), .select(f_sgpr_alu_wr_done_wfid));
   mux_40xPARAMb_to_1xPARAMb #(`ISSUE_INSTR_INFO_LENGTH) mux_rd3 
     (.out(sgpr_lsu_rd_data_tbl), .in(reg_out), .select(f_sgpr_lsu_instr_done_wfid));
   mux_40xPARAMb_to_1xPARAMb #(`ISSUE_INSTR_INFO_LENGTH) mux_rd5 
     (.out(issued_rd_data), .in(reg_out), .select(issued_wfid));

   // Bank of registerss
   reg_param #(`ISSUE_INSTR_INFO_LENGTH) data_bank[`WF_PER_CU-1:0] 
					  ( .out(reg_out), 
					    .in(reg_in), 
					    .wr_en(reg_wr_en),                               
					    .clk(clk), 
					    .rst(rst) );
   
   assign reg_in = {`WF_PER_CU{decode_wr_data}};

endmodule
