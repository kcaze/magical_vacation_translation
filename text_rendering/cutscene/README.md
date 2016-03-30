Thick font is at 0x06C8A3C. Stored in 8x8 blocks in rows of 32 blocks.

0x006C7E48 to 0x006C7E67: List of cutscene text offsets.
0x006C7E48 - 0x006C8A3B: Cutscene text.

Some useful function addresses:
0x0809B0E0: Processes glyphs, handling control characters and such I think.
0x080BEF68: Copies script from gamepak ROM to IWRAM area. r0 = destination, r1 = source
0x0809B6D8: Draws glyph.
            r0 = address of pointer to object tile location, r1 = destination, r2 = glyph value
0x080989E8: DMAs glyph data to object tiles.
0x0809C3E8: Does some OAM setting
0x0809B2B0: Main function that handles the entire text process.
            [sp, 0x08] = address of current glyph
            [sp, 0x0c] = x coord of current glyph
            [sp, 0x0e] = y coord of current glyph
            [sp, 0x18] = address of object tile for current glyph
            [sp, 0x1c] =
            [sp, 0x20] = number of glyphs?
            [sp, 0x30] = ram location for current glyph data
0x0809B1EC: Unsure what this does, but line scrolling happens here.
0x0809AF30: Initial setup each cutscene? x coordinate and stuff stored here.

Memory locations:
0x020323BC = Glyph data in RAM
0x0203DD90 = OAM data in RAM
0x020326BE = Number of glyphs to draw
0x0202DE98 = initial x coordinate and y coordinate
0x0203238C {
  ??? [4 bytes]
  initial x coord [2 bytes]
  initial y coord [2 bytes]
}

0x080C2624 = location of some cutscene data.
