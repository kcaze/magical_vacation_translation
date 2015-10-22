.PHONY: all menu_headers vwf clean

all:
	rm -f hacked.gba hacked.ups
	cp original.gba hacked.gba
	bin/armips.exe menu_headers/menu_headers.S
	bin/armips.exe vwf/vwf.S
	bin/armips.exe names/names.S
	bin/armips.exe script/script.S
	bin/ups.exe diff -b original.gba -m hacked.gba -o hacked.ups

menu_headers: menu_headers/menu_headers.S
	rm -f hacked.gba hacked.ups
	cp original.gba hacked.gba
	bin/armips.exe menu_headers/menu_headers.S
	bin/ups.exe diff -b original.gba -m hacked.gba -o hacked.ups

vwf: vwf/vwf.S
	rm -f hacked.gba hacked.ups
	cp original.gba hacked.gba
	bin/armips.exe vwf/vwf.S
	bin/ups.exe diff -b original.gba -m hacked.gba -o hacked.ups

names: names/names.S
	rm -f hacked.gba hacked.ups
	cp original.gba hacked.gba
	bin/armips.exe names/names.S
	bin/ups.exe diff -b original.gba -m hacked.gba -o hacked.ups

script: script/script.S
	rm -f hacked.gba hacked.ups
	cp original.gba hacked.gba
	bin/armips.exe script/script.S
	bin/ups.exe diff -b original.gba -m hacked.gba -o hacked.ups

clean:
	rm -f hacked.gba hacked.ups
	cp original.gba hacked.gba
