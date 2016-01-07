`0x080B62F4 - 0x080B637C` takes in ? parameters and has no return value:
r0 = RAM address. [r0] = address in tiles2, [r0, 0x04] = ???
r1 = N/A (not a parameter)
r2 = glyph value
r3 = ????

Subroutine explanation
`0x080B62F4 - 0x080B62FA`: Push registers and allocate 0x30 stack space.
`0x080B62FC - 0x080B6304`: Set r6 = r0, r2 = pointer to glyph address.
`0x080B6306 - 0x080B6328`: Copy glyph data into stack. Also set r8 = sp + 0x18
`0x080B632A - 0x080B6338`: Call 0x080BEC84 with parameters
  r0 = sp
  r1 = sp + 0x18
  r2 = 0x7 & [ram_addr, 0xC8]
`0x080B633C - 0x080B634E`: Call 0x080B6388 with parameters
  r0 = 0x0203810C
  r1 = ram_addr + 0x08
  r2 = ram_addr + 0x68
  r3 = ([ram_addr, 0xC8] << 15) >> 22
  Also, end up incrementing r6 by 0x68
`0x080B6352 - 0x080B635E`: Call 0x080BEC2C with parameters
  r0 = ram_addr + 0x08
  r1 = sp
  r2 = (ldrb[ram_addr, 0xC8] >> 3) & 0xF
  r3 = 0x03
`0x080B6362 - 0x080B636E`: Call 0x080BEC2C with parameters
  r0 = ram_addr + 0x68
  r1 = sp + 0x18
  r2 = (ldrb[ram_addr, 0xC8] >> 3) & 0xF
  r3 = 0x03
`0x080B6372 - 0x080B637C`: Deallocate stack, pop registers and return.

RAM map:
[ram_addr, 0x00]: tile2 address to draw tile.
[ram_addr, 0x04]: ???
[ram_addr, 0x08] to [ram_addr, 0xC8]: 0xC0 bytes to hold the 4bpp glyph data.
[ram_addr, 0xC8]: A bit field for two bytes.

--------------------------------------------------------------------------------
OLD DEPRECATED INFO

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
*Copy the correct width to w/e.

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
0x0203FFF6: offset to draw glyph (2 bytes)
0x0203FFF8: initial index of tile. (2 bytes)
0x0203FFFA: newline counter (2 bytes)

0x0203692C: 0xC0 bytes of RAM that can be used to store glyph data for
            RAM. We use the first 0x10 bytes for the 1bpp representation
            and the next 0x40 bytes for the 4bpp representation.
