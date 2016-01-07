.gba
.open "hacked.gba", 0x08000000

; Disable DMA transfers
.org 0x080A0BCA
nop

.org 0x080A0BF6
nop

; Stop the glyph value from being truncated
.org 0x080B61CE
nop
nop

; Where we hijack the routine to call ours.
.org 0x080B62FE
; r1 = ([r0]-0x06008000)/2, the tile index.
ldr r1, [r0]
ldr r0, =0x06008000
sub r1, r1, r0
lsr r1, r1, 0x05

; If (r1 - 0x0203CF80)/2 == 0, then it's an empty call so exit
; immediately.
cmp r1, 0x00
beq 0x080B6372

; Hijack the routine at 0x080B62F4 to jump to ours
ldr r0, =0x087E1C00
mov r15, r0
.pool

;-----------------------------;
; Beginning of my VWF routine ;
; =========================== ;
; Parameters passed in        ;
; r1: tile index              ;
; r2: glyph value             ;
;-----------------------------;
.org 0x087E1C00
; TODO: This may potentially introduce bugs by zeroing too much.
; DMA zeroes to clear tile data.
ldr r4, =0x040000D4
ldr r3, =0x0203FFFC
mov r0, 0x00
strh r0, [r3, 0x00]
str r3, [r4, 0x00]
ldr r0, [r5, 0x00]
str r0, [r4, 0x04]
ldr r0, =0x81000030
str r0, [r4, 0x08]
ldr r0, [r4, 0x08]

ldr r0, [r5, 0x00]
ldr r3, =0x0400
add r0, r0, r3
str r0, [r4, 0x04]
ldr r0, =0x81000030
str r0, [r4, 0x08]
ldr r0, [r4, 0x08]
;END Possibly buggy code.

; INVARIANTS: r5 = glyph value, r6 = RAM address 0x0203FFF4
ldr r6, =0x0203FFF4
mov r5, r2

mov r0, 0xFF
and r2, r0
cmp r2, 0x1F
bne not_bos
; Do some RAM setup on begin-of-string character, 0x1F
mov r0, 0x00
str r0, [r6, 0x00]
str r0, [r6, 0x04]
strh r1, [r6, 0x00]
strh r1, [r6, 0x04]
; Clear the glyph data in RAM.
mov r1, 0x00
ldr r2, =0x0203692C
clear_ram_loop_:
  str r1, [r2, r0]
  add r0, 0x04
  cmp r0, 0x50
  blt clear_ram_loop_
not_bos:

draw_glyph:
; Set r1 to the address of the first glyph
mov r0, 0xFF
mov r1, r5
and r1, r0
; Skip drawing of 0
cmp r1, 0x00
beq loop_draw_glyph
lsl r1, r1, 0x04
ldr r0, =0x08603900
add r1, r1, r0

; Copy glyph data onto stack with a shift depending on width of
; remaining glyph.
ldrb r2, [r6, 0x02]
mov r3, 0x00
copy_data_loop:
  ldrb r0, [r1, r3]
  lsl r0, r2
  ldr r4, =0x0203692C
  ldrb r4, [r4, r3]
  orr r0, r4
  ldr r4, =0x0203692C
  strb r0, [r4, r3]
  add r3, 0x01
  cmp r3, 0x10
  blt copy_data_loop

; Call 0x080BEC2C to translate from 1bpp to 4bpp.
ldr r0, =0x0203693C ; Destination
ldr r1, =0x0203692C ; Source
mov r2, 0x0F ; Font color
mov r3, 0x02 ; Number of 8x8 blocks to translate
; The following essentially does the same thing as
; bl 0x080BEC2C.
mov r4, pc
add r4, r4, 0x7
mov lr, r4
ldr r4, =0x80BEC2C
mov pc, r4

; DMA top half
ldr r0, =0x040000D4
; Store the RAM source
ldr r1, =0x0203693C
str r1, [r0, 0x00]
; Compute and store the tile destination
ldr r1, =0x06008000
ldrh r2, [r6, 0x00]
lsl r2, r2, 0x05
add r1, r1, r2
str r1, [r0, 0x04]
; Initiate DMA
ldr r1, =0x80000010
str r1, [r0, 0x08]
ldr r1, [r0, 0x08]

; DMA bottom half
ldr r0, =0x040000D4
; Store the RAM source
ldr r1, =0x0203695C
str r1, [r0, 0x00]
; Compute and store the tile destination
ldr r1, =0x06008000
ldrh r2, [r6, 0x00]
lsl r2, r2, 0x05
add r1, r1, r2
ldr r2, =0x0400
add r1, r2
str r1, [r0, 0x04]
ldr r1, =0x80000010
str r1, [r0, 0x08]
ldr r1, [r0, 0x08]

; Compute offset for next glyph
mov r0, 0xFF
mov r1, r5
and r1, r0
ldr r0, =0x087DF900
ldrb r0, [r0, r1]
ldrb r2, [r6, 0x02]
add r2, r2, r0
add r2, 0x01
mov r3, 0x07
and r3, r2
strh r3, [r6, 0x02]
cmp r2, 0x08
bge carryover

loop_draw_glyph:
lsr r5, r5, 0x08
cmp r5, 0x00
bne draw_glyph
b return

carryover:
sub r2, 0x08
; Increment tile index
ldrh r1, [r6, 0x00]
add r1, 0x01
strh r1, [r6, 0x00]
; Clear the RAM.
mov r0, 0x00
mov r1, 0x00
ldr r2, =0x0203692C
clear_ram_loop:
  str r1, [r2, r0]
  add r0, 0x04
  cmp r0, 0x50
  blt clear_ram_loop

; Copy remaining.
; r2 = width of glyph - number of pixels remaining
;    = pixels to shift
mov r0, 0xFF
mov r1, r5
and r1, r0
ldrb r2, [r6, 0x02]
ldr r3, =0x087DF900
ldrb r3, [r3, r1]
sub r2, r3, r2
add r2, 0x01
; r1 = address of glyph data
lsl r1, r1, 0x04
ldr r0, =0x08603900
add r1, r1, r0
; Shift and then copy over remaining glyph's data.
mov r3, 0x00
ldr r4, =0x0203692C
copy_remaining_data_loop:
  ldrb r0, [r1, r3]
  lsr r0, r2
  strb r0, [r4, r3]
  add r3, 0x01
  cmp r3, 0x10
  blt copy_remaining_data_loop

; Call 0x080BEC2C to translate from 1bpp to 4bpp.
ldr r0, =0x0203693C ; Destination
ldr r1, =0x0203692C ; Source
mov r2, 0x0F ; Font color
mov r3, 0x02 ; Number of 8x8 blocks to translate
; The following essentially does the same thing as
; bl 0x080BEC2C.
mov r4, pc
add r4, r4, 0x7
mov lr, r4
ldr r4, =0x80BEC2C
mov pc, r4

; DMA top half
ldr r0, =0x040000D4
; Store the RAM source
ldr r1, =0x0203693C
str r1, [r0, 0x00]
; Compute and store the tile destination
ldr r1, =0x06008000
ldrh r2, [r6, 0x00]
lsl r2, r2, 0x05
add r1, r1, r2
str r1, [r0, 0x04]
; Initiate DMA
ldr r1, =0x80000010
str r1, [r0, 0x08]
ldr r1, [r0, 0x08]

; DMA bottom half
ldr r0, =0x040000D4
; Store the RAM source
ldr r1, =0x0203695C
str r1, [r0, 0x00]
; Compute and store the tile destination
ldr r1, =0x06008000
ldrh r2, [r6, 0x00]
lsl r2, r2, 0x05
add r1, r1, r2
ldr r2, =0x0400
add r1, r2
str r1, [r0, 0x04]
ldr r1, =0x80000010
str r1, [r0, 0x08]
ldr r1, [r0, 0x08]

b loop_draw_glyph


return:
ldr r0, =0x080B6372
mov r15, r0

.pool

.org 0x080B5DCA
ldrh r0, [r1]
add r0, 0x1
strh r0, [r1]

.org 0x080B5FB8
lsl r3, r3, 0x11

.org 0x080B5FDA
add r4, 0x02

.org 0x080B613A
ldrh r0, [r2]
add r2, r2, 0x02
str r2, [sp, 0xC]
cmp r0, 0x00

.org 0x080B61CC
ldrh r2, [r6]

.org 0x080B64A8
mov r1, 0x02
.org 0x080B64B0
mov r1, 0x28
.org 0x080B64C0
mov r1, 0x28

.org 0x080BD874
lsl r2, r2, 0x03
add r0, r0, r2
lsl r0, r0, 0x01

.close
