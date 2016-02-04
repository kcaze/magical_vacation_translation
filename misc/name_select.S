.gba
.open "hacked.gba", 0x08000000

; Map an index x to 2 + 11*(x/9) + x%9 so that the
; correct letter is used for a name.
.org 0x080A65B2
; Not enough room here so branching to custom code.
; TODO: This address needs to be remapped at the end.
ldr r0, =0x0880A000
mov r15, r0
.pool
.org 0x0880A000
ldrh r0, [r7]
mov r1, 0x9
mov r2, r3 ; Save r3
swi 0x06 ; Division, r0 = x/9, r1 = x%9
mov r3, r2
mov r2, 0x0B
mul r0, r2
add r0, r0, r1
add r0, 0x02
lsl r0, r0, 0x2
ldr r1, =0x3904
add r0, r0, r1
add r6, r5, r0
ldr r2, =0x3A44
ldr r1, =0x080A65BE
mov r15, r1
.pool

; Change name selection to use 1 byte characters.
.org 0x080A663C
lsl r0, r0, 0x1C
lsr r0, r0, 0x1C
.org 0x080A6646
ldrb r0, [r6]
strb r0, [r1]

; Modify cursor to be 16 pixels per index instead of 12.
.org 0x080A1E10
lsl r1, r0, 0x4
nop
nop

; Modify each row to be only 9 wide.
.org 0x080A1DEE
mov r6, 0x09
.org 0x080A1DF4
mov r6, 0x09
.org 0x080A3EC0
mov r3, 0x09

; Modify the max index to be 9*4 = 36 = 0x24
.org 0x080A3EB0
mov r0, 0x24

; Modify the number of extra rows per panel to 0
.org 0x080A3EAE
mov r2, 0x00

; Modify the space skip to be at 4 characters, not 5.
.org 0x080BCB66
cmp r0, 0x4
.org 0x080BCBBC
cmp r0, 0x4

; Modify panel to skip the original ABC and Kanji panels
; TODO: remap addresses at the end.
.org 0x080BC594
ldr r0, =0x0880B000
mov r15, r0
.pool
.org 0x080BC5C0
ldr r0, =0x0880C000
mov r15, r0
.pool
; Move panel up
.org 0x0880B000
; Hopefully safe to clobber r1
mov r0, 0x18
ldr r1, =(. + 0x9)
mov r14, r1
ldr r1, =0x0805B564
mov r15, r1
ldrh r0, [r6]
cmp r0, 0x4
bne L_no_up_skip
sub r0, 0x2
L_no_up_skip:
sub r0, 0x1
ldr r1, =0x080BC5DC
mov r15, r1
.pool
; Move panel down
.org 0x0880C000
mov r0, 0x18
ldr r1, =(. + 0x9)
mov r14, r1
ldr r1, =0x0805B564
mov r15, r1
ldrh r0, [r6]
cmp r0, 0x1
bne L_no_down_skip
add r0, 0x2
L_no_down_skip:
add r0, 0x1
ldr r1, =0x080BC5DC
mov r15, r1
.pool
; Hide the ABC and Kanji panels offscreen
.org 0x080B0B8A
mov r2, 0x9F
.org 0x080B0B98
mov r2, 0x9F
.org 0x080B0B26
mov r2, 0x9F
.org 0x080B0B42
mov r2, 0x9F
; Hide the downwards arrow offscrenn
.org 0x080B0AB2
mov r1, 0xF4

; TODO: Change backspace to erase 1 byte characters
;       Delete cursor and rewrite "back" function to just delete one character.

; Fix backspace to erase only 1 byte.
; Also backspace immediately erases character.
.org 0x080A96D6
mov r1, 0xFF
.org 0x080A96DE
mov r1, r3
.org 0x080A96E4
ldrb r0, [r2]
; if [r2] != 0xFF and [r5] == 0x5, increment [r5].
cmp r0, 0xFF
beq L_not_last
cmp r3, 0x05
bne L_not_last
mov r0, 0x06
strb r0, [r5]
L_not_last:
mov r0, 0xFF
strb r0, [r2]
add r1, r6, r1
mov r0, r12
strh r0, [r1]
ldrb r0, [r5]
sub r3, 0x1
sub r0, 0x1
cmp r3, r0
bge 0x080A96DE

.close
