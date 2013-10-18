// Generated by CoffeeScript 1.6.3
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
    return plainText === this.hashed_password;
  },
  validateToken: function(token, tokenDecoded) {
    var now;
    if (token !== this.authToken) {
      return false;
    }
    now = Math.round(new Date().getTime() / 1000);
    return tokenDecoded.expires > now;
  }
};

mongoose.model('User', UserSchema);
