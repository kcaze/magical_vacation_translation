; TODO: A lot of the changes here aren't well documented / seem to nat make much
;       sense.
.gba
.open "hacked.gba", 0x08000000

;--------------------;
; Item names in menu ;
;--------------------;
; Modify item name address calculation to multiply by 32 instead of 16.
.org 0x080BD5C6
lsl r1, r1, 0x05
nop

; Disable check that aborts drawing if glyph value < 0x0FFF. Use 0xF0F0 instead.
.org 0x080B5DB2
.word 0xFFFF0000 ; 0xFFFF0000 instead of 0x0000FFFF because of byte order

; For some reason, the game writes an 0xF in the top nibble. Disabling that.
.org 0x080B5DEC
nop


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
.org 0x080B4968
mov r3, 0x10


.close
