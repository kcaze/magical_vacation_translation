var charWidths = {};
[3,3,3,7,7,7,7,1,3,3,7,7,4,7,1,7,
6,5,6,6,6,6,6,6,6,6,1,4,7,7,7,7,
7,7,6,6,6,6,5,6,6,5,4,6,5,7,7,7,
6,7,6,6,5,7,7,7,6,7,6,7,7,7,7,7,
7,6,6,5,6,6,4,6,6,1,3,6,1,7,7,6,
6,6,4,5,4,6,5,7,5,5,4,7,7,7,7,7].forEach(function(w, idx) {
  charWidths[String.fromCharCode(0x20 + idx)] = w;
});


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

// Auto line break and indentation for script dialogue. Call after macro substitution and
// process special characters.
function preprocessScript(english) {
  var parts = english.split("@"); // Split at @ symbol.
  if (parts.length != 2) return english;
  var lines = parts[1].split(String.fromCharCode(0x101, 0x80, 0x102));
  for (var ii = 0; ii < lines.length; ii++) {
    words = lines[ii].split(" ");
    widths = []
    words.forEach(function (w) {
      var width = 0;
      for (var ii = 0; ii < w.length; ii++) {
        width += (charWidths[w[ii]] || 0) + 1;
      }
      widths.push(width); // + 1 for space
    });

    var width = 0;
    var MAXWIDTH = 156;
    for (var jj = 0; jj < words.length; jj++) {
      if (width + widths[jj] > MAXWIDTH) {
        words[jj] = "|\\80`\\7f" + words[jj];
        width = widths[jj] + 0x4;
      } else {
        width += widths[jj] + 0x4; // +4 for space
      }
    }
    lines[ii] = words.join(" ");
  }
  for (var ii = 1; ii < lines.length; ii++) {
    lines[ii] = "\\7f" + lines[ii];
  }
  english = parts[0] + "@" + lines.join("|\\80`");
  return processSpecialCharacters(english);
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
