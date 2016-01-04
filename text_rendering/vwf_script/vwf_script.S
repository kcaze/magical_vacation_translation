.gba
.open "hacked.gba", 0x08000000
;--------------------;
; Macros and defines ;
;--------------------;
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

FN_SCRIPT_WRAPPER equ 0x0800CFCC
FN_SCRIPT_HANDLER equ 0x087FFE00

FN_BATTLE_WRAPPER1 equ 0x0800CFEC
FN_BATTLE_HANDLER1 equ 0x087FFD00

FN_BATTLE_WRAPPER2 equ 0x0800D00C
FN_BATTLE_HANDLER2 equ 0x087FFC00

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

.org FN_SCRIPT_HANDLER
.area 0x100
; Call our vwf routine
ldr r2, =(. + 0x09)
mov lr, r2
ldr r2, =0x087DF750
mov r15, r2

; DMA from RAM to tile
ldr r1, ADDR_DMA
ldr r2, ADDR_GLYPH
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

;--------------------------;
; Battle call (0x0800C98C) ;
;--------------------------;
.org 0x0800C98C
bl FN_BATTLE_WRAPPER1
; Have icons increment the stack space pointer and return value instead of
; toggle the 1st part / 2nd part flag.
.org 0x0800C96C
; Increment stack space pointer
add r5, 0x40
; Increment return value
add r6, 0x40
lsl r0, r7, 0x10
b 0x0800C9BC
; Branch over return value and stack space pointer increments
.org 0x0800C992
b 0x0800C9BE
; Off by one error in return value so add 0x40 and then branch to return
.org 0x0800C9CA
add r6, 0x40
b 0x0800C9D8


.org FN_BATTLE_WRAPPER1
.area 0x20
push lr
ldr r2, =FN_BATTLE_HANDLER1
mov r15, r2
pop r0
bx r0
.pool
.endarea

.org FN_BATTLE_HANDLER1
.area 0x100
; Call our vwf routine
ldr r2, =(. + 0x09)
mov lr, r2
ldr r2, =0x087DF750
mov r15, r2

; DMA from RAM to stack space
ldr r1, ADDR_DMA
ldr r2, ADDR_GLYPH
str r2, [r1]
str r5, [r1, 0x04]
ldr r2, =0x80000000
add r3, r0, 0x01
lsl r3, r3, 0x06
add r2, r2, r3
str r2, [r1, 0x08]
ldr r2, [r1, 0x08]

sub r3, 0x40
; Increment stack space pointer
add r5, r5, r3
; Increment return value
add r6, r6, r3

; Clean glyph RAM
cleanram

; Return to wrapper.
ldr r0, =FN_BATTLE_WRAPPER1
add r0, 0x06
mov r15, r0
.pool
.endarea

;--------------------------;
; Battle call (0x0800ADCE) ;
;--------------------------;
.org 0x0800ADCE
bl FN_BATTLE_WRAPPER2

; Have icons increment the x-coordinate and tile index instead of toggle the
; 1st part / 2nd part flag.
.org 0x0800ACD6
mov r2, r8
add r2, r2, 0x01
mov r8, r2
add r6, r6, 0x02
b 0x0800AEB0

; Branch over DMA and tilemap piecing
.org 0x0800ADD4
b 0x0800AEB0

.org FN_BATTLE_WRAPPER2
.area 0x20
push lr
ldr r2, =FN_BATTLE_HANDLER2
mov r15, r2
pop r0
bx r0
.pool
.endarea

.org FN_BATTLE_HANDLER2
.area 0x100
; Call our vwf routine
ldr r2, =(. + 0x09)
mov lr, r2
ldr r2, =0x087DF750
mov r15, r2

; DMA from RAM to tile
ldr r1, ADDR_DMA
ldr r2, ADDR_GLYPH
str r2, [r1]
lsl r2, r6, 0x05
ldr r3, ADDR_TILES
add r2, r2, r3
str r2, [r1, 0x04]
ldr r2, =0x80000000
add r3, r0, 0x01
lsl r3, r3, 0x05
add r2, r2, r3
str r2, [r1, 0x08]
ldr r2, [r1, 0x08]

; Piece together tilemap
ldr r1, =0x02009764
ldrh r1, [r1]
mov r2, r9
mul r1, r2
add r1, r8
lsl r1, r1, 0x01
ldr r2, =0x02009744
ldr r2, [r2]
add r1, r1, r2
mov r2, 0x00
mov r3, r6
@@loop:
strh r3, [r1]
add r3, r3, 0x01
ldr r4, =0x02009764
ldr r4, [r4]
lsl r4, r4, 0x01
strh r3, [r1, r4]
add r3, r3, 0x01
add r1, r1, 0x02
add r2, r2, 0x01
cmp r2, r0
blt @@loop

; Update x-coordinate and tile index
lsl r1, r0, 0x01
add r6, r6, r1
add r8, r0

; Clean glyph RAM
cleanram

; Return to wrapper.
ldr r0, =FN_BATTLE_WRAPPER2
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
beq L_return
b L_vwf

L_return:
mov r0, r8
popreg
pop r1
bx r1

.pool

.close
