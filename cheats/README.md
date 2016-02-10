0202A170 stores alot of information about the party.
Exp [4 bytes?]: 202A1B8
MP Max [14 bits]: 202A17D [7 bits] + 202A17C [7 bits]
MP remaining [14 bits]: 202A17C [1 bits] + 202A17B [8 bits] + 202A17A [5 bits]
HP Max [14 bits]: 202A17A [3 bits] + 202A179 [8 bits] + 202A178 [3 bits]
HP remaining [14 bits]: 202A178 [5 bits] + 202A177 [8 bits] + 202A176 [1 bit]
Level [10 bits]: 202A176 [7 bits] + 202A175 [3 bits]

0x0E000000 (SRAM): Character info (level, hp, etc.).


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


Magical Starsign AR codes:
Magical Starsign (U) (AVCE) (NDS) [DawsonJ]


Hero / Heroine:

EXP:
120976A4 000003E7

Pow:
121F4D60 000003E7

IQ:
121F4D68 000003E7

Def:
121F4D64 000003E7

Spr:
121F4D6C 000003E7

Agi:
121F4D70 000003E7



Lassi:

EXP:
1209772C 000003E7

Pow:
121F4D8C 000003E7

IQ:
121F4D94 000003E7

Def:
121F4D90 000003E7

Spr:
121F4D98 000003E7

Agi:
121F4D9C 000003E7



Mokka:

EXP:
120976E8 000003E7

Pow:
121F4DB8 000003E7

IQ:
121F4DC0 000003E7

Def:
121F4DBC 000003E7

Spr:
121F4DC4 000003E7

Agi:
121F4DC8 000003E7



Pico:

EXP:
12097770 000003E7

Pow:
121F4DE4 000003E7

IQ:
121F4DEC 000003E7

Def:
121F4DE8 000003E7

Spr:
121F4DF0 000003E7

Agi:
121F4DF4 000003E7



Chai:

EXP:
120977B4 000003E7

Pow:
121F4E10 000003E7

IQ:
121F4E18 000003E7

Def:
121F4E14 000003E7

Spr:
121F4E1C 000003E7

Agi:
121F4E20 000003E7



Sorbet:

EXP:
120977F8 000003E7

Pow:
121F4E3C 000003E7

IQ:
121F4E44 000003E7

Def:
121F4E40 000003E7

Spr:
121F4E48 000003E7

Agi:
121F4E4C 000003E7



Have All Items x90 (Press Select)*:
94000130 FFFB0000
C0000000 0000034C
22098A90 0000005A
DC000000 00000002
D2000000 00000000
*This doesn't include most Key Items, only the Scampi - Shaky Balls.


Items (Sub-Menu):

Fire Gummy (Key Items):
22098A5A 00000001

Wood Gummy (Key Items):
22098A5C 00000001

Wind Gummy (Key Items):
22098A5E 00000001

Earth Gummy (Key Items):
22098A60 00000001

Water Gummy (Key Items):
22098A62 00000001

Kovo Water (Key Items):
22098A64 00000001

Toolbox Key (Key Items):
22098A66 00000001

Dragon Key (Key Items):
22098A68 00000001

Stolen Goods (Key Items):
22098A6A 00000001

Battery Pack (Key Items):
22098A6C 00000001

Mystic Mouse (Key Items):
22098A6E 00000001

Diggy Claws (Key Items):
22098A70 00000001

Toilet Paper (Key Items):
22098A72 00000001

Tempus Forget (Key Items):
22098A74 00000001

Aquarino (Key Items):
22098A76 00000001

Fake Beard (Key Items):
22098A78 00000001

Precious Clip (Key Items):
22098A7A 00000001

Access Card (Key Items):
22098A7C 00000001

Warrior's Nose (Key Items):
22098A7E 00000001

Amigo Badge (Key Items):
22098A80 00000001

Reserved Item (Other) [Useless]:
22098A82 00000001

Reserved Item (Other) [Useless]:
22098A84 00000001

Reserved Item (Other) [Useless]:
22098A86 00000001

Reserved Item (Other) [Useless]:
22098A88 00000001

Reserved Item (Other) [Useless]:
22098A8A 00000001

Reserved Item (Other) [Useless]:
22098A8C 00000001

Reserved Item (Other) [Useless]:
22098A8E 00000001

Holey Leaf (Power-ups):
22098A90 0000005A

Raggedy Leaf (Power-ups):
22098A92 0000005A

Waggly Leaf (Power-ups):
22098A94 0000005A

Spiny Leaf (Power-ups):
22098A96 0000005A

Jaggy Leaf (Power-ups):
22098A98 0000005A

Rusty Screw (Other):
22098A9A 0000005A

Chest (Other):
22098A9C 0000005A

Gold Dust (Other):
22098A9E 0000005A

Dragon Egg (Other):
22098AA0 0000005A

Gold Nugget (Other):
22098AA2 0000005A

Piggy Bank (Other):
22098AA4 0000005A

Rainbow Shell (Other):
22098AA6 0000005A

Bang Berry (Other):
22098AA8 0000005A

Putty Pea (Other):
22098AAA 0000005A

Reserved Item (Other) [Useless]:
22098AAC 00000001

Reserved Item (Other) [Useless]:
22098AAE 00000001

Reserved Item (Other) [Useless]:
22098AB0 00000001

Reserved Item (Other) [Useless]:
22098AB2 00000001

Reserved Item (Other) [Useless]:
22098AB4 00000001

Reserved Item (Other) [Useless]:
22098AB6 00000001

Reserved Item (Other) [Useless]:
22098AB8 00000001

Reserved Item (Other) [Useless]:
22098ABA 00000001

Comet Book (Other):
22098ABC 0000005A

Amigo Book (Other):
22098ABE 0000005A

Brawly Book (Other):
22098AC0 0000005A

Splode Book (Other):
22098AC2 0000005A

Sky Book (Other):
22098AC4 0000005A

Scampi Ball (Key Items):
22098AC6 00000001

Bat Ball (Key Items):
22098AC8 00000001

Maimai Ball (Key Items):
22098ACA 00000001

Crab Ball (Key Items):
22098ACC 00000001

Shaky Ball (Key Items):
22098ACE 00000001

Reserved Item (Other) [Useless]:
22098AD0 00000001

Reserved Item (Other) [Useless]:
22098AD2 00000001

Reserved Item (Other) [Useless]:
22098AD4 00000001

Reserved Item (Other) [Useless]:
22098AD6 00000001

Reserved Item (Other) [Useless]:
22098AD8 00000001

Reserved Item (Other) [Useless]:
22098ADA 00000001

Reserved Item (Other) [Useless]:
22098ADC 00000001

Reserved Item (Other) [Useless]:
22098ADE 00000001

Green Frog (Recovery):
22098AE0 0000005A

Blue Frog (Recovery):
22098AE2 0000005A

Red Frog (Recovery):
22098AE4 0000005A

Baobab Sap (Recovery):
22098AE6 0000005A

Monster Meat (Recovery):
22098AE8 0000005A

Sweet Meat (Recovery):
22098AEA 0000005A

Yellow Worm (Recovery):
22098AEC 0000005A

Red Worm (Recovery):
22098AEE 0000005A

Tentacle (Recovery):
22098AF0 0000005A

Critter Horn (Recovery):
22098AF2 0000005A

Deburn Tail (Battle):
22098AF4 0000005A

Dethorn Tail (Battle):
22098AF6 0000005A

Undizzy Tail (Battle):
22098AF8 0000005A

Stoneoff Tail (Battle):
22098AFA 0000005A

Defrost Tail (Battle):
22098AFC 0000005A

Deblind Tail (Battle):
22098AFE 0000005A

Decursy Tail (Battle):
22098B00 0000005A

Versatail (Battle):
22098B02 0000005A

Wakey Tail (Battle):
22098B04 0000005A

Blaze Bomb (Battle):
22098B06 0000005A

Ivy Bomb (Battle):
22098B08 0000005A

Thunder Bomb (Battle):
22098B0A 0000005A

Quake Bomb (Battle):
22098B0C 0000005A

Flood Bomb (Battle):
22098B0E 0000005A

Sparkle Bomb (Battle):
22098B10 0000005A

Shadow Bomb (Battle):
22098B12 0000005A

Ruby Bomb (Battle):
22098B14 0000005A

Quartz Bomb (Battle):
22098B16 0000005A

Cobalt Bomb (Battle):
22098B18 0000005A

Emerald Bomb (Battle):
22098B1A 0000005A

Topaz Bomb (Battle):
22098B1C 0000005A

Berry Jam (Battle):
22098B1E 0000005A

Nut Spread (Battle):
22098B20 0000005A

Raisin Jam (Battle):
22098B22 0000005A

Melon Jam (Battle):
22098B24 0000005A

Lemon Jam (Battle):
22098B26 0000005A

Berry Jelly (Battle):
22098B28 0000005A

Nut Butter (Battle):
22098B2A 0000005A

Raisin Jelly (Battle):
22098B2C 0000005A

Melon Jelly (Battle):
22098B2E 0000005A

Lemon Jelly (Battle):
22098B30 0000005A

Carrot Shake (Battle):
22098B32 0000005A

Grudge Ball (Battle):
22098B34 0000005A

Ice Cube (Battle):
22098B36 0000005A

Ukulele (Battle):
22098B38 0000005A

Yellow Ooze (Battle):
22098B3A 0000005A

Clockwhistle (Battle):
22098B3C 0000005A

Antiwhistle (Battle):
22098B3E 0000005A

Sugarstar (Battle):
22098B40 0000005A

Slippy Oil (Battle):
22098B42 0000005A

Bean Pop (Battle):
22098B44 0000005A

Reserved Item (Other) [Useless]:
22098B46 00000001

Reserved Item (Other) [Useless]:
22098B48 00000001

Reserved Item (Other) [Useless]:
22098B4A 00000001

Reserved Item (Other) [Useless]:
22098B4C 00000001

White Frog (Recovery):
22098B4E 0000005A

Black Frog (Recovery):
22098B50 0000005A

Purple Frog (Recovery):
22098B52 0000005A

Orange Frog (Recovery):
22098B54 0000005A

Brown Frog (Recovery):
22098B56 0000005A

Pink Frog (Recovery):
22098B58 0000005A

Magenta Frog (Recovery):
22098B5A 0000005A

Violet Frog (Recovery):
22098B5C 0000005A

Taupe Frog (Recovery):
22098B5E 0000005A

Cyan Frog (Recovery):
22098B60 0000005A

Lilac Frog (Recovery):
22098B62 0000005A

Lime Frog (Recovery):
22098B64 0000005A

Pickle Frog (Recovery):
22098B66 0000005A

Silver Frog (Recovery):
22098B68 0000005A

Choco Frog (Recovery):
22098B6A 0000005A

Kiwi Frog (Recovery):
22098B6C 0000005A

Yellow Frog (Recovery):
22098B6E 0000005A

Crimson Frog (Recovery):
22098B70 0000005A

Jasmine Frog (Recovery):
22098B72 0000005A

Gray Frog (Recovery):
22098B74 0000005A

Maroon Frog (Recovery):
22098B76 0000005A

Puce Frog (Recovery):
22098B78 0000005A

Salmon Frog (Recovery):
22098B7A 0000005A

Russet Frog (Recovery):
22098B7C 0000005A

Fuchsia Frog (Recovery):
22098B80 0000005A

Gold Frog (Recovery):
22098B82 0000005A

Striped Frog (Recovery):
22098B84 0000005A

Peach Frog (Recovery):
22098B86 0000005A

Khaki Frog (Recovery):
22098B88 0000005A

Reserved Item (Other) [Useless]:
22098B8A 00000001

Reserved Item (Other) [Useless]:
22098B8C 00000001

Monocorn Horn (Battle):
22098B8E 0000005A

Hot Lava (Battle):
22098B90 0000005A

Bat Noble (Battle):
22098B92 0000005A

Spiky Nut (Battle):
22098B94 0000005A

Whimsy Salad (Battle):
22098B96 0000005A

Nimbus (Battle):
22098B98 0000005A

Storm Judge (Battle):
22098B9A 0000005A

Bagagong (Battle):
22098B9C 0000005A

Buffalope Herd (Battle):
22098B9E 0000005A

Wee Tadpole (Battle):
22098BA0 0000005A

Chatterbox (Battle):
22098BA2 0000005A

Three Brothers (Battle):
22098BA4 0000005A

Panic Alarm (Battle):
22098BA6 0000005A

Bone Warrior (Battle):
22098BA8 0000005A

Witch Waif (Battle):
22098BAA 0000005A

Fallen Devil (Battle):
22098BAC 0000005A

Dance Machine (Battle):
22098BAE 0000005A

Stench Lord (Battle):
22098BB0 0000005A

Narcissist (Battle):
22098BB2 0000005A

Fugitive (Battle):
22098BB4 0000005A

Wind Maiden (Battle):
22098BB6 0000005A

Seeker (Battle):
22098BB8 0000005A

Insect Mage (Battle):
22098BBA 0000005A

Zaphropeak (Battle):
22098BBC 0000005A

Pig Hasnel (Battle):
22098BBE 0000005A

Zodalkrew (Battle):
22098BC0 0000005A

Red Hero (Battle):
22098BC2 0000005A

Green Hero (Battle):
22098BC4 0000005A

Yellow Hero (Battle):
22098BC6 0000005A

Brown Hero (Battle):
22098BC8 0000005A

Blue Hero (Battle):
22098BCA 0000005A

Reserved Item (Other) [Useless]:
22098BCC 00000001

Reserved Item (Other) [Useless]:
22098BCE 00000001

Reserved Item (Other) [Useless]:
22098BD0 00000001

Reserved Item (Other) [Useless]:
22098BD2 00000001

Reserved Item (Other) [Useless]:
22098BD4 00000001

Reserved Item (Other) [Useless]:
22098BD6 00000001

Reserved Item (Other) [Useless]:
22098BD8 00000001


Equipment:

Bandana:
22098BDA 0000005A

Straw Hat:
22098BDC 0000005A

Fridge Cap:
22098BDE 0000005A

Tulip Hat:
22098BE0 0000005A

Wool Cap:
22098BE2 0000005A

Helmet:
22098BE4 0000005A

Antenna:
22098BE6 0000005A

Array:
22098BE8 0000005A

Fencing Mask:
22098BEA 0000005A

Punk Cap:
22098BEC 0000005A

Comsat Dish:
22098BEE 0000005A

Goblin Array:
22098BF0 0000005A

Gold Circlet:
22098BF2 0000005A

Odd Circlet:
22098BF4 0000005A

Self Circlet:
22098BF6 0000005A

Spirit Band:
22098BF8 0000005A

Disco Wig:
22098BFA 0000005A

Leaf Hat:
22098BFC 0000005A

Wreath:
22098BFE 0000005A

Mardi Mask:
22098C00 0000005A

Fairy Tiara:
22098C02 0000005A

Pigheaded Hat:
22098C04 0000005A

Crystal Hat:
22098C06 0000005A

Shampoo Cap:
22098C08 0000005A

Dragon Mask:
22098C0A 0000005A

Crown:
22098C0C 0000005A

Angel Ring:
22098C0E 0000005A

Purple Turban:
22098C10 0000005A

Devil's Horn:
22098C12 0000005A

Reserved Item (Other) [Useless]:
22098C14 00000001

Reserved Item (Other) [Useless]:
22098C16 00000001

Reserved Item (Other) [Useless]:
22098C18 00000001

Reserved Item (Other) [Useless]:
22098C1A 00000001

Reserved Item (Other) [Useless]:
22098C1C 00000001

Reserved Item (Other) [Useless]:
22098C1E 00000001

Reserved Item (Other) [Useless]:
22098C20 00000001

Reserved Item (Other) [Useless]:
22098C22 00000001

Reserved Item (Other) [Useless]:
22098C24 00000001

Reserved Item (Other) [Useless]:
22098C26 00000001

Reserved Item (Other) [Useless]:
22098C28 00000001

Reserved Item (Other) [Useless]:
22098C2A 00000001

Leather Wrist:
22098C2C 0000005A

Reserved Item (Other) [Useless]:
22098C2E 00000001

Baobab Wrist:
22098C30 0000005A

Bronze Ring:
22098C32 0000005A

Silver Ring:
22098C34 0000005A

Gold Ring:
22098C36 0000005A

Platinum Ring:
22098C38 0000005A

Gorgon Brace:
22098C3A 0000005A

Demon Brace:
22098C3C 0000005A

Spinel Ring:
22098C40 0000005A

Star Ring:
22098C42 0000005A

Planet Ring:
22098C44 0000005A

Space Ring:
22098C46 0000005A

Oven Mitts:
22098C48 0000005A

Martial Fist:
22098C4A 0000005A

Thorn Bangle:
22098C4C 0000005A

Garden Mitts:
22098C4E 00000006

Vinyl Shirt:
22098C7E 0000005A

Tour Shirt:
22098C80 0000005A

Long Johns:
22098C82 0000005A

Lynx Shirt:
22098C84 00000006

Frog Shirt:
22098C86 0000005A

Hide Armor:
22098C88 0000005A

Black Robe:
22098C8A 0000005A

Chain Mail:
22098C8C 0000005A

Lizard Mail:
22098C8E 0000005A

Plate Mail:
22098C90 0000005A

Heavy Mail:
22098C92 0000005A

Dark Robe:
22098C94 0000005A

Ancient Robe:
22098C96 0000005A

Star Robe:
22098C98 0000005A

Thinky Cloak:
22098C9A 0000005A

Weasel Coat:
22098C9C 0000005A

Sun Shirt:
22098CA0 0000005A

Aroma Coat:
22098CA2 0000005A

Falcon Coat:
22098CA4 0000005A

Wing Robe:
22098CA6 0000005A

Rock Robe:
22098CA8 0000005A

Earth Armor:
22098CAA 0000005A

Magic Tank:
22098CAC 0000005A

Soul Tank:
22098CAE 0000005A

Raincoat:
22098CB0 0000005A

Mirror Cloak:
22098CB2 0000005A

Fame Coat:
22098CB4 0000005A

Rainbow Coat:
22098CB6 0000005A

Bone Mail:
22098CB8 0000005A

Evil Ink:
22098CBA 0000005A

Reserved Item (Other) [Useless]:
22098CBC 0000005A

Reserved Item (Other) [Useless]:
22098CBE 0000005A

Reserved Item (Other) [Useless]:
22098CC0 0000005A

Reserved Item (Other) [Useless]:
22098CC2 0000005A

Reserved Item (Other) [Useless]:
22098CC4 0000005A

Reserved Item (Other) [Useless]:
22098CC6 0000005A

Reserved Item (Other) [Useless]:
22098CC8 00000006

Reserved Item (Other) [Useless]:
22098CCA 00000003

Reserved Item (Other) [Useless]:
22098CCC 00000006

Holey Socks:
22098CCE 00000003

Wooden Clogs:
22098CD0 0000005A

Rubber Boots:
22098CD2 0000005A

Hiking Shoes:
22098CD4 0000005A

Glass Slippers:
22098CD6 0000005A

Cleats:
22098CD8 0000005A

Spikey Shoes:
22098CDA 0000005A

Spiffy Kicks:
22098CDC 0000005A

Sprint Shoes:
22098CDE 0000005A

Mechaboots:
22098CE0 0000005A

Catdog Boots:
22098CE2 0000005A

Bird Boots:
22098CE4 0000005A

Windy Boots:
22098CE6 0000005A

Heaven Boots:
22098CE8 0000005A

Meteor Boots:
22098CEA 0000005A

Flip-flops:
22098CEC 0000005A

Manic Shoes:
22098CEE 0000005A

Mandrake Shoes:
22098CF0 0000005A

Flower Boots:
22098CF2 0000005A

Dodo Shoes:
22098CF4 0000005A

Tech Model S:
22098CF6 0000005A

Golem Clogs:
22098CF8 0000005A

Hill Boots:
22098CFA 0000005A

Sandals:
22098CFC 0000005A

Moccasins:
22098CFE 0000005A

Wing Slippers:
22098D00 0000005A

Divine Shoes:
22098D02 0000005A

Vampy Boots:
22098D04 0000005A

Dusk Shoes:
22098D06 0000005A

Reserved Item (Other) [Useless]:
22098D08 0000005A

Reserved Item (Other) [Useless]:
22098D0A 0000005A

Reserved Item (Other) [Useless]:
22098D0C 0000005A

Reserved Item (Other) [Useless]:
22098D0E 0000005A

Reserved Item (Other) [Useless]:
22098D10 0000005A

Reserved Item (Other) [Useless]:
22098D12 0000005A

Reserved Item (Other) [Useless]:
22098D14 0000005A

Reserved Item (Other) [Useless]:
22098D16 0000005A

Reserved Item (Other) [Useless]:
22098D18 0000005A

Reserved Item (Other) [Useless]:
22098D1A 0000005A

Reserved Item (Other) [Useless]:
22098D1C 0000005A

Reserved Item (Other) [Useless]:
22098D1E 0000005A

Hair Clip:
22098D20 0000005A

Headband:
22098D22 0000005A

Ribbon:
22098D24 0000005A

Ear Plugs:
22098D26 0000005A

Dog Snout:
22098D28 0000005A

Totem Studs:
22098D2A 0000005A

Red Ribbon:
22098D2C 0000005A

Skull Clip:
22098D2E 0000005A

Fish Charm:
22098D30 0000005A

Mouse Charm:
22098D32 0000005A

Bird Charm:
22098D34 0000005A

Pyrite:
22098D36 0000005A

Aqua Studs:
22098D38 0000005A

Cobalt Studs:
22098D3A 0000005A

Ruby Studs:
22098D3C 0000005A

Diamond Studs:
22098D3E 0000005A

Loincloth:
22098D40 0000005A

Belly Band:
22098D42 0000005A

Lucky Clover:
22098D44 0000005A

Holy Incense:
22098D46 0000005A

Sparrow Wings:
22098D48 0000005A

Fringe Beads:
22098D4A 0000005A

Mole Tail:
22098D4C 0000005A

Fossil Charm:
22098D4E 0000005A

Aqua Talisman:
22098D50 0000005A

Sea Ring:
22098D52 0000005A

Light Ring:
22098D54 0000005A

Photon Studs:
22098D56 0000005A

Tusk Studs:
22098D58 0000005A

Black Nails:
22098D5A 00000006

Pooka String:
22098D5C 0000005A

Bat Husk:
22098D5E 0000005A

Maimai Husk:
22098D60 0000005A

Crab Husk:
22098D62 0000005A

Bellber Husk:
22098D64 0000005A

Reserved Item (Other) [Useless]:
22098D66 00000001

Reserved Item (Other) [Useless]:
22098D68 00000001

Reserved Item (Other) [Useless]:
22098D6A 00000001

Reserved Item (Other) [Useless]:
22098D6C 00000001

Reserved Item (Other) [Useless]:
22098D6E 00000001

Cat Ears:
22098D70 0000005A

Cat Paws:
22098D72 0000005A

Cat Suit:
22098D74 0000005A

Cat Feet:
22098D76 0000005A

Cat Bell:
22098D78 0000005A

Monocle:
22098D7A 0000005A

White Gloves:
22098D7C 0000005A

Tail Coat:
22098D7E 0000005A

Dress Shoes:
22098D80 0000005A

Loupe:
22098D82 0000005A

Winged Hat:
22098D84 0000005A

Winged Bangle:
22098D86 0000005A

Winged Shirt:
22098D88 0000005A

Winged Boots:
22098D8A 0000005A

Winged Studs:
22098D8C 0000005A

Pyramid Hat:
22098D8E 0000005A

Pearls:
22098D90 0000005A

Cashwad Cloak:
22098D92 0000005A

Gold Shoes:
22098D94 0000005A

Lucky Studs:
22098D96 0000005A

Force Hat:
22098D98 0000005A

Force Ring:
22098D9A 0000005A

Force Cloak:
22098D9C 0000005A

Force Boots:
22098D9E 0000005A

Force Studs:
22098DA0 0000005A

Misty Cap:
22098DA2 0000005A

Misty Ring:
22098DA4 0000005A

Misty Cloak:
22098DA6 0000005A

Misty Boots:
22098DA8 0000005A

Misty Studs:
22098DAA 0000005A

Sage Hat:
22098DAC 0000005A

Sage Band:
22098DAE 0000005A

Sage Robe:
22098DB0 0000005A

Sage Shoes:
22098DB2 0000005A

Sage String:
22098DB4 0000005A

Magic Hat:
22098DB6 0000005A

Magic Bangle:
22098DB8 0000005A

Magic Cloak:
22098DBA 0000005A

Magic Boots:
22098DBC 0000005A

Magic Studs:
22098DBE 0000005A

Washbasin:
22098DC0 0000005A

Towel:
22098DC2 0000005A

Bathrobe:
22098DC4 0000005A

Slippers:
22098DC6 0000005A

Bath Set:
22098DC8 0000005A

Egg Hat:
22098DCA 0000005A

Egg Ring:
22098DCC 0000005A

Egg Cloak:
22098DCE 0000005A

Egg Boots:
22098DD0 0000005A

Egg Studs:
22098DD2 0000005A

Justice Helm:
22098DD4 0000005A

Justice Arm:
22098DD6 0000005A

Justice Suit:
22098DD8 0000005A

Justice Boots:
22098DDA 0000005A

Justice Badge:
22098DDC 0000005A

Empty [Useless]:
22098DDE 00000001



--------------------------


例：example

マジカルバケーション

ビジュアルボーイアドバンス専用

2002/06/18　更新

よしさんの投稿コードです。（お金の下段はたぼさんの投稿）

お金	0202D7AC	0～999999
0203B910	たぼさんの投稿コードです。
上段下段、どちらでも可？
宝箱を見つけた数	0203567C	0～999
重要アイテム	0202D7B2
0202D7B4
以降+2h
0202D7D6
0202D7D8	Valueは個数。
Blackさんの投稿コードです。（リストの一部はシュンさん、晴太さん、ブルマンさんからも投稿）

■アイテム（シール以降もリストに掲載）

※Valueは個数です。
回復アイテム	0202D7DA
0202D7DC
以降+2h
0202D7F2
0202D7F4	14個
その他アイテム	0202D7F6
0202D7F8
以降+2h
0202D812
0202D814	16個
あたま	0202D816
0202D818
以降+2h
0202D826
0202D828	10個
うで	0202D82A
0202D82C
以降+2h
0202D83A
0202D83C	10個
からだ	0202D83E
0202D840
以降+2h
0202D84E
0202D850	10個
あし	0202D852
0202D854
以降+2h
0202D862
0202D864	10個
アクセサリー	0202D866
0202D868
以降+2h
0202D876
0202D878	10個
ＭＤパーツ	0202D87A
0202D87C
以降+2h
0202D8BA
0202D8BC	34個
シール	0202D8BE
0202D8C0
以降+2h
0202D8DA
0202D8DC	16個
仲良くなった精霊の数	0202D9B0
0202D9B2
以降+2h
0202D9CC
0202D9CE	ブルマンさんからも投稿していただきました。
黒崎さんの投稿コードです。（魔法習得コードはBlackさんからも投稿）

※	間隔は+110h。他のキャラはこちらのページを参考にして下さい。
なお、改造コード全般に言えることですが、
こちらのコードを使うと魔法レベルなどの成長に悪影響を及ぼすかもしれません。
その点はご了承下さい。
主人公男魔法レベル	0202A0AC - 63
0202A0AE - 63
以降+2h
0202A0C8 - 63
0202A0CA - 63	火、風、毒、美、刃、音、石、虫、
木、獣、水、雷、古、闇、光、愛の順。
主人公男魔法装備	0202A12C - xx
0202A12E - xx
以降+2h
0202A138 - xx
0202A13A - xx	Valueは
火属性１番目の魔法：01
火属性２番目の魔法：02
各属性の魔法は７つ
主人公男魔法修得	0202A13C - 07
0202A13E - 07
以降+2h
0202A158 - 07
0202A15A - 07	　
管理人の作成コードです。

敵が出現しない	0200B798 - FF	00で即出現。
ワープ先の登録全て	02029D28 - FC
02029D29 - FC
02029D2A - C0
02029D2B - FF	このValueで全て（光・闇・死）登録済み。
ただし、ゲームの進行に悪影響を及ぼす危険があります。
種族図鑑が埋まる	02029CC0 - C0
02029CC1 - FF
02029CF3 - 80
02029CF4 - FF
02029CF5 - 07	　
魔法の手帳が埋まる	02029D32 - F8
02029D33 - FF
02029D34 - FF
02029D35 - FF
02029D36 - FF
02029D37 - 07	最終行はＭＤ辞典のコードと共有です。
ＭＤ辞典が埋まる	02029D37 - F8
02029D38 - FF
02029D39 - FF
02029D3A - FF
02029D3B - 01	02029D37をFFにすれば、
魔法の手帳の38～40も埋まります。
モンスター図鑑が埋まる	0202D9E4 - FF
0202D9E5 - FF
以降+1h
0202DA06 - FF
0202DA07 - FF	全行入力すれば、
成績表のモンスター図鑑も100%になります。
成績表	バトル回数	0202DA0C - xx
0202DA0D - xx	FF、FFで65535。
逃走	0202DA14 - xx
0202DA15 - xx	FF、FFで65535。
気絶	0202DA18 - xx
0202DA19 - xx	FF、FFで65535。
最大精霊コンボ	0202DA1C - xx
0202DA1D - xx	E7、03で999。
プレイ時間	0203BB5C - 00
0203BB5D - 00
0203BB5E - 00
0203BB5F - 00	このValueで000：00。
属性コードはいのまーさん、Value値はよしさんの投稿です。

■主人公男のステータス

※	間隔は+110h。他のキャラはこちらのページを参考にして下さい。
なお、コードは8-bitで入力していき、一通り入力したら一度画面を切り替えて下さい。
Valueは各項目の最大値と思われる値にしていますが、
バグが発生するかもしれないので、セーブのバックアップは必ず取っておいて下さい。
また、現在HP～最大MPのコードはセットで入力しないと数値に誤差が生じるようです。
キャラ変更・性別	0202A060 - xx
0202A061 - yy	この値によってキャラと性別の両方が変化します。
種族	0202A062 - xx	　
レベル	0202A065 - E0
0202A066 - 7C	Valueが20増加するごとに数値が1上昇。E0、7Cで999。
現在HP	0202A067 - 87
0202A068 - F3	Valueが1増加するごとに数値が2上昇。87、13で9998。
最大HP	0202A069 - E1
0202A06A - 04	Valueが1増加するごとに数値が8上昇。E1、04で9992。
現在HPの2行目がF3の時、9999になるようです。
現在MP	0202A06B - 38
0202A06C - 1F	Valueが1増加するごとに数値が32上昇。38、01で9984。
最大MP	0202A06D - 4E	Valueが1増加するごとに数値が128上昇。4Eで9984。
現在MPの2行目が1Fの時、9999になるようです。
MP回復率	0202A06E - 32	Valueが1増加するごとに数値が2上昇。32で100。
力	0202A06F - E0
0202A070 - 7C	Valueが20増加するごとに数値が1上昇。E0、7Cで999。
力・守・速・精	0202A06F - E0
0202A070 - FC
0202A071 - F3
0202A072 - CF
0202A073 - 3F
0202A074 - 1F	この値で、力・守・速・精、全て999になります。
属性	0202A07C - xx	　
装備	0202A080 - xx
0202A082 - xx
0202A084 - xx
0202A086 - xx
0202A088 - xx	頭、腕、体、足、アクセサリーの順。
属性シール	0202A08A - xx
0202A08C - xx
以降+2h
0202A0A4 - xx
0202A0A6 - xx	何も貼っていない時はxx＝10。
ブルマンさんの投稿コードです。

カエルグミ捕獲数	02029E42	16-bitで入力して下さい。（0にする時も）
まつぼっくり捕獲数	02029E4A
ミミズグミ捕獲数	02029E4C
Blackさんの投稿コードです。（２番目以降はパパさんの投稿）

■ステータス（表示のみ）

※	２番目以降＋1Ch。
効果がなさそうなのでアイテムで上げるようにして下さい。
　	１番目	２番目	３番目
力	0203B6E8	0203B704	0203B720
守り	0203B6EA	0203B706	0203B722
速さ	0203B6EC	0203B708	0203B724
精神	0203B6EE	0203B70A	0203B726
MP回復率	0203B6F0	0203B70C	0203B728
経験値	0203B6F2	0203B70E	0203B72A


------------------------------
