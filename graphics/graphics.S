.gba
.open "hacked.gba", 0x08000000

; Menu header graphics
.org 0x087910A0
.incbin graphics/menu_headers/menu_text.bin

; Menu icon graphics
.org 0x0879A214
.incbin graphics/menu_icons/menu_icons.bin

; LZ77 graphics
.org 0x0869A670
.incbin graphics/main_menu/buttons1.img.bin

.close
