angular.module("demo2App")
  .factory 'auth', ($cookieStore, $http, $base64) ->
    currentUser = $cookieStore.get('user') || { username: "", token: "", permissions: [ { subject: '', action: '' } ] }
    #$cookieStore.remove "user"

    return {
      authorize: (accessLevel, permissions) ->
        permissions = currentUser.permissions if permissions is undefined
        permission = accessLevel.split ":"
        subject = permission[0]
        action = permission[1]
        for p in permissions
          return true if p.subject is subject and p.action is action
          return true if p.subject is '*' or p.action is '*'
        return false

      login: (user, done) ->
        #console.log user
        $http.defaults.headers.common['Authorization'] = 'Basic ' + $base64.encode(user.username + ':' + user.password)
        $http.get('/api/auth')
          .success (res) ->
            #console.log "Authorization success!!"
            currentUser =
              username: user.username
              token: res.token
              permissions: res.auth
            $cookieStore.put('user', currentUser)
            #console.log $cookieStore.get 'user'
            done(currentUser)
          .error (res) ->
            #console.log "Authorization ERROR!!"
            done(null, new Error "Authorization error.")

      logout: ->
        $cookieStore.remove "user"

      isLoggedIn: ->
        #console.log currentUser
        return true if currentUser.token
        return false
    }