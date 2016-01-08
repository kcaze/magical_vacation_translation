.gba
.open "hacked.gba", 0x08000000


; PROTIP: Put a breakpoint at 0x080BD520 and use the condition that r0 == the
;         section number of a text to figure out when a particular string is
;         being referenced.

; PROTIP: To find where the positions are hardcoded, put a breakpoint for
; 0x080B58F0 and see where it was called from. The parameters passed in through
; r0 and r1 are the x and y coordinates respectively.

; Positioning text for the "erase save" message when selecting "new game"
; Message position
.org 0x080ACC74
mov r0, 0x10 ; x
mov r1, 0x18 ; y
; "Yes" position
.org 0x080ACC94
mov r0, 0x50 ; x
mov r1, 0x78 ; y
; "No" position
.org 0x080ACCB0
mov r0, 0x84 ; x
mov r1, 0x78 ; y
; Cursor position
.org 0x080A1DA0
mov r1, 0x32 ; distance between "Yes" and "No "
.org 0x080A1DA6
add r2, 0x40 ; x
.org 0x080A1DB8
mov r3, 0x78 ; y

; Positioning text for "Who do you play as?"
.org 0x080ACD48
mov r0, 0x30 ; x
mov r1, 0x03 ; y

; Positioning text for "Which element do you choose?"
.org 0x080ACE26
mov r0, 0x08 ; x
mov r1, 0x08 ; y

; Positioning text for element name in element choosing
.org 0x080ACE4E
mov r0, 0x5C ; x
mov r1, 0x80 ; y

; Positioning text for male confirmation screen
; "Name", "Gender", and "Element"
.org 0x080ACFA0
add r0, 0x10 ; x for all
.org 0x080ACFB4
mov r1, 0x20 ; y for "Name"
.org 0x080ACFF4
mov r1, 0x30 ; y for "Gender"
.org 0x080AD048
mov r1, 0x40 ; y for "Element"

; The actual values for name, gender, and element
.org 0x080ACFD6
mov r1, 0x20 ; y for name
.org 0x080AD028
mov r1, 0x30 ; y for gender
.org 0x080AD070
mov r1, 0xA0 ; y for element (hiding the element text, icon is enough)
; x and y for element icon
.org 0x080AD0C4
add r0, sp, 0x10
add r7, 0x08 ; x for icon
strh r7, [r0, 0x04]
mov r1, 0x3E ; y for icon
strh r1, [r0, 0x06]
.close
