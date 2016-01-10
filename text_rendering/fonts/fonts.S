.gba
.open "hacked.gba", 0x08000000

ADDR_FONT equ 0x08603900

.org ADDR_FONT
.incbin text_rendering/fonts/vwf.bin
.org ADDR_FONT + 0x800
.incbin text_rendering/fonts/vwf_widths.bin
.org ADDR_FONT + 0x900
.incbin text_rendering/fonts/vwf_robot.bin
.org ADDR_FONT + 0x800 + 0x900
.incbin text_rendering/fonts/vwf_robot_widths.bin
.org ADDR_FONT + 2 * 0x900
.incbin text_rendering/fonts/vwf_menu.bin
.org ADDR_FONT + 0x800 + 2 * 0x900
.incbin text_rendering/fonts/vwf_menu_widths.bin


.close
