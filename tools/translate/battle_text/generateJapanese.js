function generateJapanese(battle_text) {
  var character_count = 0;
  var translated_character_count = 0;

  for (var ii = 0; ii < battle_text.length; ii++) {
    battle_text[ii].Japanese = '';
    for (var jj = 0; jj < battle_text[ii].u8.length; jj += 2) {
      if (battle_text[ii].u8[jj] == 0x80) {
        battle_text[ii].Japanese += '<br>';
        jj--;
      } else {
        var v = (battle_text[ii].u8[jj] << 8) + battle_text[ii].u8[jj+1];
        if (table[v]) {
          battle_text[ii].Japanese += table[v];
          character_count += 1;
          if (battle_text[ii].English) {
            translated_character_count += 1;
          }
        } else if (v == 0xFEFF){
          battle_text[ii].Japanese += '\\FE\\FF';
        } else if (v == 0xFFFF) {
          battle_text[ii].Japanese += '\\FF\\FF';
        } else {
          battle_text[ii].Japanese += '\\' + (v >> 8).toString(16) + '\\' + (v % 256).toString(16);
        }
      }
    }
  }
  console.log(translated_character_count, "out of", character_count, "characters translated!");
  console.log("That's", translated_character_count / character_count*100, "%!");
}
