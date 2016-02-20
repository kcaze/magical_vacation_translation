.gba
.open "hacked.gba", 0x08000000

;;;;;;;;;;;;;;;;;;
; BG 1 MENU TEXT ;
;;;;;;;;;;;;;;;;;;
; PROTIP: Put a breakpoint at 0x080B57D8 and look at where it's called from.
;         r0 is the x and r1 is the y.

; Status page
.org 0x080B3966 ; "Gender:"
mov r0, 0x0C
.org 0x080B3984 ; Gender
mov r0, 0x12
.org 0x080B39A8 ; "Element:"
mov r0, 0x14
.org 0x080B39E6 ; "Species:"
mov r0, 0x0C
.org 0x080B39FE ; Species
mov r0, 0x12

; Equipment page
.org 0x080B3A3C ; Headgear
mov r0, 0x0A
.org 0x080B3A86 ; Wrist
mov r0, 0x0A
.org 0x080B3ACC ; Torso
mov r0, 0x0A
.org 0x080B3B12 ; Shoes
mov r0, 0x0A
.org 0x080B3B58 ; Accessory
mov r0, 0x0A

.org 0x080B3A62 ; Hyphens
mov r0, 0x0A

.org 0x080B43EC ; Item to equip
mov r0, 0x0A

.org 0x080B4392 ; Item to unequip
mov r0, 0x10
.org 0x080B43B6 ; "Unequip"
mov r0, 0x0A

; Magic page
.org 0x080B3BC6 ; Spell name
mov r0, 0x0E
.org 0x080B3BE8 ; Hyphens
mov r0, 0x0E

.org 0x080B448C ; Spell to unequip
mov r0, 0x0F
.org 0x080B44B0 ; "Unequip"
mov r0, 0x09
.org 0x080B44E4 ; spells to equip
mov r0, 0x0C

; Magic level page
.org 0x080B3CAC ; Element
mov r0, 0x0F
.org 0x080B3CCE ; Disable drawing the word "magic"
nop
nop
.org 0x080B3CEC ; "?????"
mov r0, 0x0F

.org 0x080B40E0 ; Element
mov r0, 0x0F
.org 0x080B4100 ; Disable drawing the word "magic"
nop
nop
.org 0x080B412C
mov r0, 0x0C

; Profile page
.org 0x080B3F1A ; Description
mov r0, 0x08
.org 0x080B3F36 ; Name
mov r0, 0x0C
.org 0x080B3F52 ; "Rank:"
mov r0, 0x08
.org 0x080B3F74 ; Rank?
.org 0x080B3F8C ; "Mojo:"
mov r0, 0x08
.org 0x080B4042 ; Mojo hyphens
mov r0, 0x0D

; All the items pages
.org 0x080B4964 ; Item name
mov r0, 0x0C

; Spirits page
.org 0x080B4738 ; Element
mov r0, 0x0C
mov r1, 0x02
.org 0x080B475C ; Disable drawing the word "spirit"
nop
nop
.org 0x080B476E ; Spirit name
mov r0, 0x0C
mov r1, 0x01
.org 0x080B4790 ; Spirit description
mov r0, 0x08

; Magic notebook page
.org 0x080B360A ; Section heading
mov r0, 0x0C


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
mov r0, 0x40 ; x
mov r1, 0x03 ; y

; Positioning text for "Which element do you choose?"
.org 0x080ACE26
mov r0, 0x24 ; x
mov r1, 0x08 ; y

; Positioning text for element name in element choosing
.org 0x080ACE4E
mov r0, 0x68 ; x
mov r1, 0x80 ; y

; Positioning text for male confirmation screen
; "Name", "Gender", and "Element"
.org 0x080ACFA0
add r0, 0x24 ; x for all
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
add r7, 0x02 ; x for icon
strh r7, [r0, 0x04]
mov r1, 0x3E ; y for icon
strh r1, [r0, 0x06]

; "Is this correct?"
.org 0x080AF624
add r0, 0x24

.close
