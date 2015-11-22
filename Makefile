.PHONY: all clean

all:
	rm -f hacked.gba hacked.ups
	cp original.gba hacked.gba
	bin/armips.exe menu_headers/menu_headers.S
	bin/armips.exe vwf/vwf.S
	bin/armips.exe menu_text/menu_text.S
	bin/armips.exe names/names.S
	bin/armips.exe script/script.S
	bin/armips.exe fonts/fonts.S
	bin/ups.exe diff -b original.gba -m hacked.gba -o hacked.ups
