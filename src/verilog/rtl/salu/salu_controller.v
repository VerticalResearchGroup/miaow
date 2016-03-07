`define SALU_SOPP_FORMAT 8'h01
`define SALU_SOP1_FORMAT 8'h02
`define SALU_SOPC_FORMAT 8'h04
`define SALU_SOP2_FORMAT 8'h08
`define SALU_SOPK_FORMAT 8'h10

module salu_controller(
	control_en,
	dst_reg,
	opcode,
	alu_control,
	branch_on_cc,
	exec_en,
	vcc_en,
	scc_en,
	m0_en,
	sgpr_en,
	vcc_wordsel,
	exec_wordsel,
	exec_sgpr_cpy,
	snd_src_imm,
	bit64_op,
	rst,
        //**CHANGE
        //**add 2 signals
        //one is output which is 
        //a signal to flag a SGPR write request pending
        //one is input to flag request satisfied, unlock request
        clk,
        salu2sgpr_req,
        rfa2salu_req_hold,

        //**change for port forwarding
        control_en_fw,
        dst_reg_fw
        //**
);

//**change [psp]
input rfa2salu_req_hold;
input clk;

input control_en_fw;
input [11:0] dst_reg_fw;
//**

//**change [psp]
output salu2sgpr_req;
//**

input [11:0] dst_reg;
input [31:0] opcode;
input control_en, rst;

output exec_en, vcc_en, scc_en, m0_en, exec_sgpr_cpy,
		snd_src_imm, bit64_op;
output [1:0] vcc_wordsel, exec_wordsel, sgpr_en;
output [5:0] branch_on_cc;
output [31:0] alu_control;

reg exec_en_dreg, vcc_en, scc_en, m0_en, exec_sgpr_cpy,
	snd_src_imm, bit64_op;
reg [1:0] vcc_ws_dreg, exec_ws_dreg, vcc_ws_op, exec_ws_op, sgpr_en;
reg [5:0] branch_on_cc;
reg [31:0] alu_control;

//**change [psp]
reg salu2sgpr_req;
reg salu2sgpr_req_trig;

wire sgpr_fw_check;
assign sgpr_fw_check = {control_en_fw, dst_reg_fw[11:9]} && 4'b1110;
//**

//**change [psp]
//create a lock mechanism that locks the request line
//until rfa notifies its been satisfied

//this is simply the unlocker
//line is locked below where it determines destination registers
always@ (control_en or dst_reg or bit64_op or clk or rst) begin
        if(~control_en | rst ) begin
              salu2sgpr_req <= 1'b0; //satisfied   
           end
        else
        if(salu2sgpr_req_trig | sgpr_fw_check) begin
              salu2sgpr_req <= 1'b1; //not satisfied
        end
        else
        begin
              salu2sgpr_req <= salu2sgpr_req;
        end
   end
//**

// setting scc_en, alu_control, vcc_ws_op, exec_ws_op
always@ (control_en or opcode or rst) begin
	if(~control_en | rst) begin
		alu_control <= 'd0;
		scc_en <= 1'b0;
		vcc_ws_op <= 2'b00;
		exec_ws_op <= 2'b00;
		exec_sgpr_cpy <= 1'b0;
		branch_on_cc <= 6'b000000;
		snd_src_imm <= 1'b0;
		bit64_op <= 1'b0;
	end
	else if(control_en) begin
		scc_en <= 1'b0;
		alu_control <= opcode;
		bit64_op <= 1'b0;
		exec_sgpr_cpy <= 1'b0;
		snd_src_imm <= 1'b0;
		branch_on_cc <= 6'b000000;
		vcc_ws_op <= 2'b00;
		exec_ws_op <= 2'b00;
		// setting scc_en for instruction that write to scc
		casex(opcode[31:24])
			// SOPP
			{`SALU_SOPP_FORMAT} : begin
				snd_src_imm <= 1'b1;
				casex(opcode[23:0])
					// s_branch	0x02
					24'h000002 : begin branch_on_cc <= 6'b111111; end
					// s_cbranch_scc0	0x04
					24'h000004 : begin branch_on_cc <= 6'b000001; end
					// s_cbranch_scc1	0x05
					24'h000005 : begin branch_on_cc <= 6'b000010; end
					// s_cbranch_vccz	0x06
					24'h000006 : begin branch_on_cc <= 6'b000100; end
					// s_cbranch_vccnz	0x07
					24'h000007 : begin branch_on_cc <= 6'b001000; end
					// s_cbranch_execz	0x08
					24'h000008 : begin branch_on_cc <= 6'b010000; end
					// s_cbranch_execnz	0x09
					24'h000009 : begin branch_on_cc <= 6'b100000; end
				endcase
			end

			// SOP1
			{`SALU_SOP1_FORMAT} : begin
				casex(opcode[23:0])
					// s_mov_b32	0x03
					// No special signals
					// s_mov_b64	0x04
					24'h000004 : begin
						bit64_op <= 1'b1;
					end
					// s_not_b32	0x07
					24'h000007 : begin
						scc_en <= 1'b1;
					end
					// s_and_saveexec_b64	0x24
					24'h000024 : begin
						scc_en <= 1'b1;
						exec_ws_op <= 2'b11;
						exec_sgpr_cpy <= 1'b1;
						bit64_op <= 1'b1;
					end
				endcase
			end

			// SOP2
			{`SALU_SOP2_FORMAT} : begin
				casex(opcode[23:0])
					// s_add_u32	0x00
					24'h000000 : begin
						scc_en <= 1'b1;
					end
					// s_sub_u32	0x01
					24'h000001 : begin
						scc_en <= 1'b1;
					end
					// s_add_i32	0x02
					24'h000002 : begin
						scc_en <= 1'b1;
					end
					// s_sub_i32	0x03
					24'h000003 : begin
						scc_en <= 1'b1;
					end
					// s_min_u32	0x07
					24'h000007 : begin
						scc_en <= 1'b1;
					end
					// s_max_u32	0x09
					24'h000009 : begin
						scc_en <= 1'b1;
					end
					// s_max_i32	0x08 - VIN
					24'h000008 : begin
						scc_en <= 1'b1;
					end
					// s_and_b32	0x0E
					24'h00000E : begin
						scc_en <= 1'b1;
					end
					// s_and_b64	0x0F
					24'h00000F : begin
						scc_en <= 1'b1;
						bit64_op <= 1'b1;
					end
					// s_or_b64	0x11
					24'h000011 : begin
						scc_en <= 1'b1;
						bit64_op <= 1'b1;
					end
					// s_or_b32	0x10
					24'h000010 : begin
						scc_en <= 1'b1;
					end
					// s_andn2_b64	0x15
					24'h000015 : begin
						scc_en <= 1'b1;
						bit64_op <= 1'b1;
					end
					// s_lshl_b32	0x1E
					24'h00001E : begin
						scc_en <= 1'b1;
					end
					// s_lshr_b32	0x20
					24'h000020 : begin
						scc_en <= 1'b1;
						
					end
					// s_ashr_i32	0x22
					24'h000022 : begin
						scc_en <= 1'b1;
						
					end
					// s_mul_i32	0x26
					// No special signals
				endcase
			end

			// SOPC
			{`SALU_SOPC_FORMAT} : begin
				casex(opcode[23:0])
					// s_cmp_eq_i32	0x00
					24'h000000 : begin scc_en <= 1'b1; end
					// s_cmp_lg_i32	0x01 - VIN
					24'h000001 : begin scc_en <= 1'b1; end
					// s_cmp_gt_i32	0x02 - VIN
					24'h000002 : begin scc_en <= 1'b1; end
					// s_cmp_ge_i32	0x03 - VIN
					24'h000003 : begin scc_en <= 1'b1; end
					// s_cmp_lt_i32	0x04 - VIN
					24'h000004 : begin scc_en <= 1'b1; end
					// s_cmp_le_i32	0x05
					24'h000005 : begin scc_en <= 1'b1; end
					// s_cmp_eq_u32	0x06 - VIN
					24'h000006 : begin scc_en <= 1'b1; end
					// s_cmp_lg_u32	0x07 - VIN
					24'h000007 : begin scc_en <= 1'b1; end
					// s_cmp_gt_u32	0x08 - VIN
					24'h000008 : begin scc_en <= 1'b1; end
					// s_cmp_ge_u32	0x09 - VIN
					24'h000009 : begin scc_en <= 1'b1; end
					// s_cmp_lt_u32	0x0A - VIN
					24'h00000A : begin scc_en <= 1'b1; end
					// s_cmp_le_u32	0x0B
					24'h00000B : begin scc_en <= 1'b1; end
					// default
					default : begin  end
				endcase
			end

			// SOPK
			{`SALU_SOPK_FORMAT} : begin
				snd_src_imm <= 1'b1;
				casex(opcode[23:0])
					// s_movk_i32	0x00
					// No special signals
					// s_addk_i32	0x0F
					24'h00000F : begin scc_en <= 1'b1; end
					// s_mulk_i32	0x10
					24'h000010 : begin scc_en <= 1'b1; end
				endcase
			end
		endcase
	end

end

always@(control_en or dst_reg or bit64_op) begin
	exec_en_dreg <= 1'b0;
	exec_ws_dreg <= 2'b00;
	vcc_en  <= 1'b0;
	vcc_ws_dreg  <= 2'b00;
	m0_en   <= 1'b0;
	sgpr_en <= 2'b00;
	casex({control_en, dst_reg})
		// SGPR
		{1'b1, 12'b110xxxxxxxxx} : begin
			sgpr_en <= bit64_op ? 2'b11 : 2'b01;
			//**change [psp]
			salu2sgpr_req_trig <= 1'b1; //request pending
			//**
		end
		// VCC_LO
		{1'b1, 12'b111000000001} : begin
			vcc_en  <= 1'b1;
			vcc_ws_dreg <= bit64_op ? 2'b11 : 2'b01;
		end
		// VCC_HI
		{1'b1, 12'b111000000010} : begin
			vcc_en  <= 1'b1;
			vcc_ws_dreg <= bit64_op ? 2'b11 : 2'b10;
			
		end
		// EXEC_LO
		{1'b1, 12'b111000001000} : begin
			exec_en_dreg <= 1'b1;
			exec_ws_dreg <= bit64_op ? 2'b11 : 2'b01;
		end
		// EXEC_HI
		{1'b1, 12'b111000010000} : begin
			exec_en_dreg <= 1'b1;
			exec_ws_dreg <= bit64_op ? 2'b11 : 2'b10;
		end
		// M0
		{1'b1, 12'b111000000100} : begin
			m0_en <= 1'b1;
		end
	endcase
end

assign exec_wordsel = exec_ws_dreg | exec_ws_op;
assign vcc_wordsel = vcc_ws_dreg | vcc_ws_op;
assign exec_en = |exec_wordsel;

endmodule
