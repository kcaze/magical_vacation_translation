.gba
.open "hacked.gba", 0x08000000

.org 0x080B6306
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

add r0, sp, 0x18
mov r8, r0

.org 0x080B64BC
nop

.close
