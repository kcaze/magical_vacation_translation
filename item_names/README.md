3007E0C <-- where glyph data is stored in ram.
3007E50 <-- this stores two u16's, the x coordinate and y coordinate of the next 16x16 glyph to dma, in pixels. It's updated at 80B64BC by the return value of 80BF9AC

80B62F4 -- This is the function that we want to hijack.
Parameters are r2 = glyph value. Copies the glyph data into [sp]
r5 is also important.

DMAs to copy into tile is
80A0BC2 <-- This copies new data into tiles 2 for the top half
80B61E8 <-- This DMA is used for some of the text welding since the game takes two 16x16 and welds them into a 16x24.

2036924 stores the destination of the DMA for 80A0BC2. This is updated
at 80BD854, called from 80B618A.

0x000BEC2C -- Beginning of subroutine for drawing glyph data to obj tiles:
  r0 -- Address in RAM to write the next glyph data to. It draws each 16x16 block
        as two 16x8 blocks. i.e. the subroutine is called twice per glyph.
  r1 -- Stores an address in RAM with the values (see below) of the
        16x8 block to draw, one row per byte. The data begins at 0x03007DDC
  r2 -- The palette color to use.
  r3 -- A flag of some sort.



Subroutines to understand:
0x080BEC84: Unsure what this does. It looks like some crazy crazy stack manipulation. I think this is what does the text welding.
0x080B6388: Does some sort of RAM clearing stuff.
0x080BEC2C: This unpacks 1bpp glyph data into 4bpp.


Rough outline
=======
*Disable DMA at 0x080A0BCA.

*Hijack 0x080B62F4, the subroutine that takes a glyph value and
converts it into the 4bpp tile data and stores it in RAM. This is
called for each glyph in order and so we branch to our VWF
routine here.

*In the call to 0x080B62F4, r0 can be used to compute the tile index
the game originally expects to draw the glyph to and r2 contains the
glyph data.

*In our VWF, we store 4 variables in RAM: the index of the tile to
draw to (a halfword), the number of pixels remaining from the previous call to our vwf routine, the last glyph of the previous call to our
vwf routine, and finally a begin of string flag. Each item string has
an ending EOF character which indicates for the begin of string flag
to be set. This way, we can use r1 to get the correct beginning tile
index when we begin to draw a string.

*Edge cases: If ([r0] == 0x06008000), then this is some weird empty call the game does. Ignore it and just return. It's important that we do not disable the begin of string flag.

0x0203FFF4: index of tile to draw to (2 bytes)
0x0203FFF6: number of pixels remaining (1 byte)
0x0203FFF7: remaining glyph's value (1 byte)
0x0203FFF8: flag set to 0 if beginning of a string (1 byte)
