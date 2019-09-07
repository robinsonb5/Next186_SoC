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
     8 => x"0b0b0ba4",
     9 => x"dc080b0b",
    10 => x"0ba4e008",
    11 => x"0b0b0ba4",
    12 => x"e4080b0b",
    13 => x"0b0b9808",
    14 => x"2d0b0b0b",
    15 => x"a4e40c0b",
    16 => x"0b0ba4e0",
    17 => x"0c0b0b0b",
    18 => x"a4dc0c04",
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
    47 => x"0b0ba2a8",
    48 => x"73830610",
    49 => x"10050806",
    50 => x"7381ff06",
    51 => x"73830609",
    52 => x"81058305",
    53 => x"1010102b",
    54 => x"0772fc06",
    55 => x"0c515104",
    56 => x"a4dc70aa",
    57 => x"b0278b38",
    58 => x"80717084",
    59 => x"05530c81",
    60 => x"e2048c51",
    61 => x"8fd00402",
    62 => x"ec050d76",
    63 => x"53805572",
    64 => x"752e80c7",
    65 => x"38875472",
    66 => x"9c2a7384",
    67 => x"2b545271",
    68 => x"802e8338",
    69 => x"81558972",
    70 => x"259938b7",
    71 => x"1252749b",
    72 => x"38ff1454",
    73 => x"738025df",
    74 => x"38800ba4",
    75 => x"dc0c0294",
    76 => x"050d04b0",
    77 => x"12527480",
    78 => x"2ee73871",
    79 => x"5182da2d",
    80 => x"ff145473",
    81 => x"8025c038",
    82 => x"82a904b0",
    83 => x"5182da2d",
    84 => x"800ba4dc",
    85 => x"0c029405",
    86 => x"0d0402f8",
    87 => x"050d7352",
    88 => x"c0087088",
    89 => x"2a708106",
    90 => x"51515170",
    91 => x"802ef138",
    92 => x"71c00c71",
    93 => x"a4dc0c02",
    94 => x"88050d04",
    95 => x"02f8050d",
    96 => x"7352c408",
    97 => x"70882a70",
    98 => x"81065151",
    99 => x"5170802e",
   100 => x"f13871c4",
   101 => x"0c71a4dc",
   102 => x"0c028805",
   103 => x"0d0402e8",
   104 => x"050d8078",
   105 => x"57557570",
   106 => x"84055708",
   107 => x"53805472",
   108 => x"982a7388",
   109 => x"2b545271",
   110 => x"802ea238",
   111 => x"c0087088",
   112 => x"2a708106",
   113 => x"51515170",
   114 => x"802ef138",
   115 => x"71c00c81",
   116 => x"15811555",
   117 => x"55837425",
   118 => x"d63871ca",
   119 => x"3874a4dc",
   120 => x"0c029805",
   121 => x"0d0402f4",
   122 => x"050dd452",
   123 => x"81ff720c",
   124 => x"71085381",
   125 => x"ff720c72",
   126 => x"882b83fe",
   127 => x"80067208",
   128 => x"7081ff06",
   129 => x"51525381",
   130 => x"ff720c72",
   131 => x"7107882b",
   132 => x"72087081",
   133 => x"ff065152",
   134 => x"5381ff72",
   135 => x"0c727107",
   136 => x"882b7208",
   137 => x"7081ff06",
   138 => x"7207a4dc",
   139 => x"0c525302",
   140 => x"8c050d04",
   141 => x"02f4050d",
   142 => x"74767181",
   143 => x"ff06d40c",
   144 => x"5353a5c0",
   145 => x"08853871",
   146 => x"892b5271",
   147 => x"982ad40c",
   148 => x"71902a70",
   149 => x"81ff06d4",
   150 => x"0c517188",
   151 => x"2a7081ff",
   152 => x"06d40c51",
   153 => x"7181ff06",
   154 => x"d40c7290",
   155 => x"2a7081ff",
   156 => x"06d40c51",
   157 => x"d4087081",
   158 => x"ff065151",
   159 => x"82b8bf52",
   160 => x"7081ff2e",
   161 => x"09810694",
   162 => x"3881ff0b",
   163 => x"d40cd408",
   164 => x"7081ff06",
   165 => x"ff145451",
   166 => x"5171e538",
   167 => x"70a4dc0c",
   168 => x"028c050d",
   169 => x"0402fc05",
   170 => x"0d81c751",
   171 => x"81ff0bd4",
   172 => x"0cff1151",
   173 => x"708025f4",
   174 => x"38028405",
   175 => x"0d0402f0",
   176 => x"050d85a5",
   177 => x"2d819c9f",
   178 => x"53805287",
   179 => x"fc80f751",
   180 => x"84b42da4",
   181 => x"dc0854a4",
   182 => x"dc08812e",
   183 => x"9038ff13",
   184 => x"5372e638",
   185 => x"72a4dc0c",
   186 => x"0290050d",
   187 => x"0481ff0b",
   188 => x"d40c820a",
   189 => x"52849c80",
   190 => x"e95184b4",
   191 => x"2da4dc08",
   192 => x"802e8e38",
   193 => x"85a52dff",
   194 => x"135372ff",
   195 => x"bc3885e4",
   196 => x"0481ff0b",
   197 => x"d40c73a4",
   198 => x"dc0c0290",
   199 => x"050d0402",
   200 => x"f4050d81",
   201 => x"ff0bd40c",
   202 => x"a2b85183",
   203 => x"9e2d9353",
   204 => x"805287fc",
   205 => x"80c15184",
   206 => x"b42da4dc",
   207 => x"08802e93",
   208 => x"3885a52d",
   209 => x"ff135372",
   210 => x"e73872a4",
   211 => x"dc0c028c",
   212 => x"050d0481",
   213 => x"ff0bd40c",
   214 => x"810ba4dc",
   215 => x"0c028c05",
   216 => x"0d0402f0",
   217 => x"050d85a5",
   218 => x"2d83aa52",
   219 => x"849c80c8",
   220 => x"5184b42d",
   221 => x"a4dc0881",
   222 => x"2e8f3886",
   223 => x"9f2d8054",
   224 => x"73a4dc0c",
   225 => x"0290050d",
   226 => x"0483e62d",
   227 => x"a4dc0883",
   228 => x"ffff0653",
   229 => x"7283aa2e",
   230 => x"098106df",
   231 => x"3881ff0b",
   232 => x"d40cb153",
   233 => x"85be2da4",
   234 => x"dc089538",
   235 => x"72822ece",
   236 => x"38ff1353",
   237 => x"72ee3872",
   238 => x"a4dc0c02",
   239 => x"90050d04",
   240 => x"805287fc",
   241 => x"80fa5184",
   242 => x"b42da4dc",
   243 => x"08de3881",
   244 => x"ff0bd40c",
   245 => x"d4085381",
   246 => x"ff0bd40c",
   247 => x"81ff0bd4",
   248 => x"0c81ff0b",
   249 => x"d40c81ff",
   250 => x"0bd40c72",
   251 => x"862a7081",
   252 => x"06a4dc08",
   253 => x"56515372",
   254 => x"802eff84",
   255 => x"38810ba4",
   256 => x"dc0c0290",
   257 => x"050d0402",
   258 => x"e8050d78",
   259 => x"5681ff0b",
   260 => x"d40cd008",
   261 => x"708f2a70",
   262 => x"81065151",
   263 => x"5372f338",
   264 => x"82810bd0",
   265 => x"0c81ff0b",
   266 => x"d40c7752",
   267 => x"87fc80d8",
   268 => x"5184b42d",
   269 => x"a4dc0881",
   270 => x"823881ff",
   271 => x"0bd40c81",
   272 => x"fe0bd40c",
   273 => x"80ff5575",
   274 => x"70840557",
   275 => x"0870982a",
   276 => x"d40c7090",
   277 => x"2c7081ff",
   278 => x"06d40c54",
   279 => x"70882c70",
   280 => x"81ff06d4",
   281 => x"0c547081",
   282 => x"ff06d40c",
   283 => x"54ff1555",
   284 => x"748025d3",
   285 => x"3881ff0b",
   286 => x"d40c81ff",
   287 => x"0bd40c81",
   288 => x"ff0bd40c",
   289 => x"868da054",
   290 => x"81ff0bd4",
   291 => x"0cd40881",
   292 => x"ff065574",
   293 => x"8738ff14",
   294 => x"5473ed38",
   295 => x"81ff0bd4",
   296 => x"0cd00870",
   297 => x"8f2a7081",
   298 => x"06515153",
   299 => x"72f33872",
   300 => x"d00c72a4",
   301 => x"dc0c0298",
   302 => x"050d04a2",
   303 => x"bc51839e",
   304 => x"2d810ba4",
   305 => x"dc0c0298",
   306 => x"050d0402",
   307 => x"ec050d76",
   308 => x"78545480",
   309 => x"5580dbc6",
   310 => x"df5281ff",
   311 => x"0bd40cd4",
   312 => x"087081ff",
   313 => x"06515170",
   314 => x"81fe2e95",
   315 => x"38ff1252",
   316 => x"71e83881",
   317 => x"ff0bd40c",
   318 => x"74a4dc0c",
   319 => x"0294050d",
   320 => x"04800ba5",
   321 => x"e40c8373",
   322 => x"259f3883",
   323 => x"e62da4dc",
   324 => x"08747084",
   325 => x"05560ca5",
   326 => x"e408a4dc",
   327 => x"0805a5e4",
   328 => x"0cfc1353",
   329 => x"728324e3",
   330 => x"38807325",
   331 => x"a03881ff",
   332 => x"0bd40cff",
   333 => x"74708105",
   334 => x"5681b72d",
   335 => x"a5e40881",
   336 => x"ff05a5e4",
   337 => x"0cff1353",
   338 => x"728024e2",
   339 => x"38815581",
   340 => x"ff0bd40c",
   341 => x"74a4dc0c",
   342 => x"0294050d",
   343 => x"0402e805",
   344 => x"0d805287",
   345 => x"fc80c951",
   346 => x"84b42d92",
   347 => x"52a5d051",
   348 => x"89cb2da5",
   349 => x"d00b80f5",
   350 => x"2d81c006",
   351 => x"537280c0",
   352 => x"2e80f738",
   353 => x"a5d90b80",
   354 => x"f52d7010",
   355 => x"8606a5da",
   356 => x"0b80f52d",
   357 => x"70872a72",
   358 => x"07a5d50b",
   359 => x"80f52d8f",
   360 => x"06a5d60b",
   361 => x"80f52d70",
   362 => x"8a2b9880",
   363 => x"06a5d70b",
   364 => x"80f52d70",
   365 => x"822b7207",
   366 => x"a5d80b80",
   367 => x"f52d7086",
   368 => x"2a720782",
   369 => x"1881782b",
   370 => x"81138173",
   371 => x"2b712951",
   372 => x"53585852",
   373 => x"52525259",
   374 => x"53545258",
   375 => x"55558480",
   376 => x"75258e38",
   377 => x"72107581",
   378 => x"2c565374",
   379 => x"848024f4",
   380 => x"3872a4dc",
   381 => x"0c029805",
   382 => x"0d04a5d7",
   383 => x"0b80f52d",
   384 => x"a5d80b80",
   385 => x"f52d7190",
   386 => x"2b71882b",
   387 => x"07a5d90b",
   388 => x"80f52d71",
   389 => x"81fffe80",
   390 => x"06077088",
   391 => x"80298880",
   392 => x"05a4dc0c",
   393 => x"51555755",
   394 => x"0298050d",
   395 => x"0402f405",
   396 => x"0d810ba5",
   397 => x"c00cd008",
   398 => x"708f2a70",
   399 => x"81065151",
   400 => x"5372f338",
   401 => x"72d00c85",
   402 => x"a52da2cc",
   403 => x"51839e2d",
   404 => x"d008708f",
   405 => x"2a708106",
   406 => x"51515372",
   407 => x"f338810b",
   408 => x"d00c8753",
   409 => x"805284d4",
   410 => x"80c05184",
   411 => x"b42da4dc",
   412 => x"08812e8d",
   413 => x"3872822e",
   414 => x"80c538ff",
   415 => x"135372e4",
   416 => x"3886e22d",
   417 => x"a4dc08a5",
   418 => x"c00ca4dc",
   419 => x"08802eb9",
   420 => x"3881ff0b",
   421 => x"d40c8add",
   422 => x"2da4dc08",
   423 => x"a5c40cd0",
   424 => x"08708f2a",
   425 => x"70810651",
   426 => x"515372f3",
   427 => x"3872d00c",
   428 => x"81ff0bd4",
   429 => x"0c810ba4",
   430 => x"dc0c028c",
   431 => x"050d0480",
   432 => x"0ba4dc0c",
   433 => x"028c050d",
   434 => x"04815287",
   435 => x"fc80d051",
   436 => x"84b42d81",
   437 => x"ff0bd40c",
   438 => x"8add2da4",
   439 => x"dc08a5c4",
   440 => x"0c8d9f04",
   441 => x"02f0050d",
   442 => x"805481ff",
   443 => x"0bd40cd0",
   444 => x"08708f2a",
   445 => x"70810651",
   446 => x"515372f3",
   447 => x"3882810b",
   448 => x"d00c81ff",
   449 => x"0bd40c75",
   450 => x"5287fc80",
   451 => x"d15184b4",
   452 => x"2da4dc08",
   453 => x"802e8a38",
   454 => x"73a4dc0c",
   455 => x"0290050d",
   456 => x"04848052",
   457 => x"765189cb",
   458 => x"2da4dc08",
   459 => x"54d00870",
   460 => x"8f2a7081",
   461 => x"06515153",
   462 => x"72f33872",
   463 => x"d00c73a4",
   464 => x"dc0c0290",
   465 => x"050d0402",
   466 => x"f4050d74",
   467 => x"70882a83",
   468 => x"fe800670",
   469 => x"72982a07",
   470 => x"72882b87",
   471 => x"fc808006",
   472 => x"73982b81",
   473 => x"f00a0671",
   474 => x"730707a4",
   475 => x"dc0c5651",
   476 => x"5351028c",
   477 => x"050d0402",
   478 => x"f8050d02",
   479 => x"8e0580f5",
   480 => x"2d74882b",
   481 => x"077083ff",
   482 => x"ff06a4dc",
   483 => x"0c510288",
   484 => x"050d0402",
   485 => x"f8050d73",
   486 => x"70902b71",
   487 => x"902a07a4",
   488 => x"dc0c5202",
   489 => x"88050d04",
   490 => x"02f4050d",
   491 => x"a5bc0853",
   492 => x"cc087082",
   493 => x"80065252",
   494 => x"70732ef4",
   495 => x"38728280",
   496 => x"32a5bc0c",
   497 => x"71fdff06",
   498 => x"a4dc0c02",
   499 => x"8c050d04",
   500 => x"02d8050d",
   501 => x"800ba5bc",
   502 => x"0ca2d051",
   503 => x"839e2d8c",
   504 => x"ad2d8054",
   505 => x"a4dc0874",
   506 => x"2e098106",
   507 => x"8a3873a4",
   508 => x"dc0c02a8",
   509 => x"050d04a2",
   510 => x"d851839e",
   511 => x"2d97962d",
   512 => x"8fa82da4",
   513 => x"dc085aa4",
   514 => x"dc088183",
   515 => x"2ebd38a4",
   516 => x"dc088183",
   517 => x"24828b38",
   518 => x"a4dc0881",
   519 => x"812e82be",
   520 => x"38a4dc08",
   521 => x"81812483",
   522 => x"da38a4dc",
   523 => x"0881802e",
   524 => x"81e538a2",
   525 => x"e051839e",
   526 => x"2d8fa82d",
   527 => x"a4dc085a",
   528 => x"a4dc0881",
   529 => x"832e0981",
   530 => x"06c538a5",
   531 => x"bc08cc0c",
   532 => x"8fa82da4",
   533 => x"dc08982b",
   534 => x"a5bc08cc",
   535 => x"0c588fa8",
   536 => x"2da4dc08",
   537 => x"902b7807",
   538 => x"a5bc08cc",
   539 => x"0c588fa8",
   540 => x"2da4dc08",
   541 => x"882b7807",
   542 => x"a5bc08cc",
   543 => x"0c588fa8",
   544 => x"2d77a4dc",
   545 => x"0807a5bc",
   546 => x"08cc0c58",
   547 => x"8fa82da4",
   548 => x"dc08ff05",
   549 => x"5978ff2e",
   550 => x"80f538a5",
   551 => x"f4577981",
   552 => x"852e84ef",
   553 => x"38765277",
   554 => x"51811858",
   555 => x"8de42d80",
   556 => x"ff567670",
   557 => x"84055808",
   558 => x"70982aa5",
   559 => x"bc0807cc",
   560 => x"0c558fa8",
   561 => x"2d74902a",
   562 => x"7081ff06",
   563 => x"70a5bc08",
   564 => x"07cc0c51",
   565 => x"548fa82d",
   566 => x"74882a70",
   567 => x"81ff0670",
   568 => x"a5bc0807",
   569 => x"cc0c5154",
   570 => x"8fa82d74",
   571 => x"81ff0670",
   572 => x"a5bc0807",
   573 => x"cc0c558f",
   574 => x"a82dff16",
   575 => x"56758025",
   576 => x"ffb038ff",
   577 => x"195978ff",
   578 => x"2e098106",
   579 => x"ff8d38a5",
   580 => x"bc08cc0c",
   581 => x"908004a5",
   582 => x"bc088180",
   583 => x"07cc0c90",
   584 => x"8004a4dc",
   585 => x"0881852e",
   586 => x"fea13881",
   587 => x"850ba4dc",
   588 => x"0824829a",
   589 => x"38a4dc08",
   590 => x"81fe2e09",
   591 => x"8106fdf3",
   592 => x"38a5bc08",
   593 => x"81fe07cc",
   594 => x"0c8fa82d",
   595 => x"a4dc0851",
   596 => x"82da2da5",
   597 => x"bc0881fe",
   598 => x"07cc0c90",
   599 => x"8004a2e8",
   600 => x"51839e2d",
   601 => x"a2f052a9",
   602 => x"f8519dc5",
   603 => x"2da4dc08",
   604 => x"54a4dc08",
   605 => x"802e83c8",
   606 => x"38a9fc08",
   607 => x"83ff0589",
   608 => x"2a578055",
   609 => x"747725fc",
   610 => x"f738a5f4",
   611 => x"52a9f851",
   612 => x"a0bc2da4",
   613 => x"dc08802e",
   614 => x"80cb38a2",
   615 => x"fc51839e",
   616 => x"2d8056a5",
   617 => x"f41680f5",
   618 => x"2da5bc08",
   619 => x"07cc0c8f",
   620 => x"a82da5bc",
   621 => x"08802eb8",
   622 => x"38ad5182",
   623 => x"da2d8116",
   624 => x"5683ff76",
   625 => x"25dd3881",
   626 => x"15557477",
   627 => x"25fcb138",
   628 => x"a9f851a0",
   629 => x"832da5f4",
   630 => x"52a9f851",
   631 => x"a0bc2da4",
   632 => x"dc08ffb7",
   633 => x"38a4dc08",
   634 => x"a4dc0c02",
   635 => x"a8050d04",
   636 => x"80df5182",
   637 => x"da2d8116",
   638 => x"5683ff76",
   639 => x"25ffa438",
   640 => x"93c704a3",
   641 => x"8051839e",
   642 => x"2da38852",
   643 => x"a9f8519d",
   644 => x"c52da5c4",
   645 => x"0b80f52d",
   646 => x"a5bc0807",
   647 => x"cc0c8fa8",
   648 => x"2da5c50b",
   649 => x"80f52da5",
   650 => x"bc0807cc",
   651 => x"0c8fa82d",
   652 => x"a5c60b80",
   653 => x"f52da5bc",
   654 => x"0807cc0c",
   655 => x"8fa82da5",
   656 => x"c70b80f5",
   657 => x"2da5bc08",
   658 => x"07cc0c90",
   659 => x"8004a5bc",
   660 => x"08cc0c8f",
   661 => x"a82da4dc",
   662 => x"08982ba5",
   663 => x"bc08cc0c",
   664 => x"588fa82d",
   665 => x"a4dc0890",
   666 => x"2b7807a5",
   667 => x"bc08cc0c",
   668 => x"588fa82d",
   669 => x"a4dc0888",
   670 => x"2b7807a5",
   671 => x"bc08cc0c",
   672 => x"588fa82d",
   673 => x"77a4dc08",
   674 => x"07a5bc08",
   675 => x"cc0c588f",
   676 => x"a82da4dc",
   677 => x"08599053",
   678 => x"80527751",
   679 => x"81f72dff",
   680 => x"195978ff",
   681 => x"2efce838",
   682 => x"a5f40ba3",
   683 => x"94525583",
   684 => x"9e2d80ff",
   685 => x"56a5bc08",
   686 => x"cc0c8fa8",
   687 => x"2da5bc08",
   688 => x"cc0ca4dc",
   689 => x"08882b54",
   690 => x"8fa82da5",
   691 => x"bc08cc0c",
   692 => x"73a4dc08",
   693 => x"07882b54",
   694 => x"8fa82da5",
   695 => x"bc08cc0c",
   696 => x"73a4dc08",
   697 => x"07882b54",
   698 => x"8fa82d73",
   699 => x"a4dc0807",
   700 => x"75708405",
   701 => x"570cff16",
   702 => x"56758025",
   703 => x"ffb738a3",
   704 => x"9451839e",
   705 => x"2da5f452",
   706 => x"77518118",
   707 => x"5888872d",
   708 => x"959f04a3",
   709 => x"9851839e",
   710 => x"2d905380",
   711 => x"52775181",
   712 => x"f72da051",
   713 => x"82da2d77",
   714 => x"528118a9",
   715 => x"f85258a0",
   716 => x"f32d7652",
   717 => x"a9f851a0",
   718 => x"bc2d80ff",
   719 => x"5691b204",
   720 => x"a39c5183",
   721 => x"9e2d73a4",
   722 => x"dc0c02a8",
   723 => x"050d0402",
   724 => x"e8050d77",
   725 => x"797b5855",
   726 => x"55805372",
   727 => x"7625a338",
   728 => x"74708105",
   729 => x"5680f52d",
   730 => x"74708105",
   731 => x"5680f52d",
   732 => x"52527171",
   733 => x"2e098106",
   734 => x"93388113",
   735 => x"53757324",
   736 => x"df38800b",
   737 => x"a4dc0c02",
   738 => x"98050d04",
   739 => x"810ba4dc",
   740 => x"0c029805",
   741 => x"0d0402d8",
   742 => x"050d800b",
   743 => x"aa9c0ca3",
   744 => x"a451839e",
   745 => x"2da5f452",
   746 => x"80518de4",
   747 => x"2da4dc08",
   748 => x"54a4dc08",
   749 => x"9238a3b4",
   750 => x"51839e2d",
   751 => x"735675a4",
   752 => x"dc0c02a8",
   753 => x"050d04a3",
   754 => x"c851839e",
   755 => x"2d805581",
   756 => x"0ba5e80c",
   757 => x"8853a3e0",
   758 => x"52a6aa51",
   759 => x"96cf2da4",
   760 => x"dc08752e",
   761 => x"80fb3888",
   762 => x"53a3ec52",
   763 => x"a6c65196",
   764 => x"cf2da4dc",
   765 => x"088738a4",
   766 => x"dc08a5e8",
   767 => x"0ca5e808",
   768 => x"802e8189",
   769 => x"38a9ba0b",
   770 => x"80f52da9",
   771 => x"bb0b80f5",
   772 => x"2d71982b",
   773 => x"71902b07",
   774 => x"a9bc0b80",
   775 => x"f52d7088",
   776 => x"2b7207a9",
   777 => x"bd0b80f5",
   778 => x"2d7107a9",
   779 => x"f20b80f5",
   780 => x"2da9f30b",
   781 => x"80f52d71",
   782 => x"882b0753",
   783 => x"4055525a",
   784 => x"56575573",
   785 => x"81abaa2e",
   786 => x"a1387382",
   787 => x"d4d52ea3",
   788 => x"38a3f851",
   789 => x"839e2d80",
   790 => x"0ba4dc0c",
   791 => x"02a8050d",
   792 => x"04a4dc08",
   793 => x"a5e80c97",
   794 => x"e7047451",
   795 => x"8ec72da4",
   796 => x"dc0855a5",
   797 => x"f4527451",
   798 => x"8de42da4",
   799 => x"dc0856a4",
   800 => x"dc08802e",
   801 => x"feb838a4",
   802 => x"9851839e",
   803 => x"2d8853a3",
   804 => x"ec52a6c6",
   805 => x"5196cf2d",
   806 => x"a4dc0881",
   807 => x"fa38810b",
   808 => x"aa9c0ca9",
   809 => x"f20b80f5",
   810 => x"2d547380",
   811 => x"d52e0981",
   812 => x"06ffa438",
   813 => x"a9f30b80",
   814 => x"f52d5473",
   815 => x"81aa2e09",
   816 => x"8106ff93",
   817 => x"38800ba5",
   818 => x"f40b80f5",
   819 => x"2d575475",
   820 => x"81e92e83",
   821 => x"38815475",
   822 => x"81eb2e8c",
   823 => x"38805673",
   824 => x"762e0981",
   825 => x"06fdd738",
   826 => x"a5ff0b80",
   827 => x"f52d5675",
   828 => x"fee538a6",
   829 => x"800b80f5",
   830 => x"2d547382",
   831 => x"2e098106",
   832 => x"fed538a6",
   833 => x"810b80f5",
   834 => x"2d70aaa4",
   835 => x"0cff05aa",
   836 => x"980ca682",
   837 => x"0b80f52d",
   838 => x"a6830b80",
   839 => x"f52d5b75",
   840 => x"057a8280",
   841 => x"290570aa",
   842 => x"8c0ca684",
   843 => x"0b80f52d",
   844 => x"70aa880c",
   845 => x"aa9c085b",
   846 => x"59577880",
   847 => x"f838a686",
   848 => x"0b80f52d",
   849 => x"a6850b80",
   850 => x"f52d7182",
   851 => x"80290570",
   852 => x"a9f40c70",
   853 => x"a02983ff",
   854 => x"0570892a",
   855 => x"70aaa00c",
   856 => x"a68b0b80",
   857 => x"f52da68a",
   858 => x"0b80f52d",
   859 => x"71828029",
   860 => x"0570a5ec",
   861 => x"0c7d7129",
   862 => x"1d70aa94",
   863 => x"0c7fa5f0",
   864 => x"0c7305aa",
   865 => x"ac0c5a5a",
   866 => x"5151555a",
   867 => x"815675a4",
   868 => x"dc0c02a8",
   869 => x"050d0488",
   870 => x"53a3e052",
   871 => x"a6aa5196",
   872 => x"cf2d8056",
   873 => x"a4dc0876",
   874 => x"2efdf838",
   875 => x"75a4dc0c",
   876 => x"02a8050d",
   877 => x"048853a3",
   878 => x"ec52a6c6",
   879 => x"5196cf2d",
   880 => x"a4dc08fb",
   881 => x"f938aaa4",
   882 => x"0870842b",
   883 => x"a9f40c70",
   884 => x"aaa00ca6",
   885 => x"990b80f5",
   886 => x"2da6980b",
   887 => x"80f52d71",
   888 => x"82802905",
   889 => x"a69a0b80",
   890 => x"f52d7084",
   891 => x"80802912",
   892 => x"a69b0b80",
   893 => x"f52d7081",
   894 => x"800a2912",
   895 => x"70a5ec0c",
   896 => x"aa880871",
   897 => x"29aa8c08",
   898 => x"0570aaac",
   899 => x"0ca6a10b",
   900 => x"80f52da6",
   901 => x"a00b80f5",
   902 => x"2d718280",
   903 => x"2905a6a2",
   904 => x"0b80f52d",
   905 => x"70848080",
   906 => x"2912a6a3",
   907 => x"0b80f52d",
   908 => x"70982b81",
   909 => x"f00a0672",
   910 => x"0570a5f0",
   911 => x"0cfe117e",
   912 => x"297705aa",
   913 => x"940c5259",
   914 => x"5255585e",
   915 => x"51525f52",
   916 => x"5b575557",
   917 => x"81569b8e",
   918 => x"0402ec05",
   919 => x"0d767087",
   920 => x"2c7180ff",
   921 => x"06565653",
   922 => x"aa9c088a",
   923 => x"3872882c",
   924 => x"7381ff06",
   925 => x"5555a5f4",
   926 => x"52aa8c08",
   927 => x"15518de4",
   928 => x"2da4dc08",
   929 => x"53a4dc08",
   930 => x"802e9c38",
   931 => x"aa9c0880",
   932 => x"2e9e3873",
   933 => x"1010a5f4",
   934 => x"05700852",
   935 => x"538ec72d",
   936 => x"a4dc08f0",
   937 => x"0a065372",
   938 => x"a4dc0c02",
   939 => x"94050d04",
   940 => x"7310a5f4",
   941 => x"057080e0",
   942 => x"2d52538e",
   943 => x"f72da4dc",
   944 => x"08539da7",
   945 => x"0402cc05",
   946 => x"0d7e605d",
   947 => x"5d800ba5",
   948 => x"f008aa94",
   949 => x"085a5c57",
   950 => x"aa9c0877",
   951 => x"2e818a38",
   952 => x"aaa40884",
   953 => x"2b598056",
   954 => x"75792780",
   955 => x"c438758f",
   956 => x"06a01858",
   957 => x"5473802e",
   958 => x"80fa3880",
   959 => x"7780f52d",
   960 => x"55557375",
   961 => x"2e833881",
   962 => x"557381e5",
   963 => x"2e9a3881",
   964 => x"70760655",
   965 => x"5a73802e",
   966 => x"8f388b17",
   967 => x"80f52d98",
   968 => x"06557480",
   969 => x"2e80de38",
   970 => x"81165678",
   971 => x"7626ffbe",
   972 => x"38aa9c08",
   973 => x"802e81c1",
   974 => x"387a519c",
   975 => x"d92da4dc",
   976 => x"08a4dc08",
   977 => x"80ffffff",
   978 => x"f806555b",
   979 => x"7380ffff",
   980 => x"fff82e81",
   981 => x"a438a4dc",
   982 => x"08fe05aa",
   983 => x"a40829aa",
   984 => x"ac080558",
   985 => x"80569de8",
   986 => x"04aaa008",
   987 => x"842b5980",
   988 => x"569de804",
   989 => x"a5f45277",
   990 => x"51811858",
   991 => x"8de42da5",
   992 => x"f4579dfb",
   993 => x"048b537b",
   994 => x"52765196",
   995 => x"cf2da4dc",
   996 => x"08ff9538",
   997 => x"9c170851",
   998 => x"8ec72da4",
   999 => x"dc08841e",
  1000 => x"0c9a1780",
  1001 => x"e02d518e",
  1002 => x"f72da4dc",
  1003 => x"08a4dc08",
  1004 => x"5556aa9c",
  1005 => x"08973873",
  1006 => x"881e0c73",
  1007 => x"8c1e0c74",
  1008 => x"7d0c7954",
  1009 => x"73a4dc0c",
  1010 => x"02b4050d",
  1011 => x"04a4dc08",
  1012 => x"881e0c94",
  1013 => x"1780e02d",
  1014 => x"518ef72d",
  1015 => x"a4dc0890",
  1016 => x"2b83fff0",
  1017 => x"0a067017",
  1018 => x"707f8805",
  1019 => x"0c8c1f0c",
  1020 => x"54747d0c",
  1021 => x"79549fc4",
  1022 => x"04800ba4",
  1023 => x"dc0c02b4",
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

