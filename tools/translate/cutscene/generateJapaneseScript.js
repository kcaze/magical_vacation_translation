function generateJapaneseScript(script) {
  var translated_character_count = 0;
  var character_count = 0;

  for (var ii = 0; ii < script.length; ii++) {
    script[ii].Japanese = "";
    for (var jj = 0; jj < script[ii].u8.length; jj += 2) {
      var c = (script[ii].u8[jj] << 8) + script[ii].u8[jj + 1];
      if (table[c]) {
        script[ii].Japanese += table[c];
      } else {
        script[ii].Japanese += "&lt;" + c.toString(16) + "&gt;";
      }
      if (script[ii].English) {
        translated_character_count++;
      }
      character_count++;
    }
  }

  console.log(translated_character_count, "out of", character_count, "characters translated!");
  console.log("That's", translated_character_count / character_count*100, "%!");
}
