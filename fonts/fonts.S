.gba
.open "hacked.gba", 0x08000000

; Monospace menu font.
.org 0x08604200
.incbin fonts/menu_monospace.bin

.close
