window.Search = 
	class Search
		constructor: (opts) ->
			@query = opts.query
			@limit = opts.limit
			@offset = opts.offset

		find: =>
			# add loading spinner
			$('.blocker').spin()
			
			# get list from server
			$.getJSON(
				"/search.json/#{@query}"
				null
				(tracks) ->
					# remove all list items that exist
					$('.results li').remove()
					$(tracks).each (key, track) ->
						resultData =
							track_id: track.id
							title: track.title
							artist: track.user.username
							duration: track.duration

						resultItem = ich.result(resultData)
						$('.results').append(resultItem)
						$('.more').toggleClass('hide', false)

					# remove spinner
					$('.blocker').spin(false)
			)
			.error (err) ->
				console.log('error', err)