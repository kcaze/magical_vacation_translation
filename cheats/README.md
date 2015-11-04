0x02000360 stores lots of information.
Change 0x02000362 from 0x01 to 0x00 and you can walk through walls.

Looks like 0x02000340 stores the index of the current room. Put a breakpoint at 0x0801CEF0 and then change the value to warp to a different room.
0x80035C0 does the room loading?
I brute force tried warping to the first 256 rooms and there were a couple suspicious rooms:
-0x9F: Seems completely blank.
-0x42: Blank but with lots of Konjac cubes that seem to give random dialogue.
-0x18: Seems like an actual room in the game, but I can't talk to anyone.
Other room notes:
0x0115: Credit roll
There's a lot of blank rooms up until 0x0157, at which point it looks like there
are actual rooms again. Around 0x01E0 is the end of the room data. Trying to go
beyond that probably tries to interpret non-room data as a room, causing weird
glitchy things to happen.
