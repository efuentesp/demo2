express = require 'express'
routes = require './routes'

env = process.env.NODE_ENV || 'development'
config = require('./config/config')[env]
mongoose = require 'mongoose'

mongoose.connect config.db

require "./models/school"

app = express()

app.use express.bodyParser()

schools = require './routes/schools'
schools app

app.get '/api/awesomeThings', routes.awesomeThings

app.use (req, res) ->
  res.json {'ok': false, 'status': '404'}

exports = module.exports = app