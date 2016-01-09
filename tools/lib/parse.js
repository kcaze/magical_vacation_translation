function parseEnglish(english) {
  var initial_parsed = [];
  for (var ii = 0; ii < english.length; ii++) {
    var c = english[ii];
    if (c == '\\') {
      // Insert a 1 byte hexadecimal value (e.g. '\8e').
      initial_parsed.push(parseInt(english.substring(ii+1, ii+3), 16));
      ii += 2;
    } else if (c == '\n') {
      // Ignore newlines.
    } else if (c == '|') {
      // Aligns the next character at a 2 byte boundary, padding with 0's.
      initial_parsed.push(-1);
    } else if (c == '{') {
      // Glossary substitution.
      var end = english.indexOf('}', ii+1);
      if (end == -1) {
        console.log("Missing terminating '}' in text '" + english + "'");
        return;
      }
      var name = english.substring(ii+1, end);
      if (!glossary[name]) {
        console.log("Glossary name '"+ name +"' doesn't exist!")
        return;
      }
      for (var jj = 0; jj < glossary[name].length; jj++) {
        initial_parsed.push(glossary[name].charCodeAt(jj));
      }
      ii += name.length + 1;
    } else if (c == '^') {
      initial_parsed.push(0x1F);
    } else {
      initial_parsed.push(c.charCodeAt(0));
    }
  }
  initial_parsed.push(-1);

  var ii = 0;
  var alignment = 0;
  var parsed = [];
  initial_parsed.forEach(function (n) {
    if (n != -1) {
      parsed.push(n);
      alignment ^= 1;
    } else if (alignment == 1) {
      parsed.push(0x00);
      alignment ^= 1;
    }
  })
  // Add ending 0xFFFF.
  parsed.push(0xFF);
  parsed.push(0xFF);
  return parsed;
}
