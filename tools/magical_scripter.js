var original_script;
var yaml_script;
var current_dialogue_number;
var HEADER_LENGTH = 12006;

function readYAMLScript(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    yaml_script = jsyaml.safeLoad(e.target.result);
    if (original_script) {
      document.getElementById('status').innerHTML = 'Loaded.';
      document.getElementById('status').className = 'green';
      setControls(true); // Activate controls
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
      document.getElementById('status').innerHTML = 'Loaded.';
      document.getElementById('status').className = 'green';
      setControls(true); // Activate controls
    }
  };
  fileReader.readAsArrayBuffer(file);
}

function setControls(enabled) {
  document.getElementById('english').disabled = !enabled;
  document.getElementById('comments').disabled = !enabled;
  document.getElementById('dialogue_number').disabled = !enabled;
  document.getElementById('export_script').disabled = !enabled;
  document.getElementById('export_binary').disabled = !enabled;

  if (enabled) {
    document.getElementById('max_dialogue_number').innerHTML = yaml_script.length - 1;
    document.getElementById('dialogue_number').max = yaml_script.length - 1;
    document.getElementById('dialogue_number').value = 0;
    current_dialogue_number = 0;
  }
}

function exportScript() {
  var export_string = jsyaml.safeDump(yaml_script);
  saveAs(new Blob([export_string], {type: 'text/plain;charset-utf-8'}), "script.yaml");
  console.log('Exported script!');
}

function exportBinary() {
  var binary = new Uint8Array(original_script.length);

  var header = [];
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

  offset = HEADER_LENGTH;
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
        console.log("English script is too long!");
      }
      binary[offset + jj] = data[jj];
    }
    header[ii] = offset % 65536;
    offset += data.length;
  }

  for (var ii = 0; ii < HEADER_LENGTH; ii += 2) {
    binary[ii] = header[ii/2] % 256;
    binary[ii+1] = header[ii/2] >> 8;
  }

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
