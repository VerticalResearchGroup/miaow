module vgpr_comparator
  (/*AUTOARG*/
   // Outputs
   result,
   // Inputs
   retired_operand_mask, retired_operand_addr, src1_gpr_info,
   src4_gpr_info, dst1_gpr_info, src2_gpr_info, src3_gpr_info,
   dst2_gpr_info
   );

   wire  src1_cmp_en, src2_cmp_en, src3_cmp_en, src4_cmp_en,
	 dst1_cmp_en, dst2_cmp_en;
   
   
   input [3:0] retired_operand_mask;
   wire [3:0]  src1_mask, src4_mask, dst1_mask;
   wire [2:0]  src2_mask, src3_mask, dst2_mask;
   
   
   input [`VGPR_ADDR_LENGTH-1:0] retired_operand_addr;
   input [13:0] 		 src1_gpr_info, src4_gpr_info, dst1_gpr_info;
   input [12:0] 		 src2_gpr_info,	src3_gpr_info, dst2_gpr_info;
   

   output [`ISSUE_GPR_RD_BITS_LENGTH-1:0] result;
   
   wire [3:0] 				  src1_cmp_result, src4_cmp_result, dst1_cmp_result;
   
   wire [1:0] 				  src2_cmp_result, src3_cmp_result, dst2_cmp_result;

   // Compare only valid vgprs
   assign src1_cmp_en = get_valid_vgpr(src1_gpr_info[11:0]);
   assign src2_cmp_en = get_valid_vgpr(src2_gpr_info[11:0]);
   assign src3_cmp_en = get_valid_vgpr(src3_gpr_info[11:0]);
   assign src4_cmp_en = get_valid_vgpr(src4_gpr_info[11:0]);
   assign dst1_cmp_en = get_valid_vgpr(dst1_gpr_info[11:0]);
   assign dst2_cmp_en = get_valid_vgpr(dst2_gpr_info[11:0]);

   assign src1_mask = get_mask_4w(src1_gpr_info);
   assign src2_mask = get_mask_2w(src2_gpr_info);
   assign src3_mask = get_mask_2w(src3_gpr_info);
   assign src4_mask = get_mask_4w(src4_gpr_info);
   assign dst1_mask = get_mask_4w(dst1_gpr_info);
   assign dst2_mask = get_mask_2w(dst2_gpr_info);

   assign src1_cmp_result = vgpr_compare_operands_4w(src1_cmp_en, retired_operand_addr,
				 		   src1_gpr_info[`VGPR_ADDR_LENGTH-1:0], 
						   retired_operand_mask,
						   src1_mask);
   assign src2_cmp_result = vgpr_compare_operands_2w(src2_cmp_en, retired_operand_addr,
				 		   src2_gpr_info[`VGPR_ADDR_LENGTH-1:0], 
						   retired_operand_mask,
						   src2_mask);
   assign src3_cmp_result = vgpr_compare_operands_2w(src3_cmp_en, retired_operand_addr,
				 		   src3_gpr_info[`VGPR_ADDR_LENGTH-1:0], 
						   retired_operand_mask,
						   src3_mask);
   assign src4_cmp_result = vgpr_compare_operands_4w(src4_cmp_en, retired_operand_addr,
				 		   src4_gpr_info[`VGPR_ADDR_LENGTH-1:0], 
						   retired_operand_mask,
						   src4_mask);
   assign dst1_cmp_result = vgpr_compare_operands_4w(dst1_cmp_en, retired_operand_addr,
				 		   dst1_gpr_info[`VGPR_ADDR_LENGTH-1:0],
						   retired_operand_mask,
						   dst1_mask);
   assign dst2_cmp_result = vgpr_compare_operands_2w(dst2_cmp_en, retired_operand_addr,
				 		   dst2_gpr_info[`VGPR_ADDR_LENGTH-1:0],
						   retired_operand_mask,
						   dst2_mask);
	
   assign result = {src1_cmp_result, src2_cmp_result, src3_cmp_result,
		    src4_cmp_result, dst1_cmp_result, dst2_cmp_result};
   


   // Function to verify if the operand is indeed a valid vgpr
   function get_valid_vgpr;
      input[11:0] vgpr_info;
      begin
	 get_valid_vgpr 
	   = (vgpr_info[`ISSUE_OP_VALID_H:`ISSUE_OP_VALID_VGPR_L] == `ISSUE_VALID_VGPR_ID)?
	     1'b1 : 1'b0;
      end
   endfunction 
   
   // Functions to generate masks
   function [3:0] get_mask_4w;
      input[13:0] vgpr_info;
      begin
	 get_mask_4w
	   = (vgpr_info[`ISSUE_OP_4WORD_BIT]) ? 4'b1111 :
	     (vgpr_info[`ISSUE_OP_2WORD_BIT]) ? 4'b0011 :
	     4'b0001;
      end
   endfunction

   function [1:0] get_mask_2w;
      input[12:0] vgpr_info;
      begin
	 get_mask_2w
	   = (vgpr_info[`ISSUE_OP_2WORD_BIT]) ? 4'b0011 :
	     4'b0001;
      end
   endfunction
   
   
   // Functions that compare two operands
   function [3:0] vgpr_compare_operands_4w;
      input sb_operand_en;
      input [`VGPR_ADDR_LENGTH-1:0] r_operand_info, sb_operand_info;
      input [3:0] 		    r_operand_mask, sb_operand_mask;
      begin
	 vgpr_compare_operands_4w 
	   = ( sb_operand_en == 1'b0 ) ? 4'b0000 :
	     ( sb_operand_info+3 == r_operand_info ) ? sb_operand_mask & r_operand_mask<<3 :
	     ( sb_operand_info+2 == r_operand_info ) ? sb_operand_mask & r_operand_mask<<2 :
	     ( sb_operand_info+1 == r_operand_info ) ? sb_operand_mask & r_operand_mask<<1 :
	     ( sb_operand_info == r_operand_info ) ? sb_operand_mask & r_operand_mask :
	     ( sb_operand_info == r_operand_info+1 ) ? sb_operand_mask & r_operand_mask>>1 :
	     ( sb_operand_info == r_operand_info+2 ) ? sb_operand_mask & r_operand_mask>>2 :
	     ( sb_operand_info == r_operand_info+3 ) ? sb_operand_mask & r_operand_mask>>3 :
	     4'b0000;
      end
   endfunction

   function [1:0] vgpr_compare_operands_2w;
      input sb_operand_en;
      input [`VGPR_ADDR_LENGTH-1:0] r_operand_info, sb_operand_info;
      input [3:0] 		    r_operand_mask;
      input [1:0] 		    sb_operand_mask;
      begin
	 vgpr_compare_operands_2w 
	   = ( sb_operand_en  == 1'b0 )? 2'b00 :
	     ( sb_operand_info+1 == r_operand_info ) ? (sb_operand_mask & {r_operand_mask[0],1'b0}) : 
	     ( sb_operand_info == r_operand_info ) ? (sb_operand_mask & r_operand_mask[1:0]) :
	     ( sb_operand_info == r_operand_info+1 ) ? (sb_operand_mask & r_operand_mask[2:1]) :
	     ( sb_operand_info == r_operand_info+2 ) ? sb_operand_mask & r_operand_mask[3:2] :
	     ( sb_operand_info == r_operand_info+3 ) ? sb_operand_mask & {1'b0,r_operand_mask[3]} :
	     2'b00;
      end
   endfunction

endmodule
