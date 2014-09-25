module rfa_tb;

reg clk;

reg rst;

reg simd0_queue_entry_valid, simd1_queue_entry_valid, simd2_queue_entry_valid,
         simd3_queue_entry_valid, simf0_queue_entry_valid, simf1_queue_entry_valid,
         simf2_queue_entry_valid, simf3_queue_entry_valid;

wire simd0_queue_entry_serviced, simd1_queue_entry_serviced, simd2_queue_entry_serviced,
         simd3_queue_entry_serviced, simf0_queue_entry_serviced, simf1_queue_entry_serviced,
         simf2_queue_entry_serviced, simf3_queue_entry_serviced;
wire[15:0] execvgprsgpr_select_fu;

rfa rfa(
      .simd0_queue_entry_valid(simd0_queue_entry_valid),
      .simd1_queue_entry_valid(simd1_queue_entry_valid),
      .simd2_queue_entry_valid(simd2_queue_entry_valid),
      .simd3_queue_entry_valid(simd3_queue_entry_valid),
      .simf0_queue_entry_valid(simf0_queue_entry_valid),
      .simf1_queue_entry_valid(simf1_queue_entry_valid),
      .simf2_queue_entry_valid(simf2_queue_entry_valid),
      .simf3_queue_entry_valid(simf3_queue_entry_valid),
      .simd0_queue_entry_serviced(simd0_queue_entry_serviced),
      .simd1_queue_entry_serviced(simd1_queue_entry_serviced),
      .simd2_queue_entry_serviced(simd2_queue_entry_serviced),
      .simd3_queue_entry_serviced(simd3_queue_entry_serviced),
      .simf0_queue_entry_serviced(simf0_queue_entry_serviced),
      .simf1_queue_entry_serviced(simf1_queue_entry_serviced),
      .simf2_queue_entry_serviced(simf2_queue_entry_serviced),
      .simf3_queue_entry_serviced(simf3_queue_entry_serviced),
      .execvgprsgpr_select_fu(execvgprsgpr_select_fu),
      .clk(clk),
      .rst(rst)
 );

  //stimulii
   initial begin
      forever #5 clk = ~clk;
   end

   initial begin
      #3 clk = 1'b0;
      #16 rst = 1'b1;

      simd0_queue_entry_valid = 1'b0;
      simd1_queue_entry_valid = 1'b0;
      simd2_queue_entry_valid = 1'b0;
      simd3_queue_entry_valid = 1'b0;
      simf0_queue_entry_valid = 1'b0;
      simf1_queue_entry_valid = 1'b0;
      simf2_queue_entry_valid = 1'b0;
      simf3_queue_entry_valid = 1'b0;

      #10 rst = 1'b0;
      #300;
    $finish;
  end

   initial begin
      #31;

      $display("SETTING ALL VALIDS TO 1\n");
      simd0_queue_entry_valid = 1'b1;
      simd1_queue_entry_valid = 1'b1;
      simd2_queue_entry_valid = 1'b1;
      simd3_queue_entry_valid = 1'b1;
      simf0_queue_entry_valid = 1'b1;
      simf1_queue_entry_valid = 1'b1;
      simf2_queue_entry_valid = 1'b1;
      simf3_queue_entry_valid = 1'b1;

      #80;
      $display("RESETTING SOME VALIDS TO 0\n");
      simd0_queue_entry_valid = 1'b0;
      simd2_queue_entry_valid = 1'b0;
      simf0_queue_entry_valid = 1'b0;
      simf2_queue_entry_valid = 1'b0;

      #50;
      $display("RESETTING ALL VALIDS TO 0\n");
      simd0_queue_entry_valid = 1'b0;
      simd1_queue_entry_valid = 1'b0;
      simd2_queue_entry_valid = 1'b0;
      simd3_queue_entry_valid = 1'b0;
      simf0_queue_entry_valid = 1'b0;
      simf1_queue_entry_valid = 1'b0;
      simf2_queue_entry_valid = 1'b0;
      simf3_queue_entry_valid = 1'b0;

      #20;
      $display("SETTING ALL VALIDS TO 1\n");
      simd0_queue_entry_valid = 1'b1;
      simd1_queue_entry_valid = 1'b1;
      simd2_queue_entry_valid = 1'b1;
      simd3_queue_entry_valid = 1'b1;
      simf0_queue_entry_valid = 1'b1;
      simf1_queue_entry_valid = 1'b1;
      simf2_queue_entry_valid = 1'b1;
      simf3_queue_entry_valid = 1'b1;

      #20;
      $display("RESETTING ALL VALIDS TO 0\n");
      simd0_queue_entry_valid = 1'b0;
      simd1_queue_entry_valid = 1'b0;
      simd2_queue_entry_valid = 1'b0;
      simd3_queue_entry_valid = 1'b0;
      simf0_queue_entry_valid = 1'b0;
      simf1_queue_entry_valid = 1'b0;
      simf2_queue_entry_valid = 1'b0;
      simf3_queue_entry_valid = 1'b0;

   end

  //monitors
  initial begin
    if ($test$plusargs("print_outputs")) begin
      $monitor($time, " \n \
         simd0_queue_entry_valid = %b, simd0_queue_entry_serviced = %b \n \
         simd1_queue_entry_valid = %b, simd1_queue_entry_serviced = %b \n \
         simd2_queue_entry_valid = %b, simd2_queue_entry_serviced = %b \n \
         simd3_queue_entry_valid = %b, simd3_queue_entry_serviced = %b \n \
         simf0_queue_entry_valid = %b, simf0_queue_entry_serviced = %b \n \
         simf1_queue_entry_valid = %b, simf1_queue_entry_serviced = %b \n \
         simf2_queue_entry_valid = %b, simf2_queue_entry_serviced = %b \n \
         simf3_queue_entry_valid = %b, simf3_queue_entry_serviced = %b \n \
         execvgprsgpr_select_fu = %b \
         ",
         simd0_queue_entry_valid, simd0_queue_entry_serviced,
         simd1_queue_entry_valid, simd1_queue_entry_serviced,
         simd2_queue_entry_valid, simd2_queue_entry_serviced,
         simd3_queue_entry_valid, simd3_queue_entry_serviced,
         simf0_queue_entry_valid, simf0_queue_entry_serviced,
         simf1_queue_entry_valid, simf1_queue_entry_serviced,
         simf2_queue_entry_valid, simf2_queue_entry_serviced,
         simf3_queue_entry_valid, simf3_queue_entry_serviced,
         execvgprsgpr_select_fu
         );
     // $monitor("$time:  vgpr_dest_data = %h", vgpr_dest_data);
      //$monitor("$time: rfa_queue_entry_serviced = %b", rfa_queue_entry_serviced);
    end
  end

  //waveforms
  initial begin
    if ($test$plusargs("dump_waveforms")) begin
      $vcdpluson(0,rfa_tb);
      //$vcdpluson(<level>,scope,<signal>);
      //Lots of options for dumping waves
      //(both system calls and run time arguments)
      // http://read.pudn.com/downloads97/sourcecode/others/399556/vcs_0123.pdf
    end
  end

endmodule
