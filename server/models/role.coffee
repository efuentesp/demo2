mongoose = require 'mongoose'

Schema = mongoose.Schema

RoleSchema = new Schema
  name:
    type: String
    default: ''
  displayName: String
  description: String
  permissions: [
    type: mongoose.Schema.Types.ObjectId
    ref: 'Permission'
  ]

mongoose.model('Role', RoleSchema)