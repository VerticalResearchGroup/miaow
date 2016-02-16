module sgpr_busy_table_decoder
(
 sgpr_addr,
 sgpr_valid,

 output_decoded
);
   parameter MAX_NUMBER_WORDS = 4;
   
   input[`SGPR_ADDR_LENGTH-1:0] sgpr_addr;
   input [MAX_NUMBER_WORDS-1:0] sgpr_valid;

   output [`NUMBER_SGPR-1:0] 	output_decoded;
   wire [`NUMBER_SGPR+4-1:0] 	output_decoded_2;

   assign output_decoded_2 = (|sgpr_valid) ? sgpr_valid << sgpr_addr : 516'd0;
   assign output_decoded = output_decoded_2[`NUMBER_SGPR-1:0] | { {(`NUMBER_SGPR-4){1'b0}},output_decoded_2[`NUMBER_SGPR+4-1:`NUMBER_SGPR]};
endmodule
