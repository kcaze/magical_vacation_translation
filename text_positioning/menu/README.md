Addresses
=========
0x087C2254 contains offsets into text. Byte offsets into 0x087C2254.
The text here is not fixed width so there is a table at the beginning
of each section to give indices for the beginning of words.

0x00000010 = N/A
0x00000048 = Menu text offset table (0x087C229C)
0x00000370 = Menu text (0x087C25C4)
0x00001F3C = Explanations [解説] offset table (0x087C4190)
0x00002374 = Explanations [解説] (0x087C45C8)
0x000091DC = Magic notebook offset table (0x087CB430)
0x0000927C = Magic notebook (0x087CB4D0)
0x0000B188 = Bestiary offset (0x087CD3DC)
0x0000B3C8 = Bestiary (0x087CD61C)
0x00015814 = Species descriptions offset (0x087D7A68)
0x00015840 = Species descriptions (0x087D7A94)
0x0001653C = MD dictionary section names offset (0x087D8790)
0x000165B4 = MD dictionary section names (0x087D8808)
0x00017DB4 = Name selection kanji offset table (0x087DA008)
0x00017F1C = Name selection kanji (0x087DA170)
0x00018CD8 = Initial element descriptions offset table (0x087DAF2C)
0x00018CF4 = Initial element descriptions (0x087DAF48)
0x000194F4 = N/A

Location of Text Data
=====================
Menu text lies between 0x087C229C and 0x087C418F.
0x087C229C to 0x087C25C4 is the header for the menu text.
The remaining part is the menu data.

0x087C2254 to 0x87CC229B is a bunch of offset into text tables, and the offsets
are computed in a short subroutine at 80BE330.


0x080BD520: Subroutine to compute the address of a piece of menu text. r1 = menu section, r0 = index into the section.
