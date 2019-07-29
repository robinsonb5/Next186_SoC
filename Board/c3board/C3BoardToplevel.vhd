library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;

library altera;
use altera.altera_syn_attributes.all;

library work;


entity C3BoardToplevel is
port(
		clk_50 	: in 	std_logic;
		reset_n : in 	std_logic;
		led_out : out 	std_logic;
		btn1 : in std_logic;
		btn2 : in std_logic;

		-- SDRAM - chip 1
		sdram1_clk : out std_logic; -- Different name format to escape wildcard in SDC file
		sd1_addr : out std_logic_vector(11 downto 0);
		sd1_data : inout std_logic_vector(7 downto 0);
		sd1_ba : out std_logic_vector(1 downto 0);
		sd1_cke : out std_logic;
		sd1_dqm : out std_logic;
		sd1_cs : out std_logic;
		sd1_we : out std_logic;
		sd1_cas : out std_logic;
		sd1_ras : out std_logic;

		-- SDRAM - chip 2
		sdram2_clk : out std_logic; -- Different name format to escape wildcard in SDC file
		sd2_addr : out std_logic_vector(11 downto 0);
		sd2_data : inout std_logic_vector(7 downto 0);
		sd2_ba : out std_logic_vector(1 downto 0);
		sd2_cke : out std_logic;
		sd2_dqm : out std_logic;
		sd2_cs : out std_logic;
		sd2_we : out std_logic;
		sd2_cas : out std_logic;
		sd2_ras : out std_logic;
		
		-- VGA
		vga_red 		: out unsigned(5 downto 0);
		vga_green 	: out unsigned(5 downto 0);
		vga_blue 	: out unsigned(5 downto 0);
		
		vga_hsync 	: buffer std_logic;
		vga_vsync 	: buffer std_logic;

		-- PS/2
		ps2k_clk : inout std_logic;
		ps2k_dat : inout std_logic;
		ps2m_clk : inout std_logic;
		ps2m_dat : inout std_logic;
		
		-- Audio
		aud_l : out std_logic;
		aud_r : out std_logic;
		
		-- RS232
		rs232_rxd : in std_logic;
		rs232_txd : out std_logic;

		-- SD card interface
		sd_cs : out std_logic;
		sd_miso : in std_logic;
		sd_mosi : out std_logic;
		sd_clk : out std_logic;
		
		-- Power and LEDs
		power_button : in std_logic;
		power_hold : out std_logic := '1';
		leds : out std_logic_vector(3 downto 0);
		
		-- Any remaining IOs yet to be assigned
		misc_ios_1 : in std_logic_vector(5 downto 0);
		misc_ios_21 : in std_logic_vector(13 downto 0);
		misc_ios_22 : in std_logic_vector(8 downto 0);
		misc_ios_3 : in std_logic_vector(1 downto 0)
	);
end entity;

architecture RTL of C3BoardToplevel is
-- Assigns pin location to ports on an entity.
-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute chip_pin : string;

-- Board features

attribute chip_pin of clk_50 : signal is "152";
attribute chip_pin of reset_n : signal is "181";
attribute chip_pin of led_out : signal is "233";

-- SDRAM (2 distinct 8-bit wide chips)

attribute chip_pin of sd1_addr : signal is "83,69,82,81,80,78,99,110,63,64,65,68";
attribute chip_pin of sd1_data : signal is "109,103,111,93,100,106,107,108";
attribute chip_pin of sd1_ba : signal is "70,71";
attribute chip_pin of sdram1_clk : signal is "117";
attribute chip_pin of sd1_cke : signal is "84";
attribute chip_pin of sd1_dqm : signal is "87";
attribute chip_pin of sd1_cs : signal is "72";
attribute chip_pin of sd1_we : signal is "88";
attribute chip_pin of sd1_cas : signal is "76";
attribute chip_pin of sd1_ras : signal is "73";

attribute chip_pin of sd2_addr : signal is "142,114,144,139,137,134,148,161,120,119,118,113";
attribute chip_pin of sd2_data : signal is "166,164,162,160,146,147,159,168";
attribute chip_pin of sd2_ba : signal is "126,127";
attribute chip_pin of sdram2_clk : signal is "186";
attribute chip_pin of sd2_cke : signal is "143";
attribute chip_pin of sd2_dqm : signal is "145";
attribute chip_pin of sd2_cs : signal is "128";
attribute chip_pin of sd2_we : signal is "133";
attribute chip_pin of sd2_cas : signal is "132";
attribute chip_pin of sd2_ras : signal is "131";

-- Video output via custom board

attribute chip_pin of vga_red : signal is "13, 9, 5, 240, 238, 236";
attribute chip_pin of vga_green : signal is "49, 45, 43, 39, 37, 18";
attribute chip_pin of vga_blue : signal is "52, 50, 46, 44, 41, 38";

attribute chip_pin of vga_hsync : signal is "51";
attribute chip_pin of vga_vsync : signal is "55";

-- Audio output via custom board

attribute chip_pin of aud_l : signal is "6";
attribute chip_pin of aud_r : signal is "22";

-- PS/2 sockets on custom board

attribute chip_pin of ps2k_clk : signal is "235";
attribute chip_pin of ps2k_dat : signal is "237";
attribute chip_pin of ps2m_clk : signal is "239";
attribute chip_pin of ps2m_dat : signal is "4";

-- RS232
attribute chip_pin of rs232_rxd : signal is "98";
attribute chip_pin of rs232_txd : signal is "112";

-- SD card interface
attribute chip_pin of sd_cs : signal is "185";
attribute chip_pin of sd_miso : signal is "196";
attribute chip_pin of sd_mosi : signal is "188";
attribute chip_pin of sd_clk : signal is "194";


-- Power and LEDs
attribute chip_pin of power_hold : signal is "171";
attribute chip_pin of power_button : signal is "94";

attribute chip_pin of leds : signal is "173, 169, 167, 135";

attribute chip_pin of btn1 : signal is "226";
attribute chip_pin of btn2 : signal is "231";

-- Free pins, not yet assigned

attribute chip_pin of misc_ios_1 : signal is "12,14,56,234,21,57";

attribute chip_pin of misc_ios_21 : signal is "184,187,189,195,197,201,203,214,217,219,221,223,232";
attribute chip_pin of misc_ios_22 : signal is "176,183,200,202,207,216,218,224,230";
attribute chip_pin of misc_ios_3 : signal is "95,177";

-- Signals internal to the project

signal clk : std_logic;
signal clk_fast : std_logic;
signal pll1_locked : std_logic;
signal pll2_locked : std_logic;

signal debugvalue : std_logic_vector(15 downto 0);

signal btn1_d : std_logic;
signal btn2_d : std_logic;

signal currentX : unsigned(11 downto 0);
signal currentY : unsigned(11 downto 0);
signal end_of_pixel : std_logic;
signal end_of_line : std_logic;
signal end_of_frame : std_logic;

-- SDRAM - merged signals to make the two chips appear as a single 16-bit wide entity.
signal sdr_addr : std_logic_vector(12 downto 0);
signal sdr_dqm : std_logic_vector(1 downto 0);
signal sdr_we : std_logic;
signal sdr_cas : std_logic;
signal sdr_ras : std_logic;
signal sdr_cs : std_logic;
signal sdr_ba : std_logic_vector(1 downto 0);
signal sdr_clk : std_logic;
signal sdr_cke : std_logic;

signal ps2m_clk_in : std_logic;
signal ps2m_clk_out : std_logic;
signal ps2m_dat_in : std_logic;
signal ps2m_dat_out : std_logic;

signal ps2k_clk_in : std_logic;
signal ps2k_clk_out : std_logic;
signal ps2k_dat_in : std_logic;
signal ps2k_dat_out : std_logic;

signal power_led : unsigned(5 downto 0);
signal disk_led : unsigned(5 downto 0);
signal net_led : unsigned(5 downto 0);
signal odd_led : unsigned(5 downto 0);

signal audio_l : signed(15 downto 0);
signal audio_r : signed(15 downto 0);


COMPONENT system
	PORT
	(
		sdr_CLK_out		:	 OUT STD_LOGIC;
		clk_25		:	 OUT STD_LOGIC;
		sdr_n_CS_WE_RAS_CAS		:	 OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		sdr_BA		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		sdr_ADDR		:	 OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		sdr_DATA		:	 INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		sdr_DQM		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		CLK_50MHZ		:	 IN STD_LOGIC;
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
END COMPONENT;

-- Sigma Delta audio
COMPONENT hybrid_pwm_sd
	PORT
	(
		clk		:	 IN STD_LOGIC;
		n_reset		:	 IN STD_LOGIC;
		din		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		dout		:	 OUT STD_LOGIC
	);
END COMPONENT;

signal clk_25 : std_logic;

begin

	power_led(5 downto 2)<=unsigned(debugvalue(15 downto 12));
	disk_led(5 downto 2)<=unsigned(debugvalue(11 downto 8));
	net_led(5 downto 2)<=unsigned(debugvalue(7 downto 4));
	odd_led(5 downto 2)<=unsigned(debugvalue(3 downto 0));

	ps2m_dat_in<=ps2m_dat;
	ps2m_dat <= '0' when ps2m_dat_out='0' else 'Z';
	ps2m_clk_in<=ps2m_clk;
	ps2m_clk <= '0' when ps2m_clk_out='0' else 'Z';

	ps2k_dat_in<=ps2k_dat;
	ps2k_dat <= '0' when ps2k_dat_out='0' else 'Z';
	ps2k_clk_in<=ps2k_clk;
	ps2k_clk <= '0' when ps2k_clk_out='0' else 'Z';

	sd1_addr <= sdr_addr(sd1_addr'high downto 0);
	sd1_dqm <= sdr_dqm(0);
	sdram1_clk <= sdr_clk;
	sd1_we <= sdr_we;
	sd1_cas <= sdr_cas;
	sd1_ras <= sdr_ras;
	sd1_cs <= sdr_cs;
	sd1_ba <= sdr_ba;
	sd1_cke <= sdr_cke;

	sd2_addr <= sdr_addr(sd2_addr'high downto 0);
	sd2_dqm <= sdr_dqm(1);
	sdram2_clk <= sdr_clk;
	sd2_we <= sdr_we;
	sd2_cas <= sdr_cas;
	sd2_ras <= sdr_ras;
	sd2_cs <= sdr_cs;
	sd2_ba <= sdr_ba;
	sd2_cke <= sdr_cke;
	
	sdr_cke<='1';
	
--	mypll : entity work.Clock_50to100Split
--		port map (
--			inclk0 => clk_50,
--			c0 => clk_fast,
--			c1 => sdram1_clk,
--			c2 => clk,
--			locked => pll1_locked
--		);
		
--	mypll2 : entity work.Clock_50to100Split_2ndRAM
--		port map (
--			inclk0 => clk_50,
--			c1 => sdram2_clk,
--			locked => pll2_locked
--		);

sys_inst: component system
	port map (
		CLK_50MHZ => clk_50,
		unsigned(VGA_R) => vga_red,
		unsigned(VGA_G) => vga_green,
		unsigned(VGA_B) => vga_blue,
		VGA_HSYNC => vga_hsync,
		VGA_VSYNC => vga_vsync,
		clk_25=>clk_25,
		sdr_CLK_out => sdr_clk,
		sdr_n_CS_WE_RAS_CAS(3)=>sdr_cs,
		sdr_n_CS_WE_RAS_CAS(2)=>sdr_we,
		sdr_n_CS_WE_RAS_CAS(1)=>sdr_ras,
		sdr_n_CS_WE_RAS_CAS(0)=>sdr_cas,
		sdr_BA => sdr_ba,
		sdr_ADDR => sdr_addr,
		sdr_DATA(7 downto 0) => sd1_data,
		sdr_DATA(15 downto 8) => sd2_data,
		sdr_DQM => sdr_dqm,
		LED(3 downto 0) => leds,
		BTN_RESET=>not power_button,
		BTN_NMI=>'0',
		RS232_DCE_RXD=>rs232_rxd,
		RS232_DCE_TXD=>rs232_txd,
		RS232_EXT_RXD=>rs232_rxd,
--		.RS232_EXT_TXD(),
		SD_n_CS=>sd_cs,
		SD_DI=>sd_mosi,
		SD_CK=>sd_clk,
		SD_DO=>sd_miso,
		AUD_L=>aud_l,
		AUD_R=>aud_r,

	 	PS2_CLK1=>ps2k_clk_in,
 	   PS2_CLK1_nOE=>ps2k_clk_out,
		PS2_DATA1=>ps2k_dat_in,
		PS2_DATA1_nOE=>ps2k_dat_out,

	 	PS2_CLK2=>ps2m_clk_in,
 	   PS2_CLK2_nOE=>ps2m_clk_out,
		PS2_DATA2=>ps2m_dat_in,
		PS2_DATA2_nOE=>ps2m_dat_out,

		RS232_HOST_RXD=>rs232_rxd
--		RS232_HOST_TXD(rs232_txd)
--		RS232_HOST_RST(),
--		.GPIO(),
--		.I2C_SCL(),
--		.I2C_SDA(),
	);

end RTL;

