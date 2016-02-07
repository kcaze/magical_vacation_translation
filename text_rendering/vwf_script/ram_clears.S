; This inserts hacks to clear the RAM at the appropriate call sites.
; TODO: Remap all the addresses at the end.
.gba
.open "hacked.gba", 0x08000000

ADDR_RAM  equ 0x0203FFF0

; 0x0800C8C8 -- Name drawing in battle.
.org 0x0800C8DA
ldr r0, =0x0880E000
mov r15, r0
.pool
.org 0x0880E000
mov r0, 0x00
ldr r1, =ADDR_RAM
strb r0, [r1]

; Original code that needs to be executed
ldr r0, [sp, 0x24]
ldr r1, [sp, 0x28]
lsl r3, r3, 0x10
lsr r3, r3, 0x10
str r3, [sp]
lsl r0, r0, 0x10
lsr r7, r0, 0x10
lsl r1, r1, 0x10
lsr r1, r1, 0x10
mov r10, r1
mov r6, 0x00
mov r8, r6

ldr r0, = 0x0800C9BE
mov r15, r0
.pool
