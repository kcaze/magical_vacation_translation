.gba
.open "hacked.gba", 0x08000000

; VWF script font.
.org 0x08603900
.incbin fonts/script.bin

; Monospace menu font.
.org 0x08604200
.incbin fonts/menu_monospace.bin

; Table storing widths of each glyph for the VWF script font
.org 0x087DF900
.incbin fonts/script_widths.bin

.close
