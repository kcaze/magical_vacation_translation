.gba
.open "hacked.gba", 0x08000000

; In the "Magic Level" screen, change it so that only the element name is
; displayed and not the word "magic". This is achieved by loading the empty
; string in name selection kanji block 0 instead.
.org 0x080B3CB6
mov r0, 0x00
mov r1, 0x0b

.close
