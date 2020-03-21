library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- -----------------------------------------------------------------------

entity DE10Lite_Toplevel is
	port
	(
		ADC_CLK_10		:	 IN STD_LOGIC;
		MAX10_CLK1_50		:	 IN STD_LOGIC;
		MAX10_CLK2_50		:	 IN STD_LOGIC;
		KEY		:	 IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		SW		:	 IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		LEDR		:	 OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX1		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX2		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX3		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX4		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX5		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		DRAM_CLK		:	 OUT STD_LOGIC;
		DRAM_CKE		:	 OUT STD_LOGIC;
		DRAM_ADDR		:	 OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		DRAM_BA		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		DRAM_DQ		:	 INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		DRAM_LDQM		:	 OUT STD_LOGIC;
		DRAM_UDQM		:	 OUT STD_LOGIC;
		DRAM_CS_N		:	 OUT STD_LOGIC;
		DRAM_WE_N		:	 OUT STD_LOGIC;
		DRAM_CAS_N		:	 OUT STD_LOGIC;
		DRAM_RAS_N		:	 OUT STD_LOGIC;
		VGA_HS		:	 OUT STD_LOGIC;
		VGA_VS		:	 OUT STD_LOGIC;
		VGA_R		:	 OUT UNSIGNED(3 DOWNTO 0);
		VGA_G		:	 OUT UNSIGNED(3 DOWNTO 0);
		VGA_B		:	 OUT UNSIGNED(3 DOWNTO 0);
		CLK_I2C_SCL		:	 OUT STD_LOGIC;
		CLK_I2C_SDA		:	 INOUT STD_LOGIC;
		GSENSOR_SCLK		:	 OUT STD_LOGIC;
		GSENSOR_SDO		:	 INOUT STD_LOGIC;
		GSENSOR_SDI		:	 INOUT STD_LOGIC;
		GSENSOR_INT		:	 IN STD_LOGIC_VECTOR(2 DOWNTO 1);
		GSENSOR_CS_N		:	 OUT STD_LOGIC;
		GPIO		:	 INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		ARDUINO_IO		:	 INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		ARDUINO_RESET_N		:	 INOUT STD_LOGIC
	);
END entity;

architecture RTL of DE10Lite_Toplevel is
   constant reset_cycles : integer := 131071;
	
-- System clocks

	signal clk_25 : std_logic;
	signal memclk : std_logic;
	signal clk_cpu : std_logic;
	signal clk_dsp : std_logic;
	signal clk44100x256 : std_logic;
	signal clk14745600 : std_logic;
	signal pll1_locked : std_logic;
	signal pll2_locked : std_logic;
	signal pll3_locked : std_logic;

-- SPI signals

	signal spi_clk : std_logic;
	signal spi_cs : std_logic;
	signal spi_mosi : std_logic;
	signal spi_miso : std_logic;
	
-- Global signals
	signal n_reset : std_logic;

-- PS/2 Keyboard socket
	alias ps2_keyboard_clk : std_logic is GPIO(10);
	alias ps2_keyboard_dat : std_logic is GPIO(12);

	signal ps2_keyboard_clk_in : std_logic;
	signal ps2_keyboard_dat_in : std_logic;
	signal ps2_keyboard_clk_out : std_logic;
	signal ps2_keyboard_dat_out : std_logic;

-- PS/2 Mouse
	alias ps2_mouse_clk : std_logic is GPIO(14);
	alias ps2_mouse_dat : std_logic is GPIO(16);

	signal ps2_mouse_clk_in: std_logic;
	signal ps2_mouse_dat_in: std_logic;
	signal ps2_mouse_clk_out: std_logic;
	signal ps2_mouse_dat_out: std_logic;

	
-- Video
	signal vga_red: std_logic_vector(7 downto 0);
	signal vga_green: std_logic_vector(7 downto 0);
	signal vga_blue: std_logic_vector(7 downto 0);
	signal vga_window : std_logic;
	signal vga_hsync : std_logic;
	signal vga_vsync : std_logic;
	
	
-- RS232 serial
	signal rs232_rxd : std_logic;
	signal rs232_txd : std_logic;

-- Sound
	signal sigmaL : std_logic;
	signal sigmaR : std_logic;

-- IO

	signal socleds : std_logic_vector(7 downto 0);

-- Sigma Delta audio
	COMPONENT hybrid_pwm_sd
	PORT
	(
		clk	:	IN STD_LOGIC;
		n_reset	:	IN STD_LOGIC;
		din	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		dout	:	OUT STD_LOGIC
	);
	END COMPONENT;

	COMPONENT video_vga_dither
	GENERIC ( outbits : INTEGER := 4 );
	PORT
	(
		clk	:	IN STD_LOGIC;
		hsync	:	IN STD_LOGIC;
		vsync	:	IN STD_LOGIC;
		vid_ena	:	IN STD_LOGIC;
		iRed	:	IN UNSIGNED(7 DOWNTO 0);
		iGreen	:	IN UNSIGNED(7 DOWNTO 0);
		iBlue	:	IN UNSIGNED(7 DOWNTO 0);
		oRed	:	OUT UNSIGNED(outbits-1 DOWNTO 0);
		oGreen	:	OUT UNSIGNED(outbits-1 DOWNTO 0);
		oBlue	:	OUT UNSIGNED(outbits-1 DOWNTO 0)
	);
	END COMPONENT;

begin

-- SPI

ARDUINO_IO(10)<=spi_cs;
ARDUINO_IO(11)<=spi_mosi;
ARDUINO_IO(12)<='Z';
spi_miso<=ARDUINO_IO(12);
ARDUINO_IO(13)<=spi_clk;


	mypll : entity work.Clock_50to100Split
		port map (
			inclk0 => MAX10_CLK1_50,
			c0 => clk_25,
			c1 => memclk, -- the same as c1,
			c2 => DRAM_CLK, -- as fast as we can get away with.  133Mhz?
			locked => pll1_locked
		);

	mypll2 : entity work.Clock_50to100Split_2ndRAM
	port map (
		inclk0 => MAX10_CLK1_50,
		c0 => clk_cpu, -- About 60Mhz?
		c1 => clk_dsp, -- About 60MHz?
		locked => pll2_locked
	);

	mypll3 : entity work.Clock_50toSlowClocks
		port map (
			inclk0 => MAX10_CLK1_50,
			c0 => clk44100x256, -- 11.2896Mhz
			c1 => clk14745600, -- 14.6756 MHz
			locked => pll3_locked
		);

vga_window<='1';

n_reset<=pll1_locked and pll2_locked and pll3_locked and KEY(0) and SW(0);

DRAM_CKE<='1';
DRAM_CS_N<='0';

-- External devices tied to GPIOs

GPIO(18)<=sigmaL;
GPIO(20)<=sigmaR;

ps2_mouse_dat_in<=ps2_mouse_dat;
ps2_mouse_dat <= '0' when ps2_mouse_dat_out='0' else 'Z';
ps2_mouse_clk_in<=ps2_mouse_clk;
ps2_mouse_clk <= '0' when ps2_mouse_clk_out='0' else 'Z';

ps2_keyboard_dat_in<=ps2_keyboard_dat;
ps2_keyboard_dat <= '0' when ps2_keyboard_dat_out='0' else 'Z';
ps2_keyboard_clk_in<=ps2_keyboard_clk;
ps2_keyboard_clk <= '0' when ps2_keyboard_clk_out='0' else 'Z';


sys_inst: entity work.Next186SOCWrapper
	generic map (
		RowBits => 13,
		ColBits => 10,
		enableDSP => 0, -- The BlockRAM's better spent on debugging for now.
		cpuclkfreq => 666
	)
	port map (
		CLK_50MHZ => MAX10_CLK1_50,
		opl_reset => not (KEY(1) and n_reset),
		clk_25=>clk_25,
		clk_sdr => memclk,
		clk_cpu => clk_cpu,
		clk_dsp => clk_dsp,
		CLK44100x256 => clk44100x256,
		CLK14745600=>clk14745600,
		unsigned(VGA_R) => vga_red(7 downto 2),
		unsigned(VGA_G) => vga_green(7 downto 2),
		unsigned(VGA_B) => vga_blue(7 downto 2),
		VGA_HSYNC => vga_hsync,
		VGA_VSYNC => vga_vsync,
		sdr_n_CS_WE_RAS_CAS(3)=>open, -- DRAM_CS_N,
		sdr_n_CS_WE_RAS_CAS(2)=>DRAM_WE_N,
		sdr_n_CS_WE_RAS_CAS(1)=>DRAM_RAS_N,
		sdr_n_CS_WE_RAS_CAS(0)=>DRAM_CAS_N,
		sdr_BA => DRAM_BA,
		sdr_ADDR => DRAM_ADDR,
		sdr_DATA => DRAM_DQ,
		sdr_DQM(1) => DRAM_UDQM,
		sdr_DQM(0) => DRAM_LDQM,
		
		LED => socleds,
		BTN_RESET=>not n_reset, -- reset,
		BTN_NMI=>'0',
		RS232_DCE_RXD=>rs232_rxd,
		RS232_DCE_TXD=>rs232_txd,
		RS232_EXT_RXD=>rs232_rxd,
--		.RS232_EXT_TXD(),
		SD_n_CS=>spi_cs,
		SD_DI=>spi_mosi,
		SD_CK=>spi_clk,
		SD_DO=>spi_miso,
		AUD_L=>sigmaL,
		AUD_R=>sigmaR,

	 	PS2_CLK1=>ps2_keyboard_clk_in,
 	   PS2_CLK1_nOE=>ps2_keyboard_clk_out,
		PS2_DATA1=>ps2_keyboard_dat_in,
		PS2_DATA1_nOE=>ps2_keyboard_dat_out,

	 	PS2_CLK2=>ps2_mouse_clk_in,
 	   PS2_CLK2_nOE=>ps2_mouse_clk_out,
		PS2_DATA2=>ps2_mouse_dat_in,
		PS2_DATA2_nOE=>ps2_mouse_dat_out,

		RS232_HOST_RXD=>rs232_rxd
--		RS232_HOST_TXD(rs232_txd)
--		RS232_HOST_RST(),
--		.GPIO(),
--		.I2C_SCL(),
--		.I2C_SDA(),
	);

	
-- Dither the video down to 5 bits per gun.
	vga_window<='1';
	VGA_HS<= not vga_hsync;
	VGA_VS<= not vga_vsync;	

	mydither : component video_vga_dither
		generic map(
			outbits => 4
		)
		port map(
			clk=>MAX10_CLK1_50,
			hsync=>vga_hsync,
			vsync=>vga_vsync,
			vid_ena=>vga_window,
			iRed => unsigned(vga_red),
			iGreen => unsigned(vga_green),
			iBlue => unsigned(vga_blue),
			oRed => VGA_R,
			oGreen => VGA_G,
			oBlue => VGA_B
		);
	
--leftsd: component hybrid_pwm_sd
--	port map
--	(
--		clk => fastclk,
--		n_reset => n_reset,
--		din(15) => not audio_l(15),
--		din(14 downto 0) => std_logic_vector(audio_l(14 downto 0)),
--		dout => sigma_l
--	);
--	
--rightsd: component hybrid_pwm_sd
--	port map
--	(
--		clk => fastclk,
--		n_reset => n_reset,
--		din(15) => not audio_r(15),
--		din(14 downto 0) => std_logic_vector(audio_r(14 downto 0)),
--		dout => sigma_r
--	);

GPIO(1)<='Z';
GPIO(0)<=rs232_txd;
rs232_rxd<=GPIO(1);

end architecture;
