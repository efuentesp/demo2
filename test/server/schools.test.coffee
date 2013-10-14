should = require "should"
request = require "supertest"
mongoose = require "mongoose"
app = require "../../server/main"
School = mongoose.model('School')

describe "SchoolsAPI", ->
  url = "http://localhost:9001"

  describe "GET /schools", ->

    before (done) ->
      schools = [
        {
          name: "Test School 1"
          www: "www.testschool1.edu.mx"
        }
        {
          name: "Test School 2"
          www: "www.testschool2.edu.mx"
        }
        {
          name: "Test School 3"
          www: "www.testschool3.edu.mx"
        }
      ]
      for s in schools
        school = new School s
        school.save (err) ->
          throw err if err
      done()

    it "should retrieve all Schools", (done) ->
      request(url)
        .get("/api/schools")
        .expect('Content-Type', /json/)
        .expect(200)
        .end (err, res) ->
          throw err if err
          res.should.be.json
          #res.body.should.have.length(3)
          #res.body.should.include({ name: "Test School 2" })
          done()

    after (done) ->
      School.collection.remove(done)


  describe "POST /schools", ->

    it "should creates a new School", (done) ->
      school =
        name: "Test School 1"
        www: "www.testschool1.edu.mx"

      request(url)
        .post("/api/schools")
        .send(school)
        .expect('Content-Type', /json/)
        .expect(200)
        .end (err, res) =>
          throw err if err
          @school_added = res.body
          res.body.should.have.property('_id')
          res.body.name.should.equal('Test School 1')
          res.body.www.should.equal('www.testschool1.edu.mx')
          res.body.createdAt.should.not.equal(null)
          done()

    after (done) ->
      School.findById @school_added._id, (err, school) ->
        if not err
          school.remove(done)
          #console.log "----> School: #{school._id} removed!"
        else
          throw err


  describe "PUT /schools", ->

    before (done) ->
      @school_before = new School
        name: "New School"
        www: "www.newschool.edu.mx"
      @school_before.save(done)

    it "should update an existing School", (done) ->
      school =
        name: "Test School 1 modified"
        www: "www.mtestschool1.edu.mx"

      request(url)
        .put("/api/schools/#{@school_before._id}")
        .send(school)
        .expect('Content-Type', /json/)
        .expect(200)
        .end (err, res) ->
          throw err if err
          res.body.should.have.property('_id')
          res.body.name.should.equal('Test School 1 modified')
          res.body.www.should.equal('www.mtestschool1.edu.mx')
          res.body.createdAt.should.not.equal(null)
          done()

    after (done) ->
      School.findById @school_before._id, (err, school) ->
        if not err
          school.remove(done)
          #console.log "----> School: #{school._id} removed!"
        else
          throw err

  describe "DELETE /schools", ->

    before (done) ->
      @school_before = new School
        name: "New School"
        www: "www.newschool.edu.mx"
      @school_before.save(done)

    it "should delete an existing School", (done) ->

      request(url)
        .del("/api/schools/#{@school_before._id}")
        .expect(200)
        .end (done)
