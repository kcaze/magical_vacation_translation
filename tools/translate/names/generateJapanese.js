function generateJapanese(names) {
  var character_count = 0;
  var translated_character_count = 0;

  names.forEach(function(section) {
    for (var ii = 0; ii < section.length; ii++) {
      section[ii].Japanese = '';
      for (var jj = 0; jj < 16; jj += 2) {
        var v = (section[ii].u8[jj] << 8) + section[ii].u8[jj+1];
        if (v == 0xFFFF) {
          break;
        }
        if (table[v]) {
          section[ii].Japanese += table[v];
          character_count += 1;
          if (section[ii].English) {
            translated_character_count += 1;
          }
        } else {
          console.log("Did not find glyph ", v, " at ", ii, jj, section.length);
        }
      }
    }
  });
  console.log(translated_character_count, "out of", character_count, "characters translated!");
  console.log("That's", translated_character_count / character_count*100, "%!");
}
