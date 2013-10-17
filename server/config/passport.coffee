mongoose = require 'mongoose'
BasicStrategy = require('passport-http').BasicStrategy
User = mongoose.model 'User'

module.exports = (passport, config) ->

  passport.use new BasicStrategy (username, password, done) ->
    User.findOne { username: username }, (err, user) ->
      return done(err) if err
      return done(null, false, {message: 'Unknown User'}) if not user
      return done(null, false, {message: 'Invalid Password'}) if not user.authenticate(password)
      return done(null, user)