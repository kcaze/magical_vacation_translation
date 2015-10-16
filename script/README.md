Script Addresses
=======
0x0062C912 to 0x00699450 is the main script.
Game considers 0x00629A2C to be the base address of the script.

Control Characters
==================
* `80`: Newline
* `91`: Begin using special katakana set.
* `8E`: Begin using red font.
* `82`: ??? (perhaps used to indicate progress in the game?)
* `8D`: End using special font (ends 0x8E, 0x8F, 0x90, and 0x91).
* `86 XX`: Display character `XX`'s name.
* `87 XX`: Display item `XX`'s name (I think).
* `8B XX`: Display character portrait `XX`.
* `85 00`: Display player's name.

`0x00699478`: Some giant address pool. Unsure what these actually point to or
if they are relevant to the script.

0998f1
0b9c05:
0b9c3d


0x02009720 and 0x020097A0 -- RAM holding location of script that current dialogue is reading from. 0x02009720 is the one that gets incremented after each character is drawn.
0x0200999C -- RAM holding the end of the current dialogue.
0x0000C18E -- Updating the script by 0x2 each read.
A lot of names are stored in the 0x0022A000-ish area. E.g. ピスタチオ begins at 0x0022A2BC


0x629A2C to 0x62C6A6-- Offsets into the script for specific dialogue. Each halfword indicates an index into the script. The halfwords are stored in increasing order in "sections". Once one "section" is finished, they start over again at 0x0000 but these are now offsets into the script base address + (number of sections read) * 0x10000. Things are packed VERY tightly. The next offset into the script indicates the end of the current one. There is no separate "end" offset and hence also no control code in the dialogue to indicate the end.
