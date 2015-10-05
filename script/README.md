NOTE: This is currently a note dump!
====================================

Description of VWF:
Takes in the following parameters:
r0 holds some the index into 603787 of the glyph to draw
r2 holds the starting address of the font glyphs in onboard wram
r3 is a boolean indicating whether this is the first or second glyph in a pair.
r13 holds the starting address in onchip wram that the current glyph should be written to
and does the following:

0x0000C1A0 is where the dma from 0x020097B0 to tile data happens
0x0000C27C is the dma control flag for transferring tile data
0x0000C21A does some stuff to draw tiles into bg3 that we modify

Script begin address: 0x0062B72A
Script end address: 0x0062C912
0x020097B0 -- onboard wram storing font glyphs?
0x03007DF4 -- onchip wram storing font glyphs.
0x0000C19C -- copy fonts from onboard wram to tile memory
0x0000D05C -- Update font tile data in onchip wram (data stored in r2, but where does it come from?)
0x0000D030 to 0x0000D058 -- loop to set the data in r2 for updating font tile data. r3 holds the data in binary.
60378E -- start of glyph graphics data

0x0000B5EE
0x0000BA70
0x0000BA98
0x0000BDF8
0x0000C036
0x0000C142


[02009930]!

Tile destination index 0x02009954 is updated at 0x0000C2E6 (3404 to 3400) and 0x0000C218 (1CA2 to 1C22) and 0x0000BA74 (3002 to 3000)
x-coordinate updated at 0x0000C248 and 0x0000C2F2

0x02009954 -- tile destination index to copy data from wram to (not what I expect it to be though…)
0x02009930 -- x-coordinate
0x02009770 -- line number
0x0200974C -- what does this store? It’s usually 0 though.

A variable width font routine must do the following:
If r3 is 0, write to the first half of r2. I.e. the total width of the glyphs drawn should be 12 pixels.
If r3 is 1, write to the second half of r2.

One issue here is that the font drawing routine is called assuming only 2 glyphs are drawn per three 8x8 tiles. That is, we need to be able to draw all the glyphs in the three 8x8 tiles, but we are only passed in 2 glyphs that are to be drawn.

In order to get around this, we can do the following:
Save the last glpyh from the previous three 8x8 tile unit and the number of pixels that that glyph extends into the current three 8x8 tile unit. This is a small amount of information and we can stuff it in some part of wram that is never used.
Modify the script codes such that each code corresponds to up to 6 English characters (worst case scenario is 6 i’s or 6 l’s) [this ought to be able to fit into a 16 bit value, since combinations such as 6 o’s can’t happen since it won’t fit in 12 pixels]. Then, when the glyph is passed in, we’ll have enough information to draw the glyphs that are displayed in the first/second half of the three 8x8 tile unit.
Draw the glyphs in our vwf routine.


Function copying glyph tiles into wram:

Assumptions:
r2 holds the starting address of the font glyphs in onboard wram
r0 holds some the index into 603787 of the glyph to draw
r3 is a boolean indicating whether this is the first or second glyph in a pair.
r13 holds the starting address in onchip wram that the current glyph should be written to

variables:
[sp, 84h] -- address of the current row of the glyph to put into onboard wram


Breakdown:
Begins at 0x0000CFCC with pushing registers on to the stack
0x0000D028 to 0x0000D06C -- Copies two 8x8 glyph tile into onchip wram (two tiles because they are stacked vertically to make one character. The address of the tile to copy is stored at [sp, 84h].
0x0000D06C to 0x0000D0BE -- Copies another two 8x8 glyph tile into onchip wram. However, it appears to only copy the last 4 bits from each row (notice the cmp r4, 3h in 0x0000D0AE vs the cmp r4, 7h in 0x0000D056)?
0x0000D0BE: If statement checking if some parameter [sp,80] is zero or not. Not sure what the parameter represents though.
0x0000D0C4 to 0x0000D0F2 -- Copies the data from onchip wram onto onboard wram.
Some other parameter is passed in [sp,80].
0x0000D112: Function returns and branches to 0x0000C18A, which transfers the data from onboard wram into the tile memory via DMA.
After this is done, we branch to 0x0000C29C

Calls to 0x0000CFCC:
0x0000ADCE
0x0000C186 <- called for dialogue boxes
0x0000C98C


How graphics are stored:
32 bytes per glyph at 1bpp (all glyphs are 16x16).
Each byte starting at 0x006035AC is a row from a glyph, stored in binary:
e.g. the letter A might look like
00011000
00100100
00100100
00111100
00111100
00100100
00100100
00100100


Table:
Ⅹ 0030
Ⅰ
Ⅱ
Ⅲ
Ⅳ
Ⅴ
Ⅵ
Ⅶ
Ⅷ
Ⅸ
~
「
」
『
』
?
→ 0040
A 0041
B
C
D
E
F
G
H
I
J
K
L
M
N
O
P
Q
R
S
T
U
V
W
X
Y
Z
ー
、
。
っ
ッ
ぁ 0060
ァ
ぃ
ィ
ぅ
ゥ
ぇ
ェ
ぉ
ォ
ゃ
ャ
ゅ
ュ
ょ
ョ
あ0070
ア0071
い0072
イ0073
う
ウ
え
エ
お
オ
か
カ
き
キ
く
ク
け
ケ
こ
コ
さ
サ
し
シ
す
ス
せ
セ
そ
ソ
た
タ
ち
チ
つ
ツ
て
テ
と
ト
な
ナ
に
ニ
ぬ
ヌ
ね
ネ
の
ノ
は
ハ
ひ
ヒ
ふ
フ
へ
ヘ
ほ
ホ
ま
マ
み
ミ
む
ム
め
メ
も
モ
や
ヤ
ゆ
ユ
よ
ヨ
ら
ラ
り
リ
る
ル
れ
レ
ろ
ロ
わ
ワ
を
ヲ
ん
00CB ン

.
.
.

0105 聖
剣
伝
説
樹
一
ニ
三
四
五
六
七
八
九
十
.
.
.

FEFF \n
