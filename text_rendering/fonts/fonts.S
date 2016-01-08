.gba
.open "hacked.gba", 0x08000000

; vwf font.
.org 0x08603900
.incbin text_rendering/fonts/vwf.bin

; Table storing widths of each glyph for the VWF script font
.org 0x08604100
.incbin text_rendering/fonts/vwf_widths.bin

; monospace font.
.org 0x08604200
.incbin text_rendering/fonts/monospace.bin


.close
