# Module dependencies
express = require 'express'
passport = require 'passport'
routes = require './routes' # Eliminar

# Configurations
env = process.env.NODE_ENV || 'development'
config = require('./config/config')[env]
mongoose = require 'mongoose'

# Database connection
mongoose.connect config.db

# Models
require "./models/school"

# Authentication Middlware
require('./config/passport')(passport, config)

# Web Application Framework
app = express()
app.use express.bodyParser()

# Routes
schools = require './routes/schools'
schools app

app.get '/api/awesomeThings', routes.awesomeThings # Eliminar

app.use (req, res) ->
  res.json {'ok': false, 'status': '404'}

# Expose app
exports = module.exports = app