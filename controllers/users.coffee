# users.coffee
# Users controller

bcrypt = require('bcrypt')
salt = bcrypt.genSaltSync(10)

# require user model
User = require('../models/user')

exports.index = (req, res) ->
	res.send('user index')

exports.new = (req, res) ->
	res.send('new user')

exports.create = (req, res) ->
	opts =
		username: req.param('username')
		email: req.param('email')
		password: bcrypt.hashSync(req.param('password'), salt)
		created: new Date()
	user = new User(opts)
	user.save (err) ->
		unless err
			res.send(200)
		else
			res.send({error: err, reason: "user input error"})

exports.show = (req, res) ->
	res.send('show user' + req.params.user)

exports.edit = (req, res) ->
	res.send('edit user' + req.params.user)

exports.update = (req, res) ->
	res.send('update user' + req.params.user)

exports.destroy = (req, res) ->
	res.send('destroy user ' + req.params.user)