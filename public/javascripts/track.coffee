# track.coffee
# Audio track 
# Depends on Soundmanager2 JS library
window.Track = 
	class Track
		constructor: (opts) ->
			@track_id = opts.track_id
			@artist = opts.artist
			@title = opts.title
			@duration = @secondsToHms(opts.duration)
			@audio = soundManager.createSound(
					id: 'current_track'
					url: "/stream/#{@track_id}"
					volume: 75
					onplay: =>
						#alert('track playing')
					onfinish: =>
						console.log('track finished, playing next track...')
						@playNextTrack()
					whileplaying: =>
						track = soundManager.getSoundById('current_track')
						current_time = Math.round( ((track.position/1000)/60)*100)/100
						$('.current_time').html(current_time)
				)
		playTrack: =>
			@audio.play()

			infoData = 
				artist: @artist
				title: @title
				duration: Math.round( ((@duration/1000)/60)*100)/100
			info = ich.nowplaying(infoData)
			console.log(info)
			$('.now-playing').html(info).slideDown(500, -> console.log('slid'))


		playPause: =>
			@audio.togglePause()
			$('.pause-track i').toggleClass('icon-pause')
			$('.pause-track i').toggleClass('icon-play')

		playNextTrack: =>
			current_track = $('.results li').find("[data-id=\"#{@track_id}\"]")
			next_track = $(current_track).parent().next().find("a")
			@track_id = $(next_track).attr('data-id')
			@title = $(next_track).attr('data-title')
			@artist = $(next_track).attr('data-artist')
			@duration = @secondsToHms($(next_track).attr('data-duration'))
			@killTrack()
			@audio = soundManager.createSound(
				id: 'current_track'
				url: "/stream/#{@track_id}"
				volume: 75
				onfinish: =>
					@playNextTrack()
				whileplaying: =>
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
			@duration = @secondsToHms($(next_track).attr('data-duration'))
			@killTrack()
			@audio = soundManager.createSound(
				id: 'current_track'
				url: "/stream/#{@track_id}"
				volume: 75
				onfinish: =>
					@playNextTrack()
				whileplaying: =>
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
			#$('.now-playing').slideToggle(500, -> console.log('slid again'))
			@audio.destruct()

		isPlaying: =>
			unless @audio.playState == 1
				return false
			else
				return true

		secondsToHms: (d) =>
			d = Number(d)
			h = Math.floor(d / 3600);
			m = Math.floor(d % 3600 / 60);
			s = Math.floor(d % 3600 % 60);
			return ((h > 0 ? h + ":" : "") + (m > 0 ? (h > 0 && m < 10 ? "0" : "") + m + ":" : "0:") + (s < 10 ? "0" : "") + s);
