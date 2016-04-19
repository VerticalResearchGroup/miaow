`timescale 1 ns / 1 ps

module compute_unit_fpga #
(
  // Users to add parameters here

  // User parameters ends
  // Do not modify the parameters beyond this line

  // Width of S_AXI data bus
  parameter integer C_S_AXI_DATA_WIDTH	= 32,
  // Width of S_AXI address bus
  parameter integer C_S_AXI_ADDR_WIDTH	= 11
)
(
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

// Example-specific design signals
// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
// ADDR_LSB is used for addressing 32/64 bit registers/memories
// ADDR_LSB = 2 for 32 bits (n downto 2)
// ADDR_LSB = 3 for 64 bits (n downto 3)
localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
localparam integer OPT_MEM_ADDR_BITS = 8;


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

//----------------------------------------------
//-- Signals for user logic register space example
//------------------------------------------------

wire rst;
wire clk;

wire slv_reg_wren;
wire slv_reg_rden;
reg slv_reg_wren_buffer;
reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;

assign clk = S_AXI_ACLK;

assign S_AXI_AWREADY	= axi_awready;
assign S_AXI_WREADY	= axi_wready;
assign S_AXI_BRESP	= axi_bresp;
assign S_AXI_BVALID	= axi_bvalid;
assign S_AXI_ARREADY	= axi_arready;
assign S_AXI_RDATA	= axi_rdata;
assign S_AXI_RRESP	= axi_rresp;
assign S_AXI_RVALID	= axi_rvalid;

wire fetch2buff_rd_en;
wire [31:0] fetch2buff_addr;
reg fetch2buff_rd_en_reg;
wire [38:0] fetch2buff_tag;
reg [38:0] fetch2buff_tag_reg;

wire cu2dispatch_wf_done;
wire [14:0] cu2dispatch_wf_tag_done;

wire [31:0] instruction_buff_out_a;
wire [31:0] instruction_buff_out_b;

// SGPR registers
reg [31:0] gprCommand;

wire mem2lsu_ack;
wire [6:0] mem2lsu_tag_resp;

wire lsu2mem_rd_en, lsu2mem_wr_en;
wire [6:0] lsu2mem_tag_req;

wire [31:0]   lsu2mem_wr_data, mem2lsu_rd_data, lsu2mem_addr;
wire [2047:0] lsu2vgpr_dest_data, vgpr2lsu_source1_data;

wire [3:0] fpgamem2mb_op;
wire [31:0] fpgamem2mb_data;
wire [31:0] fpgamem2mb_addr;

reg mb2fpgamem_data_we;
reg mb2fpgamem_ack_reg;
reg mb2fpgamem_done_reg;

reg [C_S_AXI_DATA_WIDTH-1:0] waveID;
reg [C_S_AXI_DATA_WIDTH-1:0] baseVGPR;
reg [C_S_AXI_DATA_WIDTH-1:0] baseSGPR;
reg [C_S_AXI_DATA_WIDTH-1:0] baseLDS;
reg [C_S_AXI_DATA_WIDTH-1:0] waveCount;
reg [C_S_AXI_DATA_WIDTH-1:0] pcStart;
reg [C_S_AXI_DATA_WIDTH-1:0] resultsReady;
reg [C_S_AXI_DATA_WIDTH-1:0] resultsReadyTag;

reg instrBuffWrEn;
reg [31:0] instrAddrReg;

reg [8:0] quadBaseAddress;
reg [31:0] quadData0;
reg [31:0] quadData1;
reg [31:0] quadData2;
reg [31:0] quadData3;
reg lsu2sgpr_dest_wr_en_reg;

wire [127:0] sgpr2lsu_source1_data;

reg [9:0]  singleVectorBaseAddress;

reg [63:0] singleVectorWrDataMask;
reg lsu2vgpr_dest_wr_en_reg;

`define IDLE_STATE 4'd0
`define DISPATCH_STATE 4'd1
`define EXECUTE_STATE 4'd2
`define RESULT_STATE 4'd3

reg [3:0] executeState;
reg [3:0] executeStateNext;

reg executeStart;
reg dispatch_idle;

reg mb_reset;

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


always @( posedge S_AXI_ACLK ) begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
    executeState <= `IDLE_STATE;
    //cycle_counter <= 32'd0;
  end
  else begin
    executeState <= executeStateNext;
    //cycle_counter <= cycle_counter_next;
  end
end

always @(*) begin
  executeStateNext <= executeState;
  //cycle_counter_next <= cycle_counter;
  executeStart <= 1'b0;
  resultsReady <= 32'd0;
  dispatch_idle <= 1'b0;
  //cycle_counter_wr_reg <= 1'b0;
  case(executeState)
    `IDLE_STATE: begin
      dispatch_idle <= 1'b1;
      if(slv_reg_wren && ~slv_reg_wren_buffer && axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 9'h000) begin
        executeStart <= 1'b1;
        executeStateNext <= `EXECUTE_STATE;
        //cycle_counter_next <= 32'd0;
      end
    end
    `EXECUTE_STATE: begin
      //cycle_counter_next <= cycle_counter + 32'd1;
      //cycle_counter_wr_reg <= 1'b1;
      if(cu2dispatch_wf_done) begin
        executeStateNext <= `RESULT_STATE;
      end
    end
    `RESULT_STATE: begin
      resultsReady <= 32'd1;
      if(slv_reg_rden && axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 9'h000) begin
        executeStateNext <= `IDLE_STATE;
      end
    end
  endcase
end

assign rst = ~S_AXI_ARESETN;

assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;
assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;

// Implement axi_awready generation
// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
// de-asserted when reset is low.

always @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
    axi_awready <= 1'b0;
  end
  else begin
    if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID) begin
      // slave is ready to accept write address when
      // there is a valid write address and write data
      // on the write address and data bus. This design
      // expects no outstanding transactions.
      axi_awready <= 1'b1;
    end
    else begin
      axi_awready <= 1'b0;
    end
  end
end

// Implement axi_awaddr latching
// This process is used to latch the address when both
// S_AXI_AWVALID and S_AXI_WVALID are valid.

always @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
    axi_awaddr <= 0;
  end
  else begin
    if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID) begin
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
  if ( S_AXI_ARESETN == 1'b0 ) begin
    axi_wready <= 1'b0;
  end
  else begin
    if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID) begin
      // slave is ready to accept write data when
      // there is a valid write address and write data
      // on the write address and data bus. This design
      // expects no outstanding transactions.
      axi_wready <= 1'b1;
    end
    else begin
      axi_wready <= 1'b0;
    end
  end
end

// Implement write response logic generation
// The write response and response valid signals are asserted by the slave 
// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
// This marks the acceptance of address and indicates the status of 
// write transaction.

always @( posedge S_AXI_ACLK ) begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
    axi_bvalid  <= 0;
    axi_bresp   <= 2'b0;
  end
  else begin
    if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID) begin
      // indicates a valid write response is available
      axi_bvalid <= 1'b1;
      axi_bresp  <= 2'b0; // 'OKAY' response 
    end                   // work error responses in future
    else begin
      if (S_AXI_BREADY && axi_bvalid) begin
        //check if bready is asserted while bvalid is high) 
        //(there is a possibility that bready is always asserted high)   
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

always @( posedge S_AXI_ACLK ) begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
    axi_arready <= 1'b0;
    axi_araddr  <= 32'b0;
  end
  else begin
    if (~axi_arready && S_AXI_ARVALID) begin
      // indicates that the slave has accepted the valid read address
      axi_arready <= 1'b1;
      // Read address latching
      axi_araddr  <= S_AXI_ARADDR;
    end
    else begin
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
always @( posedge S_AXI_ACLK ) begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
    axi_rvalid <= 0;
    axi_rresp  <= 0;
  end
  else begin    
    if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
      // Valid read data is available at the read data bus
      axi_rvalid <= 1'b1;
      axi_rresp  <= 2'b0; // 'OKAY' response
    end
    else if (axi_rvalid && S_AXI_RREADY) begin
      // Read data is accepted by the master
      axi_rvalid <= 1'b0;
    end
  end
end 

always @(*) begin
  lsu2sgpr_dest_wr_en_reg <= 1'b0;
  lsu2vgpr_dest_wr_en_reg <= 1'b0;
  instrBuffWrEn <= 1'b1;
  mb2fpgamem_data_we <= 1'b0;
  if(slv_reg_wren && ~slv_reg_wren_buffer && axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 9'h0C0) begin
    case(S_AXI_WDATA)
      32'd0: lsu2sgpr_dest_wr_en_reg <= 1'b1;
      32'd1: lsu2vgpr_dest_wr_en_reg <= 1'b1;
    endcase
  end
  
  if(dispatch_idle && slv_reg_wren && ~slv_reg_wren_buffer && axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 9'h008) begin
    instrBuffWrEn <= 1'b1;
  end
  
  if(slv_reg_wren && ~slv_reg_wren_buffer && axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 9'h041) begin
    mb2fpgamem_data_we <= 1'b1;
  end
end

always @( posedge S_AXI_ACLK ) begin
  if ( S_AXI_ARESETN == 1'b0) begin
    mb_reset <= 1'b1;
  end
  else begin
    mb_reset <= mb_reset;
    if (slv_reg_wren && axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 9'h009) begin
      mb_reset <= ~S_AXI_WDATA[0];
    end
  end
end

always @( posedge S_AXI_ACLK ) begin
  if ( S_AXI_ARESETN == 1'b0 || mb_reset == 1'b0 ) begin
    waveID    <= 32'd0;
    baseVGPR  <= 32'd0;
    baseSGPR  <= 32'd0;
    baseLDS   <= 32'd0;
    waveCount <= 32'd0;

    resultsReadyTag <= 32'd0;

    slv_reg_wren_buffer <= 1'b0;
    
    mb2fpgamem_ack_reg <= 1'b0;
    mb2fpgamem_done_reg <= 1'b0;
    
    quadBaseAddress <= 9'd0;
    quadData0 <= 32'd0;
    quadData1 <= 32'd0;
    quadData2 <= 32'd0;
    quadData3 <= 32'd0;
    
    singleVectorBaseAddress <= 10'd0;

    singleVectorWrDataMask <= 64'd0;
    {
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
    } <= 2048'd0;
  end
  else begin
    slv_reg_wren_buffer <= slv_reg_wren;
    if(cu2dispatch_wf_done) begin
      resultsReadyTag <= {17'd0, cu2dispatch_wf_tag_done};
    end
    if (slv_reg_wren) begin
      case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
        // 9'h00: Start command initiate program
        9'h001: waveID       <= S_AXI_WDATA;
        9'h002: baseVGPR     <= S_AXI_WDATA;
        9'h003: baseSGPR     <= S_AXI_WDATA;
        9'h004: baseLDS      <= S_AXI_WDATA;
        9'h005: waveCount    <= S_AXI_WDATA;
        9'h006: pcStart      <= S_AXI_WDATA;
        9'h007: instrAddrReg <= S_AXI_WDATA;
        // 9'h008: Instruction value
        // 9'h009: MB reset
        
        // 0x0100
        // Memory registers
        //9'h40: Writes to this address result in a write to the FPGA memory buffer
        9'h041: mb2fpgamem_ack_reg <= S_AXI_WDATA[0];
        9'h042: mb2fpgamem_done_reg <= S_AXI_WDATA[0];
        
        // 0x0300
        // 9'h0C0: GPR command register, used for both vector and scalar ops
        // Scalar register registers
        9'h0C1: quadBaseAddress <= S_AXI_WDATA[8:0];
        9'h0C2: quadData0 <= S_AXI_WDATA;
        9'h0C3: quadData1 <= S_AXI_WDATA;
        9'h0C4: quadData2 <= S_AXI_WDATA;
        9'h0C5: quadData3 <= S_AXI_WDATA;
        // Vector register configuration registers
        9'h0C6: singleVectorBaseAddress <= S_AXI_WDATA[9:0];
        //9'h75: Vector write command
        // Reset vector register inputs
        9'h0C8: begin
          {
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
          } <= 2048'd0;
        end
        //DataMask_Lo
        9'h0C9: singleVectorWrDataMask[31:0] <= S_AXI_WDATA;
        //DataMask_Hi
        9'h0CA: singleVectorWrDataMask[63:32] <= S_AXI_WDATA;
        // 0x400
        // Vector register data registers
        9'h100: begin
          singleVectorWrData0 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000001;
        end
        9'h101: begin
          singleVectorWrData1 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000002;
        end
        9'h102: begin
          singleVectorWrData2 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000004;
        end
        9'h103: begin
          singleVectorWrData3 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000008;
        end
        9'h104: begin
          singleVectorWrData4 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000010;
        end
        9'h105: begin
          singleVectorWrData5 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000020;
        end
        9'h106: begin
          singleVectorWrData6 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000040;
        end
        9'h107: begin
          singleVectorWrData7 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000080;
        end
        9'h108: begin
          singleVectorWrData8 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000100;
        end
        9'h109: begin
          singleVectorWrData9 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000200;
        end
        9'h10A: begin
          singleVectorWrData10 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000400;
        end
        9'h10B: begin
          singleVectorWrData11 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000000800;
        end
        9'h10C: begin
          singleVectorWrData12 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000001000;
         end
        9'h10D: begin
          singleVectorWrData13 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000002000;
        end
        9'h10E: begin
          singleVectorWrData14 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000004000;
        end
        9'h10F: begin
          singleVectorWrData15 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000008000;
        end
        9'h110: begin
          singleVectorWrData16 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000010000;
        end
        9'h111: begin
          singleVectorWrData17 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000020000;
        end
        9'h112: begin
          singleVectorWrData18 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000040000;
        end
        9'h113: begin
          singleVectorWrData19 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000080000;
        end
        9'h114: begin
          singleVectorWrData20 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000100000;
        end
        9'h115: begin
          singleVectorWrData21 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000200000;
        end
        9'h116: begin
          singleVectorWrData22 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000400000;
        end
        9'h117: begin
          singleVectorWrData23 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000000800000;
        end
        9'h118: begin
          singleVectorWrData24 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000001000000;
        end
        9'h119: begin
          singleVectorWrData25 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000002000000;
        end
        9'h11A: begin
          singleVectorWrData26 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000004000000;
        end
        9'h11B: begin
          singleVectorWrData27 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000008000000;
        end
        9'h11C: begin
          singleVectorWrData28 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000010000000;
        end
        9'h11D: begin
          singleVectorWrData29 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000020000000;
        end
        9'h11E: begin
          singleVectorWrData30 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000040000000;
        end
        9'h11F: begin
          singleVectorWrData31 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000080000000;
        end
        9'h120: begin
          singleVectorWrData32 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000100000000;
        end
        9'h121: begin
          singleVectorWrData33 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000000200000000;
        end
        9'h122: begin
          singleVectorWrData34 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000000400000000;
        end
        9'h123: begin
          singleVectorWrData35 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000000800000000;
        end
        9'h124: begin
          singleVectorWrData36 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |   64'h0000001000000000;
        end
        9'h125: begin
          singleVectorWrData37 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000002000000000;
        end
        9'h126: begin
          singleVectorWrData38 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000004000000000;
        end
        9'h127: begin
          singleVectorWrData39 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000008000000000;
        end
        9'h128: begin
          singleVectorWrData40 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000010000000000;
        end
        9'h129: begin
          singleVectorWrData41 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000020000000000;
        end
        9'h12A: begin
          singleVectorWrData42 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000040000000000;
        end
        9'h12B: begin
          singleVectorWrData43 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000080000000000;
        end
        9'h12C: begin
          singleVectorWrData44 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000100000000000;
        end
        9'h12D: begin
          singleVectorWrData45 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000200000000000;
        end
        9'h12E: begin
          singleVectorWrData46 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000400000000000;
        end
        9'h12F: begin
          singleVectorWrData47 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0000800000000000;
        end
        9'h130: begin
          singleVectorWrData48 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0001000000000000;
        end
        9'h131: begin
          singleVectorWrData49 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0002000000000000;
        end
        9'h132: begin
          singleVectorWrData50 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0004000000000000;
        end
        9'h133: begin
          singleVectorWrData51 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0008000000000000;
        end
        9'h134: begin
          singleVectorWrData52 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0010000000000000;
        end
        9'h135: begin
          singleVectorWrData53 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0020000000000000;
        end
        9'h136: begin
          singleVectorWrData54 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0040000000000000;
        end
        9'h137: begin
          singleVectorWrData55 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0080000000000000;
        end
        9'h138: begin
          singleVectorWrData56 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0100000000000000;
        end
        9'h139: begin
          singleVectorWrData57 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0200000000000000;
        end
        9'h13A: begin
          singleVectorWrData58 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0400000000000000;
        end
        9'h13B: begin
          singleVectorWrData59 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h0800000000000000;
        end
        9'h13C: begin
          singleVectorWrData60 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h1000000000000000;
        end
        9'h13D: begin
          singleVectorWrData61 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h2000000000000000;
        end
        9'h13E: begin
          singleVectorWrData62 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h4000000000000000;
        end
        9'h13F: begin
          singleVectorWrData63 <= S_AXI_WDATA;
          singleVectorWrDataMask <= singleVectorWrDataMask |  64'h8000000000000000;
        end

        default: begin
          waveID    <= waveID;
          baseVGPR  <= baseVGPR;
          baseSGPR  <= baseSGPR;
          baseLDS   <= baseLDS;
          waveCount <= waveCount;
          pcStart   <= pcStart;
          instrAddrReg <= instrAddrReg;
          
          mb2fpgamem_ack_reg <= mb2fpgamem_ack_reg;
          mb2fpgamem_done_reg <= mb2fpgamem_done_reg;
          
          quadBaseAddress <= quadBaseAddress;
          quadData0 <= quadData0;
          quadData1 <= quadData1;
          quadData2 <= quadData2;
          quadData3 <= quadData3;
          
          singleVectorBaseAddress <= singleVectorBaseAddress;
          singleVectorWrDataMask <= singleVectorWrDataMask;
          
          singleVectorWrData63 <= singleVectorWrData63;
          singleVectorWrData62 <= singleVectorWrData62;
          singleVectorWrData61 <= singleVectorWrData61;
          singleVectorWrData60 <= singleVectorWrData60;
          singleVectorWrData59 <= singleVectorWrData59;
          singleVectorWrData58 <= singleVectorWrData58;
          singleVectorWrData57 <= singleVectorWrData57;
          singleVectorWrData56 <= singleVectorWrData56;
          singleVectorWrData55 <= singleVectorWrData55;
          singleVectorWrData54 <= singleVectorWrData54;
          singleVectorWrData53 <= singleVectorWrData53;
          singleVectorWrData52 <= singleVectorWrData52;
          singleVectorWrData51 <= singleVectorWrData51;
          singleVectorWrData50 <= singleVectorWrData50;
          singleVectorWrData49 <= singleVectorWrData49;
          singleVectorWrData48 <= singleVectorWrData48;
          singleVectorWrData47 <= singleVectorWrData47;
          singleVectorWrData46 <= singleVectorWrData46;
          singleVectorWrData45 <= singleVectorWrData45;
          singleVectorWrData44 <= singleVectorWrData44;
          singleVectorWrData43 <= singleVectorWrData43;
          singleVectorWrData42 <= singleVectorWrData42;
          singleVectorWrData41 <= singleVectorWrData41;
          singleVectorWrData40 <= singleVectorWrData40;
          singleVectorWrData39 <= singleVectorWrData39;
          singleVectorWrData38 <= singleVectorWrData38;
          singleVectorWrData37 <= singleVectorWrData37;
          singleVectorWrData36 <= singleVectorWrData36;
          singleVectorWrData35 <= singleVectorWrData35;
          singleVectorWrData34 <= singleVectorWrData34;
          singleVectorWrData33 <= singleVectorWrData33;
          singleVectorWrData32 <= singleVectorWrData32;
          singleVectorWrData31 <= singleVectorWrData31;
          singleVectorWrData30 <= singleVectorWrData30;
          singleVectorWrData29 <= singleVectorWrData29;
          singleVectorWrData28 <= singleVectorWrData28;
          singleVectorWrData27 <= singleVectorWrData27;
          singleVectorWrData26 <= singleVectorWrData26;
          singleVectorWrData25 <= singleVectorWrData25;
          singleVectorWrData24 <= singleVectorWrData24;
          singleVectorWrData23 <= singleVectorWrData23;
          singleVectorWrData22 <= singleVectorWrData22;
          singleVectorWrData21 <= singleVectorWrData21;
          singleVectorWrData20 <= singleVectorWrData20;
          singleVectorWrData19 <= singleVectorWrData19;
          singleVectorWrData18 <= singleVectorWrData18;
          singleVectorWrData17 <= singleVectorWrData17;
          singleVectorWrData16 <= singleVectorWrData16;
          singleVectorWrData15 <= singleVectorWrData15;
          singleVectorWrData14 <= singleVectorWrData14;
          singleVectorWrData13 <= singleVectorWrData13;
          singleVectorWrData12 <= singleVectorWrData12;
          singleVectorWrData11 <= singleVectorWrData11;
          singleVectorWrData10 <= singleVectorWrData10;
          singleVectorWrData9 <= singleVectorWrData9;
          singleVectorWrData8 <= singleVectorWrData8;
          singleVectorWrData7 <= singleVectorWrData7;
          singleVectorWrData6 <= singleVectorWrData6;
          singleVectorWrData5 <= singleVectorWrData5;
          singleVectorWrData4 <= singleVectorWrData4;
          singleVectorWrData3 <= singleVectorWrData3;
          singleVectorWrData2 <= singleVectorWrData2;
          singleVectorWrData1 <= singleVectorWrData1;
          singleVectorWrData0 <= singleVectorWrData0;
        end
      endcase
    end
  end
end

always @(*) begin
  // Address decoding for reading registers
  case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
    9'h000  : reg_data_out <= resultsReady;
    9'h001  : reg_data_out <= waveID;
    9'h002  : reg_data_out <= baseVGPR;
    9'h003  : reg_data_out <= baseSGPR;
    9'h004  : reg_data_out <= baseLDS;
    9'h005  : reg_data_out <= waveCount;
    9'h006  : reg_data_out <= pcStart;
    9'h007  : reg_data_out <= instrAddrReg;
    9'h008  : reg_data_out <= instruction_buff_out_a;
    9'h009  : reg_data_out <= resultsReadyTag;
    //9'h00A   : unused
    9'h0C1  : reg_data_out <= quadBaseAddress;
    9'h0C2  : reg_data_out <= sgpr2lsu_source1_data[31:0];
    9'h0C3  : reg_data_out <= sgpr2lsu_source1_data[63:32];
    9'h0C4  : reg_data_out <= sgpr2lsu_source1_data[95:64];
    9'h0C5  : reg_data_out <= sgpr2lsu_source1_data[127:96];
    
    9'h040  : reg_data_out <= {28'd0, fpgamem2mb_op};
    9'h041  : reg_data_out <= fpgamem2mb_data;
    9'h042  : reg_data_out <= fpgamem2mb_addr;
    
    //7'h30   : reg_data_out <= cycle_counter;
    //7'h31   : reg_data_out <= pc_value;
    
    9'h100  : reg_data_out <= vgpr2lsu_source1_data[31:0];
    9'h101  : reg_data_out <= vgpr2lsu_source1_data[63:32];
    9'h102  : reg_data_out <= vgpr2lsu_source1_data[95:64];
    9'h103  : reg_data_out <= vgpr2lsu_source1_data[127:96];
    9'h104  : reg_data_out <= vgpr2lsu_source1_data[159:128];
    9'h105  : reg_data_out <= vgpr2lsu_source1_data[191:160];
    9'h106  : reg_data_out <= vgpr2lsu_source1_data[223:192];
    9'h107  : reg_data_out <= vgpr2lsu_source1_data[255:224];
    9'h108  : reg_data_out <= vgpr2lsu_source1_data[287:256];
    9'h109  : reg_data_out <= vgpr2lsu_source1_data[319:288];
    9'h10A  : reg_data_out <= vgpr2lsu_source1_data[351:320];
    9'h10B  : reg_data_out <= vgpr2lsu_source1_data[383:352];
    9'h10C  : reg_data_out <= vgpr2lsu_source1_data[415:384];
    9'h10D  : reg_data_out <= vgpr2lsu_source1_data[447:416];
    9'h10E  : reg_data_out <= vgpr2lsu_source1_data[479:448];
    9'h10F  : reg_data_out <= vgpr2lsu_source1_data[511:480];
    
    9'h110  : reg_data_out <= vgpr2lsu_source1_data[543:512];
    9'h111  : reg_data_out <= vgpr2lsu_source1_data[575:544];
    9'h112  : reg_data_out <= vgpr2lsu_source1_data[607:576];
    9'h113  : reg_data_out <= vgpr2lsu_source1_data[639:608];
    9'h114  : reg_data_out <= vgpr2lsu_source1_data[671:640];
    9'h115  : reg_data_out <= vgpr2lsu_source1_data[703:672];
    9'h116  : reg_data_out <= vgpr2lsu_source1_data[735:704];
    9'h117  : reg_data_out <= vgpr2lsu_source1_data[767:736];
    9'h118  : reg_data_out <= vgpr2lsu_source1_data[799:768];
    9'h119  : reg_data_out <= vgpr2lsu_source1_data[831:800];
    9'h11A  : reg_data_out <= vgpr2lsu_source1_data[863:832];
    9'h11B  : reg_data_out <= vgpr2lsu_source1_data[895:864];
    9'h11C  : reg_data_out <= vgpr2lsu_source1_data[927:896];
    9'h11D  : reg_data_out <= vgpr2lsu_source1_data[959:928];
    9'h11E  : reg_data_out <= vgpr2lsu_source1_data[991:960];
    9'h11F  : reg_data_out <= vgpr2lsu_source1_data[1023:992];
    
    9'h120  : reg_data_out <= vgpr2lsu_source1_data[1055:1024];
    9'h121  : reg_data_out <= vgpr2lsu_source1_data[1087:1056];
    9'h122  : reg_data_out <= vgpr2lsu_source1_data[1119:1088];
    9'h123  : reg_data_out <= vgpr2lsu_source1_data[1151:1120];
    9'h124  : reg_data_out <= vgpr2lsu_source1_data[1183:1152];
    9'h125  : reg_data_out <= vgpr2lsu_source1_data[1215:1184];
    9'h126  : reg_data_out <= vgpr2lsu_source1_data[1247:1216];
    9'h127  : reg_data_out <= vgpr2lsu_source1_data[1279:1248];
    9'h128  : reg_data_out <= vgpr2lsu_source1_data[1311:1280];
    9'h129  : reg_data_out <= vgpr2lsu_source1_data[1343:1312];
    9'h12A  : reg_data_out <= vgpr2lsu_source1_data[1375:1344];
    9'h12B  : reg_data_out <= vgpr2lsu_source1_data[1407:1376];
    9'h12C  : reg_data_out <= vgpr2lsu_source1_data[1439:1408];
    9'h12D  : reg_data_out <= vgpr2lsu_source1_data[1471:1440];
    9'h12E  : reg_data_out <= vgpr2lsu_source1_data[1503:1472];
    9'h12F  : reg_data_out <= vgpr2lsu_source1_data[1535:1504];
            
    9'h130  : reg_data_out <= vgpr2lsu_source1_data[1567:1536];
    9'h131  : reg_data_out <= vgpr2lsu_source1_data[1599:1568];
    9'h132  : reg_data_out <= vgpr2lsu_source1_data[1631:1600];
    9'h133  : reg_data_out <= vgpr2lsu_source1_data[1663:1632];
    9'h134  : reg_data_out <= vgpr2lsu_source1_data[1695:1664];
    9'h135  : reg_data_out <= vgpr2lsu_source1_data[1727:1696];
    9'h136  : reg_data_out <= vgpr2lsu_source1_data[1759:1728];
    9'h137  : reg_data_out <= vgpr2lsu_source1_data[1791:1760];
    9'h138  : reg_data_out <= vgpr2lsu_source1_data[1823:1792];
    9'h139  : reg_data_out <= vgpr2lsu_source1_data[1855:1824];
    9'h13A  : reg_data_out <= vgpr2lsu_source1_data[1887:1856];
    9'h13B  : reg_data_out <= vgpr2lsu_source1_data[1919:1888];
    9'h13C  : reg_data_out <= vgpr2lsu_source1_data[1951:1920];
    9'h13D  : reg_data_out <= vgpr2lsu_source1_data[1983:1952];
    9'h13E  : reg_data_out <= vgpr2lsu_source1_data[2015:1984];
    9'h13F  : reg_data_out <= vgpr2lsu_source1_data[2047:2016];
    
    default : reg_data_out <= 0;
  endcase
end

always @( posedge S_AXI_ACLK ) begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
    axi_rdata  <= 0;
  end
  else begin
    // When there is a valid read address (S_AXI_ARVALID) with
    // acceptance of read address by the slave (axi_arready),
    // output the read dada
    if (slv_reg_rden) begin
      axi_rdata <= reg_data_out;     // register read data
    end
  end
end

assign lsu2vgpr_dest_data = {
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
// I/O Connections assignments

assign buff2wave_tag = fetch2buff_tag_reg;
assign buff2fetchwave_ack = fetch2buff_rd_en_reg;
assign buff2wave_instr = instruction_buff_out_b;

always @( posedge clk) begin
  fetch2buff_tag_reg <= fetch2buff_tag;
  fetch2buff_rd_en_reg <= fetch2buff_rd_en;
  //buff2wave_instr_reg <= instruction_buff_out_b;
end

//assign pc_value = fetch2buff_addr;

block_ram instruction_buffer
(
  .clka(clk), // input clka
  //.rsta(rst), // input rsta
  .wea(instrBuffWrEn), // input [3 : 0] wea
  .addra(instrAddrReg[9:0]), // input [31 : 0] addra
  .dina(S_AXI_WDATA), // input [31 : 0] dina
  .douta(instruction_buff_out_a), // output [31 : 0] douta
  .clkb(clk), // input clkb
  //.rstb(rst), // input rstb
  .web(1'b0), // input [3 : 0] web
  .addrb(fetch2buff_addr[11:2]), // input [31 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb(instruction_buff_out_b) // output [31 : 0] doutb
);

compute_unit compute_unit0
(
  // Outputs
  .cu2dispatch_wf_done(cu2dispatch_wf_done),
  .cu2dispatch_wf_tag_done(cu2dispatch_wf_tag_done),
  .fetch2buff_rd_en(fetch2buff_rd_en),
  .fetch2buff_addr(fetch2buff_addr),
  .fetch2buff_tag(fetch2buff_tag),
  .lsu2mem_rd_en(lsu2mem_rd_en),
  .lsu2mem_wr_en(lsu2mem_wr_en),
  .lsu2mem_tag_req(lsu2mem_tag_req),
  .lsu2mem_wr_mask(),
  .lsu2mem_addr(lsu2mem_addr),
  .lsu2mem_wr_data(lsu2mem_wr_data),
  .lsu2mem_gm_or_lds(),
  .sgpr2dispatch_rd_data(sgpr2lsu_source1_data),
  .vgpr2dispatch_rd_data(vgpr2lsu_source1_data),
  // Inputs
  .dispatch2cu_idle(dispatch_idle),
  .dispatch2sgpr_addr(quadBaseAddress),
  .dispatch2sgpr_wr_data({quadData3, quadData2, quadData1, quadData0}),
  .dispatch2sgpr_wr_en(lsu2sgpr_dest_wr_en_reg),
  .dispatch2vgpr_addr(singleVectorBaseAddress),
  .dispatch2vgpr_wr_data(lsu2vgpr_dest_data),
  .dispatch2vgpr_wr_en(lsu2vgpr_dest_wr_en_reg),
  .dispatch2vgpr_wr_mask(singleVectorWrDataMask),
  .dispatch2cu_wf_dispatch(executeStart),
  .dispatch2cu_wf_tag_dispatch(waveID[14:0]),
  .dispatch2cu_start_pc_dispatch(pcStart),
  .dispatch2cu_sgpr_base_dispatch(baseSGPR[8:0]),
  .dispatch2cu_vgpr_base_dispatch(baseVGPR[9:0]),
  .dispatch2cu_lds_base_dispatch(baseLDS[15:0]),
  // Instruction buffer
  .buff2fetchwave_ack(fetch2buff_rd_en_reg),
  .buff2wave_instr(instruction_buff_out_b),
  .buff2wave_tag(fetch2buff_tag_reg),
  .dispatch2cu_wg_wf_count(4'd1),
  .dispatch2cu_wf_size_dispatch(waveCount[5:0]),
  .mem2lsu_ack(mem2lsu_ack),
  .mem2lsu_tag_resp(mem2lsu_tag_resp),
  .mem2lsu_rd_data(mem2lsu_rd_data),
  
  .clk(clk),
  .rst(rst)
);
  
fpga_memory fpga_memory0(
  .mem_wr_en(lsu2mem_wr_en),
  .mem_rd_en(lsu2mem_rd_en),
  .mem_addr(lsu2mem_addr),
  .mem_wr_data(lsu2mem_wr_data),
  .mem_tag_req(lsu2mem_tag_req),
  
  // MB
  //.mb_data_in(mb2fpgamem_data_in_reg),S_AXI_WDATA
  .mb_data_in(S_AXI_WDATA),
  .mb_data_we(mb2fpgamem_data_we),
  .mb_ack(mb2fpgamem_ack_reg),
  .mb_done(mb2fpgamem_done_reg),
  
  .clk(clk),
  .rst(rst),
  // output
  // LSU
  .mem_tag_resp(mem2lsu_tag_resp),
  .mem_rd_data(mem2lsu_rd_data),
  .mem_ack(mem2lsu_ack),
  
  // MB
  .mb_op(fpgamem2mb_op),
  .mb_data_out(fpgamem2mb_data),
  .mb_addr(fpgamem2mb_addr)
);

endmodule
