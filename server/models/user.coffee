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
  
  validateToken: (token, tokenDecoded) ->
    return false if token isnt @authToken
    now = Math.round((new Date().getTime()/1000))
    return tokenDecoded.expires > now
}

mongoose.model('User', UserSchema)