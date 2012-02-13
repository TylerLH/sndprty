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