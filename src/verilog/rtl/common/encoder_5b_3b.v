module encoder_5b_3b(
    in,
    out
);

input[4:0] in;
output[2:0] out;

reg[2:0] out;

always @(in) begin
    out = 3'h0;
    
    case(in)
        5'b00001: out = 3'h0;
        5'b00010: out = 3'h1;
        5'b00100: out = 3'h2;
        5'b01000: out = 3'h3;
        5'b10000: out = 3'h4;
        default: out = 3'h0;
    endcase
end
endmodule
