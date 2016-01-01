.gba
.open "hacked.gba", 0x08000000

; Insert updated offsets for name sections.
.org 0x08226F7C
.incbin text/names/name_offsets.bin

; Insert translated character names.
.org 0x087F2D30
.incbin text/names/characters.bin

; Insert translated item names.
.org 0x087DFA50
.incbin text/names/items.bin

; Insert translated spell names.
.org 0x087EB800
.incbin text/names/spells.bin

; Insert translated spirit names.
.org 0x0822730C
.incbin text/names/spirits.bin

; Insert translated element names.
.org 0x0822770C
.incbin text/names/elements.bin

; Insert translated place names.
.org 0x087EF500
.incbin text/names/places.bin

; Insert the translated script.
.org 0x08629A2C
.incbin text/script/script.bin

; Insert translated battle text.
.org 0x08698E98
.incbin text/battle_text/battle_text.bin

; Insert updated offsets for menu sections.
.org 0x087C2254
.incbin text/menu/menu_offsets.bin

; Insert menu text section offsets;
.org 0x087E1E00
.incbin text/menu/menu_text_offsets.bin

; Insert translated menu text.
.org 0x087E2128
.incbin text/menu/menu_text.bin

; Insert translated menu explanations text section offsets.
.org 0x087E4400
.incbin text/menu/explanations_offsets.bin

; Insert translated menu explanations text.
.org 0x087E4838
.incbin text/menu/explanations.bin

; Insert modified name selection kanji offsets.
.org 0x087ECA00
.incbin text/menu/name_selection_offsets.bin

; Insert modified name selection kanji.
.org 0x087ECB68
.incbin text/menu/name_selection.bin

; Insert MD dictionary section name offsets.
.org 0x087EF000
.incbin text/menu/md_dictionary_offsets.bin

; Insert MD dictionary section names.
.org 0x087EF078
.incbin text/menu/md_dictionary.bin

; Insert translated element description offsets.
.org 0x087F3200
.incbin text/menu/element_descriptions_offsets.bin

; Insert translated element descriptions.
.org 0x087F321C
.incbin text/menu/element_descriptions.bin


.close
