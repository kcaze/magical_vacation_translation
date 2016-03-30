.gba
.open "hacked.gba", 0x08000000

ADDR_WIDTHS equ (0x086C8A3C + 0x4000)
FN_X_COORD equ 0x08810400 ;TODO -- Remap addresses at the end

; Variable width x-coordinate update
.org 0x0809B5CC
ldr r0, =FN_X_COORD
mov r15, r0
.pool

.org FN_X_COORD
mov r2, r13
ldr r0, =ADDR_WIDTHS
ldr r1, [r2, 0x08]
ldrb r1, [r1, 0x01]
ldrb r0, [r1, r0]
ldrh r1, [r2, 0x0C]
add r1, r0, r1
add r1, 0x02
strh r1, [r2, 0x0C]

ldr r0, =0x0809B5D7
mov r15, r0
.pool

.close
