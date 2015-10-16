var script = {};
var table;

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
  var HEADER_LENGTH = 12006;

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

  script.text = [];
  for (var ii = 0; ii < script.header.length-1; ii++) {
    var text = '';
    for (var jj = script.header[ii]; jj < script.header[ii+1]; jj += 2) {
      if (script.u8[jj] == 128) {
        text += '\n';
        jj--;
        continue;
      }

  		var value = (script.u8[jj] << 8) + script.u8[jj+1];
      text += table[value]
              ? table[value]
              : '<0x'+value.toString(16).toUpperCase()+'>';
    }
    script.text.push(text);
  }

  document.getElementById('status').innerHTML = 'Loaded.';
  document.getElementById('status').className = 'green';
  setControls(true); // Activate controls
}

function setControls(enabled) {
  document.getElementById('japanese').disabled = !enabled;
  document.getElementById('dialogue_number').disabled = !enabled;

  if (enabled) {
    document.getElementById('dialogue_number').max = script.header.length - 1;
    document.getElementById('dialogue_number').value = 0;
  }
}

document
  .getElementById('script')
  .addEventListener('change', readScript, false);

document
  .getElementById('table')
  .addEventListener('change', readTable, false);

document
  .getElementById('dialogue_number')
  .addEventListener('change', function(e) {
    document.getElementById('japanese').innerHTML = script.text[e.target.value];
  }, false);
