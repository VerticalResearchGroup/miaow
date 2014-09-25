module dff_set_en_rst(
   d,
   q,
   en,
   clk,
   set,
   rst );


   output q;
   input d;
   input en;
   input clk;
   input set;
   input rst;

   wire d_int;
   reg state;

   assign d_int = en ? d : state;

   assign q = state;

   always @(posedge clk or posedge rst)
   begin
      if(rst)
      state <= 0;
      else
      state <= set? 1 : d_int;
   end

`ifdef dump_flops
   always @(posedge gpu_tb.rst)
   begin
      if ($test$plusargs("dump_flops"))
      begin
         $display("%m.state");
      end
   end
`endif
endmodule
