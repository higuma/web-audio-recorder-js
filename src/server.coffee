fs   = require 'fs'
path = require 'path'
http = require 'http'

MimeType =
  css:  'text/css'
  html: 'text/html'
  js:   'text/javascript'
  wav:  'audio/wav'
  mp3:  'audio/mp3'
  ogg:  'audio/ogg'

ErrorResponse =
  EACCES:  [403, 'Forbidden']
  ENOENT:  [404, 'Not found']
  DEFAULT: [500, 'Internal server error']

RootPath = 'public'

serveFile = (res, url) ->
  mime = MimeType[path.extname(url).substr(1).toLowerCase()] || 'text/plain'
  url = RootPath + url
  stream = fs.createReadStream url
  stream.on 'error', (err) ->
    errRes = ErrorResponse[err.code] || ErrorResponse.DEFAULT
    res.writeHead errRes[0], 'Content-Type': 'text/plain'
    res.end "#{errRes[0]} #{errRes[1]}"
    return
  res.writeHead 200, 'Content-Type': mime
  stream.pipe res
  return

server = http.createServer (request, res) ->
  url = request.url
  url = '/index.html' if url == '/'
  serveFile res, url
  return

port = Number(process.env.PORT || 8888)
server.listen port
console.log "listening on port #{port}"
