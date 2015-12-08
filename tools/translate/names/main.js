var names;
var section = 0;
var number = 0;
var HEADER_LENGTH = 12006;
var BINARY_SIZE = 0x6F46E;

function readJSON(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    names = JSON.parse(e.target.result);
    document.getElementById('english').disabled = false;
    document.getElementById('comments').disabled = false;
    document.getElementById('section').disabled = false;
    document.getElementById('number').disabled = false;
    document.getElementById('export_json').disabled = false;
    document.getElementById('export_binary').disabled = false;

    document.getElementById('max_number').innerHTML = names[0].length - 1;
    document.getElementById('number').max = names[0].length - 1;
    document.getElementById('number').value = 0;

    // Called each time so that updates to the parsing are reflected.
    generateJapanese(names);
  };
  fileReader.readAsText(file);
}

function exportJSON() {
  // saveAs implemented by lib/FileSaver.js
  saveAs(
    new Blob(
      [JSON.stringify(names, null, 2)],
      {type: 'text/plain;charset-utf-8'}
    ),
    'names.json'
  );
  console.log('Exported names!');
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
  // Append EOS character.
  parsed.push(0x1F);
  parsed.push(0x00);
  return parsed;
}

/*function readBinary(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    binary = new Uint8Array(e.target.result);
    generateJSON(binary);
  };
  fileReader.readAsArrayBuffer(file);
}

function generateJSON(binary) {
  console.log(binary.length);
  names = [];
  offsets = [
    0x3C,
    0x390,
    0x1394,
    0x14C8,
    0x1D7C,
    0x3260,
    0x34A4,
    0x34D8,
    0x35EC,
    0x3730,
    0x3854,
    0x5478,
    binary.length
  ];
  for (var ii = 0; ii < offsets.length - 1; ii++) {
    var o = offsets[ii] - 0x3C;
    var len = offsets[ii+1] - offsets[ii];
    var name = [];
    for (var jj = 0; jj < len - 16; jj += 16) {
      var n = {
        English: '',
        Japanese: '',
        Comments: '',
        u8: [],
      };
      for (var kk = 0; kk < 16; kk++) {
        n.u8.push(binary[o + jj + kk]);
      }
      name.push(n);
    }
    names.push(name);
  }
  document.getElementById('export_json').disabled = false;
}*/

document.getElementById('json')
  .addEventListener('change', readJSON, false);

document
  .getElementById('export_json')
  .addEventListener('click', exportJSON, false);

document
  .getElementById('section')
  .addEventListener('change', function(e) {
    number = 0;
    section = e.target.value;
    document.getElementById('max_number').innerHTML = names[section].length - 1;
    document.getElementById('number').max = names[section].length - 1;
    document.getElementById('number').value = 0;
    document.getElementById('japanese').innerHTML = names[section][number].Japanese;
    document.getElementById('english').value = names[section][number].English;
    document.getElementById('comments').value = names[section][number].Comments;
  }, false);

document
  .getElementById('number')
  .addEventListener('change', function(e) {
    number = e.target.value;
    document.getElementById('japanese').innerHTML = names[section][number].Japanese;
    document.getElementById('english').value = names[section][number].English;
    document.getElementById('comments').value = names[section][number].Comments;
  }, false);

document
  .getElementById('english')
  .addEventListener('change', function(e) {
    names[section][number].English = document.getElementById('english').value;
  });

document
  .getElementById('comments')
  .addEventListener('change', function(e) {
    names[section][number].Comments = document.getElementById('comments').value;
  });
