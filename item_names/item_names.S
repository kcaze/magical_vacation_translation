.gba
.open "hacked.gba", 0x08000000

; Disable DMA transfer
.org 0x080A0BCA
nop

; Stop the glyph value from being truncated
.org 0x080B61CE
nop
nop

.org 0x080B62FE
; Save r2 (the glyph value) in r0.
mov r1, r2
; Hijack the routine at 0x080B62F4 to jump to ours
ldr r2, =0x087E1C00
mov r15, r2
.pool

.org 0x087E1C00
mov r0, 0xFF
and r1, r0
lsl r1, r1, 0x04
ldr r0, =0x08603900
add r1, r1, r0

; Copy top half of the 1bpp data onto stack
ldr r0, [r1, 0x00]
str r0, [sp, 0x00]
ldr r0, [r1, 0x04]
str r0, [sp, 0x04]

; Copy bottom half of the 1bpp data onto stack
ldr r0, [r1, 0x08]
str r0, [sp, 0x08]
ldr r0, [r1, 0x0C]
str r0, [sp, 0x0C]

; Clear the RAM.
mov r0, 0x00
mov r1, 0x00
ldr r2, =0x0203692C
loop:
  str r1, [r2, r0]
  add r0, 0x04
  cmp r0, 0xC0
  blt loop

ldr r0, =0x0203692C
mov r1, sp
mov r2, 0x0F
mov r3, 0x01 ; Number of 8x8 blocks to translate

; The following essentially does the same thing as
; bl 0x080BEC2C.
mov r4, pc
add r4, r4, 0x7
mov lr, r4
ldr r4, =0x80BEC2C
mov pc, r4

ldr r0, =0x0203694C
mov r1, sp
add r1, 0x08
mov r2, 0x0F
mov r3, 0x01 ; Number of 8x8 blocks to translate

; The following essentially does the same thing as
; bl 0x080BEC2C.
mov r4, pc
add r4, r4, 0x7
mov lr, r4
ldr r4, =0x80BEC2C
mov pc, r4

; DMA
ldr r0, =0x040000D4
ldr r1, =0x0203692C
str r1, [r0, 0x00]
ldr r1, =0x06008980
str r1, [r0, 0x04]
ldr r1, =0x80000010
str r1, [r0, 0x08]
ldr r1, [r0, 0x08]

; DMA
ldr r0, =0x040000D4
ldr r1, =0x0203694C
str r1, [r0, 0x00]
ldr r1, =0x06008D80
str r1, [r0, 0x04]
ldr r1, =0x80000010
str r1, [r0, 0x08]
ldr r1, [r0, 0x08]

return:
ldr r0, =0x080B6372
mov r15, r0

.pool

; Disable x-coordinate update
; .org 0x080B64BC
; nop

.close
