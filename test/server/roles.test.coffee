mongoose = require "mongoose"
should = require "should"
app = require "../../server/main"

Permission = mongoose.model('Permission')
Role = mongoose.model('Role')

describe "Role Model", ->

  before (done) ->

    mongoose.connection.db.dropCollection "roles", (err) ->
      done(err) if err

    @permissions = [
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
    for p in @permissions
      permission = new Permission p
      permission.save (err) ->
        done(err) if err
    done()    


  it "should register a new Role", (done) ->

    permissions = [
      {
        subject: "Schools"
        action: "create"
        displayName: "Create new School"
        description: "Description to create a new School."
      }
      {
        subject: "Schools"
        action: "destroy"
        displayName: "Destroy a School"
        description: "Description to destroy a School."
      }
    ]

    @role = new Role
      name: "admin"
      displayName: "Admin"
      description: "Site Administrator"
      permissions: permissions

    @role.save (err) ->
      done(err) if err

    @role.permissions.length.should.equal 2
    done()


  it "should add a new valid Permission to the Role", (done) ->

    permission =
      subject: 'Schools'
      action: 'edit'

    @role.addPermission permission, (err) =>
      should.not.exist err
      @role.permissions.should.have.lengthOf 3
      done()


  it "should add a new invalid Permission to the Role", (done) ->

    permission =
      subject: 'XXX'
      action: 'edit'

    @role.addPermission permission, (err) =>
      should.exist err
      @role.permissions.should.have.lengthOf 2
      done()


  it "should check if Role has a given Permission", (done) ->
    Permission.findOne {subject: "Schools", action: "edit"}, (err, permission) ->
      throw err if err
      role = new Role
        name: "admin"
        displayName: "Admin"
        description: "Site Administrator"
      role.save (err) ->
        throw err if err
        role.addPermission permission
        role.save (err) ->
          throw err if err
          role.hasPermission("Schools", "edit").should.equal true
    done()


  it "should not add duplicated Permissions", (done) ->
    Permission.findOne {subject: "Schools", action: "edit"}, (err, permission) ->
      throw err if err
      role = new Role
        name: "admin"
        displayName: "Admin"
        description: "Site Administrator"
      role.save (err) ->
        throw err if err
        role.addPermission permission
        role.save (err) ->
          throw err if err
          role.hasPermission("Schools", "edit").should.equal true
          role.permissions.length.should.equal 2
          role.addPermission permission
          role.save (err) ->
            throw err if err
            role.permissions.length.should.equal 3
    done()


  after (done) ->
    mongoose.connection.db.dropCollection "roles", (err) ->
      throw err if err
    done()