
`timescale 1 ns / 1 ps

	module axi_slave_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 9
	)
	(
		// Users to add ports here
		output wire [C_S00_AXI_DATA_WIDTH-1:0] waveID_out,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] baseVGPR_out,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] baseSGPR_out,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] baseLDS_out,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] waveCount_out,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] pcStart_out,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] instrAddrReg_out,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] instruction_buff_out_a_in,
        input wire cu2dispatch_wf_done_in,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] resultsReadyTag_in,
        
        output wire [3:0] lsu2sgpr_dest_wr_en_out,
        output wire [9:0] quadBaseAddress_out,
        output wire [31:0] quadData0_out,
        output wire [31:0] quadData1_out,
        output wire [31:0] quadData2_out,
        output wire [31:0] quadData3_out,
        input wire [127:0] quadData_in,
        
        output wire execute_out,
        output wire executeStart_out,
        
        output wire [3:0] instrBuffWrEn_out,
        
        output wire [31:0] axi_data_out,
        
        output wire [31:0] mb2fpgamem_data_in,
        output wire mb2fpgamem_data_we,
        output wire mb2fpgamem_ack,
        output wire mb2fpgamem_done,
        
        input wire [3:0] fpgamem2mb_op,
        input wire [31:0] fpgamem2mb_data,
        input wire [31:0] fpgamem2mb_addr,
        
        input wire [31:0] pc_value,
	input wire [2047:0] singleVectorData_in,
        output wire [9:0] singleVectorBaseAddress_out,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
// Instantiation of Axi Bus Interface S00_AXI
	axi_slave_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) axi_slave_v1_0_S00_AXI_inst (
	    .waveID_out(waveID_out),
        .baseVGPR_out(baseVGPR_out),
        .baseSGPR_out(baseSGPR_out),
        .baseLDS_out(baseLDS_out),
        .waveCount_out(waveCount_out),
        .pcStart_out(pcStart_out),
        .instrAddrReg_out(instrAddrReg_out),
        .instruction_buff_out_a_in(instruction_buff_out_a_in),
        .cu2dispatch_wf_done_in(cu2dispatch_wf_done_in),
        .resultsReadyTag_in(resultsReadyTag_in),
        
        .lsu2sgpr_dest_wr_en_out(lsu2sgpr_dest_wr_en_out),
        .quadBaseAddress_out(quadBaseAddress_out),
        .quadData0_out(quadData0_out),
        .quadData1_out(quadData1_out),
        .quadData2_out(quadData2_out),
        .quadData3_out(quadData3_out),
        .quadData_in(quadData_in),
        
        .execute_out(execute_out),
        .executeStart_out(executeStart_out),
        .singleVectorBaseAddress_out(singleVectorBaseAddress_out),
        .singleVectorData_in(singleVectorData_in),
        .instrBuffWrEn_out(instrBuffWrEn_out),
        
        .axi_data_out(axi_data_out),
        
        .mb2fpgamem_data_in(mb2fpgamem_data_in),
        .mb2fpgamem_data_we(mb2fpgamem_data_we),
        .mb2fpgamem_ack(mb2fpgamem_ack),
        .mb2fpgamem_done(mb2fpgamem_done),
        
        .fpgamem2mb_op(fpgamem2mb_op),
        .fpgamem2mb_data(fpgamem2mb_data),
        .fpgamem2mb_addr(fpgamem2mb_addr),
        .pc_value(pc_value),
        
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

	// Add user logic here

	// User logic ends

	endmodule
