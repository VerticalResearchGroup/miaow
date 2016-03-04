module dff (q, d, clk, rst);

   output         q;
   input          d;
   input          clk;
   input          rst;

   reg            state;

   assign q = state;

   always @(posedge clk)
   begin
      if (rst)
         state <= 1'b0;
      else
         state <= d;
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
