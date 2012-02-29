window.Search = 
	class Search
		constructor: (opts) ->
			@query = opts.query
			@limit = opts.limit
			@offset = opts.offset

		find: =>
			# add loading spinner
			$('.blocker').spin()
			$('#find-music').button('loading')
			# get list from server
			$.ajax(
				"/search.json/#{@query}/#{@offset}"
				dataType: 'json'
				type: 'get'
			)
			.success (tracks) =>
				# remove all list items that exist
				unless @offset > 0
					$('.results li').remove()
				$(tracks).each (key, track) ->
					resultData =
						track_id: track.id
						title: track.title
						artist: track.user.username
						duration: track.duration

					resultItem = ich.result(resultData)
					$('.results').append(resultItem)

				# remove spinner
				$('.blocker').spin(false)
				$('#find-music').button('reset')
			.error (err) ->
				console.log('error', err)

		loadMore: (offset) =>
			@offset = @offset + 20
			@find()