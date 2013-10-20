mongoose = require 'mongoose'
crypto = require('crypto')

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
  salt:
    type: String
    default: ''
  roles: [
    type: mongoose.Schema.Types.ObjectId
    ref: 'Role'
  ]

UserSchema
  .virtual('password')
  .set((password) ->
    @._password = password
    @.salt = @.makeSalt()
    @.hashed_password = @.encryptPassword(password)
  )
  .get(-> @._password)

UserSchema.methods = {

  authenticate: (plainText) ->
    #plainText is @hashed_password
    @.encryptPassword(plainText) is @.hashed_password
  
  validateToken: (token, tokenDecoded) ->
    return false if token isnt @authToken
    now = Math.round((new Date().getTime()/1000))
    return tokenDecoded.expires > now

  makeSalt: ->
    Math.round((new Date().valueOf() * Math.random())) + ''

  encryptPassword: (password) ->
    return '' if not password
    try
      encrypred = crypto.createHmac('sha1', @.salt).update(password).digest('hex')
      return encrypred
    catch err
      return ''

}

mongoose.model('User', UserSchema)