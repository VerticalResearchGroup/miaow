module simd_alu
  (
   alu_source1_data,
   alu_source2_data,
   alu_source3_data, //TODO
   alu_source_vcc_value,
   alu_source_exec_value,
   alu_control,
   alu_start,
   alu_vgpr_dest_data,
   alu_sgpr_dest_data,
   alu_dest_vcc_value,
   alu_done,
   clk,
   rst
   );

   //TODO check overflow for signed and unsigned

   input clk;
   input rst;

   input [31:0]  alu_source1_data;
   input [31:0]  alu_source2_data;
   input [31:0]  alu_source3_data;
   input         alu_source_vcc_value;
   input         alu_source_exec_value;

   input [31:0]  alu_control;
   input         alu_start;

   output [31:0] alu_vgpr_dest_data;
   output        alu_sgpr_dest_data;
   output        alu_dest_vcc_value;
   output        alu_done;

   reg [31:0]    alu_vgpr_dest_data;
   reg           alu_dest_vcc_value;
   reg           alu_done;

   // Signals used by the multiplier
   reg [31:0]   mul_inp0_s;
   reg [31:0]   mul_inp1_s;
   wire [63:0]     mul_out_s;               // Combi output from multiplier
   reg [1:0]    mul_cycles_s;            // The current mult takes 4 cycles.
   wire   mul_busy_s;              // High 1 cycle after new mult, till done
   wire   mul_done_s;              // Pulse at end of computation
   reg       mul_op_s;                // Indicates multipler operation underway

   wire [31:0]     twos_complement_inp0_s;
   wire [31:0]     twos_complement_inp1_s;
	 wire [31:0]		 twos_complement_inp2_s; //VIN

   //TODO check logic

   reg [31:0] abs_signed_source1_data;
   reg [31:0] abs_signed_source2_data;
   reg [31:0] abs_signed_source3_data;
   reg [31:0] abs_unsigned_source1_data;
   reg [31:0] abs_unsigned_source2_data;
   reg [31:0] abs_unsigned_source3_data;
   reg [31:0] final_signed_source1_data;
   reg [31:0] final_signed_source2_data;
   reg [31:0] final_signed_source3_data;
   reg [31:0] final_unsigned_source1_data;
   reg [31:0] final_unsigned_source2_data;
   reg [31:0] final_unsigned_source3_data;
   
	 assign twos_complement_inp0_s = ~alu_source1_data + 32'd1;
   assign twos_complement_inp1_s = ~alu_source2_data + 32'd1;
   assign twos_complement_inp2_s = ~alu_source3_data + 32'd1;
   
	 assign alu_sgpr_dest_data = alu_dest_vcc_value;

   always @* begin
      casex(alu_control[31:24])
         {`ALU_VOP3A_FORMAT} :
            begin
               abs_signed_source1_data <= alu_control[`ALU_VOP3A_ABS1_POS]
                                          ? (alu_source1_data[31] ? twos_complement_inp0_s : alu_source1_data)
                                          : alu_source1_data;
               abs_signed_source2_data <= alu_control[`ALU_VOP3A_ABS2_POS]
                                          ? (alu_source2_data[31] ? twos_complement_inp1_s : alu_source2_data)
                                          : alu_source2_data;
               abs_signed_source3_data <= alu_control[`ALU_VOP3A_ABS3_POS]
                                          ? (alu_source3_data[31] ? twos_complement_inp2_s : alu_source3_data)
                                          : alu_source3_data;
            end
         default : //VOP1, VOP2 and VOPC
            begin
              abs_signed_source1_data <= alu_source1_data;
              abs_signed_source2_data <= alu_source2_data;
              abs_signed_source3_data <= alu_source3_data;
            end
      endcase
   end // always @ (...

   always @* begin
      casex(alu_control[31:24])
         {`ALU_VOP3A_FORMAT} :
            begin
               final_signed_source1_data <= alu_control[`ALU_VOP3A_NEG1_POS] ? (~abs_signed_source1_data + 32'd1) : abs_signed_source1_data;
               final_signed_source2_data <= alu_control[`ALU_VOP3A_NEG2_POS] ? (~abs_signed_source2_data + 32'd1) : abs_signed_source2_data;
               final_signed_source3_data <= alu_control[`ALU_VOP3A_NEG3_POS] ? (~abs_signed_source3_data + 32'd1) : abs_signed_source3_data;
							 final_unsigned_source1_data <= alu_control[`ALU_VOP3A_NEG1_POS] ? twos_complement_inp0_s : alu_source1_data;
               final_unsigned_source2_data <= alu_control[`ALU_VOP3A_NEG2_POS] ? twos_complement_inp1_s : alu_source2_data;
               final_unsigned_source3_data <= alu_control[`ALU_VOP3A_NEG3_POS] ? twos_complement_inp2_s : alu_source3_data;
            end
         {`ALU_VOP3B_FORMAT} :
            begin
               final_signed_source1_data <= alu_control[`ALU_VOP3B_NEG1_POS] ? (~abs_signed_source1_data + 32'd1) : abs_signed_source1_data;
               final_signed_source2_data <= alu_control[`ALU_VOP3B_NEG2_POS] ? (~abs_signed_source2_data + 32'd1) : abs_signed_source2_data;
               final_signed_source3_data <= alu_control[`ALU_VOP3B_NEG3_POS] ? (~abs_signed_source3_data + 32'd1) : abs_signed_source3_data;
               final_unsigned_source1_data <= alu_control[`ALU_VOP3B_NEG1_POS] ? twos_complement_inp0_s : alu_source1_data;
               final_unsigned_source2_data <= alu_control[`ALU_VOP3B_NEG2_POS] ? twos_complement_inp1_s : alu_source2_data;
               final_unsigned_source3_data <= alu_control[`ALU_VOP3B_NEG3_POS] ? twos_complement_inp2_s : alu_source3_data;
            end
         default : //VOP1, VOP2 and VOPC
            begin
              final_signed_source1_data <= abs_signed_source1_data;
              final_signed_source2_data <= abs_signed_source2_data;
              final_signed_source3_data <= abs_signed_source3_data;
              final_unsigned_source1_data <= alu_source1_data;
              final_unsigned_source2_data <= alu_source2_data;
              final_unsigned_source3_data <= alu_source3_data;
            end
      endcase
   end // always @ (...

   always @* begin
      casex({alu_source_exec_value, alu_control[31:24], alu_control[11:0]})
         {1'b0, 8'h??, 12'h???} : //EXEC disabled
            begin
               alu_done <= 1'b0;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP1_FORMAT, 12'h001} : //VOP1: V_MOV_B32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= alu_source1_data;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h025} : //VOP2: V_ADD_I32
            begin
               alu_done <= 1'b1;
               {alu_dest_vcc_value, alu_vgpr_dest_data} <= final_signed_source1_data + final_signed_source2_data;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h026} : //VOP2: V_SUB_I32
            begin
               alu_done <= 1'b1;
               {alu_dest_vcc_value, alu_vgpr_dest_data} <= final_signed_source1_data - final_signed_source2_data;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h01B} : //VOP2: V_AND_B32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= alu_source1_data & alu_source2_data;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h11B} : //VOP3A: V_AND_B32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= alu_source1_data & alu_source2_data;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h01C} : //VOP2: V_OR_B32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= alu_source1_data | alu_source2_data;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h01A} : //VOP2: V_LSHLREV_B32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= alu_source2_data << alu_source1_data[4:0];
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h016} : //VOP2: V_LSHRREV_B32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= alu_source2_data >> alu_source1_data[4:0];
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h018} : //VOP2: V_ASHRREV_I32 - VIN
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= final_signed_source2_data >> final_signed_source1_data[4:0];
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h014} : //VOP2: V_MAX_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= (final_unsigned_source1_data >= final_unsigned_source2_data) ? final_unsigned_source1_data : final_unsigned_source2_data;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h012} : //VOP2: V_MAX_I32 - VIN
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= (final_signed_source1_data >= final_signed_source2_data) ? final_signed_source1_data : final_signed_source2_data;
               alu_dest_vcc_value <= alu_source_vcc_value;
						end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h114} : //VOP3A: V_MAX_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= (final_unsigned_source1_data >= final_unsigned_source2_data) ? final_unsigned_source1_data : final_unsigned_source2_data;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h013} : //VOP2: V_MIN_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= (final_unsigned_source1_data <= final_unsigned_source2_data) ? final_unsigned_source1_data : final_unsigned_source2_data;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h113} : //VOP3A: V_MIN_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= (final_unsigned_source1_data <= final_unsigned_source2_data) ? final_unsigned_source1_data : final_unsigned_source2_data;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h000} : //VOP2: V_CNDMASK_B32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= alu_source_vcc_value ? alu_source2_data : alu_source1_data;
               alu_dest_vcc_value <= alu_source_vcc_value;
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h080} : //VOPC: V_CMP_F_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= 1'b0;
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h081} : //VOPC: V_CMP_LT_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_signed_source1_data < final_signed_source2_data);
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h082} : //VOPC: V_CMP_EQ_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_signed_source1_data == final_signed_source2_data);
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h083} : //VOPC: V_CMP_LE_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_signed_source1_data <= final_signed_source2_data);
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h084} : //VOPC: V_CMP_GT_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_signed_source1_data > final_signed_source2_data);
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h085} : //VOPC: V_CMP_LG_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_signed_source1_data != final_signed_source2_data);
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h086} : //VOPC: V_CMP_GE_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_signed_source1_data >= final_signed_source2_data);
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h087} : //VOPC: V_CMP_TRU_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= 1'b1;
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h0C0} : //VOPC: V_CMP_F_U_32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= 1'b0;
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h0C1} : //VOPC: V_CMP_LT_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= ({1'b0, final_unsigned_source1_data} < {1'b0, final_unsigned_source2_data});
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h0C2} : //VOPC: V_CMP_EQ_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= ({1'b0, final_unsigned_source1_data} == {1'b0, final_unsigned_source2_data});
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h0C3} : //VOPC: V_CMP_LE_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= ({1'b0, final_unsigned_source1_data} <= {1'b0, final_unsigned_source2_data});
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h0C4} : //VOPC: V_CMP_GT_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= ({1'b0, final_unsigned_source1_data} > {1'b0, final_unsigned_source2_data});
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h0C5} : //VOPC: V_CMP_LG_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= ({1'b0, final_unsigned_source1_data} != {1'b0, final_unsigned_source2_data});
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h0C6} : //VOPC: V_CMP_GE_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= ({1'b0, final_unsigned_source1_data} >= {1'b0, final_unsigned_source2_data});
            end
         {1'b1, `ALU_VOPC_FORMAT, 12'h0C7} : //VOPC: V_CMP_TRU_U_32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= 1'b1;
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h080} : //VOP3a: V_CMP_F_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= 1'b0;
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h081} : //VOP3a: V_CMP_LT_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_signed_source1_data < final_signed_source2_data);
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h082} : //VOP3a: V_CMP_EQ_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_signed_source1_data == final_signed_source2_data);
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h083} : //VOP3a: V_CMP_LE_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_signed_source1_data <= final_signed_source2_data);
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h084} : //VOP3a: V_CMP_GT_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_signed_source1_data > final_signed_source2_data);
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h085} : //VOP3a: V_CMP_LG_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_signed_source1_data != final_signed_source2_data);
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h086} : //VOP3a: V_CMP_GE_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_signed_source1_data >= final_signed_source2_data);
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h087} : //VOP3a: V_CMP_TRU_I32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= 1'b1;
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h0C0} : //VOP3a: V_CMP_F_U_32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= 1'b0;
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h0C1} : //VOP3a: V_CMP_LT_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= ({1'b0, final_unsigned_source1_data} < {1'b0, final_unsigned_source2_data});
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h0C2} : //VOP3a: V_CMP_EQ_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= ({1'b0, final_unsigned_source1_data} == {1'b0, final_unsigned_source2_data});
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h0C3} : //VOP3a: V_CMP_LE_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= ({1'b0, final_unsigned_source1_data} <= {1'b0, final_unsigned_source2_data});
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h0C4} : //VOP3a: V_CMP_GT_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= ({1'b0, final_unsigned_source1_data} > {1'b0, final_unsigned_source2_data});
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h0C5} : //VOP3a: V_CMP_LG_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= ({1'b0, final_unsigned_source1_data} != {1'b0, final_unsigned_source2_data});
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h0C6} : //VOP3a: V_CMP_GE_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= ({1'b0, final_unsigned_source1_data} >= {1'b0, final_unsigned_source2_data});
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h0C7} : //VOP3a: V_CMP_TRU_U_32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= 1'b1;
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h16A} : //VOP3a: V_MUL_HI_U32 => /* D.u = (S0.u * S1.u)>>32 */ VCC not used
            begin
               alu_done <= mul_done_s;
               alu_vgpr_dest_data <= mul_out_s[63:32];
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h009} : //VOP2: V_MUL_I32_I24 => /* D.i = S0.i[23:0] * S1.i[23:0]. */ VCC not used
            begin
               alu_done <= mul_done_s;
               alu_vgpr_dest_data <= mul_out_s[31:0];
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h109} : //VOP3a: V_MUL_I32_I24 => /* D.i = S0.i[23:0] * S1.i[23:0]. */ VCC not used
            begin
               alu_done <= mul_done_s;
               alu_vgpr_dest_data <= mul_out_s[31:0];
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h16B} : //VOP3a: V_MUL_LO_I32 => /* D.i = S0.i * S1.i. */ VCC not used
            begin
               // TODO-RAGHU-20130205 : When slicing, sign bit is missed.
               // FIXME
               alu_done <= mul_done_s;
               alu_vgpr_dest_data <= mul_out_s[31:0];
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h169} : //VOP3a: V_MUL_LO_U32 => /* D.u = S0.u * S1.u. */ VCC not used
            begin
               alu_done <= mul_done_s;
               alu_vgpr_dest_data <= mul_out_s[31:0];
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h148} : //VOP3A: V_BFE_U32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= (final_unsigned_source1_data >> final_unsigned_source2_data[4:0]) & ((1<<final_unsigned_source3_data[4:0])-1);
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h149} : //VOP3A: V_BFE_I32 - VIN //needs correct implmentation
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= (final_signed_source1_data >>> final_signed_source2_data[4:0]) & ((1 <<< final_signed_source3_data[4:0])-1);
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h14A} : //VOP3A: V_BFI_B32
            begin
               alu_done <= 1'b1;
               alu_vgpr_dest_data <= (alu_source1_data & alu_source2_data) | (~alu_source1_data & alu_source3_data);
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h028} : //VOP2: V_ADDC_U32 - VIN
            begin
               alu_done <= 1'b1;
               {alu_dest_vcc_value, alu_vgpr_dest_data} <= final_unsigned_source1_data + final_unsigned_source2_data + alu_source_vcc_value;
						end
         {1'b1, `ALU_VOP2_FORMAT, 12'h027} : //VOP2: V_SUBREV_I32 - VIN
            begin
               alu_done <= 1'b1;
               {alu_dest_vcc_value, alu_vgpr_dest_data} <= final_signed_source2_data - final_signed_source1_data;
						end
         default :
            begin
               alu_done <= 1'b0;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= 1'bx;
           end
      endcase
   end // always @ (...


   // Multiplier inputs
   always @* begin
      casex({alu_source_exec_value, alu_control[31:24], alu_control[11:0]})
         {1'b1, `ALU_VOP3A_FORMAT, 12'h16A} : // V_MUL_HI_U32 => /* D.u = (S0.u * S1.u)>>32 */ VCC not used
            begin
               mul_op_s <= 1'b1;
               mul_inp0_s <= final_unsigned_source1_data;
               mul_inp1_s <= final_unsigned_source2_data;
            end
         {1'b1, `ALU_VOP2_FORMAT, 12'h009} : // V_MUL_I32_I24 => /* D.i = S0.i[23:0] * S1.i[23:0]. */ VCC not used
            begin
               mul_op_s <= 1'b1;
               // ISSUE-Ragh-20130205 : Assuming i24 => 31st bit is sign, [23:0] has data.
               if (alu_source1_data[31])
                  begin
                     mul_inp0_s[23:0] <= twos_complement_inp0_s[23:0];
                     mul_inp0_s[31:24] <= 'd0;
                  end
               else
                  begin
                     mul_inp0_s[23:0] <= alu_source1_data[23:0];
                     mul_inp0_s[31:24] <= 'd0;
                  end
               if (alu_source2_data[31])
                  begin
                     mul_inp1_s[23:0] <= twos_complement_inp1_s[23:0];
                     mul_inp1_s[31:24] <= 'd0;
                  end
               else
                  begin
                     mul_inp1_s[23:0] <= alu_source2_data[23:0];
                     mul_inp1_s[31:24] <= 'd0;
                  end
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h109} : // V_MUL_I32_I24 => /* D.i = S0.i[23:0] * S1.i[23:0]. */ VCC not used
            begin
               mul_op_s <= 1'b1;
               // ISSUE-Ragh-20130205 : Assuming i24 => 31st bit is sign, [23:0] has data.
               if (alu_source1_data[31])
                  begin
                     mul_inp0_s[23:0] <= twos_complement_inp0_s[23:0];
                     mul_inp0_s[31:24] <= 'd0;
                  end
               else
                  begin
                     mul_inp0_s[23:0] <= alu_source1_data[23:0];
                     mul_inp0_s[31:24] <= 'd0;
                  end
               if (alu_source2_data[31])
                  begin
                     mul_inp1_s[23:0] <= twos_complement_inp1_s[23:0];
                     mul_inp1_s[31:24] <= 'd0;
                  end
               else
                  begin
                     mul_inp1_s[23:0] <= alu_source1_data[23:0];
                     mul_inp1_s[31:24] <= 'd0;
                  end
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h16B} : // V_MUL_LO_I32 => /* D.i = S0.i * S1.i. */ VCC not used
            begin
               mul_op_s <= 1'b1;
               if (alu_source1_data[31])
                  mul_inp0_s <= twos_complement_inp0_s;
               else
                  mul_inp0_s <= alu_source1_data;
               if (alu_source2_data[31])
                  mul_inp1_s <= twos_complement_inp1_s;
               else
                  mul_inp1_s <= alu_source2_data;
            end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h169} : // V_MUL_LO_U32 => /* D.u = S0.u * S1.u. */ VCC not used
            begin
               mul_op_s <= 1'b1;
               mul_inp0_s <= alu_source1_data;
               mul_inp1_s <= alu_source2_data;
            end
         default :
            begin
               mul_op_s <= 1'b0;
               mul_inp0_s <= 'd0;
               mul_inp1_s <= 'd0;
            end
      endcase
   end // always @ (...




  // Booth multiplier from openrisc
  // amultp2_32x32 amultp2_32x32
  //   (
  //    .X(mul_inp0_s),
  //    .Y(mul_inp1_s),
  //    .RST(rst),
  //    .CLK(clk),
  //    .P(mul_out_s)
  //    );
  assign mul_out_s = mul_inp0_s * mul_inp1_s;

   assign mul_busy_s = |mul_cycles_s;
   assign mul_done_s = (mul_cycles_s == 2'd2);

   always @(posedge clk or posedge rst)
      if (rst)
         begin
            mul_cycles_s <= 'd0;
         end
      else
         begin
            if (~mul_op_s)
               begin
                  mul_cycles_s <= 'd0;
               end
            else
               begin
                  if (mul_cycles_s == 2'd2)
                     mul_cycles_s <= 'd0;
                  else
                     mul_cycles_s <= mul_cycles_s + 'd1;
               end
         end

endmodule
