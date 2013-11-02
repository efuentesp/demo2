angular.module("demo2App")
  .factory 'auth', ($cookieStore, $http) ->
    currentUser = $cookieStore.get("user") || { username: "", permissions: [ { subject: '', action: '' } ] }
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

      isLoggedIn: (user) ->
        return false
    }