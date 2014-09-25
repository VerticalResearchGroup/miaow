module wr_port_40x64b_8_to_1 (
   select,

   port0_wr_en,
   port0_wr_addr,
   port0_wr_data,

   port1_wr_en,
   port1_wr_addr,
   port1_wr_data,

   port2_wr_en,
   port2_wr_addr,
   port2_wr_data,

   port3_wr_en,
   port3_wr_addr,
   port3_wr_data,

   port4_wr_en,
   port4_wr_addr,
   port4_wr_data,

   port5_wr_en,
   port5_wr_addr,
   port5_wr_data,

   port6_wr_en,
   port6_wr_addr,
   port6_wr_data,

   port7_wr_en,
   port7_wr_addr,
   port7_wr_data,

   muxed_port_wr_en,
   muxed_port_wr_addr,
   muxed_port_wr_data
);

   output muxed_port_wr_en;
   output [5:0] muxed_port_wr_addr;
   output [63:0] muxed_port_wr_data;

   input [7:0] select;

   input port0_wr_en;
   input [5:0] port0_wr_addr;
   input [63:0] port0_wr_data;

   input port1_wr_en;
   input [5:0] port1_wr_addr;
   input [63:0] port1_wr_data;

   input port2_wr_en;
   input [5:0] port2_wr_addr;
   input [63:0] port2_wr_data;

   input port3_wr_en;
   input [5:0] port3_wr_addr;
   input [63:0] port3_wr_data;

   input port4_wr_en;
   input [5:0] port4_wr_addr;
   input [63:0] port4_wr_data;

   input port5_wr_en;
   input [5:0] port5_wr_addr;
   input [63:0] port5_wr_data;

   input port6_wr_en;
   input [5:0] port6_wr_addr;
   input [63:0] port6_wr_data;

   input port7_wr_en;
   input [5:0] port7_wr_addr;
   input [63:0] port7_wr_data;

   reg muxed_port_wr_en;
   reg [5:0] muxed_port_wr_addr;
   reg [63:0] muxed_port_wr_data;

   always @ ( select or
      port0_wr_en or port1_wr_en or port2_wr_en or port3_wr_en or port4_wr_en or
      port5_wr_en or port6_wr_en or port7_wr_en or
      port0_wr_addr or port1_wr_addr or port2_wr_addr or port3_wr_addr or
      port4_wr_addr or port5_wr_addr or port6_wr_addr or port7_wr_addr or
      port0_wr_data or port1_wr_data or port2_wr_data or port3_wr_data or
      port4_wr_data or port5_wr_data or port6_wr_data or port7_wr_data)
    begin
       casex(select)
         8'b00000001:
           begin
             muxed_port_wr_en <= port0_wr_en;
             muxed_port_wr_addr <= port0_wr_addr;
             muxed_port_wr_data <= port0_wr_data;
           end
         8'b00000010:
           begin
             muxed_port_wr_en <= port1_wr_en;
             muxed_port_wr_addr <= port1_wr_addr;
             muxed_port_wr_data <= port1_wr_data;
           end
         8'b00000100:
           begin
             muxed_port_wr_en <= port2_wr_en;
             muxed_port_wr_addr <= port2_wr_addr;
             muxed_port_wr_data <= port2_wr_data;
           end
         8'b00001000:
           begin
             muxed_port_wr_en <= port3_wr_en;
             muxed_port_wr_addr <= port3_wr_addr;
             muxed_port_wr_data <= port3_wr_data;
           end
         8'b00010000:
           begin
             muxed_port_wr_en <= port4_wr_en;
             muxed_port_wr_addr <= port4_wr_addr;
             muxed_port_wr_data <= port4_wr_data;
           end
         8'b00100000:
           begin
             muxed_port_wr_en <= port5_wr_en;
             muxed_port_wr_addr <= port5_wr_addr;
             muxed_port_wr_data <= port5_wr_data;
           end
         8'b01000000:
           begin
             muxed_port_wr_en <= port6_wr_en;
             muxed_port_wr_addr <= port6_wr_addr;
             muxed_port_wr_data <= port6_wr_data;
           end
         8'b10000000:
           begin
             muxed_port_wr_en <= port7_wr_en;
             muxed_port_wr_addr <= port7_wr_addr;
             muxed_port_wr_data <= port7_wr_data;
           end
         8'b00000000:
           begin
             muxed_port_wr_en <= 1'b0;
             muxed_port_wr_addr <= {6{1'bx}};
             muxed_port_wr_data <= {64{1'bx}};
           end
         default:
           begin
             muxed_port_wr_en <= 1'b0;
             muxed_port_wr_addr <= {6{1'bx}};
             muxed_port_wr_data <= {64{1'bx}};
           end
       endcase
  end

endmodule
