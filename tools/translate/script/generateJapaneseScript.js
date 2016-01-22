var character_names = [
  'Marsh',
  'Mallow',
  'Kirsche',
  'Blueberry',
  'Chocolat',
  'Candy',
  'Ganache',
  'Peche',
  'Lemon',
  'Cabernet',
  'Cassis',
  'Cider',
  'Arancia',
  'Latte',
  'Pistachio',
  'Olive',
  'Sesame',
  'Sardine',
  'Flounder',
  'Mackerel',
  'Bonito',
  'Tuna',
  'Traveling Putty',
  'Ricebird',
  'Dodo',
  'Pot',
  'Gummy Frog',
  'Brown',
  'Empty',
  'Empty',
  'Empty',
  'Pooka',
  'Chappy', // TODO: Not finalized
  'Puccini' // TODO: Not finalized
]

function generateJapaneseScript(script) {
  var control_characters = {
    // Newline
    0x80:function(state) {
      state.text += '<br>';
      state.idx++;
    },
    // TODO: Unknown control character
    0x81:function(state) {
      state.text += '\\81';
      state.idx++;
    },
    // TODO: Unknown control character
    0x82:function(state) {
      state.text += '\\82';
      state.idx++;
    },
    // TODO: Unknown control character
    0x83:function(state) {
      state.text += '\\83';
      state.idx++;
    },
    // TODO: Unknown control character
    0x84:function(state) {
      state.text += '\\84';
      state.idx++;
    },
    // Display player's name.
    0x85:function(state) {
      state.text += '\\' + state.u8[state.idx].toString(16);
      state.text += '\\' + state.u8[state.idx + 1].toString(16);
      state.idx += 2;
    },
    // Display character's name.
    0x86:function(state) {
      state.text += '\\' + state.u8[state.idx].toString(16);
      state.text += '\\' + state.u8[state.idx + 1].toString(16);
      state.text += '(' + character_names[state.u8[state.idx+1]] + ')';
      state.idx += 2;
    },
    // Display item's name.
    0x87:function(state) {
      state.text += '\\' + state.u8[state.idx].toString(16);
      state.text += '\\' + state.u8[state.idx + 1].toString(16);
      state.idx += 2;
    },
    // TODO: Unknown control character
    0x88:function(state) {
      state.text += '\\88';
      state.idx++;
    },
    // TODO: Unknown control character
    0x89:function(state) {
      state.text += '\\89';
      state.idx++;
    },
    // TODO: Unknown control character
    0x8A:function(state) {
      state.text += '\\8A';
      state.idx++;
    },
    // Display character portrait.
    0x8B:function(state) {
      state.text += '\\' + state.u8[state.idx].toString(16);
      state.text += '\\' + state.u8[state.idx + 1].toString(16);
      state.idx += 2;
    },
    // TODO: Unknown control character
    0x8C:function(state) {
      state.text += '\\8C';
      state.idx++;
    },
    // Reset text to normal.
    0x8D:function(state) {
      if (state.color) {
        state.text += '</span>';
      }
      if (state.italics) {
        state.text += '</i>';
      }
      state.color = '';
      state.italics = false;
      state.idx++;
    },
    // Set text color to red.
    0x8E:function(state) {
      if (state.color) {
        state.text += '</span>';
      }
      state.color = 'red';
      state.text += '<span class="red">';
      state.idx++;
    },
    // Set text color to blue.
    0x8F:function(state) {
      if (state.color) {
        state.text += '</span>';
      }
      state.color = 'blue';
      state.text += '<span class="blue">';
      state.idx++;
    },
    // TODO: Unknown control character
    0x90:function(state) {
      state.text += '\\90';
      state.idx++;
    },
    // Set text to italics
    0x91:function(state) {
      state.italics = true;
      state.text += '<i>';
      state.idx++;
    },
    // TODO: Unknown control character
    0x92:function(state) {
      state.text += '\\92';
      state.idx++;
    },
    // TODO: Unknown control character
    0x93:function(state) {
      state.text += '\\93';
      state.idx++;
    },
    // TODO: Unknown control character
    0x94:function(state) {
      state.text += '\\94';
      state.idx++;
    },
    // TODO: Unknown control character
    0x95:function(state) {
      state.text += '\\95';
      state.idx++;
    },
    // TODO: Unknown control character
    0x96:function(state) {
      state.text += '\\96';
      state.idx++;
    },
    // TODO: Unknown control character
    0x97:function(state) {
      state.text += '\\97';
      state.idx++;
    },
    // TODO: Unknown control character
    0x98:function(state) {
      state.text += '\\98';
      state.idx++;
    },
    // TODO: Unknown control character
    0x99:function(state) {
      state.text += '\\99';
      state.idx++;
    },
    // TODO: Unknown control character
    0x9A:function(state) {
      state.text += '\\9A';
      state.idx++;
    },
    // TODO: Unknown control character
    0x9B:function(state) {
      state.text += '\\9B';
      state.idx++;
    },
    // TODO: Unknown control character
    0x9C:function(state) {
      state.text += '\\9C';
      state.idx++;
    },
    // TODO: Unknown control character
    0x9D:function(state) {
      state.text += '\\9D';
      state.idx++;
    },
    // TODO: Unknown control character
    0x9E:function(state) {
      state.text += '\\9E';
      state.idx++;
    },
    // TODO: Unknown control character
    0x9F:function(state) {
      state.text += '\\9F';
      state.idx++;
    },
    // TODO: Unknown control character
    0xA0:function(state) {
      state.text += '\\A0';
      state.idx++;
    },
    // TODO: Unknown control character
    0xA1:function(state) {
      state.text += '\\A1';
      state.idx++;
    },
    // TODO: Unknown control character
    0xA2:function(state) {
      state.text += '\\A2';
      state.idx++;
    },
    // TODO: Unknown control character
    0xA3:function(state) {
      state.text += '\\A3';
      state.idx++;
    },
    // TODO: Unknown control character
    0xA4:function(state) {
      state.text += '\\A4';
      state.idx++;
    },
    // TODO: Unknown control character
    0xA5:function(state) {
      state.text += '\\A5';
      state.idx++;
    },
    // TODO: Unknown control character
    0xA6:function(state) {
      state.text += '\\A6';
      state.idx++;
    }
  };

  var character_count = 0;
  var translated_character_count = 0;

  for (var ii = 2; ii < script.length; ii++) {
    var state = {
      italics: false,
      color: '',
      idx: 0,
      u8: script[ii].u8,
      text: ''
    };
    while (state.idx < state.u8.length) {
      if (script[ii].u8[state.idx] >= 0x80) {
        var control_fn = control_characters[script[ii].u8[state.idx]];
        if (!control_fn) {
          console.log(state.idx.toString(16), script[ii].u8[state.idx].toString(16));
        }
        control_fn(state);
        continue;
      }
      var value = (script[ii].u8[state.idx] << 8) + script[ii].u8[state.idx+1];
      if (!table[value]) {
        state.text += '\\' + script[ii].u8[state.idx].toString(16);
        state.text += '\\' + script[ii].u8[state.idx+1].toString(16);
      } else {
        state.text += table[value]
      }
      state.idx += 2;
      character_count++;
      if (script[ii].English) {
        translated_character_count++;
      }
    }
    script[ii].Japanese = state.text;
  }

  console.log(translated_character_count, "out of", character_count, "characters translated!");
  console.log("That's", translated_character_count / character_count*100, "%!");
}
