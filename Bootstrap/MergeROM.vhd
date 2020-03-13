-- ROM Wrapper - combines two ROMS of different sizes into a single ROM.
-- Useful to reduce block RAM demands.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rom_pkg.ALL;

entity MergeROM is
generic
	(
		maxAddrBitBRAM : integer := maxAddrBitBRAMLimit -- Specify your actual ROM size to save LEs and unnecessary block RAM usage.
	);
port (
	clk : in std_logic;
	areset : in std_logic := '0';
	from_soc : in toROM;
	to_soc : out fromROM;
	from_rom1 : in fromROM;
	to_rom1 : out toROM;
	from_rom2 : in fromROM;
	to_rom2 : out toROM
);
end entity;


architecture arch of MergeROM is
signal romsel_a : std_logic;
begin

romsel_a<=from_soc.memAAddr(maxAddrBitBRAM);

-- use high bit of incoming address to switch between two ROMS
to_rom1.memAAddr<=from_soc.memAAddr;
to_rom1.memAWrite<=from_soc.memAWrite;
to_rom1.memAWriteEnable<=from_soc.memAWriteEnable when from_soc.memAAddr(maxAddrBitBRAM)='0' else '0';
to_rom1.memAByteSel<=from_soc.memAByteSel;

to_rom2.memAAddr<=from_soc.memAAddr;
to_rom2.memAWrite<=from_soc.memAWrite;
to_rom2.memAWriteEnable<=from_soc.memAWriteEnable when from_soc.memAAddr(maxAddrBitBRAM)='1' else '0';
to_rom2.memAByteSel<=from_soc.memAByteSel;

to_soc.memARead <= from_rom1.memARead when romsel_a='0' else from_rom2.memARead;

end arch;

