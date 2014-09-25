module decoder_6b_40b_en(
    addr_in,
    en,
    out);

input[5:0] addr_in; 
wire[5:0] addr_in;

output[39:0] out;
wire[39:0] out;
input en; 
wire en;

reg[39:0] decoded_out;

always@(addr_in)
begin
    decoded_out = 40'd0;
    case (addr_in)
        0: decoded_out[0]=1'b1;
        1: decoded_out[1]=1'b1;
        2: decoded_out[2]=1'b1;
        3: decoded_out[3]=1'b1;
        4: decoded_out[4]=1'b1;
        5: decoded_out[5]=1'b1;
        6: decoded_out[6]=1'b1;
        7: decoded_out[7]=1'b1;
        8: decoded_out[8]=1'b1;
        9: decoded_out[9]=1'b1;
        10: decoded_out[10]=1'b1;
        11: decoded_out[11]=1'b1;
        12: decoded_out[12]=1'b1;
        13: decoded_out[13]=1'b1;
        14: decoded_out[14]=1'b1;
        15: decoded_out[15]=1'b1;
        16: decoded_out[16]=1'b1;
        17: decoded_out[17]=1'b1;
        18: decoded_out[18]=1'b1;
        19: decoded_out[19]=1'b1;
        20: decoded_out[20]=1'b1;
        21: decoded_out[21]=1'b1;
        22: decoded_out[22]=1'b1;
        23: decoded_out[23]=1'b1;
        24: decoded_out[24]=1'b1;
        25: decoded_out[25]=1'b1;
        26: decoded_out[26]=1'b1;
        27: decoded_out[27]=1'b1;
        28: decoded_out[28]=1'b1;
        29: decoded_out[29]=1'b1;
        30: decoded_out[30]=1'b1;
        31: decoded_out[31]=1'b1;
        32: decoded_out[32]=1'b1;
        33: decoded_out[33]=1'b1;
        34: decoded_out[34]=1'b1;
        35: decoded_out[35]=1'b1;
        36: decoded_out[36]=1'b1;
        37: decoded_out[37]=1'b1;
        38: decoded_out[38]=1'b1;
        39: decoded_out[39]=1'b1;
        default: decoded_out = 40'd0;
    endcase
end

assign out = (en)?decoded_out:40'd0;

endmodule
