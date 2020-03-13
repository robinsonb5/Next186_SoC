library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.rom_pkg.ALL;

entity Bootstrap is
	generic (
		sysclk_frequency : integer := 500
	);
	port (
		clk 			: in std_logic;
		reset_in 	: in std_logic;

		-- SPI signals
		spi_miso		: in std_logic := '1'; -- Allow the SPI interface not to be plumbed in.
		spi_mosi		: out std_logic;
		spi_clk		: out std_logic;
		spi_cs 		: out std_logic;
		
		-- Data channel
		dc_in : in std_logic_vector(8 downto 0);
		dc_out : out std_logic_vector(8 downto 0);
		
		-- UART
		txd	: out std_logic;
		debug_rxd : in std_logic;
		debug_txd : out std_logic;
		divert_sdcard : out std_logic;
		host_reset : out std_logic
	);
end entity;

architecture rtl of Bootstrap is

constant sysclk_hz : integer := sysclk_frequency*1000;
constant uart_divisor : integer := sysclk_hz/1152;
constant maxAddrBit : integer := 31;

signal reset : std_logic := '0';
signal reset_counter : unsigned(15 downto 0) := X"FFFF";

-- Millisecond counter
signal millisecond_counter : unsigned(31 downto 0) := X"00000000";
signal millisecond_tick : unsigned(19 downto 0);

-- SPI Clock counter
signal spi_tick : unsigned(8 downto 0);
signal spiclk_in : std_logic;
signal spi_fast : std_logic;

-- SPI signals
signal host_to_spi : std_logic_vector(7 downto 0);
signal spi_to_host : std_logic_vector(31 downto 0);
signal spi_trigger : std_logic;
signal spi_busy : std_logic;
signal spi_active : std_logic;


-- UART signals

signal ser_txdata : std_logic_vector(7 downto 0);
signal ser_txready : std_logic;
signal ser_txgo : std_logic;
signal ser_txdata2 : std_logic_vector(7 downto 0);
signal ser_txready2 : std_logic;
signal ser_txgo2 : std_logic;
signal ser_rxint : std_logic;
signal ser_rxrecv : std_logic;
signal ser_rxdata : std_logic_vector(7 downto 0);

-- CPU signals

signal soft_reset_n : std_logic;
signal mem_busy : std_logic;
signal mem_rom : std_logic;
signal rom_ack : std_logic;
signal from_mem : std_logic_vector(31 downto 0);
signal cpu_addr : std_logic_vector(31 downto 0);
signal to_cpu : std_logic_vector(31 downto 0);
signal from_cpu : std_logic_vector(31 downto 0);
signal cpu_req : std_logic; 
signal cpu_ack : std_logic; 
signal cpu_wr : std_logic; 
signal cpu_bytesel : std_logic_vector(3 downto 0);
signal mem_rd : std_logic; 
signal mem_wr : std_logic; 
signal mem_rd_d : std_logic; 
signal mem_wr_d : std_logic; 
signal cache_valid : std_logic;
signal flushcaches : std_logic;

signal to_rom : ToROM;
signal from_rom : FromROM;


begin

-- ROM

	myrom : entity work.Bootstrap_ROM_Merged
	generic map
	(
		maxAddrBitBRAM => 12
	)
	port map (
		clk => clk,
		from_soc => to_rom,
		to_soc => from_rom
	);

-- Reset counter.

host_reset<=reset_in;

process(clk)
begin
	if reset_in='0' then
		reset_counter<=X"FFFF";
		reset<='0';
	elsif rising_edge(clk) then
		reset_counter<=reset_counter-1;
		if reset_counter=X"0000" then
			reset<='1';
		end if;
	end if;
end process;


-- Timer
process(clk)
begin
	if rising_edge(clk) then
		millisecond_tick<=millisecond_tick+1;
		if millisecond_tick=sysclk_frequency*100 then
			millisecond_counter<=millisecond_counter+1;
			millisecond_tick<=X"00000";
		end if;
	end if;
end process;


-- UART

myuart : entity work.simple_uart
	generic map(
		enable_tx=>true,
		enable_rx=>false
	)
	port map(
		clk => clk,
		reset => reset, -- active low
		txdata => ser_txdata,
		txready => ser_txready,
		txgo => ser_txgo,
		rxdata => open,
		rxint => open,
		txint => open,
		clock_divisor => to_unsigned(uart_divisor,16),
		rxd => '1',
		txd => txd
	);


myuart2 : entity work.simple_uart
	generic map(
		enable_tx=>true,
		enable_rx=>false
	)
	port map(
		clk => clk,
		reset => reset, -- active low
		txdata => ser_txdata2,
		txready => ser_txready2,
		txgo => ser_txgo2,
		rxdata => ser_rxdata,
		rxint => ser_rxint,
		txint => open,
		clock_divisor => to_unsigned(uart_divisor,16),
		rxd => debug_rxd,
		txd => debug_txd
	);


-- SPI Timer
process(clk)
begin
	if rising_edge(clk) then
		spiclk_in<='0';
		spi_tick<=spi_tick+1;
		if (spi_fast='1' and spi_tick(4)='1') or spi_tick(8)='1' then
			spiclk_in<='1'; -- Momentary pulse for SPI host.
			spi_tick<='0'&X"00";
		end if;
	end if;
end process;


-- SPI host
spi : entity work.spi_interface
	port map(
		sysclk => clk,
		reset => reset,

		-- Host interface
		spiclk_in => spiclk_in,
		host_to_spi => host_to_spi,
		spi_to_host => spi_to_host,
		trigger => spi_trigger,
		busy => spi_busy,

		-- Hardware interface
		miso => spi_miso,
		mosi => spi_mosi,
		spiclk_out => spi_clk
	);

	
-- Main CPU


	mem_rom <='1' when cpu_addr(31 downto 26)=X"0"&"00" else '0';
	mem_rd<='1' when cpu_req='1' and cpu_wr='0' and mem_rom='0' else '0';
	mem_wr<='1' when cpu_req='1' and cpu_wr='1' and mem_rom='0' else '0';

	to_rom.MemAAddr<=cpu_addr(15 downto 2);
	to_rom.MemAWrite<=from_cpu;
	to_rom.MemAByteSel<=cpu_bytesel;
		
	process(clk)
	begin
		if rising_edge(clk) then
			rom_ack<=cpu_req and mem_rom;

			if mem_rom='1' then
				to_cpu<=from_rom.MemARead;
			else
				to_cpu<=from_mem;
			end if;

			if (mem_busy='0' or rom_ack='1') and cpu_ack='0' then
				cpu_ack<='1';
			else
				cpu_ack<='0';
			end if;

			if mem_rom='1' then
				to_rom.MemAWriteEnable<=(cpu_wr and cpu_req);
			else
				to_rom.MemAWriteEnable<='0';
			end if;
	
		end if;	
	end process;
	
	cpu : entity work.eightthirtytwo_cpu
	generic map
	(
		littleendian => true,
		dualthread => false,
		prefetch => true,
		interrupts => false
	)
	port map
	(
		clk => clk,
		reset_n => reset and soft_reset_n,

		-- cpu fetch interface

		addr => cpu_addr(31 downto 2),
		d => to_cpu,
		q => from_cpu,
		bytesel => cpu_bytesel,
		wr => cpu_wr,
		req => cpu_req,
		ack => cpu_ack
	);
	
process(clk)
begin
	if reset='0' then
		spi_cs<='1';
		spi_active<='0';
		divert_sdcard<='1';
		ser_rxrecv<='1';
	elsif rising_edge(clk) then
		soft_reset_n<='1';
		mem_busy<='1';
		ser_txgo<='0';
		ser_txgo2<='0';
		spi_trigger<='0';

		mem_rd_d<=mem_rd;
		mem_wr_d<=mem_wr;
		
		-- Write from CPU?
		if mem_wr='1' and mem_wr_d='0' and mem_busy='1' then
			case cpu_addr(31)&cpu_addr(10 downto 8) is
				when X"F" =>	-- Peripherals at 0xFFFFFFF00
					case cpu_addr(7 downto 0) is

						when X"C0" => -- Debug UART
							ser_txdata2<=from_cpu(7 downto 0);
							ser_txgo2<='1';
							mem_busy<='0';
							
						when X"C4" => -- Bootstrap UART
							ser_txdata<=from_cpu(7 downto 0);
							ser_txgo<='1';
							mem_busy<='0';

						when X"C8" => -- System control
							divert_sdcard<=from_cpu(0);
							mem_busy<='0';

						when X"CC" => -- Data channel
							dc_out<=from_cpu(8 downto 0);
							mem_busy<='0';

						when X"D0" => -- SPI CS
							spi_cs<=not from_cpu(0);
							spi_fast<=from_cpu(8);
							mem_busy<='0';

						when X"D4" => -- SPI Data
							spi_trigger<='1';
							host_to_spi<=from_cpu(7 downto 0);
							spi_active<='1';

						when others =>
							mem_busy<='0';
							null;
					end case;
				when others => -- SDRAM
--					mem_busy<='0';
					null;
			end case;

		elsif mem_rd='1' and mem_rd_d='0' and mem_busy='1' then -- Read from CPU?
			case cpu_addr(31)&cpu_addr(10 downto 8) is

				when X"F" =>	-- Peripherals
					case cpu_addr(7 downto 0) is
						when X"C0" => -- Debug UART
							from_mem<=(others=>'X');
							from_mem(9 downto 0)<=ser_rxrecv&ser_txready2&ser_rxdata;
							ser_rxrecv<='0';	-- Clear rx flag.
							mem_busy<='0';

						when X"C4" => -- Bootstrap UART
							from_mem<=(others=>'X');
							from_mem(9 downto 0)<='0'&ser_txready&X"00";
							mem_busy<='0';
							
						when X"C8" => -- Millisecond counter
							from_mem<=std_logic_vector(millisecond_counter);
							mem_busy<='0';
							
						when X"CC" => -- Data channel out
							from_mem(8 downto 0)<=dc_in;
							from_mem(31 downto 9)<=(others=>'0');
							mem_busy<='0';


						when X"D0" => -- SPI Status
							from_mem<=(others=>'X');
							from_mem(15)<=spi_busy;
							mem_busy<='0';

						when X"D4" => -- SPI read (blocking)
							spi_active<='1';

						when others =>
							mem_busy<='0';
					end case;

				when others => -- SDRAM
					null;
--					mem_busy<='0';
			end case;
		end if;
		
		-- Set this after the read operation has potentially cleared it.
		if ser_rxint='1' then
			ser_rxrecv<='1';
			if ser_rxdata=X"04" then
				soft_reset_n<='0';
				ser_rxrecv<='0';
			end if;
		end if;

	-- SPI cycles

		if spi_active='1' and spi_busy='0' then
			from_mem<=spi_to_host;
			spi_active<='0';
			mem_busy<='0';
		end if;

	end if; -- rising-edge(clk)

end process;
	
end architecture;
