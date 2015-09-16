 module rw_controller(rd_en_in, wrt_en_in, exec_mask_in, addr_in, addr_out, 
	wrt_en, rd_en, clk, rst, shift, increAddr, mem_ack, lsu_stall, 
	lsu_rdy, lsu_select, load_src_a, set_freez, clr_freez, wb_en,
	load_wb, shift_wb, retire);

	input [3:0] rd_en_in, wrt_en_in;
	input [63:0] exec_mask_in;
	input [2047:0] addr_in;
	output [31:0] addr_out;
	output wrt_en;
	output rd_en;
	input clk, rst;
	output shift;
	output [1:0] increAddr;
	input mem_ack, lsu_stall, lsu_select;
	output lsu_rdy, load_src_a;
	output set_freez, clr_freez;
	output wb_en;
	output load_wb, shift_wb;
	output retire;
	reg retire;
	reg lsu_rdy;
	reg clear_round;
	reg incre_round;
	reg clear_word_round;
	reg incre_word_round;
	reg load_addr;
	reg shift_addr;
	reg load_exec;
	reg shift_exec;
	reg load_src_a;
	reg shift;
	reg rd_en;
	reg wrt_en;
	reg set_freez;
	reg clr_freez;
	reg wb_en;
	reg load_wb, shift_wb;
	// the two-bit counter counts up to four rounds
	// (8k/2k)=4. The value also serves as an offset
	// that will be added to VGPR address and memory write 
	// address
	reg [1:0] round_4;// count 4 rounds
	always @ (posedge clk, posedge rst) begin
		if(rst) begin
			round_4 <= 0;
		end
		else if(clear_round) begin
			round_4 <= 0;
		end
		else if(incre_round) begin
			round_4 <= round_4 + 1;
		end
	end

	// the 6-bit counter counts up to 64 to track the iteration
	// of 64 words during reading/writing

	reg [5:0] word_round;// count 64 words
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			word_round <= 0;
		end
		else if(clear_word_round) begin
			word_round <= 0;
		end
		else if (incre_word_round) begin
			word_round <= word_round + 1;
		end
	end

	// the address reg holds the calculated address sent from
	// address calculator. It also supports shift: >> 32bit
	reg [2047:0] address;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			address <= 0;
		end
		else if (load_addr) begin
			address <= addr_in;
		end
		else if (shift_addr) begin
			address[2015:0] <= address[2047:32];
		end
	end

	// the exec mask holds the received exec mask sent from
	// previous level of flop. It also supports shift: >>1bit
	reg [63:0] exec;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			exec <= 0;
		end
		else if (load_exec) begin
			exec <= exec_mask_in;
		end
		else if (shift_exec) begin
			exec[62:0] <= exec[63:1];
		end
	end

	// address offset (0~3)
	assign increAddr = round_4;
	// actual 32-bit write address
	assign addr_out = address[31:0] + (round_4*4);

	localparam IDLE = 4'b0000;
	localparam WRITE = 4'b0001;
	localparam WRITE_WAIT = 4'b0010;
	localparam WRITE_END = 4'b0011;
	localparam SPIN_WRITE = 4'b0100;
	localparam SPIN_READ1 = 4'b0101;
	localparam READ = 4'b0110;
	localparam READ_END = 4'b0111;
	localparam READ_WAIT = 4'b1000;
	localparam SPIN_READ2 = 4'b1001;
	localparam WB = 4'b1010;
	localparam DISPATCH = 4'b1011;
	localparam INIT_READ = 4'b1100;
	localparam RETIRE = 4'b1101;
	localparam INIT_READ2 = 4'b1110;
	localparam SPIN_WRITE1 = 4'b1111;

	reg [3:0] state, nxtState;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			state<=0;
		end
		else begin
			state<=nxtState;
		end
	end
	////////////////////scalar r/w
	///////////////////// word write num

	always @ (*) begin
		shift = 0;
		rd_en = 0;
		wrt_en = 0;
		nxtState = IDLE;
		lsu_rdy = 1;
		load_src_a = 0;
		clear_round = 0;
		incre_round = 0;
		clear_word_round = 0;
		incre_word_round = 0;
		load_addr = 0;
		shift_addr = 0;
		load_exec = 0;
		shift_exec = 0;
		set_freez = 0;
		clr_freez = 0;
		wb_en = 0;
		load_wb = 0;
		shift_wb = 0;
		retire = 0;

		case(state)
			IDLE: begin
				clear_round = 1;
				clear_word_round = 1;				
				// detects the previous stage of pipeline
				// register and pre stall the issue unit
				// this is done because there is a one-cycle
				// delay between the issue and this FSM, so
				// FSM should block new instr ahead of time
				// to prevent the next level of pipeline reg
				// to be overwritten 
				if(lsu_select) begin
					set_freez = 1;
					nxtState = INIT_READ;
				end
			end
			// wait 2 cycle for block ram VGPR read
			INIT_READ: begin
				nxtState = INIT_READ2;
			end
			INIT_READ2: begin
				nxtState = DISPATCH;
			end
			DISPATCH: begin
				// when it detects non-zero rd_en, goto
				// read state and load new 2k address
				// block the read of vgpr src a
				if(|rd_en_in) begin
					nxtState = READ;
					load_addr = 1;
					// lsu_rdy = 0;
					load_src_a = 1;
					load_exec = 1;
					//$strobe("load addr %h",addr_in);
				end
				// when it detects non-zero wr_en, goto
				// write state and load new 2k address
				// block the read of vgpr src a
				else if(|wrt_en_in) begin
					nxtState = WRITE;
					load_addr = 1;
					// lsu_rdy = 0;
					load_src_a = 1;
					load_exec = 1;
				end
			end
			WRITE: begin
				//load_src_a = 0;
				//wrt_en = exec[0];
				// when the write is 32-bit word, we only go 1 round
				if(round_4 == 0 && wrt_en_in == 4'b0001 && word_round == 63) begin
					// if the last exec mask is 0, directly go back to idle
					if(exec[0] == 0) begin
						nxtState = RETIRE;
						lsu_rdy = 1;
						//clr_freez = 1;
					end
					// else write the last word in the WRITE_END stage
					else begin
						nxtState = WRITE_END;
						lsu_rdy = 0;
						wrt_en = 1;
					end					
				end
				// when the write is 128-bit word, we go 4 rounds
				else if(round_4 == 3 && wrt_en_in == 4'b1111 && word_round == 63) begin
					// if the last exec mask is 0, directly go back to idle
					if(exec[0] == 0) begin
						nxtState = RETIRE;
						lsu_rdy = 1;
						//clr_freez = 1;
					end
					// else write the last word in the WRITE_END stage
					else begin
						nxtState = WRITE_END;
						lsu_rdy = 0;
						wrt_en = 1;
					end	
				end
				else begin	
					lsu_rdy = 0;	
					// if the exec mask is 0, go to next exec mask			
					if(exec[0] == 0) begin
						nxtState = WRITE;
						shift_exec = 1;	
						shift = 1;				
						incre_word_round = 1;
						// if reach the end of word-round, update the round cntr
						if(word_round == 63) begin
							incre_round = 1;
							load_exec = 1;
							nxtState = SPIN_WRITE;
							// goto SPIN_WRITE to wait 
							// one cycle and let new data
							// feed to the flop due to 1-cycle
							// delay of block-ram behavior
						end
					end
					// else, go to another write
					else begin
						wrt_en = 1;
						nxtState = WRITE_WAIT;
					end
				end
			end
			WRITE_WAIT: begin
				load_src_a = 0;
				lsu_rdy = 0;
				//wrt_en = exec[0];
				// wait for memory ack sig
				if(!mem_ack) begin
					nxtState = WRITE_WAIT;
					wrt_en = 1;
				end
				// after transaction, shift data, address, exec mask
				// increment word_round & round if necessary
				else begin
					shift = 1;
					shift_exec = 1;
					shift_addr = 1;
					incre_word_round = 1;
					if(word_round == 63) begin
						incre_round = 1;
						load_exec = 1;						
						nxtState = SPIN_WRITE;
					end
					else begin
						// else go back to write and recheck the exec mask
						nxtState = WRITE;
					end
				end
			end
			// state for writing the last word
			WRITE_END: begin
				wrt_en = 1;
				// wait for memory ack sig
				if(!mem_ack) begin
					nxtState = WRITE_END;
				end
				else begin
					// release the stall signal
					lsu_rdy = 1;
					nxtState = RETIRE;
					//clr_freez = 1;
				end
			end
			SPIN_WRITE1: begin
				lsu_rdy = 0;
				// if(mem_ack) begin
				// 	nxtState = WRITE;
				// end
				// else begin
				// 	nxtState = SPIN_WRITE1;
				// end
				// //nxtState = WRITE;
				load_addr = 1;
				load_src_a = 1;
			end
			// wait one cycle and let the new data from
			// blockram (VGPR) feed the register
			// might not be necessary?
			SPIN_WRITE: begin
				nxtState = SPIN_WRITE1;
			end
			// wait for last word to ack
			//////////////////////////////////////////////////////////////////////////DELAY
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			SPIN_READ1: begin
				lsu_rdy = 0;
				if(!mem_ack) begin
					nxtState = SPIN_READ1;
				end
				else begin
					shift = 1;
					shift_exec = 1;
					shift_addr = 1;
					incre_word_round = 1;
					load_wb = 1;
					nxtState = SPIN_READ2;
					//$display("addrout: %h",addr_out);	
				end				
				//load_addr = 1;
			end
			// wait until lsu finish writing the 2k data
			// back to vgpr
			SPIN_READ2: begin
				//rd_en = 1;
				//wb_en = 1;
				if(lsu_stall == 1) begin
					nxtState = SPIN_READ2;
				end
				else begin
					wb_en = 1;
					//$strobe("AT FINAL WB");
					nxtState = RETIRE;					
					//set = 1;
				end
			end
			READ: begin
				load_src_a = 0; //block new data from overwritting the current data buffer
				//lsu_rdy = 0; // stall
				//rd_en = exec[0];
				// if read 32-bit long word, only go one round
				// this detects the end of this instruction
				if(round_4 == 0 && rd_en_in == 4'b0001 && word_round == 63) begin
					if(exec[0] == 0) begin
						load_wb = 1;
						nxtState = SPIN_READ2;
						lsu_rdy = 1;
						//clr_freez = 1;
						//set = 1;
					end
					// else read the last word
					else begin
						lsu_rdy = 0;
						nxtState = SPIN_READ1;
						rd_en = 1;
					end					
				end
				// same, this handles the end of 64-bit read case
				else if(round_4 == 1 && rd_en_in == 4'b0011 && word_round == 63) begin
					if(exec[0] == 0) begin
						load_wb = 1;
						nxtState = SPIN_READ2;
						lsu_rdy = 1;
						//clr_freez = 1;
						//set = 1;
					end
					else begin
						nxtState = SPIN_READ1;
						lsu_rdy = 0;
						rd_en = 1;
					end	
				end
				// this handles the end of 128-bit read case
				else if(round_4 == 3 && rd_en_in == 4'b1111 && word_round == 63) begin
					if(exec[0] == 0) begin
						load_wb = 1;
						nxtState = SPIN_READ2;
						lsu_rdy = 1;
						//clr_freez = 1;
						//set = 1;
					end
					else begin
						nxtState = SPIN_READ1;
						lsu_rdy = 0;
						rd_en = 1;
					end	
				end
				else begin
					lsu_rdy = 0;	
					// if current exec mask is 0, go to the next				
					if(exec[0] == 0) begin
						//$strobe("addrout exec0: %h",addr_out);
						nxtState = READ;
						//$strobe("wordround: %h",word_round);
						load_wb = 1;
						shift_exec = 1;	
						shift = 1;				
						incre_word_round = 1;
						if(word_round == 63) begin
							incre_round = 1;

							// when reaching the end of one round, wait
							// for write back to vgpr
							nxtState = WB;
						end
					end
					else begin
						rd_en = 1;
						//$strobe("addrout: %h",addr_out);
						nxtState = READ_WAIT;
					end
				end
			end
			READ_WAIT: begin
				load_src_a = 0;
				lsu_rdy = 0;
				rd_en = 1;
				// wait for memory read ack
				if(!mem_ack) begin
					nxtState = READ_WAIT;
				end
				else begin
					// shift data, exec mask, address
					// increment word-round, and increase round # if necessary
					shift = 1;
					shift_exec = 1;
					shift_addr = 1;
					incre_word_round = 1;
					load_wb=1;
					if(word_round == 63) begin
						incre_round = 1;
						//load_exec=1;
						//load_wb=1;
						nxtState = WB;
					end
					else begin
						nxtState = READ;
						//load_wb = 1;
					end
				end
			end 
			// read the last word for this instr
			READ_END: begin
				// lsu_rdy = 0;
				// rd_en = 1;
				// if(!mem_ack) begin
				// 	nxtState = READ_END;
				// end
				// else begin
				// 	nxtState = WB;
				// 	//set = 1;
				// end
				//$strobe("load addr end %h",addr_in);
				load_exec=1;
							//load_addr=1;
				load_addr = 1;
				nxtState = READ;
			end
			// write back the last word
			WB: begin
				//rd_en = 1;
				//wb_en = 1;
				if(lsu_stall == 1) begin
					nxtState = WB;
				end
				else begin
					wb_en = 1;

					nxtState = READ_END;	
					//$strobe("AT WB");				
					//set = 1;
				end
			end
			RETIRE: begin
				retire = 1;
				clr_freez = 1;
			end
		endcase
	end
endmodule