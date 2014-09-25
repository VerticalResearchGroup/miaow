module sgpr_simx_rd_port_mux (
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
  
  port_rd_data,

  rd_addr,
  rd_en,
  rd_data
);

  input         port0_rd_en;
  input [8:0]   port0_rd_addr;
  input         port1_rd_en;
  input [8:0]   port1_rd_addr;
  input         port2_rd_en;
  input [8:0]   port2_rd_addr;
  input         port3_rd_en;
  input [8:0]   port3_rd_addr;
  input         port4_rd_en;
  input [8:0]   port4_rd_addr;
  input         port5_rd_en;
  input [8:0]   port5_rd_addr;
  input         port6_rd_en;
  input [8:0]   port6_rd_addr;
  input         port7_rd_en;
  input [8:0]   port7_rd_addr;
  
  input [31:0]  rd_data;
  
  output [31:0] port_rd_data;
  output [8:0]  rd_addr;
  output rd_en;

  reg [8:0]     rd_addr;
  reg rd_en;

  assign port_rd_data = rd_data;
  
  always @ (
    port0_rd_en or
    port1_rd_en or
    port2_rd_en or
    port3_rd_en or
    port4_rd_en or
    port5_rd_en or
    port6_rd_en or
    port7_rd_en or
    port0_rd_addr or
    port1_rd_addr or
    port2_rd_addr or
    port3_rd_addr or
    port4_rd_addr or
    port5_rd_addr or
    port6_rd_addr or
    port7_rd_addr
  ) begin
    casex({port7_rd_en,port6_rd_en,port5_rd_en,port4_rd_en,port3_rd_en,port2_rd_en,port1_rd_en,port0_rd_en})
      8'b0000_0001:
        begin
          rd_addr <= port0_rd_addr;
          rd_en <= 1'b1;
        end
      8'b0000_0010:
        begin
          rd_addr <= port1_rd_addr;
          rd_en <= 1'b1;
        end
      8'b0000_0100:
        begin
          rd_addr <= port2_rd_addr;
          rd_en <= 1'b1;
        end
      8'b0000_1000:
        begin
          rd_addr <= port3_rd_addr;
          rd_en <= 1'b1;
        end
      8'b0001_0000:
        begin
          rd_addr <= port4_rd_addr;
          rd_en <= 1'b1;
        end
      8'b0010_0000:
        begin
          rd_addr <= port5_rd_addr;
          rd_en <= 1'b1;
        end
      8'b0100_0000:
        begin
          rd_addr <= port6_rd_addr;
          rd_en <= 1'b1;
        end
      8'b1000_0000:
        begin
          rd_addr <= port7_rd_addr;
          rd_en <= 1'b1;
        end
      8'b0000_0000:
        begin
          rd_addr <= {9{1'bx}};
          rd_en <= 1'b0;
        end
      default:
        begin
          rd_addr <= {9{1'bx}};
          rd_en <= 1'bx;
        end
    endcase
  end

endmodule
