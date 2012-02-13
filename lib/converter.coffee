# converter.coffee
# MP3 to OGG conversion using ffmpeg

spawn = require('child_process').spawn
commandName = 'ffmpeg'
commandOpts = ['-i', 'pipe:0', '-f', 'mp3', '-acodec', 'libvorbis', '-ab', '128k', '-aq', '60', '-f', 'ogg', '-']

logOutput = (data) ->
	console.log(data.toString('ascii'))

module.exports = class Converter
	constructor: (@client_id) ->
		@process = spawn(commandName, commandOpts)
		@process.stderr.on 'data', logOutput
		@process.stdin.on 'error', (err) ->
			console.log('converter input error: ', err)
		@process.stdout.on 'error', (err) ->
			console.log('converter output error: ', err)

	kill: ->
		@process.stdin.destroy()
		@process.stdout.destroy()
		@process.kill('SIGKILL')