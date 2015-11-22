Location of Text Data
=====================
0x7C2250 to 0x7C25C4 is the header for the menu text.
Menu text goes up to 0x7C3E18
0x007C2650 area is where the text is stored.

Font Hacking
============
0x080B67D8 calls 0x080BEBD8 which writes glyph data into RAM.
0x80BEC2C is then called.

We're going to use a fixed width font here.
Hijacked 0x080BEBD8 to call our own function.

DMA transfer to OAM is at 0x080B6726
