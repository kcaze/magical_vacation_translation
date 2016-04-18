var script;
var number;
var BINARY_SIZE = 0x4A8;

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
    document.getElementById('comments_search').disabled = false;

    document.getElementById('max_number').innerHTML = script.length - 1;
    document.getElementById('number').max = script.length - 1;
    document.getElementById('number').value = 0;
    number = 0;
    document.getElementById('japanese').innerHTML = script[number].Japanese;
    document.getElementById('english').value = script[number].English;
    document.getElementById('comments').value = script[number].Comments;
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
    '_character_cutscene.json'
  );
}

function exportBinary() {
  if (!script) return;
  var binary = new Uint8Array(BINARY_SIZE);

  var idx = 0x20;
  for (var ii = 0; ii < script.length; ii++) {
    binary[2*ii] = (idx - 0x20) & 0xFF;
    binary[2*ii + 1] = (idx - 0x20) >> 8;
    var data = parseEnglish(processSpecialCharacters(script[ii].English + '\\ff\\ff'));
    for (var jj = 0; jj < data.length; jj++) {
      binary[idx + jj] = data[jj];
    }
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

  saveAs(
    new Blob([new DataView(binary.buffer)], {type: 'application/octet-stream'}),
    "character_cutscene.bin"
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

function comments_search() {
  var text = document.getElementById('search_text').value;
  document.getElementById('search_results').innerHTML = '';
  for (var ii = 0; ii < script.length; ii++) {
    if (script[ii].Comments.indexOf(text) != -1) {
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

document
  .getElementById('comments_search')
  .addEventListener('click', comments_search);

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
