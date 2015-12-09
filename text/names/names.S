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

; Disable check that aborts drawing if glyph value < 0x0FFF.
.org 0x080B5DB2
.word 0xFFFF0000 ; 0xFFFF0000 instead of 0x0000FFFF because of byte order

; For some reason, the game writes an 0xF in the top nibble. Disabling that.
.org 0x080B5DEC
nop

; In the name length calculation routine, disable truncation of length to 7
.org 0x080BEE76
nop
nop

.close
