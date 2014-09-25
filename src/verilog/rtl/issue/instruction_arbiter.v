module instruction_arbiter
  (/*AUTOARG*/
   // Outputs
   simd0_alu_select, simd1_alu_select, simd2_alu_select,
   simd3_alu_select, simf0_alu_select, simf1_alu_select,
   simf2_alu_select, simf3_alu_select, lsu_lsu_select,
   salu_alu_select, lsu_wfid, alu_wfid, issued_wfid, alu_valid,
   lsu_valid, issued_valid,
   // Inputs
   clk, rst, salu_ready_to_issue, simd_ready_to_issue,
   simf_ready_to_issue, lsu_ready_to_issue, simd0_alu_ready,
   simd1_alu_ready, simd2_alu_ready, simd3_alu_ready, simf0_alu_ready,
   simf1_alu_ready, simf2_alu_ready, simf3_alu_ready, salu_alu_ready,
   lsu_ready
   );
   input clk, rst;
   
   input [`WF_PER_CU-1:0] salu_ready_to_issue, simd_ready_to_issue,
			  simf_ready_to_issue, lsu_ready_to_issue;
   input 		  simd0_alu_ready, simd1_alu_ready, 
			  simd2_alu_ready, simd3_alu_ready, 
			  simf0_alu_ready, simf1_alu_ready, 
			  simf2_alu_ready, simf3_alu_ready, 
			  salu_alu_ready, lsu_ready;
   
   output 		  simd0_alu_select, simd1_alu_select, 
			  simd2_alu_select, simd3_alu_select, 
			  simf0_alu_select, simf1_alu_select, 
			  simf2_alu_select, simf3_alu_select, 
			  lsu_lsu_select, salu_alu_select;
   output [`WF_ID_LENGTH-1:0] lsu_wfid, alu_wfid, issued_wfid;
   output 		      alu_valid, lsu_valid, issued_valid;

   wire [`WF_PER_CU-1:0]      c_issued_arry, issued_arry, inegible_wf_arry;
   
   wire [`WF_PER_CU-1:0]      f_salu_ready_to_issue, f_simd_ready_to_issue,
			      f_simf_ready_to_issue, f_lsu_ready_to_issue;
   
   wire 		      f_simd0_alu_ready, f_simd1_alu_ready, 
			      f_simd2_alu_ready, f_simd3_alu_ready, 
			      f_simf0_alu_ready, f_simf1_alu_ready, 
			      f_simf2_alu_ready, f_simf3_alu_ready, 
			      f_salu_alu_ready, f_lsu_ready;

   wire 		      c_simd0_alu_select, c_simd1_alu_select, 
			      c_simd2_alu_select, c_simd3_alu_select, 
			      c_simf0_alu_select, c_simf1_alu_select, 
			      c_simf2_alu_select, c_simf3_alu_select, 
			      c_lsu_lsu_select, c_salu_alu_select;
   wire 		      c_issued_valid;


   wire [`WF_ID_LENGTH-1:0]   c_issued_wfid;   

   decoder_6b_40b_en c_issued_decoder
     (.addr_in(c_issued_wfid),
      .en(c_issued_valid),
      .out(c_issued_arry)
      );

   decoder_6b_40b_en issued_decoder
     (.addr_in(issued_wfid),
      .en(issued_valid),
      .out(issued_arry)
      );

   // Hack: make sure the wf that are being chosen right now and the one
   // that was chosen last cycle are not issued.
   assign inegible_wf_arry = c_issued_arry | issued_arry;
   
   
   dff input_flops[(40*4 + 10)-1:0]
     (.d({salu_ready_to_issue & ~inegible_wf_arry, simd_ready_to_issue & ~inegible_wf_arry,
	  simf_ready_to_issue & ~inegible_wf_arry, lsu_ready_to_issue & ~inegible_wf_arry,
	  simd0_alu_ready & ~simd0_alu_select & ~c_simd0_alu_select, 
	  simd1_alu_ready & ~simd1_alu_select & ~c_simd1_alu_select , 
	  simd2_alu_ready & ~simd2_alu_select & ~c_simd2_alu_select, 
	  simd3_alu_ready & ~simd3_alu_select & ~c_simd3_alu_select, 
	  simf0_alu_ready & ~simf0_alu_select & ~c_simf0_alu_select, 
	  simf1_alu_ready & ~simf1_alu_select & ~c_simf1_alu_select, 
	  simf2_alu_ready & ~simf2_alu_select & ~c_simf2_alu_select, 
	  simf3_alu_ready & ~simf3_alu_select & ~c_simf3_alu_select, 
	  salu_alu_ready & ~salu_alu_select & ~c_salu_alu_select, 
	  lsu_ready & ~lsu_lsu_select & ~c_lsu_lsu_select}),
      .q({f_salu_ready_to_issue, f_simd_ready_to_issue,
	  f_simf_ready_to_issue, f_lsu_ready_to_issue,
	  f_simd0_alu_ready, f_simd1_alu_ready, 
	  f_simd2_alu_ready, f_simd3_alu_ready, 
	  f_simf0_alu_ready, f_simf1_alu_ready, 
	  f_simf2_alu_ready, f_simf3_alu_ready, 
	  f_salu_alu_ready, f_lsu_ready}),
      .clk(clk),
      .rst(rst));

   dff output_flops[(6*1 + 11)-1:0]
     (.d({c_simd0_alu_select, c_simd1_alu_select, 
	  c_simd2_alu_select, c_simd3_alu_select, 
	  c_simf0_alu_select, c_simf1_alu_select, 
	  c_simf2_alu_select, c_simf3_alu_select, 
	  c_lsu_lsu_select, c_salu_alu_select,
	  c_issued_wfid,
	  c_issued_valid}),
      .q({simd0_alu_select, simd1_alu_select, 
	  simd2_alu_select, simd3_alu_select, 
	  simf0_alu_select, simf1_alu_select, 
	  simf2_alu_select, simf3_alu_select, 
	  lsu_lsu_select, salu_alu_select,
	  issued_wfid,
	  issued_valid}),
      .clk(clk),
      .rst(rst));

   wire 		      lsu_wf_valid, salu_wf_valid, simd_wf_valid, simf_wf_valid;
   wire [`WF_ID_LENGTH-1:0]   lsu_wf_chosen, salu_wf_choosen, simd_wf_choosen, simf_wf_choosen;
   
   arbiter lsu_arbiter
     (
      .clk(clk),
      .rst(rst),
      
      .input_arry(f_lsu_ready_to_issue),
      
      .issued_en(c_issued_valid),
      .issued_wf_id(c_issued_wfid),
      
      .choosen_valid(lsu_wf_valid),
      .choosen_wf_id(lsu_wf_chosen)
      );

   arbiter salu_arbiter
     (
      .clk(clk),
      .rst(rst),
      .input_arry(f_salu_ready_to_issue),
      .issued_en(c_issued_valid),
      .issued_wf_id(c_issued_wfid),
      
      .choosen_valid(salu_wf_valid),
      .choosen_wf_id(salu_wf_choosen)
      );
   
   arbiter simd_arbiter
     (
      .clk(clk),
      .rst(rst),
      
      .input_arry(f_simd_ready_to_issue),
      
      .issued_en(c_issued_valid),
      .issued_wf_id(c_issued_wfid),
      
      .choosen_valid(simd_wf_valid),
      .choosen_wf_id(simd_wf_choosen)
      );

   arbiter simf_arbiter
     (
      .clk(clk),
      .rst(rst),
      
      .input_arry(f_simf_ready_to_issue),
      
      .issued_en(c_issued_valid),
      .issued_wf_id(c_issued_wfid),
      
      .choosen_valid(simf_wf_valid),
      .choosen_wf_id(simf_wf_choosen)
      );
   
   alu_issue_logic alu_issue_logic
     (/*AUTOINST*/
      // Outputs
      .c_issued_valid			(c_issued_valid),
      .c_simd0_alu_select		(c_simd0_alu_select),
      .c_simd1_alu_select		(c_simd1_alu_select),
      .c_simd2_alu_select		(c_simd2_alu_select),
      .c_simd3_alu_select		(c_simd3_alu_select),
      .c_simf0_alu_select		(c_simf0_alu_select),
      .c_simf1_alu_select		(c_simf1_alu_select),
      .c_simf2_alu_select		(c_simf2_alu_select),
      .c_simf3_alu_select		(c_simf3_alu_select),
      .c_lsu_lsu_select			(c_lsu_lsu_select),
      .c_salu_alu_select		(c_salu_alu_select),
      .c_issued_wfid			(c_issued_wfid[`WF_ID_LENGTH-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .f_lsu_ready			(f_lsu_ready),
      .f_salu_alu_ready			(f_salu_alu_ready),
      .f_simf3_alu_ready		(f_simf3_alu_ready),
      .f_simf2_alu_ready		(f_simf2_alu_ready),
      .f_simf1_alu_ready		(f_simf1_alu_ready),
      .f_simf0_alu_ready		(f_simf0_alu_ready),
      .f_simd3_alu_ready		(f_simd3_alu_ready),
      .f_simd2_alu_ready		(f_simd2_alu_ready),
      .f_simd1_alu_ready		(f_simd1_alu_ready),
      .f_simd0_alu_ready		(f_simd0_alu_ready),
      .lsu_wf_valid			(lsu_wf_valid),
      .simd_wf_valid			(simd_wf_valid),
      .simf_wf_valid			(simf_wf_valid),
      .salu_wf_valid			(salu_wf_valid),
      .lsu_wf_chosen			(lsu_wf_chosen[`WF_ID_LENGTH-1:0]),
      .simd_wf_choosen			(simd_wf_choosen[`WF_ID_LENGTH-1:0]),
      .simf_wf_choosen			(simf_wf_choosen[`WF_ID_LENGTH-1:0]),
      .salu_wf_choosen			(salu_wf_choosen[`WF_ID_LENGTH-1:0]));

   assign alu_wfid = issued_wfid;
   assign lsu_wfid = issued_wfid;
   assign alu_valid = simd0_alu_select | simd1_alu_select | simd2_alu_select | 
			simd3_alu_select | simf0_alu_select | simf1_alu_select | 
			simf2_alu_select | simf3_alu_select | salu_alu_select;
   
   assign lsu_valid = lsu_lsu_select;
   
endmodule
