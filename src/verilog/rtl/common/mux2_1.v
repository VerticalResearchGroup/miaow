module mux2_1(InA,InB,S,out);
input InA,InB,S;
output out;
wire a1,a2,n1;

not1 n5(S,n1);
nand2 n4(InA,n1,a1);
nand2 n2(InB,S,a2);
nand2 n3(a1,a2,out);

endmodule
