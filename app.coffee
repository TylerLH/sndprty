# Dependencies
express = require("express")
stylus = require("stylus")
nib = require("nib")
mongoose = require('mongoose')
Resource = require('express-resource')
RedisStore = require('connect-redis')(express)

# App Controllers
mainController = require('./controllers/main')
streamController = require('./controllers/stream')
sessionsController = require('./controllers/sessions')

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
  @use(express.cookieParser())
  @use express.session({ secret: "snds3cr3t", store: new RedisStore })
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

app.dynamicHelpers(
  current_user: (req, res) ->
    return req.session.user_info
  user_signed_in: (req, res) ->
    if req.session.user_info?
      return true
    else
      return false
)

# App Routes
app.get "/", mainController.index
app.get "/search.:format?/:query?/:offset?", mainController.search
app.get "/stream/:trackId", streamController.index
app.get "/templates.json", mainController.templates

app.resource('users', require('./controllers/users'))
app.post "/login", sessionsController.create
app.get "/logout", sessionsController.destroy

# Start Server
mongoose.connect('mongodb://localhost:27017/sndprty_dev');
app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env