Soundparty
=========================

Soundparty is a music streaming web app written in Node.js/Express/Coffeescript and uses the Soundcloud API for its music library.

To run the app
--------------------

Clone the repo, cd to the folder, and install dependencies

1. git clone git://github.com/TylerLH/sndprty.git
2. cd ./sndprty
3. npm install -d
4. coffee app.coffee

You'll need to be running Node.js v0.6.10, express framework, and coffeescript to run properly.

Todos
---------------------

- finish user authentication
- implement playlist creation, editing, sharing (mongodb store)
- implement radio functionality (play track from searched artist, then autoplay relevant music afterward)
- websockets integration for realtime listening w/ friends + chat functionality (will use redis for chat logs?)