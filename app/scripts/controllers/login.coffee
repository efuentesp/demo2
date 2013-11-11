angular.module('demo2App')
  .controller 'LoginCtrl', ($scope, $state, auth) ->

    $scope.login = ->
      #console.log "#{$scope.login.username}:#{$scope.login.password}"
      #console.log "toState: #{$scope.toState}"
      toState = $scope.toState
      $scope.toState = null
      auth.login
        username: $scope.login.username
        password: $scope.login.password
      , (user, error) ->
        console.log error if error
        console.log user if user
        console.log "toState: #{$scope.toState}"
        $state.transitionTo toState

    $scope.logout = ->
      console.log "Logout!"
      auth.logout
      $state.transitionTo 'main'