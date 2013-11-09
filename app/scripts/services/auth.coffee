angular.module("demo2App")
  .factory 'auth', ($cookieStore, $http, Base64) ->
    currentUser = $cookieStore.get("user") || { username: "", token: "", permissions: [ { subject: '', action: '' } ] }
    $cookieStore.remove "user"

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

      login: (user) ->
        console.log user
        $http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(user.username + ':' + user.password)

      isLoggedIn: ->
        console.log currentUser
        return true if currentUser.token
        return false
    }