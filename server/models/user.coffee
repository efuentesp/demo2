mongoose = require 'mongoose'
crypto = require('crypto')

Schema = mongoose.Schema

PermissionSchema = new Schema
  subject:
    type: String
    default: ''
  action:
    type: String
    default: ''
  displayName: String
  description: String

mongoose.model('Permission', PermissionSchema)

resolvePermission = (permission, done) ->
  mongoose.model('Permission').findOne {subject: permission.subject, action: permission.action}, (err, permission) ->
    return done(err) if err
    return done(new Error "Unknown Permission") if not permission
    done(null, permission)
    return
  return

RoleSchema = new Schema
  name:
    type: String
    default: ''
  displayName: String
  description: String
  permissions: [PermissionSchema]

RoleSchema.methods = {

  hasPermission: (subject, action) ->
    if @.permissions
      for p in @.permissions
        return true if subject is p.subject and action is p.action
    false

  addPermission: (permission, done) ->
    resolvePermission permission, (err, permission) ->
      return done(err) if err
      @.permissions.push permission._id
      @.save(done)
    return
}

mongoose.model('Role', RoleSchema)

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
  roles: [RoleSchema]

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