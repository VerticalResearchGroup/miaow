module fpga_memory
(
  // input
  // LSU
  mem_wr_en, mem_rd_en,
  mem_addr, mem_wr_data, mem_tag_req,
  
  // MB
  mb_data_in, mb_data_we, mb_ack, mb_done,
  
  clk, rst,
  // output
  // LSU
  mem_tag_resp, mem_rd_data, mem_ack,
  
  // MB
  mb_op, mb_data_out, mb_addr
);

input clk;
input rst;

input mem_wr_en;
input mem_rd_en;
input [31:0] mem_addr;
input [31:0] mem_wr_data;
input [6:0] mem_tag_req;

input [31:0] mb_data_in;
input mb_data_we;
input mb_ack;
input mb_done;

output [31:0] mem_rd_data;
output [6:0] mem_tag_resp;
output mem_ack;

output [3:0] mb_op;
output [31:0] mb_data_out;
output [31:0] mb_addr;

reg [31:0] mem_addr_reg;
//reg [31:0] mem_wr_en;
reg [31:0] mb_data_out_reg;
reg[6:0] mem_tag_req_reg;

reg[3:0] mem_state;
reg[3:0] mem_state_next;

reg [31:0] mb_data_in_reg;
reg mem_ack_reg;
reg mb_ack_reg;
reg mb_done_reg;

`define MEM_IDLE 4'b0000
`define MEM_WR_ACK_WAIT 4'b0001
`define MEM_WR_RDY_WAIT 4'b0010
`define MEM_WR_LSU_TO 4'b0011
`define MEM_RD_ACK_WAIT 4'b0100
`define MEM_RD_RDY_WAIT 4'b0101
`define MEM_RD_LSU_TO 4'b0110

assign mem_tag_resp = mem_tag_req_reg;
assign mem_rd_data = mb_data_in_reg;
assign mem_ack = mem_ack_reg;

assign mb_data_out = mb_data_out_reg;
assign mb_addr = mem_addr_reg;
assign mb_op = mem_state;

always@(posedge clk) begin
  if(rst) begin
    mem_state <= `MEM_IDLE;
    mb_data_out_reg <= 32'd0;
    mem_addr_reg <= 32'd0;
    mem_tag_req_reg <= 7'd0;
    mb_data_in_reg <= 32'd0;
    mb_ack_reg <= 1'b0;
    mb_done_reg <= 1'b0;
  end
  else begin
    mb_ack_reg <= mb_ack;
    mb_done_reg <= mb_done;
    mem_state <= mem_state_next;
    
    mb_data_out_reg <= mb_data_out_reg;
    if(mem_wr_en) begin
      mb_data_out_reg <= mem_wr_data;
    end
    
    mem_addr_reg <= mem_addr_reg;
    mem_tag_req_reg <= mem_tag_req_reg;
    if(mem_wr_en | mem_rd_en) begin
      mem_addr_reg <= mem_addr;
      mem_tag_req_reg <= mem_tag_req;
    end
    
    mb_data_in_reg <= mb_data_in_reg;
    if(mb_data_we) begin
      mb_data_in_reg <= mb_data_in;
    end
  end
end

always@(*) begin
  mem_state_next <= mem_state;
  mem_ack_reg <= 1'b0;
  case(mem_state)
    `MEM_IDLE: begin
      if(mem_wr_en) begin
        mem_state_next <= `MEM_WR_ACK_WAIT;
      end
      else if(mem_rd_en) begin
        mem_state_next <= `MEM_RD_ACK_WAIT;
      end
    end
    `MEM_WR_ACK_WAIT: begin
      if(~mb_ack_reg & mb_ack) begin
        mem_state_next <= `MEM_WR_RDY_WAIT;
      end
    end
    `MEM_WR_RDY_WAIT: begin
      if(~mb_done_reg & mb_done) begin
        mem_state_next <= `MEM_WR_LSU_TO;
      end
    end
    `MEM_WR_LSU_TO: begin
      mem_ack_reg <= 1'b1;
      mem_state_next <= `MEM_IDLE;
    end
    `MEM_RD_ACK_WAIT: begin
      if(~mb_ack_reg & mb_ack) begin
        mem_state_next <= `MEM_RD_RDY_WAIT;
      end
    end
    `MEM_RD_RDY_WAIT: begin
      if(~mb_done_reg & mb_done) begin
        mem_state_next <= `MEM_RD_LSU_TO;
      end
    end
    `MEM_RD_LSU_TO: begin
      mem_ack_reg <= 1'b1;
      mem_state_next <= `MEM_IDLE;
    end
    default: mem_state_next <= mem_state;
  endcase
end

endmodule