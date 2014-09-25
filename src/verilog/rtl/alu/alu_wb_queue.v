module alu_wb_queue(
                  in_rfa_queue_entry_serviced,
                  in_vgpr_dest_data,
                  in_sgpr_dest_data,
                  in_exec_wr_vcc_value,
                  in_vgpr_wr_mask,
                  in_wfid,
                  in_instr_pc,
                  in_vgpr_dest_addr,
                  in_sgpr_dest_addr,
                  in_instr_done,
                  in_vgpr_dest_wr_en,
                  in_sgpr_dest_wr_en,
                  in_vcc_wr_en,
                  out_vgpr_dest_data,
                  out_sgpr_dest_data,
                  out_exec_wr_vcc_value,
                  out_vgpr_wr_mask,
                  out_wfid,
                  out_instr_pc,
                  out_vgpr_dest_addr,
                  out_sgpr_dest_addr,
                  out_instr_done,
                  out_vgpr_dest_wr_en,
                  out_sgpr_dest_wr_en,
                  out_vcc_wr_en,
                  out_queue_ready,
                  out_queue_empty,
                  clk,
                  rst
                  );

   parameter BITS = 2;
   parameter SIZE = 4;

   input in_rfa_queue_entry_serviced;

   input [2047:0] in_vgpr_dest_data;
   input [63:0] in_sgpr_dest_data;
   input [63:0]   in_exec_wr_vcc_value;
   input [63:0]   in_vgpr_wr_mask;
   input [5:0] in_wfid;
   input [31:0] in_instr_pc;
   input [9:0] in_vgpr_dest_addr;
   input [8:0] in_sgpr_dest_addr;
   input in_instr_done;
   input in_vgpr_dest_wr_en;
   input in_sgpr_dest_wr_en;
   input in_vcc_wr_en;

   output [2047:0] out_vgpr_dest_data;
   output [63:0]   out_sgpr_dest_data;
   output [63:0]   out_exec_wr_vcc_value;
   output [63:0]   out_vgpr_wr_mask;
   output [5:0] out_wfid;
   output [31:0] out_instr_pc;
   output [9:0] out_vgpr_dest_addr;
   output [8:0] out_sgpr_dest_addr;
   output out_instr_done;
   output out_vgpr_dest_wr_en;
   output out_sgpr_dest_wr_en;
   output out_vcc_wr_en;

   output out_queue_ready;
   output out_queue_empty;

   input clk;
   input rst;

   wire out_queue_writable;
   wire [2300:0] queue_wr_data;
   wire [2300:0] queue_rd_data;

   assign queue_wr_data = {in_vgpr_dest_data, in_sgpr_dest_data, in_exec_wr_vcc_value, in_vgpr_wr_mask, in_wfid, in_instr_pc, in_vgpr_dest_addr, in_sgpr_dest_addr, in_instr_done, in_vgpr_dest_wr_en, in_sgpr_dest_wr_en, in_vcc_wr_en};

   assign {out_vgpr_dest_data, out_sgpr_dest_data, out_exec_wr_vcc_value, out_vgpr_wr_mask, out_wfid, out_instr_pc, out_vgpr_dest_addr, out_sgpr_dest_addr, out_instr_done, out_vgpr_dest_wr_en, out_sgpr_dest_wr_en, out_vcc_wr_en} = queue_rd_data;

   wire [BITS - 1:0] tail;
   wire [BITS - 1:0] head;
   wire [BITS - 1:0] next_tail;
   wire [BITS - 1:0] next_next_tail;
   wire [BITS - 1:0] next_head;
   wire inc_tail;
   wire inc_head;
   wire [31:0] next_tail_dummy;
   wire [31:0] next_next_tail_dummy;
   wire [31:0] next_head_dummy;

   assign next_tail_dummy = tail + 1;
   assign next_next_tail_dummy = tail + 2;
   assign next_head_dummy = head + 1;
   assign next_tail = next_tail_dummy[BITS - 1:0];
   assign next_next_tail = next_next_tail_dummy[BITS - 1:0];
   assign next_head = next_head_dummy[BITS - 1:0];

   assign inc_tail = in_instr_done & out_queue_writable;
   assign inc_head = in_rfa_queue_entry_serviced;

   assign out_queue_writable = (head != next_tail);
   assign out_queue_ready = (head != next_next_tail) & out_queue_writable;
   assign out_queue_empty = (head == tail);

   dff_en Tail[BITS - 1:0] (.q(tail), .d(next_tail), .en(inc_tail), .clk(clk), .rst(rst));
   dff_en Head[BITS - 1:0] (.q(head), .d(next_head), .en(inc_head), .clk(clk), .rst(rst));

   queue_param_1r_1w #(.BITS(BITS), .SIZE(SIZE), .WIDTH(2301)) queue_reg(
     .in_wr_en(inc_tail),
     .in_wr_addr(tail),
     .in_wr_data(queue_wr_data),
     .in_rd_addr(head),
     .out_rd_data(queue_rd_data),
     .clk(clk),
     .rst(rst)
   );

endmodule