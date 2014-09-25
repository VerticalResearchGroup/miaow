module src_mux (
 src_constant,
 sgpr_rd_data,
 vgpr_source_data,
 exec_rd_exec_value,
 exec_rd_vcc_value,
 exec_rd_m0_value,
 exec_rd_scc_value,
 literal_constant,
 source_mux_select,
 source_data
);

input [9:0] src_constant;
input [31:0] sgpr_rd_data;
input [2047:0] vgpr_source_data;
input [63:0] exec_rd_exec_value;
input [63:0] exec_rd_vcc_value;
input [31:0] exec_rd_m0_value;
input exec_rd_scc_value;
input [3:0] source_mux_select;
input [31:0] literal_constant;
output [2047:0] source_data;

reg [2047:0] source_data;

always @ (src_constant or sgpr_rd_data or
 vgpr_source_data or exec_rd_exec_value or
 exec_rd_vcc_value or source_mux_select or literal_constant) begin

	casex(source_mux_select)
		4'b0000 : source_data <= {64{literal_constant}};
		4'b0001 : source_data <= {64{{22{src_constant[9]}}, src_constant}};
		4'b0010 : source_data <= vgpr_source_data;
		4'b0011 : source_data <= {64{sgpr_rd_data}};
		4'b0100 : source_data <= {64{exec_rd_vcc_value[31:0]}};
		4'b0101 : source_data <= {64{exec_rd_vcc_value[63:32]}};
		4'b0110 : source_data <= {64{exec_rd_m0_value}};
		4'b0111 : source_data <= {64{exec_rd_exec_value[31:0]}};
		4'b1000 : source_data <= {64{exec_rd_exec_value[63:32]}};
		4'b1001 : source_data <= {64{31'b0, !(&exec_rd_vcc_value)}};
		4'b1010 : source_data <= {64{31'b0, !(&exec_rd_exec_value)}};
		4'b1011 : source_data <= {64{31'b0, exec_rd_scc_value}};
		default: source_data <= {2048{1'bx}};
	endcase
end

endmodule
