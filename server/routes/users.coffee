passport = require "passport"
users = require '../controllers/users'

module.exports = (app) ->
  auth = passport.authenticate('basic', { session: false })

  app.get     '/api/auth',      auth, users.auth
  app.get     '/api/users',     auth, users.list
  #app.get     '/api/users/:id', users.show  
  app.post    '/api/users',     users.create
  #app.put     '/api/users/:id', users.update
  #app.delete  '/api/users/:id', users.destroy

# To test with http basic auth:
#    curl -v --basic --user admin:password localhost:9001/api/auth