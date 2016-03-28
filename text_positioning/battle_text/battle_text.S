.gba
.open "hacked.gba", 0x08000000

; Regular level up
.org 0x08016224 ; Don't display "になった"
nop
nop

; Magic level up
.org 0x08016504 ; Don't display "になった"
nop
nop
.org 0x0801B5A0 ; position of LV
mov r2, 0xD0
lsl r2, r2, 0x0F

.close
