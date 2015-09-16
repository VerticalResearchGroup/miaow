module memory(
      gm_or_lds,
      rd_en,
      wr_en,
      addresses,
      wr_data,
      rd_data,
      ack,
      clk,
      rst
 );

input clk;
input rst;

input gm_or_lds;
input rd_en, wr_en;
input [31:0] addresses;
input [31:0] wr_data;

output ack;
output [31:0] rd_data;

reg[7:0] data_memory[50000:0];
reg[7:0] lds_memory[65535:0];

//integer locrd = 4; // num of loc to read

assign ack = 1;
integer i;
always@(posedge clk, posedge rst) begin
      // if(rst) begin
      //       for(i = 0; i < 50001; i = i+1) begin
      //             data_memory[i] <= 0;
      //       end
      //       for(i = 0; i < 65536; i = i+1) begin
      //             lds_memory[i] <= 0;
      //       end
      // end
      // else 
      if(wr_en) begin
            if(gm_or_lds) begin
                  lds_memory [addresses] <= wr_data[7:0];
                  lds_memory [addresses+1] <= wr_data[15:7];
                  lds_memory [addresses+2] <= wr_data[23:16];
                  lds_memory [addresses+3] <= wr_data[31:24];
            end
            else begin
                  data_memory [addresses] <= wr_data[7:0];
                  data_memory [addresses+1] <= wr_data[15:7];
                  data_memory [addresses+2] <= wr_data[23:16];
                  data_memory [addresses+3] <= wr_data[31:24];
            end
      end
end

wire [31:0] rd_lds;
wire [31:0] rd_dm;
assign rd_lds = {lds_memory[addresses+3],lds_memory[addresses+2],lds_memory[addresses+1],lds_memory[addresses]};
assign rd_dm = {data_memory[addresses+3],data_memory[addresses+2],data_memory[addresses+1],data_memory[addresses]};

assign rd_data = (gm_or_lds) ? rd_lds:rd_dm;

endmodule