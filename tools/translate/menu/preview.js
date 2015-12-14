// CPU-inefficient but whatever.
window.setInterval(updatePreview, 100);

var explanation_preview = document
    .getElementById('explanation_preview')
    .getContext('2d');
var explanation_box = document.getElementById('explanation_box');
var monospace_font = document.getElementById('monospace_font');

var monospace_font_order =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,'!?:0123456789- ";

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

      // Automatically assume that this is part of \fe\ff and treat it as a
      // newline.
      if (c == '\\') {
        x = 14;
        y += 16;
        ii += 5;
        continue;
      }

      var idx = monospace_font_order.indexOf(c);
      if (idx == -1) {
        continue;
      }

      explanation_preview.drawImage(
        monospace_font,
        2 * (idx * 8 % (8 * 16)),
        2 * (16 * Math.floor(idx / 16)),
        2*8,
        2*16,
        2*x,
        2*y,
        2*8,
        2*16
      );
      x += 8;
    }
  }
}
