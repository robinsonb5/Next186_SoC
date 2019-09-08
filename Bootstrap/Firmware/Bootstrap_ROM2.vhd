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
     0 => x"0402f405",
     1 => x"0d747008",
     2 => x"8105710c",
     3 => x"7008aac8",
     4 => x"08065353",
     5 => x"71802e8b",
     6 => x"38810ba5",
     7 => x"800c028c",
     8 => x"050d0488",
     9 => x"1308519c",
    10 => x"d72da580",
    11 => x"0888140c",
    12 => x"810ba580",
    13 => x"0c028c05",
    14 => x"0d0402f0",
    15 => x"050d7588",
    16 => x"1108fe05",
    17 => x"aad40829",
    18 => x"aadc0811",
    19 => x"7208aac8",
    20 => x"08060579",
    21 => x"55535454",
    22 => x"8de42da5",
    23 => x"800853a5",
    24 => x"8008802e",
    25 => x"83388153",
    26 => x"72a5800c",
    27 => x"0290050d",
    28 => x"0402f005",
    29 => x"0d758811",
    30 => x"08fe05aa",
    31 => x"d40829aa",
    32 => x"dc081172",
    33 => x"08aac808",
    34 => x"06057955",
    35 => x"53545488",
    36 => x"872da580",
    37 => x"0853a580",
    38 => x"08802e83",
    39 => x"38815372",
    40 => x"a5800c02",
    41 => x"90050d04",
    42 => x"02ec050d",
    43 => x"76788412",
    44 => x"08892a54",
    45 => x"55538055",
    46 => x"737227a9",
    47 => x"38720852",
    48 => x"7372278c",
    49 => x"3874730c",
    50 => x"8c130888",
    51 => x"140c7452",
    52 => x"71742e8f",
    53 => x"387251a0",
    54 => x"812d7208",
    55 => x"742e0981",
    56 => x"06f33881",
    57 => x"5574a580",
    58 => x"0c029405",
    59 => x"0d0402ec",
    60 => x"050d7777",
    61 => x"53aaa852",
    62 => x"539dc32d",
    63 => x"a5800854",
    64 => x"a580088a",
    65 => x"3873a580",
    66 => x"0c029405",
    67 => x"0d04a4e4",
    68 => x"51839e2d",
    69 => x"aaac0883",
    70 => x"ff05892a",
    71 => x"55805473",
    72 => x"7525a238",
    73 => x"7252aaa8",
    74 => x"51a0ba2d",
    75 => x"a5800880",
    76 => x"2e9d38aa",
    77 => x"a851a081",
    78 => x"2d848013",
    79 => x"81155553",
    80 => x"747424e0",
    81 => x"38810ba5",
    82 => x"800c0294",
    83 => x"050d04a5",
    84 => x"8008a580",
    85 => x"0c029405",
    86 => x"0d040000",
    87 => x"00ffffff",
    88 => x"ff00ffff",
    89 => x"ffff00ff",
    90 => x"ffffff00",
    91 => x"434d4400",
    92 => x"57726974",
    93 => x"65206661",
    94 => x"696c6564",
    95 => x"0a000000",
    96 => x"53504900",
    97 => x"5344496e",
    98 => x"69742000",
    99 => x"50617274",
   100 => x"20000000",
   101 => x"3f3f3f20",
   102 => x"00000000",
   103 => x"50617269",
   104 => x"74792065",
   105 => x"72726f72",
   106 => x"0a000000",
   107 => x"52434150",
   108 => x"20000000",
   109 => x"20465300",
   110 => x"570a0000",
   111 => x"770a0000",
   112 => x"46457272",
   113 => x"20000000",
   114 => x"52656164",
   115 => x"696e6720",
   116 => x"4d42520a",
   117 => x"00000000",
   118 => x"52656164",
   119 => x"206f6620",
   120 => x"4d425220",
   121 => x"6661696c",
   122 => x"65640a00",
   123 => x"4d425220",
   124 => x"73756363",
   125 => x"65737366",
   126 => x"756c6c79",
   127 => x"20726561",
   128 => x"640a0000",
   129 => x"46415431",
   130 => x"36202020",
   131 => x"00000000",
   132 => x"46415433",
   133 => x"32202020",
   134 => x"00000000",
   135 => x"4e6f2070",
   136 => x"61727469",
   137 => x"74696f6e",
   138 => x"20736967",
   139 => x"6e617475",
   140 => x"72652066",
   141 => x"6f756e64",
   142 => x"0a000000",
   143 => x"52656164",
   144 => x"20626f6f",
   145 => x"74207365",
   146 => x"63746f72",
   147 => x"2066726f",
   148 => x"6d206669",
   149 => x"72737420",
   150 => x"70617274",
   151 => x"6974696f",
   152 => x"6e0a0000",
   153 => x"4f70656e",
   154 => x"65642066",
   155 => x"696c652c",
   156 => x"206c6f61",
   157 => x"64696e67",
   158 => x"2e2e2e0a",
   159 => x"002e2e0a",
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

