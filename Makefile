.PHONY: all menu_headers vwf clean

all:
	rm -f hacked.gba hacked.ups
	cp original.gba hacked.gba
	bin/armips.exe menu_headers/menu_headers.S
	bin/armips.exe vwf/vwf.S
	bin/armips.exe names/names.S

menu_headers: menu_headers/menu_headers.S
	bin/armips.exe menu_headers/menu_headers.S

vwf: vwf/vwf.S
	bin/armips.exe vwf/vwf.S

names: names/names.S
	bin/armips.exe names/names.S

clean:
	rm -f hacked.gba hacked.ups
	cp original.gba hacked.gba
