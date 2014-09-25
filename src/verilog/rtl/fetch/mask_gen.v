module mask_gen(in,out);

input [5:0]in;
output [63:0]out;

assign out = (in == 6'd0) ? 64'h0000000000000001:
             (in == 6'd1) ? 64'h0000000000000003:
			 (in == 6'd2) ? 64'h0000000000000007:
			 (in == 6'd3) ? 64'h000000000000000f:
			 (in == 6'd4) ? 64'h000000000000001f:
			 (in == 6'd5) ? 64'h000000000000003f:
			 (in == 6'd6) ? 64'h000000000000007f:
			 (in == 6'd7) ? 64'h00000000000000ff:
			 (in == 6'd8) ? 64'h00000000000001ff:
			 (in == 6'd9) ? 64'h00000000000003ff:
			 (in == 6'd10) ? 64'h00000000000007ff:
			 (in == 6'd11) ? 64'h0000000000000fff:
			 (in == 6'd12) ? 64'h0000000000001fff:
			 (in == 6'd13) ? 64'h0000000000003fff:
			 (in == 6'd14) ? 64'h0000000000007fff:
			 (in == 6'd15) ? 64'h000000000000ffff:
			 (in == 6'd16) ? 64'h000000000001ffff:
			 (in == 6'd17) ? 64'h000000000003ffff:
			 (in == 6'd18) ? 64'h000000000007ffff:
			 (in == 6'd19) ? 64'h00000000000fffff:
			 (in == 6'd20) ? 64'h00000000001fffff:
			 (in == 6'd21) ? 64'h00000000003fffff:
			 (in == 6'd22) ? 64'h00000000007fffff:
			 (in == 6'd23) ? 64'h0000000000ffffff:
			 (in == 6'd24) ? 64'h0000000001ffffff:
			 (in == 6'd25) ? 64'h0000000003ffffff:
			 (in == 6'd26) ? 64'h0000000007ffffff:
			 (in == 6'd27) ? 64'h000000000fffffff:
			 (in == 6'd28) ? 64'h000000001fffffff:
			 (in == 6'd29) ? 64'h000000003fffffff:
			 (in == 6'd30) ? 64'h000000007fffffff:
			 (in == 6'd31) ? 64'h00000000ffffffff:
			 (in == 6'd32) ? 64'h00000001ffffffff:
			 (in == 6'd33) ? 64'h00000003ffffffff:
			 (in == 6'd34) ? 64'h00000007ffffffff:
			 (in == 6'd35) ? 64'h0000000fffffffff:
			 (in == 6'd36) ? 64'h0000001fffffffff:
			 (in == 6'd37) ? 64'h0000003fffffffff:
			 (in == 6'd38) ? 64'h0000007fffffffff:
			 (in == 6'd39) ? 64'h000000ffffffffff:
			 (in == 6'd40) ? 64'h000001ffffffffff:
			 (in == 6'd41) ? 64'h000003ffffffffff:
			 (in == 6'd42) ? 64'h000007ffffffffff:
			 (in == 6'd43) ? 64'h00000fffffffffff:
			 (in == 6'd44) ? 64'h00001fffffffffff:
			 (in == 6'd45) ? 64'h00003fffffffffff:
			 (in == 6'd46) ? 64'h00007fffffffffff:
			 (in == 6'd47) ? 64'h0000ffffffffffff:
			 (in == 6'd48) ? 64'h0001ffffffffffff:
			 (in == 6'd49) ? 64'h0003ffffffffffff:
			 (in == 6'd50) ? 64'h0007ffffffffffff:
			 (in == 6'd51) ? 64'h000fffffffffffff:
			 (in == 6'd52) ? 64'h001fffffffffffff:
			 (in == 6'd53) ? 64'h003fffffffffffff:
			 (in == 6'd54) ? 64'h007fffffffffffff:
			 (in == 6'd55) ? 64'h00ffffffffffffff:
			 (in == 6'd56) ? 64'h01ffffffffffffff:
			 (in == 6'd57) ? 64'h03ffffffffffffff:
			 (in == 6'd58) ? 64'h07ffffffffffffff:
			 (in == 6'd59) ? 64'h0fffffffffffffff:
			 (in == 6'd60) ? 64'h1fffffffffffffff:
			 (in == 6'd61) ? 64'h3fffffffffffffff:
			 (in == 6'd62) ? 64'h7fffffffffffffff:
			 (in == 6'd63) ? 64'hffffffffffffffff:
			 64'd0;
			 
endmodule