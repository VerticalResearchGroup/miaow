module memory
(
  clk,
  rst,
  mem_gm_or_lds,
  mem_rd_en,
  mem_wr_en,
  mem_tag_req,
  mem_tag_resp,
  mem_wr_mask,
  mem_addr,
  mem_wr_data,
  mem_rd_data,
  mem_ack,
  
  mem_state,
  mem_axi_state,
  
  ip2bus_mstrd_req,               // IP to Bus master read request
  ip2bus_mstwr_req,               // IP to Bus master write request
  ip2bus_mst_addr,                // IP to Bus master read/write address
  ip2bus_mst_be,                  // IP to Bus byte enable
  ip2bus_mst_length,              // Ip to Bus master transfer length
  ip2bus_mst_type,                // Ip to Bus burst assertion control
  ip2bus_mst_lock,                // Ip to Bus bus lock
  ip2bus_mst_reset,               // Ip to Bus master reset
  bus2ip_mst_cmdack,              // Bus to Ip master command ack
  bus2ip_mst_cmplt,               // Bus to Ip master trans complete
  bus2ip_mst_error,               // Bus to Ip master error
  bus2ip_mst_rearbitrate,         // Bus to Ip master re-arbitrate for bus ownership
  bus2ip_mst_cmd_timeout,         // Bus to Ip master command time out
  bus2ip_mstrd_d,                 // Bus to Ip master read data
  bus2ip_mstrd_rem,               // Bus to Ip master read data rem
  bus2ip_mstrd_sof_n,             // Bus to Ip master read start of frame
  bus2ip_mstrd_eof_n,             // Bus to Ip master read end of frame
  bus2ip_mstrd_src_rdy_n,         // Bus to Ip master read source ready
  bus2ip_mstrd_src_dsc_n,         // Bus to Ip master read source dsc
  ip2bus_mstrd_dst_rdy_n,         // Ip to Bus master read dest. ready
  ip2bus_mstrd_dst_dsc_n,         // Ip to Bus master read dest. dsc
  ip2bus_mstwr_d,                 // Ip to Bus master write data
  ip2bus_mstwr_rem,               // Ip to Bus master write data rem
  ip2bus_mstwr_src_rdy_n,         // Ip to Bus master write source ready
  ip2bus_mstwr_src_dsc_n,         // Ip to Bus master write source dsc
  ip2bus_mstwr_sof_n,             // Ip to Bus master write start of frame
  ip2bus_mstwr_eof_n,             // Ip to Bus master write end of frame
  bus2ip_mstwr_dst_rdy_n,         // Bus to Ip master write dest. ready
  bus2ip_mstwr_dst_dsc_n          // Bus to Ip master write dest. ready
);

parameter C_MST_NATIVE_DATA_WIDTH        = 32;
parameter C_LENGTH_WIDTH                 = 12;
parameter C_MST_AWIDTH                   = 32;
parameter C_NUM_REG                      = 33;
parameter C_SLV_DWIDTH                   = 32;

input clk;
input rst;

input mem_gm_or_lds;
input [3:0] mem_rd_en;
input [3:0] mem_wr_en;
input [63:0] mem_wr_mask;

input [6:0] mem_tag_req;
output [6:0] mem_tag_resp;

input [2047:0] mem_addr;
input [2047:0] mem_wr_data;
output [2047:0] mem_rd_data;

output mem_ack;

output                                    ip2bus_mstrd_req;
output                                    ip2bus_mstwr_req;
output     [C_MST_AWIDTH-1 : 0]           ip2bus_mst_addr;
output     [(C_MST_NATIVE_DATA_WIDTH/8)-1 : 0] ip2bus_mst_be;
output     [C_LENGTH_WIDTH-1 : 0]         ip2bus_mst_length;
output                                    ip2bus_mst_type;
output                                    ip2bus_mst_lock;
output                                    ip2bus_mst_reset;
input                                     bus2ip_mst_cmdack;
input                                     bus2ip_mst_cmplt;
input                                     bus2ip_mst_error;
input                                     bus2ip_mst_rearbitrate;
input                                     bus2ip_mst_cmd_timeout;
input      [C_MST_NATIVE_DATA_WIDTH-1 : 0] bus2ip_mstrd_d;
input      [(C_MST_NATIVE_DATA_WIDTH)/8-1 : 0] bus2ip_mstrd_rem;
input                                     bus2ip_mstrd_sof_n;
input                                     bus2ip_mstrd_eof_n;
input                                     bus2ip_mstrd_src_rdy_n;
input                                     bus2ip_mstrd_src_dsc_n;
output                                    ip2bus_mstrd_dst_rdy_n;
output                                    ip2bus_mstrd_dst_dsc_n;
output     [C_MST_NATIVE_DATA_WIDTH-1 : 0] ip2bus_mstwr_d;
output     [(C_MST_NATIVE_DATA_WIDTH)/8-1 : 0] ip2bus_mstwr_rem;
output                                    ip2bus_mstwr_src_rdy_n;
output                                    ip2bus_mstwr_src_dsc_n;
output                                    ip2bus_mstwr_sof_n;
output                                    ip2bus_mstwr_eof_n;
input                                     bus2ip_mstwr_dst_rdy_n;
input                                     bus2ip_mstwr_dst_dsc_n;

output [2:0] mem_state;
output [2:0] mem_axi_state;

reg [6:0] mem_tag_reg;
reg [3:0] mem_rd_en_reg;
reg [3:0] mem_wr_en_reg;

reg mem_ack_reg;

parameter LSU_STATE_SIZE = 3;
parameter [2:0] LSU_IDLE_STATE = 3'b000,
                LSU_READ_STATE = 3'b001,
                LSU_WRITE_STATE = 3'b010;

parameter AXI_STATE_SIZE = 3;
parameter [2:0] AXI_IDLE_STATE = 3'b000,
                AXI_CMD_STATE  = 3'b001,
                AXI_DATA_WAIT = 3'b010,
                AXI_READING = 3'b011,
                AXI_WRITING = 3'b100,
                AXI_CMD_DONE_WAIT = 3'b101,
                AXI_CMD_DONE = 3'b110;
                

reg [LSU_STATE_SIZE-1:0] lsu_mem_cs;
reg [LSU_STATE_SIZE-1:0] lsu_mem_ns;

reg [AXI_STATE_SIZE-1:0] axi_mem_cs;
reg [AXI_STATE_SIZE-1:0] axi_mem_ns;

reg [31:0] mem_addr_cur;
reg [31:0] mem_addr_next;

reg [5:0] op_cnt;
reg [5:0] op_cnt_next;

reg rd_buffer_we;

reg [127:0] mem_rd_data_buffer[0:15];
wire [127:0] mem_wr_data_buffer_net[0:15];
reg [127:0] mem_wr_data_buffer[0:15];

// Control registers for master burst interface
reg ip2bus_mstrd_req_reg;
reg ip2bus_mstwr_req_reg;
reg ip2bus_mstrd_dst_rdy_n_reg;

reg ip2bus_mstwr_sof_n_reg;
reg ip2bus_mstwr_eof_n_reg;
reg ip2bus_mstwr_src_rdy_n_reg;

reg ip2bus_mst_type_reg;

assign ip2bus_mst_addr = mem_addr_cur;

assign ip2bus_mstrd_req = ip2bus_mstrd_req_reg;
assign ip2bus_mstwr_req = ip2bus_mstwr_req_reg;

assign ip2bus_mst_reset = 1'b0;

// ip2bus_mst_be is hardcoded to enable all bytes
assign ip2bus_mst_be = 16'hFFFF; // Correct this later

assign ip2bus_mst_length = 12'd16;
assign ip2bus_mst_type = ip2bus_mst_type_reg;

assign mem_tag_resp = mem_tag_reg;
assign mem_ack = mem_ack_reg;

assign mem_state = lsu_mem_cs;
assign mem_axi_state = axi_mem_cs;

genvar rd_buffer_genvar;
generate
for(rd_buffer_genvar = 0; rd_buffer_genvar < 16; rd_buffer_genvar = rd_buffer_genvar + 1)
begin: rd_buffer_for
  assign mem_rd_data[(rd_buffer_genvar * 128) + 127:rd_buffer_genvar * 128] = mem_rd_data_buffer[rd_buffer_genvar];
end
endgenerate

genvar mem_wr_data_genvar;
generate
  for(mem_wr_data_genvar = 0; mem_wr_data_genvar < 16; mem_wr_data_genvar = mem_wr_data_genvar + 1)
  begin: wr_data_for
    assign mem_wr_data_buffer_net[mem_wr_data_genvar] = mem_wr_data[(mem_wr_data_genvar * 128) + 127:mem_wr_data_genvar * 128];
  end
endgenerate

always @ (posedge(clk)) begin

  if(rst) begin
    lsu_mem_cs <= LSU_IDLE_STATE;
    mem_addr_cur <= 32'd0;
    op_cnt <= 6'd0;
    axi_mem_cs <= AXI_IDLE_STATE;
    mem_tag_reg <= 7'd0;
    mem_rd_en_reg <= 4'd0;
    mem_wr_en_reg <= 4'd0;
  end
  else begin
    lsu_mem_cs <= lsu_mem_ns;
    axi_mem_cs <= axi_mem_ns;
    //mem_addr_cur <= mem_addr_next;
    mem_addr_cur <= mem_addr[31:0];
    op_cnt <= op_cnt_next;
    case(lsu_mem_cs)
      LSU_IDLE_STATE:
		  begin
        if(((|mem_wr_en) & (|(~mem_wr_en_reg))) | (((|mem_rd_en) & (|(~mem_rd_en_reg))))) begin
          //mem_addr_cur <= mem_addr[31:0];
          op_cnt <= 6'd0;
          mem_tag_reg <= mem_tag_req;
          mem_rd_en_reg <= mem_rd_en;
          mem_wr_en_reg <= mem_wr_en;
        end
        
        if((|mem_wr_en) & (|(~mem_wr_en_reg))) begin
          mem_wr_data_buffer[0] <= mem_wr_data_buffer_net[0];
          mem_wr_data_buffer[1] <= mem_wr_data_buffer_net[1];
          mem_wr_data_buffer[2] <= mem_wr_data_buffer_net[2];
          mem_wr_data_buffer[3] <= mem_wr_data_buffer_net[3];
          mem_wr_data_buffer[4] <= mem_wr_data_buffer_net[4];
          mem_wr_data_buffer[5] <= mem_wr_data_buffer_net[5];
          mem_wr_data_buffer[6] <= mem_wr_data_buffer_net[6];
          mem_wr_data_buffer[7] <= mem_wr_data_buffer_net[7];
          mem_wr_data_buffer[8] <= mem_wr_data_buffer_net[8];
          mem_wr_data_buffer[9] <= mem_wr_data_buffer_net[9];
          mem_wr_data_buffer[10] <= mem_wr_data_buffer_net[10];
          mem_wr_data_buffer[11] <= mem_wr_data_buffer_net[11];
          mem_wr_data_buffer[12] <= mem_wr_data_buffer_net[12];
          mem_wr_data_buffer[13] <= mem_wr_data_buffer_net[13];
          mem_wr_data_buffer[14] <= mem_wr_data_buffer_net[14];
          mem_wr_data_buffer[15] <= mem_wr_data_buffer_net[15];
        end
		  end
    endcase
    
  end
end

always@(*) begin
  lsu_mem_ns <= lsu_mem_cs;
  axi_mem_ns <= axi_mem_cs;
  mem_addr_next <= mem_addr_next + 32'd4;
  mem_ack_reg <= 1'b0;
  ip2bus_mstrd_req_reg <= 1'b0;
  ip2bus_mstwr_req_reg <= 1'b0;
  ip2bus_mst_type_reg <= 1'b0;
  
  ip2bus_mstrd_dst_rdy_n_reg <= 1'b1;
  
  // Write related signals
  ip2bus_mstwr_sof_n_reg <= 1'b1;
  ip2bus_mstwr_eof_n_reg <= 1'b1;
  ip2bus_mstwr_src_rdy_n_reg <= 1'b1;
  
  // Read buffer write enable, default is low
  rd_buffer_we <= 1'b0;
  op_cnt_next <= op_cnt;
  case(lsu_mem_cs)
    LSU_IDLE_STATE:
	  begin
      axi_mem_ns <= AXI_IDLE_STATE;
      if( ( (|mem_rd_en) & (|(~mem_rd_en_reg) ) ) | ( (|mem_wr_en) & (|(~mem_wr_en_reg) ) )) begin
        axi_mem_ns <= AXI_CMD_STATE;
        
        if(|mem_rd_en) begin
          lsu_mem_ns <= LSU_READ_STATE;
        end
        else if(|mem_wr_en) begin
          lsu_mem_ns <= LSU_WRITE_STATE;
        end
      end
		end
    LSU_READ_STATE:
	  begin
      ip2bus_mstrd_dst_rdy_n_reg <= 1'b0;
      case(axi_mem_cs)
        AXI_CMD_STATE:
        begin
          ip2bus_mstrd_req_reg <= 1'b1;
          ip2bus_mst_type_reg <= 1'b1;
          if(bus2ip_mst_cmdack) begin
            axi_mem_ns <= AXI_DATA_WAIT;
          end
        end
        AXI_DATA_WAIT:
          if(~bus2ip_mstrd_sof_n & ~bus2ip_mstrd_src_rdy_n) begin
            axi_mem_ns <= AXI_READING;
            rd_buffer_we <= 1'b1;
            op_cnt_next <= op_cnt + 6'd1;
          end
        AXI_READING:
        begin
          if(~bus2ip_mstrd_src_rdy_n) begin
            rd_buffer_we <= 1'b1;
            op_cnt_next <= op_cnt + 6'd1;
          end
          if(~bus2ip_mstrd_eof_n) begin
            if(bus2ip_mst_cmplt) begin
              axi_mem_ns <= AXI_CMD_DONE;
            end
            else begin
              axi_mem_ns <= AXI_CMD_DONE_WAIT;
            end
          end
        end
        AXI_CMD_DONE_WAIT:
          if(bus2ip_mst_cmplt) begin
            axi_mem_ns <= AXI_CMD_DONE;
          end
        AXI_CMD_DONE:
        begin
          mem_ack_reg <= 1'b1;
          axi_mem_ns <= AXI_IDLE_STATE;
          lsu_mem_ns <= LSU_IDLE_STATE;
        end
      endcase
		end
    
    LSU_WRITE_STATE:
    begin
      ip2bus_mstwr_src_rdy_n_reg <= 1'b0;
      case(axi_mem_cs)
        AXI_CMD_STATE:
        begin
          ip2bus_mstwr_req_reg <= 1'b1;
          ip2bus_mstwr_sof_n_reg <= 1'b0;
          ip2bus_mst_type_reg <= 1'b1;
          if(bus2ip_mst_cmdack) begin
            axi_mem_ns <= AXI_DATA_WAIT;
          end
        end
        AXI_DATA_WAIT:
        begin
          ip2bus_mstwr_sof_n_reg <= 1'b0;
          if(~bus2ip_mstwr_dst_rdy_n) begin
            op_cnt_next <= op_cnt + 6'd1;
            axi_mem_ns <= AXI_WRITING;
          end
        end
        AXI_WRITING:
          if(~bus2ip_mstwr_dst_rdy_n) begin
            if(op_cnt == 6'b111111) begin
              ip2bus_mstwr_eof_n_reg <= 1'b0;
              if(bus2ip_mst_cmplt) begin
                axi_mem_ns <= AXI_CMD_DONE;
              end
              else begin
                axi_mem_ns <= AXI_CMD_DONE_WAIT;
              end
            end
            else begin
              op_cnt_next <= op_cnt + 6'd1;
              axi_mem_ns <= AXI_WRITING;
            end
          end
        AXI_CMD_DONE_WAIT:
        begin
          ip2bus_mstwr_src_rdy_n_reg <= 1'b1;
          if(bus2ip_mst_cmplt) begin
            axi_mem_ns <= AXI_CMD_DONE;
          end
        end
        AXI_CMD_DONE:
        begin
          ip2bus_mstwr_src_rdy_n_reg <= 1'b1;
          mem_ack_reg <= 1'b1;
          axi_mem_ns <= AXI_IDLE_STATE;
          lsu_mem_ns <= LSU_IDLE_STATE;
        end
      endcase
    end
  endcase

end

// Block of code responsible for reading data into the buffer
always @ (posedge(clk)) begin
  if(rd_buffer_we) begin
    mem_rd_data_buffer[op_cnt] <= bus2ip_mstrd_d;
  end
end

// Assignment of data being sent to AXI master bus
assign ip2bus_mstwr_d = mem_wr_data_buffer[op_cnt];

endmodule