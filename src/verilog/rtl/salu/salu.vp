module salu(
	    issue_source_reg1,
	    issue_source_reg2,
	    issue_dest_reg,
	    issue_imm_value0,
	    issue_imm_value1,
	    issue_opcode,
	    issue_wfid,
	    issue_alu_select,
	    exec_rd_exec_value,
	    exec_rd_vcc_value,
	    exec_rd_m0_value,
	    exec_rd_scc_value,
	    sgpr_source2_data,
	    sgpr_source1_data,
	    issue_instr_pc,
	    exec_wr_exec_en,
	    exec_wr_vcc_en,
	    exec_wr_m0_en,
	    exec_wr_scc_en,
	    exec_wr_exec_value,
	    exec_wr_vcc_value,
	    exec_wr_m0_value,
	    exec_wr_scc_value,
	    exec_wr_wfid,
	    exec_rd_en,
	    exec_rd_wfid,
	    sgpr_dest_data, //**
	    sgpr_dest_addr, //**
	    sgpr_dest_wr_en, //**
	    sgpr_source2_addr, //**
	    sgpr_source1_addr, //**
	    sgpr_source1_rd_en, //**
	    sgpr_source2_rd_en, //**
	    issue_alu_ready, 
	    sgpr_instr_done_wfid, //**
	    sgpr_instr_done, //**
	    fetchwaveissue_branch_wfid,
	    fetchwaveissue_branch_en,
	    fetchwaveissue_branch_taken,
	    fetch_branch_pc_value,
	    tracemon_retire_pc,
	    tracemon_exec_word_sel,
	    tracemon_vcc_word_sel,
	    clk,
	    rst,

            //**CHANGE [PSP]
            rfa2sgpr_request
	    );

   input clk;

   input rst;

   input issue_alu_select, exec_rd_scc_value;
   input [5:0] issue_wfid;
   input [11:0] issue_source_reg1, issue_source_reg2, issue_dest_reg;
   input [15:0] issue_imm_value0;
   input [31:0] issue_imm_value1, exec_rd_m0_value, issue_instr_pc, issue_opcode;
   input [63:0] sgpr_source2_data, sgpr_source1_data,
		exec_rd_exec_value, exec_rd_vcc_value;

   //**CHANGE [PSP]
   output rfa2sgpr_request;

   output 	exec_wr_exec_en, exec_wr_vcc_en, exec_wr_m0_en, exec_wr_scc_en,
		exec_wr_scc_value, exec_rd_en, sgpr_source1_rd_en, sgpr_source2_rd_en, issue_alu_ready, sgpr_instr_done,
		fetchwaveissue_branch_en, fetchwaveissue_branch_taken;
   output [1:0] sgpr_dest_wr_en, tracemon_exec_word_sel, tracemon_vcc_word_sel;
   output [5:0] exec_wr_wfid, exec_rd_wfid, sgpr_instr_done_wfid, fetchwaveissue_branch_wfid;
   output [8:0] sgpr_dest_addr, sgpr_source2_addr, sgpr_source1_addr;
   output [31:0] exec_wr_m0_value, fetch_branch_pc_value, tracemon_retire_pc;
   output [63:0] exec_wr_exec_value, exec_wr_vcc_value, sgpr_dest_data;

   ///////////////////////////////
   //Your code goes here - beware: script does not recognize changes
   // into files. It ovewrites everithing without mercy. Save your work before running the script
   ///////////////////////////////

   wire 	 alu_select_i, alu_select_i_flopped, alu_select_ii, exec_en_i, 
		 vcc_en_i, scc_en_i, m0_en_i, branch_en, branch_taken, 
		 branch_taken_i, branch_en_i, branch_taken_ii, branch_en_ii, 
		 bit64_op, bit64_op_i, scc_val_i;
   wire [1:0] 	 sgpr_en_i, vcc_wordsel, exec_wordsel, vcc_wordsel_i,
		 exec_wordsel_i, vcc_wordsel_ii, exec_wordsel_ii;
   wire [5:0] 	 wfid_i, wfid_ii;
   wire [5:0] 	 branch_on_cc;
   wire [11:0] 	 source_reg1_i, source_reg2_i, dest_reg_i,
		 dest_reg_ii, salu_dst_reg;
   wire [11:0] 	 source_reg1_i_flopped, source_reg2_i_flopped;
   wire [15:0] 	 imm_value0_i;
   wire [31:0] 	 exec_rd_val1, exec_rd_val2, instr_pc_i,
		 instr_pc_ii, opcode_i, imm_value1_i;
   wire [63:0] 	 source2_value, source1_value, source1_value_i,
		 source2_value_i, dest_data;
   wire [63:0] 	 exec_val_i, vcc_val_i, exec_val_ii, vcc_val_ii, alu_out;

   // from controller
   wire [31:0] 	 alu_control, alu_control_i; // no of bits
   wire 	 vccz, execz, exec_en, vcc_en, scc_en, m0_en, scc_data,
		 exec_sgpr_cpy, exec_sgpr_cpy_i, exec_sgpr_cpy_ii, snd_src_imm;
   wire [1:0] 	 sgpr_en;

   wire 	 exec_rd1, vcc_rd1, sgpr_rd1, exec_rd2, vcc_rd2, sgpr_rd2;

   //**CHANGE add wires for new controller ports
   wire          salu2sgpr_req, salu2sgpr_req_i, salu2sgpr_req_ii;
   //**

   ///////////////////////////////////////////////////////
   // SOURCE REGISTER SELECT LOGIC

   reg 	 exec_rd_scc_value_i;
   reg [31:0] 	 exec_rd_m0_value_i;
   reg [63:0] exec_rd_exec_value_i, exec_rd_vcc_value_i;
   wire [63:0] sgpr_source2_data_i, sgpr_source1_data_i;
   wire rfa2salu_req_hold;
  
   // Keep the delay on exec signals
   always @ ( posedge clk or posedge rst ) begin
      if(rst) begin
	 exec_rd_scc_value_i <= 0;
	 exec_rd_m0_value_i <= 0;
	 //sgpr_source2_data_i <= 0;
	 //sgpr_source1_data_i <= 0;
	 exec_rd_exec_value_i <= 0;
	 exec_rd_vcc_value_i <= 0;
      end
      else begin
	 exec_rd_scc_value_i <= exec_rd_scc_value;
	 exec_rd_m0_value_i <= exec_rd_m0_value;
	 //sgpr_source2_data_i <= sgpr_source2_data;
	 //sgpr_source1_data_i <= sgpr_source1_data;
	 exec_rd_exec_value_i <= exec_rd_exec_value;
	 exec_rd_vcc_value_i <= exec_rd_vcc_value;
      end
   end

   assign sgpr_source2_data_i = sgpr_source2_data;
   assign sgpr_source1_data_i = sgpr_source1_data;

   assign alu_select_i = issue_alu_select;
   assign source_reg1_i = issue_source_reg1;
   assign source_reg2_i = issue_source_reg2;

   assign sgpr_source1_addr = source_reg1_i[8:0];
   assign sgpr_source2_addr = source_reg2_i[8:0];

   assign sgpr_source1_rd_en = alu_select_i;
   assign sgpr_source2_rd_en = alu_select_i;

   assign exec_rd_wfid = issue_wfid;

   assign vccz  = ~(|exec_rd_vcc_value_i);
   assign execz = ~(|exec_rd_exec_value_i);

   assign branch_en = (|branch_on_cc);
   assign branch_taken = (branch_on_cc[0] & ~exec_rd_scc_value_i) |
			 (branch_on_cc[1] & exec_rd_scc_value_i) |
			 (branch_on_cc[2] & vccz) |
			 (branch_on_cc[3] & ~vccz) |
			 (branch_on_cc[4] & execz) |
			 (branch_on_cc[5] & ~execz);

   // Test - read exec all time
   assign exec_rd_en = alu_select_i;

   // Data mux selection signas will arrive with the data, therefore
   // use delayed addr signals
   assign sgpr_rd1 = ~source_reg1_i_flopped[9];
   assign vcc_rd1 = (source_reg1_i_flopped[7:0] == 8'h01);
   assign exec_rd1 = (source_reg1_i_flopped[7:0] == 8'h08);

   assign source1_value[63:32] = bit64_op ?
				 sgpr_rd1 ? sgpr_source1_data_i[63:32] :
				 ((exec_rd1 ? exec_rd_exec_value_i[63:32] :
				   (vcc_rd1 ? exec_rd_vcc_value_i[63:32] : 32'bx)))
				   : 32'bx;

   assign source1_value[31:0] =
			       branch_en ? instr_pc_i :
			       source_reg1_i_flopped[11] ?
			       (
				source_reg1_i_flopped[10] ?
				(source_reg1_i_flopped[9] ? exec_rd_val1 : sgpr_source1_data_i[31:0]) :
				32'bx
				) : (source_reg1_i_flopped[10:0]==11'h7FF) ?
			       imm_value1_i : { {22{source_reg1_i_flopped[9]}}, source_reg1_i_flopped[9:0] };

   assign sgpr_rd2 = ~source_reg2_i_flopped[9];
   assign vcc_rd2 = (source_reg2_i_flopped[7:0] == 8'h01);
   assign exec_rd2 = (source_reg2_i_flopped[7:0] == 8'h08);

   assign source2_value[63:32] = bit64_op ?
				 sgpr_rd2 ? sgpr_source2_data_i[63:32] :
				 ((exec_rd2 ? exec_rd_exec_value_i[63:32] :
				   (vcc_rd2 ? exec_rd_vcc_value_i[63:32] : 32'bx)))
				   : 32'bx;

   assign source2_value[31:0] =
			       snd_src_imm ? { {16{imm_value0_i[15]}}, imm_value0_i } :
			       source_reg2_i_flopped[11] ?
			       (
				source_reg2_i_flopped[10] ?
				(source_reg2_i_flopped[9] ? exec_rd_val2 : sgpr_source2_data_i[31:0]) :
				32'bx
				) : (source_reg2_i_flopped[10:0]==11'h7FF) ?
			       imm_value1_i : { {22{source_reg2_i_flopped[9]}}, source_reg2_i_flopped[9:0] };

   assign exec_rd_val1 =
			(source_reg1_i_flopped[7:0] == 8'h01) ? exec_rd_vcc_value_i[31:0]    :
			(source_reg1_i_flopped[7:0] == 8'h02) ? exec_rd_vcc_value_i[63:32]   :
			(source_reg1_i_flopped[7:0] == 8'h04) ? exec_rd_m0_value_i           :
			(source_reg1_i_flopped[7:0] == 8'h08) ? exec_rd_exec_value_i[31:0]   :
			(source_reg1_i_flopped[7:0] == 8'h10) ? exec_rd_exec_value_i[63:32]  :
			(source_reg1_i_flopped[7:0] == 8'h20) ? {31'b0, vccz}              :
			(source_reg1_i_flopped[7:0] == 8'h40) ? {31'b0, execz}             :
			(source_reg1_i_flopped[7:0] == 8'h80) ? {31'b0, exec_rd_scc_value_i} : 32'bx;

   assign exec_rd_val2 =
			(source_reg2_i_flopped[7:0] == 8'h01) ? exec_rd_vcc_value_i[31:0]    :
			(source_reg2_i_flopped[7:0] == 8'h02) ? exec_rd_vcc_value_i[63:32]   :
			(source_reg2_i_flopped[7:0] == 8'h04) ? exec_rd_m0_value_i           :
			(source_reg2_i_flopped[7:0] == 8'h08) ? exec_rd_exec_value_i[31:0]   :
			(source_reg2_i_flopped[7:0] == 8'h10) ? exec_rd_exec_value_i[63:32]  :
			(source_reg2_i_flopped[7:0] == 8'h20) ? {31'b0, vccz}              :
			(source_reg2_i_flopped[7:0] == 8'h40) ? {31'b0, execz}             :
			(source_reg2_i_flopped[7:0] == 8'h80) ? {31'b0, exec_rd_scc_value_i} : 32'bx;

   ///////////////////////////////////////////////////////
   // STAGE FLOPS

   // TODO : CHANGE ALL LATCH WIDTHS

   // Stage 1: Latching input from Issue
   regfile #(155) salu_instr(
			     { issue_alu_select, issue_wfid, issue_source_reg1,
			       issue_source_reg2, issue_dest_reg, issue_imm_value0,
			       issue_imm_value1, issue_opcode, issue_instr_pc },
			     1'b1,
			     { alu_select_i_flopped, wfid_i, source_reg1_i_flopped,
			       source_reg2_i_flopped, dest_reg_i, imm_value0_i,
			       imm_value1_i, opcode_i, instr_pc_i },
			     clk, rst
			     );

   // Stage 2: Latching control signals
   regfile #(97) salu_decode(
			     { alu_select_i_flopped, dest_reg_i, wfid_i,
			       instr_pc_i, alu_control, exec_en, vcc_en, scc_en,
			       m0_en, sgpr_en, vcc_wordsel, exec_wordsel,
			       branch_en, branch_taken, exec_sgpr_cpy, bit64_op, salu2sgpr_req },
			     1'b1,
			     { alu_select_ii, dest_reg_ii, wfid_ii,
			       instr_pc_ii, alu_control_i, exec_en_i, vcc_en_i, scc_en_i,
			       m0_en_i, sgpr_en_i, vcc_wordsel_i, exec_wordsel_i,
			       branch_en_i, branch_taken_i, exec_sgpr_cpy_i, bit64_op_i, salu2sgpr_req_i },
			     clk, rst
			     );

   // Stage 2: Latching source operands
   regfile #(257) source_input(
			       { source1_value, source2_value, exec_rd_exec_value_i, exec_rd_vcc_value_i, exec_rd_scc_value_i },
			       1'b1,
			       { source1_value_i, source2_value_i, exec_val_i, vcc_val_i, scc_val_i },
			       clk, rst
			       );

   // Stage 3: Latching writeback control signals and data
   regfile #(256) writeback(
			    { instr_pc_ii, exec_en_i, vcc_en_i, scc_en_i, m0_en_i,
			      sgpr_en_i, dest_reg_ii, wfid_ii, alu_out, scc_data,
			      vcc_wordsel_i, exec_wordsel_i, exec_val_i, vcc_val_i,
			      branch_en_i, branch_taken_i, exec_sgpr_cpy_i, salu2sgpr_req_i },
			    1'b1,
			    { tracemon_retire_pc, exec_wr_exec_en, exec_wr_vcc_en,
			      exec_wr_scc_en, exec_wr_m0_en, sgpr_dest_wr_en,
			      salu_dst_reg, sgpr_instr_done_wfid, dest_data,
			      exec_wr_scc_value, vcc_wordsel_ii, exec_wordsel_ii,
			      exec_val_ii, vcc_val_ii, fetchwaveissue_branch_en,
			      fetchwaveissue_branch_taken, exec_sgpr_cpy_ii, salu2sgpr_req_ii },
			    clk, rst
			    );

   //**CHANGE [PSP]
   //request line will be double flopped. 
   assign rfa2sgpr_request = salu2sgpr_req_ii;
   ///////////////////////////////////////////////////////
   // MODULE INSTANTIATIONS


   //**CHANGE [psp]
   //**ADD two ports for salu2sgpr_request and rfa2salu_req_hold
   //controller

   assign rfa2salu_req_hold = (salu2sgpr_req_ii | salu2sgpr_req_i | salu2sgpr_req) ? 1'b1: 1'b0;
   salu_controller scontrol(
			    .control_en(alu_select_i_flopped), .dst_reg(dest_reg_i), .opcode(opcode_i), 
                            .alu_control(alu_control), .branch_on_cc(branch_on_cc), .exec_en(exec_en), 
                            .vcc_en(vcc_en), .scc_en(scc_en), .m0_en(m0_en), .sgpr_en(sgpr_en), 
                            .vcc_wordsel(vcc_wordsel), .exec_wordsel(exec_wordsel), .exec_sgpr_cpy(exec_sgpr_cpy), 
                            .snd_src_imm(snd_src_imm), .bit64_op(bit64_op), .rst(rst), .clk(clk), 
                            .salu2sgpr_req(salu2sgpr_req), .rfa2salu_req_hold(rfa2salu_req_hold), 
                            .control_en_fw(issue_alu_select), .dst_reg_fw(issue_dest_reg)
			    );
   //**

   //alu
   scalar_alu salu_gpu(
		       .s1(source1_value_i), .s2(source2_value_i), .exec(exec_val_i), .control(alu_control_i),
		       .scc(scc_val_i), .b64_op(bit64_op_i), .out(alu_out), .scc_val(scc_data)
		       );

   ///////////////////////////////////////////////////////
   // WRITEBACK DATA GENERATION

   // SGPR signals
   assign sgpr_dest_addr = salu_dst_reg[8:0];
   assign sgpr_dest_data = exec_sgpr_cpy_ii ? exec_val_ii : dest_data;

   // Exec signals
   assign exec_wr_exec_value = (exec_wordsel_ii == 2'b11) ?
			       dest_data : (exec_wordsel_ii == 2'b10) ?
			       {dest_data[31:0], exec_val_ii[31:0]} : (exec_wordsel_ii == 2'b01) ?
			       {exec_val_ii[63:32], dest_data[31:0]} : exec_val_ii;
   assign exec_wr_vcc_value = (vcc_wordsel_ii == 2'b11) ?
			      dest_data : (vcc_wordsel_ii == 2'b10) ?
			      {dest_data[31:0], vcc_val_ii[31:0]} : (vcc_wordsel_ii == 2'b01) ?
			      {vcc_val_ii[63:32], dest_data[31:0]} : vcc_val_ii;
   assign exec_wr_m0_value = dest_data[31:0];
   assign exec_wr_wfid = sgpr_instr_done_wfid;

   // Branch signals
   assign fetch_branch_pc_value = dest_data[31:0];
   assign fetchwaveissue_branch_wfid = sgpr_instr_done_wfid;

   assign sgpr_instr_done = exec_wr_exec_en | exec_wr_vcc_en | exec_wr_m0_en | exec_wr_scc_en | (|sgpr_dest_wr_en);

   // Tracemon signals
   assign tracemon_exec_word_sel = exec_wordsel_ii;
   assign tracemon_vcc_word_sel  = vcc_wordsel_ii;

   // SALU is currently always ready
   // can accept an instruction every cycle
   //assign issue_alu_ready = 1'b1;

   //**CHANGE [psp]
   // SALU not always ready
   // SALU will only accept instruction every cycle
   // if pending request line is not high
   // this is to prevent new instructions coming in while
   // salu has not been satisfied to write to SGPR

   assign issue_alu_ready = ~rfa2salu_req_hold;

   //** 

endmodule
