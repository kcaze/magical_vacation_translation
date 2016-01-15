.gba
.open "hacked.gba", 0x08000000
ADDR_FONT   equ 0x08603900
ADDR_WIDTHS equ 0x08604100
ADDR_SHIFT equ 0x0203FFF1
ADDR_VAR_FONT_SET equ 0x203FFF2
ADDR_FN_UPDATE_X equ 0x087F5BB0
ADDR_FN_VWF_SPRITE equ 0x087F6130

; The sprite drawing is lazy and it finds the first glyph that differs before
; drawing. Unfortunately, it ands the glyph with 0x0FFF so we may have two
; English glyphs that are different but the game treats the same. E.g. 0x4320
; 0x7320 would be considered the same so the game wouldn't update. We force the
; game to not be lazy by unconditionally jumping.
; TODO: This fix is pretty CPU intensive. It'd be better if we could just get
; the to compare the full 16 bits of the glyphs.
.org 0x080B66B4
b 0x080B6720

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
ldr r3, =ADDR_SHIFT
ldrb r3, [r3]
add r0, r0, r3
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
.org ADDR_FN_VWF_SPRITE
.area 0x200
push r0-r7

; Swap glyph values and store in r7.
mov r7, 0xFF
and r7, r3
lsr r3, r3, 0x08
lsl r7, r7, 0x08
cmp r3, 0x1F
bne L_not_bos
ldr r0, =ADDR_SHIFT
mov r1, 0x00
strb r1, [r0]
L_not_bos:
cmp r7, 0x1F
bne L_not_bos2
ldr r0, =ADDR_SHIFT
mov r1, 0x00
strb r1, [r0]
L_not_bos2:
orr r7, r3

mov r2, 0xFF
and r2, r7
cmp r2, 0x1D
; Change font set
bne L_not_font_set
lsr r7, 0x08
ldr r2, =ADDR_VAR_FONT_SET
strb r7, [r2]
ldr r0, =ADDR_SHIFT
mov r1, 0x00
strb r1, [r0]
str r1, [sp, 0x00]
str r1, [sp, 0x04]
str r1, [sp, 0x08]
str r1, [sp, 0x0C]
str r1, [sp, 0x10]
str r1, [sp, 0x14]
str r1, [sp, 0x18]
str r1, [sp, 0x1C]
b L_return
L_not_font_set:

ldr r2, =ADDR_WIDTHS
ldr r3, =ADDR_VAR_FONT_SET
ldrb r3, [r3]
; Add 0x900 * font set to the widths address
lsl r3, 0x08
add r2, r2, r3
lsl r3, 0x03
add r2, r2, r3

; r0 = first glyph value
; r1 = second glyph value
; r5 = width of first glyph + 1
; r6 = width of second glyph
mov r0, 0xFF
and r0, r7
lsr r1, r7, 0x08
mov r5, 0x00
mov r6, 0x00
cmp r0, 0x20
blt L_not_drawable1
ldrb r5, [r2, r0]
add r5, r5, 0x01
L_not_drawable1:
cmp r1, 0x20
blt L_not_drawable2
ldrb r6, [r2, r1]
L_not_drawable2:

lsl r0, r0, 0x04
lsl r1, r1, 0x04
ldr r2, =ADDR_FONT
add r2, r2, r3 ; r3 is 0x800 * font set
lsr r3, 0x03
add r2, r2, r3
add r0, r0, r2
add r1, r1, r2
; r4 = mask
mov r3, 0x08
sub r3, r5
mov r2, 0x01
lsl r2, r3
sub r2, 0x01
lsl r2, r5
mov r4, 0x00
add r4, r2, r4
lsl r4, 0x08
add r4, r2, r4
lsl r4, 0x08
add r4, r2, r4
lsl r4, 0x08
add r4, r2, r4

ldr r2, [r1, 0x00]
lsl r2, r5
mov r3, r4
and r3, r2
ldr r2, [r0, 0x00]
orr r2, r3
str r2, [sp, 0x20]
ldr r2, [r1, 0x04]
lsl r2, r5
mov r3, r4
and r3, r2
ldr r2, [r0, 0x04]
orr r2, r3
str r2, [sp, 0x24]
ldr r2, [r1, 0x08]
lsl r2, r5
mov r3, r4
and r3, r2
ldr r2, [r0, 0x08]
orr r2, r3
str r2, [sp, 0x30]
ldr r2, [r1, 0x0C]
lsl r2, r5
mov r3, r4
and r3, r2
ldr r2, [r0, 0x0C]
orr r2, r3
str r2, [sp, 0x34]

; r4 = mask
add r2, r5, r6
mov r4, 0x00
cmp r2, 0x08
blt no_mask
mov r3, 0x7
and r3, r2
mov r2, 0x01
lsl r2, r3
sub r2, 0x01
mov r4, 0x00
add r4, r2, r4
lsl r4, 0x08
add r4, r2, r4
lsl r4, 0x08
add r4, r2, r4
lsl r4, 0x08
add r4, r2, r4
no_mask:

; r5 = 8 - first glyph width
sub r5, 0x08
neg r5, r5

ldr r2, [r1, 0x00]
lsr r2, r5
mov r3, r4
and r3, r2
str r3, [sp, 0x28]
ldr r2, [r1, 0x04]
lsr r2, r5
mov r3, r4
and r3, r2
str r3, [sp, 0x2C]
ldr r2, [r1, 0x08]
lsr r2, r5
mov r3, r4
and r3, r2
str r3, [sp, 0x38]
ldr r2, [r1, 0x0C]
lsr r2, r5
mov r3, r4
and r3, r2
str r3, [sp, 0x3C]

; Store shift for next sprite
sub r5, 0x08
neg r5, r5
add r5, r5, r6
lsr r7, 0x08
cmp r7, 0x20
blt no_space
add r5, 0x01
no_space:
ldr r0, =ADDR_SHIFT
strb r5, [r0]

; Branch back to 0x080BEC0C to restore execution to the game
L_return:
  pop r0-r7
  add r5, sp, 0x10 ; Necessary in the original function, but branched over.
  ldr r0, =0x080BEC0C
  mov r15, r0

.pool
.endarea

.close
