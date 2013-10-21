mongoose = require "mongoose"
request = require "supertest"
should = require "should"
#should = require("chai").should
app = require "../../server/main"

User = mongoose.model('User')

describe "User Model", ->

  it "should register a new User", (done) ->
    @user = new User
      username: "test"
      password: "password"
      email: "test@mail.com"
    @user.save (err) ->
      done(err) if err
    done()
