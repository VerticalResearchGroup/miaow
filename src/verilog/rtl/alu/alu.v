module alu(
           issue_source_reg1,
           issue_source_reg2,
           issue_source_reg3,
           issue_dest_reg1,
           issue_dest_reg2,
           issue_imm_value0,
           issue_imm_value1,
           issue_opcode,
           issue_wfid,
           issue_alu_select,
           vgpr_source1_data,
           vgpr_source2_data,
           vgpr_source3_data,
           sgpr_rd_data,
           exec_rd_exec_value,
           exec_rd_vcc_value,
           exec_rd_m0_value,
           exec_rd_scc_value,
           issue_instr_pc,
           rfa_queue_entry_serviced,
           vgpr_source1_rd_en,
           vgpr_source2_rd_en,
           vgpr_source3_rd_en,
           vgpr_source1_addr,
           vgpr_source2_addr,
           vgpr_source3_addr,
           vgpr_dest_addr,
           vgpr_dest_data,
           vgpr_wr_en,
           vgpr_wr_mask,
           exec_rd_wfid,
           exec_rd_en,
           exec_wr_vcc_wfid,
           exec_wr_vcc_en,
           exec_wr_vcc_value,
           sgpr_rd_en,
           sgpr_rd_addr,
           sgpr_wr_addr,
           sgpr_wr_en,
           sgpr_wr_data,
           sgpr_wr_mask,
           issue_alu_ready,
           vgpr_instr_done_wfid,
           vgpr_instr_done,
           rfa_queue_entry_valid,
           //tracemon_retire_valid,
           tracemon_retire_pc,
           clk,
           rst
           );

   parameter MODULE = `MODULE_SIMD;

   input clk;

   input rst;

   input issue_alu_select, exec_rd_scc_value, rfa_queue_entry_serviced;
   input [5:0] issue_wfid;
   input [11:0] issue_source_reg1, issue_source_reg2, issue_source_reg3,
		issue_dest_reg1, issue_dest_reg2;
   input [15:0] issue_imm_value0;
   input [31:0] issue_imm_value1, issue_opcode, sgpr_rd_data, exec_rd_m0_value,
		issue_instr_pc;
   input [63:0] exec_rd_exec_value, exec_rd_vcc_value;
   input [2047:0] vgpr_source1_data, vgpr_source2_data, vgpr_source3_data;

   output 	  vgpr_source1_rd_en, vgpr_source2_rd_en, vgpr_source3_rd_en, vgpr_wr_en,
		  exec_rd_en, exec_wr_vcc_en, sgpr_rd_en, sgpr_wr_en, issue_alu_ready,
		  vgpr_instr_done, rfa_queue_entry_valid;
   output [5:0]   exec_rd_wfid, exec_wr_vcc_wfid, vgpr_instr_done_wfid;
   output [8:0]   sgpr_rd_addr, sgpr_wr_addr;
   output [9:0]   vgpr_source1_addr, vgpr_source2_addr, vgpr_source3_addr,
		  vgpr_dest_addr;
   output [31:0]  tracemon_retire_pc;
   output [63:0]  vgpr_wr_mask, exec_wr_vcc_value, sgpr_wr_data, sgpr_wr_mask;
   output [2047:0] vgpr_dest_data;

   wire [31:0] 	   tracemon_retire_pc;
   //wire tracemon_retire_valid; //not needed in top level anymore

   wire [11:0] 	   rd_source1_addr;
   wire [11:0] 	   rd_source2_addr;
   wire [11:0] 	   rd_source3_addr;
   
   //PS_flops_issue_alu
   wire 	   cnt_alu_select;
   wire [31:0] 	   cnt_opcode;
   wire [11:0] 	   rd_dest1_addr;
   wire [11:0] 	   rd_dest2_addr;
   wire [5:0] 	   ex_wfid;
   wire [31:0] 	   ex_instr_pc;
   wire [15:0] 	   imm_value_0;
   wire [31:0] 	   imm_value_1;

   //alu_controller
   wire [3:0] 	   source1_mux_select;
   wire [3:0] 	   source2_mux_select;
   wire [3:0] 	   source3_mux_select;
   wire 	   src_buffer_wr_en;
   wire [31:0] 	   alu_control;
   wire 	   alu_start;
   wire [11:0] 	   ex_vgpr_dest_addr;
   wire [11:0] 	   ex_sgpr_dest_addr;
   wire 	   ex_vgpr_wr_en;
   wire 	   ex_sgpr_wr_en;
   wire 	   ex_instr_done;
   wire 	   ex_vcc_wr_en;
   wire 	   alu_ready;
   wire [9:0] 	   source1_src_constant;
   wire [9:0] 	   source2_src_constant;
   wire [9:0] 	   source3_src_constant;
   
   
   //src1_mux
   wire [2047:0]   source1_data;
   wire [2047:0]   source2_data;
   wire [2047:0]   source3_data;

   //src_shift_reg
   wire [511:0]    alu_source1_data;
   wire [511:0]    alu_source2_data;
   wire [511:0]    alu_source3_data;
   wire [15:0] 	   alu_source_vcc_value;
   wire [15:0] 	   alu_source_exec_value;


   //valu
   wire [511:0]    alu_vgpr_dest_data;
   wire [15:0] 	   alu_sgpr_dest_data;
   wire [15:0] 	   alu_dest_vcc_value;
   wire [15:0] 	   alu_dest_exec_value;
   wire            valu_done;

   //dest_shift_reg
   wire [2047:0]   queue_vgpr_dest_data;
   wire [63:0] 	   queue_sgpr_dest_data;
   wire [63:0] 	   queue_vgpr_wr_mask;
   wire [63:0] 	   queue_exec_wr_vcc_value;

   //PS_flops_EX_WB_alu
   wire 	   queue_vgpr_wr_en;
   wire 	   queue_sgpr_wr_en;
   wire [9:0] 	   queue_vgpr_dest_addr;
   wire [8:0] 	   queue_sgpr_dest_addr;
   wire [5:0] 	   queue_vgpr_instr_done_wfid;
   wire [31:0] 	   queue_tracemon_retire_pc;
   wire 	   queue_vgpr_instr_done;
   wire 	   queue_exec_wr_vcc_en;

   //wb_queue
   wire 	   queue_ready;
   wire 	   queue_empty;

   // TEST_HERE
   wire [31:0] 	   sgpr_rd_data_i;
   reg [31:0] exec_rd_m0_value_i;
   reg [63:0] exec_rd_exec_value_i, exec_rd_vcc_value_i;
   reg 	      exec_rd_scc_value_i;
   wire [2047:0] vgpr_source1_data_i, vgpr_source2_data_i, vgpr_source3_data_i;

   // Keep a single delay on exec signals
   always @ ( posedge clk or posedge rst ) begin
      if(rst) begin
	 //sgpr_rd_data_i <= 0;
	 exec_rd_m0_value_i <= 0;
	 exec_rd_exec_value_i <= 0;
	 exec_rd_vcc_value_i <= 0;
	 exec_rd_scc_value_i <= 0;
	 //vgpr_source1_data_i <= 0;
	 //vgpr_source2_data_i <= 0;
	 //vgpr_source3_data_i <= 0;
      end
      else begin
	 //sgpr_rd_data_i <= sgpr_rd_data;
	 exec_rd_m0_value_i <= exec_rd_m0_value;
	 exec_rd_exec_value_i <= exec_rd_exec_value;
	 exec_rd_vcc_value_i <= exec_rd_vcc_value;
	 exec_rd_scc_value_i <= exec_rd_scc_value;
	 //vgpr_source1_data_i <= vgpr_source1_data;
	 //vgpr_source2_data_i <= vgpr_source2_data;
	 //vgpr_source3_data_i <= vgpr_source3_data;
      end
   end
   assign sgpr_rd_data_i = sgpr_rd_data;
   assign vgpr_source1_data_i = vgpr_source1_data;
   assign vgpr_source2_data_i = vgpr_source2_data;
   assign vgpr_source3_data_i = vgpr_source3_data;
   
   
   assign rd_source1_addr = issue_source_reg1;
   assign rd_source2_addr = issue_source_reg2;
   assign rd_source3_addr = issue_source_reg3;

   assign exec_wr_vcc_wfid = vgpr_instr_done_wfid;
   //assign tracemon_retire_valid = vgpr_instr_done;  //not needed in top level anymore
   assign rfa_queue_entry_valid = vgpr_instr_done & ~queue_empty;
   assign exec_rd_wfid = issue_wfid;
   assign vgpr_source1_addr = rd_source1_addr[9:0];
   assign vgpr_source2_addr = rd_source2_addr[9:0];
   assign vgpr_source3_addr = rd_source3_addr[9:0];
   assign issue_alu_ready = alu_ready & queue_ready;
   assign sgpr_wr_mask = vgpr_wr_mask;

   assign sgpr_rd_addr = (rd_source1_addr[11:9] == 3'b110) ? rd_source1_addr[8:0] :
                         ((rd_source2_addr[11:9] == 3'b110) ? rd_source2_addr[8:0] :
                          ((rd_source3_addr[11:9] == 3'b110) ? rd_source3_addr[8:0] : 3'bx));

   
   PS_flops_issue_alu flops_issue_alu
     (
      .in_alu_select(issue_alu_select),
      .in_wfid(issue_wfid),
      .in_instr_pc(issue_instr_pc),
      .in_opcode(issue_opcode),
      .in_imm_value0(issue_imm_value0),
      .in_imm_value1(issue_imm_value1),
      .in_dest1_addr(issue_dest_reg1),
      .in_dest2_addr(issue_dest_reg2),
      .out_alu_select(cnt_alu_select),
      .out_wfid(ex_wfid),
      .out_instr_pc(ex_instr_pc),
      .out_opcode(cnt_opcode),
      .out_imm_value0(imm_value_0),
      .out_imm_value1(imm_value_1),
      .out_dest1_addr(rd_dest1_addr),
      .out_dest2_addr(rd_dest2_addr),
      .clk(clk),
      .rst(rst)
      );

   alu_controller #(.MODULE(MODULE)) alu_controller
     (
      .in_alu_select_flopped(cnt_alu_select),
      .in_alu_select(issue_alu_select),
      .in_source1_addr(rd_source1_addr),
      .in_source2_addr(rd_source2_addr),
      .in_source3_addr(rd_source3_addr),
      .in_dest1_addr(rd_dest1_addr),
      .in_dest2_addr(rd_dest2_addr),
      .in_opcode(cnt_opcode),
      .in_valu_done(valu_done),
      .out_alu_ready(alu_ready),
      .out_vcc_wr_en(ex_vcc_wr_en),
      .out_instr_done(ex_instr_done),
      .out_vgpr_wr_en(ex_vgpr_wr_en),
      .out_vgpr_dest_addr(ex_vgpr_dest_addr),
      .out_sgpr_wr_en(ex_sgpr_wr_en),
      .out_sgpr_dest_addr(ex_sgpr_dest_addr),
      .out_alu_control(alu_control),
      .out_alu_start(alu_start),
      .out_src_buffer_wr_en(src_buffer_wr_en),
      .out_source1_mux_select(source1_mux_select),
      .out_source2_mux_select(source2_mux_select),
      .out_source3_mux_select(source3_mux_select),
      .out_source1_src_constant(source1_src_constant),
      .out_source2_src_constant(source2_src_constant),
      .out_source3_src_constant(source3_src_constant),
      .out_vgpr_source1_rd_en(vgpr_source1_rd_en),
      .out_vgpr_source2_rd_en(vgpr_source2_rd_en),
      .out_vgpr_source3_rd_en(vgpr_source3_rd_en),
      .out_sgpr_rd_en(sgpr_rd_en),
      .out_exec_rd_en(exec_rd_en),
      .clk(clk),
      .rst(rst)
      );

   src_mux src1_mux
     (
      .src_constant(source1_src_constant),
      .sgpr_rd_data(sgpr_rd_data_i),
      .vgpr_source_data(vgpr_source1_data_i),
      .exec_rd_exec_value(exec_rd_exec_value_i),
      .exec_rd_vcc_value(exec_rd_vcc_value_i),
      .exec_rd_m0_value(exec_rd_m0_value_i),
      .exec_rd_scc_value(exec_rd_scc_value_i),
      .literal_constant(imm_value_1),
      .source_mux_select(source1_mux_select),
      .source_data(source1_data)
      );

   src_mux src2_mux
     (
      .src_constant(source2_src_constant),
      .sgpr_rd_data(sgpr_rd_data_i),
      .vgpr_source_data(vgpr_source2_data_i),
      .exec_rd_exec_value(exec_rd_exec_value_i),
      .exec_rd_vcc_value(exec_rd_vcc_value_i),
      .exec_rd_m0_value(exec_rd_m0_value_i),
      .exec_rd_scc_value(exec_rd_scc_value_i),
      .literal_constant(imm_value_1),
      .source_mux_select(source2_mux_select),
      .source_data(source2_data)
      );

   src_mux src3_mux
     (
      .src_constant(source3_src_constant),
      .sgpr_rd_data(sgpr_rd_data_i),
      .vgpr_source_data(vgpr_source3_data_i),
      .exec_rd_exec_value(exec_rd_exec_value_i),
      .exec_rd_vcc_value(exec_rd_vcc_value_i),
      .exec_rd_m0_value(exec_rd_m0_value_i),
      .exec_rd_scc_value(exec_rd_scc_value_i),
      .literal_constant(imm_value_1),
      .source_mux_select(source3_mux_select),
      .source_data(source3_data)
      );

   src_shift_reg src_shift_reg
     (
      .source1_data(source1_data),
      .source2_data(source2_data),
      .source3_data(source3_data),
      .source_vcc_value(exec_rd_vcc_value_i),
      .source_exec_value(exec_rd_exec_value_i),
      .src_buffer_wr_en(src_buffer_wr_en),
      .src_buffer_shift_en(valu_done),
      .alu_source1_data(alu_source1_data),
      .alu_source2_data(alu_source2_data),
      .alu_source3_data(alu_source3_data),
      .alu_source_vcc_value(alu_source_vcc_value),
      .alu_source_exec_value(alu_source_exec_value),
      .clk(clk),
      .rst(rst)
      );

   valu #(.MODULE(MODULE)) valu
     (
      .alu_source1_data(alu_source1_data),
      .alu_source2_data(alu_source2_data),
      .alu_source3_data(alu_source3_data),
      .alu_source_vcc_value(alu_source_vcc_value),
      .alu_source_exec_value(alu_source_exec_value),
      .alu_control(alu_control),
      .alu_start(alu_start),
      .alu_vgpr_dest_data(alu_vgpr_dest_data),
      .alu_sgpr_dest_data(alu_sgpr_dest_data),
      .alu_dest_vcc_value(alu_dest_vcc_value),
      .alu_dest_exec_value(alu_dest_exec_value),
      .valu_done(valu_done),
      .clk(clk),
      .rst(rst)
      );

   dest_shift_reg dest_shift_reg
     (
      .alu_vgpr_dest_data(alu_vgpr_dest_data),
      .alu_sgpr_dest_data(alu_sgpr_dest_data),
      .alu_dest_vcc_value(alu_dest_vcc_value),
      .alu_dest_exec_value(alu_dest_exec_value),
      .dest_buffer_wr_en(valu_done),
      .dest_buffer_shift_en(valu_done),
      .vgpr_dest_data(queue_vgpr_dest_data),
      .sgpr_dest_data(queue_sgpr_dest_data),
      .exec_wr_vcc_value(queue_exec_wr_vcc_value),
      .vgpr_wr_mask(queue_vgpr_wr_mask),
      .clk(clk),
      .rst(rst)
      );

   PS_flops_EX_WB_alu flops_EX_WB
     (
      .in_wfid(ex_wfid),
      .in_instr_pc(ex_instr_pc),
      .in_vgpr_dest_addr(ex_vgpr_dest_addr[9:0]),
      .in_sgpr_dest_addr(ex_sgpr_dest_addr[8:0]),
      .in_instr_done(ex_instr_done),
      .in_vgpr_wr_en(ex_vgpr_wr_en),
      .in_sgpr_wr_en(ex_sgpr_wr_en),
      .in_vcc_wr_en(ex_vcc_wr_en),
      .out_wfid(queue_vgpr_instr_done_wfid),
      .out_instr_pc(queue_tracemon_retire_pc),
      .out_vgpr_dest_addr(queue_vgpr_dest_addr),
      .out_sgpr_dest_addr(queue_sgpr_dest_addr),
      .out_instr_done(queue_vgpr_instr_done),
      .out_vgpr_dest_wr_en(queue_vgpr_wr_en),
      .out_sgpr_dest_wr_en(queue_sgpr_wr_en),
      .out_vcc_wr_en(queue_exec_wr_vcc_en),
      .clk(clk),
      .rst(rst)
      );

   alu_wb_queue wb_queue
     (
      .in_rfa_queue_entry_serviced(rfa_queue_entry_serviced),
      .in_vgpr_dest_data(queue_vgpr_dest_data),
      .in_sgpr_dest_data(queue_sgpr_dest_data),
      .in_exec_wr_vcc_value(queue_exec_wr_vcc_value),
      .in_vgpr_wr_mask(queue_vgpr_wr_mask),
      .in_wfid(queue_vgpr_instr_done_wfid),
      .in_instr_pc(queue_tracemon_retire_pc),
      .in_vgpr_dest_addr(queue_vgpr_dest_addr),
      .in_sgpr_dest_addr(queue_sgpr_dest_addr),
      .in_instr_done(queue_vgpr_instr_done),
      .in_vgpr_dest_wr_en(queue_vgpr_wr_en),
      .in_sgpr_dest_wr_en(queue_sgpr_wr_en),
      .in_vcc_wr_en(queue_exec_wr_vcc_en),
      .out_vgpr_dest_data(vgpr_dest_data),
      .out_sgpr_dest_data(sgpr_wr_data),
      .out_exec_wr_vcc_value(exec_wr_vcc_value),
      .out_vgpr_wr_mask(vgpr_wr_mask),
      .out_wfid(vgpr_instr_done_wfid),
      .out_instr_pc(tracemon_retire_pc),
      .out_vgpr_dest_addr(vgpr_dest_addr),
      .out_sgpr_dest_addr(sgpr_wr_addr),
      .out_instr_done(vgpr_instr_done),
      .out_vgpr_dest_wr_en(vgpr_wr_en),
      .out_sgpr_dest_wr_en(sgpr_wr_en),
      .out_vcc_wr_en(exec_wr_vcc_en),
      .out_queue_ready(queue_ready),
      .out_queue_empty(queue_empty),
      .clk(clk),
      .rst(rst)
      );

endmodule
