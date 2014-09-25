module lsu_tb ();

reg clk;
reg rst;
reg issue_lsu_select, mem_ack;
reg[5:0] issue_wfid;
reg[6:0] mem2lsu_tag;
reg[7:0] issue_imm_value1;
reg[11:0] issue_source_reg1, issue_source_reg2, issue_source_reg3,issue_dest_reg, issue_mem_sgpr;
reg[15:0] issue_imm_value0, issue_opdcode;
reg[31:0] sgpr_source2_data, issue_instr_pc;
reg[63:0] exec_exec_value;
reg[127:0] sgpr_source1_data;
reg[2047:0] vgpr_source1_data, vgpr_source2_data, mem_rd_data;

wire issue_mem_done, issue_ready, mem_rd_en, mem_wr_en, sgpr_dest_wr_en,tracemon_retire_valid;
wire[5:0] issue_mem_done_wfid, exec_rd_wfid;
wire[6:0] lsu2mem_tag;
wire[8:0] sgpr_source1_addr, sgpr_source2_addr, sgpr_dest_addr;
wire[9:0] vgpr_source1_addr, vgpr_source2_addr, vgpr_dest_addr;
wire[31:0] sgpr_dest_data, tracemon_retire_pc;
wire[63:0] mem_wr_mask, vgpr_dest_wr_mask;
wire[2047:0] vgpr_dest_data, mem_addr, mem_wr_data;

lsu lsu(
      .issue_lsu_select(issue_lsu_select),
      .issue_source_reg1(issue_source_reg1),
      .issue_source_reg2(issue_source_reg2),
      .issue_source_reg3(issue_source_reg3),
      .issue_dest_reg(issue_dest_reg),
      .issue_imm_value0(issue_imm_value0),
      .issue_imm_value1(issue_imm_value1),
      .issue_opdcode(issue_opdcode),
      .issue_mem_sgpr(issue_mem_sgpr),
      .issue_wfid(issue_wfid),
      .vgpr_source1_data(vgpr_source1_data),
      .vgpr_source2_data(vgpr_source2_data),
      .mem_rd_data(mem_rd_data),
      .mem2lsu_tag(mem2lsu_tag),
      .mem_ack(mem_ack),
      .sgpr_source1_data(sgpr_source1_data),
      .sgpr_source2_data(sgpr_source2_data),
      .exec_exec_value(exec_exec_value),
      .issue_instr_pc(issue_instr_pc),
      .issue_mem_done_wfid(issue_mem_done_wfid),
      .issue_mem_done(issue_mem_done),
      .issue_ready(issue_ready),
      .vgpr_source1_addr(vgpr_source1_addr),
      .vgpr_source2_addr(vgpr_source2_addr),
      .vgpr_dest_addr(vgpr_dest_addr),
      .vgpr_dest_data(vgpr_dest_data),
      .exec_rd_wfid(exec_rd_wfid),
      .mem_rd_en(mem_rd_en),
      .mem_wr_en(mem_wr_en),
      .mem_addr(mem_addr),
      .mem_wr_data(mem_wr_data),
      .lsu2mem_tag(lsu2mem_tag),
      .mem_wr_mask(mem_wr_mask),
      .sgpr_source1_addr(sgpr_source1_addr),
      .sgpr_source2_addr(sgpr_source2_addr),
      .sgpr_dest_addr(sgpr_dest_addr),
      .sgpr_dest_data(sgpr_dest_data),
      .sgpr_dest_wr_en(sgpr_dest_wr_en),
      .vgpr_dest_wr_mask(vgpr_dest_wr_mask),
      .tracemon_retire_valid(tracemon_retire_valid),
      .tracemon_retire_pc(tracemon_retire_pc),
      .clk(clk),
      .rst(rst)
 );

 initial 
begin
 clk = 0;
 #1 rst = 1;
 #200 rst = 0;
 
end

initial begin   
  while (1) begin
     #50;
     clk = ~clk;
  end
end
 
initial 
 begin
    issue_lsu_select           = 1'b0;
    mem_ack                    = 1'b0;
    issue_mem_sgpr             = 12'd0;
	issue_wfid                 = 6'd0;
    mem2lsu_tag                = 7'd0;
    issue_imm_value1           = 8'd0;
    issue_source_reg1          = 12'd0;
	issue_source_reg2          = 12'd0;
	issue_source_reg3          = 12'd0;
	issue_dest_reg             = 12'd0;
    issue_imm_value0           = 16'd0;
	issue_opdcode              = 16'd0;
    sgpr_source2_data          = 32'd0;
	issue_instr_pc             = 32'd0;
    exec_exec_value            = 64'd0;
    sgpr_source1_data          = 128'd0;
    vgpr_source1_data          = 2048'd0;
	vgpr_source2_data          = 2048'd0;
	mem_rd_data                = 2048'd0;
 end
 
 initial 
 begin
  #220;
    issue_lsu_select           = 1'b1;
    mem_ack                    = 1'b0;
    issue_mem_sgpr             = 12'd4;
	issue_wfid                 = 6'd2;
    mem2lsu_tag                = 7'd0;
    issue_imm_value1           = 8'd12;
    issue_source_reg1          = 12'd4;
	issue_source_reg2          = 12'd8;
	issue_source_reg3          = 12'd32;
	issue_dest_reg             = {1'b1,1'b1,10'd16};   // SMRD 
    issue_imm_value0           = 16'd8;
	issue_opdcode              = 16'd296;
    sgpr_source2_data          = 32'd0;
	issue_instr_pc             = 32'd60;
    exec_exec_value            = 64'd0;
    sgpr_source1_data          = 128'd0;
    vgpr_source1_data          = 2048'd0;
	vgpr_source2_data          = 2048'd0;
	mem_rd_data                = 2048'd0;
 end
 
 initial begin
   #270;
    issue_lsu_select           = 1'b0;  
 end
 
 initial 
 begin
  #500;
    issue_lsu_select           = 1'b1;
    mem_ack                    = 1'b0;
    issue_mem_sgpr             = 12'd4;
	issue_wfid                 = 6'd3;
    mem2lsu_tag                = 7'd0;
    issue_imm_value1           = 8'd12;
    issue_source_reg1          = 12'h804;
	issue_source_reg2          = 12'd8;
	issue_source_reg3          = 12'd32;
	issue_dest_reg             = {1'b1,1'b0,10'd20};   // MTBUFF load
    issue_imm_value0           = 16'd28;
	issue_opdcode              = 16'd537;
    sgpr_source2_data          = 32'd98;
	issue_instr_pc             = 32'd64;
    exec_exec_value            = 64'h8888888888444444;
    sgpr_source1_data          = 128'd234;
    vgpr_source1_data          = 2048'd1234;
	vgpr_source2_data          = 2048'd98765;
	mem_rd_data                = 2048'd0;
 end
 
 initial 
 begin
  #600;
    issue_lsu_select           = 1'b1;
    mem_ack                    = 1'b0;
    issue_mem_sgpr             = 12'd4;
	issue_wfid                 = 6'd4;
    mem2lsu_tag                = 7'd0;
    issue_imm_value1           = 8'd12;
    issue_source_reg1          = 12'd5;
	issue_source_reg2          = 12'd9;
	issue_source_reg3          = 12'd34;
	issue_dest_reg             = {1'b1,1'b0,10'd20};   // MTBUFF store
    issue_imm_value0           = 16'd28;
	issue_opdcode              = 16'd540;
    sgpr_source2_data          = 32'd98;
	issue_instr_pc             = 32'd128;
    exec_exec_value            = 64'h8888888888444444;
    sgpr_source1_data          = 128'd234;
    vgpr_source1_data          = 2048'd1234;
	vgpr_source2_data          = 2048'd98765;
	mem_rd_data                = 2048'd0;
 end
 
 initial begin 
 #670;
     issue_lsu_select           = 1'b0;  
 end
 
 initial 
 begin
  #1200;
    issue_lsu_select           = 1'b0;
    mem_ack                    = 1'b1;
    issue_mem_sgpr             = 12'd0;
	issue_wfid                 = 6'd0;
    mem2lsu_tag                = 7'd66;
    issue_imm_value1           = 8'd0;
    issue_source_reg1          = 12'd0;
	issue_source_reg2          = 12'd0;
	issue_source_reg3          = 12'd0;
	issue_dest_reg             = {1'b1,1'b0,10'd0};   
    issue_imm_value0           = 16'd0;
	issue_opdcode              = 16'd0;
    sgpr_source2_data          = 32'd0;
	issue_instr_pc             = 32'd0;
    exec_exec_value            = 64'd0;
    sgpr_source1_data          = 128'd0;
    vgpr_source1_data          = 2048'd0;
	vgpr_source2_data          = 2048'd0;
	mem_rd_data                = 2048'd888;
 end
 
 initial
 begin
  #900;
    issue_lsu_select           = 1'b0;
    mem_ack                    = 1'b1;
    issue_mem_sgpr             = 12'd0;
	issue_wfid                 = 6'd0;
    mem2lsu_tag                = 7'd67;
    issue_imm_value1           = 8'd0;
    issue_source_reg1          = 12'd0;
	issue_source_reg2          = 12'd0;
	issue_source_reg3          = 12'd0;
	issue_dest_reg             = {1'b1,1'b0,10'd0};   
    issue_imm_value0           = 16'd0;
	issue_opdcode              = 16'd0;
    sgpr_source2_data          = 32'd0;
	issue_instr_pc             = 32'd0;
    exec_exec_value            = 64'd0;
    sgpr_source1_data          = 128'd0;
    vgpr_source1_data          = 2048'd0;
	vgpr_source2_data          = 2048'd0;
	mem_rd_data                = 2048'd222;
 end
 
 initial
  begin
  #1000;
    issue_lsu_select           = 1'b0;
    mem_ack                    = 1'b1;
    issue_mem_sgpr             = 12'd0;
	issue_wfid                 = 6'd0;
    mem2lsu_tag                = 7'd4;
    issue_imm_value1           = 8'd0;
    issue_source_reg1          = 12'd0;
	issue_source_reg2          = 12'd0;
	issue_source_reg3          = 12'd0;
	issue_dest_reg             = {1'b1,1'b0,10'd0};   
    issue_imm_value0           = 16'd0;
	issue_opdcode              = 16'd0;
    sgpr_source2_data          = 32'd0;
	issue_instr_pc             = 32'd0;
    exec_exec_value            = 64'd0;
    sgpr_source1_data          = 128'd0;
    vgpr_source1_data          = 2048'd0;
	vgpr_source2_data          = 2048'd0;
	mem_rd_data                = 2048'd333;
 end
 
 initial begin
 #1070;
     mem_ack                    = 1'b0;
 end
 
 initial begin
 #1270;
     mem_ack                    = 1'b0;
 end
 
 initial 
 begin 
 #1500;
 $finish;
 end
 
 
always@(mem_rd_en or mem_wr_en or sgpr_dest_wr_en or vgpr_dest_wr_mask)
begin
     $display("TIME: %g clk: %d  rst: %d  mem_rd_en: %d  mem_wr_en: %d  sgpr_dest_wr_en: %d vgpr_dest_wr_mask: %d  lsu2mem_tag: %d mem_wr_mask: %d", $time,clk,rst,mem_rd_en,mem_wr_en,sgpr_dest_wr_en,vgpr_dest_wr_mask,lsu2mem_tag,mem_wr_mask);
end
 
endmodule









