module sgpr_3to1_rd_port_mux (
  port0_rd_en,
  port0_rd_addr,

  port1_rd_en,
  port1_rd_addr,

  port2_rd_en,
  port2_rd_addr,

  port_rd_data,

  rd_addr,
  rd_data
);

  input         port0_rd_en;
  input [8:0]   port0_rd_addr;

  input         port1_rd_en;
  input [8:0]   port1_rd_addr;

  input         port2_rd_en;
  input [8:0]   port2_rd_addr;

  input [127:0] rd_data;
  output [127:0] port_rd_data;
  output [8:0]  rd_addr;

  reg [8:0]     rd_addr;

  assign port_rd_data = rd_data;

  always @ (
    port0_rd_en or
    port1_rd_en or
    port2_rd_en or
    port0_rd_addr or
    port1_rd_addr or
    port2_rd_addr
  ) begin
      casex({port2_rd_en,port1_rd_en,port0_rd_en})
        3'b001:
          begin
            rd_addr <= port0_rd_addr;
          end
        3'b010:
          begin
            rd_addr <= port1_rd_addr;
          end
        3'b100:
          begin
            rd_addr <= port2_rd_addr;
          end
        default:
          begin
            rd_addr <= {9{1'bx}};
          end
      endcase
    end

endmodule
