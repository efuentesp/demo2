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
    return done(new Error "Unknown Permission: #{permission}") if not permission
    return done(null, permission)

RoleSchema = new Schema
  name:
    type: String
    default: ''
  displayName: String
  description: String
  permissions: [PermissionSchema]

RoleSchema.methods = {

  hasPermission: (permission) ->
    if @.permissions
      for p in @.permissions
        return true if permission.subject is p.subject and permission.action is p.action
    false

  addPermission: (p, done) ->
    if @.hasPermission p
      return done(new Error "Existing Permission: #{p}")
    resolvePermission p, (err, permission) =>
      return done(err) if err
      @.permissions.push
        _id: permission._id
        subject: permission.subject
        action: permission.action
      done()

}

mongoose.model('Role', RoleSchema)

resolveRole = (roleName, done) ->
  mongoose.model('Role').findOne {name: roleName}, (err, role) ->
    return done(err) if err
    return done(new Error "Unknown Role: #{roleName}") if not role
    return done(null, role)


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
  roles: [type: Schema.ObjectId, ref: 'Role']

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

  hasRole: (roleName) ->
    if @.roles
      for r in @.roles
        mongoose.model('Role').findById r, (err, role) ->
          throw err if err
          throw err if not role
          return true if roleName is role.name
    else
      return false

  addRole: (roleName, done) ->
    if @.hasRole roleName
      return done(new Error "Existing Role: #{roleName}")
    resolveRole roleName, (err, role) =>
      return done(err) if err
      @.roles.push _id: role._id
      done()

}

mongoose.model('User', UserSchema)