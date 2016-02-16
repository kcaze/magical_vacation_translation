.gba
.open "hacked.gba", 0x08000000
;--------------------;
; Macros and defines ;
;--------------------;
ADDR_GLYPH  equ 0x020097B0
ADDR_SHIFT  equ 0x0203FFF0
ADDR_VAR_FONT_SET  equ 0x0203FFF2
ADDR_DMA    equ 0x040000D4
ADDR_TILES  equ =0x06004000
ADDR_BG     equ =0x06001800
ADDR_FONT   equ 0x08603900
ADDR_WIDTHS equ 0x08604100

ADDR_SCRIPT_TILE_INDEX equ =0x02009954
ADDR_SCRIPT_X          equ =0x02009930
ADDR_SCRIPT_Y          equ =0x02009770

FN_RAM_CLEAR equ 0x0800D020
FN_VWF equ 0x0800D060

FN_SCRIPT_WRAPPER equ 0x08810000

.macro pushreg
  push r4-r7,lr
  mov r4, r8
  mov r5, r9
  mov r6, r10
  mov r7, r11
  push r4-r7
.endmacro

.macro popreg
  pop r3-r6
  mov r8, r3
  mov r9, r4
  mov r10, r5
  mov r11, r6
  pop r4-r7
.endmacro

.macro cleanram
  ldr r2, =ADDR_GLYPH
  ldr r1, =ADDR_DMA
  lsl r3, r0, 0x06
  add r3, r2, r3
  str r3, [r1]
  str r2, [r1, 0x04]
  ldr r3, =0x80000040
  str r3, [r1, 0x08]
  ldr r3, [r1, 0x08]
  add r2, 0x40
  ldr r3, =0x22222222
  str r3, [r2]
  str r2, [r1]
  str r2, [r1, 0x04]
  ldr r3, =0x81000080
  str r3, [r1, 0x08]
  ldr r3, [r1, 0x08]
.endmacro

;--------------------------;
; Script call (0x0800C186) ;
;--------------------------;
; First character starts 5 tiles in instead of 4
.org 0x0800BDB2
mov r0, 0x05

; RAM tile wraparound happens at 0x1F8 instead of 0x1FF.
.org 0x0800C260
.word 0x000001F8

; Gut script call.
.org 0x0800C186
ldr r3, =FN_SCRIPT_WRAPPER
mov r15, r3
.pool

; r0 = palette value to clear with.
L_ram_clear:
.org FN_RAM_CLEAR
.area 0x40
push lr
mov r1, r0
mov r2, 0x00
@@L_loop:
lsl r0, 0x01
orr r0, r1
add r2, r2, 0x01
cmp r2, 0x08
blt @@L_Loop
mov r2, r0

ldr r0, =ADDR_SHIFT
mov r1, 0x00
strb r1, [r0]
ldr r0, =ADDR_GLYPH
mov r1, r2
str r1, [r0]
ldr r1, =ADDR_DMA
str r0, [r1]
str r0, [r1, 0x04]
ldr r0, =0x81000060
str r0, [r1, 0x08]
ldr r0, [r1, 0x08]
pop r0
bx r0
.pool
.endarea
L_ram_clear_end:

.org FN_SCRIPT_WRAPPER
mov r2, 0x02

ldr r3, =(.+0x09)
mov r14, r3
ldr r3, =FN_VWF
mov r15, r3

; DMA from RAM to tile
ldr r1, =ADDR_DMA
ldr r2, =ADDR_GLYPH
str r2, [r1]
ldr r2, ADDR_SCRIPT_TILE_INDEX
ldrh r2, [r2]
lsl r2, r2, 0x05
ldr r3, ADDR_TILES
add r2, r2, r3
str r2, [r1, 0x04]
ldr r2, =0x80000000
add r3, r0, 0x01
lsl r3, r3, 0x06
add r2, r2, r3
str r2, [r1, 0x08]
ldr r2, [r1, 0x08]

; Update bg tilemap
; Computes offset for dialogue box
ldr r1, =0x0200998C
ldrh r1, [r1]
lsr r1, r1, 0x03
ldr r2, =0x02009998
ldrh r2, [r2]
lsl r2, r2, 0x02
add r1, r1, r2
lsl r1, r1, 0x01
; Add offset x-coordinate and y-coordinate offset.
ldr r2, ADDR_SCRIPT_X
ldrh r2, [r2]
lsl r2, r2, 0x01
add r1, r1, r2
ldr r2, ADDR_SCRIPT_Y
ldrh r2, [r2]
lsl r2, r2, 0x07
add r1, r1, r2
ldr r2, ADDR_BG
add r1, r1, r2
; Loop through and update the tilemap
ldr r2, ADDR_SCRIPT_TILE_INDEX
ldrh r2, [r2]
mov r3, 0x00
@@loop:
strh r2, [r1]
add r2, r2, 0x01
add r1, 0x40
strh r2, [r1]
add r2, r2, 0x01
sub r1, 0x3E
add r3, r3, 0x01
cmp r3, r0
ble @@loop

; Update tile index and x-coordinate
ldr r1, ADDR_SCRIPT_TILE_INDEX
ldrh r2, [r1]
lsl r3, r0, 0x01
add r2, r2, r3
strh r2, [r1]
ldr r1, ADDR_SCRIPT_X
ldrh r2, [r1]
add r2, r2, r0
strh r2, [r1]

; Clean RAM
cleanram

ldr r0, [r5]
add r0, 0x02
str r0, [r5]

; Return.
ldr r1, =0x0800C2F6
mov r15, r1
.pool

.close
