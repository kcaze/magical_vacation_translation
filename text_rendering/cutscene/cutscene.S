.gba
.open "hacked.gba", 0x08000000

ADDR_FONT equ 0x086C8A3C
ADDR_WIDTHS equ (0x086C8A3C + 0x4000)
ADDR_DMA    equ 0x040000D4
FN_CUTSCENE equ 0x08810200 ;TODO -- Remap addresses at the end
FN_X_COORD equ 0x08810400 ;TODO -- Remap addresses at the end

.org 0x0809B1D0
mov r1, 0x42 ; really stupid hack since there's no space. set r1 = 0x42 to indicate we're in normal glyph case.
ldr r0, =FN_CUTSCENE
mov r15, r0
.pool

.org FN_CUTSCENE
cmp r1, 0x42
beq L_normal_glyph

L_control_code:
add r7, r7, 0x01
add r5, 0x02
add r6, 0x02
cmp r7, r8
ldr r0, =0x0809B1DF
mov r15, r0

L_normal_glyph:
mov r0, 0xFF
and r0, r2
lsl r0, r0, 0x08
strh r0, [r5]
lsr r0, r2, 0x08
lsl r0, r0, 0x08
strh r0, [r5, 0x02]
add r7, r7, 0x01
add r5, 0x04
add r6, 0x02
cmp r7, r8
ldr r0, =0x0809B1DF
mov r15, r0
.pool

; Have the game treat glyphs less than 0xF0F0 as valid glyphs.
.org 0x0809B128
.word 0x0000F0F0
.org 0x0809B370
.word 0x0000F0F0

; Variable width x-coordinate update
.org 0x0809B5CC
ldr r0, =FN_X_COORD
mov r15, r0
.pool

.org FN_X_COORD
mov r2, r13
ldr r0, =ADDR_WIDTHS
ldr r1, [r2, 0x08]
ldrb r1, [r1, 0x01]
ldrb r0, [r1, r0]
ldrh r1, [r2, 0x0C]
add r1, r0, r1
add r1, 0x02
strh r1, [r2, 0x0C]

ldr r0, =0x0809B5D7
mov r15, r0
.pool

.close
