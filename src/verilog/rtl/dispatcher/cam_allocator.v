module cam_allocator
  (/*AUTOARG*/
   // Outputs
   res_search_out,
   // Inputs
   clk, rst, res_search_en, res_search_size, cam_wr_en, cam_wr_addr,
   cam_wr_data
   );

   parameter CU_ID_WIDTH = 6;
   parameter NUMBER_CU = 64;

   parameter RES_ID_WIDTH = 10;
   parameter NUMBER_RES_SLOTS = 1024;

   // Search port
   input clk,rst;
   
   input 		  res_search_en;
   input [RES_ID_WIDTH:0] res_search_size;

   output [NUMBER_CU-1:0]   res_search_out;
   // Write port
   input 		  cam_wr_en;
   input [CU_ID_WIDTH-1 : 0] cam_wr_addr;
   input [RES_ID_WIDTH:0]      cam_wr_data;
   
   
   reg 			       res_search_en_i;
   reg [RES_ID_WIDTH:0]        res_search_size_i;

   // Table to implement the cam
   reg [RES_ID_WIDTH:0]      cam_ram[NUMBER_CU-1 :0];
   reg [NUMBER_CU-1 :0]      cam_valid_entry;

   wire [NUMBER_CU-1 :0]     decoded_output;

   genvar 		     i;
   generate
      for (i=0; i<NUMBER_CU; i=i+1) begin : LOOKUP
	 assign decoded_output[i] = (!res_search_en_i)? 1'b0 :
				    (!cam_valid_entry[i]) ? 1'b1 :
				    (cam_ram[i] >= res_search_size_i)? 1'b1:
				    1'b0;
      end
   endgenerate
   assign res_search_out = decoded_output;

   // Always block for the memory - no reset
   always @(posedge clk) begin
      if (cam_wr_en) begin
	 cam_ram[cam_wr_addr] <= cam_wr_data;
      end
      
   end 

   // For datapath - reset
   always @(posedge clk or rst) begin
      if(rst) begin
	 cam_valid_entry <= 0;
	 res_search_en_i <= 0;
	 res_search_size_i <= 0;
      end else begin
	 res_search_en_i <= res_search_en;
	 res_search_size_i <= res_search_size;

	 if (cam_wr_en) begin
	    cam_valid_entry[cam_wr_addr] <= 1'b1;
	 end
      end
      
      
   end 
   
endmodule
