var rom;
var offset = 0;
var length = 0;

function pad(s, n) {
  while (s.length < n) {
    s = '0' + s;
  }
  return s;
}

function readROM(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    rom = new Uint8Array(e.target.result);
  };
  fileReader.readAsArrayBuffer(file);
}

function update() {
  var original = '';
  var tabled = '';
  for (var ii = 0; ii < length; ii++) {
    original += pad(rom[offset+ii].toString(16), 2) + ' ';
    original += (ii % 16 == 15) ?  '\n' : ' ';
  }
  for (var ii = 0; ii < length/2; ii++) {
    var v = (rom[offset + 2*ii] << 8) + rom[offset + 2*ii + 1];
    if (table[v]) {
      tabled += table[v]
    } else {
      tabled += '�';
    }
    tabled += (ii % 8 == 7) ? '\n' : ' ';
  }
  document.getElementById('original').innerHTML = original;
  document.getElementById('tabled').innerHTML = tabled;
}

document
  .getElementById('rom')
  .addEventListener('change', readROM, false);

document
  .getElementById('offset')
  .addEventListener('change', function(e) {
    offset = parseInt(document.getElementById('offset').value, 10);
    update();
  }, false);

document
  .getElementById('length')
  .addEventListener('change', function(e) {
    length = parseInt(document.getElementById('length').value, 10);
    update();
  }, false);
