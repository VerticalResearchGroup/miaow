module functional_unit_reg_bank
  (/*AUTOARG*/
   // Outputs
   fu_simd, fu_salu, fu_lsu, fu_simf,
   // Inputs
   clk, rst, f_decode_valid, f_decode_fu, f_decode_wfid
   );

   input clk,rst;
   input f_decode_valid;
   input [1:0] f_decode_fu;
   input [`WF_ID_LENGTH-1:0] f_decode_wfid;

   output [`WF_PER_CU-1:0]   fu_simd,fu_salu,fu_lsu,fu_simf;

   wire [`WF_PER_CU-1:0]     decoded_init_wr_en;
   wire [`WF_PER_CU*2-1:0]   fu_regs_in;

   decoder_6b_40b_en decoder_6b_40b_en
     (
      .addr_in(f_decode_wfid),
      .out(decoded_init_wr_en),
      .en(f_decode_valid)
      );


   functional_unit_reg functional_unit_regs[`WF_PER_CU-1:0]
     (
      .wr_fu_en(decoded_init_wr_en),
      .wr_fu_value(fu_regs_in),
      .rd_fu_simd(fu_simd),
      .rd_fu_simf(fu_simf),
      .rd_fu_salu(fu_salu),
      .rd_fu_lsu(fu_lsu),
      .clk(clk),
      .rst(rst)
      );

   assign fu_regs_in = {40{f_decode_fu}};

endmodule
