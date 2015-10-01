Overview
========
This patch translates all the window titles/headers in the menu. Each individual
header is stored as a series of 8x8 tiles and rendered on screen as multiple
sprites. There were three steps involved in creating this patch:
1. Replace all the Japanese header text sprites with English header text
   sprites.
2. Modify the menu text info for each header to point to the new location of the
   sprite and to load the correct number of tiles into OAM.
3. Some headers are composed of two words. The x-coordinate of the second word
   in the text_info data structure is ignored and is instead hard-coded in the
   subroutine used to copy its data into OAM. These x-coordinates also need to
   be modified.  

Memory Addresses
================
`0x007910A0 - 0x007920A0`: Menu text graphics

`0x000C31B8 - 0x000C33C8`: Menu text info (see data structures)

Data Structures
===============
Menu text info structure:
```
struct text_info {
  u16 number_of_tiles;
  u16 tile_index; // lower 9 bits of attribute 2 in OAM
  u16 padding; // padded with 000E strangely?
  u16 tile_size; // in bytes
  u8 tile_width; // will increment x-coord by width after drawing each tile
  u8 tile_height; // will increment y-coord by height after drawing each tile
  u8 shape; // see table 4 on http://www.coranac.com/tonc/text/regobj.htm
  u8 size; // see table 4 above
  u16 x; // upper 8 bits should be 0
  u16 y; // upper 8 bits should be 0
}
```
Translated text
===============
Compound Headers
----------------
|Japanese|English|New X-Coordinate|Address|
|:-------|:------|:---------------|:------|
|かいふくアイテム|RECOVERY ITEMS|0x61|`0x000AA27C`|
|そうびアイテム|EQUIPMENT|0xFF|`0x000AA2AA`|
|MD　パッツ|MD PARTS|0x46|`0x000AA2DA`|
|そのたのアイテム|OTHER ITEMS|0x53|`0x000AA30A`|
|まほう　のてちょう|MAGIC HANDBOOK|0x55|`0x000AAF78`|
|MD じてん|MD MANUAL|0x46|`0x000AB1AC`|
|まほう　??????|Unknown|N/A|`0x000AB870`|
|ぼうぐ　そうび|EQUIPMENT|0x38|`0x000ABE20`|
|まほう　そうび|MAGIC|0xFF|`0x000AC15A`|
|まほう　レベル|MAGIC LEVEL|0x55|`0x00AC1B8`|
|ぼうぐ　そうび|EQUIPMENT|0x38|`0x00AD58A`|
|まほう　そうび|MAGIC|0xFF|`0x000AD930`|
|シール　そうび|SEALS|0xFF|`0x000ADA50`|
|まほう　のてちょう|MAGIC HANDBOOK|0x55|`0x000ADEF4`|
|MD じてん|MD MANUAL|0x46|`0x000AE366`|

Menu Graphics In Order
----------------------

|Japanese|English|
|:-------|:------|
|メニュー|MENU|
|ステータス|STATUS|
|メンバー|MEMBERS|
|そうび|EQUIPMENT|
|まほう|MAGIC|
|レベル|LEVEL|
|シール|SEALS|
|アイテム|ITEMS|
|しゅぞくずかん|SPECIES|
|せいれい|SPIRITS|
|タイム|TIME|
|おかね|BIRA (name of currency)|
|モンスターずかん|MONSTERS|
|かいふく|RECOVERY|
|メモ|MEMO|
|フォーメーション|FORMATION|
|セーブ|SAVE (unused?)|
|ぼうぐ|(blank)|
|そのたの|OTHER|
|じてん|MANUAL|
|データ|DATA|
|せいせきひょう|REPORT CARD|
|プロフィール|PROFILE|
|M|(blank)|
|ちず|MAP|
|かいせつ|EXPLANATION (unused?)|
|おぼえたまほう|LEARNED MAGIC|
|アミーゴリスト|AMIGOS|
|おてちょう|HANDBOOK|
|何でもファイル|ALL FILES|
|D|MD (M comes from earlier)|
|パーツ|PARTS|

Hacking Techniques
==================
The menu text graphics were discovered by simply scrolling through the ROM in
CrystalTile2 tile display view. To figure out the location of the text_info
data structures, I used No$GBA's breakpoint functionality to break when the OAM
address `0x07000020` was written to. The breakpoint command `[07000020]!` breaks
on any changes to the contents at the address `0x07000020`. With the breakpoint
in place, I was able to figure out that the OAM was written to using DMA3 and
looking at the source address, I found that the relevant OAM data was stored in
RAM and copied over each frame. Setting breakpoints in the RAM allowed me to and
then stepping through some assembly instructions, I found that data such as the
x and y coordinates were stored in static data in the range `0x000C31B8` to
`0x000C33C8`. Once I found the data range, modifying the values and looking at
their effects in-game let me figure out what the fields in the data structure
are.

Figuring out where the x-coordinates of the second word in a two word header
were stored took more work. It involved some manual stepping through assembly
to gain an understanding of the code and also setting breakpoints to find
important addresses. Once I had an idea that the x-coordinates were stored in
individual subroutines, I used No$GBA's search function to locate the
subroutines by searching for the address of the text_info structure. For
example, I tried searching for `80C31F8h` to find two word headers where the
first word was まほう.

Miscellaneous
=============
Some sort of subroutine to copy OAM from RAM is at `0x000B10D0` to `0x000B116A`
I think.
