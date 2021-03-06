var names;
var section = 0;
var number = 0;
var section_names = [
  'attacks',
  'items',
  'statuses',
  'spells',
  'monsters',
  'characters',
  'genders',
  'spirits',
  'species',
  'elements',
  'places',
  'rankings'
];

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
    document.getElementById('japanese_search').disabled = false;
    document.getElementById('english_search').disabled = false;

    document.getElementById('max_number').innerHTML = names[0].length - 1;
    document.getElementById('number').max = names[0].length - 1;
    document.getElementById('number').value = 0;

    // Called each time so that updates to the parsing are reflected.
    generateJapanese(names);
  };
  fileReader.readAsText(file);
}

function exportJSON() {
  if (!names) return;
  // saveAs implemented by lib/FileSaver.js
  saveAs(
    new Blob(
      [JSON.stringify(names, null, 2)],
      {type: 'text/plain;charset-utf-8'}
    ),
    '_names.json'
  );
}

// Exporting names at 32 bits per name.
function exportBinary() {
  if (!names) return;
  var binary = generateBinary(names[section]);
  saveAs(
    new Blob([new DataView(binary.buffer)], {type: 'application/octet-stream'}),
    section_names[section] + ".bin"
  );
}

function exportAll() {
  for (var ii = 0; ii < names.length; ii++) {
    var binary = generateBinary(names[ii]);
    saveAs(
      new Blob([new DataView(binary.buffer)], {type: 'application/octet-stream'}),
      section_names[ii] + ".bin"
    );
  }
}

function generateBinary(name) {
  var binary = new Uint8Array(name.length*32);
  for (var ii = 0; ii < name.length; ii++) {
    // First write all 0xFF's.
    for (var jj = 0; jj < 32; jj++) {
      binary[ii*32 + jj] = 0xFF;
    }

    if (name[ii].English == '') {
      // Copy original data.
      for (var jj = 0; jj < 16; jj++) {
        binary[ii*32 + jj] = name[ii].u8[jj];
      }
    } else {
      var data = parseEnglish(processSpecialCharacters(substituteMacros(name[ii].English)));
      if (data.length > 32) {
        console.log("WARNING: Name", name[ii].English, "(" + ii + ")", "is too long! Truncating!");
      }
      for (var jj = 0; jj < Math.min(data.length, 32); jj++) {
        binary[ii*32 + jj] = data[jj];
      }
    }
  }
  return binary;
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

function japanese_search() {
  var text = document.getElementById('japanese_search_text').value;
  document.getElementById('search_results').innerHTML = '';
  for (var ii = 0; ii < names[section].length; ii++) {
    if (names[section][ii].Japanese.indexOf(text) != -1) {
      document.getElementById('search_results').innerHTML += ii + '<br>';
    }
  }
}

function english_search() {
  var text = document.getElementById('english_search_text').value;
  document.getElementById('search_results').innerHTML = '';
  for (var ii = 0; ii < names[section].length; ii++) {
    if (names[section][ii].English.indexOf(text) != -1) {
      document.getElementById('search_results').innerHTML += ii + '<br>';
    }
  }
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
  .getElementById('export_binary')
  .addEventListener('click', exportBinary, false);

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
    number = parseInt(e.target.value, 10);
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

document
  .getElementById('japanese_search')
  .addEventListener('click', japanese_search);

document
  .getElementById('english_search')
  .addEventListener('click', english_search);

document.addEventListener('keydown', function (e) {
  if (!e.ctrlKey) return;
  var preventDefault = true;
  switch (String.fromCharCode(e.keyCode)) {
  case 'H':
    document.getElementById('number').value = Math.max(0, number-1);
    break;
  case 'L':
    document.getElementById('number').value = Math.min(names[section].length-1, number+1);
    break;
  case 'E':
    exportJSON();
    exportAll();
    break;
  default:
    preventDefault = false;
  }
  if (preventDefault) {
    e.preventDefault();
    e.stopPropagation();
  }
});

function heartBeat() {
  if (!names) return;
  var newNumber = parseInt(document.getElementById('number').value, 10);
  if (number != newNumber) {
    number = newNumber;
    document.getElementById('japanese').innerHTML = names[section][number].Japanese;
    document.getElementById('english').value = names[section][number].English;
    document.getElementById('comments').value = names[section][number].Comments;
  }
  names[section][number].English = document.getElementById('english').value;
  names[section][number].Comments = document.getElementById('comments').value;
}
window.setInterval(heartBeat, 100);
