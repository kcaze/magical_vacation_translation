; 0x080B6108
; r0 = looks like address of beginning of glyph data to render.
; r1 = number of glyphs to render

; 0x080B61D4
; r4 = ???
; r5 = pointer to two rom addresses: tiles and scratch address. Expectation is
; draw tile data to location pointed by [r5, 0x04] and them DMA that over to the tiles address
; in [r5, 0x00]
; r6 = glyph stored as words with a F or'd into the 4th nibble. Not sure why
; this weird format.

; 0x0203B6CA
; Thing that computes how many glyphs to draw? There's some sort of load balancing
; so that the call to 0x080B6108 doesn't block. 0x0203B6CA is a byte storing the
; total number of glyphs to draw. Each byte before that tells how many bytes
; 0x080B6108 should render. It always renders 4 times and divides the number of
; glyphs equally. We should only care about the total number of glyphs.
;
; Format of glyphs 0x02036604 = one row is 20 words. Since each glyph is 12x12,
; this means each row is 240 pixels, i.e. the width of the gba screen.
; There should be 10 rows, each row being 16 pixels tall, since gba screen is 160 = 10*16 pixels tall.

; 0x0203CF80
; Tile indices that will be DMA'd to BG1

.gba
.open "hacked.gba", 0x08000000

.macro pushreg
  push r4-r7,lr
  mov r5, r8
  mov r6, r9
  mov r7, r10
  push r5-r7
.endmacro

.macro popreg
  pop r3-r5
  mov r8, r3
  mov r9, r4
  mov r10, r5
  pop r4-r7
.endmacro

FN_RAM_CLEAR equ 0x0800D020
FN_VWF equ 0x0800D060
FN_ICON equ 0x0800D370

ADDR_GLYPH  equ 0x020097B0
ADDR_DMA    equ 0x040000D4
ADDR_TILE    equ 0x06008000
ADDR_RAM_BG1    equ 0x0203CF80
START equ 0x080B6112
END equ 0x080B6258

L_vwf_menu:
.org START
.area END - START
mov r7, 0x00 ; r7 = outer loop counter
mov r8, r0 ; r8 = glyph address

@@L_loop:
mov r0, 0x00
bl FN_RAM_CLEAR

mov r5, 0xFF ; r5 = x tile coordinate
mov r6, 0x00 ; r6 = inner loop counter
@@L_inner_loop:
mov r0, r8
ldr r0, [r0]
lsl r0, 0x10
lsr r0, 0x10
cmp r0, 0x00
beq @@L_inner_loop_end
cmp r5, 0xFF
bne @@L_not_first_nonzero
mov r5, r6
@@L_not_first_nonzero:

mov r1, 0x0F ;TODO currently hardcoding palette value. Need to find where this stored.
mov r2, 0x00 ; bg palette
bl FN_VWF
mov r9, r0 ; r9 = copy of return value

; copy glyph data to tiles
@@L_tile_loop:
; DMA glyph data to tiles2
ldr r2, =ADDR_GLYPH
lsl r1, r0, 0x06
add r2, r2, r1 ; r2 = glyph address
ldr r3, =ADDR_TILE
add r1, r5, r0
lsl r1, r1, 0x05
add r3, r3, r1
lsl r1, r7, 0x0B
add r3, r3, r1 ; r3 = tile address
ldr r4, =ADDR_DMA
str r2, [r4]
str r3, [r4, 0x04]
ldr r1, =0x80000010
str r1, [r4, 0x08]
ldr r1, [r4, 0x08]

add r2, 0x20
ldr r1, =0x0400
add r3, r3, r1
str r2, [r4]
str r3, [r4, 0x04]
ldr r1, =0x80000010
str r1, [r4, 0x08]
ldr r1, [r4, 0x08]

; Update bg1 in RAM.
ldr r1, =ADDR_RAM_BG1
add r2, r5, r0
mov r3, 0x1E
mul r3, r7
lsl r3, r3, 0x01
add r3, r3, r2
lsl r3, 0x01
lsl r4, r7, 0x06
add r2, r2, r4
strh r2, [r1, r3]
mov r4, 0x1E
lsl r4, r4, 0x01
add r3, r3, r4
mov r4, 0x01
lsl r4, r4, 0x05
add r2, r2, r4
strh r2, [r1, r3]

sub r0, 0x01
cmp r0, 0x00
bge @@L_tile_loop

; Update ADDR_GLYPH
mov r0, r9
lsl r3, r0, 0x06
ldr r1, =ADDR_DMA
ldr r2, =ADDR_GLYPH
add r3, r2, r3
str r3, [r1]
str r2, [r1, 0x04]
ldr r3, =0x80000020
str r3, [r1, 0x08]
ldr r3, [r1, 0x08]
add r2, 0x40
mov r3, 0x00
str r3, [r2]
str r2, [r1]
str r2, [r1, 0x04]
ldr r3, =0x81000040
str r3, [r1, 0x08]
ldr r3, [r1, 0x08]

; Update x tile coordinate
add r5, r5, r0

@@L_inner_loop_end:
mov r0, r8
add r0, 0x04
mov r8, r0
add r6, 0x01
cmp r6, 0x14
blt @@L_inner_loop

add r7, 0x01
cmp r7, 0x0A
blt @@L_loop

@@L_return:
; Clear 0x0203B6CA so that this subroutine isn't called 4 times.
mov r0, 0x00
ldr r1, =0x0203B6C6
strh r0, [r1]
strh r0, [r1, 0x02]
strb r0, [r1, 0x05]
b END

.pool
.close

; TODO: This routine should only be called once, not four times. Fix that.
