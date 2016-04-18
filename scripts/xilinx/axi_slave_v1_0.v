
`timescale 1 ns / 1 ps

	module axi_slave_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 11
	)
	(
        // Users to add ports here
        // Passthrough signals
        output wire  S_AXI_ACLK,
        output wire  S_AXI_ARESETN,
        output wire [C_S00_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
        output wire [2 : 0] S_AXI_AWPROT,
        output wire  S_AXI_AWVALID,
        
        input wire  S_AXI_AWREADY,
        
        output wire [C_S00_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
        output wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
        output wire  S_AXI_WVALID,
        
        input wire  S_AXI_WREADY,
        input wire [1 : 0] S_AXI_BRESP,
        input wire  S_AXI_BVALID,
        
        output wire  S_AXI_BREADY,
        output wire [C_S00_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
        output wire [2 : 0] S_AXI_ARPROT,
        output wire  S_AXI_ARVALID,
        
        input wire  S_AXI_ARREADY,
        input wire [C_S00_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
        input wire [1 : 0] S_AXI_RRESP,
        input wire  S_AXI_RVALID,
        
        output wire  S_AXI_RREADY,
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
	// Add user logic here
	
    assign S_AXI_ACLK = s00_axi_aclk;
    assign S_AXI_ARESETN = s00_axi_aresetn;
    assign S_AXI_AWADDR = s00_axi_awaddr;
    assign S_AXI_AWPROT = s00_axi_awprot;
    assign S_AXI_AWVALID = s00_axi_awvalid;
    
    assign s00_axi_awready = S_AXI_AWREADY;
    
    assign S_AXI_WDATA = s00_axi_wdata;
    assign S_AXI_WSTRB = s00_axi_wstrb;
    assign S_AXI_WVALID = s00_axi_wvalid;
    
    assign s00_axi_wready = S_AXI_WREADY;
    assign s00_axi_bresp = S_AXI_BRESP;
    assign s00_axi_bvalid = S_AXI_BVALID;
    
    assign S_AXI_BREADY = s00_axi_bready;
    assign S_AXI_ARADDR = s00_axi_araddr;
    assign S_AXI_ARPROT = s00_axi_arprot;
    assign S_AXI_ARVALID = s00_axi_arvalid;
            
    assign s00_axi_arready = S_AXI_ARREADY;
    assign s00_axi_rdata = S_AXI_RDATA;
    assign s00_axi_rresp = S_AXI_RRESP;
    assign s00_axi_rvalid = S_AXI_RVALID;
    
    assign S_AXI_RREADY = s00_axi_rready;

	// User logic ends

	endmodule
