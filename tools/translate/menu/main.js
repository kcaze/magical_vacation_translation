var menus;
var section = 0;
var number = 0;
var section_names = [
  'menu_text',
  'explanations',
  'notebook',
  'profiles',
  'name_selection',
  'element_descriptions'
];

function readJSON(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    menus = JSON.parse(e.target.result);
    document.getElementById('english').disabled = false;
    document.getElementById('comments').disabled = false;
    document.getElementById('section').disabled = false;
    document.getElementById('number').disabled = false;
    document.getElementById('export_json').disabled = false;
    document.getElementById('export_binary').disabled = false;
    document.getElementById('japanese_search').disabled = false;
    document.getElementById('english_search').disabled = false;

    document.getElementById('max_number').innerHTML = menus[0].length - 1;
    document.getElementById('number').max = menus[0].length - 1;
    document.getElementById('number').value = 0;

    // Called each time so that updates to the parsing are reflected.
    generateJapanese(menus);
  };
  fileReader.readAsText(file);
}

function exportJSON() {
  // saveAs implemented by lib/FileSaver.js
  saveAs(
    new Blob(
      [JSON.stringify(menus, null, 2)],
      {type: 'text/plain;charset-utf-8'}
    ),
    'menu.json'
  );
  console.log('Exported menus!');
}

function exportBinary() {
  var menu = menus[section];
  var data = menu.reduce(function(acc, curr) {
    acc.push(curr.English ? parseEnglish(curr.English) : curr.u8);
    return acc;
  }, []);

  var offsets = new Uint8Array(2*menu.length);
  var binary = new Uint8Array(data.reduce(function(acc, curr) {
    return acc + curr.length;
  }, 0));

  // First write all 0xFF's.
  for (var ii = 0; ii < binary.length; ii++) {
    binary[ii] = 0xFF;
  }

  var offset = 0;
  for (var ii = 0; ii < menu.length; ii++) {
    offsets[2*ii] = offset & 0xFF;
    offsets[2*ii + 1] = (offset >> 8);

    for (var jj = 0; jj < data[ii].length; jj++) {
      binary[offset + jj] = data[ii][jj];
    }

    offset += data[ii].length;
  }

  saveAs(
    new Blob([new DataView(offsets.buffer)], {type: 'application/octet-stream'}),
    section_names[section] + "_offsets.bin"
  );
  saveAs(
    new Blob([new DataView(binary.buffer)], {type: 'application/octet-stream'}),
    section_names[section] + ".bin"
  );
  console.log('Exported binary and offsets!');
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
    parsed.push(curr == '^' ? 0x1F : curr.charCodeAt(0));
  }

  if (parsed.length % 2) {
    parsed.push(0x20);
  }

  // Pad ending with two spaces 0x2020 to force drawing of remaining glyphs.
  //parsed.push(0x20);
  //parsed.push(0x20);
  // Text must end in 0xFFFF
  parsed.push(0xFF);
  parsed.push(0xFF);

  return parsed;
}

function japanese_search() {
  var text = document.getElementById('japanese_search_text').value;
  document.getElementById('search_results').innerHTML = '';
  for (var ii = 0; ii < menus[section].length; ii++) {
    if (menus[section][ii].Japanese.indexOf(text) != -1) {
      document.getElementById('search_results').innerHTML += ii + '<br>';
    }
  }
}

function english_search() {
  var text = document.getElementById('english_search_text').value;
  document.getElementById('search_results').innerHTML = '';
  for (var ii = 0; ii < menus[section].length; ii++) {
    if (menus[section][ii].English.indexOf(text) != -1) {
      document.getElementById('search_results').innerHTML += ii + '<br>';
    }
  }
}

/*
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
  console.log(binary.length);
  menus = [];
  offsets = [
    0x48,
    0x370,
    0x1F3C,
    0x2374,
    0x91DC,
    0x927C,
    0xB188,
    0xB3C8,
    0x17DB4,
    0x17F1C,
    0x18CD8,
    0x18CF4,
    0x194F4
  ];
  menus = [];
  for (var ii = 0; ii < offsets.length-1; ii += 2) {
    var menu = [];
    for (var jj = 0; jj < (offsets[ii+1] - offsets[ii])/2; jj++) {
      var m = {
        English: '',
        Japanese: '',
        Comments: '',
        u8: []
      }

      var o = offsets[ii] - 0x48;
      var o1 = binary[o + 2*jj] + (binary[o + 2*jj + 1] << 8);
      var o2;
      if (jj + 1 == (offsets[ii+1] - offsets[ii])/2) {
        o2 = offsets[ii+2] - offsets[ii+1];
      } else {
        o2 = binary[o + 2*jj + 2] + (binary[o + 2*jj + 3] << 8);
      }
      for (var kk = 0; kk < o2 - o1; kk++) {
        m.u8.push(binary[offsets[ii+1] - 0x48 + o1 + kk]);
      }
      menu.push(m);
    }
    menus.push(menu);
  }
  document.getElementById('export_json').disabled = false;
}

document.getElementById('binary')
  .addEventListener('change', readBinary, false);
*/

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
    document.getElementById('max_number').innerHTML = menus[section].length - 1;
    document.getElementById('number').max = menus[section].length - 1;
    document.getElementById('number').value = 0;
    document.getElementById('japanese').innerHTML = menus[section][number].Japanese;
    document.getElementById('english').value = menus[section][number].English;
    document.getElementById('comments').value = menus[section][number].Comments;
  }, false);

document
  .getElementById('number')
  .addEventListener('change', function(e) {
    number = e.target.value;
    document.getElementById('japanese').innerHTML = menus[section][number].Japanese;
    document.getElementById('english').value = menus[section][number].English;
    document.getElementById('comments').value = menus[section][number].Comments;
  }, false);

document
  .getElementById('english')
  .addEventListener('change', function(e) {
    menus[section][number].English = document.getElementById('english').value;
  });

document
  .getElementById('comments')
  .addEventListener('change', function(e) {
    menus[section][number].Comments = document.getElementById('comments').value;
  });

document
  .getElementById('japanese_search')
  .addEventListener('click', japanese_search);

document
  .getElementById('english_search')
  .addEventListener('click', english_search);
