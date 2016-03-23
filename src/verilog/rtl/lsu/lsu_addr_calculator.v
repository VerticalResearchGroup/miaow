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
  out_ld_st_addr,
  out_gm_or_lds
);

input [2047:0] in_vector_source_b;
input [127:0] in_scalar_source_a;
input [31:0] in_scalar_source_b;
input [31:0] in_opcode;
input [15:0] in_lds_base;
input [15:0] in_imm_value0;

output [2047:0] out_ld_st_addr;
output out_gm_or_lds;

`define ADD_TID_ENABLE in_scalar_source_a[119]

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
        out_gm_or_lds <= 1'b0;
      end
    `LSU_DS_FORMAT:
      begin
        out_ld_st_addr <= ds_address;
        out_gm_or_lds <= 1'b1;
      end
    `LSU_MTBUF_FORMAT:
      begin
        // We suffer a architectural limitation here wherein we cannot support
        // both an offset and index value as inputs into the address
        // calculation, as that would require two vector register reads
        // instead of the one that we currently do. Proposed future solution
        // is to have the LSU be able to utilize two read ports to the VGPR to
        // facilitate two reads in a cycle instead of just one.
        out_ld_st_addr <= ({in_opcode[`LSU_MTBUF_IDXEN_POS],in_opcode[`LSU_MTBUF_OFFEN_POS]} == 2'b11) ? {2048{1'bx}} : mtbuf_address;
        out_gm_or_lds <= 1'b0;
      end
    default:
      begin
        out_ld_st_addr <= {2048{1'bx}};
        out_gm_or_lds <= 1'b0;
      end
  endcase
end

mtbuf_addr_calc mtbuf_address_calc[63:0](
  .out_addr(mtbuf_address),
  .vector_source_b(in_vector_source_b),
  .scalar_source_a(in_scalar_source_a),
  .scalar_source_b(in_scalar_source_b),
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
//   print "assign thread_id[$high:$low] = `ADD_TID_ENABLE ? 6'd$i : 6'd0;\n";
// }
// %%stop_veriperl
assign thread_id[5:0] = `ADD_TID_ENABLE ? 6'd0 : 6'd0;
assign thread_id[11:6] = `ADD_TID_ENABLE ? 6'd1 : 6'd0;
assign thread_id[17:12] = `ADD_TID_ENABLE ? 6'd2 : 6'd0;
assign thread_id[23:18] = `ADD_TID_ENABLE ? 6'd3 : 6'd0;
assign thread_id[29:24] = `ADD_TID_ENABLE ? 6'd4 : 6'd0;
assign thread_id[35:30] = `ADD_TID_ENABLE ? 6'd5 : 6'd0;
assign thread_id[41:36] = `ADD_TID_ENABLE ? 6'd6 : 6'd0;
assign thread_id[47:42] = `ADD_TID_ENABLE ? 6'd7 : 6'd0;
assign thread_id[53:48] = `ADD_TID_ENABLE ? 6'd8 : 6'd0;
assign thread_id[59:54] = `ADD_TID_ENABLE ? 6'd9 : 6'd0;
assign thread_id[65:60] = `ADD_TID_ENABLE ? 6'd10 : 6'd0;
assign thread_id[71:66] = `ADD_TID_ENABLE ? 6'd11 : 6'd0;
assign thread_id[77:72] = `ADD_TID_ENABLE ? 6'd12 : 6'd0;
assign thread_id[83:78] = `ADD_TID_ENABLE ? 6'd13 : 6'd0;
assign thread_id[89:84] = `ADD_TID_ENABLE ? 6'd14 : 6'd0;
assign thread_id[95:90] = `ADD_TID_ENABLE ? 6'd15 : 6'd0;
assign thread_id[101:96] = `ADD_TID_ENABLE ? 6'd16 : 6'd0;
assign thread_id[107:102] = `ADD_TID_ENABLE ? 6'd17 : 6'd0;
assign thread_id[113:108] = `ADD_TID_ENABLE ? 6'd18 : 6'd0;
assign thread_id[119:114] = `ADD_TID_ENABLE ? 6'd19 : 6'd0;
assign thread_id[125:120] = `ADD_TID_ENABLE ? 6'd20 : 6'd0;
assign thread_id[131:126] = `ADD_TID_ENABLE ? 6'd21 : 6'd0;
assign thread_id[137:132] = `ADD_TID_ENABLE ? 6'd22 : 6'd0;
assign thread_id[143:138] = `ADD_TID_ENABLE ? 6'd23 : 6'd0;
assign thread_id[149:144] = `ADD_TID_ENABLE ? 6'd24 : 6'd0;
assign thread_id[155:150] = `ADD_TID_ENABLE ? 6'd25 : 6'd0;
assign thread_id[161:156] = `ADD_TID_ENABLE ? 6'd26 : 6'd0;
assign thread_id[167:162] = `ADD_TID_ENABLE ? 6'd27 : 6'd0;
assign thread_id[173:168] = `ADD_TID_ENABLE ? 6'd28 : 6'd0;
assign thread_id[179:174] = `ADD_TID_ENABLE ? 6'd29 : 6'd0;
assign thread_id[185:180] = `ADD_TID_ENABLE ? 6'd30 : 6'd0;
assign thread_id[191:186] = `ADD_TID_ENABLE ? 6'd31 : 6'd0;
assign thread_id[197:192] = `ADD_TID_ENABLE ? 6'd32 : 6'd0;
assign thread_id[203:198] = `ADD_TID_ENABLE ? 6'd33 : 6'd0;
assign thread_id[209:204] = `ADD_TID_ENABLE ? 6'd34 : 6'd0;
assign thread_id[215:210] = `ADD_TID_ENABLE ? 6'd35 : 6'd0;
assign thread_id[221:216] = `ADD_TID_ENABLE ? 6'd36 : 6'd0;
assign thread_id[227:222] = `ADD_TID_ENABLE ? 6'd37 : 6'd0;
assign thread_id[233:228] = `ADD_TID_ENABLE ? 6'd38 : 6'd0;
assign thread_id[239:234] = `ADD_TID_ENABLE ? 6'd39 : 6'd0;
assign thread_id[245:240] = `ADD_TID_ENABLE ? 6'd40 : 6'd0;
assign thread_id[251:246] = `ADD_TID_ENABLE ? 6'd41 : 6'd0;
assign thread_id[257:252] = `ADD_TID_ENABLE ? 6'd42 : 6'd0;
assign thread_id[263:258] = `ADD_TID_ENABLE ? 6'd43 : 6'd0;
assign thread_id[269:264] = `ADD_TID_ENABLE ? 6'd44 : 6'd0;
assign thread_id[275:270] = `ADD_TID_ENABLE ? 6'd45 : 6'd0;
assign thread_id[281:276] = `ADD_TID_ENABLE ? 6'd46 : 6'd0;
assign thread_id[287:282] = `ADD_TID_ENABLE ? 6'd47 : 6'd0;
assign thread_id[293:288] = `ADD_TID_ENABLE ? 6'd48 : 6'd0;
assign thread_id[299:294] = `ADD_TID_ENABLE ? 6'd49 : 6'd0;
assign thread_id[305:300] = `ADD_TID_ENABLE ? 6'd50 : 6'd0;
assign thread_id[311:306] = `ADD_TID_ENABLE ? 6'd51 : 6'd0;
assign thread_id[317:312] = `ADD_TID_ENABLE ? 6'd52 : 6'd0;
assign thread_id[323:318] = `ADD_TID_ENABLE ? 6'd53 : 6'd0;
assign thread_id[329:324] = `ADD_TID_ENABLE ? 6'd54 : 6'd0;
assign thread_id[335:330] = `ADD_TID_ENABLE ? 6'd55 : 6'd0;
assign thread_id[341:336] = `ADD_TID_ENABLE ? 6'd56 : 6'd0;
assign thread_id[347:342] = `ADD_TID_ENABLE ? 6'd57 : 6'd0;
assign thread_id[353:348] = `ADD_TID_ENABLE ? 6'd58 : 6'd0;
assign thread_id[359:354] = `ADD_TID_ENABLE ? 6'd59 : 6'd0;
assign thread_id[365:360] = `ADD_TID_ENABLE ? 6'd60 : 6'd0;
assign thread_id[371:366] = `ADD_TID_ENABLE ? 6'd61 : 6'd0;
assign thread_id[377:372] = `ADD_TID_ENABLE ? 6'd62 : 6'd0;
assign thread_id[383:378] = `ADD_TID_ENABLE ? 6'd63 : 6'd0;

endmodule
