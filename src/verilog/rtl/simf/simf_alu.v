module simf_alu
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
   reg           alu_done;
   reg           alu_dest_vcc_value;

   reg [31:0] final_source1_data;
   reg [31:0] final_source2_data;
	 reg [31:0] final_source3_data; // VIN
	 reg [31:0] temp_dest_data; 		//VIN


	 //Signals used by the fpu
   reg [31:0] fpu_opa_i;
   reg [31:0] fpu_opb_i;
   reg [2:0] fpu_op_i;
   wire [1:0] fpu_rmode_i;
   wire [31:0] fpu_output_o;
   reg fpu_start_i;
   wire fpu_ready_o;

   assign fpu_rmode_i = 2'b00;

   fpu_arith fpu(
               .clk(clk),
               .rst(rst),
               .opa_i(fpu_opa_i),
               .opb_i(fpu_opb_i),
               .fpu_op_i(fpu_op_i),
               .rmode_i(fpu_rmode_i),
               .output_o(fpu_output_o),
               .start_i(fpu_start_i),
               .ready_o(fpu_ready_o),
               .ine_o(),
               .overflow_o(),
               .underflow_o(),
               .div_zero_o(),
               .inf_o(),
               .zero_o(),
               .qnan_o(),
               .snan_o()
               );

   assign alu_sgpr_dest_data = alu_dest_vcc_value;
   
   
   always @* begin
      casex(alu_control[31:24])
         {`ALU_VOP3A_FORMAT} :
            begin
               final_source1_data <= alu_source1_data;
               final_source2_data <= alu_source2_data;
							 final_source3_data <= alu_source3_data; //VIN
            end
         {`ALU_VOP3B_FORMAT} :
            begin
               final_source1_data <= alu_source1_data;
               final_source2_data <= alu_source2_data;
							 final_source3_data <= alu_source3_data; //VIN
            end
         default : //VOP1, VOP2 and VOPC
            begin
               final_source1_data <= alu_source1_data;
               final_source2_data <= alu_source2_data;
							 final_source3_data <= alu_source3_data; //VIN
            end
      endcase
   end // always @ (...

	
   always @* begin
      casex({alu_source_exec_value, alu_control[31:24], alu_control[11:0]})
         {1'b0, 8'h??, 12'h???} : //EXEC disabled
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'b000;
               fpu_opa_i <= final_source1_data;
               fpu_opb_i <= final_source2_data;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h003} : //V_ADD_F32
            begin
               alu_done <= fpu_ready_o;
               fpu_start_i <= alu_start;
               fpu_op_i <= 3'b000;
               fpu_opa_i <= final_source1_data;
               fpu_opb_i <= final_source2_data;
               alu_vgpr_dest_data <= fpu_output_o;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h004} : //V_SUB_F32
            begin
               alu_done <= fpu_ready_o;
               fpu_start_i <= alu_start;
               fpu_op_i <= 3'b001;
               fpu_opa_i <= final_source1_data;
               fpu_opb_i <= final_source2_data;
               alu_vgpr_dest_data <= fpu_output_o;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h005} : //V_SUBREV_F32
            begin
               alu_done <= fpu_ready_o;
               fpu_start_i <= alu_start;
               fpu_op_i <= 3'b001;
               fpu_opa_i <= final_source2_data;
               fpu_opb_i <= final_source1_data;
               alu_vgpr_dest_data <= fpu_output_o;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h010} : //V_MAX_F32  - VIN
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= (final_source1_data >= final_source2_data) ? final_source1_data : final_source2_data;
               alu_dest_vcc_value <= alu_source_vcc_value;
						end
         {1'b1, `ALU_VOP1_FORMAT, 12'h02A} : //V_RCP_F32  - VIN
            begin
               alu_done <= fpu_ready_o;
               fpu_start_i <= alu_start;
               fpu_op_i <= 3'b011;
               fpu_opa_i <= 32'h3f80_0000;
               fpu_opb_i <= final_source1_data;
               alu_vgpr_dest_data <= fpu_output_o;
               alu_dest_vcc_value <= alu_source_vcc_value;
						end
         {1'b1, `ALU_VOP2_FORMAT, 12'h008} : //V_MUL_F32
            begin
               alu_done <= fpu_ready_o;
               fpu_start_i <= alu_start;
               fpu_op_i <= 3'b010;
               fpu_opa_i <= final_source1_data;
               fpu_opb_i <= final_source2_data;
               alu_vgpr_dest_data <= fpu_output_o;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP2_FORMAT, 12'h01F} : //V_MAC_F32 - VIN
            begin
               alu_dest_vcc_value <= alu_source_vcc_value;
							 alu_vgpr_dest_data <= temp_dest_data + alu_source3_data;
					
							 fpu_start_i <= alu_start;
							 fpu_op_i <= 3'b010;
							 fpu_opa_i <= final_source1_data;
							 fpu_opb_i <= final_source2_data;
							 temp_dest_data <= fpu_output_o;
							 alu_done <= fpu_ready_o;

							/*
								 casex(fpu_ready_o)
								1'b0 :
									begin
										fpu_start_i <= alu_start;
										fpu_op_i <= 3'b010;
										fpu_opa_i <= final_source1_data;
										fpu_opb_i <= final_source2_data;
										temp_dest_data <= fpu_output_o;
										alu_done <= 1'b0;
									end
								1'b1 :
									begin
										fpu_start_i <= 1'b1;
										fpu_op_i <= 3'b000;
										fpu_opa_i <= temp_dest_data;
										fpu_opb_i <= final_source3_data;
									  temp_dest_data <= fpu_output_o;	
										alu_done <= fpu_ready_o;
									end
								default :
									begin
               			fpu_start_i <= 1'b0;
               			fpu_op_i <= 3'b000;
               			fpu_opa_i <= 32'b0;
               			fpu_opb_i <= 32'b0;
               			temp_dest_data <= {32{1'bx}};
										alu_done <= 1'b1;
           				end
							endcase
							*/
						 	
						end
         {1'b1, `ALU_VOP2_FORMAT, 12'h020} : //V_MADMK_F32 - VIN
            begin
               alu_dest_vcc_value <= alu_source_vcc_value;
							 alu_vgpr_dest_data <= temp_dest_data + alu_source2_data;
						
							 fpu_start_i <= alu_start;
							 fpu_op_i <= 3'b010;
							 fpu_opa_i <= final_source1_data;
							 fpu_opb_i <= final_source3_data;
							 temp_dest_data <= fpu_output_o;
							 alu_done <= fpu_ready_o;

							 /*
							 casex(fpu_ready_o)
								1'b0 :
									begin
										fpu_start_i <= alu_start;
										fpu_op_i <= 3'b010;
										fpu_opa_i <= final_source1_data;
										fpu_opb_i <= final_source3_data;
										temp_dest_data <= fpu_output_o;
										alu_done <= 1'b0;
									end
								1'b1 :
									begin
										fpu_start_i <= 1'b1;
										fpu_op_i <= 3'b000;
										fpu_opa_i <= temp_dest_data;
										fpu_opb_i <= final_source2_data;
									  temp_dest_data <= fpu_output_o;	
										alu_done <= 1'b1;
									end
								default :
									begin
               			fpu_start_i <= 1'b0;
               			fpu_op_i <= 3'b000;
               			fpu_opa_i <= 32'b0;
               			fpu_opb_i <= 32'b0;
               			temp_dest_data <= {32{1'bx}};
										alu_done <= 1'b1;
           				end
							endcase
							*/
						end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h141} : //V_MAD_F32 - VIN
            begin
               alu_dest_vcc_value <= alu_source_vcc_value;
							 alu_vgpr_dest_data <= temp_dest_data;
							 
							 casex(fpu_ready_o)
								1'b0 :
									begin
										fpu_start_i <= alu_start;
										fpu_op_i <= 3'b010;
										fpu_opa_i <= final_source1_data;
										fpu_opb_i <= final_source2_data;
										temp_dest_data <= fpu_output_o;
										alu_done <= 1'b0;
									end
								1'b1 :
									begin
										fpu_start_i <= 1'b1;
										fpu_op_i <= 3'b000;
										fpu_opa_i <= temp_dest_data;
										fpu_opb_i <= final_source3_data;
									  temp_dest_data <= fpu_output_o;	
										alu_done <= 1'b1;
									end
								default :
									begin
               			fpu_start_i <= 1'b0;
               			fpu_op_i <= 3'b000;
               			fpu_opa_i <= 32'b0;
               			fpu_opb_i <= 32'b0;
               			temp_dest_data <= {32{1'bx}};
										alu_done <= 1'b1;
           				end
							endcase
						end
         {1'b1, `ALU_VOPC_FORMAT, 12'h000} : //V_CMP_F_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= 1'b0;
           end
         {1'b1, `ALU_VOPC_FORMAT, 12'h001} : //V_CMP_LT_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data < final_source2_data);
           end
         {1'b1, `ALU_VOPC_FORMAT, 12'h002} : //V_CMP_EQ_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data == final_source2_data);
           end
         {1'b1, `ALU_VOPC_FORMAT, 12'h003} : //V_CMP_LE_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data <= final_source2_data);
           end
         {1'b1, `ALU_VOPC_FORMAT, 12'h004} : //V_CMP_GT_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data > final_source2_data);
           end
         {1'b1, `ALU_VOPC_FORMAT, 12'h005} : //V_CMP_LG_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data != final_source2_data);
           end
         {1'b1, `ALU_VOPC_FORMAT, 12'h006} : //V_CMP_GE_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data >= final_source2_data);
           end
         {1'b1, `ALU_VOPC_FORMAT, 12'h009} : //V_CMP_NGE_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= !(final_source1_data >= final_source2_data);
           end
         {1'b1, `ALU_VOPC_FORMAT, 12'h00A} : //V_CMP_NLG_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data == final_source2_data);
           end
         {1'b1, `ALU_VOPC_FORMAT, 12'h00B} : //V_CMP_NGT_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= !(final_source1_data > final_source2_data);
           end
         {1'b1, `ALU_VOPC_FORMAT, 12'h00C} : //V_CMP_NLE_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= !(final_source1_data <= final_source2_data);
           end
         {1'b1, `ALU_VOPC_FORMAT, 12'h00D} : //V_CMP_NEQ_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data != final_source2_data);
           end
         {1'b1, `ALU_VOPC_FORMAT, 12'h00E} : //V_CMP_NLT_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= !(final_source1_data < final_source2_data);
           end
         {1'b1, `ALU_VOPC_FORMAT, 12'h00F} : //V_CMP_TRU_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= 1'b1;
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h000} : //V_CMP_F_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= 1'b0;
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h001} : //V_CMP_LT_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data < final_source2_data);
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h002} : //V_CMP_EQ_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data == final_source2_data);
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h003} : //V_CMP_LE_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data <= final_source2_data);
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h004} : //V_CMP_GT_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data > final_source2_data);
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h005} : //V_CMP_LG_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data != final_source2_data);
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h006} : //V_CMP_GE_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data >= final_source2_data);
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h009} : //V_CMP_NGE_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= !(final_source1_data >= final_source2_data);
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h00A} : //V_CMP_NLG_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data == final_source2_data);
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h00B} : //V_CMP_NGT_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= !(final_source1_data > final_source2_data);
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h00C} : //V_CMP_NLE_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= !(final_source1_data <= final_source2_data);
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h00D} : //V_CMP_NEQ_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= (final_source1_data != final_source2_data);
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h00E} : //V_CMP_NLT_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= !(final_source1_data < final_source2_data);
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h00F} : //V_CMP_TRU_F32
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'bxxx;
               fpu_opa_i <= {32{1'bx}};
               fpu_opb_i <= {32{1'bx}};
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= 1'b1;
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h103} : //V_ADD_F32
            begin
               alu_done <= fpu_ready_o;
               fpu_start_i <= alu_start;
               fpu_op_i <= 3'b000;
               fpu_opa_i <= final_source1_data;
               fpu_opb_i <= final_source2_data;
               alu_vgpr_dest_data <= fpu_output_o;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h104} : //V_SUB_F32
            begin
               alu_done <= fpu_ready_o;
               fpu_start_i <= alu_start;
               fpu_op_i <= 3'b001;
               fpu_opa_i <= final_source1_data;
               fpu_opb_i <= final_source2_data;
               alu_vgpr_dest_data <= fpu_output_o;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h105} : //V_SUBREV_F32
            begin
               alu_done <= fpu_ready_o;
               fpu_start_i <= alu_start;
               fpu_op_i <= 3'b001;
               fpu_opa_i <= final_source1_data;
               fpu_opb_i <= final_source2_data;
               alu_vgpr_dest_data <= fpu_output_o;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         {1'b1, `ALU_VOP3A_FORMAT, 12'h108} : //V_MUL_F32
            begin
               alu_done <= fpu_ready_o;
               fpu_start_i <= alu_start;
               fpu_op_i <= 3'b010;
               fpu_opa_i <= final_source1_data;
               fpu_opb_i <= final_source2_data;
               alu_vgpr_dest_data <= fpu_output_o;
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
         default :
            begin
               alu_done <= 1'b1;
               fpu_start_i <= 1'b0;
               fpu_op_i <= 3'b000;
               fpu_opa_i <= 32'b0;
               fpu_opb_i <= 32'b0;
               alu_vgpr_dest_data <= {32{1'bx}};
               alu_dest_vcc_value <= alu_source_vcc_value;
           end
      endcase
   end // always @ (...
endmodule
