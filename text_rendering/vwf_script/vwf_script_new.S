.gba
.open "hacked.gba", 0x08000000
;--------------------;
; Macros and defines ;
;--------------------;
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

ADDR_GLYPH  equ =0x020097B0
ADDR_SHIFT  equ =0x0203FFF0
ADDR_DMA    equ =0x040000D4
ADDR_TILES  equ =0x06004000
ADDR_BG     equ =0x06001800
ADDR_FONT   equ =0x08603900
ADDR_WIDTHS equ =0x087DF900

ADDR_SCRIPT_TILE_INDEX equ =0x02009954
ADDR_SCRIPT_X          equ =0x02009930
ADDR_SCRIPT_Y          equ =0x02009770

FUN_SCRIPT_WRAPPER equ 0x0800CFCC
FUN_SCRIPT_HANDLER equ 0x087FFE00

;--------------------------;
; Script call (0x0800C186) ;
;--------------------------;
.org 0x0800C190
; Skip the original DMA, x-coordinate, tile index, and tile map updates.
b 0x0800C2F6

; Script entry point
.org FUN_SCRIPT_WRAPPER
push lr
ldr r2, =FUN_SCRIPT_HANDLER
mov r15, r2
pop r0
bx r0
.pool

; Script handler for DMA, x-coordinate updates, etc.
.org FUN_SCRIPT_HANDLER
.area 0x100
; Call our vwf routine
ldr r2, =(. + 0x09)
mov lr, r2
ldr r2, =0x087DF750
mov r15, r2
; DMA from RAM to tile
ldr r2, ADDR_GLYPH
ldr r1, ADDR_DMA
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
ldr r2, ADDR_GLYPH
ldr r1, ADDR_DMA
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

ldr r0, =FUN_SCRIPT_WRAPPER
add r0, 0x06
mov r15, r0
.pool
.endarea

;--------------------------;
; Battle call (0x0800C98C) ;
;--------------------------;
.org 0x0800C98C
b 0x0800C2F6 ; Branch over DMA and x-coordinate and tile index updates.

;-----------------------------;
; Our vwf routine             ;
; ===============             ;
; Input:                      ;
;   r0 = glyph value [half]   ;
;   r1 = palette color [byte] ;
; Return:                     ;
;   Number of blocks used - 1 ;
;-----------------------------;
.org 0x087DF750
pushreg

; r8 = return value
; r9 = glyph value
; r10 = palette value
mov r2, 0x00
mov r8, r2
mov r9, r0
mov r10, r1

L_vwf:
; Get the next glyph value, r0 = r9 & 0xFF
mov r7, r9
lsl r7, r7, 0x18
lsr r7, r7, 0x18
cmp r7, 0x1F
bne L_not_bos
L_not_bos:
lsl r7, r7, 0x04
ldr r0, ADDR_FONT
add r7, r7, r0
mov r6, 0x00
ldr r5, ADDR_GLYPH
mov r0, r8
lsl r0, r0, 0x06
add r5, r5, r0
; r7 = glyph address
; r6 = loop glyph counter
; r5 = destination in RAM to write to
L_loop_glyph:
; Compute the 4bpp row and store it in r1.
ldrb r0, [r7, r6]
mov r1, 0x00
mov r2, 0x80
mov r4, 0x00
; r0 = 1bpp row
; r1 = 4bpp row
; r2 = mask
; r4 = loop row counter
@@L_loop_row:
lsl r1, r1, 0x04
add r1, r1, 0x02
tst r0, r2
beq @@L_off
mov r3, r10
sub r1, r1, 0x02
add r1, r1, r3
@@L_off:
lsl r0, r0, 0x01
add r4, r4, 0x01
cmp r4, 0x08
blt @@L_loop_row
; Do the appropriate shifting and then store the 4bpp row.
lsl r0, r6, 0x02
ldr r2, [r5, r0]
ldr r4, ADDR_SHIFT
ldr r4, [r4]
lsl r4, r4, 0x02
lsl r1, r4
; Mask r2 with 0xFFFFFFFF << r4
mov r3, 0x01
neg r3, r3
lsl r3, r4
neg r3, r3
sub r3, r3, 0x01
and r2, r3
add r2, r2, r1
str r2, [r5, r0]
add r6, r6, 0x01
cmp r6, 0x10
blt L_loop_glyph

; Compute the new shift.
mov r7, r9
lsl r7, r7, 0x18
lsr r7, r7, 0x18
ldr r6, ADDR_WIDTHS
ldrb r6, [r6, r7]
ldr r4, ADDR_SHIFT
ldrb r4, [r4]
add r4, r4, r6
cmp r4, 0x08
ble L_no_overflow
; Handle overflow.
mov r7, r9
lsl r7, r7, 0x18
lsr r7, r7, 0x18
lsl r7, 0x04
ldr r0, ADDR_FONT
add r7, r7, r0
mov r6, 0x00
ldr r5, ADDR_GLYPH
mov r0, r8
add r0, r0, 0x01
lsl r0, r0, 0x06
add r5, r5, r0
; r7 = glyph address
; r6 = loop glyph counter
; r5 = destination in RAM to write to
L_loop_glyph_overflow:
; Compute the 4bpp row and store it in r1.
ldrb r0, [r7, r6]
mov r1, 0x00
mov r2, 0x80
mov r4, 0x00
; r0 = 1bpp row
; r1 = 4bpp row
; r2 = mask
; r4 = loop row counter
@@L_loop_row:
lsl r1, r1, 0x04
add r1, r1, 0x02
tst r0, r2
beq @@L_off
mov r3, r10
sub r1, r1, 0x02
add r1, r1, r3
@@L_off:
lsl r0, r0, 0x01
add r4, r4, 0x01
cmp r4, 0x08
blt @@L_loop_row
; Do the appropriate shifting and then store the 4bpp row.
lsl r0, r6, 0x02
ldr r2, [r5, r0]
ldr r4, ADDR_SHIFT
ldrb r4, [r4]
lsl r4, r4, 0x02
lsr r2, r4
lsl r2, r4
sub r4, 0x20
neg r4, r4
lsr r1, r4
add r2, r1, r2
str r2, [r5, r0]
add r6, r6, 0x01
cmp r6, 0x10
blt L_loop_glyph_overflow
; Update the shift
mov r7, r9
lsl r7, r7, 0x18
lsr r7, r7, 0x18
ldr r6, ADDR_WIDTHS
ldrb r6, [r6, r7]
ldr r5, ADDR_SHIFT
ldrb r4, [r5]
add r4, r4, r6
strb r4, [r5]
b L_after_overflow
L_no_overflow:
; Update the shift.
ldr r5, ADDR_SHIFT
strb r4, [r5]
L_after_overflow:

; Increment shift by 1 and mod 8. Also increment return value.
ldr r5, ADDR_SHIFT
ldrb r4, [r5]
add r4, r4, 0x01
lsr r3, r4, 0x03
mov r0, r8
add r0, r0, r3
mov r8, r0
lsl r4, 0x1D
lsr r4, 0x1D
strb r4, [r5]

mov r0, r9
lsr r0, 0x08
mov r9, r0
cmp r0, 0x00
bne L_vwf

return:
mov r0, r8
popreg
pop r1
bx r1

.pool

.close
