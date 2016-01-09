Outline
=======
Hijack the call at 0x080BEBD8. This is a relatively easy hack since we're
replacing the original code that copies glyph data onto the stack with our own
code that accepts 1 byte English characters and uses glyph data from the
inserted monospace font.

Disabled check that aborts if a glyph has value > 0x0FFF. We will often
have glyphs with large values because 2 English characters are packed and
read together in a single halfword.

Edited the x increment between sprites to be 0x10 instead of 0x0C. Previously,
one Japanese character was inserted into each sprite and the Japanese font is
12x12. Here, we insert to 16x8 English characters into each sprite so the total
width is 16 and not 12.
