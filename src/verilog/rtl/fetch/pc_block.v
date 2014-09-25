module pc_block (
	new_pc_init, 
	wf_id, 
	wr, 
	rd_en, 
	wf_id_rd, 
	pc_read2ibuff, 
	clk, 
	rst
);

parameter BITWIDTH = 32;

input [31:0] new_pc_init;
input [5:0] wf_id;
input wr;
input clk, rst;
input rd_en;
input [5:0] wf_id_rd;

output [32:0]pc_read2ibuff;

wire write;
wire [31:0] pc_read;
wire [32:0] data0, data_flop0;
wire [32:0] data1, data_flop1;
wire [32:0] data2, data_flop2;
wire [32:0] data3, data_flop3;
wire [32:0] data4, data_flop4;
wire [32:0] data5, data_flop5;
wire [32:0] data6, data_flop6;
wire [32:0] data7, data_flop7;
wire [32:0] data8, data_flop8;
wire [32:0] data9, data_flop9;
wire [32:0] data10, data_flop10;
wire [32:0] data11, data_flop11;
wire [32:0] data12, data_flop12;
wire [32:0] data13, data_flop13;
wire [32:0] data14, data_flop14;
wire [32:0] data15, data_flop15;
wire [32:0] data16, data_flop16;
wire [32:0] data17, data_flop17;
wire [32:0] data18, data_flop18;
wire [32:0] data19, data_flop19;
wire [32:0] data20, data_flop20;
wire [32:0] data21, data_flop21;
wire [32:0] data22, data_flop22;
wire [32:0] data23, data_flop23;
wire [32:0] data24, data_flop24;
wire [32:0] data25, data_flop25;
wire [32:0] data26, data_flop26;
wire [32:0] data27, data_flop27;
wire [32:0] data28, data_flop28;
wire [32:0] data29, data_flop29;
wire [32:0] data30, data_flop30;
wire [32:0] data31, data_flop31;
wire [32:0] data32, data_flop32;
wire [32:0] data33, data_flop33;
wire [32:0] data34, data_flop34;
wire [32:0] data35, data_flop35;
wire [32:0] data36, data_flop36;
wire [32:0] data37, data_flop37;
wire [32:0] data38, data_flop38;
wire [32:0] data39, data_flop39;

   assign write = 1'b1;  

     regfile #(33) rfile0 (data0, write, data_flop0, clk, rst);
	 regfile #(33) rfile1 (data1, write, data_flop1, clk, rst);
	 regfile #(33) rfile2 (data2, write, data_flop2, clk, rst);
	 regfile #(33) rfile3 (data3, write, data_flop3, clk, rst);
	 regfile #(33) rfile4 (data4, write, data_flop4, clk, rst);
	 regfile #(33) rfile5 (data5, write, data_flop5, clk, rst);
	 regfile #(33) rfile6 (data6, write, data_flop6, clk, rst);
	 regfile #(33) rfile7 (data7, write, data_flop7, clk, rst);
	 regfile #(33) rfile8 (data8, write, data_flop8, clk, rst);
	 regfile #(33) rfile9 (data9, write, data_flop9, clk, rst);
	 regfile #(33) rfile10 (data10, write, data_flop10, clk, rst);
	 regfile #(33) rfile11 (data11, write, data_flop11, clk, rst);
	 regfile #(33) rfile12 (data12, write, data_flop12, clk, rst);
	 regfile #(33) rfile13 (data13, write, data_flop13, clk, rst);
	 regfile #(33) rfile14 (data14, write, data_flop14, clk, rst);
	 regfile #(33) rfile15 (data15, write, data_flop15, clk, rst);
	 regfile #(33) rfile16 (data16, write, data_flop16, clk, rst);
	 regfile #(33) rfile17 (data17, write, data_flop17, clk, rst);
	 regfile #(33) rfile18 (data18, write, data_flop18, clk, rst);
	 regfile #(33) rfile19 (data19, write, data_flop19, clk, rst);
	 regfile #(33) rfile20 (data20, write, data_flop20, clk, rst);
	 regfile #(33) rfile21 (data21, write, data_flop21, clk, rst);
	 regfile #(33) rfile22 (data22, write, data_flop22, clk, rst);
	 regfile #(33) rfile23 (data23, write, data_flop23, clk, rst);
	 regfile #(33) rfile24 (data24, write, data_flop24, clk, rst);
	 regfile #(33) rfile25 (data25, write, data_flop25, clk, rst);
	 regfile #(33) rfile26 (data26, write, data_flop26, clk, rst);
	 regfile #(33) rfile27 (data27, write, data_flop27, clk, rst);
	 regfile #(33) rfile28 (data28, write, data_flop28, clk, rst);
	 regfile #(33) rfile29 (data29, write, data_flop29, clk, rst);
	 regfile #(33) rfile30 (data30, write, data_flop30, clk, rst);
	 regfile #(33) rfile31 (data31, write, data_flop31, clk, rst);
	 regfile #(33) rfile32 (data32, write, data_flop32, clk, rst);
	 regfile #(33) rfile33 (data33, write, data_flop33, clk, rst);
	 regfile #(33) rfile34 (data34, write, data_flop34, clk, rst);
	 regfile #(33) rfile35 (data35, write, data_flop35, clk, rst);
	 regfile #(33) rfile36 (data36, write, data_flop36, clk, rst);
	 regfile #(33) rfile37 (data37, write, data_flop37, clk, rst);
	 regfile #(33) rfile38 (data38, write, data_flop38, clk, rst);
	 regfile #(33) rfile39 (data39, write, data_flop39, clk, rst);
	 
   adder a1(pc_read2ibuff[31:0],pc_read);
   assign pc_read2ibuff = (wf_id_rd==6'd0)?data_flop0:
                   (wf_id_rd==6'd1)?data_flop1:
				   (wf_id_rd==6'd2)?data_flop2:
				   (wf_id_rd==6'd3)?data_flop3:
				   (wf_id_rd==6'd4)?data_flop4:
				   (wf_id_rd==6'd5)?data_flop5:
				   (wf_id_rd==6'd6)?data_flop6:
				   (wf_id_rd==6'd7)?data_flop7:
				   (wf_id_rd==6'd8)?data_flop8:
				   (wf_id_rd==6'd9)?data_flop9:
				   (wf_id_rd==6'd10)?data_flop10:
				   (wf_id_rd==6'd11)?data_flop11:
				   (wf_id_rd==6'd12)?data_flop12:
				   (wf_id_rd==6'd13)?data_flop13:
				   (wf_id_rd==6'd14)?data_flop14:
				   (wf_id_rd==6'd15)?data_flop15:
				   (wf_id_rd==6'd16)?data_flop16:
				   (wf_id_rd==6'd17)?data_flop17:
				   (wf_id_rd==6'd18)?data_flop18:
				   (wf_id_rd==6'd19)?data_flop19:
				   (wf_id_rd==6'd20)?data_flop20:
				   (wf_id_rd==6'd21)?data_flop21:
				   (wf_id_rd==6'd22)?data_flop22:
				   (wf_id_rd==6'd23)?data_flop23:
				   (wf_id_rd==6'd24)?data_flop24:
				   (wf_id_rd==6'd25)?data_flop25:
				   (wf_id_rd==6'd26)?data_flop26:
				   (wf_id_rd==6'd27)?data_flop27:
				   (wf_id_rd==6'd28)?data_flop28:
				   (wf_id_rd==6'd29)?data_flop29:
				   (wf_id_rd==6'd30)?data_flop30:
				   (wf_id_rd==6'd31)?data_flop31:
				   (wf_id_rd==6'd32)?data_flop32:
				   (wf_id_rd==6'd33)?data_flop33:
				   (wf_id_rd==6'd34)?data_flop34:
				   (wf_id_rd==6'd35)?data_flop35:
				   (wf_id_rd==6'd36)?data_flop36:
				   (wf_id_rd==6'd37)?data_flop37:
				   (wf_id_rd==6'd38)?data_flop38:
				   (wf_id_rd==6'd39)?data_flop39:
                    33'd0;
  
   
   assign data0=(wr & (wf_id==6'd0))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd0))?{1'b0,pc_read}:data_flop0;
   assign data1=(wr & (wf_id==6'd1))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd1))?{1'b0,pc_read}:data_flop1;
   assign data2=(wr & (wf_id==6'd2))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd2))?{1'b0,pc_read}:data_flop2;
   assign data3=(wr & (wf_id==6'd3))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd3))?{1'b0,pc_read}:data_flop3;
   assign data4=(wr & (wf_id==6'd4))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd4))?{1'b0,pc_read}:data_flop4;
   assign data5=(wr & (wf_id==6'd5))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd5))?{1'b0,pc_read}:data_flop5;
   assign data6=(wr & (wf_id==6'd6))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd6))?{1'b0,pc_read}:data_flop6;
   assign data7=(wr & (wf_id==6'd7))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd7))?{1'b0,pc_read}:data_flop7;
   assign data8=(wr & (wf_id==6'd8))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd8))?{1'b0,pc_read}:data_flop8;
   assign data9=(wr & (wf_id==6'd9))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd9))?{1'b0,pc_read}:data_flop9;
   assign data10=(wr & (wf_id==6'd10))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd10))?{1'b0,pc_read}:data_flop10;
   assign data11=(wr & (wf_id==6'd11))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd11))?{1'b0,pc_read}:data_flop11;
   assign data12=(wr & (wf_id==6'd12))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd12))?{1'b0,pc_read}:data_flop12;
   assign data13=(wr & (wf_id==6'd13))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd13))?{1'b0,pc_read}:data_flop13;
   assign data14=(wr & (wf_id==6'd14))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd14))?{1'b0,pc_read}:data_flop14;
   assign data15=(wr & (wf_id==6'd15))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd15))?{1'b0,pc_read}:data_flop15;
   assign data16=(wr & (wf_id==6'd16))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd16))?{1'b0,pc_read}:data_flop16;
   assign data17=(wr & (wf_id==6'd17))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd17))?{1'b0,pc_read}:data_flop17;
   assign data18=(wr & (wf_id==6'd18))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd18))?{1'b0,pc_read}:data_flop18;
   assign data19=(wr & (wf_id==6'd19))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd19))?{1'b0,pc_read}:data_flop19;
   assign data20=(wr & (wf_id==6'd20))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd20))?{1'b0,pc_read}:data_flop20;
   assign data21=(wr & (wf_id==6'd21))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd21))?{1'b0,pc_read}:data_flop21;
   assign data22=(wr & (wf_id==6'd22))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd22))?{1'b0,pc_read}:data_flop22;
   assign data23=(wr & (wf_id==6'd23))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd23))?{1'b0,pc_read}:data_flop23;
   assign data24=(wr & (wf_id==6'd24))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd24))?{1'b0,pc_read}:data_flop24;
   assign data25=(wr & (wf_id==6'd25))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd25))?{1'b0,pc_read}:data_flop25;
   assign data26=(wr & (wf_id==6'd26))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd26))?{1'b0,pc_read}:data_flop26;
   assign data27=(wr & (wf_id==6'd27))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd27))?{1'b0,pc_read}:data_flop27;
   assign data28=(wr & (wf_id==6'd28))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd28))?{1'b0,pc_read}:data_flop28;
   assign data29=(wr & (wf_id==6'd29))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd29))?{1'b0,pc_read}:data_flop29;
   assign data30=(wr & (wf_id==6'd30))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd30))?{1'b0,pc_read}:data_flop30;
   assign data31=(wr & (wf_id==6'd31))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd31))?{1'b0,pc_read}:data_flop31;
   assign data32=(wr & (wf_id==6'd32))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd32))?{1'b0,pc_read}:data_flop32;
   assign data33=(wr & (wf_id==6'd33))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd33))?{1'b0,pc_read}:data_flop33;
   assign data34=(wr & (wf_id==6'd34))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd34))?{1'b0,pc_read}:data_flop34;
   assign data35=(wr & (wf_id==6'd35))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd35))?{1'b0,pc_read}:data_flop35;
   assign data36=(wr & (wf_id==6'd36))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd36))?{1'b0,pc_read}:data_flop36;
   assign data37=(wr & (wf_id==6'd37))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd37))?{1'b0,pc_read}:data_flop37;
   assign data38=(wr & (wf_id==6'd38))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd38))?{1'b0,pc_read}:data_flop38;
   assign data39=(wr & (wf_id==6'd39))? {1'b1,new_pc_init} :(rd_en & (wf_id_rd==6'd39))?{1'b0,pc_read}:data_flop39;
   

endmodule
