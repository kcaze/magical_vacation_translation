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
          } else {
            section[ii].Japanese += '\\' + (v >> 8).toString(16);
            section[ii].Japanese += '\\' + (v & 0xFF).toString(16);
            // 0xFBFF = Display spirit icon. 0xFAFF = change font color
            // The next 2 bytes are a parameter for these control characters
            if (v == 0xFBFF || v == 0xFAFF) {
              jj += 2;
              var v = (section[ii].u8[jj] << 8) + section[ii].u8[jj+1];
              section[ii].Japanese += '\\' + (v >> 8).toString(16);
              section[ii].Japanese += '\\' + (v & 0xFF).toString(16);
            }
          }
        }
      }
    }
  });
  console.log(translated_character_count, "out of", character_count, "characters translated!");
  console.log("That's", translated_character_count / character_count*100, "%!");
}
