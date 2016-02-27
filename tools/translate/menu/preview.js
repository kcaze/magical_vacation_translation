// CPU-inefficient but whatever.
window.setInterval(updatePreview, 100);

var explanation_preview = document
    .getElementById('explanation_preview')
    .getContext('2d');
var explanation_box = document.getElementById('explanation_box');
var font = document.getElementById('font');
var widths = [
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  4,4,6,0,0,7,7,3,4,4,6,6,3,6,3,0,
  6,4,6,6,6,6,6,6,6,6,3,3,0,6,0,6,
  8,6,6,6,6,6,6,6,6,2,5,6,6,8,6,7,
  6,7,6,6,6,6,6,8,6,6,6,0,0,0,0,0,
  0,5,5,5,5,5,5,5,5,2,4,5,3,6,5,5,
  5,5,5,5,5,5,5,6,8,5,5,8,8,0,7,8,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
];

//var monospace_font_order =
//    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,'!?:0123456789- ";

function updatePreview() {
  explanation_preview.drawImage(explanation_box, 0, 0);
  if (menus &&
      menus[section] &&
      menus[section][number] &&
      menus[section][number].English) {
    var x = 14;
    var y = 12;
    for (var ii = 0; ii < menus[section][number].English.length; ii++) {
      var c = menus[section][number].English[ii];

      // Automatically assume that this is part of $N$ and treat it as a
      // newline.
      if (c == '$') {
        x = 14;
        y += 16;
        ii += 3;
        continue;
      }

      var idx = c.charCodeAt(0);

      explanation_preview.drawImage(
        font,
        2 * (idx * 8 % (8 * 16)),
        2 * (16 * Math.floor(idx / 16)),
        2*8,
        2*16,
        2*x,
        2*y,
        2*8,
        2*16
      );
      x += widths[idx] + 1;
    }
  }
}
