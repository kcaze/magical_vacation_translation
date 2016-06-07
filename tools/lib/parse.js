var charWidths = {};
[3,3,3,7,7,7,7,1,3,3,7,7,4,7,1,7,
6,5,6,6,6,6,6,6,6,6,1,4,7,7,7,7,
7,7,6,6,6,6,5,6,6,5,4,6,5,7,7,7,
6,7,6,6,5,7,7,7,6,7,6,7,7,7,7,7,
7,6,6,5,6,6,4,6,6,1,3,6,1,7,7,6,
6,6,4,5,4,6,5,7,5,5,4,7,7,7,7,7].forEach(function(w, idx) {
  charWidths[String.fromCharCode(0x20 + idx)] = w;
});
var itemWidths = [30,69,73,90,92,60,45,74,76,95,50,72,55,55,91,74,98,50,49,80,
                  67,58,59,61,77,63,52,50,66,53,72,81,63,72,56,61,62,69,72,75,
                  76,68,80,71,64,79,63,64,69,68,67,51,47,49,36,76,48,51,84,62,
                  66,60,72,57,51,74,51,77,68,73,72,56,55,60,54,55,44,56,51,66,
                  55,77,71,34,52,73,48,67,57,75,84,43,57,63,64,62,41,47,73,52,
                  59,66,55,74,72,58,58,70,76,60,68,52,59,49,27,46,58,42,41,31,
                  39,39,37,72,36,48,61,56,68,79,61,66,82,86,77,98,80,86,89,76,
                  89,85,90,84,78,67,90,84,85,86,108,69,74,76,80,80,58,63,69,
                  71,71,62,81,69,75,75,54,59,65,67,67,59,69,68,74,74,52,55,61,
                  63,63,73,86,84,88,92,53,72,64,66,66,52,57,63,65,65,52,57,63,
                  65,65,67,72,76,80,80,58,30,52,43,49,0,0,0,0,0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,61,55,42,59,51,61,63,57,57,53,54,66,62,73,65,
                  63,57,72,69,57,49,74,66,60,52];
var characterWidths = [
  "Marsh", "Mallow", "Kirsche", "Blueberry", "Chocolat", "Candy", "Ganache",
  "Peche", "Lemon", "Cabernet", "Cassis", "Cider", "Arancia", "Latte",
  "Pistachio", "Olive", "Sesame", "Sardine", "Flounder", "Mackerel", "Bonito",
  "Tuna", "Traveling Putty", "Ricebird", "Dodo", "Pot", "Gummy Frog",
  "Brownie", "Miss Madeleine", "Empty", "Empty", "Pooka", "Chappy", "Pucine"].map(computeWidth);

function computeWidth(s) {
  var width = 0
  for (var ii = 0; ii < s.length; ii++) {
    width += charWidths[s[ii]];
  }
  return width;
}

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

function insertLineBreaks(line, newlineInsert) {
  words = line.split(" ");
  widths = []
  words.forEach(function (w) {
    var width = 0;
    for (var ii = 0; ii < w.length; ii++) {
      if (w[ii] == "\\") {
        // Player control code, assume max width of 6 * 9 = 54
        if (w[ii+1] == "8" && w[ii+2] == "5") {
          width += 54;
        } else if (w[ii+1] == "9" && w[ii+2] == "3") {
        // Money control code, assume max width of 6 * 7 = 42
          width += 42;
        } else if (w[ii+1] == "8" && w[ii+2] == "7") {
        // Item control code.
          ii += 3;
          var n = parseInt(w.substring(ii+1, ii+3), 16);
          width += itemWidths[n] + 18; // + 18 for icon
        } else if (w[ii+1] == "8" && w[ii+2] == "6") {
          ii += 3;
          var n = parseInt(w.substring(ii+1, ii+3), 16);
          width += characterWidths[n];
        }
        ii += 2;
        continue;
      }
      if (w[ii] == "|" || w[ii] == "`") continue;
      width += (charWidths[w[ii]] || 0) + 1; // + 1 for space
    }
    widths.push(width);
  });

  var width = 0;
  var MAXWIDTH = 160;
  var line = "";
  for (var jj = 0; jj < words.length; jj++) {
    if (width + widths[jj] > MAXWIDTH) {
      line += newlineInsert + words[jj];
      width = widths[jj];
    } else {
      line += " " + words[jj];
      width += widths[jj] + 0x4; // +4 for space
    }
  }
  return line.trim();
}

// Auto line break and indentation for script dialogue. Call after macro substitution and
// process special characters.
function preprocessScript(english) {
  var parts = english.split("@"); // Split at @ symbol.

  // non character dialogue
  if (parts.length != 2) {
    var lines = english.split("|\\80`");
    for (var ii = 0; ii < lines.length; ii++) {
      lines[ii] = insertLineBreaks(lines[ii], "|\\80`");
    }
    return processSpecialCharacters(lines.join("|\\80`"));
  }

  var lines = parts[1].split("|\\80`");
  for (var ii = 0; ii < lines.length; ii++) {
    lines[ii] = insertLineBreaks(lines[ii], "|\\80`\\7f");
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
  //english = String.fromCharCode(0x1F, 0x00) + english + String.fromCharCode(0x101, 0xFF, 0xFF);
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
  if (parsed.length % 2) {
    parsed.push(0x00);
  }
  return parsed;
}
