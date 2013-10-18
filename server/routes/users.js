// Generated by CoffeeScript 1.6.3
var passport, users;

passport = require("passport");

users = require('../controllers/users');

module.exports = function(app, config) {
  var auth, bearer;
  auth = passport.authenticate('basic', {
    session: false
  });
  bearer = passport.authenticate('bearer', {
    session: false
  });
  app.get('/api/auth', auth, users.auth);
  app.get('/api/users', bearer, users.list);
  return app.post('/api/users', bearer, users.create);
};
