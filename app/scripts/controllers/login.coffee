angular.module('demo2App')
  .controller 'LoginCtrl', ($scope, auth) ->
    console.log "LOGIN!"

    $scope.login = ->
      console.log "#{$scope.login.username}:#{$scope.login.password}"
      auth.login
        username: $scope.login.username
        password: $scope.login.password