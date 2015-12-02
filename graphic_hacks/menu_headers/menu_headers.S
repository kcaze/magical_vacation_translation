; Hacks menu to have English header text.
.gba
.open "hacked.gba", 0x08000000

;-------------------------------------------------------;
; Include binary files for graphics and data structures ;
;-------------------------------------------------------;
.org 0x087910A0
.incbin graphic_hacks/menu_headers/menu_text.bin

.org 0x080C31B8
.incbin graphic_hacks/menu_headers/menu_text_info.bin

;--------------------------------------------;
; Update the x-coordinate for compound words ;
;--------------------------------------------;
; かいふ　くアイテム　ー　RECOVERY ITEMS
.org 0x080AA27C
mov r0, 0x61
; そうび　アイテム　ー　EQUIPMENT
.org 0x080AA2AA
mov r1, 0xFF
; MD　パッツ　ー　MD PARTS
.org 0x080AA2DA
mov r1, 0x46
; そのたの　アイテム　ー　OTHER ITEMS
.org 0x080AA30A
mov r1, 0x46
; まほう　のてちょう　ー　MAGIC HANDBOOK
.org 0x080AA30A
mov r1, 0x53
; MD じてん　ー　MD MANUAL
.org 0x080AB1AC
mov r0, 0x46
; ぼうぐ　そうび　ー　EQUIPMENT
.org 0x080ABE20
mov r1, 0x38
; まほう　そうび　ー　MAGIC
.org 0x080AC15A
mov r0, 0xFF
; まほう　レベル　ー　MAGIC LEVEL
.org 0x080AC1B8
mov r0, 0x55
; ぼうぐ　そうび　ー　EQUIPMENT
.org 0x080AD58A
mov r1, 0x38
; まほう　そうび　ー　MAGIC
.org 0x080AD930
mov r0, 0xFF
; シール　そうび　ー　SEALS
.org 0x080ADA50
mov r0, 0xFF
; まほう　のてちょう　ー　MAGIC HANDBOOK
.org 0x080ADEF4
mov r0, 0x55
; MD じてん　ー　MD MANUAL
.org 0x080AE366
mov r0, 0x46

.close
