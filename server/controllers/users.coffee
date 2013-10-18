mongoose = require 'mongoose'
jwt = require 'jwt-simple'
User = mongoose.model('User')

# GET /api/auth
# Get authorization token
exports.auth = (req, res) ->
  authorization = req.headers.authorization
  if not authorization
      console.log "HTTP: Authorization not found!"
      res.statusCode = 400
      return res.send "Error 400: HTTP: Authorization not found!"
  parts = authorization.split(' ')
  scheme = parts[0]
  credentials = new Buffer(parts[1], 'base64').toString()
  index = credentials.indexOf(':')
  if scheme is not 'Basic' or index < 0
      console.log "Not Basic Authorization!"
      res.statusCode = 400
      return res.send "Error 400: HTTP: Not Basic Authorization!"

  username = credentials.slice(0, index)
  password = credentials.slice(index + 1)

  return User.findOne { username: username }, (err, user) ->
    return console.log err if err
    if user
      payload =
        username: user.username
        expires: Math.round((new Date().getTime()/1000)) + 3600 # 1 hr
      secret = 'Peacemakers2.0'
      token = jwt.encode(payload, secret)
      console.log jwt.decode(token, secret)
      return res.send token
    else
      console.log "Resource not found!"
      res.statusCode = 400
      return res.send "Error 400: Resource not found!"

# GET /api/users
# list all users
exports.list = (req, res) ->
  console.log "GET: "
  console.log req.query

  return User.find()
    .exec (err, users) ->
      if not err
        return res.send users
      else
        return console.log err

# POST /api/users
# create a new user
exports.create = (req, res) ->
  console.log "POST: "
  console.log req.body
  user = new User req.body
  user.save (err) ->
    if not err
      return console.log "created"
    else
      return console.log err
  return res.send user