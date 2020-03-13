-- Control ROM for the FPGA PC Engine project.
-- the ROM is split between two different chunks of memory of different
-- size to reduce demands on block RAM.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.rom_pkg.ALL;

entity Bootstrap_ROM_Merged is
generic
	(
		maxAddrBitBRAM : integer := maxAddrBitBRAMLimit -- Specify your actual ROM size to save LEs and unnecessary block RAM usage.
	);
port (
	clk : in std_logic;
	areset : in std_logic := '0';
	from_soc : in toROM;
	to_soc : out fromROM
);
end Bootstrap_ROM_Merged;

architecture arch of Bootstrap_ROM_Merged is

signal to_rom1 : toROM;
signal from_rom1 : fromROM;
signal to_rom2 : toROM;
signal from_rom2 : fromROM;

begin

	myrom1 : entity work.Bootstrap_ROM1
	generic map
	(
		maxAddrBitBRAM => maxAddrBitBRAM-1
	)
	port map (
		clk => clk,
		from_soc => to_rom1,
		to_soc => from_rom1
	);

	myrom2 : entity work.Bootstrap_ROM2
	generic map
	(
		maxAddrBitBRAM => maxAddrBitBRAM-2
	)
	port map (
		clk => clk,
		from_soc => to_rom2,
		to_soc => from_rom2
	);

	merge : entity work.MergeROM
	generic map
	(
		maxAddrBitBRAM => maxAddrBitBRAM
	)
	port map (
		clk => clk,
		from_soc => from_soc,
		to_soc => to_soc,
		from_rom1 => from_rom1,
		to_rom1 => to_rom1,
		from_rom2 => from_rom2,
		to_rom2 => to_rom2
	);

end arch;

