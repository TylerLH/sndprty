# stream.coffee
# track stream controller

http = require('http')
url = require('url')
Converter = require('../lib/converter')
util = require('util')
fs = require('fs')
ffmpeg = require('basicFFmpeg')

# GET '/stream/:streamUrl'
exports.index = (req, res) ->
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
    if !result.headers.location
      res.send "No stream available"
    else
      location = url.parse(result.headers.location)
    
      http.get(optsFromRedirect(location), (result) ->
        #util.log(util.inspect(result))
        result.pipe(res)
        res.contentType('audio/mp3')
        ###
        ffmpeg.createProcessor(
            inputStream: result
            outputStream: res
            emitInputAudioCodecEvent: true
            emitInfoEvent: true
            emitProgressEvent: true
            niceness: 10
            timeout: 10 * 60 * 1000
            arguments:
              "-ab": "128k"
              "-acodec": "libvorbis"
              "-f": "ogg"
              # "-aq": "60"
          ).on("info", (infoLine) ->
            util.log infoLine
          ).on("inputAudioCodec", (codec) ->
            util.debug "input audio codec is: " + codec
          ).on("success", (retcode, signal) ->
            util.debug "process finished successfully with retcode: " + retcode + ", signal: " + signal
            res.end()
          ).on("failure", (retcode, signal) ->
            util.debug "process failure, retcode: " + retcode + ", signal: " + signal
            res.end()
          ).on("progress", (bytes) ->
            util.debug "process event, bytes: " + bytes
          ).on("timeout", (processor) ->
            util.debug "timeout event fired, stopping process."
            processor.terminate()
            res.end()
          ).execute() 
          res.contentType('application/ogg')
          res.writeHead(200,
            'Transfer-Encoding': 'chunked'
            'Content-Type': 'audio/mpeg'
            'Accept-Ranges': 'bytes' # just to please some players, we do not actually allow seeking
        )
        ###
      )
  )
  