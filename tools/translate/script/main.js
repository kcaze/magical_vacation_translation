var script;
var number;
var HEADER_LENGTH = 12006;
var BINARY_SIZE = 0x6F46E;

function readScript(e) {
  var file = e.target.files[0]; // FileList object
  var fileReader = new FileReader();
  fileReader.onload = function (e) {
    script = JSON.parse(e.target.result);
    document.getElementById('english').disabled = false;
    document.getElementById('comments').disabled = false;
    document.getElementById('number').disabled = false;
    document.getElementById('export_json').disabled = false;
    document.getElementById('export_binary').disabled = false;
    document.getElementById('japanese_search').disabled = false;
    document.getElementById('english_search').disabled = false;

    document.getElementById('max_number').innerHTML = script.length - 1;
    document.getElementById('number').max = script.length - 1;
    document.getElementById('number').value = 0;
    number = 0;

    // Called each time so that updates to the script parsing are reflected.
    generateJapaneseScript(script);
  };
  fileReader.readAsText(file);
}

function exportJSON() {
  saveAs(
    new Blob(
      [JSON.stringify(script, null, 2)],
      {type: 'text/plain;charset-utf-8'}
    ),
    '_script.json'
  );
}

function exportBinary() {
  var binary = new Uint8Array(BINARY_SIZE);

  var idx = 2*(script.length+1);
  for (var ii = 2; ii < script.length; ii++) {
    var data = [];

    if (script[ii].English == '') {
      // Copy original data.
      for (jj = 0; jj < script[ii].u8.length; jj++) {
        data.push(script[ii].u8[jj]);
      }
    } else {
      var english = script[ii].English;
      // Auto insert character portraits
      if (script[ii].u8[0] == 0x8b) {
        var s = script[ii].u8[1].toString(16);
        if (s.length == 1) s = "0" + s;
        english = "\\8b\\" + s + english;
      }
      english = preprocessScript(
                processSpecialCharacters(
                substituteMacros(english)));
      data = parseEnglish(english);
    }

    for (var jj = 0; jj < data.length; jj++) {
      binary[idx + jj] = data[jj];
    }

    var offset = idx % 65536;
    binary[2*ii] = offset % 256;
    binary[2*ii+1] = offset >> 8;

    idx += data.length;
  }

  // Warn if the English script is too long.
  if (idx >= BINARY_SIZE) {
    console.log(
      "WARNING: English script has length ",
      idx,
      " which is ",
      idx - BINARY_SIZE + 1,
      " bytes too long!"
    );
  }

  // The first 2 offsets are hardcoded.
  binary[0] = 0x00; binary[1] = 0x00; binary[2] = 0x70; binary[3] = 0x17;

  // Duplicate the last offset
  binary[2*script.length+1] = binary[2*script.length - 1];
  binary[2*script.length] = binary[2*script.length - 2];

  saveAs(
    new Blob([new DataView(binary.buffer)], {type: 'application/octet-stream'}),
    "script.bin"
  );
}

function japanese_search() {
  var text = document.getElementById('search_text').value;
  document.getElementById('search_results').innerHTML = '';
  for (var ii = 0; ii < script.length; ii++) {
    if (script[ii].Japanese.indexOf(text) != -1) {
      document.getElementById('search_results').innerHTML += ii + '<br>';
    }
  }
}

function english_search() {
  var text = document.getElementById('search_text').value;
  document.getElementById('search_results').innerHTML = '';
  for (var ii = 0; ii < script.length; ii++) {
    if (script[ii].English.indexOf(text) != -1) {
      document.getElementById('search_results').innerHTML += ii + '<br>';
    }
  }
}

document
  .getElementById('script')
  .addEventListener('change', readScript, false);

document
  .getElementById('export_json')
  .addEventListener('click', exportJSON, false);

document
  .getElementById('export_binary')
  .addEventListener('click', exportBinary, false);

document
  .getElementById('number')
  .addEventListener('change', function(e) {
    document.getElementById('japanese').innerHTML = script[number].Japanese;
    document.getElementById('english').value = script[number].English;
    document.getElementById('comments').value = script[number].Comments;
  }, false);

document
  .getElementById('english')
  .addEventListener('change', function(e) {
    script[number].English = document.getElementById('english').value;
  });

document
  .getElementById('comments')
  .addEventListener('change', function(e) {
    script[number].Comments = document.getElementById('comments').value;
  });

document
  .getElementById('japanese_search')
  .addEventListener('click', japanese_search);

document
  .getElementById('english_search')
  .addEventListener('click', english_search);

function heartBeat() {
  if (!script) return;
  var newNumber = parseInt(document.getElementById('number').value, 10);
  if (number != newNumber) {
    number = newNumber;
    document.getElementById('japanese').innerHTML = script[number].Japanese;
    document.getElementById('english').value = script[number].English;
    document.getElementById('comments').value = script[number].Comments;
  }
  script[number].English = document.getElementById('english').value;
  script[number].Comments = document.getElementById('comments').value;
}
window.setInterval(heartBeat, 100);

document.addEventListener('keydown', function (e) {
  if (!e.ctrlKey) return;
  var preventDefault = true;
  switch (String.fromCharCode(e.keyCode)) {
  case 'H':
    document.getElementById('number').value = Math.max(0, number-1);
    break;
  case 'L':
    document.getElementById('number').value = Math.min(script.length-1, number+1);
    break;
  case 'E':
    exportJSON();
    exportBinary();
    break;
  default:
    preventDefault = false;
  }
  if (preventDefault) {
    e.preventDefault();
    e.stopPropagation();
  }
});
