var http         = require('http');
var serveStatic  = require('serve-static');
var finalhandler = require('finalhandler');
var port         = process.env.PORT || 9000;
var distDir      = '/.tmp';



var serve  = serveStatic(__dirname + distDir, {'index': ['index.html']});

var server = http.createServer(function(req, res){
  var done = finalhandler(req, res);
  serve(req, res, done);
});

server.listen(9000);