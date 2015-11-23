var original_script;
var yaml_script;
var header;
var current_dialogue_number;
var HEADER_LENGTH = 12006;

function readYAMLScript(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    yaml_script = jsyaml.safeLoad(e.target.result);
    if (original_script) {
      enable();
    }
  };
  fileReader.readAsText(file);
}

function readOriginalScript(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    original_script = new Uint8Array(e.target.result);
    if (yaml_script) {
      enable();
    }
  };
  fileReader.readAsArrayBuffer(file);
}

function enable() {
  document.getElementById('status').innerHTML = 'Loaded.';
  document.getElementById('status').className = 'green';
  document.getElementById('english').disabled = false;
  document.getElementById('comments').disabled = false;
  document.getElementById('dialogue_number').disabled = false;
  document.getElementById('export_script').disabled = false;
  document.getElementById('export_binary').disabled = false;
  document.getElementById('search').disabled = false;

  document.getElementById('max_dialogue_number').innerHTML = yaml_script.length - 1;
  document.getElementById('dialogue_number').max = yaml_script.length - 1;
  document.getElementById('dialogue_number').value = 0;
  current_dialogue_number = 0;

  // Header is used in multiple functions so we generate here and store in a
  // global variable.
  generateOriginalHeader();
  // Called each time so that updates to the script parsing are reflected.
  generateJapaneseScript();
}

function exportScript() {
  var export_string = jsyaml.safeDump(yaml_script);
  saveAs(new Blob([export_string], {type: 'text/plain;charset-utf-8'}), "script.yaml");
  console.log('Exported script!');
}

function exportBinary() {
  var binary = new Uint8Array(original_script.length);

  var offset = HEADER_LENGTH;
  var newheader;
  for (var ii = 2; ii < header.length-1; ii++) {
    var data = [];
    if (yaml_script[ii].English == '') {
      for (var jj = header[ii]; jj < header[ii+1]; jj++) {
        data.push(original_script[jj]);
      }
    } else {
      data = parseEnglish(yaml_script[ii].English);
    }
    for (var jj = 0; jj < data.length; jj++) {
      if (offset+jj >= original_script.length) {
        console.log("English script is too long!", offset, jj);
      }
      binary[offset + jj] = data[jj];
    }
    newheader = offset % 65536;
    binary[2*ii] = newheader % 256;
    binary[2*ii+1] = newheader >> 8;
    offset += data.length;
  }

  // Preserve first two header values.
  for (var ii = 0; ii < 4; ii++) {
    binary[ii] = original_script[ii];
  }
  // Fill in last header value.
  binary[HEADER_LENGTH - 2] = newheader % 256;
  binary[HEADER_LENGTH - 1] = newheader >> 8;

  saveAs(new Blob([new DataView(binary.buffer)], {type: 'application/octet-stream'}), "script.bin");
  console.log('Exported binary!');
}

function parseEnglish(english) {
  var parsed = [];
  var ii = 0;
  while (ii < english.length) {
    var curr = english[ii];
    var next = english[ii+1];
    if (curr == '\\') {
      parsed.push(parseInt(english.substring(ii+1, ii+3), 16));
      ii += 3;
      continue;
    } else if (curr == '\n') {
      parsed.push(128);
      ii += 1;
      continue;
    }
    if (next && next != '\\' && next != '\n') {
      parsed.push(next.charCodeAt(0));
      ii += 2;
    } else {
      parsed.push(0);
      ii += 1;
    }
    parsed.push(curr.charCodeAt(0));
  }
  return parsed;
}

function generateJapaneseScript() {
  var control_characters = {
    // Newline
    0x80:function(state) {
      state.text += '<br>';
      state.idx++;
    },
    0x81:function(state) { state.idx++; }, // TODO: Unknown control character
    0x82:function(state) { state.idx++; }, // TODO: Unknown control character
    0x83:function(state) { state.idx++; }, // TODO: Unknown control character
    0x84:function(state) { state.idx++; }, // TODO: Unknown control character
    // Display player's name.
    0x85:function(state) {
      state.text += '\\' + original_script[state.idx].toString(16);
      state.text += '\\' + original_script[state.idx + 1].toString(16);
      state.idx += 2;
    },
    // Display character's name.
    0x86:function(state) {
      state.text += '\\' + original_script[state.idx].toString(16);
      state.text += '\\' + original_script[state.idx + 1].toString(16);
      state.idx += 2;
    },
    // Display item's name.
    0x87:function(state) {
      state.text += '\\' + original_script[state.idx].toString(16);
      state.text += '\\' + original_script[state.idx + 1].toString(16);
      state.idx += 2;
    },
    0x88:function(state) { state.idx++; }, // TODO: Unknown control character
    0x89:function(state) { state.idx++; }, // TODO: Unknown control character
    0x8A:function(state) { state.idx++; }, // TODO: Unknown control character
    // Display character portrait.
    0x8B:function(state) {
      state.text += '\\' + original_script[state.idx].toString(16);
      state.text += '\\' + original_script[state.idx + 1].toString(16);
      state.idx += 2;
    },
    0x8C:function(state) { state.idx++; }, // TODO: Unknown control character
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
    0x90:function(state) { state.idx++; }, // TODO: Unknown control character
    // Set text to italics
    0x91:function(state) {
      state.italics = true;
      state.text += '<i>';
      state.idx++;
    },
    0x92:function(state) { state.idx++; }, // TODO: Unknown control character
    0x93:function(state) { state.idx++; }, // TODO: Unknown control character
    0x94:function(state) { state.idx++; }, // TODO: Unknown control character
    0x95:function(state) { state.idx++; }, // TODO: Unknown control character
    0x96:function(state) { state.idx++; }, // TODO: Unknown control character
    0x97:function(state) { state.idx++; }, // TODO: Unknown control character
    0x98:function(state) { state.idx++; }, // TODO: Unknown control character
    0x99:function(state) { state.idx++; }, // TODO: Unknown control character
    0x9A:function(state) { state.idx++; }, // TODO: Unknown control character
    0x9B:function(state) { state.idx++; }, // TODO: Unknown control character
    0x9C:function(state) { state.idx++; }, // TODO: Unknown control character
    0x9D:function(state) { state.idx++; }, // TODO: Unknown control character
    0x9E:function(state) { state.idx++; }, // TODO: Unknown control character
    0x9F:function(state) { state.idx++; }, // TODO: Unknown control character
    0xA0:function(state) { state.idx++; }, // TODO: Unknown control character
    0xA1:function(state) { state.idx++; }, // TODO: Unknown control character
    0xA2:function(state) { state.idx++; }, // TODO: Unknown control character
    0xA3:function(state) { state.idx++; }, // TODO: Unknown control character
    0xA4:function(state) { state.idx++; }, // TODO: Unknown control character
    0xA5:function(state) { state.idx++; }, // TODO: Unknown control character
    0xA6:function(state) { state.idx++; } // TODO: Unknown control character
  };

  var character_count = 0;
  var translated_character_count = 0;
  for (var ii = 2; ii < HEADER_LENGTH/2 - 1; ii++) {
    var state = {
      italics: false,
      color: '',
      idx: header[ii],
      text: ''
    };
    while (state.idx < header[ii+1]) {
      if (original_script[state.idx] >= 0x80) {
        var control_fn = control_characters[original_script[state.idx]];
        if (!control_fn) {
          console.log(state.idx.toString(16), original_script[state.idx].toString(16));
        }
        control_fn(state);
        continue;
      }
      var value = (original_script[state.idx] << 8) + original_script[state.idx+1];
      if (!table[value]) {
        state.text += '\\' + original_script[state.idx].toString(16);
        state.text += '\\' + original_script[state.idx+1].toString(16);
      } else {
        state.text += table[value]
      }
      state.idx += 2;
      character_count++;
      if (yaml_script[ii].English) {
        translated_character_count++;
      }
    }
    yaml_script[ii].Japanese = state.text;
  }
  console.log(translated_character_count, "out of", character_count, "characters translated!");
  console.log("That's", translated_character_count / character_count*100, "%!");
}

function generateOriginalHeader() {
  header = [];
  var count = 0;
  var offset = 0;
  for (var ii = 0; ii < HEADER_LENGTH; ii += 2) {
    var newoffset = original_script[ii] + (original_script[ii+1] << 8);
    if (newoffset < offset) {
      count++;
    }
    offset = newoffset;
    header.push(offset + count*65536);
  }
}

function search() {
  var text = document.getElementById('search_text').value;
  document.getElementById('search_results').innerHTML = '';
  for (var ii = 0; ii < yaml_script.length; ii++) {
    if (yaml_script[ii].Japanese.indexOf(text) != -1) {
      document.getElementById('search_results').innerHTML += ii + '<br>';
    }
  }
}

document
  .getElementById('yaml-script')
  .addEventListener('change', readYAMLScript, false);

document
  .getElementById('original-script')
  .addEventListener('change', readOriginalScript, false);

document
  .getElementById('export_script')
  .addEventListener('click', exportScript, false);

document
  .getElementById('export_binary')
  .addEventListener('click', exportBinary, false);

document
  .getElementById('dialogue_number')
  .addEventListener('change', function(e) {
    current_dialogue_number = e.target.value;
    document.getElementById('japanese').innerHTML = yaml_script[current_dialogue_number].Japanese;
    document.getElementById('english').value = yaml_script[current_dialogue_number].English;
    document.getElementById('comments').value = yaml_script[current_dialogue_number].Comments;
  }, false);

document
  .getElementById('english')
  .addEventListener('change', function(e) {
    yaml_script[current_dialogue_number].English = document.getElementById('english').value;
  });

document
  .getElementById('comments')
  .addEventListener('change', function(e) {
    yaml_script[current_dialogue_number].Comments = document.getElementById('comments').value;
  });

document
  .getElementById('search')
  .addEventListener('click', search);
