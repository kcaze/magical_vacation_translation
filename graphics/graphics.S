.gba
.open "hacked.gba", 0x08000000

ADDR_TABLE_MAIN_MENU equ 0x08699AA4
ADDR_MAIN_MENU_TITLE      equ 0x08800000
ADDR_MAIN_MENU_BUTTONS1   equ 0x08803000
ADDR_MAIN_MENU_BUTTONS2   equ 0x08806000

.org ADDR_TABLE_MAIN_MENU
.word 0x00000009 ;hardcoded
.word ADDR_MAIN_MENU_TITLE - ADDR_TABLE_MAIN_MENU
.word ADDR_MAIN_MENU_BUTTONS1 - ADDR_TABLE_MAIN_MENU
.word ADDR_MAIN_MENU_BUTTONS2 - ADDR_TABLE_MAIN_MENU

; Menu header graphics
.org 0x087910A0
.incbin graphics/menu_headers/menu_text.bin

; Menu icon graphics
.org 0x0879A214
.incbin graphics/menu_icons/menu_icons.bin

; LZ77 compressed main menu graphics
.org ADDR_MAIN_MENU_TITLE
.incbin graphics/main_menu/title.img.bin
.org ADDR_MAIN_MENU_BUTTONS1
.incbin graphics/main_menu/buttons1.img.bin
.org ADDR_MAIN_MENU_BUTTONS2
.incbin graphics/main_menu/buttons2.img.bin

; Repositioning title
.org 0x080C245C
.halfword 0x0004 ; y-coordinate
.halfword 0x0010 ; x-coordinate

.close
