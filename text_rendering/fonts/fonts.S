.gba
.open "hacked.gba", 0x08000000

ADDR_FONT equ 0x08603900
ADDR_CUTSCENE_FONT equ 0x086C8A3C

.org ADDR_FONT
.incbin text_rendering/fonts/vwf.bin
.org ADDR_FONT + 0x800
.incbin text_rendering/fonts/vwf_widths.bin
.org ADDR_FONT + 0x900
.incbin text_rendering/fonts/vwf.bin
.org ADDR_FONT + 0x800 + 0x900
.incbin text_rendering/fonts/vwf_monospace_widths.bin

.org ADDR_CUTSCENE_FONT
.incbin text_rendering/fonts/cutscene_font.bin
.org ADDR_CUTSCENE_FONT + 0x4000
.incbin text_rendering/fonts/cutscene_font_widths.bin

.close
