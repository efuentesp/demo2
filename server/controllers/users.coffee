mongoose = require 'mongoose'
User = mongoose.model('User')

# GET /api/users
# list all users
exports.list = (req, res) ->
  console.log "GET: "
  console.log req.query
  console.log req.authInfo

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