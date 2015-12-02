var original_script;
var yaml_script;
var header;
var current_dialogue_number;
var HEADER_LENGTH = 404;

function readYAMLScript(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    yaml_script = jsyaml.safeLoad(e.target.result);
  };
  fileReader.readAsText(file);
}

function readOriginalScript(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    original_script = new Uint8Array(e.target.result);
    enable();
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

  document.getElementById('max_dialogue_number').innerHTML = HEADER_LENGTH - 1;
  document.getElementById('dialogue_number').max = HEADER_LENGTH - 1;
  document.getElementById('dialogue_number').value = 0;
  current_dialogue_number = 0;

  // Called each time so that updates to the script parsing are reflected.
  generateJapaneseScript();
}

function exportScript() {
  var export_string = jsyaml.safeDump(yaml_script);
  saveAs(new Blob([export_string], {type: 'text/plain;charset-utf-8'}), "menu_text.yaml");
  console.log('Exported script!');
}

function exportBinary() {
  var binary = new Uint8Array(original_script.length);
  var original_lengths = [];
  var original_offsets = [];
  for (var ii = 0; ii < HEADER_LENGTH; ii++) {
    var begin = original_script[2*ii] + (original_script[2*ii+1] << 8);
    var end = original_script[2*ii+2] + (original_script[2*ii+3] << 8);
    original_lengths.push(end - begin);
    original_offsets.push(2*HEADER_LENGTH + begin);
  }
  original_lengths[HEADER_LENGTH-1] = 4;

  var idx = 0;
  for (var ii = 0; ii < HEADER_LENGTH; ii++) {
    binary[2*ii] = idx & 0xFF;
    binary[2*ii+1] = idx >> 8;
    if (yaml_script[ii].English == '') {
      for (var jj = 0; jj < original_lengths[ii]; jj++) {
        binary[2*HEADER_LENGTH + idx] = original_script[original_offsets[ii] + jj];
        idx++;
      }
    } else {
      var bytes = parseEnglish(yaml_script[ii].English);
      for (var jj = 0; jj < bytes.length; jj++) {
        binary[2*HEADER_LENGTH + idx] = bytes[jj]
        idx++;
      }
    }
  }

  saveAs(new Blob([new DataView(binary.buffer)], {type: 'application/octet-stream'}), "menu_text.bin");
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
  parsed.push(0xff);
  parsed.push(0xff);
  return parsed;
}

function generateJapaneseScript() {
  if (!yaml_script) {
    yaml_script = [];
    for (var ii = 0; ii < HEADER_LENGTH; ii++) {
      yaml_script.push({Japanese: '', English: '', Comments: ''});
    }
  }

  for (var ii = 0; ii < HEADER_LENGTH - 1; ii++) {
    yaml_script[ii].Japanese = '';
    var begin = original_script[2*ii] + (original_script[2*ii+1] << 8);
    var end = original_script[2*ii+2] + (original_script[2*ii+3] << 8);
    for (var jj = begin; jj < end; jj += 2) {
      var idx = jj + 2*HEADER_LENGTH;
      var value = (original_script[idx] << 8) + original_script[idx+1];
      if (!table[value]) {
        yaml_script[ii].Japanese += "\\" + value.toString(16);
      } else {
        yaml_script[ii].Japanese += table[value];
      }
    }
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
