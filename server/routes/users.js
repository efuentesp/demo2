// Generated by CoffeeScript 1.6.3
var passport, users;

passport = require("passport");

users = require('../controllers/users');

module.exports = function(app, config) {
  var bearer;
  bearer = passport.authenticate('bearer', {
    session: false
  });
  app.get('/api/users', bearer, users.list);
  return app.post('/api/users', users.create);
};
