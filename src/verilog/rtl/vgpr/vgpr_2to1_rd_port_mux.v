module vgpr_2to1_rd_port_mux (
  port0_rd_en,
  port0_rd_addr,

  port1_rd_en,
  port1_rd_addr,

  port_rd_data,

  rd_addr,
  rd_data
);
// S: changed to 2k (parameter passed)
  parameter DATAWIDTH = 2048;

  input         port0_rd_en;
  input [9:0]   port0_rd_addr;

  input         port1_rd_en;
  input [9:0]   port1_rd_addr;

  input [DATAWIDTH-1:0] rd_data;
  output [DATAWIDTH-1:0] port_rd_data;
  output [9:0]  rd_addr;

  reg [9:0]     rd_addr;

  assign port_rd_data = rd_data;

  always @ (
    port0_rd_en or
    port1_rd_en or
    port0_rd_addr or
    port1_rd_addr
  ) begin
      casex({port1_rd_en,port0_rd_en})
        2'b01:
          begin
            rd_addr <= port0_rd_addr;
          end
        2'b10:
          begin
            rd_addr <= port1_rd_addr;
          end
        default:
          begin
            rd_addr <= {10{1'bx}};
          end
      endcase
    end

endmodule
