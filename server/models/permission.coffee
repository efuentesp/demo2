mongoose = require 'mongoose'

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