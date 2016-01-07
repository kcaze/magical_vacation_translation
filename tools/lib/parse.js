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

  /* Flip the order of characters in each pair and pad appropriately. */
  var ii = 0;
  var parsed = [];
  var argument_taking_control_characters = {
    0x00: true,
    0x85: true,
    0x86: true,
    0x87: true,
    0x8b: true,
  }
  while (ii < initial_parsed.length) {
    if (initial_parsed[ii] >= 0x80 || initial_parsed[ii] == 0) {
      if (argument_taking_control_characters[initial_parsed[ii]]) {
        parsed.push(initial_parsed[ii]);
        parsed.push(initial_parsed[ii+1]);
        ii += 2;
      } else {
        parsed.push(initial_parsed[ii]);
        ii++;
      }
    }
    else if (ii+1 == parsed.length || initial_parsed[ii+1] >= 0x80) {
      parsed.push(0x00);
      parsed.push(initial_parsed[ii]);
      ii++;
    } else {
      parsed.push(initial_parsed[ii+1]);
      parsed.push(initial_parsed[ii]);
      ii += 2;
    }
  }

  return parsed;
}
