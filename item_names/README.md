3007E0C <-- where glyph data is stored in ram.
3007E50 <-- this stores two u16's, the x coordinate and y coordinate of the next 16x16 glyph to dma, in pixels. It's updated at 80B64BC by the return value of 80BF9AC

80B62F4 -- This is the function that we want to hijack.
Parameters are r2 = glyph value. Copies the glyph data into [sp]

DMAs to copy into tile is
80A0BC2 <-- This copies new data into tiles 2 for the top half
80B61E8 <-- This DMA is used for some of the text welding since the game takes two 16x16 and welds them into a 16x24.

2036924 stores the destination of the DMA for 80A0BC2. This is updated
at 80BD854, called from 80B618A.

Outline
=======
Hijack 80B62F4.
Disable the DMA at 80A0BC2 and manually DMA in our hijack.
Disable the x-coordinate increment at 80B64BC and also handle that
ourselves.
