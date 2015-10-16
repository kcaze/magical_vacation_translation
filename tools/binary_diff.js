var rom = {};

function pad(s, n) {
  while (s.length < n) s = '0'+s;
  return s;
}

function readROM(which) {
  return function (e) {
    var file = e.target.files[0]; // FileList object
    var fileReader = new FileReader();
    fileReader.onload = function (e) {
      rom[which] = {};
      rom[which].u8 = new Uint8Array(e.target.result);
      rom[which].u16 = new Uint16Array(e.target.result);
      rom[which].u32 = new Uint32Array(e.target.result);
    };
    fileReader.readAsArrayBuffer(file);
  };
}

function diff() {
  if (!original_rom || !modified_rom) {
    return 'Make sure you select ROMs to diff!';
  }
  var bytes_per_row = 8;
  var output = '';
  var original_row = '';
  var modified_row = '';
  for (var ii = 0; ii < rom.original.u8.length; ii += bytes_per_row) {
    original_row = '';
    modified_row = '';
    var diff_row = false;
    for (var jj = 0; jj < bytes_per_row; jj++) {
      var diff_byte = false;
      var idx = ii + jj;
      if (idx >= rom.original.u8.length) {
        break;
      }
      if (rom.original.u8[idx] != rom.modified.u8[idx]) {
        diff_byte = diff_row = true;
      }
      original_row += (diff_byte ? '<span class="red">' : '') +
                      pad(rom.original.u8[idx].toString(16), 2) +
                      (diff_byte ? '</span>' : '') +
                      ' ';
      modified_row += diff_byte ? ('<span class="red">' +
                        pad(rom.modified.u8[idx].toString(16), 2) +
                        '</span> ') :
                      '   ';
    }
    if (diff_row) {
      output += original_row +
                '    0x' + pad(ii.toString(16), 8) +
                '\n' + modified_row + '\n\n';
    }
  }
  return output;
}

function diff_output(e) {
  e.preventDefault();
  document.getElementById('diff_output').innerHTML = diff();
}

document
  .getElementById('original_rom')
  .addEventListener('change', readROM('original'), false);
document
  .getElementById('modified_rom')
  .addEventListener('change', readROM('modified'), false);
document
  .getElementById('diff')
  .addEventListener('submit', diff_output, false);
