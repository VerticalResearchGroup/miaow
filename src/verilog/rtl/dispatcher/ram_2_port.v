module ram_2_port
  (/*AUTOARG*/
   // Outputs
   rd_word,
   // Inputs
   rst, clk, wr_en, wr_addr, wr_word, rd_en, rd_addr
   );

   parameter WORD_SIZE = 16;
   parameter ADDR_SIZE = 5;
   parameter NUM_WORDS = 2**5;

   input rst, clk;
   
   input wr_en;
   input [ADDR_SIZE-1 :0] wr_addr;
   input [WORD_SIZE-1 :0] wr_word;

   input 		  rd_en;
   input [ADDR_SIZE-1: 0] rd_addr;
   output reg [WORD_SIZE-1: 0] rd_word;

   reg [WORD_SIZE-1 :0]    ram_table[NUM_WORDS-1:0];

   always @(posedge clk or rst) begin
      if(rst) begin
	 rd_word <= 0;
      end else begin
	 if(rd_en) begin
	    rd_word <= ram_table[rd_addr];
	 end

	 if(wr_en) begin
	    ram_table[wr_addr] <= wr_word;
	 end
      end
      
   end
   
endmodule // ram_2_port



