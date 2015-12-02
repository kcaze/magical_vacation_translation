; This injects the translated script.
.gba
.open "hacked.gba", 0x08000000

.org 0x08629A2C
.incbin script/script.bin

.close
