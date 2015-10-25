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

Writing sprite text to object tile via DMA:
0x000A0D36

The sprite text is stored in RAM beginning at 0x020381D8. The RAM is updated at
0x000B6736 -- Clear glyph data I think.
0x000BEC56 -- Write glyph data probably.
The structure of the glyph data is interesting. There's an 8 byte header storing
two addresses followed by 128 bytes of tile data at 4bpp so that's one 16x16 block.
I.e. one glyph.

0x000BEC2C -- Beginning of subroutine for drawing glyph data to obj tiles:
  r0 -- Address in RAM to write the next glyph data to. It draws each 16x16 block
        as two 16x8 blocks. i.e. the subroutine is called twice per glyph.
  r1 -- Stores an address in the 0x03000000 RAM. Not sure what that is.
  r2 -- The palette color to use.
  r3 -- A flag of some sort.

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
