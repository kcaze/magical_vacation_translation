.gba
.open "hacked.gba", 0x08000000

; These 2 are used to clear the ram first I believe.
.org 0x080B6338
nop
nop

.org 0x080B634E
nop
nop

.org 0x080B62FE
; Hijack the routine at 0x080B62F4 to jump to ours
;mov r2, 0x08
;lsl r2, r2, 0x08
;add r2, 0x7E
;lsl r2, r2, 0x08
;add r2, 0x1C
;lsl r2, r2, 0x08
;add r2, 0x00
;mov r15, r2

.org 0x087E1C00
ldr r0, [r2]
str r0, [sp]

ldr r0, [r2, 0x04]
str r0, [sp, 0x04]

ldr r0, [r2, 0x10]
str r0, [sp, 0x08]

ldr r0, [r2, 0x14]
str r0, [sp, 0x0C]

ldr r0, [r2, 0x08]
str r0, [sp, 0x18]

ldr r0, [r2, 0x0C]
str r0, [sp, 0x1C]

ldr r0, [r2, 0x18]
str r0, [sp, 0x20]

ldr r0, [r2, 0x1C]
str r0, [sp, 0x24]

ldr r0, =0x0203698C
mov r1, sp
mov r2, 0x0F
mov r3, 0x03

mov r7, pc
add r7, r7, 0x7
mov lr, r7
ldr r7, =0x80BEC2C
mov pc, r7

return:
  ldr r0, =0x080B6372
  mov r15, r0

.pool

; Disable x-coordinate update
; .org 0x080B64BC
; nop

; Disable DMA
; .org 0x080A0BCA
; nop

.close
