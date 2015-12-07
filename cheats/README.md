0x02000360 stores lots of information.
Change 0x02000362 from 0x01 to 0x00 and you can walk through walls.

Looks like 0x02000340 stores the index of the current room. Put a breakpoint at 0x0801CEF0 and then change the value to warp to a different room.
0x80035C0 does the room loading?
I brute force tried warping to the first 256 rooms and there were a couple suspicious rooms:
-0x9F: Seems completely blank.
-0x42: Blank but with lots of Konjac cubes that seem to give random dialogue.
-0x18: Seems like an actual room in the game, but I can't talk to anyone.
Other room notes:
0x0115: Credit roll
There's a lot of blank rooms up until 0x0157, at which point it looks like there
are actual rooms again. Around 0x01E0 is the end of the room data. Trying to go
beyond that probably tries to interpret non-room data as a room, causing weird
glitchy things to happen.


Found the following AR codes:
（Ｍ）
93CD4294 8F343417　
4CD06F3E 81982E98
主人公（男）
ＨＰ・ＭＰＭＡＸ
0EF7D133 812DEC12
5251C320 9E9D6312　
4188EB8A 1511FE67
全ステータスＭＡＸ
ACC7D034 B0B4CD7C
AE761202 1F986378
4C2B5651 38046842
全魔法レベルＭＡＸ
DF09A7C5 4187B874
6948C3EC 38CA0162
2BBE8F21 AF0A759B
0DC9C9AD AAA50290　
8602DCE5 05670006
D658EB14 6A1D7AC4　
A63E7BC5 FB73B5AD
090BADB8 4C0458BD
全魔法修得
629B42A2 24518DB5　
6936815B 387ECA1B
629FE243 ADBE4130　
9BE6DF68 64A49ACE
01710EE3 02F679D8　
061F9978 C4CB97EE
732402DD 1BE5C595　
F7B817D9 C88C2F8B
主人公（女）
ＨＰ・ＭＰＭＡＸ
9EAAAA95 FF83E9AD　
9437B943 64DB87F7
8E27CD1F 4CB40C07　
全ステータスＭＡＸ
CC9A7D64 D9ABEC45　
43B7276C 9BB90E48　
94BBCBC4 48EEDCCC
全魔法レベルＭＡＸ
45935835 8F760933　
67D7F875 271F5835
07EE9377 E5B31E1A　
4F7F86F1 7779DDD0
26983E60 AF7F86F1　
AD64981D 2E37AD57
E3B20CC9 0608D787
45F6874F 68A10254
全魔法修得
9FE39714 56D62F22
BA02287C E0EB7DFA
C3564CEE C05A2AAF　
DB4A29D0 8364CF02
019D10CF DFFD5D08　
037B3454 136A1E5E　　
97011A70 28CDB886　
6B173EE3 225BF8F3

Source is http://www.geocities.jp/muraakideltora/PAR/mazibake.html

Bugs
====
http://jp.wazap.com/cheat/%E9%97%87%E3%81%AE%E3%82%B7%E3%83%BC%E3%83%AB%E3%81%8C%E3%81%84%E3%81%A3%E3%81%B1%E3%81%84/121332/
99 dark seals by checking empty chest in Wetsomus ruins
