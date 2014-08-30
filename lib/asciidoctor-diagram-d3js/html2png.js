var page = require('webpage').create();
var system = require('system');

var htmlFile = system.args[1];
var pngFile = system.args[2];

page.open(htmlFile, function(status) {
  if (status === 'fail') {
    console.log('Error! failed to open ' + htmlFile);
    phantom.exit(1);
  }

  page.evaluate(function() {
    document.body.bgColor = 'white';
  });
  page.render(pngFile);
  phantom.exit();
});
