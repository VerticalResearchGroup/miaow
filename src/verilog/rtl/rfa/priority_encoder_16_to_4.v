module priority_encoder_16_to_4 (
   out,
   in,
   enable
);

output[3:0] out;
input[15:0] in;
input enable;

assign out =
      (!enable) ? 4'd0 : (
      (in[0]) ? 4'd0 :
      (in[1]) ? 4'd1 :
      (in[2]) ? 4'd2 :
      (in[3]) ? 4'd3 :
      (in[4]) ? 4'd4 :
      (in[5]) ? 4'd5 :
      (in[6]) ? 4'd6 :
      (in[7]) ? 4'd7 :
      (in[8]) ? 4'd8 :
      (in[9]) ? 4'd9 :
      (in[10]) ? 4'd10 :
      (in[11]) ? 4'd11 :
      (in[12]) ? 4'd12 :
      (in[13]) ? 4'd13 :
      (in[14]) ? 4'd14 :
      (in[15]) ? 4'd15 :  {4{1'bx}});

endmodule
