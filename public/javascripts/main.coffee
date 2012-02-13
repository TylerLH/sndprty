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
						<li><span class='track-title'>#{track.title}</span> ////// #{track.user.username}</li>
					""")

				# remove spinner
				$('.blocker').spin(false)
		)
		.error (err) ->
			console.log('error', err)