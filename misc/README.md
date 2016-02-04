RAM locations:
0x02032908 - Current panel number.
0x02036120 - Name
0x02036018 - Letters in name select.
0x02032908 - Index into Letters
0x02036140 - Number of rows scrolled down.
0x0203614A - Number of rows in page.
0x02036158 - Current panel number and also cursor position.
0x0203CAC0 - Buttons pressed
0x0203DD90 - OAM attributes
0x0203BBF0 - Cursor x and y

0x080A3CDC -- General input handling routine?

0x080BCA70 -- routine for updating cursor in response to button press
arguments:
r0 = 0x02032908 (index)
r1 = 0x02036140 (rows)
r2 = 0x0203CAC0 (buttons)
r3 = 0xB (indices per row)
[sp, 0x00] = max index per page.
[sp, 0x04] = max extra rows.
[sp, 0x08] = panel (hiragana, katakana, etc)

0x080BCA70 -0x080BCA8A: push registers, move arguments around
  r5 = r0 = index
  r7 = r3 = 0xB (???)
  r8 = r1 = rows
  r4 = r2 = buttons
  r0 = [sp, 0x00]
  r1 = [sp, 0x04]
  r2 = [sp, 0x08]

0x080BCB04 = move down normally
0x080BCB1A = move down at the bottom of the page
0x080BCB4A = move left normally
0x080BCBA0 = move right normally
0x080BCBC0 = move right skip over space
0x080BCBCE = nop

move panel up: 0x080BC596
move panel down: 0x080BC5C8
