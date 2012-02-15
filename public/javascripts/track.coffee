# track.coffee
# Audio track 
# Depends on Soundmanager2 JS library
window.Track = 
	class Track
		constructor: (opts) ->
			@track_id = opts.track_id
			@artist = opts.artist
			@title = opts.title
			@duration = opts.duration
			@audio = soundManager.createSound(
					id: 'current_track'
					url: "/stream/#{@track_id}"
					volume: 75
					onfinish: ->
						alert('track finished')
					whileplaying: ->
						setTimeout(
							->
								track = soundManager.getSoundById('current_track')
								current_time = Math.round( ((track.position/1000)/60)*100)/100
								$('.current_time').html(current_time)
							, 1000
						)
				)
		playTrack: =>
			@audio.play()

			infoData = 
				artist: @artist
				title: @title
				duration: Math.round( ((@duration/1000)/60)*100)/100
			info = ich.nowplaying(infoData)
			$('.now-playing').html(info).slideToggle(500, -> console.log('slid'))


		playPause: =>
			@audio.togglePause()
			$('.pause-track').toggleClass('icon-pause')
			$('.pause-track').toggleClass('icon-play')

		playNextTrack: =>
			current_track = $('.results li').find("[data-id=\"#{@track_id}\"]")
			next_track = $(current_track).parent().next().find("a")
			@track_id = $(next_track).attr('data-id')
			@title = $(next_track).attr('data-title')
			@artist = $(next_track).attr('data-artist')
			@duration = $(next_track).attr('data-duration')
			@killTrack()
			@audio = soundManager.createSound(
				id: 'current_track'
				url: "/stream/#{@track_id}"
				volume: 75
				onfinish: ->
					alert('track finished')
				whileplaying: ->
					setTimeout(
						->
							track = soundManager.getSoundById('current_track')
							current_time = Math.round( ((track.position/1000)/60)*100)/100
							$('.current_time').html(current_time)
						, 1000
					)
			)
			@playTrack()

		playPrevTrack: =>
			current_track = $('.results li').find("[data-id=\"#{@track_id}\"]")
			next_track = $(current_track).parent().prev().find("a")
			@track_id = $(next_track).attr('data-id')
			@title = $(next_track).attr('data-title')
			@artist = $(next_track).attr('data-artist')
			@duration = $(next_track).attr('data-duration')
			@killTrack()
			@audio = soundManager.createSound(
				id: 'current_track'
				url: "/stream/#{@track_id}"
				volume: 75
				onfinish: ->
					alert('track finished')
				whileplaying: ->
					setTimeout(
						->
							track = soundManager.getSoundById('current_track')
							current_time = Math.round( ((track.position/1000)/60)*100)/100
							$('.current_time').html(current_time)
						, 1000
					)
			)
			@playTrack()

		killTrack: =>
			$('.now-playing').slideToggle(500, -> console.log('slid again'))
			@audio.destruct()

		isPlaying: =>
			unless @audio.playState == 1
				return false
			else
				return true
