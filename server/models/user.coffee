mongoose = require 'mongoose'
Schema = mongoose.Schema

UserSchema = new Schema
  username:
    type: String
    default: ''
  hashed_password:
    type: String
    default: ''
  email:
    type: String
    default: ''
  authToken:
    type: String
    default: ''

UserSchema.methods = {

  authenticate: (plainText) ->
    plainText is @hashed_password
    
}

mongoose.model('User', UserSchema)