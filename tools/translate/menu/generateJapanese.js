function generateJapanese(names) {
  var character_count = 0;
  var translated_character_count = 0;

  names.forEach(function(section) {
    for (var ii = 0; ii < section.length; ii++) {
      section[ii].Japanese = '';
      for (var jj = 0; jj < section[ii].u8.length; jj += 2) {
        if (section[ii].u8[jj] == 0x80) {
          section[ii].Japanese += '<br>';
          jj--;
        } else {
          var v = (section[ii].u8[jj] << 8) + section[ii].u8[jj+1];
          if (table[v]) {
            section[ii].Japanese += table[v];
            character_count += 1;
            if (section[ii].English) {
              translated_character_count += 1;
            }
          } else if (v == 0xFEFF){
            section[ii].Japanese += '\\FE\\FF';
          } else if (v == 0xFFFF) {
            section[ii].Japanese += '\\FF\\FF';
          } else {
            console.log("Did not find glyph ", v, " at ", ii, jj, section.length);
          }
        }
      }
    }
  });
  console.log(translated_character_count, "out of", character_count, "characters translated!");
  console.log("That's", translated_character_count / character_count*100, "%!");
}
