var rom;
var start = 0;
var end = -1;
var canvas = document.getElementById('canvas');
var context = canvas.getContext('2d');

function readROM(e) {
  var file = e.target.files[0]; // FileList object
    var fileReader = new FileReader();
  fileReader.onload = function (e) {
    rom = new Uint8Array(e.target.result);
  };
  fileReader.readAsArrayBuffer(file);
}

function updateRangeStart(e) {
  start = e.target.value;
  draw();
}

function updateRangeEnd(e) {
  end = e.target.value;
  draw();
}

function draw() {
  var data = context.createImageData(canvas.width, canvas.height);
  var x = 0;
  var y = 0;
  for (var ii = start; ii <= end; ii++) {
    for (var jj = 0; jj < 8; jj++) {
      if ((rom[ii] & (1 << jj)) == 0) continue;
      data.data[(canvas.width * y + x + jj) * 4 + 3] = 255;
    }
    y++;
    if (x >= canvas.width - 8) {
      y += 32;
      x = 0;
    }
    if (y % 16 == 0) {
      x += 8;
      y -= 16;
    }
  }
  context.putImageData(data, 0, 0);
}

document
  .getElementById('file')
  .addEventListener('change', readROM, false);
document
  .getElementById('start-address')
  .addEventListener('change', updateRangeStart, false);
document
  .getElementById('end-address')
  .addEventListener('change', updateRangeEnd, false);
