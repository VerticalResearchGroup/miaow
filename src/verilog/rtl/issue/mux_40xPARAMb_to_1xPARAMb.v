module mux_40xPARAMb_to_1xPARAMb(
            out,
            in,
            select );

    parameter WORD_WIDTH = 12; 

    input[40*WORD_WIDTH-1:0] in;
    input[5:0] select;
    output[WORD_WIDTH-1:0] out;
    
    reg[WORD_WIDTH-1:0] out;
    always @(in or select) begin
        casex(select)
            6'h00: out = in[1*WORD_WIDTH-1:0*WORD_WIDTH];
            6'h01: out = in[2*WORD_WIDTH-1:1*WORD_WIDTH];
            6'h02: out = in[3*WORD_WIDTH-1:2*WORD_WIDTH];
            6'h03: out = in[4*WORD_WIDTH-1:3*WORD_WIDTH];
            6'h04: out = in[5*WORD_WIDTH-1:4*WORD_WIDTH];
            6'h05: out = in[6*WORD_WIDTH-1:5*WORD_WIDTH];
            6'h06: out = in[7*WORD_WIDTH-1:6*WORD_WIDTH];
            6'h07: out = in[8*WORD_WIDTH-1:7*WORD_WIDTH];
            6'h08: out = in[9*WORD_WIDTH-1:8*WORD_WIDTH];
            6'h09: out = in[10*WORD_WIDTH-1:9*WORD_WIDTH];
            6'h0a: out = in[11*WORD_WIDTH-1:10*WORD_WIDTH];
            6'h0b: out = in[12*WORD_WIDTH-1:11*WORD_WIDTH];
            6'h0c: out = in[13*WORD_WIDTH-1:12*WORD_WIDTH];
            6'h0d: out = in[14*WORD_WIDTH-1:13*WORD_WIDTH];
            6'h0e: out = in[15*WORD_WIDTH-1:14*WORD_WIDTH];
            6'h0f: out = in[16*WORD_WIDTH-1:15*WORD_WIDTH];
            6'h10: out = in[17*WORD_WIDTH-1:16*WORD_WIDTH];
            6'h11: out = in[18*WORD_WIDTH-1:17*WORD_WIDTH];
            6'h12: out = in[19*WORD_WIDTH-1:18*WORD_WIDTH];
            6'h13: out = in[20*WORD_WIDTH-1:19*WORD_WIDTH];
            6'h14: out = in[21*WORD_WIDTH-1:20*WORD_WIDTH];
            6'h15: out = in[22*WORD_WIDTH-1:21*WORD_WIDTH];
            6'h16: out = in[23*WORD_WIDTH-1:22*WORD_WIDTH];
            6'h17: out = in[24*WORD_WIDTH-1:23*WORD_WIDTH];
            6'h18: out = in[25*WORD_WIDTH-1:24*WORD_WIDTH];
            6'h19: out = in[26*WORD_WIDTH-1:25*WORD_WIDTH];
            6'h1a: out = in[27*WORD_WIDTH-1:26*WORD_WIDTH];
            6'h1b: out = in[28*WORD_WIDTH-1:27*WORD_WIDTH];
            6'h1c: out = in[29*WORD_WIDTH-1:28*WORD_WIDTH];
            6'h1d: out = in[30*WORD_WIDTH-1:29*WORD_WIDTH];
            6'h1e: out = in[31*WORD_WIDTH-1:30*WORD_WIDTH];
            6'h1f: out = in[32*WORD_WIDTH-1:31*WORD_WIDTH];
            6'h20: out = in[33*WORD_WIDTH-1:32*WORD_WIDTH];
            6'h21: out = in[34*WORD_WIDTH-1:33*WORD_WIDTH];
            6'h22: out = in[35*WORD_WIDTH-1:34*WORD_WIDTH];
            6'h23: out = in[36*WORD_WIDTH-1:35*WORD_WIDTH];
            6'h24: out = in[37*WORD_WIDTH-1:36*WORD_WIDTH];
            6'h25: out = in[38*WORD_WIDTH-1:37*WORD_WIDTH];
            6'h26: out = in[39*WORD_WIDTH-1:38*WORD_WIDTH];
            6'h27: out = in[40*WORD_WIDTH-1:39*WORD_WIDTH];
            default: out = {(WORD_WIDTH){1'bX}};
        endcase
    end
endmodule
