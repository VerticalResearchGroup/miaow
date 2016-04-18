--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.1 (win64) Build 1215546 Mon Apr 27 19:22:08 MDT 2015
--Date        : Thu Apr 14 15:33:49 2016
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
    sys_diff_clock_clk_n : in STD_LOGIC;
    sys_diff_clock_clk_p : in STD_LOGIC
  );
end base_microblaze_design_wrapper;

architecture STRUCTURE of base_microblaze_design_wrapper is

signal S_AXI_ACLK : std_logic;
signal S_AXI_ARESETN : std_logic;
signal S_AXI_AWADDR : std_logic_vector(10 downto 0);
signal S_AXI_AWPROT : std_logic_vector(2 downto 0);
signal S_AXI_AWVALID : std_logic;

signal S_AXI_AWREADY : std_logic;
signal S_AXI_WDATA : std_logic_vector(31 downto 0);
signal S_AXI_WSTRB : std_logic_vector(3 downto 0);
signal S_AXI_WVALID : std_logic;
signal S_AXI_WREADY : std_logic;
signal S_AXI_BRESP : std_logic_vector(1 downto 0);
signal S_AXI_BVALID : std_logic;
signal S_AXI_BREADY : std_logic;
signal S_AXI_ARADDR : std_logic_vector(10 downto 0);
signal S_AXI_ARPROT : std_logic_vector(2 downto 0);
signal S_AXI_ARVALID : std_logic;
signal S_AXI_ARREADY : std_logic;
signal S_AXI_RDATA : std_logic_vector(31 downto 0);
signal S_AXI_RRESP : std_logic_vector(1 downto 0);
signal S_AXI_RVALID : std_logic;
signal S_AXI_RREADY : std_logic;

  component base_microblaze_design is
  port (
    sys_diff_clock_clk_p : in STD_LOGIC;
    sys_diff_clock_clk_n : in STD_LOGIC;
    rs232_uart_rxd : in STD_LOGIC;
    rs232_uart_txd : out STD_LOGIC;
    led_8bits_tri_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
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
    reset : in STD_LOGIC;
    S_AXI_AWREADY : in STD_LOGIC;
    S_AXI_ACLK : out STD_LOGIC;
    S_AXI_BREADY : out STD_LOGIC;
    S_AXI_ARESETN : out STD_LOGIC;
    S_AXI_RDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_BRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_ARVALID : out STD_LOGIC;
    S_AXI_RRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_ARADDR : out STD_LOGIC_VECTOR ( 10 downto 0 );
    S_AXI_WDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_AWADDR : out STD_LOGIC_VECTOR ( 10 downto 0 );
    S_AXI_WSTRB : out STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_ARPROT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_WVALID : out STD_LOGIC;
    S_AXI_AWPROT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_WREADY : in STD_LOGIC;
    S_AXI_ARREADY : in STD_LOGIC;
    S_AXI_BVALID : in STD_LOGIC;
    S_AXI_RVALID : in STD_LOGIC;
    S_AXI_AWVALID : out STD_LOGIC;
    S_AXI_RREADY : out STD_LOGIC
  );
  end component base_microblaze_design;
  
  component compute_unit_fpga is
  port (
    S_AXI_ACLK : in std_logic;
    S_AXI_ARESETN : in std_logic;
    S_AXI_AWADDR : in std_logic_vector(10 downto 0);
    S_AXI_AWPROT : in std_logic_vector(2 downto 0);
    S_AXI_AWVALID : in std_logic;
    
    S_AXI_AWREADY : out std_logic;
    S_AXI_WDATA : in std_logic_vector(31 downto 0);
    S_AXI_WSTRB : in std_logic_vector(3 downto 0);
    S_AXI_WVALID : in std_logic;
    S_AXI_WREADY : out std_logic;
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    S_AXI_BVALID : out std_logic;
    S_AXI_BREADY : in std_logic;
    S_AXI_ARADDR : in std_logic_vector(10 downto 0);
    S_AXI_ARPROT : in std_logic_vector(2 downto 0);
    S_AXI_ARVALID : in std_logic;
    S_AXI_ARREADY : out std_logic;
    S_AXI_RDATA : out std_logic_vector(31 downto 0);
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    S_AXI_RVALID : out std_logic;
    S_AXI_RREADY : in std_logic
  );
  end component compute_unit_fpga;
  
begin
base_microblaze_design_i: component base_microblaze_design
     port map (
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARADDR(10 downto 0) => S_AXI_ARADDR(10 downto 0),
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI_ARPROT(2 downto 0) => S_AXI_ARPROT(2 downto 0),
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_AWADDR(10 downto 0) => S_AXI_AWADDR(10 downto 0),
      S_AXI_AWPROT(2 downto 0) => S_AXI_AWPROT(2 downto 0),
      S_AXI_AWREADY => S_AXI_AWREADY,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_BREADY => S_AXI_BREADY,
      S_AXI_BRESP(1 downto 0) => S_AXI_BRESP(1 downto 0),
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_RDATA(31 downto 0) => S_AXI_RDATA(31 downto 0),
      S_AXI_RREADY => S_AXI_RREADY,
      S_AXI_RRESP(1 downto 0) => S_AXI_RRESP(1 downto 0),
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_WDATA(31 downto 0) => S_AXI_WDATA(31 downto 0),
      S_AXI_WREADY => S_AXI_WREADY,
      S_AXI_WSTRB(3 downto 0) => S_AXI_WSTRB(3 downto 0),
      S_AXI_WVALID => S_AXI_WVALID,
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
      led_8bits_tri_o(7 downto 0) => led_8bits_tri_o(7 downto 0),
      reset => reset,
      rs232_uart_rxd => rs232_uart_rxd,
      rs232_uart_txd => rs232_uart_txd,
      sys_diff_clock_clk_n => sys_diff_clock_clk_n,
      sys_diff_clock_clk_p => sys_diff_clock_clk_p
    );
    
compute_unit_fpga_i : component compute_unit_fpga
(
    S_AXI_ACLK => S_AXI_ACLK,
    S_AXI_ARESETN => S_AXI_ARESETN,
    S_AXI_AWADDR => S_AXI_AWADDR,
    S_AXI_AWPROT => S_AXI_AWPROT,
    S_AXI_AWVALID => S_AXI_AWVALID,
    
    S_AXI_AWREADY => S_AXI_AWREADY,
    S_AXI_WDATA => S_AXI_WDATA,
    S_AXI_WSTRB => S_AXI_WSTRB,
    S_AXI_WVALID => S_AXI_WVALID,
    S_AXI_WREADY => S_AXI_WREADY,
    S_AXI_BRESP => S_AXI_BRESP,
    S_AXI_BVALID => S_AXI_BVALID,
    S_AXI_BREADY => S_AXI_BREADY,
    S_AXI_ARADDR => S_AXI_ARADDR,
    S_AXI_ARPROT => S_AXI_ARPROT,
    S_AXI_ARVALID => S_AXI_ARVALID,
    S_AXI_ARREADY => S_AXI_ARREADY,
    S_AXI_RDATA => S_AXI_RDATA,
    S_AXI_RRESP => S_AXI_RRESP,
    S_AXI_RVALID => S_AXI_RVALID,
    S_AXI_RREADY => S_AXI_RREADY
);
end STRUCTURE;
