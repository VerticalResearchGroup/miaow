`define SALU_SOPP_FORMAT 8'h01
`define SALU_SOP1_FORMAT 8'h02
`define SALU_SOPC_FORMAT 8'h04
`define SALU_SOP2_FORMAT 8'h08
`define SALU_SOPK_FORMAT 8'h10

module scalar_alu(
    s1,
    s2,
    exec,
    control,
    scc,
    b64_op,
    out,
    scc_val
);

integer i;

input[63:0] s1, s2, exec;
input[31:0] control;
input b64_op, scc;

output[63:0] out;
output scc_val;

reg scc_val;

reg infogen;
reg [31:0] partial_sum, out_low, out_hi;

wire [31:0] s1_low, s2_low;

assign s1_low = s1[31:0];
assign s2_low = s2[31:0];

assign out = b64_op ? {out_hi, out_low} : {32'bx, out_low};

always@(s1 or s2 or control)
begin
    // setting out for instructions
    casex(control[31:24])
        // SOPP
        {`SALU_SOPP_FORMAT} : begin
            infogen     = 1'bx;
            partial_sum = 32'bx;
            out_hi = 32'bx;

            casex(control[23:0])
                // s_branch    0x02
                24'h000002 : begin out_low = s1_low + s2_low*4 + 4; end
                // s_cbranch_scc0  0x04
                24'h000004 : begin out_low = s1_low + s2_low*4 + 4; end
                // s_cbranch_scc1  0x05
                24'h000005 : begin out_low = s1_low + s2_low*4 + 4; end
                // s_cbranch_vccz  0x06
                24'h000006 : begin out_low = s1_low + s2_low*4 + 4; end
                // s_cbranch_execz 0x08
                24'h000008 : begin out_low = s1_low + s2_low*4 + 4; end
                default : begin out_low = 32'bx; end
            endcase
        end

        // SOP1
        {`SALU_SOP1_FORMAT} : begin
            infogen     = 1'bx;
            partial_sum = 32'bx;

            casex(control[23:0])
                // s_mov_b32    0x03
                24'h000003 : begin
                               out_low = s1_low;
                               out_hi = 32'bx;
                             end
                // s_mov_b64    0x04
                24'h000004 : begin {out_hi, out_low} = s1; end
		// s_cmov_b32	0x05
		24'h000005 : begin
			       if(scc) begin
				 out_low <= s1_low;
			 	end
			     end
                // s_not_b32    0x07
                24'h000007 : begin
                               out_low = ~s1_low;
                               out_hi = 32'bx;
                             end
		// s_brev_b32	0x0B
		24'h00000B : begin
				for(i = 0; i < 32; i = i + 1)
				  out_low[i] <= s1_low[31 - i];
			     end
		// s_sext_i32_i8    0x19
		24'h000019 : begin
				out_low <= {{24{s1_low[7]}}, s1_low[7:0]};
			     end
                // s_and_saveexec_b64   0x24
                24'h000024 : begin {out_hi, out_low} = s1 & exec; end
                // default
                default : begin
                               out_low = 32'bx;
                               out_hi = 32'bx;
                          end
            endcase
        end

        // SOP2
        {`SALU_SOP2_FORMAT} : begin
            casex(control[23:0])
                // s_add_u32    0x00
                24'h000000 : begin
                    {infogen, out_low} = s1_low + s2_low;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
                // s_sub_u32    0x01
                24'h000001 : begin
                    {infogen, out_low} = s1_low - s2_low;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
                // s_add_i32    0x02
                24'h000002 : begin
                    {infogen, out_low} = s1_low + s2_low;
                    partial_sum = s1_low[30:0] + s2_low[30:0];
                    out_hi = 32'bx;
                end
                // s_sub_i32    0x03
                24'h000003 : begin
                    {infogen, out_low} = s1_low - s2_low;
                    partial_sum = s1_low[30:0] + (~(s2_low[30:0])) + 31'b1;
                    out_hi = 32'bx;
                end
                // s_min_u32    0x07
                24'h000007 : begin
                    out_low     = (s1_low < s2_low) ? s1_low : s2_low;
                    infogen     = s1_low < s2_low;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
                // s_max_i32    0x08
                24'h000008 : begin
                    out_low     = (s1_low > s2_low) ? s1_low : s2_low;
                    infogen     = s1_low > s2_low;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
                // s_max_u32    0x09
                24'h000009 : begin
                    out_low     = (s1_low > s2_low) ? s1_low : s2_low;
                    infogen     = s1_low > s2_low;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
		// s_cselect_b32
		24'h00000A : begin
                    out_low <= scc ? s1_low : s2_low;
                end
                // s_and_b32    0x0E
                24'h00000e : begin
                    out_low     = s1_low & s2_low;
                    infogen     = 1'bx;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
                // s_and_b64    0x0F
                24'h00000f : begin
                    {out_hi, out_low} = s1 & s2;
                    infogen           = 1'bx;
                    partial_sum       = 32'bx;
                end
                // s_or_b64    0x11
                24'h000011 : begin
                    {out_hi, out_low} = s1 | s2;
                    infogen           = 1'bx;
                    partial_sum       = 32'bx;
                end
                // s_or_b32     0x10
                24'h000010 : begin
                    out_low     = s1_low | s2_low;
                    infogen     = 1'bx;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
                // s_andn2_b64  0x15
                24'h000015 : begin
                    {out_hi, out_low} = s1 & ~s2;
                    infogen           = 1'bx;
                    partial_sum       = 32'bx;
                end
                // s_lshl_b32   0x1E
                24'h00001e : begin
                    out_low     = s1_low << s2_low[4:0];
                    infogen     = 1'bx;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
                // s_lshr_b32   0x20
                24'h000020 : begin
                    out_low     = s1_low >> s2_low[4:0];
                    infogen     = 1'bx;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
                // s_ashr_i32   0x22
                24'h000022 : begin
                    out_low     = s1_low >>> s2_low[4:0];
                    infogen     = 1'bx;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
                // s_mul_i32    0x26
                24'h000026 : begin
                    out_low     = s1_low * s2_low;
                    infogen     = 1'bx;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
                default : begin
                    out_low     = 32'bx;
                    infogen     = 1'bx;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
            endcase
        end

        // SOPC
        {`SALU_SOPC_FORMAT} : begin
            out_low     = 32'bx;
            partial_sum = 32'bx;

            casex(control[23:0])
                // s_cmp_eq_i32 0x00
                24'h000000 : begin infogen = s1_low == s2_low;
                                   out_hi = 32'bx;
                             end
                // s_cmp_lg_i32 0x01 - VIN
                24'h000001 : begin infogen = s1_low != s2_low;
                                   out_hi = 32'bx;
                             end
                // s_cmp_gt_i32 0x02 - VIN
                24'h000002 : begin
				   if(s1_low[31] == 1'b1 & s2_low[31] == 1'b1)
				     begin
				       infogen = s1_low < s2_low;
                        	       out_hi = 32'bx;
                      		     end
				   else if(s1_low[31] == 1'b1)
				     begin
				       infogen = 1'b0;
                                       out_hi = 32'bx;
				     end
				   else if(s2_low[31] == 1'b1)
				     begin
				       infogen = 1'b1;
                                       out_hi = 32'bx;
				     end
				   else
				     begin
				       infogen = s1_low > s2_low;
                        	       out_hi = 32'bx;
				     end
			     end
                // s_cmp_ge_i32 0x03 - VIN
                24'h000003 : begin
				if(s1_low[31] == 1'b1 & s2_low[31] == 1'b1)
											begin
												infogen = s1_low <= s2_low;
                        out_hi = 32'bx;
                      end
										else if(s1_low[31] == 1'b1)
											begin
												infogen = 1'b0;
                        out_hi = 32'bx;
										  end
										else if(s2_low[31] == 1'b1)
											begin
												infogen = 1'b1;
                        out_hi = 32'bx;
											end
										else
											begin
												infogen = s1_low >= s2_low;
                        out_hi = 32'bx;
											end
								end
                // s_cmp_lt_i32 0x04 - VIN
                24'h000004 : begin
                    if (s1_low[31] == 1'b1 & s2_low[31] == 1'b1)
                      begin
                        infogen = s1_low > s2_low;
                        out_hi = 32'bx;
                      end
                    else if (s1_low[31] == 1'b1)
                      begin
                        infogen = 1'b1;
                        out_hi = 32'bx;
                      end
                    else if (s2_low[31] == 1'b1)
                      begin
                        infogen = 1'b0;
                        out_hi = 32'bx;
                      end
                    else
                      begin
                        infogen = s1_low < s2_low;
                        out_hi = 32'bx;
                      end
                end
                // s_cmp_le_i32 0x05 - VIN
                24'h000005 : begin
                    if (s1_low[31] == 1'b1 & s2_low[31] == 1'b1)
                      begin
                        infogen = s1_low >= s2_low;
                        out_hi = 32'bx;
                      end
                    else if (s1_low[31] == 1'b1)
                      begin
                        infogen = 1'b1;
                        out_hi = 32'bx;
                      end
                    else if (s2_low[31] == 1'b1)
                      begin
                        infogen = 1'b0;
                        out_hi = 32'bx;
                      end
                    else
                      begin
                        infogen = s1_low <= s2_low;
                        out_hi = 32'bx;
                      end
                end
		// s_cmp_eq_u32 0x06 - VIN
                24'h000006 : begin infogen = s1_low == s2_low;
                                   out_hi = 32'bx;
			     end
		// s_cmp_lg_u32 0x07 - VIN
                24'h000007 : begin infogen = s1_low != s2_low;
                                   out_hi = 32'bx;
			     end
		// s_cmp_gt_u32 0x08 - VIN
                24'h000008 : begin infogen = s1_low > s2_low;
                                   out_hi = 32'bx;
		             end
		// s_cmp_ge_u32 0x09
                24'h000009 : begin infogen = s1_low >= s2_low;
                                   out_hi = 32'bx;
			     end
		// s_cmp_lt_u32 0x0A - VIN
                24'h00000A : begin infogen = s1_low < s2_low;
                                   out_hi = 32'bx;
                             end
                // s_cmp_le_u32 0x0B
                24'h00000B : begin infogen = s1_low <= s2_low;
                                   out_hi = 32'bx;
                             end
                // default
                default : begin infogen = 1'bx;
                                out_hi = 32'bx;
                          end
            endcase
        end

        // SOPK
        {`SALU_SOPK_FORMAT} : begin
            casex(control[23:0])
                // s_movk_i32   0x00
                24'h000000 : begin
                    out_low = s2_low;
                    infogen = 1'bx;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
                // s_addk_i32   0x0F
                24'h00000F : begin
                    {infogen, out_low} = s1_low + s2_low;
                    partial_sum = s1_low[30:0] + s2_low[30:0];
                    out_hi = 32'bx;
                end
                // s_mulk_i32   0x10
                24'h000010 : begin
                    {infogen, out_low} = s1_low * s2_low;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
                // default
                default : begin
                    out_low = 32'bx;
                    infogen = 1'bx;
                    partial_sum = 32'bx;
                    out_hi = 32'bx;
                end
            endcase
        end
        default : begin
            out_low     = 32'bx;
            infogen     = 1'bx;
            partial_sum = 32'bx;
            out_hi = 32'bx;
        end
    endcase
end

always@(control or out_low or out or infogen or partial_sum)
begin
    scc_val = 1'bx;

    // setting scc_val for instruction that write to scc
    casex(control[31:24])
        // SOPP
        // no instruction set scc

        // SOP1
        {`SALU_SOP1_FORMAT} : begin
            casex(control[23:0])
                // s_not_b32    0x07
                24'h000007 : begin scc_val = (|out_low); end
                // s_and_saveexec_b64   0x24
                24'h000024 : begin scc_val = (|out); end
                // default
                default : begin scc_val = 1'bx; end
            endcase
        end

        // SOP2
        {`SALU_SOP2_FORMAT} : begin
            casex(control[23:0])
                // s_add_u32    0x00
                24'h000000 : begin scc_val = infogen; end
                // s_sub_u32    0x01
                24'h000001 : begin scc_val = infogen; end
                // s_add_i32    0x02
                24'h000002 : begin scc_val = partial_sum[31] ^ infogen; end
                // s_sub_i32    0x03
                24'h000003 : begin scc_val = partial_sum[31] ^ infogen; end
                // s_min_u32    0x07
                24'h000007 : begin scc_val = infogen; end
                // s_max_i32    0x08
                24'h000008 : begin scc_val = infogen; end
                // s_max_u32    0x09
                24'h000009 : begin scc_val = infogen; end
                // s_and_b32    0x0E
                24'h00000E : begin scc_val = |out_low; end
                // s_and_b64    0x0F
                24'h00000F : begin scc_val = |out; end
                // s_or_b32     0x10
                24'h000010 : begin scc_val = |out_low; end
                // s_or_b64     0x11
                24'h000011 : begin scc_val = |out; end
                // s_andn2_b64  0x15
                24'h000015 : begin scc_val = |out; end
                // s_lshl_b32   0x1E
                24'h00001E : begin scc_val = |out_low; end
                // s_lshr_b32   0x20
                24'h000020 : begin scc_val = |out_low; end
                // s_ashr_i32   0x22
                24'h000022 : begin scc_val = |out_low; end
                // default
                default : begin scc_val = 1'bx; end
            endcase
        end

        // SOPC
        {`SALU_SOPC_FORMAT} : begin
            casex(control[23:0])
                // s_cmp_eq_i32 0x00
                24'h000000 : begin scc_val = infogen; end
                // s_cmp_lg_i32 0x01
                24'h000001 : begin scc_val = infogen; end
                // s_cmp_gt_i32 0x02
                24'h000002 : begin scc_val = infogen; end
                // s_cmp_ge_i32 0x03
                24'h000003 : begin scc_val = infogen; end
                // s_cmp_lt_i32 0x04
                24'h000004 : begin scc_val = infogen; end
                // s_cmp_le_i32 0x05
                24'h000005 : begin scc_val = infogen; end
                // s_cmp_eq_u32 0x06
                24'h000006 : begin scc_val = infogen; end
                // s_cmp_lg_u32 0x07
                24'h000007 : begin scc_val = infogen; end
								// s_cmp_gt_u32 0x08
                24'h000008 : begin scc_val = infogen; end
								// s_cmp_ge_u32 0x09
                24'h000009 : begin scc_val = infogen; end
                // s_cmp_lt_u32 0x0A
                24'h00000A : begin scc_val = infogen; end
                // s_cmp_le_u32 0x0B
                24'h00000B : begin scc_val = infogen; end
                // default
                default : begin scc_val = 1'bx; end
            endcase
        end

        // SOPK
        {`SALU_SOPK_FORMAT} : begin
            casex(control[23:0])
                // s_addk_i32   0x0F
                24'h00000F : begin scc_val = partial_sum[31] ^ infogen; end
                // s_mulk_i32   0x10
                24'h000010 : begin scc_val = infogen; end
                // default
                default : begin scc_val = 1'bx; end
            endcase
        end
    endcase
end

endmodule
