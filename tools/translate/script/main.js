var script;
var current_dialogue_number;
var HEADER_LENGTH = 12006;
var BINARY_SIZE = 0x6F46E;

function readScript(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    script = JSON.parse(e.target.result);
    document.getElementById('status').innerHTML = 'Loaded.';
    document.getElementById('status').className = 'green';
    document.getElementById('english').disabled = false;
    document.getElementById('comments').disabled = false;
    document.getElementById('dialogue_number').disabled = false;
    document.getElementById('export_script').disabled = false;
    document.getElementById('export_binary').disabled = false;
    document.getElementById('japanese_search').disabled = false;
    document.getElementById('english_search').disabled = false;

    document.getElementById('max_dialogue_number').innerHTML = script.length - 1;
    document.getElementById('dialogue_number').max = script.length - 1;
    document.getElementById('dialogue_number').value = 0;
    current_dialogue_number = 0;

    // Called each time so that updates to the script parsing are reflected.
    generateJapaneseScript(script);
  };
  fileReader.readAsText(file);
}

function exportScript() {
  // saveAs implemented by lib/FileSaver.js
  saveAs(
    new Blob(
      [JSON.stringify(script, null, 2)],
      {type: 'text/plain;charset-utf-8'}
    ),
    'script.json'
  );
  console.log('Exported script!');
}

function exportBinary() {
  var binary = new Uint8Array(BINARY_SIZE);

  var idx = 2*(script.length+1);
  for (var ii = 2; ii < script.length; ii++) {
    var data = [];

    if (script[ii].English == '') {
      // Copy original data.
      for (jj = 0; jj < script[ii].u8.length; jj++) {
        data.push(script[ii].u8[jj]);
      }
    } else {
      data = parseEnglish(script[ii].English);
    }

    for (var jj = 0; jj < data.length; jj++) {
      binary[idx + jj] = data[jj];
    }

    var offset = idx % 65536;
    binary[2*ii] = offset % 256;
    binary[2*ii+1] = offset >> 8;

    idx += data.length;
  }

  // Warn if the English script is too long.
  if (idx >= BINARY_SIZE) {
    console.log(
      "WARNING: English script has length ",
      idx,
      " which is ",
      idx - BINARY_SIZE + 1,
      " bytes too long!"
    );
  }

  // The first 2 offsets are hardcoded.
  binary[0] = 0x00; binary[1] = 0x00; binary[2] = 0x70; binary[3] = 0x17;

  // Duplicate the last offset
  binary[2*script.length+1] = binary[2*script.length - 1];
  binary[2*script.length] = binary[2*script.length - 2];

  saveAs(
    new Blob([new DataView(binary.buffer)], {type: 'application/octet-stream'}),
    "script.bin"
  );
  console.log('Exported binary!');
}

function japanese_search() {
  var text = document.getElementById('japanese_search_text').value;
  document.getElementById('search_results').innerHTML = '';
  for (var ii = 0; ii < script.length; ii++) {
    if (script[ii].Japanese.indexOf(text) != -1) {
      document.getElementById('search_results').innerHTML += ii + '<br>';
    }
  }
}

function english_search() {
  var text = document.getElementById('english_search_text').value;
  document.getElementById('search_results').innerHTML = '';
  for (var ii = 0; ii < script.length; ii++) {
    if (script[ii].English.indexOf(text) != -1) {
      document.getElementById('search_results').innerHTML += ii + '<br>';
    }
  }
}

function parseEnglish(english) {
  var initial_parsed = [];
  for (var ii = 0; ii < english.length; ii++) {
    var c = english[ii];
    if (c == '\\') {
      initial_parsed.push(parseInt(english.substring(ii+1, ii+3), 16));
      ii += 2;
    } else if (c == '\n') {
      initial_parsed.push(0x80);
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

document
  .getElementById('script')
  .addEventListener('change', readScript, false);

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
    document.getElementById('japanese').innerHTML = script[current_dialogue_number].Japanese;
    document.getElementById('english').value = script[current_dialogue_number].English;
    document.getElementById('comments').value = script[current_dialogue_number].Comments;
  }, false);

document
  .getElementById('english')
  .addEventListener('change', function(e) {
    script[current_dialogue_number].English = document.getElementById('english').value;
  });

document
  .getElementById('comments')
  .addEventListener('change', function(e) {
    script[current_dialogue_number].Comments = document.getElementById('comments').value;
  });

document
  .getElementById('japanese_search')
  .addEventListener('click', japanese_search);

document
  .getElementById('english_search')
  .addEventListener('click', english_search);
