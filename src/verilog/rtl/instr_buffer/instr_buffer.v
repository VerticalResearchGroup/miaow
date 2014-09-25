module instr_buffer(
      fetch_rd_en,
      fetch_addr,
      fetch_tag,
      fetchwave_ack,
      wave_instr,
      wave_tag,
      clk,
      rst
 );

parameter NUMOFCU = 1;

input clk;

input rst;

input [(NUMOFCU - 1):0] fetch_rd_en;
input [(NUMOFCU*32 - 1):0] fetch_addr;
input [(NUMOFCU*39 - 1):0] fetch_tag;

output [(NUMOFCU - 1):0] fetchwave_ack;
output [(NUMOFCU*32 - 1):0] wave_instr;
output [(NUMOFCU*39 - 1):0] wave_tag;

reg [(NUMOFCU - 1):0] fetchwave_ack;
reg [(NUMOFCU*32 - 1):0] wave_instr;
reg [(NUMOFCU*39 - 1):0] wave_tag;

reg [7:0] instr_memory[10000];

///////////////////////////////
//Your code goes here - beware: script does not recognize changes
// into files. It ovewrites everithing without mercy. Save your work before running the script
///////////////////////////////

integer i;

always @ (posedge clk)
	for(i = 0; i < NUMOFCU; i++) begin
		if (~rst & fetch_rd_en[i]) begin
			wave_instr[(i*32 + 7)-:8] = instr_memory[fetch_addr[(i*32 + 31)-:32]];
			wave_instr[(i*32 + 15)-:8] = instr_memory[fetch_addr[(i*32 + 31)-:32] + 1];
			wave_instr[(i*32 + 23)-:8] = instr_memory[fetch_addr[(i*32 + 31)-:32] + 2];
			wave_instr[(i*32 + 31)-:8] = instr_memory[fetch_addr[(i*32 + 31)-:32] + 3];

			wave_tag[(i*39 + 38)-:39] = fetch_tag[(i*39 + 38)-:39];
			fetchwave_ack[i] = 1'b1;
		end
		else begin
			// if reset or ~fetch_rd_en[i]
			wave_tag[(i*39 + 38)-:39] = 39'bx;
			fetchwave_ack[i] = 1'b0;
		end
	end

endmodule

