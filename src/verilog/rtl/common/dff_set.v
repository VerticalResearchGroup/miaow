// D-flipflop
// Copied from http://pages.cs.wisc.edu/~karu/courses/cs552/spring2009/handouts/verilog_code/dff.v
module dff_set (q, d, clk, set);

   output         q;
   input          d;
   input          clk;
   input          set;

   reg            state;

   assign q = state;

   always @(posedge clk)
   begin
      state <= set? 1 : d;
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
