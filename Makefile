.PHONY: all clean

all:
	rm -f hacked.gba hacked.ups
	cp original.gba hacked.gba

	bin/grit/grit.exe graphics/main_menu/title.bmp -gB4 -p! -m! -fh! -ftb -Zl -q -o graphics/main_menu/title
	bin/grit/grit.exe graphics/main_menu/buttons1.bmp -gB4 -p! -m! -fh! -ftb -Zl -q -o graphics/main_menu/buttons1
	bin/grit/grit.exe graphics/main_menu/buttons2.bmp -gB4 -p! -m! -fh! -ftb -Zl -q -o graphics/main_menu/buttons2
	bin/grit/grit.exe graphics/yuujou/yuujou.bmp -gB4 -p! -m! -fh! -ftb -Zl -q -o graphics/yuujou/yuujou
	bin/grit/grit.exe graphics/name_select/name_select.bmp -gB4 -p! -m! -fh! -ftb -q -o graphics/name_select/name_select


	bin/armips.exe graphics/menu_headers/menu_headers.S
	bin/armips.exe graphics/graphics.S
	bin/armips.exe text_rendering/fonts/fonts.S

	cat header.S text_rendering/vwf_script/vwf.S footer.S > tmp.S
	bin/armips.exe tmp.S
	rm tmp.S

	cat header.S text_rendering/vwf_menu/vwf_menu.S footer.S > tmp.S
	bin/armips.exe tmp.S
	rm tmp.S

	bin/armips.exe text_rendering/cutscene/cutscene.S
	bin/armips.exe text_rendering/vwf_sprite/vwf_sprite.S
	bin/armips.exe text_rendering/vwf_script/vwf_script.S
	bin/armips.exe text_rendering/vwf_script/battle_1.S
	bin/armips.exe text_rendering/vwf_script/battle_2.S
	bin/armips.exe text_rendering/control_characters/control_characters.S
	bin/armips.exe text/text.S
	bin/armips.exe text_positioning/names/names.S
	bin/armips.exe text_positioning/menu/menu.S
	bin/armips.exe text_positioning/battle_text/battle_text.S
	bin/armips.exe misc/name_select.S
