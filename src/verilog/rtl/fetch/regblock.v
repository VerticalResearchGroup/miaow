module regblock(
	readdata, 
	clk, 
	rst, 
	readregsel, 
	writeregsel, 
	writedata, 
	write
);

parameter BITWIDTH = 11;

input clk, rst;
input [5:0] readregsel;
input [5:0] writeregsel;
input [(BITWIDTH-1):0] writedata;
input  write;

output [(BITWIDTH-1):0] readdata;

wire write_dff;

wire [(BITWIDTH-1):0] data0,data_flop0;
wire [(BITWIDTH-1):0] data1,data_flop1;
wire [(BITWIDTH-1):0] data2,data_flop2;
wire [(BITWIDTH-1):0] data3,data_flop3;
wire [(BITWIDTH-1):0] data4,data_flop4;
wire [(BITWIDTH-1):0] data5,data_flop5;
wire [(BITWIDTH-1):0] data6,data_flop6;
wire [(BITWIDTH-1):0] data7,data_flop7;
wire [(BITWIDTH-1):0] data8,data_flop8;
wire [(BITWIDTH-1):0] data9,data_flop9;
wire [(BITWIDTH-1):0] data10,data_flop10;
wire [(BITWIDTH-1):0] data11,data_flop11;
wire [(BITWIDTH-1):0] data12,data_flop12;
wire [(BITWIDTH-1):0] data13,data_flop13;
wire [(BITWIDTH-1):0] data14,data_flop14;
wire [(BITWIDTH-1):0] data15,data_flop15;
wire [(BITWIDTH-1):0] data16,data_flop16;
wire [(BITWIDTH-1):0] data17,data_flop17;
wire [(BITWIDTH-1):0] data18,data_flop18;
wire [(BITWIDTH-1):0] data19,data_flop19;
wire [(BITWIDTH-1):0] data20,data_flop20;
wire [(BITWIDTH-1):0] data21,data_flop21;
wire [(BITWIDTH-1):0] data22,data_flop22;
wire [(BITWIDTH-1):0] data23,data_flop23;
wire [(BITWIDTH-1):0] data24,data_flop24;
wire [(BITWIDTH-1):0] data25,data_flop25;
wire [(BITWIDTH-1):0] data26,data_flop26;
wire [(BITWIDTH-1):0] data27,data_flop27;
wire [(BITWIDTH-1):0] data28,data_flop28;
wire [(BITWIDTH-1):0] data29,data_flop29;
wire [(BITWIDTH-1):0] data30,data_flop30;
wire [(BITWIDTH-1):0] data31,data_flop31;
wire [(BITWIDTH-1):0] data32,data_flop32;
wire [(BITWIDTH-1):0] data33,data_flop33;
wire [(BITWIDTH-1):0] data34,data_flop34;
wire [(BITWIDTH-1):0] data35,data_flop35;
wire [(BITWIDTH-1):0] data36,data_flop36;
wire [(BITWIDTH-1):0] data37,data_flop37;
wire [(BITWIDTH-1):0] data38,data_flop38;
wire [(BITWIDTH-1):0] data39,data_flop39;
   
assign write_dff = 1'b1;

         regfile #(BITWIDTH) r_file0 (data0,write_dff,data_flop0,clk,rst);
	 regfile #(BITWIDTH) r_file1 (data1,write_dff,data_flop1,clk,rst);
	 regfile #(BITWIDTH) r_file2 (data2,write_dff,data_flop2,clk,rst);
	 regfile #(BITWIDTH) r_file3 (data3,write_dff,data_flop3,clk,rst);
	 regfile #(BITWIDTH) r_file4 (data4,write_dff,data_flop4,clk,rst);
	 regfile #(BITWIDTH) r_file5 (data5,write_dff,data_flop5,clk,rst);
	 regfile #(BITWIDTH) r_file6 (data6,write_dff,data_flop6,clk,rst);
	 regfile #(BITWIDTH) r_file7 (data7,write_dff,data_flop7,clk,rst);
	 regfile #(BITWIDTH) r_file8 (data8,write_dff,data_flop8,clk,rst);
	 regfile #(BITWIDTH) r_file9 (data9,write_dff,data_flop9,clk,rst);
	 regfile #(BITWIDTH) r_file10 (data10,write_dff,data_flop10,clk,rst);
	 regfile #(BITWIDTH) r_file11 (data11,write_dff,data_flop11,clk,rst);
	 regfile #(BITWIDTH) r_file12 (data12,write_dff,data_flop12,clk,rst);
	 regfile #(BITWIDTH) r_file13 (data13,write_dff,data_flop13,clk,rst);
	 regfile #(BITWIDTH) r_file14 (data14,write_dff,data_flop14,clk,rst);
	 regfile #(BITWIDTH) r_file15 (data15,write_dff,data_flop15,clk,rst);
	 regfile #(BITWIDTH) r_file16 (data16,write_dff,data_flop16,clk,rst);
	 regfile #(BITWIDTH) r_file17 (data17,write_dff,data_flop17,clk,rst);
	 regfile #(BITWIDTH) r_file18 (data18,write_dff,data_flop18,clk,rst);
	 regfile #(BITWIDTH) r_file19 (data19,write_dff,data_flop19,clk,rst);
	 regfile #(BITWIDTH) r_file20 (data20,write_dff,data_flop20,clk,rst);
	 regfile #(BITWIDTH) r_file21 (data21,write_dff,data_flop21,clk,rst);
	 regfile #(BITWIDTH) r_file22 (data22,write_dff,data_flop22,clk,rst);
	 regfile #(BITWIDTH) r_file23 (data23,write_dff,data_flop23,clk,rst);
	 regfile #(BITWIDTH) r_file24 (data24,write_dff,data_flop24,clk,rst);
	 regfile #(BITWIDTH) r_file25 (data25,write_dff,data_flop25,clk,rst);
	 regfile #(BITWIDTH) r_file26 (data26,write_dff,data_flop26,clk,rst);
	 regfile #(BITWIDTH) r_file27 (data27,write_dff,data_flop27,clk,rst);
	 regfile #(BITWIDTH) r_file28 (data28,write_dff,data_flop28,clk,rst);
	 regfile #(BITWIDTH) r_file29 (data29,write_dff,data_flop29,clk,rst);
	 regfile #(BITWIDTH) r_file30 (data30,write_dff,data_flop30,clk,rst);
	 regfile #(BITWIDTH) r_file31 (data31,write_dff,data_flop31,clk,rst);
	 regfile #(BITWIDTH) r_file32 (data32,write_dff,data_flop32,clk,rst);
	 regfile #(BITWIDTH) r_file33 (data33,write_dff,data_flop33,clk,rst);
	 regfile #(BITWIDTH) r_file34 (data34,write_dff,data_flop34,clk,rst);
	 regfile #(BITWIDTH) r_file35 (data35,write_dff,data_flop35,clk,rst);
	 regfile #(BITWIDTH) r_file36 (data36,write_dff,data_flop36,clk,rst);
	 regfile #(BITWIDTH) r_file37 (data37,write_dff,data_flop37,clk,rst);
	 regfile #(BITWIDTH) r_file38 (data38,write_dff,data_flop38,clk,rst);
	 regfile #(BITWIDTH) r_file39 (data39,write_dff,data_flop39,clk,rst);
	 
   
 assign readdata = (readregsel==6'd0)?data_flop0:
                   (readregsel==6'd1)?data_flop1:
				   (readregsel==6'd2)?data_flop2:
				   (readregsel==6'd3)?data_flop3:
				   (readregsel==6'd4)?data_flop4:
				   (readregsel==6'd5)?data_flop5:
				   (readregsel==6'd6)?data_flop6:
				   (readregsel==6'd7)?data_flop7:
				   (readregsel==6'd8)?data_flop8:
				   (readregsel==6'd9)?data_flop9:
				   (readregsel==6'd10)?data_flop10:
				   (readregsel==6'd11)?data_flop11:
				   (readregsel==6'd12)?data_flop12:
				   (readregsel==6'd13)?data_flop13:
				   (readregsel==6'd14)?data_flop14:
				   (readregsel==6'd15)?data_flop15:
				   (readregsel==6'd16)?data_flop16:
				   (readregsel==6'd17)?data_flop17:
				   (readregsel==6'd18)?data_flop18:
				   (readregsel==6'd19)?data_flop19:
				   (readregsel==6'd20)?data_flop20:
				   (readregsel==6'd21)?data_flop21:
				   (readregsel==6'd22)?data_flop22:
				   (readregsel==6'd23)?data_flop23:
				   (readregsel==6'd24)?data_flop24:
				   (readregsel==6'd25)?data_flop25:
				   (readregsel==6'd26)?data_flop26:
				   (readregsel==6'd27)?data_flop27:
				   (readregsel==6'd28)?data_flop28:
				   (readregsel==6'd29)?data_flop29:
				   (readregsel==6'd30)?data_flop30:
				   (readregsel==6'd31)?data_flop31:
				   (readregsel==6'd32)?data_flop32:
				   (readregsel==6'd33)?data_flop33:
				   (readregsel==6'd34)?data_flop34:
				   (readregsel==6'd35)?data_flop35:
				   (readregsel==6'd36)?data_flop36:
				   (readregsel==6'd37)?data_flop37:
				   (readregsel==6'd38)?data_flop38:
				   (readregsel==6'd39)?data_flop39:
                   11'd0;
   
   assign data0=(write & (writeregsel==6'd0))? writedata:data_flop0;
   assign data1=(write & (writeregsel==6'd1))? writedata:data_flop1;
   assign data2=(write & (writeregsel==6'd2))? writedata:data_flop2;
   assign data3=(write & (writeregsel==6'd3))? writedata:data_flop3;
   assign data4=(write & (writeregsel==6'd4))? writedata:data_flop4;
   assign data5=(write & (writeregsel==6'd5))? writedata:data_flop5;
   assign data6=(write & (writeregsel==6'd6))? writedata:data_flop6;
   assign data7=(write & (writeregsel==6'd7))? writedata:data_flop7;
   assign data8=(write & (writeregsel==6'd8))? writedata:data_flop8;
   assign data9=(write & (writeregsel==6'd9))? writedata:data_flop9;
   assign data10=(write & (writeregsel==6'd10))? writedata:data_flop10;
   assign data11=(write & (writeregsel==6'd11))? writedata:data_flop11;
   assign data12=(write & (writeregsel==6'd12))? writedata:data_flop12;
   assign data13=(write & (writeregsel==6'd13))? writedata:data_flop13;
   assign data14=(write & (writeregsel==6'd14))? writedata:data_flop14;
   assign data15=(write & (writeregsel==6'd15))? writedata:data_flop15;
   assign data16=(write & (writeregsel==6'd16))? writedata:data_flop16;
   assign data17=(write & (writeregsel==6'd17))? writedata:data_flop17;
   assign data18=(write & (writeregsel==6'd18))? writedata:data_flop18;
   assign data19=(write & (writeregsel==6'd19))? writedata:data_flop19;
   assign data20=(write & (writeregsel==6'd20))? writedata:data_flop20;
   assign data21=(write & (writeregsel==6'd21))? writedata:data_flop21;
   assign data22=(write & (writeregsel==6'd22))? writedata:data_flop22;
   assign data23=(write & (writeregsel==6'd23))? writedata:data_flop23;
   assign data24=(write & (writeregsel==6'd24))? writedata:data_flop24;
   assign data25=(write & (writeregsel==6'd25))? writedata:data_flop25;
   assign data26=(write & (writeregsel==6'd26))? writedata:data_flop26;
   assign data27=(write & (writeregsel==6'd27))? writedata:data_flop27;
   assign data28=(write & (writeregsel==6'd28))? writedata:data_flop28;
   assign data29=(write & (writeregsel==6'd29))? writedata:data_flop29;
   assign data30=(write & (writeregsel==6'd30))? writedata:data_flop30;
   assign data31=(write & (writeregsel==6'd31))? writedata:data_flop31;
   assign data32=(write & (writeregsel==6'd32))? writedata:data_flop32;
   assign data33=(write & (writeregsel==6'd33))? writedata:data_flop33;
   assign data34=(write & (writeregsel==6'd34))? writedata:data_flop34;
   assign data35=(write & (writeregsel==6'd35))? writedata:data_flop35;
   assign data36=(write & (writeregsel==6'd36))? writedata:data_flop36;
   assign data37=(write & (writeregsel==6'd37))? writedata:data_flop37;
   assign data38=(write & (writeregsel==6'd38))? writedata:data_flop38;
   assign data39=(write & (writeregsel==6'd39))? writedata:data_flop39;
   
endmodule

