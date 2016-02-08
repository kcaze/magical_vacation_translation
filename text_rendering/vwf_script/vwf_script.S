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

FN_SCRIPT_WRAPPER equ 0x0800CFCC
FN_SCRIPT_HANDLER equ 0x087F5C30

FN_RAM_CLEAR equ 0x0800D020
FN_VWF_JUMP equ 0x0800D060

FN_VWF equ 0x087F5F30

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

.org 0x0800C186
bl FN_SCRIPT_WRAPPER
.org 0x0800C190
; Skip the original DMA, x-coordinate, tile index, and tile map updates.
b 0x0800C2F6

.org FN_SCRIPT_WRAPPER
.area 0x20
push lr
ldr r2, =FN_SCRIPT_HANDLER
mov r15, r2
pop r0
bx r0
.pool
.endarea

.org FN_RAM_CLEAR
.area 0x40
push lr
ldr r0, =ADDR_SHIFT
mov r1, 0x00
strb r1, [r0]
ldr r0, =ADDR_GLYPH
ldr r1, =0x22222222
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

.org FN_VWF_JUMP
.area 0x20
push lr
ldr r2, =(. + 0x09)
mov lr, r2
ldr r2, =FN_VWF
mov r15, r2
pop r1
bx r1
.pool
.endarea

.org FN_SCRIPT_HANDLER
.area 0x100
; Call our vwf routine
ldr r2, =(. + 0x09)
mov lr, r2
ldr r2, =FN_VWF
mov r15, r2

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

; Return to wrapper.
ldr r0, =FN_SCRIPT_WRAPPER
add r0, 0x06
mov r15, r0
.pool
.endarea

;-----------------------------;
; Our vwf routine             ;
; ===============             ;
; Input:                      ;
;   r0 = glyph value [half]   ;
;   r1 = palette color [byte] ;
; Return:                     ;
;   Number of blocks used - 1 ;
;-----------------------------;
.org FN_VWF
.area 0x200
pushreg

; Swap order of values in glyph
mov r2, 0xFF
and r2, r0
lsr r0, 0x08
lsl r2, 0x08
orr r0, r2

; r8 = return value
; r9 = glyph value
; r10 = palette value
mov r2, 0x00
mov r8, r2
mov r9, r0
mov r10, r1

L_vwf:
; Get the next glyph value, r7 = r9 & 0xFF
mov r7, r9
lsl r7, r7, 0x18
lsr r7, r7, 0x18

; Skip drawing if r7 < 0x20 or r7 >= 0x80
cmp r7, 0x20
blt L_not_drawable
cmp r7, 0x80
blt L_drawable
L_not_drawable:
b L_vwf_end_loop
L_drawable:

; Copy glyph to the RAM buffer
ldr r0, =ADDR_FONT
lsl r1, r7, 0x04
add r0, r0, r1
ldr r1, =ADDR_GLYPH
mov r5, r8
lsl r5, r5, 0x06
add r1, r1, r5
mov r2, r10
bl L_fn_copy_glyph

; Update shift and return value.
ldr r0, =ADDR_WIDTHS
add r0, r0, r7
ldrb r0, [r0]
add r0, 0x01 ; add 0x1 for space.
ldr r1, =ADDR_SHIFT
ldrb r2, [r1]
add r0, r0, r2 ; r0 = shift + width
mov r2, 0x07
and r2, r0
strb r2, [r1] ; shift = (shift + width) % 8
lsr r0, r0, 0x03
add r8, r0 ; ret += (shift + width) / 8

L_vwf_end_loop:
mov r0, r9
lsr r0, 0x08
mov r9, r0
cmp r0, 0x00
beq L_return
b L_vwf

L_return:
mov r0, r8
popreg
pop r1
bx r1

.pool

; ARGS:
; r0 = glyph address
; r1 = destination address
; r2 = palette
; RET: N/A
L_fn_copy_glyph:
pushreg
mov r3, 0x00 ; r3 = loop counter
ldr r4, =ADDR_SHIFT
ldrb r4, [r4]
lsl r4, r4, 0x02 ; r4 = shift
mov r5, r0 ; r5 = glyph address
mov r6, r1 ; r6 = destination address
mov r7, r2 ; r7 = palette
mov r0, 0x20
sub r0, r0, r4
mov r8, r0 ; r8 = 0x20 - shift

@@L_loop:
; Convert 1bpp row to 4bpp row and store in r0
mov r0, 0x00
ldrb r1, [r5, r3]
mov r2, 0x80
@@L_1bpp_to_4bpp:
lsl r0, r0, 0x04
tst r1, r2
beq @@L_off
add r0, 0x01
@@L_off:
lsr r2, r2, 0x01
cmp r2, 0x00
bne @@L_1bpp_to_4bpp

; Convert 0's to 2's and 1's to palette value
ldr r1, =0x11111111
sub r1, r1, r0
mov r2, 0x2
mul r1, r2
mul r0, r7
add r0, r0, r1

; Shift and store first half of row
ldr r2, [r6]
mov r1, r8
lsl r2, r1
lsr r2, r1
mov r1, r0
lsl r1, r4
orr r2, r1
str r2, [r6]

; Shift and store second half of row
mov r1, r8
lsr r0, r1
ldr r1, =0x22222222
lsl r1, r4
orr r0, r1
str r0, [r6, 0x40]

add r6, 0x04
add r3, 0x01
cmp r3, 0x10
blt @@L_loop

popreg
pop r0
bx r0
.pool
.endarea

.close
