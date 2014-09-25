module valu
  (
   alu_source1_data,
   alu_source2_data,
   alu_source3_data,
   alu_source_vcc_value,
   alu_source_exec_value,
   alu_control,
   alu_start,
   alu_vgpr_dest_data,
   alu_sgpr_dest_data,
   alu_dest_vcc_value,
   alu_dest_exec_value,
   valu_done,
   clk,
   rst
   );

   parameter MODULE = `MODULE_SIMD;

   input [511:0]  alu_source1_data;
   input [511:0]  alu_source2_data;
   input [511:0]  alu_source3_data;
   input [15:0]   alu_source_vcc_value;
   input [15:0]   alu_source_exec_value;
   input [31:0] 	alu_control;
   input          alu_start;
   output [511:0] alu_vgpr_dest_data;
   output [15:0]  alu_sgpr_dest_data;
   output [15:0]  alu_dest_vcc_value;
   output [15:0]  alu_dest_exec_value;
   output         valu_done;
   input 	  clk;
   input 	  rst;

   wire [15:0] alu_done;
   assign alu_dest_exec_value = alu_source_exec_value;
   assign valu_done = (&(alu_done | (~alu_source_exec_value))) & (|alu_control);

generate
   if (MODULE == `MODULE_SIMD)
      simd_alu simd_alu[15:0]
        (
         .alu_source1_data(alu_source1_data),
         .alu_source2_data(alu_source2_data),
         .alu_source3_data(alu_source3_data),
         .alu_source_vcc_value(alu_source_vcc_value),
         .alu_source_exec_value(alu_source_exec_value),
         .alu_control(alu_control),
         .alu_start(alu_start),
         .alu_vgpr_dest_data(alu_vgpr_dest_data),
         .alu_sgpr_dest_data(alu_sgpr_dest_data),
         .alu_dest_vcc_value(alu_dest_vcc_value),
         .alu_done(alu_done),
         .clk(clk),
         .rst(rst)
         );
   else if (MODULE == `MODULE_SIMF)
      simf_alu simf_alu[15:0]
        (
         .alu_source1_data(alu_source1_data),
         .alu_source2_data(alu_source2_data),
         .alu_source3_data(alu_source3_data),
         .alu_source_vcc_value(alu_source_vcc_value),
         .alu_source_exec_value(alu_source_exec_value),
         .alu_control(alu_control),
         .alu_start(alu_start),
         .alu_vgpr_dest_data(alu_vgpr_dest_data),
         .alu_sgpr_dest_data(alu_sgpr_dest_data),
         .alu_dest_vcc_value(alu_dest_vcc_value),
         .alu_done(alu_done),
         .clk(clk),
         .rst(rst)
         );
endgenerate

endmodule
