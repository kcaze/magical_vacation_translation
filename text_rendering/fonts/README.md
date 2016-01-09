Fonts are 8x16 at 1bpp and include 128 glyphs in ASCII order. So each font takes
up 16 bytes * 128 = 0x800 bytes. The width data is 0x100 more bytes so in total,
each font takes up 0x900 bytes.


Fonts used
==========
* vwf: http://www.romhacking.net/fonts/13/
* monospace: http://www.romhacking.net/fonts/108/

A table of glyph widths for the vwf font in order to make writing vwf routines
significantly easier.

Some alternative fonts ideas:
For Pistachio: http://www.dafont.com/aardvark-cwm-type.font
For Latte: http://www.dafont.com/pixel-intv.font
