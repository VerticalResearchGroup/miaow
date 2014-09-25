module busy_gpr_table
  (/*AUTOARG*/
   // Outputs
   decode_dest_reg1_busy_bits, decode_source_reg1_busy_bits,
   decode_source_reg4_busy_bits, decode_source_reg2_busy_bits,
   decode_source_reg3_busy_bits, decode_dest_reg2_busy_bits,
   // Inputs
   clk, rst, alu_valid, lsu_valid, f_decode_source_reg2,
   f_decode_source_reg3, f_decode_dest_reg2, f_decode_dest_reg1,
   f_decode_source_reg1, f_decode_source_reg4, alu_dest_reg1,
   lsu_dest_reg, lsu_dest_reg_size, alu_dest_reg1_size, alu_dest_reg2,
   alu_dest_reg2_size, f_vgpr_alu_dest_reg_addr, f_vgpr_lsu_dest_reg_addr,
   f_vgpr_lsu_dest_reg_valid, f_vgpr_alu_dest_reg_valid,
   f_sgpr_valu_dest_addr, f_sgpr_alu_dest_reg_addr,
   f_sgpr_lsu_dest_reg_addr, f_sgpr_lsu_dest_reg_valid,
   f_sgpr_alu_dest_reg_valid, f_sgpr_valu_dest_reg_valid
   );
   

   /**
    * Busy bit is set when dst1 and dst2 are issued, cleared when 
    * register retires
    ***/
   input clk,rst;
   
   input alu_valid, lsu_valid;

   input [`OPERAND_LENGTH_2WORD-1:0] f_decode_source_reg2, f_decode_source_reg3, f_decode_dest_reg2;
   
   input [`OPERAND_LENGTH_4WORD-1:0] f_decode_dest_reg1, f_decode_source_reg1, f_decode_source_reg4;
   
   input [11:0] alu_dest_reg1, lsu_dest_reg;
   input [1:0] 	lsu_dest_reg_size;
   input 	alu_dest_reg1_size;
   
   wire [3:0] 	lsu_dest_reg_sgpr_valid, lsu_dest_reg_vgpr_valid;

   wire [1:0] 	alu_dest_reg1_sgpr_valid, alu_dest_reg1_vgpr_valid;
   
   input [11:0] alu_dest_reg2;
   input 	alu_dest_reg2_size;
   
   wire [1:0] 			    alu_dest_reg2_sgpr_valid;
   
   input [`VGPR_ADDR_LENGTH-1:0]    f_vgpr_alu_dest_reg_addr, f_vgpr_lsu_dest_reg_addr;
   input [3:0] 			    f_vgpr_lsu_dest_reg_valid;
   input 			    f_vgpr_alu_dest_reg_valid;
   
   input [`SGPR_ADDR_LENGTH-1:0]    f_sgpr_valu_dest_addr, f_sgpr_alu_dest_reg_addr, 
				     f_sgpr_lsu_dest_reg_addr;
   input [3:0] 			     f_sgpr_lsu_dest_reg_valid;
   input [1:0] 			     f_sgpr_alu_dest_reg_valid;
   input 			     f_sgpr_valu_dest_reg_valid;
   
   output [3:0] 		    decode_dest_reg1_busy_bits, decode_source_reg1_busy_bits, decode_source_reg4_busy_bits;
		    
   output [1:0] 		    decode_source_reg2_busy_bits, decode_source_reg3_busy_bits, decode_dest_reg2_busy_bits;

   wire [3:0] 			    decode_dest_reg1_mask, decode_source_reg1_mask, decode_source_reg4_mask;
   wire [1:0] 			    decode_source_reg2_mask, decode_source_reg3_mask, decode_dest_reg2_mask;
 			    
   wire [3:0] 		    decode_dest_reg1_busy_bits_vgpr, decode_source_reg1_busy_bits_vgpr, decode_dest_reg1_busy_bits_sgpr, decode_source_reg1_busy_bits_sgpr, decode_source_reg4_busy_bits_sgpr;
		    
   wire [1:0] 		    decode_source_reg2_busy_bits_vgpr, decode_source_reg3_busy_bits_vgpr, decode_source_reg2_busy_bits_sgpr, decode_source_reg3_busy_bits_sgpr, decode_dest_reg2_busy_bits_sgpr;

   wire [`NUMBER_SGPR-1:0] 	    sgpr_busy_bits, next_sgpr_busy_bits;
   
   wire [`NUMBER_SGPR-1:0] 	    alu_dest_reg1_sgpr_set_decoded, alu_dest_reg2_sgpr_set_decoded, lsu_dest_reg_sgpr_set_decoded;
   wire [`NUMBER_SGPR-1:0] 	    sgpr_alu_dest_clear_decoded, sgpr_lsu_dest_clear_decoded, sgpr_valu_dest_clear_decoded;

   wire [`NUMBER_VGPR-1:0] 	    vgpr_busy_bits, next_vgpr_busy_bits;
  	    
   wire [`NUMBER_VGPR-1:0] 	    alu_dest_reg1_vgpr_set_decoded, lsu_dest_reg_vgpr_set_decoded;
   
   wire [`NUMBER_VGPR-1:0] 	    vgpr_alu_dest_clear_decoded, vgpr_lsu_dest_clear_decoded;
   // Decoder for the dsts value to set the busy table
   // 1024 - dest1 alu - 2, dest1 lsu - 4
   // 512 - dest1 alu - 1(2wide), dest1 lsu - 1(4wide), dest2 alu 1(2wide)
   vgpr_busy_table_decoder #(2) alu_dst1_vgpr_set_decoder
     (
      .vgpr_addr(alu_dest_reg1[`VGPR_ADDR_LENGTH-1:0]),
      .vgpr_valid(alu_dest_reg1_vgpr_valid),
      .output_decoded(alu_dest_reg1_vgpr_set_decoded)
      );
   
   vgpr_busy_table_decoder #(4) lsu_dst1_set_decoder
     (
      .vgpr_addr(lsu_dest_reg[`VGPR_ADDR_LENGTH-1:0]),
      .vgpr_valid(lsu_dest_reg_vgpr_valid),
      .output_decoded(lsu_dest_reg_vgpr_set_decoded)
      );

   sgpr_busy_table_decoder #(4) lsu_dst1_sgpr_set_decoder
     (
      .sgpr_addr(lsu_dest_reg[`SGPR_ADDR_LENGTH-1:0]),
      .sgpr_valid(lsu_dest_reg_sgpr_valid),
      .output_decoded(lsu_dest_reg_sgpr_set_decoded)
      );

   sgpr_busy_table_decoder #(2) alu_dst1_sgpr_set_decoder
     (
      .sgpr_addr(alu_dest_reg1[`SGPR_ADDR_LENGTH-1:0]),
      .sgpr_valid(alu_dest_reg1_sgpr_valid),
      .output_decoded(alu_dest_reg1_sgpr_set_decoded)
      );

   sgpr_busy_table_decoder #(2) alu_dst2_sgpr_set_decoder
     (
      .sgpr_addr(alu_dest_reg2[`SGPR_ADDR_LENGTH-1:0]),
      .sgpr_valid(alu_dest_reg2_sgpr_valid),
      .output_decoded(alu_dest_reg2_sgpr_set_decoded)
      );

   
   // Decoders for the retired values to clear the busy table
   // 1024 - vgpr_alu - 2, vgpr_lsu - 4
   // 512 -sgpr_alu - 1(2 wide), sgpr_lsu 1(4wide)
   vgpr_busy_table_decoder #(2) vgpr_alu_dst_clear_decoder
     (
      .vgpr_addr(f_vgpr_alu_dest_reg_addr),
      .vgpr_valid({1'b0,f_vgpr_alu_dest_reg_valid}),
      .output_decoded(vgpr_alu_dest_clear_decoded)
      );

   vgpr_busy_table_decoder #(4) vgpr_lsu_dst_clear_decoder
     (
      .vgpr_addr(f_vgpr_lsu_dest_reg_addr),
      .vgpr_valid(f_vgpr_lsu_dest_reg_valid),
      .output_decoded(vgpr_lsu_dest_clear_decoded)
      );

   sgpr_busy_table_decoder #(2) sgpr_alu_dst_clear_decoder
     (
      .sgpr_addr(f_sgpr_alu_dest_reg_addr),
      .sgpr_valid(f_sgpr_alu_dest_reg_valid),
      .output_decoded(sgpr_alu_dest_clear_decoded)
      );

   sgpr_busy_table_decoder #(2) sgpr_valu_dst_clear_decoder
     (
      .sgpr_addr(f_sgpr_valu_dest_addr),
      .sgpr_valid({f_sgpr_valu_dest_reg_valid, f_sgpr_valu_dest_reg_valid}),
      .output_decoded(sgpr_valu_dest_clear_decoded)
      );

   sgpr_busy_table_decoder #(4) sgpr_lsu_dst_clear_decoder
     (
      .sgpr_addr(f_sgpr_lsu_dest_reg_addr),
      .sgpr_valid(f_sgpr_lsu_dest_reg_valid),
      .output_decoded(sgpr_lsu_dest_clear_decoded)
      );

   
   // Muxes for the read ports
   // 1024- 4 to dst1 and src1  2 to src2 and src3
   // 1(4wide) dst1 src1 and src4, 1(2wide) dest2, src2 and src3
   vgpr_busy_table_mux #(4) decode_dest_reg1_rd_port_vgpr
     (
      .in(vgpr_busy_bits),
      .select(f_decode_dest_reg1[`VGPR_ADDR_LENGTH-1:0]),
      .out(decode_dest_reg1_busy_bits_vgpr)
      );

    vgpr_busy_table_mux #(4) decode_source_reg1_rd_port_vgpr
     (
      .in(vgpr_busy_bits),
      .select(f_decode_source_reg1[`VGPR_ADDR_LENGTH-1:0]),
      .out(decode_source_reg1_busy_bits_vgpr)
      );
   vgpr_busy_table_mux #(2) decode_source_reg2_rd_port_vgpr
     (
      .in(vgpr_busy_bits),
      .select(f_decode_source_reg2[`VGPR_ADDR_LENGTH-1:0]),
      .out(decode_source_reg2_busy_bits_vgpr)
      );
   vgpr_busy_table_mux #(2) decode_source_reg3_rd_port_vgpr
     (
      .in(vgpr_busy_bits),
      .select(f_decode_source_reg3[`VGPR_ADDR_LENGTH-1:0]),
      .out(decode_source_reg3_busy_bits_vgpr)
      );

   

   sgpr_busy_table_mux #(4) decode_dest_reg1_rd_port_sgpr
     (
      .in(sgpr_busy_bits),
      .select(f_decode_dest_reg1[`SGPR_ADDR_LENGTH-1:0]),
      .out(decode_dest_reg1_busy_bits_sgpr)
      );

   sgpr_busy_table_mux #(2) decode_dest_reg2_rd_port_sgpr
     (
      .in(sgpr_busy_bits),
      .select(f_decode_dest_reg2[`SGPR_ADDR_LENGTH-1:0]),
      .out(decode_dest_reg2_busy_bits_sgpr)
      );

    sgpr_busy_table_mux #(4) decode_source_reg1_rd_port_sgpr
     (
      .in(sgpr_busy_bits),
      .select(f_decode_source_reg1[`SGPR_ADDR_LENGTH-1:0]),
      .out(decode_source_reg1_busy_bits_sgpr)
      );
   sgpr_busy_table_mux #(2) decode_source_reg2_rd_port_sgpr
     (
      .in(sgpr_busy_bits),
      .select(f_decode_source_reg2[`SGPR_ADDR_LENGTH-1:0]),
      .out(decode_source_reg2_busy_bits_sgpr)
      );
   sgpr_busy_table_mux #(2) decode_source_reg3_rd_port_sgpr
     (
      .in(sgpr_busy_bits),
      .select(f_decode_source_reg3[`SGPR_ADDR_LENGTH-1:0]),
      .out(decode_source_reg3_busy_bits_sgpr)
      );
   sgpr_busy_table_mux #(4) decode_source_reg4_rd_port_sgpr
     (
      .in(sgpr_busy_bits),
      .select(f_decode_source_reg4[`SGPR_ADDR_LENGTH-1:0]),
      .out(decode_source_reg4_busy_bits_sgpr)
      );

   
   // 1024 reg for vgpr
   dff vgpr_busy_bit_reg[`NUMBER_VGPR-1:0]
     (
      .q(vgpr_busy_bits),
      .d(next_vgpr_busy_bits),
      .clk(clk),
      .rst(rst)
      );


   // 512 reg for sgpr
   dff sgpr_busy_bit_reg[`NUMBER_SGPR-1:0]
     (
      .q(sgpr_busy_bits),
      .d(next_sgpr_busy_bits),
      .clk(clk),
      .rst(rst)
      );
   // Generate next inputs for the busy bits tables
   assign next_vgpr_busy_bits 
     = vgpr_busy_bits & 
       (~vgpr_alu_dest_clear_decoded & ~vgpr_lsu_dest_clear_decoded) |
       (alu_dest_reg1_vgpr_set_decoded | lsu_dest_reg_vgpr_set_decoded);
   
   assign next_sgpr_busy_bits
     = sgpr_busy_bits & 
       (~sgpr_valu_dest_clear_decoded & ~sgpr_alu_dest_clear_decoded & ~sgpr_lsu_dest_clear_decoded) |
       (   lsu_dest_reg_sgpr_set_decoded | 
	   alu_dest_reg1_sgpr_set_decoded | alu_dest_reg2_sgpr_set_decoded   );
   
   // Generate the valid bits for write ports
   assign alu_dest_reg1_vgpr_valid 
     = alu_valid && (alu_dest_reg1[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_VGPR_L] == `ISSUE_VALID_VGPR_ID)?
       ( (alu_dest_reg1_size)? 2'b11 : 2'b01  ) :
       2'b00;

   assign lsu_dest_reg_vgpr_valid 
     = lsu_valid && (lsu_dest_reg[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_VGPR_L] == `ISSUE_VALID_VGPR_ID)?
       (  (lsu_dest_reg_size[1])? 4'b1111 :
	  (lsu_dest_reg_size[0])? 4'b0011 : 4'b0001  ) :
       4'b0000;

   assign alu_dest_reg1_sgpr_valid 
     = alu_valid && (alu_dest_reg1[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_SGPR_L] == `ISSUE_VALID_SGPR_ID)?
       (  (alu_dest_reg1_size)? 2'b11 : 2'b01  ) :
       2'b00;

   assign alu_dest_reg2_sgpr_valid 
     = alu_valid && (alu_dest_reg2[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_SGPR_L] == `ISSUE_VALID_SGPR_ID)?
       (  (alu_dest_reg2_size)? 2'b11 : 2'b01  ) :
       2'b00;

   assign lsu_dest_reg_sgpr_valid 
     = lsu_valid && (lsu_dest_reg[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_SGPR_L] == `ISSUE_VALID_SGPR_ID)?
       (  (lsu_dest_reg_size[1])? 4'b1111 :
	  (lsu_dest_reg_size[0])? 4'b0011 : 4'b0001  ) :
       4'b0000;

   

   
				 
   // Select only valid values for read ports
   assign decode_dest_reg1_mask = (f_decode_dest_reg1[`ISSUE_OP_4WORD_BIT])? 4'b1111 :
				  (f_decode_dest_reg1[`ISSUE_OP_2WORD_BIT])? 4'b0011 :
				  4'b0001;
   
   assign decode_source_reg1_mask = (f_decode_source_reg1[`ISSUE_OP_4WORD_BIT])? 4'b1111 :
				    (f_decode_source_reg1[`ISSUE_OP_2WORD_BIT])? 4'b0011 :
				    4'b0001;
   assign decode_source_reg4_mask = (f_decode_source_reg4[`ISSUE_OP_4WORD_BIT])? 4'b1111 :
				    (f_decode_source_reg4[`ISSUE_OP_2WORD_BIT])? 4'b0011 :
				    4'b0001;
   assign decode_source_reg2_mask = (f_decode_source_reg2[`ISSUE_OP_2WORD_BIT])? 2'b11 :
				    2'b01;
   assign decode_source_reg3_mask = (f_decode_source_reg3[`ISSUE_OP_2WORD_BIT])? 2'b11 :
				    2'b01;
   assign decode_dest_reg2_mask = (f_decode_dest_reg2[`ISSUE_OP_2WORD_BIT])? 2'b11 :
				  2'b01;

   assign decode_dest_reg1_busy_bits
     = (f_decode_dest_reg1[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_VGPR_L] == `ISSUE_VALID_VGPR_ID)? decode_dest_reg1_busy_bits_vgpr & decode_dest_reg1_mask :
       (f_decode_dest_reg1[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_SGPR_L] == `ISSUE_VALID_SGPR_ID)? decode_dest_reg1_busy_bits_sgpr & decode_dest_reg1_mask :
       4'b0000;

   assign decode_dest_reg2_busy_bits
     = (f_decode_dest_reg2[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_SGPR_L] == `ISSUE_VALID_SGPR_ID)? decode_dest_reg2_busy_bits_sgpr & decode_dest_reg2_mask:
       2'b00;

   assign decode_source_reg1_busy_bits
     = (f_decode_source_reg1[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_VGPR_L] == `ISSUE_VALID_VGPR_ID)? decode_source_reg1_busy_bits_vgpr & decode_source_reg1_mask :
       (f_decode_source_reg1[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_SGPR_L] == `ISSUE_VALID_SGPR_ID)? decode_source_reg1_busy_bits_sgpr & decode_source_reg1_mask:
       4'b0000;

   assign decode_source_reg2_busy_bits
     = (f_decode_source_reg2[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_VGPR_L] == `ISSUE_VALID_VGPR_ID)? decode_source_reg2_busy_bits_vgpr & decode_source_reg2_mask:
       (f_decode_source_reg2[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_SGPR_L] == `ISSUE_VALID_SGPR_ID)? decode_source_reg2_busy_bits_sgpr & decode_source_reg2_mask:
       2'b00;

   assign decode_source_reg3_busy_bits
     = (f_decode_source_reg3[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_VGPR_L] == `ISSUE_VALID_VGPR_ID)? decode_source_reg3_busy_bits_vgpr & decode_source_reg3_mask:
       (f_decode_source_reg3[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_SGPR_L] == `ISSUE_VALID_SGPR_ID)? decode_source_reg3_busy_bits_sgpr & decode_source_reg3_mask:
       2'b00;

   assign decode_source_reg4_busy_bits
     = (f_decode_source_reg4[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_SGPR_L] == `ISSUE_VALID_SGPR_ID)? decode_source_reg4_busy_bits_sgpr & decode_source_reg4_mask:
       4'b0000;

   
endmodule
