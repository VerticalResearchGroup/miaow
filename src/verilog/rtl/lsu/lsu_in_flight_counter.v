module lsu_in_flight_counter(
  in_rd_en,
  in_wr_en,
  in_mem_ack,
  out_lsu_ready,
  clk,
  rst
);

parameter MAX_INFLIGHT_DATA_MEM = 16;
parameter MAX_INFLIGHT_DATA_MEM_LOG2 = 4;

input [3:0] in_rd_en;
input [3:0] in_wr_en;
input in_mem_ack;

output out_lsu_ready;

input clk;
input rst;

wire rd_en;
wire wr_en;

wire [MAX_INFLIGHT_DATA_MEM_LOG2-1:0] in_flight_count;
reg [MAX_INFLIGHT_DATA_MEM_LOG2-1:0] next_count;

assign rd_en = |in_rd_en;
assign wr_en = |in_wr_en;

dff in_flight_store[MAX_INFLIGHT_DATA_MEM_LOG2-1:0](
  .q(in_flight_count),
  .d(next_count),
  .clk(clk),
  .rst(rst)
);

always @(rd_en or wr_en or in_mem_ack or in_flight_count)
begin
  casex({rd_en, wr_en, in_mem_ack})
    3'b000:
      begin
        next_count <= in_flight_count;
      end
    3'b001:
      begin
        next_count <= in_flight_count - 1'b1;
      end
    3'b010:
      begin
        next_count <= in_flight_count + 1'b1;
      end
    3'b011:
      begin
        next_count <= in_flight_count;
      end
    3'b100:
      begin
        next_count <= in_flight_count + 1'b1;
      end
    3'b101:
      begin
        next_count <= in_flight_count;
      end
    default:
      begin
        next_count <= {MAX_INFLIGHT_DATA_MEM_LOG2{1'bx}};
      end
  endcase
end

assign out_lsu_ready = (next_count == MAX_INFLIGHT_DATA_MEM-3) ? 1'b0 : 1'b1;

endmodule
