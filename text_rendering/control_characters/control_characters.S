.gba
.open "hacked.gba", 0x08000000

ADDR_GLYPH  equ =0x020097B0
ADDR_SHIFT  equ =0x0203FFF0
ADDR_DMA    equ =0x040000D4
ADDR_SCRIPT_TILE_INDEX equ =0x02009954
ADDR_SCRIPT_X          equ =0x02009930

ADDR_CONTROL_CHAR_TABLE equ 0x0800B844
ADDR_FN_NEWLINE equ 0x087F5950

FN_ICON_JUMP equ 0x0800C060
FN_ICON_UPDATE equ 0x08815000
FN_ICON_JUMP2 equ 0x0800C008
FN_ICON_UPDATE2 equ 0x08816000


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

; Handle icon shifts properly, inserting the proper spacing for the next character.
.org FN_ICON_JUMP
ldr r0, =FN_ICON_UPDATE
mov r15, r0
.pool

.org FN_ICON_UPDATE
; Update shift
ldr r1, ADDR_SHIFT
ldrb r0, [r1]
add r0, 0x0D
mov r6, 0x7
and r6, r0
strb r6, [r1]
lsr r0, r0, 0x03
ldr r1, ADDR_SCRIPT_X
ldrh r6, [r1]
add r6, r6, r0
strh r6, [r1]
ldrh r0, [r1]

; Update tile index
ldr r1, ADDR_SCRIPT_TILE_INDEX
ldrh r6, [r1]
add r6, 0x02
strh r6, [r1]


ldr r6, =(FN_ICON_JUMP + 0x09)
mov r15, r6
.pool

; Position the icon's x-coordinate properly.
.org FN_ICON_JUMP2
ldr r4, =FN_ICON_UPDATE2
mov r15, r4
.pool

.org FN_ICON_UPDATE2
add r0, r0, r2
add r0, 0x07
ldr r4, ADDR_SHIFT
ldrb r4, [r4]
add r0, r0, r4
ldr r4, =(FN_ICON_JUMP2 + 0x09)
mov r15, r4
.pool

.close
