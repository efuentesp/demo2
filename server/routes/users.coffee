users = require '../controllers/users'

module.exports = (app) ->
  app.get     '/api/auth',      users.auth
  #app.get     '/api/users',     users.list
  #app.get     '/api/users/:id', users.show  
  #app.post    '/api/users',     users.create
  #app.put     '/api/users/:id', users.update
  #app.delete  '/api/users/:id', users.destroy