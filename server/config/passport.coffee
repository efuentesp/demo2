mongoose = require 'mongoose'
LocalStrategy = require('passport-local').Strategy
User = mongoose.model 'User'

module.exports = (passport, config) ->

  localStrategy = new LocalStrategy
      usernameField: 'username'
      passwordField: 'password'

  passport.use localStrategy,
    (username, password, done) ->
      return done(err) if err
      return done(null, false, {message: 'Unknown User'}) if not user
      return done(null, false, {message: 'Invalid Password'}) if not user.authenticate(password)
      return done(null, user)