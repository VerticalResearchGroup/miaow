module fpu_tb ();
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			div_zero_o;		// From DUT of fpu_arith.v
   wire			ine_o;			// From DUT of fpu_arith.v
   wire			inf_o;			// From DUT of fpu_arith.v
   wire [32-1:0]	output_o;		// From DUT of fpu_arith.v
   wire			overflow_o;		// From DUT of fpu_arith.v
   wire			qnan_o;			// From DUT of fpu_arith.v
   wire			ready_o;		// From DUT of fpu_arith.v
   wire			snan_o;			// From DUT of fpu_arith.v
   wire			underflow_o;		// From DUT of fpu_arith.v
   wire			zero_o;			// From DUT of fpu_arith.v
   // End of automatics
   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg			clk;			// To DUT of fpu_arith.v
   reg [2:0]		fpu_op_i;		// To DUT of fpu_arith.v
   reg [32-1:0]	opa_i;			// To DUT of fpu_arith.v
   reg [32-1:0]	opb_i;			// To DUT of fpu_arith.v
   reg [1:0]		rmode_i;		// To DUT of fpu_arith.v
   reg			rst;			// To DUT of fpu_arith.v
   reg			start_i;		// To DUT of fpu_arith.v
   // End of automatics
   reg goahead;

   fpu_arith DUT
	(
	 // Outputs
	 .ready_o			(ready_o),
	 .output_o			(output_o[32-1:0]),
	 .ine_o				(ine_o),
	 .overflow_o			(overflow_o),
	 .underflow_o			(underflow_o),
	 .div_zero_o			(div_zero_o),
	 .inf_o				(inf_o),
	 .zero_o			(zero_o),
	 .qnan_o			(qnan_o),
	 .snan_o			(snan_o),
	 // Inputs
	 .clk				(clk),
	 .rst				(rst),
	 .opa_i				(opa_i[32-1:0]),
	 .opb_i				(opb_i[32-1:0]),
	 .fpu_op_i			(fpu_op_i[2:0]),
	 .rmode_i			(rmode_i[1:0]),
	 .start_i			(start_i));

   // Stimulus


   // clock
   initial begin
      clk = 0;
      while (1) begin
	 #40;
	 clk = ~clk;
      end
   end

   // reset
   initial begin
      rst = 1;
      #200;
      rst = 0;

      #10000;
      $finish;
   end



   always @(posedge clk or posedge rst)
   begin
      if (rst)
      begin
         opa_i <= 'd0;
         opb_i <= 'd0;
         fpu_op_i <= 'd0;
         rmode_i <= 'd0;
         start_i <= 1'b0;
         goahead <= 1'b1;
      end
      else
      begin
         if (goahead)
         begin
            opa_i <= $random;
            opb_i <= $random;
            fpu_op_i <= 3'd2;
            rmode_i <= 2'd0;
            start_i <= 1'b1;
         end
         else
         begin
            start_i <= 1'b0;
         end
         if (goahead)
            goahead <= 1'b0;
         else if (ready_o)
            goahead <= 1'b1;
   end // else: !if(rst)
   end // always @ (posedge clk or posedge rst)

 //waveforms
  initial begin
    if ($test$plusargs("dump_waveforms")) begin
      $vcdpluson(0,fpu_tb);
      //$vcdpluson(<level>,scope,<signal>);
      //Lots of options for dumping waves
      //(both system calls and run time arguments)
      // http://read.pudn.com/downloads97/sourcecode/others/399556/vcs_0123.pdf
    end
  end


endmodule // fpu_tb
