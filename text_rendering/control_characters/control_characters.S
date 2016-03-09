.gba
.open "hacked.gba", 0x08000000

ADDR_GLYPH  equ =0x020097B0
ADDR_SHIFT  equ =0x0203FFF0
ADDR_DMA    equ =0x040000D4
ADDR_SCRIPT_TILE_INDEX equ =0x02009954

ADDR_CONTROL_CHAR_TABLE equ 0x0800B844
ADDR_FN_NEWLINE equ 0x087F5950

; 0x80 = newline
.org ADDR_CONTROL_CHAR_TABLE + 0x4 * (0x80 - 0x80)
.word ADDR_FN_NEWLINE
; Modify original newline routine to indent to 5 tiles in instead of 4.
.org 0x0800BA64
mov r1, 0x05
; Cleans up RAM and then branches back to original newline routine.
.org ADDR_FN_NEWLINE
.area 0x60
; Clear shift variable.
ldr r0, ADDR_SHIFT
mov r1, 0x00
strb r1, [r0]
; Clear glyph data.
ldr r0, ADDR_GLYPH
ldr r1, =0x22222222
str r1, [r0]
ldr r1, ADDR_DMA
str r0, [r1]
str r0, [r1, 0x04]
ldr r0, =0x810000C0
str r0, [r1, 0x08]
ldr r0, [r1, 0x08]
; Increment tile index
ldr r0, ADDR_SCRIPT_TILE_INDEX
ldrh r1, [r0]
add r1, 0x04
strh r1, [r0]
; Branch to original newline routine
ldr r0, =0x0800BA58
mov r15, r0
.pool
.endarea

; Modify first character in script to start 5 tiles in instead of 4.
.org 0x0800BDB2
mov r0, 0x05

; 0x93: Fix number display routine to store the right glyph values
.org 0x0800A4CA
mov r0, 0x30
add r0, r0, r1
strb r0, [r4]
add r4, 0x02
nop

; Fix x-coordinate incrementing for icons.
.org 0x0800C064
add r0, 0x02

.close
