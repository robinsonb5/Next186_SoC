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
     0 => x"050d0402",
     1 => x"f4050d74",
     2 => x"70088105",
     3 => x"710c7008",
     4 => x"aa980806",
     5 => x"53537180",
     6 => x"2e8b3881",
     7 => x"0ba4dc0c",
     8 => x"028c050d",
     9 => x"04881308",
    10 => x"519cd92d",
    11 => x"a4dc0888",
    12 => x"140c810b",
    13 => x"a4dc0c02",
    14 => x"8c050d04",
    15 => x"02f0050d",
    16 => x"75881108",
    17 => x"fe05aaa4",
    18 => x"0829aaac",
    19 => x"08117208",
    20 => x"aa980806",
    21 => x"05795553",
    22 => x"54548de4",
    23 => x"2da4dc08",
    24 => x"53a4dc08",
    25 => x"802e8338",
    26 => x"815372a4",
    27 => x"dc0c0290",
    28 => x"050d0402",
    29 => x"ec050d76",
    30 => x"78841208",
    31 => x"892a5455",
    32 => x"53805573",
    33 => x"7227a938",
    34 => x"72085273",
    35 => x"72278c38",
    36 => x"74730c8c",
    37 => x"13088814",
    38 => x"0c745271",
    39 => x"742e8f38",
    40 => x"7251a083",
    41 => x"2d720874",
    42 => x"2e098106",
    43 => x"f3388155",
    44 => x"74a4dc0c",
    45 => x"0294050d",
    46 => x"0402ec05",
    47 => x"0d777753",
    48 => x"a9f85253",
    49 => x"9dc52da4",
    50 => x"dc0854a4",
    51 => x"dc088a38",
    52 => x"73a4dc0c",
    53 => x"0294050d",
    54 => x"04a4c051",
    55 => x"839e2da9",
    56 => x"fc0883ff",
    57 => x"05892a55",
    58 => x"80547375",
    59 => x"25a23872",
    60 => x"52a9f851",
    61 => x"a0bc2da4",
    62 => x"dc08802e",
    63 => x"9d38a9f8",
    64 => x"51a0832d",
    65 => x"84801381",
    66 => x"15555374",
    67 => x"7424e038",
    68 => x"810ba4dc",
    69 => x"0c029405",
    70 => x"0d04a4dc",
    71 => x"08a4dc0c",
    72 => x"0294050d",
    73 => x"04000000",
    74 => x"00ffffff",
    75 => x"ff00ffff",
    76 => x"ffff00ff",
    77 => x"ffffff00",
    78 => x"434d4400",
    79 => x"57726974",
    80 => x"65206661",
    81 => x"696c6564",
    82 => x"0a000000",
    83 => x"53504900",
    84 => x"5344496e",
    85 => x"69742000",
    86 => x"50617274",
    87 => x"20000000",
    88 => x"3f3f3f20",
    89 => x"00000000",
    90 => x"42535450",
    91 => x"20000000",
    92 => x"42494f53",
    93 => x"4e455854",
    94 => x"31383600",
    95 => x"730a0000",
    96 => x"52434150",
    97 => x"20000000",
    98 => x"4e455854",
    99 => x"424f4f54",
   100 => x"494d4700",
   101 => x"720a0000",
   102 => x"20465300",
   103 => x"46457272",
   104 => x"20000000",
   105 => x"52656164",
   106 => x"696e6720",
   107 => x"4d42520a",
   108 => x"00000000",
   109 => x"52656164",
   110 => x"206f6620",
   111 => x"4d425220",
   112 => x"6661696c",
   113 => x"65640a00",
   114 => x"4d425220",
   115 => x"73756363",
   116 => x"65737366",
   117 => x"756c6c79",
   118 => x"20726561",
   119 => x"640a0000",
   120 => x"46415431",
   121 => x"36202020",
   122 => x"00000000",
   123 => x"46415433",
   124 => x"32202020",
   125 => x"00000000",
   126 => x"4e6f2070",
   127 => x"61727469",
   128 => x"74696f6e",
   129 => x"20736967",
   130 => x"6e617475",
   131 => x"72652066",
   132 => x"6f756e64",
   133 => x"0a000000",
   134 => x"52656164",
   135 => x"20626f6f",
   136 => x"74207365",
   137 => x"63746f72",
   138 => x"2066726f",
   139 => x"6d206669",
   140 => x"72737420",
   141 => x"70617274",
   142 => x"6974696f",
   143 => x"6e0a0000",
   144 => x"4f70656e",
   145 => x"65642066",
   146 => x"696c652c",
   147 => x"206c6f61",
   148 => x"64696e67",
   149 => x"2e2e2e0a",
   150 => x"002e2e0a",
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

