Location of Text Data
=====================
Menu text lies between 0x087C229C and 0x087C418F.
0x087C229C to 0x087C25C4 is the header for the menu text.
The remaining part is the menu data.

Font Hacking
============
Using a fixed width font. Hijack the call at 0x080BEBD8 to call our own
function to copy over glyph data into the RAM. This is a relatively easy
hack.
