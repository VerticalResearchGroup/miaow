module fetch_tb();

reg      dispatch2cu_wf_dispatch;
reg      [14:0]dispatch2cu_wf_tag_dispatch;
reg      [31:0]dispatch2cu_start_pc_dispatch;
reg      [9:0]dispatch2cu_vgpr_base_dispatch;
reg      [8:0]dispatch2cu_sgpr_base_dispatch;
reg      [15:0]dispatch2cu_lds_base_dispatch;
reg      [5:0]dispatch2cu_wf_size_dispatch;
reg      [3:0]dispatch2cu_wg_wf_count;
reg      buff_ack;
reg      [39:0]wave_stop_fetch;
reg      issue_wf_done_en;
reg      [5:0]issue_wf_done_wf_id;
reg      [5:0]issue_wg_wfid;
reg      [5:0]salu_branch_wfid;
reg      salu_branch_en;
reg      salu_branch_taken;
reg      [31:0]salu_branch_pc_value;
reg      clk;
reg      rst;

wire     [14:0]cu2dispatch_wf_tag_done;
wire     cu2dispatch_wf_done;
wire     [31:0]buff_addr;
wire     [38:0]buff_tag;
wire     buff_rd_en;
wire     [5:0]wave_reserve_slotid;
wire     wave_reserve_valid;
wire     wave_basereg_wr;
wire     [5:0]wave_basereg_wfid;
wire     [9:0]wave_vgpr_base;
wire     [8:0]wave_sgpr_base;
wire     [15:0]wave_lds_base;
wire     [63:0]exec_init_value;
wire     [5:0]exec_init_wf_id;
wire     [5:0]issue_wg_wgid;
wire     [3:0]issue_wg_wf_count;
wire     exec_init_wf_en;

fetch fetch_test(
      .dispatch2cu_wf_dispatch(dispatch2cu_wf_dispatch),
      .dispatch2cu_wf_tag_dispatch(dispatch2cu_wf_tag_dispatch),
      .dispatch2cu_start_pc_dispatch(dispatch2cu_start_pc_dispatch),
      .dispatch2cu_vgpr_base_dispatch(dispatch2cu_vgpr_base_dispatch),
      .dispatch2cu_sgpr_base_dispatch(dispatch2cu_sgpr_base_dispatch),
      .dispatch2cu_lds_base_dispatch(dispatch2cu_lds_base_dispatch),
      .dispatch2cu_wf_size_dispatch(dispatch2cu_wf_size_dispatch),
      .dispatch2cu_wg_wf_count(dispatch2cu_wg_wf_count),
      .buff_ack(buff_ack),
      .wave_stop_fetch(wave_stop_fetch),
      .issue_wf_done_en(issue_wf_done_en),
      .issue_wf_done_wf_id(issue_wf_done_wf_id),
      .issue_wg_wfid(issue_wg_wfid),
      .salu_branch_wfid(salu_branch_wfid),
      .salu_branch_en(salu_branch_en),
      .salu_branch_taken(salu_branch_taken),
      .salu_branch_pc_value(salu_branch_pc_value),
      .cu2dispatch_wf_tag_done(cu2dispatch_wf_tag_done),
      .cu2dispatch_wf_done(cu2dispatch_wf_done),
      .buff_addr(buff_addr),
      .buff_tag(buff_tag),
      .buff_rd_en(buff_rd_en),
      .wave_reserve_slotid(wave_reserve_slotid),
      .wave_reserve_valid(wave_reserve_valid),
      .wave_basereg_wr(wave_basereg_wr),
      .wave_basereg_wfid(wave_basereg_wfid),
      .wave_vgpr_base(wave_vgpr_base),
      .wave_sgpr_base(wave_sgpr_base),
      .wave_lds_base(wave_lds_base),
	    .exec_init_value(exec_init_value),
      .exec_init_wf_id(exec_init_wf_id),
      .exec_init_wf_en(exec_init_wf_en),
      .issue_wg_wgid(issue_wg_wgid),
      .issue_wg_wf_count(issue_wg_wf_count),
      .clk(clk),
      .rst(rst)
 );

initial 
begin
 clk = 0;
 #1 rst = 1;
 #10 rst = 0;
 
end

initial begin   
  while (1) begin
     #3;
     clk = ~clk;
  end
end

initial
begin
      dispatch2cu_wf_dispatch        = 1'b0;
      dispatch2cu_wf_tag_dispatch    = 15'dx;
      dispatch2cu_start_pc_dispatch  = 32'dx;
      dispatch2cu_vgpr_base_dispatch = 10'dx;
      dispatch2cu_sgpr_base_dispatch = 9'dx;
      dispatch2cu_lds_base_dispatch  = 16'dx;
      dispatch2cu_wf_size_dispatch   = 6'dx;
      dispatch2cu_wg_wf_count        = 4'dx;
      buff_ack                       = 1'b0;
      wave_stop_fetch                = 40'd0;
      issue_wf_done_en               = 1'b0;
      issue_wf_done_wf_id            = 6'd0;
      salu_branch_wfid               = 6'dx;
      salu_branch_en                 = 1'b0;
      salu_branch_taken              = 1'b0;
      salu_branch_pc_value           = 32'bx;
      issue_wg_wfid                  = 6'dx;
  
  #20;
      dispatch2cu_wf_dispatch        = 1'b1;
      dispatch2cu_wf_tag_dispatch    = 15'd0;
      dispatch2cu_start_pc_dispatch  = 32'd0;
      dispatch2cu_vgpr_base_dispatch = 10'd0;
      dispatch2cu_sgpr_base_dispatch = 9'd0;
      dispatch2cu_lds_base_dispatch  = 16'd0;
      dispatch2cu_wf_size_dispatch   = 6'd0;
      dispatch2cu_wg_wf_count        = 4'd3;
      buff_ack                       = 1'b0;
      wave_stop_fetch                = 40'd0;
      issue_wf_done_en               = 1'b0;
      issue_wf_done_wf_id            = 6'd0;

  
  #6;
      dispatch2cu_wf_dispatch        = 1'b0;

  #6;
      issue_wg_wfid                  = 1'b0;

  #15;
      dispatch2cu_wf_dispatch        = 1'b1;
      dispatch2cu_wf_tag_dispatch    = 15'd5;
      dispatch2cu_start_pc_dispatch  = 32'd18;
      dispatch2cu_vgpr_base_dispatch = 10'd9;
      dispatch2cu_sgpr_base_dispatch = 9'd10;
      dispatch2cu_lds_base_dispatch  = 16'd20;
      dispatch2cu_wf_size_dispatch   = 6'd6;
      dispatch2cu_wg_wf_count        = 4'd7;
      buff_ack                       = 1'b0;
      wave_stop_fetch                = 40'd0;
      issue_wf_done_en               = 1'b0;
      issue_wf_done_wf_id            = 6'd0;

  #6;
      dispatch2cu_wf_dispatch        = 1'b0;

  #6;
      issue_wg_wfid                  = 1'b1;

  #6;
      salu_branch_en                 = 1'b0;
      salu_branch_taken              = 1'b1;
      salu_branch_wfid               = 6'd0;
      salu_branch_pc_value           = 32'h20;

  #6;
      salu_branch_en                 = 1'b1;
      salu_branch_taken              = 1'b1;
      salu_branch_wfid               = 6'd0;
      salu_branch_pc_value           = 32'h30;

  #6;
      salu_branch_en                 = 1'b0;
      salu_branch_taken              = 1'b0;

  #24;
      issue_wf_done_en               = 1'b1;
      issue_wf_done_wf_id            = 6'd0;

  #6;
      issue_wf_done_en               = 1'b0;

  #12;
      issue_wf_done_en               = 1'b1;
      issue_wf_done_wf_id            = 6'd1;

  #6;
      issue_wf_done_en               = 1'b0;

  #30;
      $finish;
end

always@(posedge clk) begin
   $display("TIME: %g clk: %d  rst: %d  base_wr: %d  wfid: %d  vgpr_base: %d sgpr_base: %d  lds_base: %d PC: %d buff_tag: %h issue_wg_wf_count: %d issue_wf_done_wf_id: %d issue_wf_done_en: %d new_vacant=%h \n", 
   $time, clk, rst, wave_basereg_wr, wave_basereg_wfid, wave_vgpr_base, wave_sgpr_base, wave_lds_base, buff_addr, buff_tag, issue_wg_wf_count, issue_wf_done_wf_id, issue_wf_done_en, fetch_test.wfgen.vmg.new_vacant);
end

endmodule
