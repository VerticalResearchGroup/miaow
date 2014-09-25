module functional_unit_reg
  (/*AUTOARG*/
   // Outputs
   rd_fu_simd, rd_fu_salu, rd_fu_lsu, rd_fu_simf,
   // Inputs
   clk, rst, wr_fu_en, wr_fu_value
   );

   input clk,rst;

   input wr_fu_en;
   input [1:0] wr_fu_value;

   output      rd_fu_simd, rd_fu_salu, rd_fu_lsu, rd_fu_simf;

   reg [3:0]   decoded_wr_fu_value;

   // Decoder for fu value
   always @(wr_fu_value) begin
      decoded_wr_fu_value = 4'b0;

      case(wr_fu_value)
	`ISSUE_FU_SIMD_ENCODING : decoded_wr_fu_value = 4'b0001;
	`ISSUE_FU_SALU_ENCODING : decoded_wr_fu_value = 4'b0010;
	`ISSUE_FU_LSU_ENCODING  : decoded_wr_fu_value = 4'b0100;
	`ISSUE_FU_SIMF_ENCODING : decoded_wr_fu_value = 4'b1000;
	default: decoded_wr_fu_value = 4'b0;
      endcase
   end

   dff_en reg_ff[3:0](.q({rd_fu_simf,rd_fu_lsu,rd_fu_salu,rd_fu_simd}), 
		      .d(decoded_wr_fu_value), .en(wr_fu_en), .clk(clk), .rst(rst) );

endmodule
