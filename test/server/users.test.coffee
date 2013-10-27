mongoose = require "mongoose"
should = require "should"
app = require "../../server/main"

Permission = mongoose.model('Permission')
Role = mongoose.model('Role')
User = mongoose.model('User')

describe "User Model", ->

  before (done) ->

    permissions = [
      {
        subject: "Schools"
        action: "create"
        displayName: "Create new School"
        description: "Description to create a new School."
      }
      {
        subject: "Schools"
        action: "edit"
        displayName: "Edit a School"
        description: "Description to edit a new School."
      }
      {
        subject: "Schools"
        action: "destroy"
        displayName: "Destroy a School"
        description: "Description to destroy a School."
      }
    ]

    for p in permissions
      permission = new Permission p
      permission.save (err) ->
        done(err) if err

    role = new Role
      name: "admin"
      displayName: "Admin"
      description: "Site Administrator"

    role.save(done)


  it "should register a new User", (done) =>

    @user = new User
      username: "test"
      password: "password"
      email: "test@mail.com"
    @user.save (err) ->
      should.not.exist err
      done()


  it "should add a new Role to User", (done) =>

    @user.addRole 'admin', (err) =>
      should.not.exist err
      @user.save (err) =>
        should.not.exist err
        @user.roles.should.have.lengthOf 1
        done()

  it "should notify when a Role was previously added", (done) =>

    @user.addRole 'admin', (err) =>
      should.exist err
      @user.roles.should.have.lengthOf 1
      done()

  it "should notify when the new Role doesn't exist", (done) =>

    @user.addRole 'xxx', (err) =>
      should.exist err
      @user.roles.should.have.lengthOf 1
      done()


  after (done) ->
    mongoose.connection.db.dropCollection "permissions", (err) ->
      done(err) if err
    mongoose.connection.db.dropCollection "roles", (err) ->
      done(err) if err      
    mongoose.connection.db.dropCollection "users", (err) ->
      done(err) if err
      done()