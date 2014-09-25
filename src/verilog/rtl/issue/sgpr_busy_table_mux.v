module sgpr_busy_table_mux
  (
   in,
   select,
   out
   );
   parameter MAX_NUMBER_WORDS = 4;
   
   input[`NUMBER_SGPR-1:0] in;
   wire [`NUMBER_SGPR+4-1:0] in_rotated;
   input [`SGPR_ADDR_LENGTH-1:0] select;

   output [MAX_NUMBER_WORDS-1:0] out;

   assign in_rotated = {in[3:0],in};
   assign out = in_rotated >> select;
endmodule
