.gba
.open "hacked.gba", 0x08000000

; Insert translated people names.
.org 0x0822A1EC
.incbin text/names/people_names.bin

; Insert the translated script.
.org 0x08629A2C
.incbin text/script/script.bin

; Insert translated menu text.
.org 0x087C229C
.incbin text/menu_text/menu_text.bin

; Insert translated item names.
.org 0x087DFA50
.incbin text/names/item_names.bin

; TODO: Not actually sure about this stuff.
; We changed the item offset from 0x390 to
; 0x087DFA50 - 0x8226F7C = 0x5B8AD4
.org 0x08226F7C
.incbin text/names/name_offsets.bin

.close
