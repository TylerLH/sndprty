soundManager.url = '/javascripts/plugins/sm2/swf/'
soundManager.flashVersion = 8 # optional: shiny features (default = 8)
soundManager.useFlashBlock = false # optionally, enable when you're ready to dive in
soundManager.useHTML5Audio = false
soundManager.preferFlash = true
soundManager.html5PollingInterval = 1000
soundManager.flashPollingInterval = 1000

$ ->
	Track = window.Track
	Search = window.Search

	# Get mustache templates & store for use
	$.getJSON(
		'/templates.json'
		(templates) ->
			$(templates).each (key, tmpl) ->
				ich.addTemplate(tmpl.name, tmpl.template)
	)

	###
		Handle user sign up modal
	###
	$('#create-account').click (e) ->
		e.preventDefault()
		console.log('click')
		$.ajax(
			'/users'
			dataType: 'json'
			type: 'post'
			data:
				username: $('#signup_username').val()
				email: $('#signup_email').val()
				password: $('#signup_password').val()
				password_confirm: $('#signup_confirm_password').val()
		)
		.success (user) ->
			alert('success!')
			console.log(user)

	###
		Handle user sign in modal
	###
	$('#do-login').click (e) ->
		e.preventDefault()
		console.log('click')
		$.ajax(
			'/login'
			dataType: 'json'
			type: 'post'
			data:
				username: $('#login_username').val()
				password: $('#login_password').val()
		)
		.success (user) ->
			alert('success!')
			console.log(user)
	
	# Handle track search
	# Returns list of tracks and appends them to list
	# Each list item is playable
	$('#search').submit (e) ->
		e.preventDefault()

		# define search opts
		searchOpts = 
			query: $('#query').val()
			offset: 0

		window.currentSearch = new Search(searchOpts)
		window.currentSearch.find()


		# Play selected item onclick
		# If another track is loaded, current track is killed and replaced
		$('.playable').live 'click', (e) ->
			e.preventDefault()

			if window.currentTrack
				window.currentTrack.killTrack() # kill & destruct current track
				window.currentTrack = null

			# track data (for track info displays)
			opts =
				track_id: $(this).attr('data-id')
				title: $(this).attr('data-title')
				artist: $(this).attr('data-artist')
				duration: $(this).attr('data-duration')

			# create new track instance # play it
			window.currentTrack = new Track(opts)
			window.currentTrack.playTrack()

		###### Pause/Play current track ######
		$('.pause-track').live 'click', (e) ->
			window.currentTrack.playPause()

		###### Play next track ######
		$('.next-track').live 'click', (e) ->
			window.currentTrack.playNextTrack()

		###### Play prev track ######
		$('.prev-track').live 'click', (e) ->
			window.currentTrack.playPrevTrack()

		###### We've reached the bottom, captain ######

		$(window).scroll ->
  		window.currentSearch.loadMore()  if $(window).scrollTop() is $(document).height() - $(window).height()