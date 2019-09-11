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
     0 => x"2da4c008",
     1 => x"88140c81",
     2 => x"0ba4c00c",
     3 => x"028c050d",
     4 => x"0402f005",
     5 => x"0d758811",
     6 => x"08fe05aa",
     7 => x"940829aa",
     8 => x"9c081172",
     9 => x"08aa8808",
    10 => x"06057955",
    11 => x"5354548d",
    12 => x"ea2da4c0",
    13 => x"0853a4c0",
    14 => x"08802e83",
    15 => x"38815372",
    16 => x"a4c00c02",
    17 => x"90050d04",
    18 => x"02f0050d",
    19 => x"75881108",
    20 => x"fe05aa94",
    21 => x"0829aa9c",
    22 => x"08117208",
    23 => x"aa880806",
    24 => x"05795553",
    25 => x"54548887",
    26 => x"2da4c008",
    27 => x"53a4c008",
    28 => x"802e8338",
    29 => x"815372a4",
    30 => x"c00c0290",
    31 => x"050d0402",
    32 => x"ec050d76",
    33 => x"78841208",
    34 => x"892a5455",
    35 => x"53805573",
    36 => x"7227a938",
    37 => x"72085273",
    38 => x"72278c38",
    39 => x"74730c8c",
    40 => x"13088814",
    41 => x"0c745271",
    42 => x"742e8f38",
    43 => x"72519fd8",
    44 => x"2d720874",
    45 => x"2e098106",
    46 => x"f3388155",
    47 => x"74a4c00c",
    48 => x"0294050d",
    49 => x"0402ec05",
    50 => x"0d777753",
    51 => x"a9e85253",
    52 => x"9d9a2da4",
    53 => x"c00854a4",
    54 => x"c0088a38",
    55 => x"73a4c00c",
    56 => x"0294050d",
    57 => x"04a4a451",
    58 => x"839e2da9",
    59 => x"ec0883ff",
    60 => x"05892a55",
    61 => x"80547375",
    62 => x"25a23872",
    63 => x"52a9e851",
    64 => x"a0912da4",
    65 => x"c008802e",
    66 => x"9d38a9e8",
    67 => x"519fd82d",
    68 => x"84801381",
    69 => x"15555374",
    70 => x"7424e038",
    71 => x"810ba4c0",
    72 => x"0c029405",
    73 => x"0d04a4c0",
    74 => x"08a4c00c",
    75 => x"0294050d",
    76 => x"04000000",
    77 => x"00ffffff",
    78 => x"ff00ffff",
    79 => x"ffff00ff",
    80 => x"ffffff00",
    81 => x"434d4400",
    82 => x"57726974",
    83 => x"65206661",
    84 => x"696c6564",
    85 => x"0a000000",
    86 => x"53504900",
    87 => x"49455252",
    88 => x"00000000",
    89 => x"5344496e",
    90 => x"69742000",
    91 => x"50617274",
    92 => x"20000000",
    93 => x"3f200000",
    94 => x"52434150",
    95 => x"20000000",
    96 => x"46457272",
    97 => x"20000000",
    98 => x"52656164",
    99 => x"696e6720",
   100 => x"4d42520a",
   101 => x"00000000",
   102 => x"52656164",
   103 => x"206f6620",
   104 => x"4d425220",
   105 => x"6661696c",
   106 => x"65640a00",
   107 => x"4d425220",
   108 => x"73756363",
   109 => x"65737366",
   110 => x"756c6c79",
   111 => x"20726561",
   112 => x"640a0000",
   113 => x"46415431",
   114 => x"36202020",
   115 => x"00000000",
   116 => x"46415433",
   117 => x"32202020",
   118 => x"00000000",
   119 => x"4e6f2070",
   120 => x"61727469",
   121 => x"74696f6e",
   122 => x"20736967",
   123 => x"6e617475",
   124 => x"72652066",
   125 => x"6f756e64",
   126 => x"0a000000",
   127 => x"52656164",
   128 => x"20626f6f",
   129 => x"74207365",
   130 => x"63746f72",
   131 => x"2066726f",
   132 => x"6d206669",
   133 => x"72737420",
   134 => x"70617274",
   135 => x"6974696f",
   136 => x"6e0a0000",
   137 => x"4f70656e",
   138 => x"65642066",
   139 => x"696c652c",
   140 => x"206c6f61",
   141 => x"64696e67",
   142 => x"2e2e2e0a",
   143 => x"002e2e0a",
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

