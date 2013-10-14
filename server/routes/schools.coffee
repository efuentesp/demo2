schools = require '../controllers/schools'

module.exports = (app) ->
	app.get 		'/api/schools', 		schools.list
	app.get			'/api/schools/:id',	schools.show	
	app.post 		'/api/schools', 		schools.create
	app.put 		'/api/schools/:id', schools.update
	app.delete	'/api/schools/:id', schools.destroy