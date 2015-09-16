`define LSU_SMRD_FORMAT 8'h01
`define LSU_DS_FORMAT 8'h02
`define LSU_MTBUF_FORMAT 8'h04

`define LSU_SMRD_IMM_POS 23
`define LSU_DS_GDS_POS 23
`define LSU_MTBUF_IDXEN_POS 12
`define LSU_MTBUF_OFFEN_POS 11

module lsu_addr_calculator(
  in_vector_source_b,
  in_scalar_source_a,
  in_scalar_source_b,
  in_opcode,
  in_lds_base,
  in_imm_value0,
  in_exec_value,
  out_exec_value,
  out_ld_st_addr,
  out_gm_or_lds
);

input [2047:0] in_vector_source_b;
input [127:0] in_scalar_source_a;
input [31:0] in_scalar_source_b;
input [31:0] in_opcode;
input [15:0] in_lds_base;
input [15:0] in_imm_value0;
input [63:0] in_exec_value;

output [63:0] out_exec_value;
output [2047:0] out_ld_st_addr;
output out_gm_or_lds;

reg [63:0] out_exec_value;
reg [2047:0] out_ld_st_addr;
reg out_gm_or_lds;
wire [383:0] thread_id;
wire [2047:0] mtbuf_address;
wire [2047:0]ds_address;

always @(*)
begin
  casex(in_opcode[31:24])
    `LSU_SMRD_FORMAT:
      begin
        //Only 32 bits of the result is the address
        //Other bits are ignored since exec mask is 64'd1
        out_ld_st_addr <= in_scalar_source_a[47:0] + (in_opcode[`LSU_SMRD_IMM_POS] ? (in_imm_value0 * 4) : in_scalar_source_b);
        out_exec_value <= 64'd1;
        out_gm_or_lds <= 1'b0;
      end
    `LSU_DS_FORMAT:
      begin
        out_ld_st_addr <= ds_address;
        out_exec_value <= in_exec_value;
        out_gm_or_lds <= 1'b1;
      end
    `LSU_MTBUF_FORMAT:
      begin
        out_ld_st_addr <= ({in_opcode[`LSU_MTBUF_IDXEN_POS],in_opcode[`LSU_MTBUF_OFFEN_POS]} == 2'b11) ? {2048{1'bx}} : mtbuf_address;
        out_exec_value <= in_exec_value;
        out_gm_or_lds <= 1'b0;
      end
    default:
      begin
        out_ld_st_addr <= {2048{1'bx}};
        out_exec_value <= {63{1'bx}};
        out_gm_or_lds <= 1'bx;
      end
  endcase
end

mtbuf_addr_calc mtbuf_address_calc[63:0](
  .out_addr(mtbuf_address),
  .vector_source_b(in_vector_source_b),
  .scalar_source_a(in_scalar_source_a),
  .imm_value0(in_imm_value0),
  .idx_en(in_opcode[`LSU_MTBUF_IDXEN_POS]),
  .off_en(in_opcode[`LSU_MTBUF_OFFEN_POS]),
  .tid(thread_id)
);

ds_addr_calc ds_address_calc[63:0](
  .lds_base(in_lds_base),
  .in_addr(in_vector_source_b),
  .out_addr(ds_address)
);


// %%start_veriperl
// my $i;
// my $high;
// my $low;
// for($i=0; $i<64; $i=$i+1)
// {
//   $high = (($i+1)*6) - 1;
//   $low = $i * 6;
//   print "assign thread_id[$high:$low] = 6'd$i;\n";
// }
// %%stop_veriperl
assign thread_id[5:0] = 6'd0;
assign thread_id[11:6] = 6'd1;
assign thread_id[17:12] = 6'd2;
assign thread_id[23:18] = 6'd3;
assign thread_id[29:24] = 6'd4;
assign thread_id[35:30] = 6'd5;
assign thread_id[41:36] = 6'd6;
assign thread_id[47:42] = 6'd7;
assign thread_id[53:48] = 6'd8;
assign thread_id[59:54] = 6'd9;
assign thread_id[65:60] = 6'd10;
assign thread_id[71:66] = 6'd11;
assign thread_id[77:72] = 6'd12;
assign thread_id[83:78] = 6'd13;
assign thread_id[89:84] = 6'd14;
assign thread_id[95:90] = 6'd15;
assign thread_id[101:96] = 6'd16;
assign thread_id[107:102] = 6'd17;
assign thread_id[113:108] = 6'd18;
assign thread_id[119:114] = 6'd19;
assign thread_id[125:120] = 6'd20;
assign thread_id[131:126] = 6'd21;
assign thread_id[137:132] = 6'd22;
assign thread_id[143:138] = 6'd23;
assign thread_id[149:144] = 6'd24;
assign thread_id[155:150] = 6'd25;
assign thread_id[161:156] = 6'd26;
assign thread_id[167:162] = 6'd27;
assign thread_id[173:168] = 6'd28;
assign thread_id[179:174] = 6'd29;
assign thread_id[185:180] = 6'd30;
assign thread_id[191:186] = 6'd31;
assign thread_id[197:192] = 6'd32;
assign thread_id[203:198] = 6'd33;
assign thread_id[209:204] = 6'd34;
assign thread_id[215:210] = 6'd35;
assign thread_id[221:216] = 6'd36;
assign thread_id[227:222] = 6'd37;
assign thread_id[233:228] = 6'd38;
assign thread_id[239:234] = 6'd39;
assign thread_id[245:240] = 6'd40;
assign thread_id[251:246] = 6'd41;
assign thread_id[257:252] = 6'd42;
assign thread_id[263:258] = 6'd43;
assign thread_id[269:264] = 6'd44;
assign thread_id[275:270] = 6'd45;
assign thread_id[281:276] = 6'd46;
assign thread_id[287:282] = 6'd47;
assign thread_id[293:288] = 6'd48;
assign thread_id[299:294] = 6'd49;
assign thread_id[305:300] = 6'd50;
assign thread_id[311:306] = 6'd51;
assign thread_id[317:312] = 6'd52;
assign thread_id[323:318] = 6'd53;
assign thread_id[329:324] = 6'd54;
assign thread_id[335:330] = 6'd55;
assign thread_id[341:336] = 6'd56;
assign thread_id[347:342] = 6'd57;
assign thread_id[353:348] = 6'd58;
assign thread_id[359:354] = 6'd59;
assign thread_id[365:360] = 6'd60;
assign thread_id[371:366] = 6'd61;
assign thread_id[377:372] = 6'd62;
assign thread_id[383:378] = 6'd63;

endmodule
