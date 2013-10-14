should = require "should"
request = require "supertest"
mongoose = require "mongoose"

describe "SchoolsAPI", ->
	url = "http://localhost:9001"

	before (done) ->
		mongoose.connect "mongodb://localhost/peacemakers-dev"
		done()

	it "POST a new School", (done) ->
		school =
			name: "Test School 1"
			www: "www.testschool1.edu.mx"

		request(url)
			.post("/api/schools")
			.send(school)
			.expect('Content-Type', /json/)
			.expect(200)
			.end (err, res) ->
				if err
					throw err
				res.body.should.have.property('_id')
				res.body.name.should.equal('Test School 1')
				res.body.www.should.equal('www.testschool1.edu.mx')
				res.body.createdAt.should.not.equal(null)
				done()