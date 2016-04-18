.gba
.open "hacked.gba", 0x08000000

CUTSCENE_HEADER_SIZE equ 32
ADDR_WIDTHS equ (0x086C8A3C + 0x4000)
ADDR_CHAR_CUTSCENE_WIDTHS equ (0x08603900 + 0x800)
ADDR_CUTSCENE equ 0x08810400 ;TODO -- Remap addresses at the end, be consistent with text.S
ADDR_TEXT_TABLES equ 0x086A55E8
FN_X_COORD equ 0x08810200 ;TODO -- Remap addresses at the end

; Cutscene script repointing
.org (ADDR_TEXT_TABLES + 8 * 4 + 4)
.word (ADDR_CUTSCENE - ADDR_TEXT_TABLES)
.org (ADDR_TEXT_TABLES + 9 * 4 + 4)
.word (ADDR_CUTSCENE - ADDR_TEXT_TABLES + CUTSCENE_HEADER_SIZE)

; Variable width x-coordinate update
.org 0x0809B5CC
ldr r0, =FN_X_COORD
mov r15, r0
.pool

.org FN_X_COORD
mov r2, r13
ldr r0, =0x7E4C ; Magic constant that allows us to distinguish between which of the two cutscenes we're in.
ldrh r1, [r2, 0x04]
cmp r0, r1
bne L_regular_cutscene
ldr r0, =ADDR_CHAR_CUTSCENE_WIDTHS
ldr r1, [r2, 0x08]
ldrb r1, [r1, 0x01]
ldrb r0, [r0, r1]
ldrh r1, [r2, 0x0C]
add r1, r0, r1
add r1, 0x01
strh r1, [r2, 0x0C]
ldr r0, =ADDR_CHAR_CUTSCENE_WIDTHS
ldr r1, [r2, 0x08]
ldrb r1, [r1, 0x00]
ldrb r0, [r0, r1]
ldrh r1, [r2, 0x0C]
add r1, r0, r1
add r1, 0x01
strh r1, [r2, 0x0C]
b L_regular_cutscene_end
L_regular_cutscene:
ldr r0, =ADDR_WIDTHS
ldr r1, [r2, 0x08]
ldrb r1, [r1, 0x01]
ldrb r0, [r0, r1]
ldrh r1, [r2, 0x0C]
add r1, r0, r1
add r1, 0x02
strh r1, [r2, 0x0C]
L_regular_cutscene_end:

ldr r0, =0x0809B5D7
mov r15, r0
.pool

; Cutscene positioning and timing
.org 0x080C25C8 ; x-coordinates of idle title screen cutscenes
.halfword 0x08
.org 0x080C25D8
.halfword 0x08
.org 0x080C25E0
.halfword 0x08

.org 0x080C25CC ; timing of idle title screen cutscenes
.halfword 0x01C0
.org 0x080C25D4
.halfword 0x0200
.org 0x080C25DC
.halfword 0x02A0

.org 0x080C262C ; x-coordinates of intro cutscenes
.halfword 0x08
.org 0x080C2640
.halfword 0x08
.org 0x080C2654
.halfword 0x08
.org 0x080C2668
.halfword 0x08
.org 0x080C267C
.halfword 0x08
.org 0x080C2690
.halfword 0x08

.org 0x0809A2B8; Speed up intro cutscene text
mov r3, 0x03

; Change intro cutscene timings
.org 0x080C2630
.halfword 0x0160
.org 0x080C2644
.halfword 0x0200
.org 0x080C266C
.halfword 0x03C0
.org 0x080C2694
.halfword 0x0380

.close
