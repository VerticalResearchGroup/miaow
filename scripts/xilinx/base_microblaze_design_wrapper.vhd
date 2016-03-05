--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.1 (win64) Build 1215546 Mon Apr 27 19:22:08 MDT 2015
--Date        : Thu Aug 13 11:34:27 2015
--Host        : youko running 64-bit major release  (build 9200)
--Command     : generate_target base_microblaze_design_wrapper.bd
--Design      : base_microblaze_design_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity base_microblaze_design_wrapper is
  port (
    ddr3_sdram_addr : out STD_LOGIC_VECTOR ( 13 downto 0 );
    ddr3_sdram_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    ddr3_sdram_cas_n : out STD_LOGIC;
    ddr3_sdram_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_cs_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_dm : out STD_LOGIC_VECTOR ( 7 downto 0 );
    ddr3_sdram_dq : inout STD_LOGIC_VECTOR ( 63 downto 0 );
    ddr3_sdram_dqs_n : inout STD_LOGIC_VECTOR ( 7 downto 0 );
    ddr3_sdram_dqs_p : inout STD_LOGIC_VECTOR ( 7 downto 0 );
    ddr3_sdram_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_ras_n : out STD_LOGIC;
    ddr3_sdram_reset_n : out STD_LOGIC;
    ddr3_sdram_we_n : out STD_LOGIC;
    led_8bits_tri_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    
    reset : in STD_LOGIC;
    rs232_uart_rxd : in STD_LOGIC;
    rs232_uart_txd : out STD_LOGIC;
    sys_diff_clock_0_clk_n : in STD_LOGIC;
    sys_diff_clock_0_clk_p : in STD_LOGIC
  );
end base_microblaze_design_wrapper;

architecture STRUCTURE of base_microblaze_design_wrapper is

  signal waveID_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal baseVGPR_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal baseSGPR_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal baseLDS_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal waveCount_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal pcStart_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal instrAddrReg_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal instruction_buff_out_a_in : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal cu2dispatch_wf_done_in : STD_LOGIC;
  signal resultsReadyTag_in : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal lsu2sgpr_dest_wr_en_out : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal quadBaseAddress_out : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal quadData0_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal quadData1_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal quadData2_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal quadData3_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal quadData_in : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal execute_out : STD_LOGIC;
  signal executeStart_out : STD_LOGIC;
  signal instrBuffWrEn_out : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_data_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal peripheral_aresetn : STD_LOGIC;
  signal clk_out1 : STD_LOGIC;
  
  signal mb2fpgamem_ack : STD_LOGIC;
  signal mb2fpgamem_data_in : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal mb2fpgamem_data_we : STD_LOGIC;
  signal mb2fpgamem_done : STD_LOGIC;
        
  signal fpgamem2mb_addr : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal fpgamem2mb_data : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal fpgamem2mb_op : STD_LOGIC_VECTOR ( 3 downto 0 );
  
  signal pc_value : STD_LOGIC_VECTOR ( 31 downto 0 );
  
  signal  singleVectorData_in : STD_LOGIC_VECTOR ( 2047 downto 0 );
  signal  singleVectorBaseAddress_out : STD_LOGIC_VECTOR ( 9 downto 0 );
  component base_microblaze_design is
  port (
    rs232_uart_rxd : in STD_LOGIC;
    rs232_uart_txd : out STD_LOGIC;
    led_8bits_tri_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    reset : in STD_LOGIC;
    axi_data_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    resultsReadyTag_in : in STD_LOGIC_VECTOR ( 31 downto 0 );
    quadData_in : in STD_LOGIC_VECTOR ( 127 downto 0 );
    lsu2sgpr_dest_wr_en_out : out STD_LOGIC_VECTOR ( 3 downto 0 );
    quadBaseAddress_out : out STD_LOGIC_VECTOR ( 9 downto 0 );
    waveCount_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    instrBuffWrEn_out : out STD_LOGIC_VECTOR ( 3 downto 0 );
    waveID_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    pcStart_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    quadData0_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    quadData1_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    instrAddrReg_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    baseVGPR_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    baseSGPR_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    instruction_buff_out_a_in : in STD_LOGIC_VECTOR ( 31 downto 0 );
    quadData2_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    quadData3_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    cu2dispatch_wf_done_in : in STD_LOGIC;
    baseLDS_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    execute_out : out STD_LOGIC;
    executeStart_out : out STD_LOGIC;
    ddr3_sdram_dq : inout STD_LOGIC_VECTOR ( 63 downto 0 );
    ddr3_sdram_dqs_p : inout STD_LOGIC_VECTOR ( 7 downto 0 );
    ddr3_sdram_dqs_n : inout STD_LOGIC_VECTOR ( 7 downto 0 );
    ddr3_sdram_addr : out STD_LOGIC_VECTOR ( 13 downto 0 );
    ddr3_sdram_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    ddr3_sdram_ras_n : out STD_LOGIC;
    ddr3_sdram_cas_n : out STD_LOGIC;
    ddr3_sdram_we_n : out STD_LOGIC;
    ddr3_sdram_reset_n : out STD_LOGIC;
    ddr3_sdram_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_cs_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_dm : out STD_LOGIC_VECTOR ( 7 downto 0 );
    ddr3_sdram_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    sys_diff_clock_0_clk_p : in STD_LOGIC;
    sys_diff_clock_0_clk_n : in STD_LOGIC;
    fpgamem2mb_op : in STD_LOGIC_VECTOR ( 3 downto 0 );
    fpgamem2mb_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    fpgamem2mb_addr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    mb2fpgamem_data_in : out STD_LOGIC_VECTOR ( 31 downto 0 );
    mb2fpgamem_data_we : out STD_LOGIC;
    mb2fpgamem_ack : out STD_LOGIC;
    mb2fpgamem_done : out STD_LOGIC;
    pc_value : in STD_LOGIC_VECTOR( 31 downto 0 );
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    
    singleVectorData_in : in STD_LOGIC_VECTOR ( 2047 downto 0 );
    singleVectorBaseAddress_out : out STD_LOGIC_VECTOR ( 9 downto 0 );
    
    clk_out1 : out STD_LOGIC
  );
  end component base_microblaze_design;
  
  component compute_unit_fpga is
    port (
      waveID_out : in STD_LOGIC_VECTOR ( 31 downto 0 );
      baseVGPR_out : in STD_LOGIC_VECTOR ( 31 downto 0 );
      baseSGPR_out : in STD_LOGIC_VECTOR ( 31 downto 0 );
      baseLDS_out : in STD_LOGIC_VECTOR ( 31 downto 0 );
      waveCount_out : in STD_LOGIC_VECTOR ( 31 downto 0 );
      pcStart_out : in STD_LOGIC_VECTOR ( 31 downto 0 );
      instrAddrReg_out : in STD_LOGIC_VECTOR ( 31 downto 0 );
      instruction_buff_out_a_in : out STD_LOGIC_VECTOR ( 31 downto 0 );
      cu2dispatch_wf_done_in : out STD_LOGIC;
      resultsReadyTag_in : out STD_LOGIC_VECTOR ( 31 downto 0 );
      lsu2sgpr_dest_wr_en_out : in STD_LOGIC_VECTOR ( 3 downto 0 );
      quadBaseAddress_out : in STD_LOGIC_VECTOR ( 9 downto 0 );
      quadData0_out : in STD_LOGIC_VECTOR ( 31 downto 0 );
      quadData1_out : in STD_LOGIC_VECTOR ( 31 downto 0 );
      quadData2_out : in STD_LOGIC_VECTOR ( 31 downto 0 );
      quadData3_out : in STD_LOGIC_VECTOR ( 31 downto 0 );
      quadData_in : out STD_LOGIC_VECTOR ( 127 downto 0 );
      execute_out : in STD_LOGIC;
      executeStart_out : in STD_LOGIC;
      instrBuffWrEn_out : in STD_LOGIC_VECTOR ( 3 downto 0 );
      axi_data_out : in STD_LOGIC_VECTOR ( 31 downto 0 );
      reset_out : in STD_LOGIC;
      clk_50 : in STD_LOGIC;
      
      mb2fpgamem_ack : in STD_LOGIC;
      mb2fpgamem_data_in : in STD_LOGIC_VECTOR ( 31 downto 0 );
      mb2fpgamem_data_we : in STD_LOGIC;
      mb2fpgamem_done : in STD_LOGIC;
      
      fpgamem2mb_addr : out STD_LOGIC_VECTOR ( 31 downto 0 );
      fpgamem2mb_data : out STD_LOGIC_VECTOR ( 31 downto 0 );
      fpgamem2mb_op : out STD_LOGIC_VECTOR ( 3 downto 0 );
      
      singleVectorData_in : out STD_LOGIC_VECTOR ( 2047 downto 0 );
      singleVectorBaseAddress_out : in STD_LOGIC_VECTOR ( 9 downto 0 );
      
      pc_value : out STD_LOGIC_VECTOR ( 31 downto 0 )
    );
    end component compute_unit_fpga;
begin
base_microblaze_design_i: component base_microblaze_design
     port map (
      axi_data_out(31 downto 0) => axi_data_out(31 downto 0),
      baseLDS_out(31 downto 0) => baseLDS_out(31 downto 0),
      baseSGPR_out(31 downto 0) => baseSGPR_out(31 downto 0),
      baseVGPR_out(31 downto 0) => baseVGPR_out(31 downto 0),
      clk_out1 => clk_out1,
      cu2dispatch_wf_done_in => cu2dispatch_wf_done_in,
      ddr3_sdram_addr(13 downto 0) => ddr3_sdram_addr(13 downto 0),
      ddr3_sdram_ba(2 downto 0) => ddr3_sdram_ba(2 downto 0),
      ddr3_sdram_cas_n => ddr3_sdram_cas_n,
      ddr3_sdram_ck_n(0) => ddr3_sdram_ck_n(0),
      ddr3_sdram_ck_p(0) => ddr3_sdram_ck_p(0),
      ddr3_sdram_cke(0) => ddr3_sdram_cke(0),
      ddr3_sdram_cs_n(0) => ddr3_sdram_cs_n(0),
      ddr3_sdram_dm(7 downto 0) => ddr3_sdram_dm(7 downto 0),
      ddr3_sdram_dq(63 downto 0) => ddr3_sdram_dq(63 downto 0),
      ddr3_sdram_dqs_n(7 downto 0) => ddr3_sdram_dqs_n(7 downto 0),
      ddr3_sdram_dqs_p(7 downto 0) => ddr3_sdram_dqs_p(7 downto 0),
      ddr3_sdram_odt(0) => ddr3_sdram_odt(0),
      ddr3_sdram_ras_n => ddr3_sdram_ras_n,
      ddr3_sdram_reset_n => ddr3_sdram_reset_n,
      ddr3_sdram_we_n => ddr3_sdram_we_n,
      executeStart_out => executeStart_out,
      execute_out => execute_out,
      fpgamem2mb_addr(31 downto 0) => fpgamem2mb_addr(31 downto 0),
      fpgamem2mb_data(31 downto 0) => fpgamem2mb_data(31 downto 0),
      fpgamem2mb_op(3 downto 0) => fpgamem2mb_op(3 downto 0),
      instrAddrReg_out(31 downto 0) => instrAddrReg_out(31 downto 0),
      instrBuffWrEn_out(3 downto 0) => instrBuffWrEn_out(3 downto 0),
      instruction_buff_out_a_in(31 downto 0) => instruction_buff_out_a_in(31 downto 0),
      led_8bits_tri_o(7 downto 0) => led_8bits_tri_o(7 downto 0),
      lsu2sgpr_dest_wr_en_out(3 downto 0) => lsu2sgpr_dest_wr_en_out(3 downto 0),
      mb2fpgamem_ack => mb2fpgamem_ack,
      mb2fpgamem_data_in(31 downto 0) => mb2fpgamem_data_in(31 downto 0),
      mb2fpgamem_data_we => mb2fpgamem_data_we,
      mb2fpgamem_done => mb2fpgamem_done,
      pcStart_out(31 downto 0) => pcStart_out(31 downto 0),
      pc_value(31 downto 0) => pc_value(31 downto 0),
      peripheral_aresetn(0) => peripheral_aresetn,
      quadBaseAddress_out(9 downto 0) => quadBaseAddress_out(9 downto 0),
      quadData0_out(31 downto 0) => quadData0_out(31 downto 0),
      quadData1_out(31 downto 0) => quadData1_out(31 downto 0),
      quadData2_out(31 downto 0) => quadData2_out(31 downto 0),
      quadData3_out(31 downto 0) => quadData3_out(31 downto 0),
      quadData_in(127 downto 0) => quadData_in(127 downto 0),
      reset => reset,
      resultsReadyTag_in(31 downto 0) => resultsReadyTag_in(31 downto 0),
      rs232_uart_rxd => rs232_uart_rxd,
      rs232_uart_txd => rs232_uart_txd,
      sys_diff_clock_0_clk_n => sys_diff_clock_0_clk_n,
      sys_diff_clock_0_clk_p => sys_diff_clock_0_clk_p,
      waveCount_out(31 downto 0) => waveCount_out(31 downto 0),
      
      singleVectorData_in( 2047 downto 0 ) => singleVectorData_in( 2047 downto 0 ),
      singleVectorBaseAddress_out( 9 downto 0 )  => singleVectorBaseAddress_out( 9 downto 0 ), 
      
      waveID_out(31 downto 0) => waveID_out(31 downto 0)
    );
    
    compute_unit_fpga_i : component compute_unit_fpga
    port map (
      waveID_out => waveID_out,
      baseVGPR_out => baseVGPR_out,
      baseSGPR_out => baseSGPR_out,
      baseLDS_out =>baseLDS_out,
      waveCount_out => waveCount_out,
      pcStart_out => pcStart_out,
      instrAddrReg_out => instrAddrReg_out,
      instruction_buff_out_a_in => instruction_buff_out_a_in,
      cu2dispatch_wf_done_in => cu2dispatch_wf_done_in,
      resultsReadyTag_in => resultsReadyTag_in,
      lsu2sgpr_dest_wr_en_out => lsu2sgpr_dest_wr_en_out,
      quadBaseAddress_out => quadBaseAddress_out,
      quadData0_out => quadData0_out,
      quadData1_out => quadData1_out,
      quadData2_out => quadData2_out,
      quadData3_out => quadData3_out,
      quadData_in => quadData_in,
      execute_out => execute_out,
      executeStart_out => executeStart_out,
      instrBuffWrEn_out => instrBuffWrEn_out,
      axi_data_out => axi_data_out,
      reset_out => peripheral_aresetn,
      clk_50 => clk_out1,
      mb2fpgamem_ack => mb2fpgamem_ack,
      mb2fpgamem_data_in(31 downto 0) => mb2fpgamem_data_in(31 downto 0),
      mb2fpgamem_data_we => mb2fpgamem_data_we,
      mb2fpgamem_done => mb2fpgamem_done,
      fpgamem2mb_addr(31 downto 0) => fpgamem2mb_addr(31 downto 0),
      fpgamem2mb_data(31 downto 0) => fpgamem2mb_data(31 downto 0),
      fpgamem2mb_op(3 downto 0) => fpgamem2mb_op(3 downto 0),
      singleVectorData_in( 2047 downto 0 ) => singleVectorData_in( 2047 downto 0 ),
      singleVectorBaseAddress_out( 9 downto 0 )  => singleVectorBaseAddress_out( 9 downto 0 ),
      pc_value => pc_value
    );
end STRUCTURE;
