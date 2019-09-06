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
     0 => x"518ef72d",
     1 => x"a5b408a5",
     2 => x"b4085556",
     3 => x"aaf40897",
     4 => x"3873881e",
     5 => x"0c738c1e",
     6 => x"0c747d0c",
     7 => x"795473a5",
     8 => x"b40c02b4",
     9 => x"050d04a5",
    10 => x"b408881e",
    11 => x"0c941780",
    12 => x"e02d518e",
    13 => x"f72da5b4",
    14 => x"08902b83",
    15 => x"fff00a06",
    16 => x"7017707f",
    17 => x"88050c8c",
    18 => x"1f0c5474",
    19 => x"7d0c7954",
    20 => x"a09e0480",
    21 => x"0ba5b40c",
    22 => x"02b4050d",
    23 => x"0402f405",
    24 => x"0d747008",
    25 => x"8105710c",
    26 => x"7008aaf0",
    27 => x"08065353",
    28 => x"71802e8b",
    29 => x"38810ba5",
    30 => x"b40c028c",
    31 => x"050d0488",
    32 => x"1308519d",
    33 => x"b32da5b4",
    34 => x"0888140c",
    35 => x"810ba5b4",
    36 => x"0c028c05",
    37 => x"0d0402f0",
    38 => x"050d7588",
    39 => x"1108fe05",
    40 => x"aafc0829",
    41 => x"ab840811",
    42 => x"7208aaf0",
    43 => x"08060579",
    44 => x"55535454",
    45 => x"8de42da5",
    46 => x"b40853a5",
    47 => x"b408802e",
    48 => x"83388153",
    49 => x"72a5b40c",
    50 => x"0290050d",
    51 => x"0402ec05",
    52 => x"0d767884",
    53 => x"1208892a",
    54 => x"54555380",
    55 => x"55737227",
    56 => x"a9387208",
    57 => x"52737227",
    58 => x"8c387473",
    59 => x"0c8c1308",
    60 => x"88140c74",
    61 => x"5271742e",
    62 => x"8f387251",
    63 => x"a0dd2d72",
    64 => x"08742e09",
    65 => x"8106f338",
    66 => x"815574a5",
    67 => x"b40c0294",
    68 => x"050d0402",
    69 => x"ec050d77",
    70 => x"7753aad0",
    71 => x"52539e9f",
    72 => x"2da5b408",
    73 => x"54a5b408",
    74 => x"8a3873a5",
    75 => x"b40c0294",
    76 => x"050d04a5",
    77 => x"9851839e",
    78 => x"2daad408",
    79 => x"83ff0589",
    80 => x"2a558054",
    81 => x"737525a2",
    82 => x"387252aa",
    83 => x"d051a196",
    84 => x"2da5b408",
    85 => x"802e9d38",
    86 => x"aad051a0",
    87 => x"dd2d8480",
    88 => x"13811555",
    89 => x"53747424",
    90 => x"e038810b",
    91 => x"a5b40c02",
    92 => x"94050d04",
    93 => x"a5b408a5",
    94 => x"b40c0294",
    95 => x"050d0400",
    96 => x"00ffffff",
    97 => x"ff00ffff",
    98 => x"ffff00ff",
    99 => x"ffffff00",
   100 => x"434d4400",
   101 => x"57726974",
   102 => x"65206661",
   103 => x"696c6564",
   104 => x"0a000000",
   105 => x"53504900",
   106 => x"5344496e",
   107 => x"69742000",
   108 => x"50617274",
   109 => x"20000000",
   110 => x"3f3f3f20",
   111 => x"00000000",
   112 => x"42535450",
   113 => x"20000000",
   114 => x"42494f53",
   115 => x"4e455854",
   116 => x"31383600",
   117 => x"730a0000",
   118 => x"52434150",
   119 => x"20000000",
   120 => x"4e455854",
   121 => x"424f4f54",
   122 => x"494d4700",
   123 => x"720a0000",
   124 => x"20465300",
   125 => x"46457272",
   126 => x"20000000",
   127 => x"52656164",
   128 => x"696e6720",
   129 => x"4d42520a",
   130 => x"00000000",
   131 => x"52656164",
   132 => x"206f6620",
   133 => x"4d425220",
   134 => x"6661696c",
   135 => x"65640a00",
   136 => x"4d425220",
   137 => x"73756363",
   138 => x"65737366",
   139 => x"756c6c79",
   140 => x"20726561",
   141 => x"640a0000",
   142 => x"46415431",
   143 => x"36202020",
   144 => x"00000000",
   145 => x"46415433",
   146 => x"32202020",
   147 => x"00000000",
   148 => x"4e6f2070",
   149 => x"61727469",
   150 => x"74696f6e",
   151 => x"20736967",
   152 => x"6e617475",
   153 => x"72652066",
   154 => x"6f756e64",
   155 => x"0a000000",
   156 => x"52656164",
   157 => x"20626f6f",
   158 => x"74207365",
   159 => x"63746f72",
   160 => x"2066726f",
   161 => x"6d206669",
   162 => x"72737420",
   163 => x"70617274",
   164 => x"6974696f",
   165 => x"6e0a0000",
   166 => x"4f70656e",
   167 => x"65642066",
   168 => x"696c652c",
   169 => x"206c6f61",
   170 => x"64696e67",
   171 => x"2e2e2e0a",
   172 => x"002e2e0a",
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

