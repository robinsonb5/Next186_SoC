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

entity Bootstrap_ROM1 is
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
end Bootstrap_ROM1;

architecture arch of Bootstrap_ROM1 is

type ram_type is array(natural range 0 to ((2**(maxAddrBitBRAM+1))/4)-1) of std_logic_vector(wordSize-1 downto 0);

shared variable ram : ram_type :=
(
     0 => x"0b0b0b0b",
     1 => x"8c0b0b0b",
     2 => x"0b81e004",
     3 => x"000b0b0b",
     4 => x"0b8c04ff",
     5 => x"0d800404",
     6 => x"00000017",
     7 => x"00000000",
     8 => x"0b0b0b9c",
     9 => x"c8080b0b",
    10 => x"0b9ccc08",
    11 => x"0b0b0b9c",
    12 => x"d0080b0b",
    13 => x"0b0b9808",
    14 => x"2d0b0b0b",
    15 => x"9cd00c0b",
    16 => x"0b0b9ccc",
    17 => x"0c0b0b0b",
    18 => x"9cc80c04",
    19 => x"00000000",
    20 => x"00000000",
    21 => x"00000000",
    22 => x"00000000",
    23 => x"00000000",
    24 => x"71fd0608",
    25 => x"72830609",
    26 => x"81058205",
    27 => x"832b2a83",
    28 => x"ffff0652",
    29 => x"0471fc06",
    30 => x"08728306",
    31 => x"09810583",
    32 => x"05101010",
    33 => x"2a81ff06",
    34 => x"520471fd",
    35 => x"060883ff",
    36 => x"ff738306",
    37 => x"09810582",
    38 => x"05832b2b",
    39 => x"09067383",
    40 => x"ffff0673",
    41 => x"83060981",
    42 => x"05820583",
    43 => x"2b0b2b07",
    44 => x"72fc060c",
    45 => x"51510471",
    46 => x"fc06080b",
    47 => x"0b0b99f0",
    48 => x"73830610",
    49 => x"10050806",
    50 => x"7381ff06",
    51 => x"73830609",
    52 => x"81058305",
    53 => x"1010102b",
    54 => x"0772fc06",
    55 => x"0c515104",
    56 => x"9cc870a1",
    57 => x"c4278b38",
    58 => x"80717084",
    59 => x"05530c81",
    60 => x"e2048c51",
    61 => x"8ef00402",
    62 => x"f8050d73",
    63 => x"52c00870",
    64 => x"882a7081",
    65 => x"06515151",
    66 => x"70802ef1",
    67 => x"3871c00c",
    68 => x"719cc80c",
    69 => x"0288050d",
    70 => x"0402f805",
    71 => x"0d7352c4",
    72 => x"0870882a",
    73 => x"70810651",
    74 => x"51517080",
    75 => x"2ef13871",
    76 => x"c40c719c",
    77 => x"c80c0288",
    78 => x"050d0402",
    79 => x"e8050d80",
    80 => x"78575575",
    81 => x"70840557",
    82 => x"08538054",
    83 => x"72982a73",
    84 => x"882b5452",
    85 => x"71802ea2",
    86 => x"38c00870",
    87 => x"882a7081",
    88 => x"06515151",
    89 => x"70802ef1",
    90 => x"3871c00c",
    91 => x"81158115",
    92 => x"55558374",
    93 => x"25d63871",
    94 => x"ca38749c",
    95 => x"c80c0298",
    96 => x"050d0402",
    97 => x"f4050dd4",
    98 => x"5281ff72",
    99 => x"0c710853",
   100 => x"81ff720c",
   101 => x"72882b83",
   102 => x"fe800672",
   103 => x"087081ff",
   104 => x"06515253",
   105 => x"81ff720c",
   106 => x"72710788",
   107 => x"2b720870",
   108 => x"81ff0651",
   109 => x"525381ff",
   110 => x"720c7271",
   111 => x"07882b72",
   112 => x"087081ff",
   113 => x"0672079c",
   114 => x"c80c5253",
   115 => x"028c050d",
   116 => x"0402f405",
   117 => x"0d747671",
   118 => x"81ff06d4",
   119 => x"0c53539c",
   120 => x"d8088538",
   121 => x"71892b52",
   122 => x"71982ad4",
   123 => x"0c71902a",
   124 => x"7081ff06",
   125 => x"d40c5171",
   126 => x"882a7081",
   127 => x"ff06d40c",
   128 => x"517181ff",
   129 => x"06d40c72",
   130 => x"902a7081",
   131 => x"ff06d40c",
   132 => x"51d40870",
   133 => x"81ff0651",
   134 => x"5182b8bf",
   135 => x"527081ff",
   136 => x"2e098106",
   137 => x"943881ff",
   138 => x"0bd40cd4",
   139 => x"087081ff",
   140 => x"06ff1454",
   141 => x"515171e5",
   142 => x"38709cc8",
   143 => x"0c028c05",
   144 => x"0d0402fc",
   145 => x"050d81c7",
   146 => x"5181ff0b",
   147 => x"d40cff11",
   148 => x"51708025",
   149 => x"f4380284",
   150 => x"050d0402",
   151 => x"f0050d84",
   152 => x"c22d819c",
   153 => x"9f538052",
   154 => x"87fc80f7",
   155 => x"5183d12d",
   156 => x"9cc80854",
   157 => x"9cc80881",
   158 => x"2e098106",
   159 => x"a33881ff",
   160 => x"0bd40c82",
   161 => x"0a52849c",
   162 => x"80e95183",
   163 => x"d12d9cc8",
   164 => x"088b3881",
   165 => x"ff0bd40c",
   166 => x"735385a6",
   167 => x"0484c22d",
   168 => x"ff135372",
   169 => x"c138729c",
   170 => x"c80c0290",
   171 => x"050d0402",
   172 => x"f4050d81",
   173 => x"ff0bd40c",
   174 => x"9a805182",
   175 => x"bb2d9353",
   176 => x"805287fc",
   177 => x"80c15183",
   178 => x"d12d9cc8",
   179 => x"088b3881",
   180 => x"ff0bd40c",
   181 => x"815385e2",
   182 => x"0484c22d",
   183 => x"ff135372",
   184 => x"df38729c",
   185 => x"c80c028c",
   186 => x"050d0402",
   187 => x"f0050d84",
   188 => x"c22d83aa",
   189 => x"52849c80",
   190 => x"c85183d1",
   191 => x"2d9cc808",
   192 => x"812e0981",
   193 => x"06923883",
   194 => x"832d9cc8",
   195 => x"0883ffff",
   196 => x"06537283",
   197 => x"aa2e9138",
   198 => x"85af2d86",
   199 => x"a3048154",
   200 => x"87880480",
   201 => x"54878804",
   202 => x"81ff0bd4",
   203 => x"0cb15384",
   204 => x"db2d9cc8",
   205 => x"08802e80",
   206 => x"c0388052",
   207 => x"87fc80fa",
   208 => x"5183d12d",
   209 => x"9cc808b1",
   210 => x"3881ff0b",
   211 => x"d40cd408",
   212 => x"5381ff0b",
   213 => x"d40c81ff",
   214 => x"0bd40c81",
   215 => x"ff0bd40c",
   216 => x"81ff0bd4",
   217 => x"0c72862a",
   218 => x"7081069c",
   219 => x"c8085651",
   220 => x"5372802e",
   221 => x"9338869e",
   222 => x"0472822e",
   223 => x"ffa538ff",
   224 => x"135372ff",
   225 => x"aa387254",
   226 => x"739cc80c",
   227 => x"0290050d",
   228 => x"04800b9c",
   229 => x"c80c0402",
   230 => x"ec050d76",
   231 => x"78535480",
   232 => x"5580dbc6",
   233 => x"df5381ff",
   234 => x"0bd40cd4",
   235 => x"087081ff",
   236 => x"06515170",
   237 => x"81fe2e09",
   238 => x"810680ce",
   239 => x"38800b9c",
   240 => x"fc0c8372",
   241 => x"259d3883",
   242 => x"832d9cc8",
   243 => x"08747084",
   244 => x"05560c9c",
   245 => x"fc089cc8",
   246 => x"08059cfc",
   247 => x"0cfc1252",
   248 => x"87c20480",
   249 => x"72259e38",
   250 => x"81ff0bd4",
   251 => x"0cff7470",
   252 => x"81055681",
   253 => x"b72d9cfc",
   254 => x"0881ff05",
   255 => x"9cfc0cff",
   256 => x"125287e3",
   257 => x"04815588",
   258 => x"9104ff13",
   259 => x"5372ff96",
   260 => x"3881ff0b",
   261 => x"d40c749c",
   262 => x"c80c0294",
   263 => x"050d0402",
   264 => x"e8050d80",
   265 => x"5287fc80",
   266 => x"c95183d1",
   267 => x"2d92529c",
   268 => x"e8518797",
   269 => x"2d9ce80b",
   270 => x"80f52d81",
   271 => x"c0065372",
   272 => x"80c02e09",
   273 => x"8106b038",
   274 => x"9cef0b80",
   275 => x"f52d9cf0",
   276 => x"0b80f52d",
   277 => x"71902b71",
   278 => x"882b079c",
   279 => x"f10b80f5",
   280 => x"2d7181ff",
   281 => x"fe800607",
   282 => x"70888029",
   283 => x"88800551",
   284 => x"51555755",
   285 => x"89e1049c",
   286 => x"f10b80f5",
   287 => x"2d701086",
   288 => x"069cf20b",
   289 => x"80f52d70",
   290 => x"872a7207",
   291 => x"9ced0b80",
   292 => x"f52d8f06",
   293 => x"9cee0b80",
   294 => x"f52d708a",
   295 => x"2b988006",
   296 => x"9cef0b80",
   297 => x"f52d7082",
   298 => x"2b72079c",
   299 => x"f00b80f5",
   300 => x"2d70862a",
   301 => x"72078218",
   302 => x"81782b81",
   303 => x"1381732b",
   304 => x"71295153",
   305 => x"58585252",
   306 => x"52525953",
   307 => x"54525855",
   308 => x"55848075",
   309 => x"258b3872",
   310 => x"1075812c",
   311 => x"565389d1",
   312 => x"04729cc8",
   313 => x"0c029805",
   314 => x"0d0402f4",
   315 => x"050d810b",
   316 => x"9cd80cd0",
   317 => x"08708f2a",
   318 => x"70810651",
   319 => x"515372f3",
   320 => x"3872d00c",
   321 => x"84c22d9a",
   322 => x"845182bb",
   323 => x"2dd00870",
   324 => x"8f2a7081",
   325 => x"06515153",
   326 => x"72f33881",
   327 => x"0bd00c87",
   328 => x"53805284",
   329 => x"d480c051",
   330 => x"83d12d9c",
   331 => x"c808812e",
   332 => x"94387282",
   333 => x"2e098106",
   334 => x"86388053",
   335 => x"8b8304ff",
   336 => x"135372dd",
   337 => x"3885eb2d",
   338 => x"9cc8089c",
   339 => x"d80c9cc8",
   340 => x"088b3881",
   341 => x"5287fc80",
   342 => x"d05183d1",
   343 => x"2d81ff0b",
   344 => x"d40c889f",
   345 => x"2d9cc808",
   346 => x"9cdc0cd0",
   347 => x"08708f2a",
   348 => x"70810651",
   349 => x"515372f3",
   350 => x"3872d00c",
   351 => x"81ff0bd4",
   352 => x"0c815372",
   353 => x"9cc80c02",
   354 => x"8c050d04",
   355 => x"02f0050d",
   356 => x"805481ff",
   357 => x"0bd40cd0",
   358 => x"08708f2a",
   359 => x"70810651",
   360 => x"515372f3",
   361 => x"3882810b",
   362 => x"d00c81ff",
   363 => x"0bd40c75",
   364 => x"5287fc80",
   365 => x"d15183d1",
   366 => x"2d9cc808",
   367 => x"9e388480",
   368 => x"52765187",
   369 => x"972d9cc8",
   370 => x"0854d008",
   371 => x"708f2a70",
   372 => x"81065151",
   373 => x"5372f338",
   374 => x"72d00c73",
   375 => x"9cc80c02",
   376 => x"90050d04",
   377 => x"02f4050d",
   378 => x"7470882a",
   379 => x"83fe8006",
   380 => x"7072982a",
   381 => x"0772882b",
   382 => x"87fc8080",
   383 => x"0673982b",
   384 => x"81f00a06",
   385 => x"71730707",
   386 => x"9cc80c56",
   387 => x"51535102",
   388 => x"8c050d04",
   389 => x"02f8050d",
   390 => x"028e0580",
   391 => x"f52d7488",
   392 => x"2b077083",
   393 => x"ffff069c",
   394 => x"c80c5102",
   395 => x"88050d04",
   396 => x"02f8050d",
   397 => x"7370902b",
   398 => x"71902a07",
   399 => x"9cc80c52",
   400 => x"0288050d",
   401 => x"0402e405",
   402 => x"0d7852a1",
   403 => x"90519692",
   404 => x"2d9cc808",
   405 => x"539cc808",
   406 => x"802e81f9",
   407 => x"38a19408",
   408 => x"83ff0589",
   409 => x"2a568057",
   410 => x"76762581",
   411 => x"f8389d8c",
   412 => x"52a19051",
   413 => x"98d72d9c",
   414 => x"c808802e",
   415 => x"81e03876",
   416 => x"818b389d",
   417 => x"8c0b80f5",
   418 => x"2d5372b1",
   419 => x"2e098106",
   420 => x"80f5389d",
   421 => x"8d0b80f5",
   422 => x"2d5372b8",
   423 => x"2e098106",
   424 => x"80e5389d",
   425 => x"8e0b80f5",
   426 => x"2d5372b6",
   427 => x"2e098106",
   428 => x"80d5389d",
   429 => x"8f0b80f5",
   430 => x"2d537280",
   431 => x"ca389cdc",
   432 => x"089a8852",
   433 => x"5382bb2d",
   434 => x"9cdb0b80",
   435 => x"f52d9d94",
   436 => x"0b81b72d",
   437 => x"729d8c0b",
   438 => x"840581b7",
   439 => x"2d72882c",
   440 => x"53729d8c",
   441 => x"0b850581",
   442 => x"b72d7288",
   443 => x"2c53729d",
   444 => x"8c0b8605",
   445 => x"81b72d72",
   446 => x"882c5372",
   447 => x"9d8c0b87",
   448 => x"0581b72d",
   449 => x"8e8d049a",
   450 => x"945182bb",
   451 => x"2d80549d",
   452 => x"8c1480f5",
   453 => x"2d518299",
   454 => x"2d800bff",
   455 => x"17545576",
   456 => x"732e0981",
   457 => x"06833881",
   458 => x"557383ff",
   459 => x"2e098106",
   460 => x"8a387480",
   461 => x"2e853880",
   462 => x"0bc80c81",
   463 => x"145483ff",
   464 => x"7425cc38",
   465 => x"81175776",
   466 => x"76259a38",
   467 => x"a1905198",
   468 => x"aa2d8cee",
   469 => x"049aa051",
   470 => x"82bb2d8e",
   471 => x"e7049cc8",
   472 => x"08538ee7",
   473 => x"04815372",
   474 => x"9cc80c02",
   475 => x"9c050d04",
   476 => x"02fc050d",
   477 => x"9ab45182",
   478 => x"bb2d89ea",
   479 => x"2d9cc808",
   480 => x"802ea338",
   481 => x"9acc5182",
   482 => x"bb2d8fee",
   483 => x"2d9ae451",
   484 => x"8cc52d9c",
   485 => x"c808802e",
   486 => x"87389af0",
   487 => x"518fa304",
   488 => x"9afc5182",
   489 => x"bb2d800b",
   490 => x"9cc80c02",
   491 => x"84050d04",
   492 => x"02e8050d",
   493 => x"77797b58",
   494 => x"55558053",
   495 => x"727625a3",
   496 => x"38747081",
   497 => x"055680f5",
   498 => x"2d747081",
   499 => x"055680f5",
   500 => x"2d525271",
   501 => x"712e8638",
   502 => x"81518fe5",
   503 => x"04811353",
   504 => x"8fbc0480",
   505 => x"51709cc8",
   506 => x"0c029805",
   507 => x"0d0402d8",
   508 => x"050d800b",
   509 => x"a1b00c9b",
   510 => x"905182bb",
   511 => x"2d9d8c52",
   512 => x"80518b8c",
   513 => x"2d9cc808",
   514 => x"549cc808",
   515 => x"8c389ba0",
   516 => x"5182bb2d",
   517 => x"7355959b",
   518 => x"049bb451",
   519 => x"82bb2d80",
   520 => x"56810b9d",
   521 => x"800c8853",
   522 => x"9bcc529d",
   523 => x"c2518fb0",
   524 => x"2d9cc808",
   525 => x"762e0981",
   526 => x"0687389c",
   527 => x"c8089d80",
   528 => x"0c88539b",
   529 => x"d8529dde",
   530 => x"518fb02d",
   531 => x"9cc80887",
   532 => x"389cc808",
   533 => x"9d800c9d",
   534 => x"8008802e",
   535 => x"80ff38a0",
   536 => x"d20b80f5",
   537 => x"2da0d30b",
   538 => x"80f52d71",
   539 => x"982b7190",
   540 => x"2b07a0d4",
   541 => x"0b80f52d",
   542 => x"70882b72",
   543 => x"07a0d50b",
   544 => x"80f52d71",
   545 => x"07a18a0b",
   546 => x"80f52da1",
   547 => x"8b0b80f5",
   548 => x"2d71882b",
   549 => x"07535f54",
   550 => x"525a5657",
   551 => x"557381ab",
   552 => x"aa2e0981",
   553 => x"068d3875",
   554 => x"518be42d",
   555 => x"9cc80856",
   556 => x"91c30473",
   557 => x"82d4d52e",
   558 => x"8a389be4",
   559 => x"5182bb2d",
   560 => x"92e7049d",
   561 => x"8c527551",
   562 => x"8b8c2d9c",
   563 => x"c808559c",
   564 => x"c808802e",
   565 => x"83c5389c",
   566 => x"845182bb",
   567 => x"2d88539b",
   568 => x"d8529dde",
   569 => x"518fb02d",
   570 => x"9cc80889",
   571 => x"38810ba1",
   572 => x"b00c928d",
   573 => x"0488539b",
   574 => x"cc529dc2",
   575 => x"518fb02d",
   576 => x"80559cc8",
   577 => x"08752e09",
   578 => x"8106838f",
   579 => x"38a18a0b",
   580 => x"80f52d54",
   581 => x"7380d52e",
   582 => x"09810680",
   583 => x"ca38a18b",
   584 => x"0b80f52d",
   585 => x"547381aa",
   586 => x"2e098106",
   587 => x"ba38800b",
   588 => x"9d8c0b80",
   589 => x"f52d5654",
   590 => x"7481e92e",
   591 => x"83388154",
   592 => x"7481eb2e",
   593 => x"8c388055",
   594 => x"73752e09",
   595 => x"810682cb",
   596 => x"389d970b",
   597 => x"80f52d55",
   598 => x"748d389d",
   599 => x"980b80f5",
   600 => x"2d547382",
   601 => x"2e863880",
   602 => x"55959b04",
   603 => x"9d990b80",
   604 => x"f52d70a1",
   605 => x"b80cff05",
   606 => x"a1ac0c9d",
   607 => x"9a0b80f5",
   608 => x"2d9d9b0b",
   609 => x"80f52d58",
   610 => x"76057782",
   611 => x"80290570",
   612 => x"a1a00c9d",
   613 => x"9c0b80f5",
   614 => x"2d70a19c",
   615 => x"0ca1b008",
   616 => x"59575876",
   617 => x"802e81a3",
   618 => x"3888539b",
   619 => x"d8529dde",
   620 => x"518fb02d",
   621 => x"9cc80881",
   622 => x"e238a1b8",
   623 => x"0870842b",
   624 => x"a18c0c70",
   625 => x"a1b40c9d",
   626 => x"b10b80f5",
   627 => x"2d9db00b",
   628 => x"80f52d71",
   629 => x"82802905",
   630 => x"9db20b80",
   631 => x"f52d7084",
   632 => x"80802912",
   633 => x"9db30b80",
   634 => x"f52d7081",
   635 => x"800a2912",
   636 => x"709d840c",
   637 => x"a19c0871",
   638 => x"29a1a008",
   639 => x"0570a1c0",
   640 => x"0c9db90b",
   641 => x"80f52d9d",
   642 => x"b80b80f5",
   643 => x"2d718280",
   644 => x"29059dba",
   645 => x"0b80f52d",
   646 => x"70848080",
   647 => x"29129dbb",
   648 => x"0b80f52d",
   649 => x"70982b81",
   650 => x"f00a0672",
   651 => x"05709d88",
   652 => x"0cfe117e",
   653 => x"297705a1",
   654 => x"a80c5259",
   655 => x"5243545e",
   656 => x"51525952",
   657 => x"5d575957",
   658 => x"9599049d",
   659 => x"9e0b80f5",
   660 => x"2d9d9d0b",
   661 => x"80f52d71",
   662 => x"82802905",
   663 => x"70a18c0c",
   664 => x"70a02983",
   665 => x"ff057089",
   666 => x"2a70a1b4",
   667 => x"0c9da30b",
   668 => x"80f52d9d",
   669 => x"a20b80f5",
   670 => x"2d718280",
   671 => x"2905709d",
   672 => x"840c7b71",
   673 => x"291e70a1",
   674 => x"a80c7d9d",
   675 => x"880c7305",
   676 => x"a1c00c55",
   677 => x"5e515155",
   678 => x"55815574",
   679 => x"9cc80c02",
   680 => x"a8050d04",
   681 => x"02ec050d",
   682 => x"7670872c",
   683 => x"7180ff06",
   684 => x"555654a1",
   685 => x"b0088a38",
   686 => x"73882c74",
   687 => x"81ff0654",
   688 => x"559d8c52",
   689 => x"a1a00815",
   690 => x"518b8c2d",
   691 => x"9cc80854",
   692 => x"9cc80880",
   693 => x"2eb338a1",
   694 => x"b008802e",
   695 => x"98387284",
   696 => x"299d8c05",
   697 => x"70085253",
   698 => x"8be42d9c",
   699 => x"c808f00a",
   700 => x"06539687",
   701 => x"0472109d",
   702 => x"8c057080",
   703 => x"e02d5253",
   704 => x"8c942d9c",
   705 => x"c8085372",
   706 => x"54739cc8",
   707 => x"0c029405",
   708 => x"0d0402c8",
   709 => x"050d7f61",
   710 => x"5f5b800b",
   711 => x"9d8808a1",
   712 => x"a808595d",
   713 => x"56a1b008",
   714 => x"762e8a38",
   715 => x"a1b80884",
   716 => x"2b5896bb",
   717 => x"04a1b408",
   718 => x"842b5880",
   719 => x"59787827",
   720 => x"81a93878",
   721 => x"8f06a017",
   722 => x"5754738f",
   723 => x"389d8c52",
   724 => x"76518117",
   725 => x"578b8c2d",
   726 => x"9d8c5680",
   727 => x"7680f52d",
   728 => x"56547474",
   729 => x"2e833881",
   730 => x"547481e5",
   731 => x"2e80f638",
   732 => x"81707506",
   733 => x"555d7380",
   734 => x"2e80ea38",
   735 => x"8b1680f5",
   736 => x"2d98065a",
   737 => x"7980de38",
   738 => x"8b537d52",
   739 => x"75518fb0",
   740 => x"2d9cc808",
   741 => x"80cf389c",
   742 => x"1608518b",
   743 => x"e42d9cc8",
   744 => x"08841c0c",
   745 => x"9a1680e0",
   746 => x"2d518c94",
   747 => x"2d9cc808",
   748 => x"9cc80888",
   749 => x"1d0c9cc8",
   750 => x"085555a1",
   751 => x"b008802e",
   752 => x"98389416",
   753 => x"80e02d51",
   754 => x"8c942d9c",
   755 => x"c808902b",
   756 => x"83fff00a",
   757 => x"06701651",
   758 => x"5473881c",
   759 => x"0c797b0c",
   760 => x"7c5498a1",
   761 => x"04811959",
   762 => x"96bd04a1",
   763 => x"b008802e",
   764 => x"ae387b51",
   765 => x"95a42d9c",
   766 => x"c8089cc8",
   767 => x"0880ffff",
   768 => x"fff80655",
   769 => x"5c7380ff",
   770 => x"fffff82e",
   771 => x"92389cc8",
   772 => x"08fe05a1",
   773 => x"b80829a1",
   774 => x"c0080557",
   775 => x"96bb0480",
   776 => x"54739cc8",
   777 => x"0c02b805",
   778 => x"0d0402f4",
   779 => x"050d7470",
   780 => x"08810571",
   781 => x"0c7008a1",
   782 => x"ac080653",
   783 => x"53718e38",
   784 => x"88130851",
   785 => x"95a42d9c",
   786 => x"c8088814",
   787 => x"0c810b9c",
   788 => x"c80c028c",
   789 => x"050d0402",
   790 => x"f0050d75",
   791 => x"881108fe",
   792 => x"05a1b808",
   793 => x"29a1c008",
   794 => x"117208a1",
   795 => x"ac080605",
   796 => x"79555354",
   797 => x"548b8c2d",
   798 => x"9cc80853",
   799 => x"9cc80880",
   800 => x"2e833881",
   801 => x"53729cc8",
   802 => x"0c029005",
   803 => x"0d0402ec",
   804 => x"050d7777",
   805 => x"53a19052",
   806 => x"5396922d",
   807 => x"9cc80854",
   808 => x"9cc80880",
   809 => x"2ebf389c",
   810 => x"ac5182bb",
   811 => x"2da19408",
   812 => x"83ff0589",
   813 => x"2a558054",
   814 => x"737525a7",
   815 => x"387252a1",
   816 => x"905198d7",
   817 => x"2d9cc808",
   818 => x"802e9138",
   819 => x"a1905198",
   820 => x"aa2d8480",
   821 => x"13811555",
   822 => x"5399b804",
   823 => x"9cc80854",
   824 => x"99e50481",
   825 => x"54739cc8",
   826 => x"0c029405",
   827 => x"0d040000",
   828 => x"00ffffff",
   829 => x"ff00ffff",
   830 => x"ffff00ff",
   831 => x"ffffff00",
   832 => x"434d4400",
   833 => x"53504900",
   834 => x"466f756e",
   835 => x"64207461",
   836 => x"670a0000",
   837 => x"4e6f2074",
   838 => x"6167210a",
   839 => x"00000000",
   840 => x"43616e27",
   841 => x"74206f70",
   842 => x"656e2066",
   843 => x"696c650a",
   844 => x"00000000",
   845 => x"496e6974",
   846 => x"69616c69",
   847 => x"7a696e67",
   848 => x"20534420",
   849 => x"63617264",
   850 => x"0a000000",
   851 => x"48756e74",
   852 => x"696e6720",
   853 => x"666f7220",
   854 => x"70617274",
   855 => x"6974696f",
   856 => x"6e0a0000",
   857 => x"42494f53",
   858 => x"4e455854",
   859 => x"31383600",
   860 => x"42494f53",
   861 => x"2053656e",
   862 => x"740a0000",
   863 => x"42494f53",
   864 => x"204c6f61",
   865 => x"64206661",
   866 => x"696c6564",
   867 => x"0a000000",
   868 => x"52656164",
   869 => x"696e6720",
   870 => x"4d42520a",
   871 => x"00000000",
   872 => x"52656164",
   873 => x"206f6620",
   874 => x"4d425220",
   875 => x"6661696c",
   876 => x"65640a00",
   877 => x"4d425220",
   878 => x"73756363",
   879 => x"65737366",
   880 => x"756c6c79",
   881 => x"20726561",
   882 => x"640a0000",
   883 => x"46415431",
   884 => x"36202020",
   885 => x"00000000",
   886 => x"46415433",
   887 => x"32202020",
   888 => x"00000000",
   889 => x"4e6f2070",
   890 => x"61727469",
   891 => x"74696f6e",
   892 => x"20736967",
   893 => x"6e617475",
   894 => x"72652066",
   895 => x"6f756e64",
   896 => x"0a000000",
   897 => x"52656164",
   898 => x"20626f6f",
   899 => x"74207365",
   900 => x"63746f72",
   901 => x"2066726f",
   902 => x"6d206669",
   903 => x"72737420",
   904 => x"70617274",
   905 => x"6974696f",
   906 => x"6e0a0000",
   907 => x"4f70656e",
   908 => x"65642066",
   909 => x"696c652c",
   910 => x"206c6f61",
   911 => x"64696e67",
   912 => x"2e2e2e0a",
   913 => x"002e2e0a",
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

