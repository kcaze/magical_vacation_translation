This directory stores code used to modify how the game renders text on-screen.

vwf_sprite: This hacks the sprite-based text rendering routine used mostly for
           the menu to render a variable width font.
vwf_menu: This hacks the tile-based text rendering routine used in the menu to
          render a variable width font.
vwf_script: This hacks the tile-based text rendering routine used for the
            script to render a variable width font.

RAM used:
0x203FFF0 [byte] = shift variable for vwf_script
0x203FFF1 [byte] = shift variable for vwf_sprite
0x203FFF2 [byte] = index into which font set we're using
0x203FFF4 [word] = variables for vwf_menu (it's messy)
0x203FFF8 [word] = reserved space for vwf_menu (it's complicated)
