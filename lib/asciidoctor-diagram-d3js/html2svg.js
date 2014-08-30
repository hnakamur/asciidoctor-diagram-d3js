var page = require('webpage').create();
var system = require('system');

if (system.args.length !== 2) {
  console.log('Usage: ' + system.args[0] + ' html_file');
  phantom.exit(1);
}

var htmlFile = system.args[1];

page.open(htmlFile, function(status) {
  if (status === 'fail') {
    console.log('Error! failed to open ' + htmlFile);
    phantom.exit(1);
  }

  var svg = page.evaluate(function() {
    return document.getElementsByTagName('div')[0].innerHTML;
  });
  console.log(svg);
  phantom.exit();
});
