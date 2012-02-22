# main.coffee
fermata = require('fermata')

# GET '/'
# Returns main page
exports.index = (req, res) ->
  res.render "index",
    title: "Soundparty"

# GET '/search.:format?/:query?'
# Returns list of tracks from soundcloud
exports.search = (req, res) ->
	sc = fermata.json("http://api.soundcloud.com")
	sc.tracks(
		client_id: '95ee851cbc8c34b329e15fb78475f834'
		q: req.params.query
		order: 'hotness'
		limit: 20
	).get (err, result) ->
		if !err
			if req.params.format == 'json'
				res.send result
			else
			res.render "search",
				tracks: result
				title: "Search"
		else
			if req.params.format == 'json'
				res.send err
			else
				res.render "index",
					title: "Soundparty"
					error: err

# GET '/templates.json'
# Returns all mustache templates for icanhaz.js
exports.templates = (req, res) ->
	templates = [
		{ name: 'result'
		template: """
				<li>
					<a href="#" data-id="{{ track_id }}" data-title="{{ title }}" data-artist="{{ artist }}" data-duration="{{ duration }}" class="playable">
							<span class='track-title'>{{ title }}</span> ////// {{ artist }}
						</a>
				</li>
			"""
		}
		,
		{
		name: 'nowplaying'
		template: """<div class="track-info pull-left">
						<i class="icon-headphones icon-white"></i> Listening to {{ title }} by <b>{{ artist }}</b> <span class="current_time">0.00</span>/{{ duration }} 
					</div>
					<div class="controls">
						<button class='metal radial pause-track'><i class="icon-pause"></i></button>&nbsp;<button class='metal radial prev-track'><i class="icon-step-backward"></i></button>&nbsp;<button class="metal radial next-track"><i class="icon-step-forward"></i></button>
					</div>"""
		}
	]

	res.send templates