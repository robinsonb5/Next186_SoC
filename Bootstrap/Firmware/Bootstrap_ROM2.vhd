-- ZPU
--
-- Copyright 2004-2008 oharboe - �yvind Harboe - oyvind.harboe@zylin.com
-- Modified by Alastair M. Robinson for the ZPUFlex project.
--
-- The FreeBSD license
-- 
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions
-- are met:
-- 
-- 1. Redistributions of source code must retain the above copyright
--    notice, this list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above
--    copyright notice, this list of conditions and the following
--    disclaimer in the documentation and/or other materials
--    provided with the distribution.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE ZPU PROJECT ``AS IS'' AND ANY
-- EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
-- PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
-- ZPU PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
-- INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
-- OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
-- STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
-- ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-- 
-- The views and conclusions contained in the software and documentation
-- are those of the authors and should not be interpreted as representing
-- official policies, either expressed or implied, of the ZPU Project.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.zpupkg.all;

entity Bootstrap_ROM2 is
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
end Bootstrap_ROM2;

architecture arch of Bootstrap_ROM2 is

type ram_type is array(natural range 0 to ((2**(maxAddrBitBRAM+1))/4)-1) of std_logic_vector(wordSize-1 downto 0);

shared variable ram : ram_type :=
(
     0 => x"94050d04",
     1 => x"02ec050d",
     2 => x"777753a8",
     3 => x"9852539c",
     4 => x"902da2f0",
     5 => x"0854a2f0",
     6 => x"08802ebf",
     7 => x"38a2d451",
     8 => x"838b2da8",
     9 => x"9c0883ff",
    10 => x"05892a55",
    11 => x"80547375",
    12 => x"25a73872",
    13 => x"52a89851",
    14 => x"9ed92da2",
    15 => x"f008802e",
    16 => x"9138a898",
    17 => x"519eac2d",
    18 => x"84801381",
    19 => x"155553a0",
    20 => x"ae04a2f0",
    21 => x"0854a0db",
    22 => x"04815473",
    23 => x"a2f00c02",
    24 => x"94050d04",
    25 => x"00ffffff",
    26 => x"ff00ffff",
    27 => x"ffff00ff",
    28 => x"ffffff00",
    29 => x"434d4400",
    30 => x"57726974",
    31 => x"65206661",
    32 => x"696c6564",
    33 => x"0a000000",
    34 => x"53504900",
    35 => x"49455252",
    36 => x"00000000",
    37 => x"5344496e",
    38 => x"69742000",
    39 => x"50617274",
    40 => x"20000000",
    41 => x"46457272",
    42 => x"20000000",
    43 => x"52434150",
    44 => x"20000000",
    45 => x"3f200000",
    46 => x"52656164",
    47 => x"696e6720",
    48 => x"4d42520a",
    49 => x"00000000",
    50 => x"52656164",
    51 => x"206f6620",
    52 => x"4d425220",
    53 => x"6661696c",
    54 => x"65640a00",
    55 => x"4d425220",
    56 => x"73756363",
    57 => x"65737366",
    58 => x"756c6c79",
    59 => x"20726561",
    60 => x"640a0000",
    61 => x"46415431",
    62 => x"36202020",
    63 => x"00000000",
    64 => x"46415433",
    65 => x"32202020",
    66 => x"00000000",
    67 => x"4e6f2070",
    68 => x"61727469",
    69 => x"74696f6e",
    70 => x"20736967",
    71 => x"6e617475",
    72 => x"72652066",
    73 => x"6f756e64",
    74 => x"0a000000",
    75 => x"52656164",
    76 => x"20626f6f",
    77 => x"74207365",
    78 => x"63746f72",
    79 => x"2066726f",
    80 => x"6d206669",
    81 => x"72737420",
    82 => x"70617274",
    83 => x"6974696f",
    84 => x"6e0a0000",
    85 => x"4f70656e",
    86 => x"65642066",
    87 => x"696c652c",
    88 => x"206c6f61",
    89 => x"64696e67",
    90 => x"2e2e2e0a",
    91 => x"002e2e0a",
	others => x"00000000"
);

begin

process (clk)
begin
	if (clk'event and clk = '1') then
		if (from_zpu.memAWriteEnable = '1') and (from_zpu.memBWriteEnable = '1') and (from_zpu.memAAddr=from_zpu.memBAddr) and (from_zpu.memAWrite/=from_zpu.memBWrite) then
			report "write collision" severity failure;
		end if;
	
		if (from_zpu.memAWriteEnable = '1') then
			ram(to_integer(unsigned(from_zpu.memAAddr(maxAddrBitBRAM downto 2)))) := from_zpu.memAWrite;
			to_zpu.memARead <= from_zpu.memAWrite;
		else
			to_zpu.memARead <= ram(to_integer(unsigned(from_zpu.memAAddr(maxAddrBitBRAM downto 2))));
		end if;
	end if;
end process;

process (clk)
begin
	if (clk'event and clk = '1') then
		if (from_zpu.memBWriteEnable = '1') then
			ram(to_integer(unsigned(from_zpu.memBAddr(maxAddrBitBRAM downto 2)))) := from_zpu.memBWrite;
			to_zpu.memBRead <= from_zpu.memBWrite;
		else
			to_zpu.memBRead <= ram(to_integer(unsigned(from_zpu.memBAddr(maxAddrBitBRAM downto 2))));
		end if;
	end if;
end process;


end arch;

