module.exports = {

	development: {
		app: {
			name: 'Peacemakers (dev)'
		},
		db: 'mongodb://localhost/peacemakers-dev'
	}

	testing: {
		app: {
			name: 'Peacemakers (test)'
		},
		db: 'mongodb://localhost/peacemakers-test'
	}
}