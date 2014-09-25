//                              -*- Mode: Verilog -*-
// Filename        : vgpr_contention_tracker.v
// Description     : Implements a contention tracker for the vgpr register file
// Author          : Mario Paulo Drumond
// Created On      : Sat Aug 31 21:57:26 2013
// Last Modified By: Mario Paulo Drumond
// Last Modified On: Sat Aug 31 21:57:26 2013
// Update Count    : 0
// Status          : Unknown, Use with caution!
module vgpr_contention_tracker 
  (/*AUTOARG*/
   // Inputs
   clk, rst, lsu_source1_rd_en, lsu_source2_rd_en,
   simd0_source1_rd_en, simd1_source1_rd_en, simd2_source1_rd_en,
   simd3_source1_rd_en, simd0_source2_rd_en, simd1_source2_rd_en,
   simd2_source2_rd_en, simd3_source2_rd_en, simd0_source3_rd_en,
   simd1_source3_rd_en, simd2_source3_rd_en, simd3_source3_rd_en,
   simd0_wr_en, simd1_wr_en, simd2_wr_en, simd3_wr_en,
   simf0_source1_rd_en, simf1_source1_rd_en, simf2_source1_rd_en,
   simf3_source1_rd_en, simf0_source2_rd_en, simf1_source2_rd_en,
   simf2_source2_rd_en, simf3_source2_rd_en, simf0_source3_rd_en,
   simf1_source3_rd_en, simf2_source3_rd_en, simf3_source3_rd_en,
   simf0_wr_en, simf1_wr_en, simf2_wr_en, simf3_wr_en, lsu_dest_wr_en,
   simd0_source1_addr, simd1_source1_addr, simd2_source1_addr,
   simd3_source1_addr, simd0_source2_addr, simd1_source2_addr,
   simd2_source2_addr, simd3_source2_addr, simd0_source3_addr,
   simd1_source3_addr, simd2_source3_addr, simd3_source3_addr,
   simd0_dest_addr, simd1_dest_addr, simd2_dest_addr, simd3_dest_addr,
   simf0_source1_addr, simf1_source1_addr, simf2_source1_addr,
   simf3_source1_addr, simf0_source2_addr, simf1_source2_addr,
   simf2_source2_addr, simf3_source2_addr, simf0_source3_addr,
   simf1_source3_addr, simf2_source3_addr, simf3_source3_addr,
   simf0_dest_addr, simf1_dest_addr, simf2_dest_addr, simf3_dest_addr,
   lsu_source1_addr, lsu_source2_addr, lsu_dest_addr, rfa_select_fu,
   fetch2tracemon_dispatch, issue2fetchwave_wf_done_en,
   issue2fetchwave_wf_done_wf_id, fetch2tracemon_new_wfid
   ) ;
   input clk;

   input rst;

   input lsu_source1_rd_en, lsu_source2_rd_en;
   input simd0_source1_rd_en, simd1_source1_rd_en, simd2_source1_rd_en,
         simd3_source1_rd_en, simd0_source2_rd_en, simd1_source2_rd_en, 
	 simd2_source2_rd_en, simd3_source2_rd_en, simd0_source3_rd_en, 
	 simd1_source3_rd_en, simd2_source3_rd_en, simd3_source3_rd_en, 
	 simd0_wr_en, simd1_wr_en, simd2_wr_en, simd3_wr_en, simf0_source1_rd_en, 
	 simf1_source1_rd_en, simf2_source1_rd_en, simf3_source1_rd_en,
         simf0_source2_rd_en, simf1_source2_rd_en, simf2_source2_rd_en, 
         simf3_source2_rd_en, simf0_source3_rd_en, simf1_source3_rd_en, 
	 simf2_source3_rd_en, simf3_source3_rd_en, simf0_wr_en, simf1_wr_en, 
	 simf2_wr_en, simf3_wr_en;
   input [3:0] lsu_dest_wr_en;
   input [9:0] simd0_source1_addr, simd1_source1_addr, simd2_source1_addr,
               simd3_source1_addr, simd0_source2_addr, simd1_source2_addr, 
	       simd2_source2_addr, simd3_source2_addr, simd0_source3_addr, 
	       simd1_source3_addr, simd2_source3_addr, simd3_source3_addr, 
	       simd0_dest_addr, simd1_dest_addr, simd2_dest_addr, simd3_dest_addr, 
	       simf0_source1_addr, simf1_source1_addr, simf2_source1_addr, 
	       simf3_source1_addr, simf0_source2_addr, simf1_source2_addr, 
	       simf2_source2_addr, simf3_source2_addr, simf0_source3_addr, 
	       simf1_source3_addr, simf2_source3_addr, simf3_source3_addr, 
	       simf0_dest_addr, simf1_dest_addr, simf2_dest_addr, simf3_dest_addr, 
	       lsu_source1_addr, lsu_source2_addr, lsu_dest_addr;
   input [15:0] rfa_select_fu;

   input 	fetch2tracemon_dispatch; //1

   input 	issue2fetchwave_wf_done_en;
   input [5:0] 	issue2fetchwave_wf_done_wf_id;
   input [5:0] 	fetch2tracemon_new_wfid; //6

   

   wire 	rd_src1_rd_en, rd_src2_rd_en, rd_src3_rd_en;
   wire [9:0] 	rd_src1_addr, rd_src2_addr, rd_src3_addr;

   wire 		wr_alu_wr_en;
   wire [9:0] 	wr_alu_addr;

   reg [39:0] 	live_wf;
   
   integer 	contention_access_counter, access_counter;
   reg 		end_of_execution;

   localparam BANK_SIZE = 16;
   localparam BANK_ADDR_SIZE = 4;
   
   
   integer  curr_bank_access[0:BANK_SIZE-1];
   reg [BANK_ADDR_SIZE-1:0] rd_src1_bank_addr, rd_src2_bank_addr, rd_src3_bank_addr, 
			    wr_alu_bank_addr, wr_lsu_bank_addr;
   
   
   assign rd_src1_rd_en = |{simd0_source1_rd_en, simd1_source1_rd_en,
			    simd2_source1_rd_en, simd3_source1_rd_en,
			    simf0_source1_rd_en, simf1_source1_rd_en,
			    simf2_source1_rd_en, simf3_source1_rd_en};
   
   assign rd_src1_addr = simd0_source1_rd_en?  simd0_source1_addr :
			 simd1_source1_rd_en?  simd1_source1_addr :
			 simd2_source1_rd_en?  simd2_source1_addr :
			 simd3_source1_rd_en?  simd3_source1_addr :
			 simf0_source1_rd_en?  simf0_source1_addr :
			 simf1_source1_rd_en?  simf1_source1_addr :
			 simf2_source1_rd_en?  simf2_source1_addr :
			 simf3_source1_rd_en?  simf3_source1_addr :
			 10'h0;
   
   assign rd_src2_rd_en = |{simd0_source2_rd_en, simd1_source2_rd_en,
			    simd2_source2_rd_en, simd3_source2_rd_en,
			    simf0_source2_rd_en, simf1_source2_rd_en,
			    simf2_source2_rd_en, simf3_source2_rd_en};
   
   assign rd_src2_addr = simd0_source2_rd_en?  simd0_source2_addr :
			 simd1_source2_rd_en?  simd1_source2_addr :
			 simd2_source2_rd_en?  simd2_source2_addr :
			 simd3_source2_rd_en?  simd3_source2_addr :
			 simf0_source2_rd_en?  simf0_source2_addr :
			 simf1_source2_rd_en?  simf1_source2_addr :
			 simf2_source2_rd_en?  simf2_source2_addr :
			 simf3_source2_rd_en?  simf3_source2_addr :
			 10'h0;

   assign rd_src3_rd_en = |{simd0_source3_rd_en, simd1_source3_rd_en,
			    simd2_source3_rd_en, simd3_source3_rd_en,
			    simf0_source3_rd_en, simf1_source3_rd_en,
			    simf2_source3_rd_en, simf3_source3_rd_en};
   
   assign rd_src3_addr = simd0_source3_rd_en?  simd0_source3_addr :
			 simd1_source3_rd_en?  simd1_source3_addr :
			 simd2_source3_rd_en?  simd2_source3_addr :
			 simd3_source3_rd_en?  simd3_source3_addr :
			 simf0_source3_rd_en?  simf0_source3_addr :
			 simf1_source3_rd_en?  simf1_source3_addr :
			 simf2_source3_rd_en?  simf2_source3_addr :
			 simf3_source3_rd_en?  simf3_source3_addr :
			 10'h0;

   assign wr_alu_wr_en = |rfa_select_fu;
   assign wr_alu_addr = rfa_select_fu[0]? simd0_dest_addr :
			rfa_select_fu[1]? simd1_dest_addr :
			rfa_select_fu[2]? simd2_dest_addr :
			rfa_select_fu[3]? simd3_dest_addr :
			rfa_select_fu[4]? simf0_dest_addr :
			rfa_select_fu[5]? simf1_dest_addr :
			rfa_select_fu[6]? simf2_dest_addr :
			rfa_select_fu[7]? simf3_dest_addr : 
			10'h0;
   

   integer 	  i;

   assign rd_src1_bank_addr = rd_src1_addr[BANK_ADDR_SIZE-1:0];
   assign rd_src2_bank_addr = rd_src2_addr[BANK_ADDR_SIZE-1:0];
   assign rd_src3_bank_addr = rd_src3_addr[BANK_ADDR_SIZE-1:0];
   assign wr_alu_bank_addr = wr_alu_addr[BANK_ADDR_SIZE-1:0];
   assign wr_lsu_bank_addr = lsu_dest_addr[BANK_ADDR_SIZE-1:0];
   
   
   
   // Block that keeps track of contention accesses
   always @(negedge clk) begin
      
      // Clear the counter for bank access in this cycle
      for (i = 0; i<BANK_SIZE; i= i+1) begin
	 curr_bank_access[i] = 0;
      end

      // Account for accesses of each port to the respective bank
      if(rd_src1_rd_en) begin
	 curr_bank_access[rd_src1_bank_addr] = curr_bank_access[rd_src1_bank_addr]+1;
	 access_counter = access_counter + 1;
      end

      if(rd_src2_rd_en) begin
	 curr_bank_access[rd_src2_bank_addr] = curr_bank_access[rd_src2_bank_addr]+1;
	 access_counter = access_counter + 1;
      end

      if(rd_src3_rd_en) begin
	 curr_bank_access[rd_src3_bank_addr] = curr_bank_access[rd_src3_bank_addr]+1;
	 access_counter = access_counter + 1;
      end
      
      if(lsu_dest_wr_en[0]) begin
	 curr_bank_access[wr_lsu_bank_addr] = curr_bank_access[wr_lsu_bank_addr]+1;
	 access_counter = access_counter + 1;
      end

      if(lsu_dest_wr_en[1]) begin
	 curr_bank_access[(wr_lsu_bank_addr+1)%BANK_SIZE] 
			      = curr_bank_access[(wr_lsu_bank_addr+1)%16]+1;
	 access_counter = access_counter + 1;
      end

      if(lsu_dest_wr_en[2]) begin
	 curr_bank_access[(wr_lsu_bank_addr+2)%BANK_SIZE] 
			      = curr_bank_access[(wr_lsu_bank_addr+2)%16]+1;
	 access_counter = access_counter + 1;
      end

      if(lsu_dest_wr_en[3]) begin
	 curr_bank_access[(wr_lsu_bank_addr+3)%BANK_SIZE] 
			      = curr_bank_access[(wr_lsu_bank_addr+3)%16]+1;
	 access_counter = access_counter + 1;
      end

      if(wr_alu_wr_en) begin
	 curr_bank_access[wr_alu_bank_addr] 
			 = curr_bank_access[wr_alu_bank_addr] + 1;
	 access_counter = access_counter + 1;
      end


      for (i = 0; i<BANK_SIZE; i= i+1) begin
	 if(curr_bank_access[i] > 1) begin
	    contention_access_counter = contention_access_counter+1;
	    
	 end
      end

   end

   
   // block that keeps track of live wf
   initial begin
      access_counter = 0;
      contention_access_counter = 0;

      // Wait for the first dispach
      @( posedge fetch2tracemon_dispatch);
      
      forever begin
	 @(posedge clk);
	 if(issue2fetchwave_wf_done_en) begin
	    $display("Number of accesses: %d\nNumber of access with contention:%d\n",
	       access_counter,contention_access_counter);
	 end
      end

   end
   
endmodule // vgpr_contention_tracker
