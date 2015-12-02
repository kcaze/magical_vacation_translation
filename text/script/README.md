Translation Notes
=================
*Cider is a romanticist. He should sound a bit like Shakespeare.
*Candy is a valley girl.
*Kirsche is a hothead. Maybe it makes sense to sound a bit like a cowboy, idk.
*Maybe "ancient spirit" should be "antiquity spirit"?


Script Addresses
=======
0x00629A2C to be the base address of the script, including offsets.
0x0062C912 to 0x00698E9A is the main script.

Icons
=====
0x0000 to 0x000E inclusive draws various icons instead of text. The icons are
rendered as sprites rather than tiles.
* `0000`: Exclamation point.
* `0001`:
* `0002`: Frog.
* `0003`: Tail.
* `0004`: Bomb.
* `0005`: Headgear.
* `0006`: Armwear.
* `0007`: Bodywear.
* `0008`: Shoes.
* `0009`: Bracelet.
* `000A`:
* `000B`: Seal.
* `000C`:
* `000D`: Book.
* `000E`: Coin.

Control Characters
==================
* `80`: Newline. Function located at `0x0000BA58`. We're overriding this to also perform some cleanup work for our own routine.
* `82`: ??? (perhaps used to indicate progress in the game?)
* `85 00`: Display player's name
* `86 XX`: Display character `XX`'s name.
* `87 XX`: Display item `XX`'s name (I think). `0x0000BC9C` We're overriding this to double the maximum length of names.
* `8B XX`: Display character portrait `XX`.
* `8D`: End using special font (ends 0x8E, 0x8F, 0x90, and 0x91).
* `8E`: Begin using red font.
* `8F`: Begin using blue font.
* `91`: Begin using special katakana set.
* `FF`: Ends dialogue?

0x629A2C to 0x62C6A6-- Offsets into the script for specific dialogue. Each halfword indicates an index into the script. The halfwords are stored in increasing order in "sections". Once one "section" is finished, they start over again at 0x0000 but these are now offsets into the script base address + (number of sections read) * 0x10000. Things are packed VERY tightly. The next offset into the script indicates the end of the current one. There is no separate "end" offset and hence also no control code in the dialogue to indicate the end.

0x0000B564 -- Beginning of subroutine to load next dialogue text. The parameter r0 passed indicates which offset to use.
0x0000B818 -- Does the comparison for control characters.
  0x0000B82C -- FF control character. Branches to 0x0000C2F6.
  0x0000B844 -- Function jump table of control codes, goes from 0x80 to 0xA6 (0x26 control codes total).
  NOTE: I can override some of the jump tables to define my own control codes!!!
0x0000C18E -- Updating the script by 0x2 each read.

0x0000B564 is called at 0x0001CDA4
The beginning of the subroutine for that is at 0x0001CD5C, which is called from
  -0x00000D4C
  -0x00001062
  -0x000170BC
  -0x00017152
  -0x0001CB1C
  -0x0001CCD4
  -0x0001CD0E
  -0x0001CD48
  -0x0001CDA4
  -0x00023700

0x02009720 and 0x020097A0 -- RAM holding location of script that current dialogue is reading from. 0x02009720 is the one that gets incremented after each character is drawn.
0x0200999C -- RAM holding the end of the current dialogue.

`0x00699478`: Some giant address pool. Unsure what these actually point to or
if they are relevant to the script.

0998f1
0b9c05:
0b9c3d
