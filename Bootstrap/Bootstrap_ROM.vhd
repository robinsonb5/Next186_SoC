-- Control ROM for the FPGA PC Engine project.
-- the ROM is split between two different chunks of memory of different
-- size to reduce demands on block RAM.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.zpupkg.all;

entity Bootstrap_ROM is
generic
	(
		maxAddrBitBRAM : integer := maxAddrBitBRAMLimit -- Specify your actual ROM size to save LEs and unnecessary block RAM usage.
	);
port (
	clk : in std_logic;
	areset : in std_logic := '0';
	from_zpu : in ZPU_ToROM;
	to_zpu : out ZPU_FromROM
);
end Bootstrap_ROM;

architecture arch of Bootstrap_ROM is

signal to_rom1 : ZPU_ToROM;
signal from_rom1 : ZPU_FromROM;
signal to_rom2 : ZPU_ToROM;
signal from_rom2 : ZPU_FromROM;

begin

	myrom1 : entity work.Bootstrap_ROM1
	generic map
	(
		maxAddrBitBRAM => maxAddrBitBRAM-1
	)
	port map (
		clk => clk,
		from_zpu => to_rom1,
		to_zpu => from_rom1
	);

	myrom2 : entity work.Bootstrap_ROM2
	generic map
	(
		maxAddrBitBRAM => maxAddrBitBRAM-2
	)
	port map (
		clk => clk,
		from_zpu => to_rom2,
		to_zpu => from_rom2
	);

	merge : entity work.MergeROM
	generic map
	(
		maxAddrBitBRAM => maxAddrBitBRAM
	)
	port map (
		clk => clk,
		from_zpu => from_zpu,
		to_zpu => to_zpu,
		from_rom1 => from_rom1,
		to_rom1 => to_rom1,
		from_rom2 => from_rom2,
		to_rom2 => to_rom2
	);

end arch;

