# track.coffee
# Audio track 
# Depends on Soundmanager2 JS library
window.Track = 
	class Track
		constructor: (opts) ->
			@track_id = opts.track_id
			@artist = opts.artist
			@title = opts.title
			@audio = soundManager.createSound(
					id: 'current_track'
					url: "/stream/#{@track_id}"
					volume: 75
				)

		playTrack: =>
			@audio.play()
			infoData = 
				artist: @artist
				title: @title
			info = ich.nowplaying(infoData)
			$('.now-playing').html(info).slideToggle(500, -> console.log('slid'))


		playPause: =>
			@audio.togglePause()
			$('.pause-track').toggleClass('icon-pause')
			$('.pause-track').toggleClass('icon-play')

		killTrack: =>
			$('.now-playing').slideToggle(500, -> console.log('slid again'))
			@audio.destruct()

		isPlaying: =>
			unless @audio.playState == 1
				return false
			else
				return true
