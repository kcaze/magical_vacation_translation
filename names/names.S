; This injects the English names for stuff.
.gba
.open "hacked.gba", 0x08000000

;--------------;
; People Names ;
;--------------;
.org 0x0822A1EC
.incbin names/people_names.bin

.close
