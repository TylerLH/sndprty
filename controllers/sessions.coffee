# sessions.coffee
# Sessions controller

bcrypt = require('bcrypt')
salt = bcrypt.genSaltSync(10)

# require user model
User = require('../models/user')

exports.new = (req, res) ->
	res.render('users/signup')

exports.create = (req, res) ->
	username = req.param('username')
	password = bcrypt.hashSync(req.param('password'), salt)
	User.find({username: username}, (err, user) ->
		unless err
			if user[0].password is password
				req.session.user_info = user[0]
				res.cookie('current_user', user[0])
				res.send({status: "success", message: "Logged in successfully", user: user[0]})
			else
				res.send({status: "error", message: "Invalid password!"})
		else
			res.send({status: "error", message: err})
	)

exports.destroy = (req, res) ->
	req.session.destroy()
	res.clearCookie('current_user')
	#req.flash('info', 'You signed out successfully')
	res.redirect('/')