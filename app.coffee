# Dependencies
express = require("express")
stylus = require("stylus")
nib = require("nib")
mongoose = require('mongoose')
Resource = require('express-resource')

# App Controllers
mainController = require('./controllers/main')
streamController = require('./controllers/stream')

app = module.exports = express.createServer()
sc_api_key = '95ee851cbc8c34b329e15fb78475f834'

# Override stylus compile function to use nib
compile = (str, path) ->
  return stylus(str).set('filename', path).set('compress', true).use(nib())

# Global config
app.configure ->
  @use require('connect-assets')({src: 'public'})
  css.root = '/stylesheets'
  js.root  = '/javascripts'
  @set "views", __dirname + "/views"
  @set "view engine", "jade"
  @use express.bodyParser()
  @use express.methodOverride()
  @use express.static(__dirname + "/public")

# Config development env
app.configure "development", ->
  @use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

# Config production env
app.configure "production", ->
  @use express.errorHandler()

# App Routes
app.get "/", mainController.index
app.get "/search.:format?/:query?", mainController.search
app.get "/stream/:trackId", streamController.index
app.get "/templates.json", mainController.templates

app.resource('users', require('./controllers/users'))

# Start Server
mongoose.connect('mongodb://localhost:27017/sndprty_dev');
app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env