.gba
.open "hacked.gba", 0x08000000

;------------------;
; Translated names ;
;------------------;
ADDR_NAME_OFFSETS equ 0x08226F7C
ADDR_NAME_ATTACKS equ 0x087F4130
ADDR_NAME_ITEMS equ 0x087DFA50
ADDR_NAME_STATUSES equ 0x08FFFFFF ; TODO
ADDR_NAME_SPELLS equ 0x087EB800
ADDR_NAME_MONSTERS equ 0x087F4800
ADDR_NAME_CHARACTERS equ 0x087F2D30
ADDR_NAME_GENDERS equ 0x08FFFFFF ; TODO
ADDR_NAME_SPIRITS equ 0x0822730C
ADDR_NAME_SPECIES equ 0x08FFFFFF ; TODO
ADDR_NAME_ELEMENTS equ 0x0822770C
ADDR_NAME_PLACES equ 0x087EF500
ADDR_NAME_RANKINGS equ 0x087F71E0

.org ADDR_NAME_OFFSETS
.word 0x00000008 ; Hardcoded
.word 0x0000000C ; Hardcoded
.word ADDR_NAME_ATTACKS - 0x08226F7C
.word ADDR_NAME_ITEMS - 0x08226F7C
.word ADDR_NAME_STATUSES - 0x08226F7C
.word ADDR_NAME_SPELLS - 0x08226F7C
.word ADDR_NAME_MONSTERS - 0x08226F7C
.word ADDR_NAME_CHARACTERS - 0x08226F7C
.word ADDR_NAME_GENDERS - 0x08226F7C
.word ADDR_NAME_SPIRITS - 0x08226F7C
.word ADDR_NAME_SPECIES - 0x08226F7C
.word ADDR_NAME_ELEMENTS - 0x08226F7C
.word ADDR_NAME_PLACES - 0x08226F7C
.word ADDR_NAME_RANKINGS - 0x08226F7C

.org ADDR_NAME_ATTACKS
.incbin text/names/attacks.bin
.org ADDR_NAME_ITEMS
.incbin text/names/items.bin
.org ADDR_NAME_SPELLS
.incbin text/names/spells.bin
.org ADDR_NAME_MONSTERS
.incbin text/names/monsters.bin
.org ADDR_NAME_CHARACTERS
.incbin text/names/characters.bin
.org ADDR_NAME_SPIRITS
.incbin text/names/spirits.bin
.org ADDR_NAME_ELEMENTS
.incbin text/names/elements.bin
.org ADDR_NAME_PLACES
.incbin text/names/places.bin
.org ADDR_NAME_RANKINGS
.incbin text/names/rankings.bin

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
