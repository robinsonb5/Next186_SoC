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
     0 => x"0c810ba4",
     1 => x"b00c028c",
     2 => x"050d0402",
     3 => x"f0050d75",
     4 => x"881108fe",
     5 => x"05aa8408",
     6 => x"29aa8c08",
     7 => x"117208a9",
     8 => x"f8080605",
     9 => x"79555354",
    10 => x"548de42d",
    11 => x"a4b00853",
    12 => x"a4b00880",
    13 => x"2e833881",
    14 => x"5372a4b0",
    15 => x"0c029005",
    16 => x"0d0402f0",
    17 => x"050d7588",
    18 => x"1108fe05",
    19 => x"aa840829",
    20 => x"aa8c0811",
    21 => x"7208a9f8",
    22 => x"08060579",
    23 => x"55535454",
    24 => x"88872da4",
    25 => x"b00853a4",
    26 => x"b008802e",
    27 => x"83388153",
    28 => x"72a4b00c",
    29 => x"0290050d",
    30 => x"0402ec05",
    31 => x"0d767884",
    32 => x"1208892a",
    33 => x"54555380",
    34 => x"55737227",
    35 => x"a9387208",
    36 => x"52737227",
    37 => x"8c387473",
    38 => x"0c8c1308",
    39 => x"88140c74",
    40 => x"5271742e",
    41 => x"8f387251",
    42 => x"9fd22d72",
    43 => x"08742e09",
    44 => x"8106f338",
    45 => x"815574a4",
    46 => x"b00c0294",
    47 => x"050d0402",
    48 => x"ec050d77",
    49 => x"7753a9d8",
    50 => x"52539d94",
    51 => x"2da4b008",
    52 => x"54a4b008",
    53 => x"8a3873a4",
    54 => x"b00c0294",
    55 => x"050d04a4",
    56 => x"9451839e",
    57 => x"2da9dc08",
    58 => x"83ff0589",
    59 => x"2a558054",
    60 => x"737525a2",
    61 => x"387252a9",
    62 => x"d851a08b",
    63 => x"2da4b008",
    64 => x"802e9d38",
    65 => x"a9d8519f",
    66 => x"d22d8480",
    67 => x"13811555",
    68 => x"53747424",
    69 => x"e038810b",
    70 => x"a4b00c02",
    71 => x"94050d04",
    72 => x"a4b008a4",
    73 => x"b00c0294",
    74 => x"050d0400",
    75 => x"00ffffff",
    76 => x"ff00ffff",
    77 => x"ffff00ff",
    78 => x"ffffff00",
    79 => x"434d4400",
    80 => x"57726974",
    81 => x"65206661",
    82 => x"696c6564",
    83 => x"0a000000",
    84 => x"53504900",
    85 => x"5344496e",
    86 => x"69742000",
    87 => x"50617274",
    88 => x"20000000",
    89 => x"3f200000",
    90 => x"52434150",
    91 => x"20000000",
    92 => x"46457272",
    93 => x"20000000",
    94 => x"52656164",
    95 => x"696e6720",
    96 => x"4d42520a",
    97 => x"00000000",
    98 => x"52656164",
    99 => x"206f6620",
   100 => x"4d425220",
   101 => x"6661696c",
   102 => x"65640a00",
   103 => x"4d425220",
   104 => x"73756363",
   105 => x"65737366",
   106 => x"756c6c79",
   107 => x"20726561",
   108 => x"640a0000",
   109 => x"46415431",
   110 => x"36202020",
   111 => x"00000000",
   112 => x"46415433",
   113 => x"32202020",
   114 => x"00000000",
   115 => x"4e6f2070",
   116 => x"61727469",
   117 => x"74696f6e",
   118 => x"20736967",
   119 => x"6e617475",
   120 => x"72652066",
   121 => x"6f756e64",
   122 => x"0a000000",
   123 => x"52656164",
   124 => x"20626f6f",
   125 => x"74207365",
   126 => x"63746f72",
   127 => x"2066726f",
   128 => x"6d206669",
   129 => x"72737420",
   130 => x"70617274",
   131 => x"6974696f",
   132 => x"6e0a0000",
   133 => x"4f70656e",
   134 => x"65642066",
   135 => x"696c652c",
   136 => x"206c6f61",
   137 => x"64696e67",
   138 => x"2e2e2e0a",
   139 => x"002e2e0a",
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

