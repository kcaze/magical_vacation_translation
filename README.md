NOTE: This is out of date. I'm allowing things to spill past 0x087FFFFF for now
      and then repacking everything at the end.


Allocation of extra memory from 0x087DF750 to 0x087FFFFF
`0x087DF750 -- 0x087E2110`: Monster names
`0x087E2110 -- 0x087E5950`: Place names
`0x087E5950 -- 0x087F5950`: Bestiary descriptions
`0x087F5950 -- 0x087F59B0`: Custom newline control character function
`0x087F59B0 -- 0x087F5A10`: VWF menu clear tiles function
`0x087F5A10 -- 0x087F5BB0`: Main VWF menu function
`0x087F5BB0 -- 0x087F5C30`: x-coordinate update function for VWF sprite
`0x087F5C30 -- 0x087F5F30`: VWF script handlers
`0x087F5F30 -- 0x087F6130`: Main VWF script function
`0x087F6130 -- 0x087F6330`: VWF sprite function

Layout of game:
`0x08106320 -- 0x0810655B`: Table for overworld character sprites. Each entry
  in the table is 4 bytes. The first 2 represent some information about the
  sprite (unsure what). The last 2 are address offsets for the sprite.
`0x0810655C -- 0x0813FC3B`: Overworld sprites
`0x0813FC3C`
