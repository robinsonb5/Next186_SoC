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
     0 => x"a5d00855",
     1 => x"56ab9008",
     2 => x"97387388",
     3 => x"1e0c738c",
     4 => x"1e0c747d",
     5 => x"0c795473",
     6 => x"a5d00c02",
     7 => x"b4050d04",
     8 => x"a5d00888",
     9 => x"1e0c9417",
    10 => x"80e02d51",
    11 => x"8ef72da5",
    12 => x"d008902b",
    13 => x"83fff00a",
    14 => x"06701770",
    15 => x"7f88050c",
    16 => x"8c1f0c54",
    17 => x"747d0c79",
    18 => x"54a09704",
    19 => x"800ba5d0",
    20 => x"0c02b405",
    21 => x"0d0402f4",
    22 => x"050d7470",
    23 => x"08810571",
    24 => x"0c7008ab",
    25 => x"8c080653",
    26 => x"5371802e",
    27 => x"8b38810b",
    28 => x"a5d00c02",
    29 => x"8c050d04",
    30 => x"88130851",
    31 => x"9dac2da5",
    32 => x"d0088814",
    33 => x"0c810ba5",
    34 => x"d00c028c",
    35 => x"050d0402",
    36 => x"f0050d75",
    37 => x"881108fe",
    38 => x"05ab9808",
    39 => x"29aba008",
    40 => x"117208ab",
    41 => x"8c080605",
    42 => x"79555354",
    43 => x"548de42d",
    44 => x"a5d00853",
    45 => x"a5d00880",
    46 => x"2e833881",
    47 => x"5372a5d0",
    48 => x"0c029005",
    49 => x"0d0402e8",
    50 => x"050d7779",
    51 => x"71087089",
    52 => x"2a555556",
    53 => x"54805674",
    54 => x"72279b38",
    55 => x"7275269f",
    56 => x"3872752e",
    57 => x"8f387351",
    58 => x"a0d62d73",
    59 => x"08752e09",
    60 => x"8106f338",
    61 => x"815675a5",
    62 => x"d00c0298",
    63 => x"050d0475",
    64 => x"740c8c14",
    65 => x"08519dac",
    66 => x"2da5d008",
    67 => x"88150c73",
    68 => x"08537275",
    69 => x"2e098106",
    70 => x"cd38a1f4",
    71 => x"0402ec05",
    72 => x"0d777753",
    73 => x"aaec5253",
    74 => x"9e982da5",
    75 => x"d00854a5",
    76 => x"d0088a38",
    77 => x"73a5d00c",
    78 => x"0294050d",
    79 => x"04a5b451",
    80 => x"839e2daa",
    81 => x"f00883ff",
    82 => x"05892a55",
    83 => x"80547375",
    84 => x"25a23872",
    85 => x"52aaec51",
    86 => x"a18f2da5",
    87 => x"d008802e",
    88 => x"9d38aaec",
    89 => x"51a0d62d",
    90 => x"84801381",
    91 => x"15555374",
    92 => x"7424e038",
    93 => x"810ba5d0",
    94 => x"0c029405",
    95 => x"0d04a5d0",
    96 => x"08a5d00c",
    97 => x"0294050d",
    98 => x"04000000",
    99 => x"00ffffff",
   100 => x"ff00ffff",
   101 => x"ffff00ff",
   102 => x"ffffff00",
   103 => x"434d4400",
   104 => x"57726974",
   105 => x"65206661",
   106 => x"696c6564",
   107 => x"0a000000",
   108 => x"53504900",
   109 => x"5344496e",
   110 => x"69742000",
   111 => x"50617274",
   112 => x"20000000",
   113 => x"3f3f3f20",
   114 => x"00000000",
   115 => x"20520000",
   116 => x"42535450",
   117 => x"20000000",
   118 => x"42494f53",
   119 => x"4e455854",
   120 => x"31383600",
   121 => x"730a0000",
   122 => x"52434150",
   123 => x"20000000",
   124 => x"4e455854",
   125 => x"424f4f54",
   126 => x"494d4700",
   127 => x"20570000",
   128 => x"720a0000",
   129 => x"4e4f500a",
   130 => x"00000000",
   131 => x"20465300",
   132 => x"46457272",
   133 => x"20000000",
   134 => x"52656164",
   135 => x"696e6720",
   136 => x"4d42520a",
   137 => x"00000000",
   138 => x"52656164",
   139 => x"206f6620",
   140 => x"4d425220",
   141 => x"6661696c",
   142 => x"65640a00",
   143 => x"4d425220",
   144 => x"73756363",
   145 => x"65737366",
   146 => x"756c6c79",
   147 => x"20726561",
   148 => x"640a0000",
   149 => x"46415431",
   150 => x"36202020",
   151 => x"00000000",
   152 => x"46415433",
   153 => x"32202020",
   154 => x"00000000",
   155 => x"4e6f2070",
   156 => x"61727469",
   157 => x"74696f6e",
   158 => x"20736967",
   159 => x"6e617475",
   160 => x"72652066",
   161 => x"6f756e64",
   162 => x"0a000000",
   163 => x"52656164",
   164 => x"20626f6f",
   165 => x"74207365",
   166 => x"63746f72",
   167 => x"2066726f",
   168 => x"6d206669",
   169 => x"72737420",
   170 => x"70617274",
   171 => x"6974696f",
   172 => x"6e0a0000",
   173 => x"4f70656e",
   174 => x"65642066",
   175 => x"696c652c",
   176 => x"206c6f61",
   177 => x"64696e67",
   178 => x"2e2e2e0a",
   179 => x"002e2e0a",
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

