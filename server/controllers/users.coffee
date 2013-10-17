passport = require 'passport'
mongoose = require 'mongoose'
User = mongoose.model('User')

# GET token
exports.auth = (req, res) ->
  console.log "GET: "
  console.log req

  return School.find()
    .exec (err, schools) ->
      if not err
        return res.send schools
      else
        return console.log err