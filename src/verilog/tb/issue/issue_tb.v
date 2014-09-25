module issue_tb();
   parameter MAX_INFLIGHT_TB = 8;
   parameter STORED_INSTR_INFO_LENGTH = (1 + 6 + 1 + 9 + 1 + 10 + 1 + 6  + 1 + 9 + 1 + 10);
   
   wire		clk, rst;			
   
   reg		decode_barrier;		
   reg		decode_branch;		
   reg [13:0] 	decode_dest_reg1;	
   reg [12:0] 	decode_dest_reg2;	
   reg		decode_exec_rd;		
   reg		decode_exec_wr;		
   reg [1:0] 	decode_fu;		
   reg [15:0] 	decode_imm_value0;	
   reg [31:0] 	decode_imm_value1;	
   reg [31:0] 	decode_instr_pc;	
   reg		decode_m0_rd;		
   reg		decode_m0_wr;		
   reg [31:0] 	decode_opcode;		
   reg		decode_scc_rd;		
   reg		decode_scc_wr;		
   reg [13:0] 	decode_source_reg1;	
   reg [12:0] 	decode_source_reg2;	
   reg [12:0] 	decode_source_reg3;	
   reg [13:0] 	decode_source_reg4;	
   reg		decode_valid;		
   reg		decode_vcc_rd;		
   reg		decode_vcc_wr;		
   reg		decode_wf_halt;		
   reg [5:0] 	decode_wfid;		
   reg		exec_salu_wr_exec_en;	
   reg		exec_salu_wr_m0_en;	
   reg		exec_salu_wr_scc_en;	
   reg		exec_salu_wr_vcc_en;	 
   reg [5:0] 	exec_salu_wr_wfid;	
   reg		exec_valu_wr_vcc_en;	
   reg [5:0] 	exec_valu_wr_vcc_wfid;	
   reg [3:0] 	fetch_wg_wf_count;	
   reg [5:0] 	fetch_wg_wgid;		
   reg		lsu_ready;		
   reg		salu_alu_ready;		
   reg		salu_branch_en;		
   reg		salu_branch_taken;	
   reg [5:0] 	salu_branch_wfid;	
   reg [8:0] 	sgpr_alu_dest_reg_addr;	
   reg [1:0] 	sgpr_alu_dest_reg_valid;
   reg		sgpr_alu_wr_done;	
   reg [5:0] 	sgpr_alu_wr_done_wfid;	
   reg [8:0] 	sgpr_lsu_dest_reg_addr;	
   reg [3:0] 	sgpr_lsu_dest_reg_valid;
   reg		sgpr_lsu_instr_done;	
   reg [5:0] 	sgpr_lsu_instr_done_wfid;
   reg		simd0_alu_ready;	
   reg		simd1_alu_ready;	
   reg		simd2_alu_ready;	
   reg		simd3_alu_ready;	
   reg		simf0_alu_ready;	
   reg		simf1_alu_ready;	
   reg		simf2_alu_ready;	
   reg		simf3_alu_ready;	
   reg [9:0] 	vgpr_alu_dest_reg_addr;	
   reg		vgpr_alu_dest_reg_valid;
   reg		vgpr_alu_wr_done;	
   reg [5:0] 	vgpr_alu_wr_done_wfid;	
   reg [9:0] 	vgpr_lsu_dest_reg_addr;	
   reg [3:0] 	vgpr_lsu_dest_reg_valid;
   reg		vgpr_lsu_wr_done;	
   reg [5:0] 	vgpr_lsu_wr_done_wfid;	

   /**
    * Patterns:
    * retire every instruction after 6 cycles
    * simulate fu utilization
    * 
    **/
   /*AUTOINPUT*/

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [11:0] 	alu_dest_reg1;		// From issue of issue.v
   wire [11:0] 	alu_dest_reg2;		// From issue of issue.v
   wire [15:0] 	alu_imm_value0;		// From issue of issue.v
   wire [31:0] 	alu_imm_value1;		// From issue of issue.v
   wire [31:0] 	alu_instr_pc;		// From issue of issue.v
   wire [31:0] 	alu_opcode;		// From issue of issue.v
   wire [11:0] 	alu_source_reg1;	// From issue of issue.v
   wire [11:0] 	alu_source_reg2;	// From issue of issue.v
   wire [11:0] 	alu_source_reg3;	// From issue of issue.v
   wire [5:0] 	alu_wfid;		// From issue of issue.v
   wire [5:0] 	fetch_wg_wfid;		// From issue of issue.v
   wire 	fetchwave_wf_done_en;	// From issue of issue.v
   wire [5:0] 	fetchwave_wf_done_wf_id;// From issue of issue.v
   wire [11:0] 	lsu_dest_reg;		// From issue of issue.v
   wire [15:0] 	lsu_imm_value0;		// From issue of issue.v
   wire [31:0] 	lsu_imm_value1;		// From issue of issue.v
   wire [31:0] 	lsu_instr_pc;		// From issue of issue.v
   wire 	lsu_lsu_select;		// From issue of issue.v
   wire [11:0] 	lsu_mem_sgpr;		// From issue of issue.v
   wire [31:0] 	lsu_opcode;		// From issue of issue.v
   wire [11:0] 	lsu_source_reg1;	// From issue of issue.v
   wire [11:0] 	lsu_source_reg2;	// From issue of issue.v
   wire [11:0] 	lsu_source_reg3;	// From issue of issue.v
   wire [5:0] 	lsu_wfid;		// From issue of issue.v
   wire 	salu_alu_select;	// From issue of issue.v
   wire 	simd0_alu_select;	// From issue of issue.v
   wire 	simd1_alu_select;	// From issue of issue.v
   wire 	simd2_alu_select;	// From issue of issue.v
   wire 	simd3_alu_select;	// From issue of issue.v
   wire 	simf0_alu_select;	// From issue of issue.v
   wire 	simf1_alu_select;	// From issue of issue.v
   wire 	simf2_alu_select;	// From issue of issue.v
   wire 	simf3_alu_select;	// From issue of issue.v
   wire 	tracemon_barrier_retire_en;// From issue of issue.v
   wire [5:0] 	tracemon_barrier_retire_wfid;// From issue of issue.v
   wire [39:0] 	wave_valid_entries;	// From issue of issue.v
   // End of automatics

   // Module that controls tests
   tester tester
     (
      .clk(clk),
      .rst(rst)
      );

   // Issue instantiation
   issue issue
     (/*AUTOINST*/
      // Outputs
      .salu_alu_select			(salu_alu_select),
      .simd0_alu_select			(simd0_alu_select),
      .simd1_alu_select			(simd1_alu_select),
      .simd2_alu_select			(simd2_alu_select),
      .simd3_alu_select			(simd3_alu_select),
      .simf0_alu_select			(simf0_alu_select),
      .simf1_alu_select			(simf1_alu_select),
      .simf2_alu_select			(simf2_alu_select),
      .simf3_alu_select			(simf3_alu_select),
      .lsu_lsu_select			(lsu_lsu_select),
      .fetchwave_wf_done_en		(fetchwave_wf_done_en),
      .tracemon_barrier_retire_en	(tracemon_barrier_retire_en),
      .lsu_wfid				(lsu_wfid[5:0]),
      .alu_wfid				(alu_wfid[5:0]),
      .fetchwave_wf_done_wf_id		(fetchwave_wf_done_wf_id[5:0]),
      .fetch_wg_wfid			(fetch_wg_wfid[5:0]),
      .tracemon_barrier_retire_wfid	(tracemon_barrier_retire_wfid[5:0]),
      .lsu_source_reg1			(lsu_source_reg1[11:0]),
      .lsu_source_reg2			(lsu_source_reg2[11:0]),
      .lsu_source_reg3			(lsu_source_reg3[11:0]),
      .lsu_dest_reg			(lsu_dest_reg[11:0]),
      .lsu_mem_sgpr			(lsu_mem_sgpr[11:0]),
      .alu_source_reg1			(alu_source_reg1[11:0]),
      .alu_source_reg2			(alu_source_reg2[11:0]),
      .alu_source_reg3			(alu_source_reg3[11:0]),
      .alu_dest_reg1			(alu_dest_reg1[11:0]),
      .alu_dest_reg2			(alu_dest_reg2[11:0]),
      .lsu_imm_value0			(lsu_imm_value0[15:0]),
      .alu_imm_value0			(alu_imm_value0[15:0]),
      .lsu_imm_value1			(lsu_imm_value1[31:0]),
      .lsu_opcode			(lsu_opcode[31:0]),
      .alu_imm_value1			(alu_imm_value1[31:0]),
      .alu_opcode			(alu_opcode[31:0]),
      .alu_instr_pc			(alu_instr_pc[31:0]),
      .lsu_instr_pc			(lsu_instr_pc[31:0]),
      .wave_valid_entries		(wave_valid_entries[39:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .decode_branch			(decode_branch),
      .decode_barrier			(decode_barrier),
      .decode_vcc_wr			(decode_vcc_wr),
      .decode_vcc_rd			(decode_vcc_rd),
      .decode_scc_wr			(decode_scc_wr),
      .decode_scc_rd			(decode_scc_rd),
      .decode_exec_rd			(decode_exec_rd),
      .decode_exec_wr			(decode_exec_wr),
      .decode_m0_rd			(decode_m0_rd),
      .decode_m0_wr			(decode_m0_wr),
      .decode_wf_halt			(decode_wf_halt),
      .decode_valid			(decode_valid),
      .vgpr_alu_wr_done			(vgpr_alu_wr_done),
      .vgpr_alu_dest_reg_valid		(vgpr_alu_dest_reg_valid),
      .vgpr_lsu_wr_done			(vgpr_lsu_wr_done),
      .sgpr_alu_wr_done			(sgpr_alu_wr_done),
      .sgpr_lsu_instr_done		(sgpr_lsu_instr_done),
      .simd0_alu_ready			(simd0_alu_ready),
      .simd1_alu_ready			(simd1_alu_ready),
      .simd2_alu_ready			(simd2_alu_ready),
      .simd3_alu_ready			(simd3_alu_ready),
      .simf0_alu_ready			(simf0_alu_ready),
      .simf1_alu_ready			(simf1_alu_ready),
      .simf2_alu_ready			(simf2_alu_ready),
      .simf3_alu_ready			(simf3_alu_ready),
      .salu_alu_ready			(salu_alu_ready),
      .lsu_ready			(lsu_ready),
      .exec_salu_wr_vcc_en		(exec_salu_wr_vcc_en),
      .exec_salu_wr_exec_en		(exec_salu_wr_exec_en),
      .exec_salu_wr_scc_en		(exec_salu_wr_scc_en),
      .exec_salu_wr_m0_en		(exec_salu_wr_m0_en),
      .exec_valu_wr_vcc_en		(exec_valu_wr_vcc_en),
      .salu_branch_en			(salu_branch_en),
      .salu_branch_taken		(salu_branch_taken),
      .decode_fu			(decode_fu[1:0]),
      .sgpr_alu_dest_reg_valid		(sgpr_alu_dest_reg_valid[1:0]),
      .vgpr_lsu_dest_reg_valid		(vgpr_lsu_dest_reg_valid[3:0]),
      .sgpr_lsu_dest_reg_valid		(sgpr_lsu_dest_reg_valid[3:0]),
      .fetch_wg_wf_count		(fetch_wg_wf_count[3:0]),
      .decode_wfid			(decode_wfid[5:0]),
      .vgpr_alu_wr_done_wfid		(vgpr_alu_wr_done_wfid[5:0]),
      .vgpr_lsu_wr_done_wfid		(vgpr_lsu_wr_done_wfid[5:0]),
      .sgpr_alu_wr_done_wfid		(sgpr_alu_wr_done_wfid[5:0]),
      .sgpr_lsu_instr_done_wfid		(sgpr_lsu_instr_done_wfid[5:0]),
      .exec_salu_wr_wfid		(exec_salu_wr_wfid[5:0]),
      .exec_valu_wr_vcc_wfid		(exec_valu_wr_vcc_wfid[5:0]),
      .fetch_wg_wgid			(fetch_wg_wgid[5:0]),
      .salu_branch_wfid			(salu_branch_wfid[5:0]),
      .sgpr_alu_dest_reg_addr		(sgpr_alu_dest_reg_addr[8:0]),
      .sgpr_lsu_dest_reg_addr		(sgpr_lsu_dest_reg_addr[8:0]),
      .vgpr_alu_dest_reg_addr		(vgpr_alu_dest_reg_addr[9:0]),
      .vgpr_lsu_dest_reg_addr		(vgpr_lsu_dest_reg_addr[9:0]),
      .decode_source_reg2		(decode_source_reg2[12:0]),
      .decode_source_reg3		(decode_source_reg3[12:0]),
      .decode_dest_reg2			(decode_dest_reg2[12:0]),
      .decode_source_reg1		(decode_source_reg1[13:0]),
      .decode_source_reg4		(decode_source_reg4[13:0]),
      .decode_dest_reg1			(decode_dest_reg1[13:0]),
      .decode_imm_value0		(decode_imm_value0[15:0]),
      .decode_instr_pc			(decode_instr_pc[31:0]),
      .decode_opcode			(decode_opcode[31:0]),
      .decode_imm_value1		(decode_imm_value1[31:0]));

   //waveforms
   initial begin
      if ($test$plusargs("dump_waveforms")) begin
	 $vcdpluson(0,issue_tb);
	 //$vcdpluson(<level>,scope,<signal>);
	 //Lots of options for dumping waves
	 //(both system calls and run time arguments)
	 // http://read.pudn.com/downloads97/sourcecode/others/399556/vcs_0123.pdf
      end
   end

   initial begin
      decode_barrier = 0;	   
      decode_branch = 0;		
      decode_dest_reg1 = 0;	
      decode_dest_reg2 = 0;	
      decode_exec_rd = 0;		
      decode_exec_wr = 0;		
      decode_fu = 0;		
      decode_imm_value0 = 0;	
      decode_imm_value1 = 0;	
      decode_instr_pc = 0;	
      decode_m0_rd = 0;		
      decode_m0_wr = 0;		
      decode_opcode = 0;		
      decode_scc_rd = 0;		
      decode_scc_wr = 0;		
      decode_source_reg1 = 0;	
      decode_source_reg2 = 0;	
      decode_source_reg3 = 0;	
      decode_source_reg4 = 0;	
      decode_valid = 0;		
      decode_vcc_rd = 0;		
      decode_vcc_wr = 0;		
      decode_wf_halt = 0;		
      decode_wfid = 0;		
      exec_salu_wr_exec_en = 0;	
      exec_salu_wr_m0_en = 0;	
      exec_salu_wr_scc_en = 0;	
      exec_salu_wr_vcc_en = 0;	 
      exec_salu_wr_wfid = 0;	
      exec_valu_wr_vcc_en = 0;	
      exec_valu_wr_vcc_wfid = 0;	
      fetch_wg_wf_count = 4'h3;	
      fetch_wg_wgid = 0;		
      lsu_ready = 1;		
      salu_alu_ready = 1;		
      salu_branch_en = 0;		
      salu_branch_taken = 0;	
      salu_branch_wfid = 0;	
      sgpr_alu_dest_reg_addr = 0;	
      sgpr_alu_dest_reg_valid = 0;
      sgpr_alu_wr_done = 0;	
      sgpr_alu_wr_done_wfid = 0;	
      sgpr_lsu_dest_reg_addr = 0;	
      sgpr_lsu_dest_reg_valid = 0;
      sgpr_lsu_instr_done = 0;	
      sgpr_lsu_instr_done_wfid = 0;
      simd0_alu_ready = 1;	
      simd1_alu_ready = 1;	
      simd2_alu_ready = 1;	
      simd3_alu_ready = 1;	
      simf0_alu_ready = 1;	
      simf1_alu_ready = 1;	
      simf2_alu_ready = 1;	
      simf3_alu_ready = 1;	
      vgpr_alu_dest_reg_addr = 0;	
      vgpr_alu_dest_reg_valid = 0;
      vgpr_alu_wr_done = 0;	
      vgpr_alu_wr_done_wfid = 0;	
      vgpr_lsu_dest_reg_addr = 0;	
      vgpr_lsu_dest_reg_valid = 0;
      vgpr_lsu_wr_done = 0;
      vgpr_lsu_wr_done_wfid = 0;
      
   end // initial begin

   int end_of_simulation;
   
   /////////////////////////////////////////////////////////////////////////////////////////////// 
   // Read decoded instructions from file
   /////////////////////////////////////////////////////////////////////////////////////////////// 
   /**
    * Format of input:
    * valid:%h fu:%b wfid:%d op:%h pc:%h dest1:%h dest2:%h src1:%h src2:%h src3:%h src4:%h imm0:%h imm1:%h branch:%b barrier:%b halt:%b
    */
   initial begin
      int input_file, r, eof;
      end_of_simulation = 0;
      input_file = $fopen("input.trace", "r");
      tester.reset_module();
      
      while(eof == 0) begin
	 @(negedge clk);
	 // Read data from file and input it into issue stage
	 r = $fscanf(input_file, 
		     "valid:%h fu:%b wfid:%d op:%h pc:%h dest1:%h dest2:%h src1:%h src2:%h src3:%h src4:%h imm0:%h imm1:%h branch:%b barrier:%b halt:%b\n", 
		     decode_valid, decode_fu, decode_wfid, decode_opcode, decode_instr_pc, decode_dest_reg1, decode_dest_reg2,
		     decode_source_reg1, decode_source_reg2, decode_source_reg3, decode_source_reg4,
		     decode_imm_value0, decode_imm_value1, 
		     decode_branch, decode_barrier, decode_wf_halt);
	 $display("inputs read: %d",r);
	 
	 // Check for end of file
	 eof = $feof(input_file);
      end

      // Finished input file, wait last instruction to retire and end simulation
      repeat (MAX_INFLIGHT_TB + 2) @(negedge clk);
      $fclose(input_file);
      
      end_of_simulation = 1;
      #(10);
      
      $finish;
      
   end
   
   /////////////////////////////////////////////////////////////////////////////////////////////// 
   // Write issued instructions to file
   /////////////////////////////////////////////////////////////////////////////////////////////// 
   /**
    * Format of output
    * lsu valid:%b wfid:%h pc:%h op:%h dest:%h src1:%h src2:%h src3:%h src4:%h imm0:%h imm1:%h
    * alu valid:%b wfid:%h pc:%h op:%h dest1:%h dest2:%h src1:%h src2:%h src3:%h imm0:%h imm1:%h
    * finished_wf valid:%b wfid:%h
    * retired_barrier valid:%b wfid:%h
    **/
   initial begin
      int output_file, r;
      reg alu_valid;
      
      output_file = $fopen("output.trace", "w");
      @( negedge rst);
      while(!end_of_simulation) begin
	 
	 @( negedge clk);
	 alu_valid = salu_alu_select |
		     simd0_alu_select | simd1_alu_select |
		     simd2_alu_select | simd3_alu_select |
		     simf0_alu_select | simf1_alu_select |
		     simf2_alu_select | simf3_alu_select;
	 
	 $fwrite(output_file,
		  "lsu valid:%b wfid:%h pc:%h op:%h dest:%h src1:%h src2:%h src3:%h src4:%h imm0:%h imm1:%h\n",
		  lsu_lsu_select, lsu_wfid, lsu_instr_pc, lsu_opcode, lsu_dest_reg, 
		  lsu_source_reg1, lsu_source_reg2, lsu_source_reg3, lsu_mem_sgpr,
		  lsu_imm_value0, lsu_imm_value1);
	 $fwrite(output_file,
		  "alu valid:%b wfid:%h pc:%h op:%h dest1:%h dest2:%h src1:%h src2:%h src3:%h imm0:%h imm1:%h\n",
		  alu_valid, alu_wfid, alu_instr_pc, alu_opcode, alu_dest_reg1, alu_dest_reg2, 
		  alu_source_reg1, alu_source_reg2, alu_source_reg3,
		  alu_imm_value0, alu_imm_value1);
	 $fwrite(output_file,
		  "finished_wf valid:%b wfid:%h\n",
		  fetchwave_wf_done_en, fetchwave_wf_done_wf_id);
	 $fwrite(output_file,
		  "retired_barrier valid:%b wfid:%h\n\n",
		  tracemon_barrier_retire_en, tracemon_barrier_retire_wfid);
      end
      
      if(end_of_simulation)
	$fclose(output_file);
      
   end
   /////////////////////////////////////////////////////////////////////////////////////////////// 
   // Simulate fu utililization using a fifo
   /////////////////////////////////////////////////////////////////////////////////////////////// 

   
   reg[STORED_INSTR_INFO_LENGTH-1:0] inflight_fifo[MAX_INFLIGHT_TB-1:0];
   integer 			     fifo_pointer;
   reg 				     lsu_vgpr_valid, lsu_sgpr_valid, alu_vgpr_valid, alu_sgpr_valid;
   reg 				     lsu_instr_valid, alu_instr_valid;
   reg [8:0] 			     alu_sgpr_addr;

   initial begin
      int i;
      
      fifo_pointer = 0;
      for(i=0; i<MAX_INFLIGHT_TB; i = i+1)
	inflight_fifo[i] = {STORED_INSTR_INFO_LENGTH{1'b0}};

      @( negedge rst);

      // Infinite loop that retires everything
      forever  begin
	 @ (negedge clk);
	 
	 // Push: dest1 dest2 alu, dest1 lsu
	 lsu_instr_valid = 0;
	 lsu_vgpr_valid = 0;
	 
	 lsu_sgpr_valid = 0;

	 alu_instr_valid = 0;
	 alu_vgpr_valid = 0;
	 alu_sgpr_valid = 0;

	 alu_sgpr_addr = 0;
	 
	 // Put the issued values in the fifo
	 if( lsu_lsu_select ) begin
	    lsu_instr_valid = 1;
	    lsu_sgpr_valid = ( lsu_dest_reg[11:9] == 3'b111 )? 1'b1 : 1'b0;
	    lsu_vgpr_valid = ( lsu_dest_reg[11:10] == 2'b10 )? 1'b1 : 1'b0;
	 end
	 
	 if( salu_alu_select |
	     simd0_alu_select | simd1_alu_select |
	     simd2_alu_select | simd3_alu_select |
	     simf0_alu_select | simf1_alu_select |
	     simf2_alu_select | simf3_alu_select ) begin
	    alu_instr_valid = 1;
	    if( alu_dest_reg1[11:10] == 2'b10 ) begin
	       alu_vgpr_valid = 1;
	       if( alu_dest_reg2[11:9] == 3'b111 ) begin
		  alu_sgpr_valid = 1;
		  alu_sgpr_addr = alu_dest_reg2[8:0];
	       end
	    end
	    else if(alu_dest_reg1[11:9] == 3'b111 ) begin
	       alu_sgpr_valid = 1;
	       alu_sgpr_addr = alu_dest_reg1[8:0];
	    end
	 end // if ( salu_alu_select |...

	 inflight_fifo[fifo_pointer]
	   = {lsu_instr_valid,lsu_wfid,lsu_sgpr_valid,lsu_dest_reg[8:0],lsu_vgpr_valid,lsu_dest_reg[9:0],
	      alu_instr_valid,alu_wfid,alu_sgpr_valid,alu_sgpr_addr,alu_vgpr_valid,alu_dest_reg1[9:0]};

	 fifo_pointer = (fifo_pointer + 1) % (MAX_INFLIGHT_TB);

	 // Remove the values from the fifo and retire them:
	 // TODO: For now all fu remain available all the time
	 // When both write, signal only vgpr, when neither retire, signal vgpr, if only one
	 // retire, signal that one.
	 vgpr_lsu_wr_done = inflight_fifo[fifo_pointer][38] | (inflight_fifo[fifo_pointer][55] & ~inflight_fifo[fifo_pointer][48]);
	 sgpr_lsu_instr_done = inflight_fifo[fifo_pointer][48] | (inflight_fifo[fifo_pointer][55] & ~inflight_fifo[fifo_pointer][38]);
	

	 sgpr_lsu_instr_done_wfid = inflight_fifo[fifo_pointer][54:49];
	 vgpr_lsu_wr_done_wfid = inflight_fifo[fifo_pointer][54:49];

	 sgpr_lsu_dest_reg_valid = inflight_fifo[fifo_pointer][48];
	 sgpr_lsu_dest_reg_addr = inflight_fifo[fifo_pointer][47:39];	
	 vgpr_lsu_dest_reg_valid = inflight_fifo[fifo_pointer][38];
	 vgpr_lsu_dest_reg_addr = inflight_fifo[fifo_pointer][37:28];	
	 
	 vgpr_alu_wr_done = inflight_fifo[fifo_pointer][10] | (inflight_fifo[fifo_pointer][27] & ~inflight_fifo[fifo_pointer][20]);	
	 sgpr_alu_wr_done = inflight_fifo[fifo_pointer][20] | (inflight_fifo[fifo_pointer][27] & ~inflight_fifo[fifo_pointer][10]);
	 

	 vgpr_alu_wr_done_wfid = inflight_fifo[fifo_pointer][26:21];	
	 sgpr_alu_wr_done_wfid = inflight_fifo[fifo_pointer][26:21];	

	 sgpr_alu_dest_reg_valid = inflight_fifo[fifo_pointer][20];
	 sgpr_alu_dest_reg_addr = inflight_fifo[fifo_pointer][19:11];	
	 vgpr_alu_dest_reg_valid = inflight_fifo[fifo_pointer][10];
	 vgpr_alu_dest_reg_addr = inflight_fifo[fifo_pointer][9:0];	
	 
      end
   end
endmodule

