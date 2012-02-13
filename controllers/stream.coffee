# stream.coffee
# track stream controller

http = require('http')
url = require('url')
Converter = require('../lib/converter')
util = require('util')
stream = require('stream')

# GET '/stream/:streamUrl'
exports.index = (req, res) ->
  converter = new Converter
  reqOptions = (trackId) ->
    {
      host: 'api.soundcloud.com',
      path: '/tracks/' + trackId + '/stream?client_id=' + '95ee851cbc8c34b329e15fb78475f834',
      headers:
        'User-Agent': 'node.js'
    }
  optsFromRedirect = (location) ->
    return {
      host: location.host,
      path: location.pathname + location.search,
      headers:
        'User-Agent': 'node.js'
    }

  http.get(reqOptions(req.params.trackId), (result) ->
    # util.log(util.inspect(result))
    location = url.parse(result.headers.location)
    
    http.get(optsFromRedirect(location), (result) ->
      # util.log(util.inspect(result))
      result.on 'data', (chunk) -> 
        chunk.pipe(converter.process.stdin)
        converter.process.stdout.pipe(res)
    )
  )

  res.header('Content-Type', 'audio/ogg')
  res.send 'yo'
  