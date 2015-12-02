var original;
var yaml;
var filename;
var current_object_number;

function readYAML(e) {
  var file = e.target.files[0]; // FileList object
  filename = file.name.split('.')[0];
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    yaml = jsyaml.safeLoad(e.target.result);
    if (original) {
      enable();
    }
  };
  fileReader.readAsText(file);
}

function readOriginal(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    original = new Uint8Array(e.target.result);
    if (yaml) {
      enable();
    }
  };
  fileReader.readAsArrayBuffer(file);
}

function enable() {
  document.getElementById('status').innerHTML = 'Loaded.';
  document.getElementById('status').className = 'green';
  document.getElementById('english').disabled = false;
  document.getElementById('object_number').disabled = false;
  document.getElementById('name_length').disabled = false;
  document.getElementById('export_yaml').disabled = false;
  document.getElementById('export_binary').disabled = false;
  document.getElementById('search').disabled = false;

  document.getElementById('max_object_number').innerHTML = yaml.length - 1;
  document.getElementById('object_number').max = yaml.length - 1;
  document.getElementById('object_number').value = 0;
  current_object_number = 0;

  // Called each time so that updates to the names parsing are reflected
  generateJapanese();
}

function exportYAML() {
  var export_string = jsyaml.safeDump(yaml);
  saveAs(new Blob([export_string], {type: 'text/plain;charset-utf-8'}), filename + '.yaml');
  console.log('Exported YAML!');
}

function exportBinary() {
  var name_length = document.getElementById('name_length').value;
  if (!name_length) {
    console.error('Enter a valid export name length.');
  }

  var binary = new Uint8Array(yaml.length*name_length);
  for (var ii = 0; ii < yaml.length; ii++) {
    var english = parseEnglish(yaml[ii].English + '\\1F');
    if (english.length > name_length) {
      console.log('Object ', ii, '\'s name is too long! Truncating...');
    }
    for (var jj = 0; jj < name_length; jj++) {
      binary[ii*name_length + jj] = jj < english.length ? english[jj] : 255;
    }
  }
  saveAs(new Blob([new DataView(binary.buffer)], {type: 'application/octet-stream'}), filename + '.bin');
  console.log('Exported names with length', name_length);
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

function generateJapanese() {
  for (var ii = 0; ii < original.length / 16; ii++) {
    yaml[ii].Japanese = '';
    for (var jj = 0; jj < 8; jj++) {
      var value = (original[16*ii + 2*jj] << 8) + original[16*ii + 2*jj + 1];
      if (table[value]) {
        yaml[ii].Japanese += table[value];
      } else {
        yaml[ii].Japanese += '\\' + original[16*ii + 2*jj].toString(16);
        yaml[ii].Japanese += '\\' + original[16*ii + 2*jj + 1].toString(16);
      }
    }
  }
}

function search() {
  var text = document.getElementById('search_text').value;
  document.getElementById('search_results').innerHTML = '';
  for (var ii = 0; ii < yaml.length; ii++) {
    if (yaml[ii].Japanese.indexOf(text) != -1) {
      document.getElementById('search_results').innerHTML += ii + '<br>';
    }
  }
}

document
  .getElementById('yaml')
  .addEventListener('change', readYAML, false);

document
  .getElementById('original')
  .addEventListener('change', readOriginal, false);

document
  .getElementById('export_yaml')
  .addEventListener('click', exportYAML, false);

document
  .getElementById('export_binary')
  .addEventListener('click', exportBinary, false);

document
  .getElementById('object_number')
  .addEventListener('change', function(e) {
    current_object_number = e.target.value;
    document.getElementById('japanese').innerHTML = yaml[current_object_number].Japanese;
    document.getElementById('english').value = yaml[current_object_number].English;
  }, false);

document
  .getElementById('english')
  .addEventListener('change', function(e) {
    yaml[current_object_number].English = document.getElementById('english').value;
  });

document
  .getElementById('search')
  .addEventListener('click', search);
