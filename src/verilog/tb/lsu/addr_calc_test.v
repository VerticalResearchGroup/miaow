module addr_calc_test;

wire[2047:0] out_addr;

reg[127:0] resource_buffer;
reg[2047:0] vreg_value;
reg[31:0] sreg_value;
reg[15:0] imm_value;
reg[15:0] opcode;

address_calculation adcal(out_addr, resource_buffer, vreg_value, sreg_value, imm_value, opcode);

initial
	begin
		// sbuff_load test
		resource_buffer <= 128'h02;
		vreg_value <= 2048'hx;
		sreg_value <= 32'h3;
		imm_value <= 16'h04;
		opcode <= 16'b0000_0001_0010_1000;
		#1
		$display("Out Address = %H", out_addr);
		#20
		// tbuff_load test
		resource_buffer <= 128'h02;
		vreg_value <= 2048'h01;
		sreg_value <= 32'h03;
		imm_value <= 16'h04;
		opcode <= 16'b0000_0010_0001_1000;
		#1
		$display("Out Address = %H", out_addr);
		#20
		$finish;
	end

endmodule
