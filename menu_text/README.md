Location of Text Data
=====================
Menu text lies between 0x087C229C and 0x087C418F.
0x087C229C to 0x087C25C4 is the header for the menu text.
The remaining part is the menu data.

0x087C2254 to 0x87CC229B is a bunch of offset into text tables, and the offsets
are computed in a short subroutine at 80BE330.

Font Hacking
============
Using a fixed width font. Hijack the call at 0x080BEBD8 to call our own
function to copy over glyph data into the RAM. This is a relatively easy
hack.
