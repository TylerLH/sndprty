# user.coffee
# User model

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

userSchema = new Schema(
  id: ObjectId
  username: { type: String, index: { unique: true }, required: true }
  email: { type: String, index: { unique: true }, required: true }
  created: Date
)

module.exports = mongoose.model('User', userSchema)
