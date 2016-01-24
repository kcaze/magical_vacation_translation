// Perform macro substitution (non-recursive)
function substituteMacros(english) {
  var strings = english.split("$");
  if (strings.length % 2 == 0) {
    console.log("Missing terminating '$' in text '" + english + "'");
    return;
  }
  for (var ii = 1; ii < strings.length; ii += 2) {
    if (!glossary[strings[ii]]) {
      console.log ("Glossary name '" + strings[ii] + "' doesn't exist!");
      return;
    }
    strings[ii] = glossary[strings[ii]];
  }
  return strings.join("");
}

// Auto line break and indentation for script dialogue. Call after initial parse.
function preprocessScript(bytes) {
  var parts = bytes.split(0x40); // Split at @ symbol.
  if (parts.length != 2) return bytes;
  var lines = parts[1].split(0x80); 
}

// Processes escaped hex values and alignment characters.
function processSpecialCharacters(english) {
  var initial_parsed = [];
  for (var ii = 0; ii < english.length; ii++) {
    var c = english[ii];
    if (c == '\\') {
      // Insert a 1 byte hexadecimal value (e.g. '\8e').
      initial_parsed.push(String.fromCharCode(parseInt(english.substring(ii+1, ii+3), 16)));
      ii += 2;
    } else if (c == '\n') {
      // Ignore newlines.
    } else if (c == '|') {
      // Aligns the next character at a 2 byte boundary, padding with 0's.
      initial_parsed.push(String.fromCharCode(0x101));
    } else if (c == '`') {
      // Resets the alignment.
      initial_parsed.push(String.fromCharCode(0x102));
    } else {
      initial_parsed.push(c);
    }
  }
  return initial_parsed.join("");
}

function parseEnglish(english) {
  english = String.fromCharCode(0x1F, 0x00) + english + String.fromCharCode(0x101, 0xFF, 0xFF);
  var ii = 0;
  var alignment = 0;
  var parsed = [];
  for (var ii = 0; ii < english.length; ii++) {
    var n = english.charCodeAt(ii);
    if (n == 0x101) {
      if (alignment == 1) {
        parsed.push(0x00);
        alignment = 0;
      }
    } else if (n == 0x102) {
      alignment = 0;
    } else {
      parsed.push(n);
      alignment ^= 1;
    }
  }
  return parsed;
}
