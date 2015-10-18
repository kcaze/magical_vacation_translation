var script = {text: {}};
var table;
var current_dialogue_number;
var HEADER_LENGTH = 12006;

function pad(s, n) {
  while (s.length < n) s = '0'+s;
  return s;
}

function readScript(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    script.u8 = new Uint8Array(e.target.result);
    convertScript();
  };
  fileReader.readAsArrayBuffer(file);
}

function readTable(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    table = jsyaml.safeLoad(e.target.result);
    convertScript();
  };
  fileReader.readAsText(file);
}

function convertScript() {
  if (!script.u8 || !table) return;

  setControls(false); // Disable controls
  document.getElementById('status').innerHTML = 'Not Loaded.';
  document.getElementById('status').className = 'red';

  script.header = [];
  var count = 0;
  var offset = 0;
  for (var ii = 0; ii < HEADER_LENGTH; ii += 2) {
    var newoffset = script.u8[ii] + (script.u8[ii+1] << 8);
    if (newoffset < offset) {
      count++;
    }
    offset = newoffset;
    script.header.push(offset + count*65536);
  }

  document.getElementById('max_dialogue_number').innerHTML = script.header.length - 1;

  var control_characters = {
    128:function(text, flags) { return '<br>'; },
    130:function(text, flags) { return ''; },
    141:function(text, flags) { for (var f in flags) flags[f] = false; return '';},
    142:function(text, flags) { flags.red = true; return '';},
    145:function(text, flags) { flags.italics = true; return '';}
  };
  var flags = {
    italics: false,
    red: false
  };
  script.text.japanese = [];
  script.text.english = [];
  script.text.comments = [];
  for (var ii = 0; ii < script.header.length-1; ii++) {
    var text = '';
    for (var jj = script.header[ii]; jj < script.header[ii+1]; jj += 2) {
      if (control_characters[script.u8[jj]]) {
        text += control_characters[script.u8[jj]](text, flags);
        jj--;
        continue;
      }

  		var value = (script.u8[jj] << 8) + script.u8[jj+1];
      text += flags.italics ? '<i>' : '';
      text += flags.red ? '<span class="red">' : '';
      text += table[value]
              ? table[value]
              : '<0x'+value.toString(16).toUpperCase()+'>';
      text += flags.red ? '</span>' : '';
      text += flags.italics ? '</i>' : '';
    }
    script.text.japanese.push(text);
    script.text.english.push('');
    script.text.comments.push('');
  }

  document.getElementById('status').innerHTML = 'Loaded.';
  document.getElementById('status').className = 'green';
  setControls(true); // Activate controls
}

function setControls(enabled) {
  document.getElementById('english').disabled = !enabled;
  document.getElementById('comments').disabled = !enabled;
  document.getElementById('dialogue_number').disabled = !enabled;
  document.getElementById('export_script').disabled = !enabled;
  document.getElementById('export_binary').disabled = !enabled;

  if (enabled) {
    document.getElementById('dialogue_number').max = script.header.length - 1;
    document.getElementById('dialogue_number').value = 0;
    current_dialogue_number = 0;
  }
}

function exportScript() {
  var export_script = [];
  for (var ii = 0; ii < script.text.japanese.length; ii++) {
    export_script.push({
      Japanese: script.text.japanese[ii],
      English: script.text.english[ii],
      Comments: script.text.comments[ii],
    });
  }
  var export_string = jsyaml.safeDump(export_script);
  saveAs(new Blob([export_string], {type: 'text/plain;charset-utf-8'}), "script.yaml");
  console.log('Exported script!');
}

function exportBinary() {
  var binary = new Uint8Array(script.u8.length);

  var count = 0;
  for (var ii = 0; ii < HEADER_LENGTH/2; ii++) {
    binary[2*ii] = script.u8[2*ii];
    binary[2*ii+1] = script.u8[2*ii+1];

    var offset = script.header[ii];
    var length = script.header[ii+1] - script.header[ii];
    var eol = 4;
    var noop = 255;

    if (offset >= HEADER_LENGTH && length > 0) {
      if (script.text.english[ii] == '') {
        for (var jj = 0; jj < length; jj++) {
          binary[offset + jj] = script.u8[offset + jj];
        }
      } else {
        var english = [];
        for (var jj = 0; jj < script.text.english[ii].length; jj++) {
          if (script.text.english[ii][jj] == '\\') {
            var control_code = parseInt(
                script.text.english[ii].substring(jj+1, jj+3),
                16);
            english.push(control_code);
            jj += 2;
          } else {
            english.push(script.text.english[ii].charCodeAt(jj));
          }
        }
        english.push(eol);
        english.push(eol);

        if (english.length > length) {
          console.log("WARNING: English is too long!")
        }

        for (var jj = 0; jj < length; jj++) {
          binary[offset + jj] = english[jj] ? english[jj] : noop;
        }
      }
    }

  }

  saveAs(new Blob([new DataView(binary.buffer)], {type: 'application/octet-stream'}), "script.bin");
  console.log('Exported binary!');
}

document
  .getElementById('script')
  .addEventListener('change', readScript, false);

document
  .getElementById('table')
  .addEventListener('change', readTable, false);

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
    document.getElementById('japanese').innerHTML = script.text.japanese[current_dialogue_number];
    document.getElementById('english').value = script.text.english[current_dialogue_number];
    document.getElementById('comments').value = script.text.comments[current_dialogue_number];
  }, false);

document
  .getElementById('english')
  .addEventListener('change', function(e) {
    script.text.english[current_dialogue_number] = document.getElementById('english').value;
  });

document
  .getElementById('comments')
  .addEventListener('change', function(e) {
    script.text.comments[current_dialogue_number] = document.getElementById('comments').value;
  });
