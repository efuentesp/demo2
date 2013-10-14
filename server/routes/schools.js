// Generated by CoffeeScript 1.6.3
(function() {
  var schools;

  schools = require('../controllers/schools');

  module.exports = function(app) {
    app.get('/api/schools', schools.list);
    app.get('/api/schools/:id', schools.show);
    app.post('/api/schools', schools.create);
    app.put('/api/schools/:id', schools.update);
    return app["delete"]('/api/schools/:id', schools.destroy);
  };

}).call(this);
