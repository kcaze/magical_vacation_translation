.gba
.open "hacked.gba", 0x08000000
ADDR_FONT   equ 0x08603900
ADDR_WIDTHS equ 0x08604100
ADDR_FN_UPDATE_X equ 0x087F5BB0
ADDR_FN_VWF_SPRITE equ 0x087F6130

; The sprite drawing is lazy and it finds the first glyph that differs before
; drawing. The game stored the palette in the highest nibble of a glyph, which
; is an issue for comparing glyphs. We fix this by making the palette read/write
; be at a different location so that we have the full glyph to compare

; This should ensure that we compare the full 16 bits. It looks like there's
; an issue updating the x-coordinate however.
.org 0x080B6656
lsl r6, r2, 0x10
.org 0x080B66A4
lsl r0, r0, 0x10

; Change where the palette is written to / read from.
.org 0x080B6670
mov r0, r9
strh r0, [r4]
mov r0, r10
ldrb r0, [r0, 0x0B]
lsl r0, r0, 0x1C
lsr r0, r0, 0x1C
strb r0, [r4, 0x08]
b 0x080B6692
.org 0x080B67CA
ldrb r0, [r1, 0x07]
nop



; Disable the check that aborts drawing if a glyph has value > 0x0FFF
.org 0x080B65C0
.word 0x0000F0F0

; Jump to our x-coordinate update function
.org 0x080B681C
ldr r3, =ADDR_FN_UPDATE_X
mov r15, r3
.pool

; x-coordinate update function
.org ADDR_FN_UPDATE_X
.area 0x80
ldr r2, =ADDR_WIDTHS
mov r3, r9
lsl r3, r3, 0x18
lsr r3, r3, 0x18
ldrb r3, [r2, r3]
add r0, r0, r3
mov r3, r9
lsr r3, r3, 0x08
ldrb r3, [r2, r3]
add r0, r0, r3
add r0, r0, 0x02

ldr r2, [sp, 0x2C]
strh r0, [r2]
lsl r0, r0, 0x10
lsr r0, r0, 0x10
ldr r3, =0x80B6826
mov r15, r3
.pool
.endarea

; Hijack the routine at 0x080BEBD8 to jump to ours
.org 0x080BEBE0
ldr r2, =ADDR_FN_VWF_SPRITE
mov r15, r2
.pool

; Our custom drawing routine
; r0 = ???
; r1 = ???
; r2 = ???
; r3 = glyph values
;
; Copies the glyph data from to [sp, 0x20]. The correspondence is like this:
;
; Font Data          Stack Data
; [00] [10]          [00] [08]
; [04] [14]  -----\  [04] [0C]
; [08] [18]  -----/  [10] [18]
; [0C] [1C]          [14] [1C]
;
.org ADDR_FN_VWF_SPRITE
.area 0x200
push r0-r7

add r7, sp, 0x20 ; r7 = base address on stack we copy to.
mov r0, 0xFF
and r0, r3

cmp r0, 0x20
blt @L_not_drawable1
cmp r0, 0x80
blt @L_drawable1
@L_not_drawable1:
mov r0, 0x00
@L_drawable1:

lsr r3, r3, 0x08
cmp r3, 0x20
blt @L_not_drawable2
cmp r3, 0x80
blt @L_drawable2
@L_not_drawable2:
mov r3, 0x00
@L_drawable2:

lsl r0, r0, 0x08
add r0, r0, r3
mov r8, r0 ; r8 = swapped glyph values

; Draw glyph 1
mov r0, 0xFF
mov r1, r8
and r0, r1 ; r0 = glyph 1 value
ldr r1, =ADDR_FONT
lsl r2, r0, 0x04
add r1, r1, r2 ; r1 = glyph 1 font address
; To copy data, ldr, lsr 0x01, str. The lsr 0x01 is to delete the leading space.
ldr r2, [r1, 0x00]
lsr r2, 0x01
str r2, [r7, 0x00]
ldr r2, [r1, 0x04]
lsr r2, 0x01
str r2, [r7, 0x04]
ldr r2, [r1, 0x08]
lsr r2, 0x01
str r2, [r7, 0x10]
ldr r2, [r1, 0x0C]
lsr r2, 0x01
str r2, [r7, 0x14]

; Draw glyph 2
mov r1, r8
lsr r1, r1, 0x08 ; r1 = glyph 2 value
ldr r2, =ADDR_FONT
lsl r3, r1, 0x04
add r2, r2, r3 ; r2 = glyph 2 font address
ldr r3, =ADDR_WIDTHS
add r3, r3, r0
ldrb r3, [r3] ; r3 = glyph1's width
mov r4, 0xFF
lsr r4, r3
lsl r4, r3
lsl r5, r4, 0x08
orr r4, r5
lsl r5, r4, 0x08
orr r4, r5
lsl r5, r4, 0x08
orr r4, r5 ; r4 = mask 111...000 (number of 1's = w)
; To copy left data, ldr, lsl (w+1), mask, orr with glyph1, str.
ldr r5, [r2, 0x00]
ldr r6, [r7, 0x00]
lsl r5, r3
and r5, r4
orr r5, r6
str r5, [r7, 0x00]
ldr r5, [r2, 0x04]
ldr r6, [r7, 0x04]
lsl r5, r3
and r5, r4
orr r5, r6
str r5, [r7, 0x04]
ldr r5, [r2, 0x08]
ldr r6, [r7, 0x10]
lsl r5, r3
and r5, r4
orr r5, r6
str r5, [r7, 0x10]
ldr r5, [r2, 0x0C]
ldr r6, [r7, 0x14]
lsl r5, r3
and r5, r4
orr r5, r6
str r5, [r7, 0x14]

; To copy right data, ldr, lsr (8 - (w+1)), mask, str
L_shift_right:
sub r3, 0x08
neg r3, r3 ; r3 = 8 - r3 = 8 - (w+1)
ldr r4, =0xFF000000
lsl r4, r3
lsr r4, r3
lsr r5, r4, 0x08
orr r4, r5
lsr r5, r4, 0x10
orr r4, r5 ; r4 = mask

ldr r5, [r2, 0x00]
lsr r5, r3
and r5, r4
str r5, [r7, 0x08]
ldr r5, [r2, 0x04]
lsr r5, r3
and r5, r4
str r5, [r7, 0x0C]
ldr r5, [r2, 0x08]
lsr r5, r3
and r5, r4
str r5, [r7, 0x18]
ldr r5, [r2, 0x0C]
lsr r5, r3
and r5, r4
str r5, [r7, 0x1C]

; Branch back to 0x080BEC0C to restore execution to the game
return:
  pop r0-r7
  add r5, sp, 0x10 ; Necessary in the original function, but branched over.
  ldr r0, =0x080BEC0C
  mov r15, r0

.pool
.endarea

.close
