module rd_port_9_to_1 (
  port0_rd_en,
  port0_rd_addr,

  port1_rd_en,
  port1_rd_addr,

  port2_rd_en,
  port2_rd_addr,

  port3_rd_en,
  port3_rd_addr,

  port4_rd_en,
  port4_rd_addr,

  port5_rd_en,
  port5_rd_addr,

  port6_rd_en,
  port6_rd_addr,

  port7_rd_en,
  port7_rd_addr,

  port8_rd_en,
  port8_rd_addr,

  rd_addr
);

  parameter WIDTH = 1;

  input               port0_rd_en;
  input [WIDTH - 1:0] port0_rd_addr;
  input               port1_rd_en;
  input [WIDTH - 1:0] port1_rd_addr;
  input               port2_rd_en;
  input [WIDTH - 1:0] port2_rd_addr;
  input               port3_rd_en;
  input [WIDTH - 1:0] port3_rd_addr;
  input               port4_rd_en;
  input [WIDTH - 1:0] port4_rd_addr;
  input               port5_rd_en;
  input [WIDTH - 1:0] port5_rd_addr;
  input               port6_rd_en;
  input [WIDTH - 1:0] port6_rd_addr;
  input               port7_rd_en;
  input [WIDTH - 1:0] port7_rd_addr;
  input               port8_rd_en;
  input [WIDTH - 1:0] port8_rd_addr;

  output [WIDTH - 1:0]  rd_addr;

  reg [WIDTH - 1:0]     rd_addr;

   always @ (
      port0_rd_en or port1_rd_en or port2_rd_en or port3_rd_en or port4_rd_en or
      port5_rd_en or port6_rd_en or port7_rd_en or port8_rd_en or
      port0_rd_addr or port1_rd_addr or port2_rd_addr or port3_rd_addr or
      port4_rd_addr or port5_rd_addr or port6_rd_addr or port7_rd_addr or port8_rd_addr)
   begin
      casex({port8_rd_en, port7_rd_en, port6_rd_en, port5_rd_en, port4_rd_en,
            port3_rd_en, port2_rd_en, port1_rd_en, port0_rd_en})
         9'b000000001: rd_addr <= port0_rd_addr;
         9'b000000010: rd_addr <= port1_rd_addr;
         9'b000000100: rd_addr <= port2_rd_addr;
         9'b000001000: rd_addr <= port3_rd_addr;
         9'b000010000: rd_addr <= port4_rd_addr;
         9'b000100000: rd_addr <= port5_rd_addr;
         9'b001000000: rd_addr <= port6_rd_addr;
         9'b010000000: rd_addr <= port7_rd_addr;
         9'b100000000: rd_addr <= port8_rd_addr;
         default: rd_addr <= 6'bxxxxxx;
      endcase
   end

endmodule
