Location of control character routine switchboard: 0x0800B844.
There are control codes for 0x80 up to 0xFE. Only control codes 0x80 up to 0x99
are in use it appears.
0x80: 0x0800BA58 Newline
0x81: 0x0800BA94 (apparently unused)
0x82: 0x0800BADC Force an A-button press for the next character in the dialogue.
0x83: 0x0800BB00 Prefix for selection items
0x84: 0x0800BB90 Display hand cursor for selection. Goes at the end of dialogue.
0x85: 0x0800BC20 Player's name, takes byte argument for some reason.
0x86: 0x0800BC78 Display character name, takes byte argument
0x87: 0x0800BC9C Display item name, takes byte argument
0x88: 0x0800BCB4 (apparently unused)
0x89: 0x0800BCD8 (apparently unused)
0x8A: 0x0800BCFC (apparently unused)
0x8B: 0x0800BD20 Display character portrait, takes byte argument
0x8C: 0x0800BDD4 (apparently unused)
0x8D: 0x0800BEE0 Reset text color.
0x8E: 0x0800BEE0 Set text color to red.
0x8F: 0x0800BEE0 Set text color to blue.
0x90: 0x0800BEE0 (apparently unused)
0x91: 0x0800BF10 Set text to italics kana.
0x92: 0x0800BEE0 (apparently unused)
0x93: 0x0800BF84 Display current bura.
0x94: 0x0800BFB0 Displays variable item dependent on register.
0x95: 0x0800BF28 (apparently unused)
0x96: 0x0800BF28 (apparently unused)
0x97: 0x0800BF28 (apparently unused)
0x98: 0x0800BF54 (apparently unused)
0x99: 0x0800C2F6 (apparently unused)

Some of my custom control codes (values in the range [0x10, 0x1F])
0x1C align to grid boundary for next character. used in vwf_menu to space text
     properly in name select.
0x1D switch font set. Takes a byte argument for the font set to switch to.
0x1E newline cleanup for vwf_menu. used so that position is recalibrated after a
     newline.
0x1F beginning of string marker, inserted so that RAM is reset properly. Takes
     an additional byte argument for the font set to switch to.
