.gba
.open "hacked.gba", 0x08000000


; PROTIP: Put a breakpoint at 0x080BD520 and use the condition that r0 == the
;         section number of a text to figure out when a particular string is
;         being referenced.

; In the "Magic Level" screen, change it so that only the element name is
; displayed and not the word "magic". This is achieved by loading the empty
; string in name selection kanji block 0 instead.
.org 0x080B3CB6
mov r0, 0x00
mov r1, 0x0b

.org 0x080B40EA
mov r0, 0x00
mov r1, 0x0b

; Positioning text for the "erase save" message when selecting "new game"
; Message position
.org 0x080ACC74
mov r0, 0x10 ; x-coordinate
mov r1, 0x18 ; y-coordinate
; "Yes" position
.org 0x080ACC94
mov r0, 0x50 ; x-coordinate
mov r1, 0x78 ; y-coordinate
; "No" position
.org 0x080ACCB0
mov r0, 0x84 ; x-coordinate
mov r1, 0x78 ; y-coordinate
; Cursor position
.org 0x080A1DA0
mov r1, 0x32 ; distance between "Yes" and "No "
.org 0x080A1DA6
add r2, 0x40 ; x-coordinate - 0x10
.org 0x080A1DB8
mov r3, 0x78 ; y-coordinate


.close
