module simf_instr_decoder 
  (/*AUTOARG*/
   // Outputs
   out_vcc_wr_en, out_vgpr_wr_en, out_sgpr_wr_en,
   // Inputs
   in_opcode, in_sgpr_dest_addr
   );

input [31:0] in_opcode;
input [11:0] in_sgpr_dest_addr;

output out_vcc_wr_en;
output out_vgpr_wr_en;
output out_sgpr_wr_en;

reg out_vcc_wr_en;
reg out_vgpr_wr_en;
reg out_sgpr_wr_en;

reg temp_vcc_wr_en;
reg temp_sgpr_wr_en;


always @* begin
   casex({in_opcode[31:24], in_sgpr_dest_addr})
      {`ALU_VOP3A_FORMAT, 12'b1_1_1_0_0000_0001}:
         begin
            out_vcc_wr_en <= 1'b1;
            out_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOP3A_FORMAT, 12'b1_1_0_?????????}:
         begin
            out_vcc_wr_en <= 1'b0;
            out_sgpr_wr_en <= 1'b1;
         end
      default:
         begin
            out_vcc_wr_en <= temp_vcc_wr_en;
            out_sgpr_wr_en <= temp_sgpr_wr_en;
         end
      endcase
end

always @ (in_opcode) begin
	casex(in_opcode)
      {`ALU_VOP2_FORMAT, 12'h???, 12'h003} : //V_ADD_F32
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOP2_FORMAT, 12'h???, 12'h004} : //V_SUB_F32
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
        end
      {`ALU_VOP2_FORMAT, 12'h???, 12'h005} : //V_SUBREV_F32
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
        end
      {`ALU_VOP2_FORMAT, 12'h???, 12'h008} : //V_MUL_F32
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
        end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h000} : //V_CMP_F_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h001} : //V_CMP_LT_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h002} : //V_CMP_EQ_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h003} : //V_CMP_LE_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h004} : //V_CMP_GT_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h005} : //V_CMP_LG_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h006} : //V_CMP_GE_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h009} : //V_CMP_NGE_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h00A} : //V_CMP_NLG_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h00B} : //V_CMP_NGT_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h00C} : //V_CMP_NLE_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h00D} : //V_CMP_NEQ_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h00E} : //V_CMP_NLT_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOPC_FORMAT, 12'h???, 12'h00F} : //V_CMP_TRU_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b0;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h000} : //V_CMP_F_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h001} : //V_CMP_LT_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h002} : //V_CMP_EQ_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h003} : //V_CMP_LE_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h004} : //V_CMP_GT_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h005} : //V_CMP_LG_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h006} : //V_CMP_GE_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h009} : //V_CMP_NGE_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h00A} : //V_CMP_NLG_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h00B} : //V_CMP_NGT_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h00C} : //V_CMP_NLE_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h00D} : //V_CMP_NEQ_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h00E} : //V_CMP_NLT_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h00F} : //V_CMP_TRU_F32
         begin
            temp_vcc_wr_en <= 1'b1;
            out_vgpr_wr_en <= 1'b0;
            temp_sgpr_wr_en <= 1'b1;
         end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h103} : //V_ADD_F32
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
        end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h104} : //V_SUB_F32
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
        end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h105} : //V_SUBREV_F32
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
        end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h108} : //V_MUL_F32
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
        end
      {`ALU_VOP2_FORMAT, 12'h???, 12'h01F} : //V_MAC_F32  - VIN
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
        end
      {`ALU_VOP2_FORMAT, 12'h???, 12'h020} : //V_MADMK_F32  - VIN
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
				 end
      {`ALU_VOP2_FORMAT, 12'h???, 12'h010} : //V_MAX_F32  - VIN
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
				 end
      {`ALU_VOP3A_FORMAT, 12'h???, 12'h141} : //V_MAD_F32  - VIN
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
				 end
      {`ALU_VOP1_FORMAT, 12'h???, 12'h033} : //V_SQRT_F32  - VIN
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
				 end
      {`ALU_VOP1_FORMAT, 12'h???, 12'h02A} : //V_RCP_F32  - VIN
         begin
      		temp_vcc_wr_en <= 1'b0;
      		out_vgpr_wr_en <= 1'b1;
            temp_sgpr_wr_en <= 1'b0;
				 end
		default:
			begin
				temp_vcc_wr_en <= 1'bx;
				out_vgpr_wr_en <= 1'bx;
            temp_sgpr_wr_en <= 1'b0;
			end
	endcase
end

endmodule
