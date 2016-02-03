.gba
.open "hacked.gba", 0x08000000

; Change name selection to use 1 byte characters.
; Also, skip first 0x1F character in each row
.org 0x080A65B2
; We need to map an index x to 2 + 11*(x/9) + x%9.
; Not enough room here so branching to custom code.
; TODO: This address needs to be remapped at the end.
ldr r0, =0x0880A000
mov r15, r0
.pool
.org 0x0880A000
ldrh r0, [r7]
lsl r0, r0, 0x2
ldr r1, =0x3904
add r0, r0, r1
add r6, r5, r0
ldr r1, =0x080A65BC
mov r15, r1
.pool

.org 0x080A663C
lsl r0, r0, 0x1C
lsr r0, r0, 0x1C
.org 0x080A6646
ldrb r0, [r6, 0x08]
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



; TODO: Change backspace to erase 1 byte characters
;       Delete cursor and rewrite "back" function to just delete one character.

.close
