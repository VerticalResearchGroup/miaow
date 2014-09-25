module rd_port_mux_8to1 (
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

  rd_data,

  muxed_port_rd_addr,
  muxed_port_rd_en,
  muxed_port_rd_data
);

  output [2047:0] rd_data;

  output [9:0] muxed_port_rd_addr;
  output muxed_port_rd_en;

  input port0_rd_en;
  input port1_rd_en;
  input port2_rd_en;
  input port3_rd_en;
  input port4_rd_en;
  input port5_rd_en;
  input port6_rd_en;
  input port7_rd_en;

  input [9:0] port0_rd_addr;
  input [9:0] port1_rd_addr;
  input [9:0] port2_rd_addr;
  input [9:0] port3_rd_addr;
  input [9:0] port4_rd_addr;
  input [9:0] port5_rd_addr;
  input [9:0] port6_rd_addr;
  input [9:0] port7_rd_addr;

  input [2047:0] muxed_port_rd_data;

  reg [2047:0] port0_rd_data;
  reg [2047:0] port1_rd_data;
  reg [2047:0] port2_rd_data;
  reg [2047:0] port3_rd_data;
  reg [2047:0] port4_rd_data;
  reg [2047:0] port5_rd_data;
  reg [2047:0] port6_rd_data;
  reg [2047:0] port7_rd_data;
  reg [9:0] muxed_port_rd_addr;
  reg muxed_port_rd_en;

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
          muxed_port_rd_addr <= port0_rd_addr;
          muxed_port_rd_en <= 1'b1;
        end
      8'b0000_0010:
        begin
          muxed_port_rd_addr <= port1_rd_addr;
          muxed_port_rd_en <= 1'b1;
        end
      8'b0000_0100:
        begin
          muxed_port_rd_addr <= port2_rd_addr;
          muxed_port_rd_en <= 1'b1;
        end
      8'b0000_1000:
        begin
          muxed_port_rd_addr <= port3_rd_addr;
          muxed_port_rd_en <= 1'b1;
        end
      8'b0001_0000:
        begin
          muxed_port_rd_addr <= port4_rd_addr;
          muxed_port_rd_en <= 1'b1;
        end
      8'b0010_0000:
        begin
          muxed_port_rd_addr <= port5_rd_addr;
          muxed_port_rd_en <= 1'b1;
        end
      8'b0100_0000:
        begin
          muxed_port_rd_addr <= port6_rd_addr;
          muxed_port_rd_en <= 1'b1;
        end
      8'b1000_0000:
        begin
          muxed_port_rd_addr <= port7_rd_addr;
          muxed_port_rd_en <= 1'b1;
        end
      8'b0000_0000:
        begin
          muxed_port_rd_addr <= {10{1'bx}};
          muxed_port_rd_en <= 1'b0;
        end
      default:
        begin
          muxed_port_rd_addr <= {10{1'bx}};
          muxed_port_rd_en <= 1'bx;
        end
    endcase
  end

  assign rd_data = muxed_port_rd_data;

endmodule
