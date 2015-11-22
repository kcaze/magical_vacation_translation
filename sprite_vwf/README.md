0x007C229C -- Header with offsets for the sprite text below.
0x007C25C4 to 0x007C418F -- Text for various menus and stuff.
0x007C4190 -- Header with offsets for the sprite text below.
0x007C45C8 to 0x007CB42F -- Text for descriptions of equipment, attacks, etc.
0x007CB430 -- Header with offsets.
0x007CB4D0 to 0x007CD3D9 -- Text for explanations in the magic handbook and stuff.

0x007C2614 = 回復アイテム in menu I think?
0x000B6558 looks like beginning of some subroutine. At this point, r0 holds the
address in RAM for the data structure described below. r1 holds the number of
characters in the text to draw. r2 holds the address of the last byte of text to
draw in the ROM I think? Current guess is this draws the sprite text to the
screen.

Reading menu text in 3 places:
0x000B6566
0x000BEEA6
0x000BEEB2

0x0203AFA8 stores a list of sprite text to render. The format seems to be
4 bytes storing the address of the beginning of the sprite text.
2 bytes storing the x coordinate.
2 bytes storing the beginning tile number.
FF FF E4 11 (some sort of delimiter? I'm not sure)

0x000A0CE8 -- Write sprite text to object tile via DMA.

0x000B6572 -- Move the glyph data in to r9, which is then preserved all the way until
calling 0x000BEBD8.

0x020381D8 is the beginning of the sprite text stored in RAM beginning. The RAM is updated at
  0x000B6736 -- Clear glyph data I think.
  0x000BEC56 -- Write glyph data probably.
The structure of the glyph data is interesting. There's a 4 byte header storing the
address of the obj tile to copy the data to, followed by 128 bytes of tile data at
4bpp so that's one 16x16 block, and then a 4 byte footer storing an address for idk what.

0x000BEC2C -- Beginning of subroutine for drawing glyph data to obj tiles:
  r0 -- Address in RAM to write the next glyph data to. It draws each 16x16 block
        as two 16x8 blocks. i.e. the subroutine is called twice per glyph.
  r1 -- Stores an address in RAM with the values (see below) of the
        16x8 block to draw, one row per byte. The data begins at 0x03007DDC
  r2 -- The palette color to use.
  r3 -- A flag of some sort.
0x000BEC2C is called from:
-0x080B635E
-0x080B636E
-0x080BEC14 <-- It looks like this and 0x080BEC20 are the primary call sites.
-0x080BEC20

0x007DBB50 -- This stores all the possible halfwords for a glyph. This is crazy.
In r1 of the subroutine, it stores a bunch of bytes. Each byte represents 8 pixels
in the glyph. The glyph is then drawn by reading the bytes, indexing into the values
here and finding the appropriate 4 byte value. For example, consider a tile
00111100
00100100
00100100
00100100
00100100
00100100
00100100
00111100
We would convert each row to a number from 0 to 255, look up the byte pattern here
at 0x007DBB50 and copy that over. WTF.

0x000BEBD8 -- Beginning subroutine that writes to the 0x03007DDC area with the
  numerical value of each row. r0 stores 0x086035AC, the base address for glyphs
  data in the ROM. It then branches to 0x000BEC2C to update the ram in the 0x020381D8 area.
  We want to hijack this.
  r1 and r2 are the address in the 0x020381D8 RAM that need to be updated and are
  passed in.
  r3 is the table value of the glyph.
Call sites are:
-0x0009B57E
-0x0009B7B4
-0x0009B86A
-0x000B67D8

PLAN OF ATTACK: Hijack 0x000BEBD8 to update data at 0x03007DDC with the appropriate
  shifts for a given character. We then need to make sure that the object tile where
  the data is copied over to isn't incremented until we've filled the tile. This is done
  by modifying the r0 that gets passed in to 0x000BEC2C.

0x03007E18 stores the address of the next glyph in the script to draw. However,
this is actually a reference to the stack. In particular, [sp, 0x0C] is where the
address is...

0x000B6842 is where the address of the next glyph is incremented and updated.


80B1B72 to 80B1BA4 does sprite drawing for item icons
80B5E0A is roughly the area where sprite drawing is done for item names.
0x3007E48 is where the glyphs for item names is stored.
item names are stored as tiles, not sprites!

The only sprite things are in the menu. Most other text are tiles.
