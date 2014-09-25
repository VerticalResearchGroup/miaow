module memory_tb();

reg clk;
reg rst;

reg[3:0] rd_en, wr_en;
reg[6:0] input_tag;
reg[63:0] wr_mask;
reg[2047:0] addresses;
reg[8191:0] wr_data;

wire ack;
wire[6:0] output_tag;
wire[2047:0] tracemon_addr;
wire[8191:0] rd_data, tracemon_store_data;

memory mem(
      rd_en,
      wr_en,
      addresses,
      wr_data,
      input_tag,
      wr_mask,
      rd_data,
      output_tag,
      ack,
      tracemon_addr,
      tracemon_store_data,
      clk,
      rst
	);

initial begin
	clk = 0;
	while (1) begin
		#2;
		clk = ~clk;
	end
end

initial begin
	rst = 1;
	rd_en = 4'b0000;
	wr_en = 4'b0000;
	#11;
	rst = 0;
	#20
	input_tag = 1;
	addresses  = 2048'h00000034_00000024_00000014_00000004;
	wr_data = 8192'h00000001_00000002_00000003_00000004_00000005_00000006_00000007_00000008;
	wr_en = 4'b0101;
	wr_mask = 7;
	#4
	wr_en = 4'b0000;
	#20;
	input_tag = 2;
	addresses  = 2048'h00000034_00000024_00000014_00000004;
	rd_en = 4'b0101;
	wr_mask = 1;
	#4
	rd_en = 0;
	#10
	$finish;
end

always @ (posedge clk) begin
	if (!rst) begin
		$display ("Time= %g : Ack= %b : Output_tag= %b", $time, ack, output_tag);
		if(ack) begin
            $display ("Addr: %h Read Data: %h", addresses[31:0], rd_data[127:0]);
            $display ("Addr: %h Read Data: %h", addresses[63:32], rd_data[255:128]);
            $display ("Addr: %h Read Data: %h", addresses[95:64], rd_data[383:256]);
            $display ("Addr: %h Read Data: %h", addresses[127:96], rd_data[511:384]);
        end
	end
end

endmodule
