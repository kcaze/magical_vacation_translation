.gba
.open "hacked.gba", 0x08000000

; Insert updated offsets for name sections.
.org 0x08226F7C
.incbin text/names/name_offsets.bin

; TODO: This is not the new format.
; Insert translated people names.
.org 0x0822A1EC
.incbin text/names/people_names.bin

; Insert translated item names.
.org 0x087DFA50
.incbin text/names/items.bin

; Insert translated spirit names.
.org 0x0822730C
.incbin text/names/spirits.bin

; Insert translated element names.
.org 0x0822770C
.incbin text/names/elements.bin

; Insert the translated script.
.org 0x08629A2C
.incbin text/script/script.bin

; Insert updated offsets for menu sections.
.org 0x087C2254
.incbin text/menu/menu_offsets.bin

; Insert menu text section offsets;
.org 0x087E1E00
.incbin text/menu/menu_text_offsets.bin

; Insert translated menu text.
.org 0x087E2128
.incbin text/menu/menu_text.bin

.close
