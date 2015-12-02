; TODO: A lot of the changes here aren't well documented / seem to nat make much
;       sense.
.gba
.open "hacked.gba", 0x08000000

;------------;
; Item Names ;
;------------;
; We hack the item display subroutine a bit to allow for longer names.
.org 0x0800BFC0
lsl r1, r1, 0x05

.org 0x0800BFD0
add r1, 0x20

.org 0x080BD5C8
lsr r1, r1, 0x0B

; Change check that glyph value < 0x0FFF to 0xFFFF
.org 0x080B5DB2
.word 0xFFFF0000 ; 0xFFFF0000 instead of 0x0000FFFF because of byte order

; This inserts an 0xF for whatever reason so we're deleting that
.org 0x80B5DEC
nop

.close
