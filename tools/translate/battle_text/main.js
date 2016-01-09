var battle_text;
var number = 0;
var HEADER_SIZE = 0xBA;
var BINARY_SIZE = 0x4DD;

function readJSON(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    battle_text = JSON.parse(e.target.result);
    document.getElementById('english').disabled = false;
    document.getElementById('comments').disabled = false;
    document.getElementById('number').disabled = false;
    document.getElementById('export_json').disabled = false;
    document.getElementById('export_binary').disabled = false;
    document.getElementById('japanese_search').disabled = false;
    document.getElementById('english_search').disabled = false;

    document.getElementById('max_number').innerHTML = battle_text.length - 1;
    document.getElementById('number').max = battle_text.length - 1;
    document.getElementById('number').value = 0;

    // Called each time so that updates to the parsing are reflected.
    generateJapanese(battle_text);
  };
  fileReader.readAsText(file);
}

function exportJSON() {
  // saveAs implemented by lib/FileSaver.js
  saveAs(
    new Blob(
      [JSON.stringify(battle_text, null, 2)],
      {type: 'text/plain;charset-utf-8'}
    ),
    '_battle_text.json'
  );
  console.log('Exported battle text!');
}

function exportBinary() {
  var binary = new Uint8Array(BINARY_SIZE);
  var idx = HEADER_SIZE;
  for (var ii = 0; ii < battle_text.length; ii++) {
    var data = [];

    if (battle_text[ii].English == '') {
      // Copy original data.
      for (jj = 0; jj < battle_text[ii].u8.length; jj++) {
        data.push(battle_text[ii].u8[jj]);
      }
    } else {
      data = parseEnglish(battle_text[ii].English);
    }

    for (var jj = 0; jj < data.length; jj++) {
      binary[idx + jj] = data[jj];
    }

    var offset = idx;
    binary[4 + 2*ii] = offset % 256;
    binary[5 + 2*ii] = offset >> 8;

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
  binary[0] = 0x00; binary[1] = 0x00; binary[2] = 0x5A; binary[3] = 0x00;

  // Duplicate the last offset
  //binary[2*script.length+1] = binary[2*script.length - 1];
  //binary[2*script.length] = binary[2*script.length - 2];

  saveAs(
    new Blob([new DataView(binary.buffer)], {type: 'application/octet-stream'}),
    "battle_text.bin"
  );

  console.log('Exported binary!');
}

function japanese_search() {
  var text = document.getElementById('japanese_search_text').value;
  document.getElementById('search_results').innerHTML = '';
  for (var ii = 0; ii < battle_text.length; ii++) {
    if (battle_text[ii].Japanese.indexOf(text) != -1) {
      document.getElementById('search_results').innerHTML += ii + '<br>';
    }
  }
}

function english_search() {
  var text = document.getElementById('english_search_text').value;
  document.getElementById('search_results').innerHTML = '';
  for (var ii = 0; ii < battle_text.length; ii++) {
    if (battle_text[ii].English.indexOf(text) != -1) {
      document.getElementById('search_results').innerHTML += ii + '<br>';
    }
  }
}

function readBinary(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    binary = new Uint8Array(e.target.result);
    generateJSON(binary);
  };
  fileReader.readAsArrayBuffer(file);
}

function generateJSON(binary) {
  battle_text = [];
  for (var ii = 2; ii < 0xBA/2; ii++) {
    var text = {
      English: '',
      Japanese: '',
      Comments: '',
      u8: []
    };
    var o1 = binary[2*ii] + (binary[2*ii + 1] << 8);
    var o2;
    if (ii + 1 == 0xBA/2) {
      o2 = binary.length - 1;
    } else {
      o2 = binary[2*ii + 2] + (binary[2*ii + 3] << 8);
    }
    for (var jj = 0; jj < o2 - o1; jj++) {
      text.u8.push(binary[o1 + jj]);
    }
    battle_text.push(text);
  }
  document.getElementById('export_json').disabled = false;
}

document.getElementById('binary')
  .addEventListener('change', readBinary, false);

document.getElementById('json')
  .addEventListener('change', readJSON, false);

document
  .getElementById('export_json')
  .addEventListener('click', exportJSON, false);

document
  .getElementById('export_binary')
  .addEventListener('click', exportBinary, false);

document
  .getElementById('number')
  .addEventListener('change', function(e) {
    number = e.target.value;
    document.getElementById('japanese').innerHTML = battle_text[number].Japanese;
    document.getElementById('english').value = battle_text[number].English;
    document.getElementById('comments').value = battle_text[number].Comments;
  }, false);

document
  .getElementById('english')
  .addEventListener('change', function(e) {
    battle_text[number].English = document.getElementById('english').value;
  });

document
  .getElementById('comments')
  .addEventListener('change', function(e) {
    battle_text[number].Comments = document.getElementById('comments').value;
  });

document
  .getElementById('japanese_search')
  .addEventListener('click', japanese_search);

document
  .getElementById('english_search')
  .addEventListener('click', english_search);
