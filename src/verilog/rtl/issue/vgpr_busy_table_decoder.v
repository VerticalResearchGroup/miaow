module vgpr_busy_table_decoder
  (
   vgpr_addr,
   vgpr_valid,
   
   output_decoded
   );
   parameter MAX_NUMBER_WORDS = 4;
   
   input[`VGPR_ADDR_LENGTH-1:0] vgpr_addr;
   input [MAX_NUMBER_WORDS-1:0] vgpr_valid;

   output [`NUMBER_VGPR-1:0] 	output_decoded;
   wire [`NUMBER_VGPR+4-1:0] 	output_decoded_2;
   
   assign output_decoded_2 = (|vgpr_valid) ? vgpr_valid << vgpr_addr : 1028'd0;
   assign output_decoded = output_decoded_2[`NUMBER_VGPR-1:0] | { {(`NUMBER_VGPR-4){1'b0}},output_decoded_2[`NUMBER_VGPR+4-1:`NUMBER_VGPR]};
endmodule
