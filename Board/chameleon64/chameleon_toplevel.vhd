-- -----------------------------------------------------------------------
--
-- Turbo Chameleon
--
-- Toplevel file for Turbo Chameleon 64
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

library work;

-- -----------------------------------------------------------------------

entity chameleon_toplevel is
	generic (
		resetCycles: integer := 131071
	);
	port (
-- Clocks
		clk8 : in std_logic;
		phi2_n : in std_logic;
		dotclock_n : in std_logic;

-- Bus
		romlh_n : in std_logic;
		ioef_n : in std_logic;

-- Buttons
		freeze_n : in std_logic;

-- MMC/SPI
		spi_miso : in std_logic;
		mmc_cd_n : in std_logic;
		mmc_wp : in std_logic;

-- MUX CPLD
		mux_clk : out std_logic;
		mux : out unsigned(3 downto 0);
		mux_d : out unsigned(3 downto 0);
		mux_q : in unsigned(3 downto 0);

-- USART
		usart_tx : in std_logic;
		usart_clk : in std_logic;
		usart_rts : in std_logic;
		usart_cts : in std_logic;

-- SDRam
		sdram_clk : out std_logic;
		sd_data : inout std_logic_vector(15 downto 0);
		sd_addr : out std_logic_vector(12 downto 0);
		sd_we_n : out std_logic;
		sd_ras_n : out std_logic;
		sd_cas_n : out std_logic;
		sd_ba_0 : out std_logic;
		sd_ba_1 : out std_logic;
		sd_ldqm : out std_logic;
		sd_udqm : out std_logic;

-- Video
		red : out unsigned(4 downto 0);
		grn : out unsigned(4 downto 0);
		blu : out unsigned(4 downto 0);
		nHSync : buffer std_logic;
		nVSync : buffer std_logic;

-- Audio
		sigmaL : out std_logic;
		sigmaR : out std_logic
	);
end entity;

-- -----------------------------------------------------------------------

architecture rtl of chameleon_toplevel is
	
-- System clocks
	signal clk_25 : std_logic;
	signal clk_50 : std_logic;
	signal clk_100 : std_logic;
	signal memclk : std_logic;
	signal clk_cpu : std_logic;
	signal clk_dsp : std_logic;
	signal clk44100x256 : std_logic;
	signal clk14745600 : std_logic;
	signal pll1_locked : std_logic;
	signal pll2_locked : std_logic;

	signal reset_button_n : std_logic;
	signal pll_locked : std_logic;
	
-- Global signals
	signal n_reset : std_logic;
	
-- MUX
	signal mux_clk_reg : std_logic := '0';
	signal mux_reg : unsigned(3 downto 0) := (others => '1');
	signal mux_d_reg : unsigned(3 downto 0) := (others => '1');
	signal mux_d_regd : unsigned(3 downto 0) := (others => '1');
	signal mux_regd : unsigned(3 downto 0) := (others => '1');

-- LEDs
	signal led_green : std_logic;
	signal led_red : std_logic;
	signal socleds : std_logic_vector(7 downto 0);

-- PS/2 Keyboard
	signal ps2_keyboard_clk_in : std_logic;
	signal ps2_keyboard_dat_in : std_logic;
	signal ps2_keyboard_clk_out : std_logic;
	signal ps2_keyboard_dat_out : std_logic;

-- PS/2 Mouse
	signal ps2_mouse_clk_in: std_logic;
	signal ps2_mouse_dat_in: std_logic;
	signal ps2_mouse_clk_out: std_logic;
	signal ps2_mouse_dat_out: std_logic;

-- Video
	signal vga_r: unsigned(7 downto 0);
	signal vga_g: unsigned(7 downto 0);
	signal vga_b: unsigned(7 downto 0);
	signal vga_window : std_logic;

-- SD card
	signal spi_mosi : std_logic;
	signal spi_cs : std_logic;
	signal spi_clk : std_logic;
	
-- RS232 serial
	signal rs232_rxd : std_logic;
	signal rs232_txd : std_logic;

-- Sound
	signal audio_l : signed(15 downto 0);
	signal audio_r : signed(15 downto 0);

-- IO
	signal ena_1mhz : std_logic;
	signal button_reset_n : std_logic;

	signal no_clock : std_logic;
	signal docking_station : std_logic;
	signal c64_keys : unsigned(63 downto 0);
	signal c64_restore_key_n : std_logic;
	signal c64_nmi_n : std_logic;
	signal c64_joy1 : unsigned(5 downto 0);
	signal c64_joy2 : unsigned(5 downto 0);
	signal joystick3 : unsigned(5 downto 0);
	signal joystick4 : unsigned(5 downto 0);
	signal usart_rx : std_logic:='1'; -- Safe default
	signal ir : std_logic;

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
	
--	sd_addr(12)<='0'; -- FIXME - genericise the SDRAM size
	
-- -----------------------------------------------------------------------
-- Clocks and PLL
-- -----------------------------------------------------------------------
--	mypll : entity work.Clock_8to100Split
--		port map (
--			inclk0 => clk8,
--			c0 => clk,
--			c1 => sdram_clk,
----			c2 => clk,
--			locked => pll_locked
--		);
		
	mypll : entity work.Clock_8to100Split
		port map (
			inclk0 => clk8,
			c0 => clk_25,
			c1 => memclk, -- the same as c1,
			c2 => sdram_clk, -- as fast as we can get away with.  133Mhz?
			locked => pll1_locked
		);

		mypll2 : entity work.Clock_8to100Split_2ndRAM
		port map (
			inclk0 => clk8,
			c0 => clk_cpu, -- About 60Mhz?
			c1 => clk_dsp, -- About 60MHz?
			c2 => clk_100, -- around 100 MHz for the chameleon builtin modules
			c3 => clk_50,
			locked => pll2_locked
		);

	mypll3 : entity work.Clock_8toSlowClocks
		port map (
			inclk0 => clk8,
			c0 => clk44100x256, -- 11.2896Mhz
			c1 => clk14745600 -- 14.6756 MHz
		);

-- -----------------------------------------------------------------------
-- MUX CPLD
-- -----------------------------------------------------------------------
--	-- MUX clock
--	process(clk)
--	begin
--		if rising_edge(clk) then
--			mux_clk_reg <= not mux_clk_reg;
--		end if;
--	end process;
--
--	-- MUX read
--	process(clk)
--	begin
--		if rising_edge(clk) then
--			if mux_clk_reg = '1' then
--				case mux_reg is
----				when X"6" =>
----					irq_n <= mux_q(2);
--				when X"B" =>
--					reset_button_n <= mux_q(1);
----					ir <= mux_q(3);
--				when X"A" =>
----					vga_id <= mux_q;
--				when X"E" =>
--					ps2_keyboard_dat_in <= mux_q(0);
--					ps2_keyboard_clk_in <= mux_q(1);
--					ps2_mouse_dat_in <= mux_q(2);
--					ps2_mouse_clk_in <= mux_q(3);
--				when others =>
--					null;
--				end case;
--			end if;
--		end if;
--	end process;
--
--	-- MUX write
--	process(clk)
--	begin
--		if rising_edge(clk) then
----			docking_ena <= '0';
--			if mux_clk_reg = '1' then
--				mux_reg<=X"C";
--				mux_d_reg(3) <= '1'; -- usart_rx;	-- AMR transmit to Chameleons uC
--				mux_d_reg(2) <= spi_cs;
--				mux_d_reg(1) <= spi_mosi;
--				mux_d_reg(0) <= spi_clk;
--
--				case mux_reg is
--				when X"7" =>
--					mux_d_regd <= "1111";
--					mux_regd <= X"6";
--				when X"6" =>
--					mux_d_regd <= "1111";
--					mux_regd <= X"8";
--				when X"8" =>
--					mux_d_regd <= "1111";
--					mux_regd <= X"A";
--				when X"A" =>
--					mux_d_regd <= "10" & led_green & led_red;
--					mux_regd <= X"B";
--				when X"B" =>
--				   -- RS232 serial over IEC port; TxD -> ATN as per Christian Vogelgsang's Minimig core
----					mux_d_reg <= iec_reg;
--					mux_d_regd <= "1111";
--					mux_d_regd(3) <= rs232_txd; -- ATN
--					mux_regd <= X"D";
----					docking_ena <= '1';
--				when X"C" =>
--					mux_reg <= mux_regd;
--					mux_d_reg <= mux_d_regd;
--				when X"D" =>
--					rs232_rxd <= mux_q(1); -- IEC_CLK -> RxD
--					mux_d_regd(0) <= ps2_keyboard_dat_out;
--					mux_d_regd(1) <= ps2_keyboard_clk_out;
--					mux_d_regd(2) <= ps2_mouse_dat_out;
--					mux_d_regd(3) <= ps2_mouse_clk_out;
--					mux_regd <= X"E";
--				when X"E" =>
--					mux_d_regd <= "1111";
--					mux_regd <= X"7";
--				when others =>
--					mux_regd <= X"B";
--					mux_d_regd <= "10" & led_green & led_red;
--				end case;
--
--			end if;
--		end if;
--	end process;
--	
--	mux_clk <= mux_clk_reg;
--	mux_d <= mux_d_reg;
--	mux <= mux_reg;
--


my1mhz : entity work.chameleon_1mhz
	generic map (
		-- Timer calibration. Clock speed in Mhz.
		clk_ticks_per_usec => 100
	)
	port map(
		clk => clk_100,
		ena_1mhz => ena_1mhz
	);

myReset : entity work.gen_reset
	generic map (
		resetCycles => 131071
	)
	port map (
		clk => clk_100,
		enable => '1',
		button => not freeze_n,
		nreset => n_reset
	);
	
	myIO : entity work.chameleon_io
		generic map (
			enable_docking_station => true,
			enable_c64_joykeyb => true,
			enable_c64_4player => true,
			enable_raw_spi => true,
			enable_iec_access =>true
		)
		port map (
		-- Clocks
			clk => clk_100,
			clk_mux => clk_100,
			ena_1mhz => ena_1mhz,
			reset => not n_reset,
			
			no_clock => no_clock,
			docking_station => docking_station,
			
		-- Chameleon FPGA pins
			-- C64 Clocks
			phi2_n => phi2_n,
			dotclock_n => dotclock_n, 
			-- C64 cartridge control lines
			io_ef_n => ioef_n,
			rom_lh_n => romlh_n,
			-- SPI bus
			spi_miso => spi_miso,
			-- CPLD multiplexer
			mux_clk => mux_clk,
			mux => mux,
			mux_d => mux_d,
			mux_q => mux_q,
			
			to_usb_rx => usart_rx,

		-- SPI raw signals (enable_raw_spi must be set to true)
			mmc_cs_n => spi_cs,
			spi_raw_clk => spi_clk,
			spi_raw_mosi => spi_mosi,
--			spi_raw_ack => spi_raw_ack,

		-- LEDs
			led_green => '1',
			led_red => '1',
			ir => ir,
		
		-- PS/2 Keyboard
			ps2_keyboard_clk_out => ps2_keyboard_clk_out,
			ps2_keyboard_dat_out => ps2_keyboard_dat_out,
			ps2_keyboard_clk_in => ps2_keyboard_clk_in,
			ps2_keyboard_dat_in => ps2_keyboard_dat_in,
	
		-- PS/2 Mouse
			ps2_mouse_clk_out => ps2_mouse_clk_out,
			ps2_mouse_dat_out => ps2_mouse_dat_out,
			ps2_mouse_clk_in => ps2_mouse_clk_in,
			ps2_mouse_dat_in => ps2_mouse_dat_in,

		-- Buttons
			button_reset_n => button_reset_n,

		-- Joysticks
			joystick1 => c64_joy1,
			joystick2 => c64_joy2,
			joystick3 => joystick3, 
			joystick4 => joystick4,

		-- Keyboards
			keys => c64_keys,
			restore_key_n => c64_restore_key_n,
			c64_nmi_n => c64_nmi_n

--
--			iec_clk_out : in std_logic := '1';
--			iec_dat_out : in std_logic := '1';
--			iec_atn_out => rs232_txd,
--			iec_srq_out : in std_logic := '1';
--			iec_clk_in => rs232_rxd
--			iec_dat_in : out std_logic;
--			iec_atn_in : out std_logic;
--			iec_srq_in : out std_logic
	
		);

	
-- Dither the video down to 5 bits per gun.

	mydither : component video_vga_dither
		generic map(
			outbits => 5
		)
		port map(
			clk=>clk_100,
			hsync=>nHSync,
			vsync=>nVSync,
			vid_ena=>vga_window,
			iRed => vga_r,
			iGreen => vga_g,
			iBlue => vga_b,
			oRed => red,
			oGreen => grn,
			oBlue => blu
		);


vga_window<='1';

vga_r(1 downto 0)<="10";
vga_g(1 downto 0)<="10";
vga_b(1 downto 0)<="10";

sys_inst: entity work.Next186SOCWrapper
	generic map (
		RowBits => 13,
		ColBits => 9,
		enableDSP => 0, -- The BlockRAM's better spent on debugging for now.
		cpuclkfreq => 625
	)
	port map (
		CLK_50MHZ => clk_50,
		clk_25=>clk_25,
		clk_sdr => memclk,
		clk_cpu => clk_cpu,
		clk_dsp => clk_dsp,
		CLK44100x256 => clk44100x256,
		CLK14745600=>clk14745600,
		unsigned(VGA_R) => vga_r(7 downto 2),
		unsigned(VGA_G) => vga_g(7 downto 2),
		unsigned(VGA_B) => vga_b(7 downto 2),
		VGA_HSYNC => nHSync,
		VGA_VSYNC => nVSync,
		sdr_n_CS_WE_RAS_CAS(3)=>open,
		sdr_n_CS_WE_RAS_CAS(2)=>sd_we_n,
		sdr_n_CS_WE_RAS_CAS(1)=>sd_ras_n,
		sdr_n_CS_WE_RAS_CAS(0)=>sd_cas_n,
		sdr_BA(1) => sd_ba_1,
		sdr_BA(0) => sd_ba_0,
		sdr_ADDR => sd_addr,
		sdr_DATA => sd_data,
		sdr_DQM(1) => sd_udqm,
		sdr_DQM(0) => sd_ldqm,
		LED => socleds,
		BTN_RESET=>not n_reset,
		BTN_NMI=>'0',
		RS232_DCE_RXD=>'1',
		RS232_DCE_TXD=>open,
		RS232_EXT_RXD=>'1',
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


end architecture;
