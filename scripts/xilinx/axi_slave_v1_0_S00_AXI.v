
`timescale 1 ns / 1 ps

	module axi_slave_v1_0_S00_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 9
	)
	(
		// Users to add ports here

		output wire [C_S_AXI_DATA_WIDTH-1:0] waveID_out,
        output wire [C_S_AXI_DATA_WIDTH-1:0] baseVGPR_out,
        output wire [C_S_AXI_DATA_WIDTH-1:0] baseSGPR_out,
        output wire [C_S_AXI_DATA_WIDTH-1:0] baseLDS_out,
        output wire [C_S_AXI_DATA_WIDTH-1:0] waveCount_out,
        output wire [C_S_AXI_DATA_WIDTH-1:0] pcStart_out,
        output wire [C_S_AXI_DATA_WIDTH-1:0] instrAddrReg_out,
        input wire [C_S_AXI_DATA_WIDTH-1:0] instruction_buff_out_a_in,
        input wire cu2dispatch_wf_done_in,
        input wire [C_S_AXI_DATA_WIDTH-1:0] resultsReadyTag_in,

        output wire [3:0] lsu2sgpr_dest_wr_en_out,
        output wire [9:0] quadBaseAddress_out,
        output wire [31:0] quadData0_out,
        output wire [31:0] quadData1_out,
        output wire [31:0] quadData2_out,
        output wire [31:0] quadData3_out,
        input wire [127:0] quadData_in,
        input wire [2047:0] singleVectorData_in,
        output wire [9:0] singleVectorBaseAddress_out,
        output wire [2047:0] singleVectorWrData_out,
        output wire [63:0] singleVectorWrDataMask_out,
        output wire [3:0] singleVectorWrEn_out,
        
        output wire execute_out,
        output wire executeStart_out,

        output wire [3:0] instrBuffWrEn_out,

        output wire [31:0] axi_data_out,
        
        output wire [31:0] mb2fpgamem_data_in,
        output wire mb2fpgamem_data_we,
        output wire mb2fpgamem_ack,
        output wire mb2fpgamem_done,
        output wire [0:0] peripheral_aresetn,

        input wire [3:0] fpgamem2mb_op,
        input wire [31:0] fpgamem2mb_data,
        input wire [31:0] fpgamem2mb_addr,
        
        input wire [31:0] pc_value,

		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave)
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 6;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 128
	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
	integer	 byte_index;

reg slv_reg_wren_buffer;
parameter IDLE_STATE = 4'd0;
parameter DISPATCH_STATE = 4'd1;
parameter EXECUTE_STATE = 4'd2;
parameter RESULT_STATE = 4'd3;

reg [3:0] executeState;
reg [3:0] executeStateNext;
reg execute;
reg executeStart;

reg [C_S_AXI_DATA_WIDTH-1:0] waveID;
reg [C_S_AXI_DATA_WIDTH-1:0] baseVGPR;
reg [C_S_AXI_DATA_WIDTH-1:0] baseSGPR;
reg [C_S_AXI_DATA_WIDTH-1:0] baseLDS;
reg [C_S_AXI_DATA_WIDTH-1:0] waveCount;
reg [C_S_AXI_DATA_WIDTH-1:0] pcStart;
reg [C_S_AXI_DATA_WIDTH-1:0] resultsReady;
reg [C_S_AXI_DATA_WIDTH-1:0] resultsReadyTag;

reg [3:0] instrBuffWrEn;
reg [31:0] instrAddrReg;

reg [9:0] quadBaseAddress;
reg [31:0] quadData0;
reg [31:0] quadData1;
reg [31:0] quadData2;
reg [31:0] quadData3;
reg [3:0] lsu2sgpr_dest_wr_en_reg;

reg [9:0]  singleVectorBaseAddress;

reg [63:0] singleVectorWrDataMask;
reg [3:0] singleVectorWrEn_reg;


reg [31:0] singleVectorWrData0, singleVectorWrData1, singleVectorWrData2, singleVectorWrData3, singleVectorWrData4, singleVectorWrData5, singleVectorWrData6,
           singleVectorWrData7, singleVectorWrData8, singleVectorWrData9, singleVectorWrData10, singleVectorWrData11, singleVectorWrData12, singleVectorWrData13,
           singleVectorWrData14, singleVectorWrData15, singleVectorWrData16, singleVectorWrData17, singleVectorWrData18, singleVectorWrData19, singleVectorWrData20,
           singleVectorWrData21, singleVectorWrData22, singleVectorWrData23, singleVectorWrData24, singleVectorWrData25, singleVectorWrData26, singleVectorWrData27,
           singleVectorWrData28, singleVectorWrData29, singleVectorWrData30, singleVectorWrData31, singleVectorWrData32, singleVectorWrData33, singleVectorWrData34,
           singleVectorWrData35, singleVectorWrData36, singleVectorWrData37, singleVectorWrData38, singleVectorWrData39, singleVectorWrData40, singleVectorWrData41,
           singleVectorWrData42, singleVectorWrData43, singleVectorWrData44, singleVectorWrData45, singleVectorWrData46, singleVectorWrData47, singleVectorWrData48,
           singleVectorWrData49, singleVectorWrData50, singleVectorWrData51, singleVectorWrData52, singleVectorWrData53, singleVectorWrData54, singleVectorWrData55,
           singleVectorWrData56, singleVectorWrData57, singleVectorWrData58, singleVectorWrData59, singleVectorWrData60, singleVectorWrData61, singleVectorWrData62,
           singleVectorWrData63;
           
reg [31:0] mb2fpgamem_data_in_reg;
reg mb2fpgamem_data_we_reg;
reg mb2fpgamem_ack_reg;
reg mb2fpgamem_done_reg;

reg [31:0] cycle_counter;
reg [31:0] cycle_counter_next;

reg mb_reset;
initial mb_reset = 1'b1;

wire [31:0] fpgamem2mb_op_net;

assign fpgamem2mb_op_net = {28'd0, fpgamem2mb_op}; 

assign mb2fpgamem_data_in = mb2fpgamem_data_in_reg;
assign mb2fpgamem_data_we = mb2fpgamem_data_we_reg;
assign mb2fpgamem_ack = mb2fpgamem_ack_reg;
assign mb2fpgamem_done = mb2fpgamem_done_reg;

assign waveID_out = waveID;
assign baseVGPR_out = baseVGPR;
assign baseSGPR_out = baseSGPR;
assign baseLDS_out = baseLDS;
assign waveCount_out = waveCount;
assign pcStart_out = pcStart;
assign instrAddrReg_out = instrAddrReg;
assign peripheral_aresetn = mb_reset & S_AXI_ARESETN;
assign quadBaseAddress_out = quadBaseAddress;
assign lsu2sgpr_dest_wr_en_out = lsu2sgpr_dest_wr_en_reg;
assign quadData0_out = quadData0;
assign quadData1_out = quadData1;
assign quadData2_out = quadData2;
assign quadData3_out = quadData3;

assign singleVectorBaseAddress_out = singleVectorBaseAddress;
assign singleVectorWrData_out = {
            singleVectorWrData63, singleVectorWrData62, singleVectorWrData61, singleVectorWrData60, singleVectorWrData59, singleVectorWrData58,
            singleVectorWrData57, singleVectorWrData56, singleVectorWrData55, singleVectorWrData54, singleVectorWrData53, singleVectorWrData52,
            singleVectorWrData51, singleVectorWrData50, singleVectorWrData49, singleVectorWrData48, singleVectorWrData47, singleVectorWrData46,
            singleVectorWrData45, singleVectorWrData44, singleVectorWrData43, singleVectorWrData42, singleVectorWrData41, singleVectorWrData40,
            singleVectorWrData39, singleVectorWrData38, singleVectorWrData37, singleVectorWrData36, singleVectorWrData35, singleVectorWrData34,
            singleVectorWrData33, singleVectorWrData32, singleVectorWrData31, singleVectorWrData30, singleVectorWrData29, singleVectorWrData28,
            singleVectorWrData27, singleVectorWrData26, singleVectorWrData25, singleVectorWrData24, singleVectorWrData23, singleVectorWrData22,
            singleVectorWrData21, singleVectorWrData20, singleVectorWrData19, singleVectorWrData18, singleVectorWrData17, singleVectorWrData16,
            singleVectorWrData15, singleVectorWrData14, singleVectorWrData13, singleVectorWrData12, singleVectorWrData11, singleVectorWrData10,
            singleVectorWrData9,  singleVectorWrData8,  singleVectorWrData7,  singleVectorWrData6,  singleVectorWrData5,  singleVectorWrData4,
            singleVectorWrData3,  singleVectorWrData2,  singleVectorWrData1,  singleVectorWrData0
           }; 
assign singleVectorWrDataMask_out = singleVectorWrDataMask;
assign singleVectorWrEn_out = singleVectorWrEn_reg;

assign execute_out = execute;
assign executeStart_out = executeStart;

assign instrBuffWrEn_out = instrBuffWrEn;

assign axi_data_out = S_AXI_WDATA;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

always @(*) begin
      instrBuffWrEn <= 4'd0;
      if(~execute && slv_reg_wren && ~slv_reg_wren_buffer && axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 7'h08) begin
        instrBuffWrEn <= 4'b1111;
      end
    end

    always @( posedge S_AXI_ACLK ) begin
      if ( S_AXI_ARESETN == 1'b0 | mb_reset == 1'b0) begin
        executeState <= IDLE_STATE;
        cycle_counter <= 32'd0;
      end
      else begin
        executeState <= executeStateNext;
        cycle_counter <= cycle_counter_next;
      end
    end

    always @(*) begin
      executeStateNext <= executeState;
      cycle_counter_next <= cycle_counter;
      executeStart <= 1'b0;
      resultsReady <= 1'b0;
      execute <= 1'b1;
      case(executeState)
        IDLE_STATE: begin
          execute <= 1'b0;
          if(slv_reg_wren && ~slv_reg_wren_buffer && axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 7'h00) begin
            executeStart <= 1'b1;
            executeStateNext <= EXECUTE_STATE;
            cycle_counter_next <= 32'd0;
          end
        end
        EXECUTE_STATE: begin
          cycle_counter_next <= cycle_counter + 32'd1;
          if(cu2dispatch_wf_done_in) begin
            executeStateNext <= RESULT_STATE;
          end
        end
        RESULT_STATE: begin
          resultsReady <= 1'b1;
          if(slv_reg_rden && axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 7'h00) begin
            executeStateNext <= IDLE_STATE;
          end
        end
        default: executeStateNext <= IDLE_STATE;
      endcase
    end

    always @(*) begin
      singleVectorWrEn_reg <= 4'd0;
      if(slv_reg_wren && ~slv_reg_wren_buffer && axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 7'h75) begin
        singleVectorWrEn_reg <= 4'b1111;
      end
    end
    
    always @(*) begin
      lsu2sgpr_dest_wr_en_reg <= 4'd0;
      if(slv_reg_wren && ~slv_reg_wren_buffer && axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 7'h0A) begin
        lsu2sgpr_dest_wr_en_reg <= 4'b1111;
      end
    end

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	    end
	  else
	    begin
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
	        begin
	          // slave is ready to accept write address when
	          // there is a valid write address and write data
	          // on the write address and data bus. This design
	          // expects no outstanding transactions.
	          axi_awready <= 1'b1;
	        end
	      else
	        begin
	          axi_awready <= 1'b0;
	        end
	    end
	end

	// Implement axi_awaddr latching
	// This process is used to latch the address when both
	// S_AXI_AWVALID and S_AXI_WVALID are valid.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end
	  else
	    begin
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
	        begin
	          // Write Address latching
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end
	end

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end
	  else
	    begin
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID)
	        begin
	          // slave is ready to accept write data when
	          // there is a valid write address and write data
	          // on the write address and data bus. This design
	          // expects no outstanding transactions.
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end
	end

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

	always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
      begin
        waveID    <= 32'd0;
        baseVGPR  <= 32'd0;
        baseSGPR  <= 32'd0;
        baseLDS   <= 32'd0;
        waveCount <= 32'd0;

        resultsReadyTag <= 32'd0;
        
        slv_reg_wren_buffer <= 1'b0;
        
        singleVectorWrDataMask <= 64'd0;
      end
      else begin
      	if( mb_reset == 1'b0)
            begin
              waveID    <= 32'd0;
              baseVGPR  <= 32'd0;
              baseSGPR  <= 32'd0;
              baseLDS   <= 32'd0;
              waveCount <= 32'd0;
      
              resultsReadyTag <= 32'd0;
              
              singleVectorWrDataMask <= 64'd0;
              
              slv_reg_wren_buffer <= 1'b0;
            end
        else
          begin
              slv_reg_wren_buffer <= slv_reg_wren;
              if(cu2dispatch_wf_done_in) begin
                resultsReadyTag <= resultsReadyTag_in;
              end
          end
        if (slv_reg_wren)
          begin
            case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
              // 7'h00: Start command initiate program
              7'h01: waveID       <= S_AXI_WDATA;
              7'h02: baseVGPR     <= S_AXI_WDATA;
              7'h03: baseSGPR     <= S_AXI_WDATA;
              7'h04: baseLDS      <= S_AXI_WDATA;
              7'h05: waveCount    <= S_AXI_WDATA;
              7'h06: pcStart      <= S_AXI_WDATA;
              7'h07: instrAddrReg <= S_AXI_WDATA;
              // 7'h08: Instruction value
              7'h09: mb_reset <= ~S_AXI_WDATA[0];
              // 7'h0A: GPR command register
              
              7'h0B: quadBaseAddress <= S_AXI_WDATA[9:0];
              7'h0C: quadData0 <= S_AXI_WDATA;
              7'h0D: quadData1 <= S_AXI_WDATA;
              7'h0E: quadData2 <= S_AXI_WDATA;
              7'h0F: quadData3 <= S_AXI_WDATA;
              
              7'h30: mb2fpgamem_data_in_reg <= S_AXI_WDATA;
              7'h31: mb2fpgamem_data_we_reg <= S_AXI_WDATA[0];
              7'h32: mb2fpgamem_ack_reg <= S_AXI_WDATA[0];
              7'h33: mb2fpgamem_done_reg <= S_AXI_WDATA[0];
              
              7'h34:
              begin
               singleVectorBaseAddress <= S_AXI_WDATA[9:0];
               singleVectorWrDataMask <= 64'd0;
              end
              
              7'h35:
              begin
               singleVectorWrData0 <= S_AXI_WDATA;
               singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000001;
              end
              7'h36:
              begin
               singleVectorWrData1 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000002;
              end
              7'h37:
              begin
               singleVectorWrData2 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000004;
              end
              7'h38:
              begin
               singleVectorWrData3 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000008;
              end
              7'h39:
              begin
               singleVectorWrData4 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000010;
              end
              7'h3a:
              begin
               singleVectorWrData5 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000020;
              end
              7'h3b:
              begin
               singleVectorWrData6 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000040;
              end
              7'h3c:
              begin
               singleVectorWrData7 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000080;
              end
              7'h3d:
              begin
               singleVectorWrData8 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000100;
              end
              7'h3e:
              begin
               singleVectorWrData9 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000200;
              end
              7'h3f:
              begin
               singleVectorWrData10 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000400;
              end
              
              7'h40:
              begin
               singleVectorWrData11 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000800;
              end
              7'h41:
              begin
               singleVectorWrData12 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000001000;
               end
              7'h42:
              begin
               singleVectorWrData13 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000002000;
              end
              7'h43:
              begin
               singleVectorWrData14 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000004000;
              end
              7'h44:
              begin
               singleVectorWrData15 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000008000;
              end
              7'h45:
              begin
               singleVectorWrData16 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000010000;
              end
              7'h46:
              begin
               singleVectorWrData17 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000020000;
              end
              7'h47:
              begin
               singleVectorWrData18 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000040000;
              end
              7'h48:
              begin
               singleVectorWrData19 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000080000;
              end
              7'h49:
              begin
               singleVectorWrData20 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000100000;
              end
              7'h4a:
              begin
               singleVectorWrData21 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000200000;
              end
              7'h4b:
              begin
               singleVectorWrData22 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000400000;
              end
              7'h4c:
              begin
               singleVectorWrData23 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000800000;
              end
              7'h4d:
              begin
               singleVectorWrData24 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000001000000;
              end
              7'h4e:
              begin
               singleVectorWrData25 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000002000000;
              end
              7'h4f:
              begin
               singleVectorWrData26 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000004000000;
              end
              
              7'h50:
              begin
               singleVectorWrData27 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000008000000;
              end
              7'h51:
              begin
               singleVectorWrData28 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000010000000;
              end
              7'h52:
              begin
               singleVectorWrData29 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000020000000;
              end
              7'h53:
              begin
               singleVectorWrData30 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000040000000;
              end
              7'h54:
              begin
               singleVectorWrData31 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000080000000;
              end
              7'h55:
              begin
               singleVectorWrData32 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000100000000;
              end
              7'h56:
              begin
               singleVectorWrData33 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000200000000;
              end
              7'h57:
              begin
               singleVectorWrData34 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000000400000000;
              end
              7'h58:
              begin
               singleVectorWrData35 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000000800000000;
              end
              7'h59:
              begin
               singleVectorWrData36 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000001000000000;
              end
              7'h5a:
              begin
               singleVectorWrData37 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000002000000000;
              end
              7'h5b:
              begin
               singleVectorWrData38 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000004000000000;
              end
              7'h5c:
              begin
               singleVectorWrData39 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000008000000000;
              end
              7'h5d:
              begin
               singleVectorWrData40 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000010000000000;
              end
              7'h5e:
              begin
               singleVectorWrData41 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000020000000000;
              end
              7'h5f:
              begin
               singleVectorWrData42 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000040000000000;
              end
              7'h60:
              begin
               singleVectorWrData43 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000080000000000;
              end
              7'h61:
              begin
               singleVectorWrData44 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000100000000000;
              end
              7'h62:
              begin
               singleVectorWrData45 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000200000000000;
              end
              7'h63:
              begin
               singleVectorWrData46 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000400000000000;
              end
              7'h64:
              begin
               singleVectorWrData47 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000800000000000;
              end
              7'h65:
              begin
               singleVectorWrData48 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0001000000000000;
              end
              7'h66:
              begin
               singleVectorWrData49 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0002000000000000;
              end
              7'h67:
              begin
               singleVectorWrData50 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0004000000000000;
              end
              7'h68:
              begin
               singleVectorWrData51 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0008000000000000;
              end
              7'h69:
              begin
               singleVectorWrData52 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0010000000000000;
              end
              7'h6a:
              begin
               singleVectorWrData53 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0020000000000000;
              end
              7'h6b:
              begin
               singleVectorWrData54 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0040000000000000;
              end
              7'h6c:
              begin
               singleVectorWrData55 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0080000000000000;
              end
              7'h6d:
              begin
               singleVectorWrData56 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0100000000000000;
              end
              7'h6e:
              begin
               singleVectorWrData57 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0200000000000000;
              end
              7'h6f:
              begin
               singleVectorWrData58 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0400000000000000;
              end
              7'h70:
              begin
               singleVectorWrData59 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0800000000000000;
              end
              7'h71:
              begin
               singleVectorWrData60 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h1000000000000000;
              end
              7'h72:
              begin
               singleVectorWrData61 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h2000000000000000;
              end
              7'h73:
              begin
               singleVectorWrData62 <= S_AXI_WDATA;
                singleVectorWrDataMask <= singleVectorWrDataMask |  64'h4000000000000000;
              end
              7'h74:
              begin
               singleVectorWrData63 <= S_AXI_WDATA;
               singleVectorWrDataMask <= singleVectorWrDataMask |  64'h8000000000000000;
              end
              //7'h75: Vector write command
              7'h76://reset_vector_values
              begin
                {         singleVectorWrData63, singleVectorWrData62, singleVectorWrData61, singleVectorWrData60, singleVectorWrData59, singleVectorWrData58,
                          singleVectorWrData57, singleVectorWrData56, singleVectorWrData55, singleVectorWrData54, singleVectorWrData53, singleVectorWrData52,
                          singleVectorWrData51, singleVectorWrData50, singleVectorWrData49, singleVectorWrData48, singleVectorWrData47, singleVectorWrData46,
                          singleVectorWrData45, singleVectorWrData44, singleVectorWrData43, singleVectorWrData42, singleVectorWrData41, singleVectorWrData40,
                          singleVectorWrData39, singleVectorWrData38, singleVectorWrData37, singleVectorWrData36, singleVectorWrData35, singleVectorWrData34,
                          singleVectorWrData33, singleVectorWrData32, singleVectorWrData31, singleVectorWrData30, singleVectorWrData29, singleVectorWrData28,
                          singleVectorWrData27, singleVectorWrData26, singleVectorWrData25, singleVectorWrData24, singleVectorWrData23, singleVectorWrData22,
                          singleVectorWrData21, singleVectorWrData20, singleVectorWrData19, singleVectorWrData18, singleVectorWrData17, singleVectorWrData16,
                          singleVectorWrData15, singleVectorWrData14, singleVectorWrData13, singleVectorWrData12, singleVectorWrData11, singleVectorWrData10,
                          singleVectorWrData9,  singleVectorWrData8,  singleVectorWrData7,  singleVectorWrData6,  singleVectorWrData5,  singleVectorWrData4,
                          singleVectorWrData3,  singleVectorWrData2,  singleVectorWrData1,  singleVectorWrData0
                         } <= 2048'd0;
                singleVectorWrDataMask <= 64'hffffffffffffffff;
              end
              7'h77://DataMask_Lo
                singleVectorWrDataMask[31:0] <= S_AXI_WDATA;
              7'h78://DataMask_Hi
                singleVectorWrDataMask[63:32] <= S_AXI_WDATA;
              
              default:
              begin
                waveID    <= waveID;
                baseVGPR  <= baseVGPR;
                baseSGPR  <= baseSGPR;
                baseLDS   <= baseLDS;
                waveCount <= waveCount;
              end
            endcase
          end
      end
    end

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.
	// This marks the acceptance of address and indicates the status of
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end
	  else
	    begin
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid)
	            //check if bready is asserted while bvalid is high)
	            //(there is a possibility that bready is always asserted high)
	            begin
	              axi_bvalid <= 1'b0;
	            end
	        end
	    end
	end

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is
	// de-asserted when reset (active low) is asserted.
	// The read address is also latched when S_AXI_ARVALID is
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end
	  else
	    begin
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end
	end

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers
	// data are available on the axi_rdata bus at this instance. The
	// assertion of axi_rvalid marks the validity of read data on the
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid
	// is deasserted on reset (active low). axi_rresp and axi_rdata are
	// cleared to zero on reset (active low).
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end
	  else
	    begin
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end
	    end
	end

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
	always @(*)
    begin
      // Address decoding for reading registers
      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
        7'h00   : reg_data_out <= resultsReady;
        7'h01   : reg_data_out <= waveID;
        7'h02   : reg_data_out <= baseVGPR;
        7'h03   : reg_data_out <= baseSGPR;
        7'h04   : reg_data_out <= baseLDS;
        7'h05   : reg_data_out <= waveCount;
        7'h06   : reg_data_out <= pcStart;
        7'h07   : reg_data_out <= instrAddrReg;
        7'h08   : reg_data_out <= instruction_buff_out_a_in;
        7'h09   : reg_data_out <= resultsReadyTag;
        //7'h0A   : unused
        7'h0B   : reg_data_out <= quadBaseAddress;
        7'h0C   : reg_data_out <= quadData_in[31:0];
        7'h0D   : reg_data_out <= quadData_in[63:32];
        7'h0E   : reg_data_out <= quadData_in[95:64];
        7'h0F   : reg_data_out <= quadData_in[127:96];
        
        7'h20   : reg_data_out <= fpgamem2mb_op_net;
        7'h21   : reg_data_out <= fpgamem2mb_data;
        7'h22   : reg_data_out <= fpgamem2mb_addr;
        
        7'h30   : reg_data_out <= cycle_counter;
        7'h31   : reg_data_out <= pc_value;
        7'h35   : reg_data_out <= singleVectorData_in[31:0];
        7'h36   : reg_data_out <= singleVectorData_in[63:32];
        7'h37   : reg_data_out <= singleVectorData_in[95:64];
        7'h38   : reg_data_out <= singleVectorData_in[127:96];
        7'h39   : reg_data_out <= singleVectorData_in[159:128];
        7'h3A   : reg_data_out <= singleVectorData_in[191:160];
        7'h3B   : reg_data_out <= singleVectorData_in[223:192];
        7'h3C   : reg_data_out <= singleVectorData_in[255:224];
        7'h3D   : reg_data_out <= singleVectorData_in[287:256];
        7'h3E   : reg_data_out <= singleVectorData_in[319:288];
        7'h3F   : reg_data_out <= singleVectorData_in[351:320];
        7'h40   : reg_data_out <= singleVectorData_in[383:352];
        7'h41   : reg_data_out <= singleVectorData_in[415:384];
        7'h42   : reg_data_out <= singleVectorData_in[447:416];
        7'h43   : reg_data_out <= singleVectorData_in[479:448];
        7'h44   : reg_data_out <= singleVectorData_in[511:480];
        
        7'h45   : reg_data_out <= singleVectorData_in[543:512];
        7'h46   : reg_data_out <= singleVectorData_in[575:544];
        7'h47   : reg_data_out <= singleVectorData_in[607:576];
        7'h48   : reg_data_out <= singleVectorData_in[639:608];
        7'h49   : reg_data_out <= singleVectorData_in[671:640];
        7'h4A   : reg_data_out <= singleVectorData_in[703:672];
        7'h4B   : reg_data_out <= singleVectorData_in[735:704];
        7'h4C   : reg_data_out <= singleVectorData_in[767:736];
        7'h4D   : reg_data_out <= singleVectorData_in[799:768];
        7'h4E   : reg_data_out <= singleVectorData_in[831:800];
        7'h4F   : reg_data_out <= singleVectorData_in[863:832];
        7'h50   : reg_data_out <= singleVectorData_in[895:864];
        7'h51   : reg_data_out <= singleVectorData_in[927:896];
        7'h52   : reg_data_out <= singleVectorData_in[959:928];
        7'h53   : reg_data_out <= singleVectorData_in[991:960];
        7'h54   : reg_data_out <= singleVectorData_in[1023:992];
        
        7'h55   : reg_data_out <= singleVectorData_in[1055:1024];
        7'h56   : reg_data_out <= singleVectorData_in[1087:1056];
        7'h57   : reg_data_out <= singleVectorData_in[1119:1088];
        7'h58   : reg_data_out <= singleVectorData_in[1151:1120];
        7'h59   : reg_data_out <= singleVectorData_in[1183:1152];
        7'h5A   : reg_data_out <= singleVectorData_in[1215:1184];
        7'h5B   : reg_data_out <= singleVectorData_in[1247:1216];
        7'h5C   : reg_data_out <= singleVectorData_in[1279:1248];
        7'h5D   : reg_data_out <= singleVectorData_in[1311:1280];
        7'h5E   : reg_data_out <= singleVectorData_in[1343:1312];
        7'h5F   : reg_data_out <= singleVectorData_in[1375:1344];
        7'h60   : reg_data_out <= singleVectorData_in[1407:1376];
        7'h61   : reg_data_out <= singleVectorData_in[1439:1408];
        7'h62   : reg_data_out <= singleVectorData_in[1471:1440];
        7'h63   : reg_data_out <= singleVectorData_in[1503:1472];
        7'h64   : reg_data_out <= singleVectorData_in[1535:1504];
                
        7'h65   : reg_data_out <= singleVectorData_in[1567:1536];
        7'h66   : reg_data_out <= singleVectorData_in[1599:1568];
        7'h67   : reg_data_out <= singleVectorData_in[1631:1600];
        7'h68   : reg_data_out <= singleVectorData_in[1663:1632];
        7'h69   : reg_data_out <= singleVectorData_in[1695:1664];
        7'h6A   : reg_data_out <= singleVectorData_in[1727:1696];
        7'h6B   : reg_data_out <= singleVectorData_in[1759:1728];
        7'h6C   : reg_data_out <= singleVectorData_in[1791:1760];
        7'h6D   : reg_data_out <= singleVectorData_in[1823:1792];
        7'h6E   : reg_data_out <= singleVectorData_in[1855:1824];
        7'h6F   : reg_data_out <= singleVectorData_in[1887:1856];
        7'h70   : reg_data_out <= singleVectorData_in[1919:1888];
        7'h71   : reg_data_out <= singleVectorData_in[1951:1920];
        7'h72   : reg_data_out <= singleVectorData_in[1983:1952];
        7'h73   : reg_data_out <= singleVectorData_in[2015:1984];
        7'h74   : reg_data_out <= singleVectorData_in[2047:2016];
        
        default : reg_data_out <= 0;
      endcase
    end

	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end
	  else
	    begin
	      // When there is a valid read address (S_AXI_ARVALID) with
	      // acceptance of read address by the slave (axi_arready),
	      // output the read dada
	      if (slv_reg_rden)
	        begin
	          axi_rdata <= reg_data_out;     // register read data
	        end
	    end
	end

	// Add user logic here

	// User logic ends

	endmodule
