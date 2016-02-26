The sprite text function sucks.

Instead, we'll replace all calls to 0x080B58F0 which sets up one word / text
item for drawing with a call to 0x080B57D8 which is the hacked bg1 text function.
