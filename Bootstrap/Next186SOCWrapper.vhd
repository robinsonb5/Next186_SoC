library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;


entity Next186SOCWrapper is
	Generic
	(
		RowBits : integer;
		ColBits : integer;
		enableDSP : integer;
		cpuclkfreq : integer
	);
	PORT
	(
		CLK_50MHZ	:	 IN STD_LOGIC;
		clk_25		:	 in STD_LOGIC;
		clk_sdr		:	 in STD_LOGIC;
		clk_cpu		:	 in STD_LOGIC;
		clk_dsp		:	 in STD_LOGIC;
		CLK44100x256		:	 in STD_LOGIC;
		CLK14745600		:	 in STD_LOGIC;
		sdr_n_CS_WE_RAS_CAS		:	 OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		sdr_BA		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		sdr_ADDR		:	 OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		sdr_DATA		:	 INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		sdr_DQM		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		VGA_R		:	 OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		VGA_G		:	 OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		VGA_B		:	 OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		frame_on		:	 OUT STD_LOGIC;
		VGA_HSYNC		:	 OUT STD_LOGIC;
		VGA_VSYNC		:	 OUT STD_LOGIC;
		BTN_RESET		:	 IN STD_LOGIC;
		BTN_NMI		:	 IN STD_LOGIC;
		LED		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		RS232_DCE_RXD		:	 IN STD_LOGIC;
		RS232_DCE_TXD		:	 OUT STD_LOGIC;
		RS232_EXT_RXD		:	 IN STD_LOGIC := '1';
		RS232_EXT_TXD		:	 OUT STD_LOGIC;
		RS232_HOST_RXD		:	 IN STD_LOGIC :='1';
		RS232_HOST_TXD		:	 OUT STD_LOGIC;
		RS232_HOST_RST		:	 OUT STD_LOGIC;
		SD_n_CS		:	 OUT STD_LOGIC;
		SD_DI		:	 OUT STD_LOGIC;
		SD_CK		:	 OUT STD_LOGIC;
		SD_DO		:	 IN STD_LOGIC;
		AUD_L		:	 OUT STD_LOGIC;
		AUD_R		:	 OUT STD_LOGIC;
		PS2_CLK1		:	 IN STD_LOGIC;
		PS2_CLK2		:	 IN STD_LOGIC;
		PS2_DATA1		:	 IN STD_LOGIC;
		PS2_DATA2		:	 IN STD_LOGIC;
		PS2_CLK1_nOE		:	 OUT STD_LOGIC;
		PS2_CLK2_nOE		:	 OUT STD_LOGIC;
		PS2_DATA1_nOE		:	 OUT STD_LOGIC;
		PS2_DATA2_nOE		:	 OUT STD_LOGIC;
		GPIO		:	 INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		I2C_SCL		:	 OUT STD_LOGIC;
		I2C_SDA		:	 INOUT STD_LOGIC
	);
END entity;

architecture behavioural of Next186SOCWrapper is

COMPONENT system
	Generic
	(
		RowBits : integer;
		CoLBits : integer;
		enableDSP : integer
	);
	PORT
	(
		CLK_50MHZ	:	 IN STD_LOGIC;
		clk_25		:	 in STD_LOGIC;
		clk_sdr		:	 in STD_LOGIC;
		clk_cpu		:	 in STD_LOGIC;
		clk_dsp		:	 in STD_LOGIC;
		CLK44100x256		:	 in STD_LOGIC;
		CLK14745600		:	 in STD_LOGIC;
		sdr_n_CS_WE_RAS_CAS		:	 OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		sdr_BA		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		sdr_ADDR		:	 OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		sdr_DATA		:	 INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		sdr_DQM		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		VGA_R		:	 OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		VGA_G		:	 OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		VGA_B		:	 OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		frame_on		:	 OUT STD_LOGIC;
		VGA_HSYNC		:	 OUT STD_LOGIC;
		VGA_VSYNC		:	 OUT STD_LOGIC;
		BTN_RESET		:	 IN STD_LOGIC;
		BTN_NMI		:	 IN STD_LOGIC;
		LED		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		RS232_DCE_RXD		:	 IN STD_LOGIC;
		RS232_DCE_TXD		:	 OUT STD_LOGIC;
		RS232_EXT_RXD		:	 IN STD_LOGIC := '1';
		RS232_EXT_TXD		:	 OUT STD_LOGIC;
		RS232_HOST_RXD		:	 IN STD_LOGIC :='1';
		RS232_HOST_TXD		:	 OUT STD_LOGIC;
		RS232_HOST_RST		:	 OUT STD_LOGIC;
		SD_n_CS		:	 OUT STD_LOGIC;
		SD_DI		:	 OUT STD_LOGIC;
		SD_CK		:	 OUT STD_LOGIC;
		SD_DO		:	 IN STD_LOGIC;
		AUD_L		:	 OUT STD_LOGIC;
		AUD_R		:	 OUT STD_LOGIC;
		PS2_CLK1		:	 IN STD_LOGIC;
		PS2_CLK2		:	 IN STD_LOGIC;
		PS2_DATA1		:	 IN STD_LOGIC;
		PS2_DATA2		:	 IN STD_LOGIC;
		PS2_CLK1_nOE		:	 OUT STD_LOGIC;
		PS2_CLK2_nOE		:	 OUT STD_LOGIC;
		PS2_DATA1_nOE		:	 OUT STD_LOGIC;
		PS2_DATA2_nOE		:	 OUT STD_LOGIC;
		GPIO		:	 INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		I2C_SCL		:	 OUT STD_LOGIC;
		I2C_SDA		:	 INOUT STD_LOGIC;
		-- Data channel
		dc_in : in std_logic_vector(8 downto 0);
		dc_out : out std_logic_vector(8 downto 0)
	);
END COMPONENT;

signal divert_sdcard : std_logic;
signal rs232_from_bootstrap : std_logic;
signal rs232_cts : std_logic; -- FIXME - add support to the host for this.
signal host_reset : std_logic;
signal spi_host_cs : std_logic;
signal spi_host_clk : std_logic;
signal spi_host_mosi : std_logic;
signal spi_cs : std_logic;
signal spi_clk : std_logic;
signal spi_mosi : std_logic;

signal dc_host_to_pc : std_logic_vector(8 downto 0);
signal dc_pc_to_host : std_logic_vector(8 downto 0);
begin

SD_n_CS <= spi_cs when divert_sdcard='1' else spi_host_cs;
SD_DI <= spi_mosi when divert_sdcard='1' else spi_host_mosi;
SD_CK <= spi_clk when divert_sdcard='1' else spi_host_clk;


bootstrap_inst : work.Bootstrap
	generic map
	(
		sysclk_frequency => cpuclkfreq
	)
	port map
	(
		clk=>clk_cpu,
		reset_in => not BTN_RESET,
		spi_mosi => spi_mosi,
		spi_miso => SD_DO,
		spi_clk => spi_clk,
		spi_cs => spi_cs,
		txd => rs232_from_bootstrap,
		debug_rxd => RS232_DCE_RXD,
		debug_txd => RS232_DCE_TXD,
		divert_sdcard => divert_sdcard,
		host_reset => host_reset,
		dc_in => dc_pc_to_host,
		dc_out => dc_host_to_pc
	);


sys_inst: component system
	generic map (
		RowBits => RowBits,
		ColBits => ColBits,
		enableDSP => enableDSP -- The BlockRAM's better spent on debugging for now.
	)
	port map (
		CLK_50MHZ => CLK_50MHz,
		clk_25=>clk_25,
		clk_sdr => clk_sdr,
		clk_cpu => clk_cpu,
		clk_dsp => clk_dsp,
		CLK44100x256 => CLK44100x256,
		CLK14745600=>CLK14745600,
		VGA_R => VGA_R,
		VGA_G => VGA_G,
		VGA_B => VGA_B,
		VGA_HSYNC => VGA_HSYNC,
		VGA_VSYNC => VGA_VSYNC,
		sdr_n_CS_WE_RAS_CAS=>sdr_n_CS_WE_RAS_CAS,
		sdr_BA => sdr_BA,
		sdr_ADDR => sdr_addr,
		sdr_DATA => sdr_DATA,
		sdr_DQM => sdr_DQM,
		LED => LED,
		BTN_RESET=>not host_reset,
		BTN_NMI=>BTN_NMI,
		RS232_DCE_RXD=>RS232_DCE_RXD, -- rs232_from_bootstrap,
--		RS232_DCE_TXD=>RS232_DCE_TXD,
		RS232_EXT_RXD=>RS232_EXT_RXD,
--		.RS232_EXT_TXD(),
		SD_n_CS=>spi_host_cs,
		SD_DI=>spi_host_mosi,
		SD_CK=>spi_host_clk,
		SD_DO=>SD_DO,
		AUD_L=>AUD_L,
		AUD_R=>AUD_R,

	 	PS2_CLK1=>PS2_CLK1,
 	   PS2_CLK1_nOE=>PS2_CLK1_nOE,
		PS2_DATA1=>PS2_DATA1,
		PS2_DATA1_nOE=>PS2_DATA1_nOE,

	 	PS2_CLK2=>PS2_CLK2,
 	   PS2_CLK2_nOE=>PS2_CLK2_nOE,
		PS2_DATA2=>PS2_DATA2,
		PS2_DATA2_nOE=>PS2_DATA2_nOE,

		RS232_HOST_RXD=>RS232_HOST_RXD,
--		RS232_HOST_TXD(rs232_txd)
--		RS232_HOST_RST(),
--		.GPIO(),
--		.I2C_SCL(),
--		.I2C_SDA(),
		dc_in => dc_host_to_pc,
		dc_out => dc_pc_to_host
	);


end architecture;
