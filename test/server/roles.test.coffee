mongoose = require "mongoose"
should = require "should"
app = require "../../server/main"

Permission = mongoose.model('Permission')
Role = mongoose.model('Role')

describe "Role Model", ->

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
    done()


  it "should register a new Role", (done) =>

    @role = new Role
      name: "admin"
      displayName: "Admin"
      description: "Site Administrator"

    @role.save (err) ->
      should.not.exist err
      done()


  it "should add a new valid Permission to the Role", (done) =>

    permission =
      subject: 'Schools'
      action: 'edit'

    @role.addPermission permission, (err) =>
      should.not.exist err
      @role.save (err) =>
        should.not.exist err
        @role.permissions.should.have.lengthOf 1
        @role.permissions[0].subject.should.equal 'Schools'
        @role.permissions[0].action.should.equal 'edit'
        done()


  it "should not add a new invalid Permission to the Role", (done) =>

    permission =
      subject: 'XXX'
      action: 'edit'

    @role.addPermission permission, (err) =>
      should.exist err
      @role.permissions.should.have.lengthOf 1
      done()


  it "should check if a Role has a given Permission", (done) =>

    permission =
      subject: 'Schools'
      action: 'edit'

    @role.hasPermission(permission).should.equal true
    done()


  it "should not add duplicated Permissions", (done) =>

    permission =
      subject: 'Schools'
      action: 'edit'

    @role.addPermission permission, (err) =>
      should.exist err
      @role.permissions.should.have.lengthOf 1
      done()


  after (done) ->
    mongoose.connection.db.dropCollection "roles", (err) ->
      done(err) if err
      mongoose.connection.db.dropCollection "permissions", (err) ->
        done(err) if err
        done()