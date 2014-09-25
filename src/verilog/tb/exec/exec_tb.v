module exec_tb;

  //wires
reg clk;

reg rst;

reg salu_wr_exec_en, salu_wr_vcc_en, salu_rd_en, salu_wr_m0_en, salu_wr_scc_en,
         salu_wr_scc_value, simd0_rd_en, simd1_rd_en, simd2_rd_en, simd3_rd_en,
         simd0_vcc_wr_en, simd1_vcc_wr_en, simd2_vcc_wr_en, simd3_vcc_wr_en,
         simf0_rd_en, simf1_rd_en, simf2_rd_en, simf3_rd_en, simf0_vcc_wr_en,
         simf1_vcc_wr_en, simf2_vcc_wr_en, simf3_vcc_wr_en, fetch_init_wf_en;
reg [5:0] lsu_rd_wfid, salu_wr_wfid, salu_rd_wfid, simd0_rd_wfid, simd1_rd_wfid,
         simd2_rd_wfid, simd3_rd_wfid, simd0_vcc_wr_wfid, simd1_vcc_wr_wfid,
         simd2_vcc_wr_wfid, simd3_vcc_wr_wfid, simf0_rd_wfid, simf1_rd_wfid,
         simf2_rd_wfid, simf3_rd_wfid, simf0_vcc_wr_wfid, simf1_vcc_wr_wfid,
         simf2_vcc_wr_wfid, simf3_vcc_wr_wfid, fetch_init_wf_id;
reg [15:0] rfa_select_fu;
reg [31:0] salu_wr_m0_value;
reg [63:0] salu_wr_exec_value, salu_wr_vcc_value, simd0_vcc_value,
         simd1_vcc_value, simd2_vcc_value, simd3_vcc_value, simf0_vcc_value,
         simf1_vcc_value, simf2_vcc_value, simf3_vcc_value, fetch_init_value;

wire simd_rd_scc_value, simf_rd_scc_value, salu_rd_scc_value, issue_salu_wr_vcc_en,
         issue_salu_wr_exec_en, issue_salu_wr_m0_en, issue_salu_wr_scc_en, issue_valu_wr_vcc_en;
wire [5:0] issue_salu_wr_vcc_wfid, issue_valu_wr_vcc_wfid;
wire [31:0] lsu_rd_m0_value, simd_rd_m0_value, simf_rd_m0_value, salu_rd_m0_value;
wire [63:0] lsu_exec_value, simd_rd_exec_value, simd_rd_vcc_value,
         simf_rd_exec_value, simf_rd_vcc_value, salu_rd_exec_value, salu_rd_vcc_value;

  //instantiation of dut
exec exec0(
      .lsu_rd_wfid(lsu_rd_wfid),
      .salu_wr_exec_en(salu_wr_exec_en),
      .salu_wr_vcc_en(salu_wr_vcc_en),
      .salu_wr_exec_value(salu_wr_exec_value),
      .salu_wr_vcc_value(salu_wr_vcc_value),
      .salu_wr_wfid(salu_wr_wfid),
      .salu_rd_en(salu_rd_en),
      .salu_rd_wfid(salu_rd_wfid),
      .salu_wr_m0_en(salu_wr_m0_en),
      .salu_wr_m0_value(salu_wr_m0_value),
      .salu_wr_scc_en(salu_wr_scc_en),
      .salu_wr_scc_value(salu_wr_scc_value),
      .simd0_rd_wfid(simd0_rd_wfid),
      .simd1_rd_wfid(simd1_rd_wfid),
      .simd2_rd_wfid(simd2_rd_wfid),
      .simd3_rd_wfid(simd3_rd_wfid),
      .simd0_rd_en(simd0_rd_en),
      .simd1_rd_en(simd1_rd_en),
      .simd2_rd_en(simd2_rd_en),
      .simd3_rd_en(simd3_rd_en),
      .simd0_vcc_wr_wfid(simd0_vcc_wr_wfid),
      .simd1_vcc_wr_wfid(simd1_vcc_wr_wfid),
      .simd2_vcc_wr_wfid(simd2_vcc_wr_wfid),
      .simd3_vcc_wr_wfid(simd3_vcc_wr_wfid),
      .simd0_vcc_wr_en(simd0_vcc_wr_en),
      .simd1_vcc_wr_en(simd1_vcc_wr_en),
      .simd2_vcc_wr_en(simd2_vcc_wr_en),
      .simd3_vcc_wr_en(simd3_vcc_wr_en),
      .simd0_vcc_value(simd0_vcc_value),
      .simd1_vcc_value(simd1_vcc_value),
      .simd2_vcc_value(simd2_vcc_value),
      .simd3_vcc_value(simd3_vcc_value),
      .simf0_rd_wfid(simf0_rd_wfid),
      .simf1_rd_wfid(simf1_rd_wfid),
      .simf2_rd_wfid(simf2_rd_wfid),
      .simf3_rd_wfid(simf3_rd_wfid),
      .simf0_rd_en(simf0_rd_en),
      .simf1_rd_en(simf1_rd_en),
      .simf2_rd_en(simf2_rd_en),
      .simf3_rd_en(simf3_rd_en),
      .simf0_vcc_wr_wfid(simf0_vcc_wr_wfid),
      .simf1_vcc_wr_wfid(simf1_vcc_wr_wfid),
      .simf2_vcc_wr_wfid(simf2_vcc_wr_wfid),
      .simf3_vcc_wr_wfid(simf3_vcc_wr_wfid),
      .simf0_vcc_wr_en(simf0_vcc_wr_en),
      .simf1_vcc_wr_en(simf1_vcc_wr_en),
      .simf2_vcc_wr_en(simf2_vcc_wr_en),
      .simf3_vcc_wr_en(simf3_vcc_wr_en),
      .simf0_vcc_value(simf0_vcc_value),
      .simf1_vcc_value(simf1_vcc_value),
      .simf2_vcc_value(simf2_vcc_value),
      .simf3_vcc_value(simf3_vcc_value),
      .fetch_init_wf_en(fetch_init_wf_en),
      .fetch_init_wf_id(fetch_init_wf_id),
      .fetch_init_value(fetch_init_value),
      .rfa_select_fu(rfa_select_fu),
      .lsu_exec_value(lsu_exec_value),
      .lsu_rd_m0_value(lsu_rd_m0_value),
      .simd_rd_exec_value(simd_rd_exec_value),
      .simd_rd_vcc_value(simd_rd_vcc_value),
      .simd_rd_m0_value(simd_rd_m0_value),
      .simd_rd_scc_value(simd_rd_scc_value),
      .simf_rd_exec_value(simf_rd_exec_value),
      .simf_rd_vcc_value(simf_rd_vcc_value),
      .simf_rd_m0_value(simf_rd_m0_value),
      .simf_rd_scc_value(simf_rd_scc_value),
      .salu_rd_exec_value(salu_rd_exec_value),
      .salu_rd_vcc_value(salu_rd_vcc_value),
      .salu_rd_m0_value(salu_rd_m0_value),
      .salu_rd_scc_value(salu_rd_scc_value),
      .issue_salu_wr_vcc_wfid(issue_salu_wr_vcc_wfid),
      .issue_salu_wr_vcc_en(issue_salu_wr_vcc_en),
      .issue_salu_wr_exec_en(issue_salu_wr_exec_en),
      .issue_salu_wr_m0_en(issue_salu_wr_m0_en),
      .issue_salu_wr_scc_en(issue_salu_wr_scc_en),
      .issue_valu_wr_vcc_wfid(issue_valu_wr_vcc_wfid),
      .issue_valu_wr_vcc_en(issue_valu_wr_vcc_en),
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

    fetch_init_wf_en = 1'b0;
    fetch_init_wf_id = 6'b000000;
    fetch_init_value = {64{1'b0}};

    rfa_select_fu = 16'b0;

    lsu_rd_wfid = 6'b000000;

    salu_rd_en = 1'b0;
    salu_rd_wfid = 6'b000000;


    salu_wr_exec_en = 1'b0;
    salu_wr_vcc_en = 1'b0;
    salu_wr_scc_en = 1'b0;
    salu_wr_m0_en = 1'b0;
    salu_wr_wfid = 6'b000000;
    salu_wr_exec_value = {64{1'b0}};
    salu_wr_vcc_value = {64{1'b0}};
    salu_wr_scc_value = 1'b0;
    salu_wr_m0_value = {32{1'b0}};

    simd0_rd_en = 1'b0;
    simd1_rd_en = 1'b0;
    simd2_rd_en = 1'b0;
    simd3_rd_en = 1'b0;
    simd0_rd_wfid = 6'b000000;
    simd1_rd_wfid = 6'b000000;
    simd2_rd_wfid = 6'b000000;
    simd3_rd_wfid = 6'b000000;

    simf0_rd_en = 1'b0;
    simf1_rd_en = 1'b0;
    simf2_rd_en = 1'b0;
    simf3_rd_en = 1'b0;
    simf0_rd_wfid = 6'b000000;
    simf1_rd_wfid = 6'b000000;
    simf2_rd_wfid = 6'b000000;
    simf3_rd_wfid = 6'b000000;

    simd0_vcc_wr_en = 1'b0;
    simd1_vcc_wr_en = 1'b0;
    simd2_vcc_wr_en = 1'b0;
    simd3_vcc_wr_en = 1'b0;
    simd0_vcc_wr_wfid = 6'b000000;
    simd1_vcc_wr_wfid = 6'b000000;
    simd2_vcc_wr_wfid = 6'b000000;
    simd3_vcc_wr_wfid = 6'b000000;
    simd0_vcc_value = {64{1'b0}};
    simd1_vcc_value = {64{1'b0}};
    simd2_vcc_value = {64{1'b0}};
    simd3_vcc_value = {64{1'b0}};

    simf0_vcc_wr_en = 1'b0;
    simf1_vcc_wr_en = 1'b0;
    simf2_vcc_wr_en = 1'b0;
    simf3_vcc_wr_en = 1'b0;
    simf0_vcc_wr_wfid = 6'b000000;
    simf1_vcc_wr_wfid = 6'b000000;
    simf2_vcc_wr_wfid = 6'b000000;
    simf3_vcc_wr_wfid = 6'b000000;
    simf0_vcc_value = {64{1'b0}};
    simf1_vcc_value = {64{1'b0}};
    simf2_vcc_value = {64{1'b0}};
    simf3_vcc_value = {64{1'b0}};

    #10 rst = 1'b0;
    #2000;
    $finish;
  end

  initial begin
    #31;

    #10
    $display("Initializing exec value \n");
    fetch_init_wf_en = 1'b1;
    fetch_init_wf_id = 6'b000010;
    fetch_init_value = {{58{1'b0}},6'b101101};

    #10
    fetch_init_wf_en = 1'b0;

    #10
    $display("Read from SIMD0 and LSU \n");
    simd0_rd_en = 1'b1;
    simd0_rd_wfid = 6'b000010;

    lsu_rd_wfid = 6'b000010;

    #10
    $display("Read from SIMF2 and LSU \n");
    simd0_rd_en = 1'b0;
    simf2_rd_en = 1'b1;
    simf2_rd_wfid = 6'b000010;

    #10
    $display("Write exec = 0..1001, vcc = 0..11011, scc = 1, m0 = 0..1101 from SALU \n");
    salu_wr_exec_en = 1'b1;
    salu_wr_vcc_en = 1'b1;
    salu_wr_scc_en = 1'b1;
    salu_wr_m0_en = 1'b1;
    salu_wr_wfid = 6'b000010;
    salu_wr_exec_value = {{58{1'b0}}, 6'b001001};
    salu_wr_vcc_value = {{58{1'b0}}, 6'b011011};
    salu_wr_scc_value = 1'b1;
    salu_wr_m0_value = {{24{1'b0}}, 6'b001101};

    #10
    salu_wr_vcc_en = 1'b0;
    salu_wr_exec_en = 1'b0;
    salu_wr_scc_en = 1'b0;
    salu_wr_m0_en = 1'b0;

    $display("Write vcc = 0...0101 from SIMD1 \n");
    rfa_select_fu = 16'd2;
    simd1_vcc_wr_en = 1'b1;
    simd1_vcc_wr_wfid = 6'b000010;
    simd1_vcc_value = {{58{1'b0}}, 6'b000101};

    #10
    simd1_vcc_wr_en = 1'b0;

    $display("Read from SALU \n");
    simf2_rd_en = 1'b0;
    salu_rd_en = 1'b1;
    salu_rd_wfid = 6'b000010;


  end
  //monitors
  initial begin
    if ($test$plusargs("print_outputs")) begin
      $monitor($time, "\n \
                issue_salu_wr_exec_en = %b \n \
                issue_salu_wr_m0_en = %b \n \
                issue_salu_wr_scc_en = %b \n \
                issue_salu_wr_vcc_en = %b \n \
                issue_salu_wr_vcc_wfid = %b \n \
                issue_valu_wr_vcc_en = %b \n \
                issue_valu_wr_vcc_wfid = %b \n \n\
                lsu_exec_value = %b \n \
                lsu_rd_m0_value = %b \n \n\
                salu_rd_exec_value = %b \n \
                salu_rd_m0_value = %b \n \
                salu_rd_scc_value = %b \n \
                salu_rd_vcc_value = %b \n \n \
                simd_rd_exec_value = %b \n \
                simd_rd_m0_value = %b \n \
                simd_rd_scc_value = %b \n \
                simd_rd_vcc_value = %b \n \
                simf_rd_exec_value = %b \n \
                simf_rd_m0_value = %b \n \
                simf_rd_scc_value = %b \n \
                simf_rd_vcc_value = %b \n \
                ",
                issue_salu_wr_exec_en,
                issue_salu_wr_m0_en,
                issue_salu_wr_scc_en,
                issue_salu_wr_vcc_en,
                issue_salu_wr_vcc_wfid,
                issue_valu_wr_vcc_en,
                issue_valu_wr_vcc_wfid,
                lsu_exec_value,
                lsu_rd_m0_value,
                salu_rd_exec_value,
                salu_rd_m0_value,
                salu_rd_scc_value,
                salu_rd_vcc_value,
                simd_rd_exec_value,
                simd_rd_m0_value,
                simd_rd_scc_value,
                simd_rd_vcc_value,
                simf_rd_exec_value,
                simf_rd_m0_value,
                simf_rd_scc_value,
                simf_rd_vcc_value,
                );
    end
  end

  //waveforms
  initial begin
    if ($test$plusargs("dump_waveforms")) begin
      $vcdpluson(0,exec_tb);
      //$vcdpluson(<level>,scope,<signal>);
      //Lots of options for dumping waves
      //(both system calls and run time arguments)
      // http://read.pudn.com/downloads97/sourcecode/others/399556/vcs_0123.pdf
    end
  end

endmodule
