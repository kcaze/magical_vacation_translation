Thick font is at 0x06C8A3C. Stored in 8x8 blocks in rows of 32 blocks.

0x006C7E48 to 0x006C7E67: List of cutscene text offsets.
0x006C7E48 - 0x006C8A3B: Cutscene text.

Some useful function addresses:
0x0809B0E0: Processes glyphs, handling control characters and such I think.
0x080BEF68: Copies script from gamepak ROM to IWRAM area. r0 = destination, r1 = source
0x0809B6D8: Draws glyph.
            r0 = address of pointer to object tile location, r1 = destination, r2 = glyph value
0x0809B2B0: Main function that handles the entire text process.
            [sp, 0x18] = address of object tile for current glyph
            [sp, 0x30] = ram location for current glyph data

Memory locations:
0x0203238C {
  ??? [4 bytes]
  initial x coord [2 bytes]
  initial y coord [2 bytes]
}
