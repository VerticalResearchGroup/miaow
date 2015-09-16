module sgpr_simxlsu_wr_port_mux 
  (/*AUTOARG*/
   // Outputs
   muxed_port_wr_en, muxed_port_wr_addr, muxed_port_wr_data,
   muxed_port_wr_mask,
   // Inputs

   //**CHANGE [PSP]
   //**add ports 9 for SALU integration
   wr_port_select, port0_wr_en, port0_wr_addr, port0_wr_data,
   port0_wr_mask, port1_wr_en, port1_wr_addr, port1_wr_data,
   port1_wr_mask, port2_wr_en, port2_wr_addr, port2_wr_data,
   port2_wr_mask, port3_wr_en, port3_wr_addr, port3_wr_data,
   port3_wr_mask, port4_wr_en, port4_wr_addr, port4_wr_data,
   port4_wr_mask, port5_wr_en, port5_wr_addr, port5_wr_data,
   port5_wr_mask, port6_wr_en, port6_wr_addr, port6_wr_data,
   port6_wr_mask, port7_wr_en, port7_wr_addr, port7_wr_data,
   port7_wr_mask, port8_wr_en, port8_wr_addr, port8_wr_data,
   port8_wr_mask, port9_wr_en, port9_wr_addr, port9_wr_data,
   port9_wr_mask
   //**
   );

  output [3:0] muxed_port_wr_en;
  output [8:0] muxed_port_wr_addr;
  output [127:0] muxed_port_wr_data;
  output [127:0] muxed_port_wr_mask;

  input [15:0] wr_port_select;

  input[3:0] port0_wr_en;
  input [8:0] port0_wr_addr;
  input [127:0] port0_wr_data;
  input [127:0] port0_wr_mask;
  
  input [3:0] port1_wr_en;
  input [8:0] port1_wr_addr;
  input [127:0] port1_wr_data;
  input [127:0] port1_wr_mask;
  
  input [3:0] port2_wr_en;
  input [8:0] port2_wr_addr;
  input [127:0] port2_wr_data;
  input [127:0] port2_wr_mask;
  
  input [3:0] port3_wr_en;
  input [8:0] port3_wr_addr;
  input [127:0] port3_wr_data;
  input [127:0] port3_wr_mask;

  input [3:0] port4_wr_en;
  input [8:0] port4_wr_addr;
  input [127:0] port4_wr_data;
  input [127:0] port4_wr_mask;
  
  input [3:0] port5_wr_en;
  input [8:0] port5_wr_addr;
  input [127:0] port5_wr_data;
  input [127:0] port5_wr_mask;
  
  input [3:0] port6_wr_en;
  input [8:0] port6_wr_addr;
  input [127:0] port6_wr_data;
  input [127:0] port6_wr_mask;
  
  input [3:0] port7_wr_en;
  input [8:0] port7_wr_addr;
  input [127:0] port7_wr_data;
  input [127:0] port7_wr_mask;

  input [3:0] port8_wr_en;
  input [8:0] port8_wr_addr;
  input [127:0] port8_wr_data;
  input [127:0] port8_wr_mask;
   
  reg [3:0] muxed_port_wr_en;
  reg [8:0] muxed_port_wr_addr;
  reg [127:0] muxed_port_wr_data;
  reg [127:0] muxed_port_wr_mask;

  //**CHANGE [PSP]
  //** add extra SALU port
  input [3:0] port9_wr_en;
  input [8:0] port9_wr_addr;
  input [127:0] port9_wr_data;
  input [127:0] port9_wr_mask;
  //**

  always @ (
    wr_port_select or
    port0_wr_en or
    port0_wr_addr or
    port0_wr_data or
    port0_wr_mask or
    port1_wr_en or
    port1_wr_addr or
    port1_wr_data or
    port1_wr_mask or
    port2_wr_en or
    port2_wr_addr or
    port2_wr_data or
    port2_wr_mask or
    port3_wr_en or
    port3_wr_addr or
    port3_wr_data or
    port3_wr_mask or
    port4_wr_en or
    port4_wr_addr or
    port4_wr_data or
    port4_wr_mask or
    port5_wr_en or
    port5_wr_addr or
    port5_wr_data or
    port5_wr_mask or
    port6_wr_en or
    port6_wr_addr or
    port6_wr_data or
    port6_wr_mask or
    port7_wr_en or
    port7_wr_addr or
    port7_wr_data or
    port7_wr_mask or
    port8_wr_en or
    port8_wr_addr or
    port8_wr_data or
    port8_wr_mask or

    //**CHANGE
    port9_wr_en or
    port9_wr_addr or
    port9_wr_data or
    port9_wr_mask 
    //**
	    
  ) begin
    casex(wr_port_select)
      16'h0001:
        begin
          muxed_port_wr_en <= port0_wr_en;
          muxed_port_wr_addr <= port0_wr_addr;
          muxed_port_wr_data <= port0_wr_data;
          muxed_port_wr_mask <= port0_wr_mask;
        end
      16'h0002:
        begin
          muxed_port_wr_en <= port1_wr_en;
          muxed_port_wr_addr <= port1_wr_addr;
          muxed_port_wr_data <= port1_wr_data;
          muxed_port_wr_mask <= port1_wr_mask;
        end
      16'h0004:
        begin
          muxed_port_wr_en <= port2_wr_en;
          muxed_port_wr_addr <= port2_wr_addr;
          muxed_port_wr_data <= port2_wr_data;
          muxed_port_wr_mask <= port2_wr_mask;
        end
      16'h0008:
        begin
          muxed_port_wr_en <= port3_wr_en;
          muxed_port_wr_addr <= port3_wr_addr;
          muxed_port_wr_data <= port3_wr_data;
          muxed_port_wr_mask <= port3_wr_mask;
        end
      16'h0010:
        begin
          muxed_port_wr_en <= port4_wr_en;
          muxed_port_wr_addr <= port4_wr_addr;
          muxed_port_wr_data <= port4_wr_data;
          muxed_port_wr_mask <= port4_wr_mask;
        end
      16'h0020:
        begin
          muxed_port_wr_en <= port5_wr_en;
          muxed_port_wr_addr <= port5_wr_addr;
          muxed_port_wr_data <= port5_wr_data;
          muxed_port_wr_mask <= port5_wr_mask;
        end
      16'h0040:
        begin
          muxed_port_wr_en <= port6_wr_en;
          muxed_port_wr_addr <= port6_wr_addr;
          muxed_port_wr_data <= port6_wr_data;
          muxed_port_wr_mask <= port6_wr_mask;
        end
      16'h0080:
        begin
          muxed_port_wr_en <= port7_wr_en;
          muxed_port_wr_addr <= port7_wr_addr;
          muxed_port_wr_data <= port7_wr_data;
          muxed_port_wr_mask <= port7_wr_mask;
        end
      16'h0100:
        begin
          muxed_port_wr_en <= port8_wr_en;
          muxed_port_wr_addr <= port8_wr_addr;
          muxed_port_wr_data <= port8_wr_data;
          muxed_port_wr_mask <= port8_wr_mask;
        end


      //**CHANGE [PSP]
      //**actual port assigning for SALU
      16'h0200:
        begin
          muxed_port_wr_en <= port9_wr_en;
          muxed_port_wr_addr <= port9_wr_addr;
          muxed_port_wr_data <= port9_wr_data;
          muxed_port_wr_mask <= port9_wr_mask;
        end
      //**


      16'b0000:
        begin
          muxed_port_wr_en <= 1'b0;
          muxed_port_wr_addr <= {9{1'bx}};
          muxed_port_wr_data <= {64{1'bx}};
          muxed_port_wr_mask <= {64{1'bx}};
        end
      default:
        begin
          muxed_port_wr_en <= 1'bx;
          muxed_port_wr_addr <= {9{1'bx}};
          muxed_port_wr_data <= {64{1'bx}};
          muxed_port_wr_mask <= {64{1'bx}};
        end
    endcase
  end

endmodule

