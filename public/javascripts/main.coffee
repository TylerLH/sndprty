soundManager.url = '/javascripts/plugins/sm2/swf/'
soundManager.flashVersion = 9 # optional: shiny features (default = 8)
soundManager.useFlashBlock = false # optionally, enable when you're ready to dive in
soundManager.useHTML5Audio = true
soundManager.preferFlash = false

$ ->
	$('#search').submit (e) ->
		e.preventDefault()

		# add loading spinner
		$('.blocker').spin()

		# define search val
		query = $('#query').val()

		# get list from server
		$.getJSON(
			"/search.json/#{query}"
			null
			(tracks) ->
				# remove all list items that exist
				$('.results li').remove()
				$(tracks).each (key, track) ->
					$('.results').append("""
						<li><a href="#" data-id="#{track.id}" class="playable"><span class='track-title'>#{track.title}</span> ////// #{track.user.username}</a></li>
					""")

				# remove spinner
				$('.blocker').spin(false)
		)
		.error (err) ->
			console.log('error', err)

		$('.playable').live 'click', (e) ->
			if window.currentTrack
				window.currentTrack.destruct()
			e.preventDefault()
			src = $(this).attr('data-id')
			window.currentTrack = soundManager.createSound(
				id: 'current_track'
				url: "/stream/#{src}"
				volume: 75
				autoPlay: true
			)