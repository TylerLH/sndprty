# users.coffee
# Users controller

bcrypt = require('bcrypt')
salt = bcrypt.genSaltSync(10)

# require user model
User = require('../models/user')

exports.index = (req, res) ->
	res.send('user index')

exports.new = (req, res) ->
	res.render('users/signup')

exports.create = (req, res) ->
	opts =
		username: req.param('username')
		email: req.param('email')
		password: bcrypt.hashSync(req.param('password'), salt)
		created: new Date()
	user = new User(opts)
	user.save (err) ->
		unless err
			req.session.user_info = user
			app.helpers.current_user = user
			res.send({status: "success", message: "User created successfully", user: user})
		else
			res.send({status: "error", message: err})

exports.show = (req, res) ->
	res.send('show user' + req.params.user)

exports.edit = (req, res) ->
	res.send('edit user' + req.params.user)

exports.update = (req, res) ->
	res.send('update user' + req.params.user)

exports.destroy = (req, res) ->
	req.session.destroy()
	req.flash('info', 'You signed out successfully')
	res.redirect('/')