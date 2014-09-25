module priority_encoder_40to6 (
	binary_out,
	valid,
	encoder_in,
	enable
);

output[5:0] binary_out;
output valid;

input[39:0] encoder_in;
input enable;

assign valid = (|encoder_in) & enable;

assign binary_out = (!enable) ? 6'd0 : (
		(encoder_in[0]) ? 6'd0 : 
		(encoder_in[1]) ? 6'd1 : 
		(encoder_in[2]) ? 6'd2 : 
		(encoder_in[3]) ? 6'd3 : 
		(encoder_in[4]) ? 6'd4 : 
		(encoder_in[5]) ? 6'd5 : 
		(encoder_in[6]) ? 6'd6 : 
		(encoder_in[7]) ? 6'd7 : 
		(encoder_in[8]) ? 6'd8 : 
		(encoder_in[9]) ? 6'd9 : 
		(encoder_in[10]) ? 6'd10 : 
		(encoder_in[11]) ? 6'd11 : 
		(encoder_in[12]) ? 6'd12 : 
		(encoder_in[13]) ? 6'd13 : 
		(encoder_in[14]) ? 6'd14 : 
		(encoder_in[15]) ? 6'd15 : 
		(encoder_in[16]) ? 6'd16 : 
		(encoder_in[17]) ? 6'd17 : 
		(encoder_in[18]) ? 6'd18 : 
		(encoder_in[19]) ? 6'd19 : 
		(encoder_in[20]) ? 6'd20 : 
		(encoder_in[21]) ? 6'd21 : 
		(encoder_in[22]) ? 6'd22 : 
		(encoder_in[23]) ? 6'd23 : 
		(encoder_in[24]) ? 6'd24 : 
		(encoder_in[25]) ? 6'd25 : 
		(encoder_in[26]) ? 6'd26 : 
		(encoder_in[27]) ? 6'd27 : 
		(encoder_in[28]) ? 6'd28 : 
		(encoder_in[29]) ? 6'd29 : 
		(encoder_in[30]) ? 6'd30 : 
		(encoder_in[31]) ? 6'd31 : 
		(encoder_in[32]) ? 6'd32 : 
		(encoder_in[33]) ? 6'd33 : 
		(encoder_in[34]) ? 6'd34 : 
		(encoder_in[35]) ? 6'd35 : 
		(encoder_in[36]) ? 6'd36 : 
		(encoder_in[37]) ? 6'd37 : 
		(encoder_in[38]) ? 6'd38 : 
		(encoder_in[39]) ? 6'd39 : {6{1'bx}}); 

endmodule
