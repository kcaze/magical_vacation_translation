; This guts the text draw routine 0x0800AB30 - 0x0800AB4E which delegates to 0x0800AB50 - 0x0800AF98.
; The battle 2 routine is called from the following locations:
;   0x080172CC: Battle commands "Magic", "Items", "Defend", "Escape", "Kick"
;   0x08017322:
;   0x08017346:
;   0x08017416:
;   0x08017478:
;   0x080174E8:
;   0x080183C2:
;   0x080183F6:
;   0x08018928:
;   0x0801896A:
;   0x08018BD6:
;   0x08018C06:
;   0x08018CD4:
;   0x08018CFE:
;   0x08018D34:
;   0x08018F42:
;   0x08018F62:
;   0x08019104:
; This routine takes in one arguments:
;   r0 = number of times to call 0x0800AB50 (length of text).
;   0x02009714: Length of array
;   0x02009744: Pointer to location of panel tilemap
;   0x02009764: Width of panel in tiles
;   0x02009A40: An array of data structure {
;                 [8 bits] x-coordinate in panel;
;                 [8 bits] y-coordinate in panel;
;                 [12 bits] tile index;
;                 [4 bits] palette (0xF - the color);
;                 [word] pointer to text start;
;                 [word] pointer to text end;
;               }
;   0x020099A4: x-coordinate of panel in tiles
;   0x02009734: y-coordinate of panel in tiles

; The original routine had 0x0800AB30 be called multiple times, drawing 4
; letters at a time. In my modified routine, it will draw the entire array with
; each call.
;
; 0x0800C56C: This routine is used to populate the array of data structures.
; It takes in 3 arguments:
;   r0 = beginning script pointer
;   r1 = end script pointer
;   r2 = tile index
;   r3 = palette
;   [sp] = x-coordinate
;   [sp, 0x04] = y-coordinate
; It returns the number of tiles the text takes up. I'm modifying the return
; value to compute this as 4 * (r1 - r0) + 1.


.gba
.open "hacked.gba", 0x08000000

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

FN_RAM_CLEAR equ 0x0800D020
FN_VWF equ 0x0800D060
FN_ICON equ 0x0800D370

ADDR_GLYPH  equ 0x020097B0
ADDR_DMA    equ 0x040000D4
ADDR_TILE    equ 0x06004000
START equ 0x0800AB30
END equ 0x0800AF98

.org START
L_wrapper:
.area 0x20
push r4,lr
ldr r4, =0x02009714

@@L_loop:
bl L_battle2
ldrb r0, [r4]
cmp r0, 0x00
bne @@L_loop

pop r4
pop r0
bx r0
.pool
.endarea

.org START + 0x20
L_battle2:
.area END - (START + 0x20)
pushreg

; Clear RAM
bl FN_RAM_CLEAR

; Setup registers
ldr r0, =0x02009714
ldrb r0, [r0]
sub r0, 0x01
mov r1, 0x0C
mul r0, r1
ldr r1, =0x02009A40
add r0, r0, r1
mov r7, r0 ; r7 = pointer to data structure

@@L_loop:
; Call vwf
mov r6, 0x00 ; flag indicate if we need to break out of loop.
ldr r0, [r7, 0x04]
ldrb r1, [r0]
cmp r1, 0xFE
blt @@L_not_terminate
mov r6, 0x01
@@L_not_terminate:
lsl r1, r1, 0x08
ldrb r0, [r0, 0x01]
cmp r0, 0xFE
blt @@L_not_terminate2
mov r6, 0x01
@@L_not_terminate2:
add r0, r0, r1

cmp r0, 0xF
bgt @@L_vwf
; Icon
mov r2, r0
ldr r0, =0x020099A4
ldrh r0, [r0]
ldrb r1, [r7, 0x00]
add r0, r0, r1
lsl r0, r0, 0x03
ldr r1, =0x02009734
ldrh r1, [r1]
ldrb r3, [r7, 0x01]
add r1, r1, r3
lsl r1, r1, 0x03
mov r3, 0x00
bl FN_ICON
ldr r0, =0x22222222
ldr r1, =ADDR_GLYPH
str r0, [r1]
ldr r0, =ADDR_DMA
str r1, [r0]
str r1, [r0, 0x4]
ldr r1, =0x81000040
str r1, [r0, 0x8]
ldr r1, [r0, 0x8]
mov r0, 0x02
b @@L_vwf_end

@@L_vwf:
ldrb r1, [r7, 0x03]
lsr r1, r1, 0x04
sub r1, 0x0F
neg r1, r1
mov r2, 0x02 ; bg palette
bl FN_VWF
@@L_vwf_end:

; Copy glyph data to tiles
ldr r1, =ADDR_DMA
ldr r2, =ADDR_GLYPH
str r2, [r1]
ldr r2, =ADDR_TILE
ldrh r3, [r7, 0x02]
lsl r3, r3, 0x05
add r2, r2, r3
str r2, [r1, 0x04]
ldr r2, =0x80000000
lsl r3, r0, 0x05
add r2, r2, r3
add r2, 0x20
str r2, [r1, 0x08]
ldr r2, [r1, 0x08]

; Update tilemap
ldr r1, =0x02009764
ldrb r1, [r1]
lsl r1, r1, 0x01 ; r1 = panel width

ldr r2, =0x02009744
ldr r2, [r2]
ldrb r3, [r7, 0x01]
mul r3, r1
add r2, r2, r3
ldrb r3, [r7, 0x00]
lsl r3, r3, 0x01
add r2, r2, r3 ; r2 = tilemap address
ldrh r3, [r7, 0x02]
lsl r3, r3, 0x14
lsr r3, r3, 0x14 ; r3 = tile index
mov r4, 0x00 ; r4 = loop counter
@@L_tilemap_loop:
strh r3, [r2]
add r3, 0x01
strh r3, [r2, r1]
add r2, 0x02
add r3, 0x01
add r4, 0x01
cmp r4, r0
ble @@L_tilemap_loop

; Update data structure
ldrb r1, [r7, 0x00]
add r1, r1, r0
strb r1, [r7, 0x00]
ldrh r1, [r7, 0x02]
add r1, r1, r0
add r1, r1, r0
strh r1, [r7, 0x02]
ldr r1, [r7, 0x04]
add r1, 0x02
str r1, [r7, 0x04]

; Update glyph ram
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

ldr r0, [r7, 0x04]
ldr r1, [r7, 0x08]
cmp r6, 0x00
bne @@L_return
cmp r0, r1
bne @@L_loop

@@L_return:
; Decrement array length.
ldr r0, =0x02009714
ldrb r1, [r0]
sub r1, 0x01
strb r1, [r0]
popreg
pop r0
bx r0
.pool
.endarea

; Fix tile calculation
.org 0x0800C652
lsl r0, r1, 0x02
add r0, 0x01
nop
nop
nop
nop
nop
.close
