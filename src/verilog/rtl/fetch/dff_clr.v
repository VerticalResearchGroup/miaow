module dff_clr (q, d, clk, rst);

   output         q;
   input          d;
   input          clk;
   input          rst;

   reg            state;

   assign q = state;

   always @(posedge clk or posedge rst)
   begin
      state <= rst? 1 : d;
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

