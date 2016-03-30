var script;
var number;
var HEADER_LENGTH = 16;
var BINARY_SIZE = 0xBF4;

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
  if (!script) return;
  saveAs(
    new Blob(
      [JSON.stringify(script, null, 2)],
      {type: 'text/plain;charset-utf-8'}
    ),
    '_cutscene.json'
  );
}

function exportBinary() {
  if (!script) return;
  var binary = new Uint8Array(BINARY_SIZE);

  var offset = 0;
  for (var ii = 0; ii < script.length; ii++) {
    binary[2*ii] = offset & 0xFF;
    binary[2*ii + 1] = (offset >> 8) & 0xFF;

    var english = script[ii].English;
    english = processSpecialCharacters(
              substituteMacros(english+'|\\ff\\ff'));
    data = parseEnglish(english);
    for (var jj = 0; jj < data.length; jj++) {
      binary[2*HEADER_LENGTH + offset + jj] = data[jj];
    }
    offset += data.length;
  }

  if (offset >= BINARY_SIZE) {
    console.log("Translated text overflows by " + (offset-BINARY_SIZE+1).toString(10) + " bytes.");
  }

  saveAs(
    new Blob([new DataView(binary.buffer)], {type: 'application/octet-stream'}),
    "cutscene.bin"
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
