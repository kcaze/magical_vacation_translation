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

Outline
=======
Hijack 80B62F4.
Disable the DMA at 80A0BC2 and manually DMA in our hijack.
Disable the x-coordinate increment at 80B64BC and also handle that
ourselves.


Subroutines to understand:
0x080BEC84: Unsure what this does. It looks like some crazy crazy stack manipulation. I think this is what does the text welding.
0x080B6388: Does some sort of RAM clearing stuff.
0x080BEC2C: This unpacks 1bpp glyph data into 4bpp.
