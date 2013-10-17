// Generated by CoffeeScript 1.6.3
(function() {
  var Schema, UserSchema, mongoose;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  UserSchema = new Schema({
    username: {
      type: String,
      "default": ''
    },
    hashed_password: {
      type: String,
      "default": ''
    },
    email: {
      type: String,
      "default": ''
    },
    authToken: {
      type: String,
      "default": ''
    }
  });

  UserSchema.methods = {
    authenticate: function(plainText) {
      return this.plainText === this.hashed_password;
    }
  };

  mongoose.model('User', UserSchema);

}).call(this);