module wr_port_mux_9to1 
  (/*AUTOARG*/
   // Outputs
   muxed_port_wr_en, muxed_port_wr_mask, muxed_port_wr_addr,
   muxed_port_wr_data,
   // Inputs
   wr_port_select, port0_wr_en, port0_wr_mask, port0_wr_addr,
   port0_wr_data, port1_wr_en, port1_wr_mask, port1_wr_addr,
   port1_wr_data, port2_wr_en, port2_wr_mask, port2_wr_addr,
   port2_wr_data, port3_wr_en, port3_wr_mask, port3_wr_addr,
   port3_wr_data, port4_wr_en, port4_wr_mask, port4_wr_addr,
   port4_wr_data, port5_wr_en, port5_wr_mask, port5_wr_addr,
   port5_wr_data, port6_wr_en, port6_wr_mask, port6_wr_addr,
   port6_wr_data, port7_wr_en, port7_wr_mask, port7_wr_addr,
   port7_wr_data, port8_wr_en, port8_wr_mask, port8_wr_addr,
   port8_wr_data
   );

  output[3:0] muxed_port_wr_en;
  output [63:0] muxed_port_wr_mask;
  output [9:0] muxed_port_wr_addr;

  // change output port width
  output [2047:0] muxed_port_wr_data;

  input [15:0] wr_port_select;

  input[3:0] port0_wr_en;
  input [63:0] port0_wr_mask;
  input [9:0] port0_wr_addr;
  input [2047:0] port0_wr_data;

  input[3:0] port1_wr_en;
  input [63:0] port1_wr_mask;
  input [9:0] port1_wr_addr;
  input [2047:0] port1_wr_data;

  input[3:0] port2_wr_en;
  input [63:0] port2_wr_mask;
  input [9:0] port2_wr_addr;
  input [2047:0] port2_wr_data;

  input[3:0] port3_wr_en;
  input [63:0] port3_wr_mask;
  input [9:0] port3_wr_addr;
  input [2047:0] port3_wr_data;

  input[3:0] port4_wr_en;
  input [63:0] port4_wr_mask;
  input [9:0] port4_wr_addr;
  input [2047:0] port4_wr_data;

  input[3:0] port5_wr_en;
  input [63:0] port5_wr_mask;
  input [9:0] port5_wr_addr;
  input [2047:0] port5_wr_data;

  input[3:0] port6_wr_en;
  input [63:0] port6_wr_mask;
  input [9:0] port6_wr_addr;
  input [2047:0] port6_wr_data;

  input[3:0] port7_wr_en;
  input [63:0] port7_wr_mask;
  input [9:0] port7_wr_addr;
  input [2047:0] port7_wr_data;

  input[3:0] port8_wr_en;
  input [63:0] port8_wr_mask;
  input [9:0] port8_wr_addr;

  // S: change output width
  input [2047:0] port8_wr_data;
  /* 
  wire [2047:0] port0_wr_data_i, port1_wr_data_i, port2_wr_data_i,
		port3_wr_data_i, port4_wr_data_i, port5_wr_data_i,
		port6_wr_data_i, port7_wr_data_i;
   
   assign port0_wr_data_i =
   */
   /*
   genvar 	i;
   generate
      for (i = 0; i<64; i=i+1) begin
	 assign port0_wr_data_i[i*32+:32] = {port0_wr_data[i*32+:32]};
	 assign port1_wr_data_i[i*32+:32] = {port1_wr_data[i*32+:32]};
	 assign port2_wr_data_i[i*32+:32] = {port2_wr_data[i*32+:32]};
	 assign port3_wr_data_i[i*32+:32] = {port3_wr_data[i*32+:32]};
	 assign port4_wr_data_i[i*128+:128] = {port4_wr_data[i*32+:32]};
	 assign port5_wr_data_i[i*128+:128] = {port5_wr_data[i*32+:32]};
	 assign port6_wr_data_i[i*128+:128] = {port6_wr_data[i*32+:32]};
	 assign port7_wr_data_i[i*128+:128] = {port7_wr_data[i*32+:32]};
      end
      
   endgenerate
   */

  reg [3:0] muxed_port_wr_en;
  reg [63:0] muxed_port_wr_mask;
  reg [9:0] muxed_port_wr_addr;
  reg [2047:0] muxed_port_wr_data;

  always @ (*) begin
    casex(wr_port_select)
      16'h0001:
        begin
          muxed_port_wr_en <= port0_wr_en;
          muxed_port_wr_mask <= port0_wr_mask;
          muxed_port_wr_addr <= port0_wr_addr;
          muxed_port_wr_data <= port0_wr_data;
        end
      16'h0002:
        begin
          muxed_port_wr_en <= port1_wr_en;
          muxed_port_wr_mask <= port1_wr_mask;
          muxed_port_wr_addr <= port1_wr_addr;
          muxed_port_wr_data <= port1_wr_data;
        end
      16'h0004:
        begin
          muxed_port_wr_en <= port2_wr_en;
          muxed_port_wr_mask <= port2_wr_mask;
          muxed_port_wr_addr <= port2_wr_addr;
          muxed_port_wr_data <= port2_wr_data;
        end
      16'h0008:
        begin
          muxed_port_wr_en <= port3_wr_en;
          muxed_port_wr_mask <= port3_wr_mask;
          muxed_port_wr_addr <= port3_wr_addr;
          muxed_port_wr_data <= port3_wr_data;
        end
      16'h0010:
        begin
          muxed_port_wr_en <= port4_wr_en;
          muxed_port_wr_mask <= port4_wr_mask;
          muxed_port_wr_addr <= port4_wr_addr;
          muxed_port_wr_data <= port4_wr_data;
        end
      16'h0020:
        begin
          muxed_port_wr_en <= port5_wr_en;
          muxed_port_wr_mask <= port5_wr_mask;
          muxed_port_wr_addr <= port5_wr_addr;
          muxed_port_wr_data <= port5_wr_data;
        end
      16'h0040:
        begin
          muxed_port_wr_en <= port6_wr_en;
          muxed_port_wr_mask <= port6_wr_mask;
          muxed_port_wr_addr <= port6_wr_addr;
          muxed_port_wr_data <= port6_wr_data;
        end
      16'h0080:
        begin
          muxed_port_wr_en <= port7_wr_en;
          muxed_port_wr_mask <= port7_wr_mask;
          muxed_port_wr_addr <= port7_wr_addr;
          muxed_port_wr_data <= port7_wr_data;
        end
      16'h0100:
        begin
          muxed_port_wr_en <= port8_wr_en;
          muxed_port_wr_mask <= port8_wr_mask;
          muxed_port_wr_addr <= port8_wr_addr;
          muxed_port_wr_data <= port8_wr_data;
        end
      16'b0000:
        begin
          muxed_port_wr_en <= 4'd0;
          muxed_port_wr_mask <= 64'b0;
          muxed_port_wr_addr <= {10{1'bx}};
          // S: change from 8k to 2k
          muxed_port_wr_data <= {2048{1'bx}};
        end
      default:
        begin
          muxed_port_wr_en <= 4'd0;
          muxed_port_wr_mask <= {64{1'b0}};
          muxed_port_wr_addr <= {10{1'bx}};
          // S: change from 8k to 2k
          muxed_port_wr_data <= {2048{1'bx}};
        end
    endcase
  end

endmodule
