module alu_controller 
  (/*AUTOARG*/
   // Outputs
   out_alu_ready, out_vcc_wr_en, out_instr_done, out_vgpr_wr_en,
   out_vgpr_dest_addr, out_sgpr_wr_en, out_sgpr_dest_addr,
   out_alu_control, out_alu_start, out_src_buffer_wr_en,
   out_source1_mux_select, out_source2_mux_select,
   out_source3_mux_select, out_source1_src_constant,
   out_source2_src_constant, out_source3_src_constant,
   out_vgpr_source1_rd_en, out_vgpr_source2_rd_en,
   out_vgpr_source3_rd_en, out_sgpr_rd_en, out_exec_rd_en,
   // Inputs
   in_alu_select_flopped, in_alu_select, in_source1_addr,
   in_source2_addr, in_source3_addr, in_dest1_addr, in_dest2_addr,
   in_opcode, in_valu_done, clk, rst
   );

   parameter MODULE = `MODULE_SIMD;

   input in_alu_select_flopped;
   input in_alu_select;
   input [11:0] in_source1_addr;
   input [11:0] in_source2_addr;
   input [11:0] in_source3_addr;
   input [11:0] in_dest1_addr;
   input [11:0] in_dest2_addr;
   input [31:0] in_opcode;
   input 	in_valu_done;

   output 	out_alu_ready;
   output 	out_vcc_wr_en;
   output 	out_instr_done;
   output 	out_vgpr_wr_en;
   output [11:0] out_vgpr_dest_addr;
   output 	 out_sgpr_wr_en;
   output [11:0] out_sgpr_dest_addr;
   output [31:0] out_alu_control;
   output 	 out_alu_start;
   output 	 out_src_buffer_wr_en;
   output [3:0]  out_source1_mux_select;
   output [3:0]  out_source2_mux_select;
   output [3:0]  out_source3_mux_select;
   output [9:0]  out_source1_src_constant;
   output [9:0]  out_source2_src_constant;
   output [9:0]  out_source3_src_constant;
   
   output 	 out_vgpr_source1_rd_en;
   output 	 out_vgpr_source2_rd_en;
   output 	 out_vgpr_source3_rd_en;
   output 	 out_sgpr_rd_en;
   output 	 out_exec_rd_en;

   input 	 clk;
   input 	 rst;


   reg 		 out_vcc_wr_en;
   reg 		 out_instr_done;
   reg 		 out_vgpr_wr_en;
   reg 		 out_sgpr_wr_en;
   reg [31:0] 	 out_alu_control;
   reg 		 out_src_buffer_wr_en;
   wire 	 out_vgpr_source1_rd_en;
   wire 	 out_vgpr_source2_rd_en;
   wire 	 out_vgpr_source3_rd_en;
   wire 	 out_sgpr_rd_en;
   wire 	 out_exec_rd_en;
   reg [11:0] 	 out_vgpr_dest_addr;
   reg [11:0] 	 out_sgpr_dest_addr;
   reg [9:0] 	 out_source1_src_constant;
   reg [9:0] 	 out_source2_src_constant;
   reg [9:0] 	 out_source3_src_constant;
   reg [3:0] 	 out_source1_mux_select;
   reg [3:0] 	 out_source2_mux_select;
   reg [3:0] 	 out_source3_mux_select;

   wire 	 dec_vcc_wr_en;
   wire 	 dec_vgpr_wr_en;
   wire 	 dec_sgpr_wr_en;
   reg 		 dec_vgpr_source1_rd_en;
   reg 		 dec_vgpr_source2_rd_en;
   reg 		 dec_vgpr_source3_rd_en;
   wire 	 dec_sgpr_rd_en;
   wire 	 dec_exec_rd_en;
   reg [3:0] 	 dec_out_source1_mux_select;
   reg [3:0] 	 dec_out_source2_mux_select;
   reg [3:0] 	 dec_out_source3_mux_select;

   wire 	 RD, EX, WB;

   assign dec_sgpr_rd_en = 1'b1;
   assign dec_exec_rd_en = 1'b1;

   always @ (in_source1_addr) begin

      dec_vgpr_source1_rd_en <= 1'b0;
      casex(in_source1_addr)
	12'b0_11111111111 : //literal constant
          begin
             dec_out_source1_mux_select <= 4'b0000;
          end
	12'b0_0_?????????? : //constant value
          begin
             dec_out_source1_mux_select <= 4'b0001;
          end
	12'b1_0_?????????? : //read VGPR
          begin
             dec_out_source1_mux_select <= 4'b0010;
             dec_vgpr_source1_rd_en <= 1'b1;
          end
	12'b1_1_0_????????? : //read value from SGPR
          begin
             dec_out_source1_mux_select <= 4'b0011;
          end
	12'b1_1_1_0_0000_0001 : //read VCC_LO
          begin
             dec_out_source1_mux_select <= 4'b0100;
          end
	12'b1_1_1_0_0000_0010 : //read VCC_HI
          begin
             dec_out_source1_mux_select <= 4'b0101;
          end
	12'b1_1_1_0_0000_0100 : //read M0
          begin
             dec_out_source1_mux_select <= 4'b0110;
          end
	12'b1_1_1_0_0000_1000 : //read EXEC_LO
          begin
             dec_out_source1_mux_select <= 4'b0111;
          end
	12'b1_1_1_0_0001_0000 : //read EXEC_HI
          begin
             dec_out_source1_mux_select <= 4'b1000;
          end
	12'b1_1_1_0_0010_0000 : //read VCCZ
          begin
             dec_out_source1_mux_select <= 4'b1001;
          end
	12'b1_1_1_0_0100_0000 : //read EXECZ
          begin
             dec_out_source1_mux_select <= 4'b1010;
          end
	12'b1_1_1_0_1000_0000 : //read SCC
          begin
             dec_out_source1_mux_select <= 4'b1011;
          end
	default:
          begin
             dec_out_source1_mux_select <= 4'bx;
          end
      endcase
   end

   always @ (in_source2_addr) begin
      
      dec_vgpr_source2_rd_en <= 1'b0;
      casex(in_source2_addr)
	12'b0_11111111111 : //literal constant
          begin
             dec_out_source2_mux_select <= 4'b0000;
          end
	12'b0_0_?????????? : //constant value
          begin
             dec_out_source2_mux_select <= 4'b0001;
          end
	12'b1_0_?????????? : //read VGPR
          begin
             dec_out_source2_mux_select <= 4'b0010;
             dec_vgpr_source2_rd_en <= 1'b1;
          end
	12'b1_1_0_????????? : //read value from SGPR
          begin
             dec_out_source2_mux_select <= 4'b0011;
          end
	12'b1_1_1_0_0000_0001 : //read VCC_LO
          begin
             dec_out_source2_mux_select <= 4'b0100;
          end
	12'b1_1_1_0_0000_0010 : //read VCC_HI
          begin
             dec_out_source2_mux_select <= 4'b0101;
          end
	12'b1_1_1_0_0000_0100 : //read M0
          begin
             dec_out_source2_mux_select <= 4'b0110;
          end
	12'b1_1_1_0_0000_1000 : //read EXEC_LO
          begin
             dec_out_source2_mux_select <= 4'b0111;
          end
	12'b1_1_1_0_0001_0000 : //read EXEC_HI
          begin
             dec_out_source2_mux_select <= 4'b1000;
          end
	12'b1_1_1_0_0010_0000 : //read VCCZ
          begin
             dec_out_source2_mux_select <= 4'b1001;
          end
	12'b1_1_1_0_0100_0000 : //read EXECZ
          begin
             dec_out_source2_mux_select <= 4'b1010;
          end
	12'b1_1_1_0_1000_0000 : //read SCC
          begin
             dec_out_source2_mux_select <= 4'b1011;
          end
	default:
          begin
             dec_out_source2_mux_select <= 4'bx;
          end
      endcase
   end

   always @ (in_source3_addr) begin
      dec_vgpr_source3_rd_en <= 1'b0;
      casex(in_source3_addr)
	12'b0_11111111111 : //literal constant
          begin
             dec_out_source3_mux_select <= 4'b0000;
          end
	12'b0_0_?????????? : //constant value
          begin
             dec_out_source3_mux_select <= 4'b0001;
          end
	12'b1_0_?????????? : //read VGPR
          begin
             dec_out_source3_mux_select <= 4'b0010;
             dec_vgpr_source3_rd_en <= 1'b1;
          end
	12'b1_1_0_????????? : //read value from SGPR
          begin
             dec_out_source3_mux_select <= 4'b0011;
          end
	12'b1_1_1_0_0000_0001 : //read VCC_LO
          begin
             dec_out_source3_mux_select <= 4'b0100;
          end
	12'b1_1_1_0_0000_0010 : //read VCC_HI
          begin
             dec_out_source3_mux_select <= 4'b0101;
          end
	12'b1_1_1_0_0000_0100 : //read M0
          begin
             dec_out_source3_mux_select <= 4'b0110;
          end
	12'b1_1_1_0_0000_1000 : //read EXEC_LO
          begin
             dec_out_source3_mux_select <= 4'b0111;
          end
	12'b1_1_1_0_0001_0000 : //read EXEC_HI
          begin
             dec_out_source3_mux_select <= 4'b1000;
          end
	12'b1_1_1_0_0010_0000 : //read VCCZ
          begin
             dec_out_source3_mux_select <= 4'b1001;
          end
	12'b1_1_1_0_0100_0000 : //read EXECZ
          begin
             dec_out_source3_mux_select <= 4'b1010;
          end
	12'b1_1_1_0_1000_0000 : //read SCC
          begin
             dec_out_source3_mux_select <= 4'b1011;
          end
	default:
          begin
             dec_out_source3_mux_select <= 4'bx;
          end
      endcase
   end

   assign out_vgpr_source1_rd_en = dec_vgpr_source1_rd_en && in_alu_select;
   assign out_vgpr_source2_rd_en = dec_vgpr_source2_rd_en && in_alu_select;
   assign out_vgpr_source3_rd_en = dec_vgpr_source3_rd_en && in_alu_select;
   assign out_sgpr_rd_en = dec_sgpr_rd_en && in_alu_select;
   assign out_exec_rd_en = dec_exec_rd_en && in_alu_select;

   // Single cycle delay for the mux select and src_constant so
   // they arrive with the rest of the data
   always @ ( posedge clk or posedge rst ) begin
      if(rst) begin
	 out_source1_mux_select <= 0;
	 out_source2_mux_select <= 0;
	 out_source3_mux_select <= 0;
	 out_source1_src_constant <= 0;
	 out_source2_src_constant <= 0;
	 out_source3_src_constant <= 0;
      end
      else begin
	 out_source1_mux_select <= dec_out_source1_mux_select;
	 out_source2_mux_select <= dec_out_source2_mux_select;
	 out_source3_mux_select <= dec_out_source3_mux_select;
	 out_source1_src_constant <= in_source1_addr[9:0];
	 out_source2_src_constant <= in_source2_addr[9:0];
	 out_source3_src_constant <= in_source3_addr[9:0];
      end
   end
   
   always @* begin
      casex({in_dest1_addr[11:10], in_dest2_addr[11:10]})
	4'b10_??:
	  begin
	     out_vgpr_dest_addr <= in_dest1_addr;
	     out_sgpr_dest_addr <= in_dest2_addr;
	  end
	4'b11_??:
	  begin
	     out_vgpr_dest_addr <= in_dest2_addr;
	     out_sgpr_dest_addr <= in_dest1_addr;
	  end
	4'b??_10:
	  begin
	     out_vgpr_dest_addr <= in_dest2_addr;
	     out_sgpr_dest_addr <= in_dest1_addr;
	  end
	4'b??_11:
	  begin
	     out_vgpr_dest_addr <= in_dest1_addr;
	     out_sgpr_dest_addr <= in_dest2_addr;
	  end
	default:
	  begin
	     out_vgpr_dest_addr <= 12'bx;
	     out_sgpr_dest_addr <= 12'bx;
	  end
      endcase
   end


   generate
      if (MODULE == `MODULE_SIMD)
	simd_instr_decoder simd_instr_decoder 
	  (
	   .in_sgpr_dest_addr(out_sgpr_dest_addr),
	   .in_opcode(in_opcode),
	   .out_vcc_wr_en(dec_vcc_wr_en),
	   .out_vgpr_wr_en(dec_vgpr_wr_en),
	   .out_sgpr_wr_en(dec_sgpr_wr_en)
	   );
      else if (MODULE == `MODULE_SIMF)
	simf_instr_decoder simf_instr_decoder 
	  (
	   .in_sgpr_dest_addr(out_sgpr_dest_addr),
	   .in_opcode(in_opcode),
	   .out_vcc_wr_en(dec_vcc_wr_en),
	   .out_vgpr_wr_en(dec_vgpr_wr_en),
	   .out_sgpr_wr_en(dec_sgpr_wr_en)
	   );
endgenerate

   alu_fsm alu_fsm 
     (
      .in_alu_select(in_alu_select_flopped),
      .out_alu_start(out_alu_start),
      .in_valu_done(in_valu_done),
      .out_alu_ready(out_alu_ready),
      .RD(RD),
      .EX(EX),
      .WB(WB),
      .clk(clk),
      .rst(rst)
      );


   always @ (RD) begin
      casex(RD)
	1'b0 :
	  begin
	     out_src_buffer_wr_en <= 1'b0;
	  end
	1'b1 :
	  begin
	     out_src_buffer_wr_en <= 1'b1;
	  end
	default:
	  begin
	     out_src_buffer_wr_en <= 1'bx;
	  end
      endcase
   end

   always @ (EX or in_opcode) begin
      casex(EX)
	1'b0 :
	  begin
	     out_alu_control <= 32'd0;
	  end
	1'b1 :
	  begin
	     out_alu_control <= in_opcode;
	  end
	default :
	  begin
	     out_alu_control <= 32'dx;
	  end
      endcase
   end

   always @ (WB or dec_vcc_wr_en or dec_vgpr_wr_en or dec_sgpr_wr_en) begin
      casex(WB)
	1'b0 :
	  begin
	     out_vcc_wr_en <= 1'b0;
	     out_instr_done <= 1'b0;
	     out_vgpr_wr_en <= 1'b0;
	     out_sgpr_wr_en <= 1'b0;
	  end
	1'b1 :
	  begin
	     out_vcc_wr_en <= dec_vcc_wr_en;
	     out_instr_done <= 1'b1;
	     out_vgpr_wr_en <= dec_vgpr_wr_en;
	     out_sgpr_wr_en <= dec_sgpr_wr_en;
	  end
	default :
	  begin
	     out_vcc_wr_en <= 1'bx;
	     out_instr_done <= 1'bx;
	     out_vgpr_wr_en <= 1'bx;
	     out_sgpr_wr_en <= 1'bx;
	  end
      endcase
   end

endmodule
