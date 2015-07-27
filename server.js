(function() {
  var ErrorResponse, MimeType, RootPath, fs, http, path, port, serveFile, server;

  fs = require('fs');

  path = require('path');

  http = require('http');

  MimeType = {
    css: 'text/css',
    html: 'text/html',
    js: 'text/javascript',
    wav: 'audio/wav',
    mp3: 'audio/mp3',
    ogg: 'audio/ogg'
  };

  ErrorResponse = {
    EACCES: [403, 'Forbidden'],
    ENOENT: [404, 'Not found'],
    DEFAULT: [500, 'Internal server error']
  };

  RootPath = 'public';

  serveFile = function(res, url) {
    var mime, stream;
    mime = MimeType[path.extname(url).substr(1).toLowerCase()] || 'text/plain';
    url = RootPath + url;
    stream = fs.createReadStream(url);
    stream.on('error', function(err) {
      var errRes;
      errRes = ErrorResponse[err.code] || ErrorResponse.DEFAULT;
      res.writeHead(errRes[0], {
        'Content-Type': 'text/plain'
      });
      res.end("" + errRes[0] + " " + errRes[1]);
    });
    res.writeHead(200, {
      'Content-Type': mime
    });
    stream.pipe(res);
  };

  server = http.createServer(function(request, res) {
    var url;
    url = request.url;
    if (url === '/') {
      url = '/index.html';
    }
    serveFile(res, url);
  });

  port = Number(process.env.PORT || 8888);

  server.listen(port);

  console.log("listening on port " + port);

}).call(this);
