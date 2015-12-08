.PHONY: all clean

all:
	rm -f hacked.gba hacked.ups
	cp original.gba hacked.gba
	bin/armips.exe graphic_hacks/menu_headers/menu_headers.S
	bin/armips.exe text_rendering/fonts/fonts.S
	bin/armips.exe text_rendering/monospace/monospace.S
	bin/armips.exe text_rendering/vwf_script/vwf_script.S
	bin/armips.exe text_rendering/vwf_menu/vwf_menu.S
	bin/armips.exe text/text.S
	# names.S does something, but I'm not quite sure what.
	#bin/armips.exe text/names/names.S
	bin/ups.exe diff -b original.gba -m hacked.gba -o hacked.ups
