.gba
.open "hacked.gba", 0x08000000

;--------------------;
; Item names in menu ;
;--------------------;
; Modify item name address calculation to multiply by 32 instead of 16.
.org 0x080BD5C6
lsl r1, r1, 0x05
nop

; Disable check that aborts drawing if glyph value < 0x0FFF. Use 0x7F7F instead.
.org 0x080B5DB4
.word 0x00007F7F

; For some reason, the game modifies the glyph values, disabling that.
.org 0x080B5DEC
nop
.org 0x080B5DD6
mov r0, 0x00


; Modify a bunch of calls to the name length calculation routine to read 16
; halfwords instead of 8.
;.org 0x0809B18E
;mov r1, 0x10
;.org 0x080A3CA2
;mov r1, 0x10
;.org 0x080A3D90
;mov r1, 0x10
;.org 0x080A3E2A
;mov r1, 0x10
;.org 0x080A6454
;mov r1, 0x10
;.org 0x080A9630
;mov r1, 0x10
;.org 0x080A96A0
;mov r1, 0x10
;.org 0x080AAE88
;mov r1, 0x10
;.org 0x080AB896
;mov r1, 0x10
;.org 0x080AF34A
;mov r1, 0x10
;.org 0x080AF3FA
;mov r1, 0x10
;.org 0x080AF888
;mov r1, 0x10
;.org 0x080AF8D8
;mov r1, 0x10
;.org 0x080AF954
;mov r1, 0x10
;.org 0x080AF9C8
;mov r1, 0x10
;.org 0x080B3FA4
;mov r1, 0x10
;.org 0x080B4472
;mov r1, 0x10
;.org 0x080BEE28
;mov r1, 0x10
;.org 0x080BEFCE ; Used in the title screen.
;mov r1, 0x10

; The following pass in r1 = 7 and not r1 = 8...
;.org 0x080AE75A
;mov r1, 0x10
;.org 0x080AEA8C
;mov r1, 0x10
;.org 0x080AEEE4
;mov r1, 0x10
;.org 0x080B4378
;mov r1, 0x10

; Other calls
; 0x080BEEEC loads r1 from r2. r2 = value of r1 passed in at
; 0x080BEE90, which is called 3 times: 0x0809B312, 0x080B5D50, and 0x080B653E.
; Tracing back further, we find that 0x080B4968 causes the 0x7 to be passed in.


; PROTIP: To trace where the 0x07 needs to be changed to a 0x10, set a
;         breakpoint at 0x080B57D8 and see where that is called. The value of
;         r3 passed in needs to be changed to 0x10.

;----------------------;
; Menu related changes ;
;----------------------;

; Item names in the menu.
.org 0x080B4968
mov r3, 0x10

; Item names in the shop buy menu.
.org 0x080B422A
mov r3, 0x10

; Item names in the shop sell menu.
.org 0x080B49E4
mov r3, 0x10

; Spell names in the menu.
.org 0x080B3BC8
mov r3, 0x10
.org 0x080B412E
mov r3, 0x10
.org 0x080B4492
mov r3, 0x10
.org 0x080B44E6
mov r3, 0x10

; Sticker names in the menu.
.org 0x080B45AA
mov r3, 0x10


;------------------------;
; Battle related changes ;
;------------------------;
; Monster names
.org 0x0800C468
lsl r0, r2, 0x05

; Character names in battle.
.org 0x0800C488
lsl r0, r2, 0x05

; Spell names in battle.
.org 0x08016DC0
lsl r0, r0, 0x05
.org 0x08019F12
lsl r2, r2, 0x05

; Item names in battle.
.org 0x08016DE8
lsl r0, r0, 0x05
.org 0x08019F58
lsl r2, r6, 0x05

; Spirit names in battle.
.org 0x08019440
lsl r4, r4, 0x05

; Attack names in battle.
.org 0x080157E4
lsl r0, r0, 0x1A
lsr r0, r0, 0x15
.org 0x08015802
add r1, 0x20
.org 0x08019EAC
lsl r2, r2, 0x1A
lsr r2, r2, 0x15

; Battle vwf calls.
.org 0x08016B2E
add r6, 0x20
.org 0x080168DE
add r6, 0x20

; Unknown, but probably necessary changes
.org 0x0800C42C
lsl r0, r2, 0x05
.org 0x0800C478
lsl r0, r2, 0x05
.org 0x08015A94
mov r0, 0x20
.org 0x08015B52
mov r0, 0x20
.org 0x080167DA
add r1, 0x20
;------------------------;
; Script related changes ;
;------------------------;
; Character names in script
.org 0x0800BC8A
lsl r1, r1, 0x05

; Item names in script
.org 0x0800BCC6
lsl r1, r1, 0x05
.org 0x0800BFD0
add r1, 0x20

; Frog and worm names in script
.org 0x0800BFC0
lsl r1, r1, 0x05

.close
