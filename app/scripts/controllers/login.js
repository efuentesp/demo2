// Generated by CoffeeScript 1.6.3
angular.module('demo2App').controller('LoginCtrl', function($scope, auth) {
  console.log("LOGIN!");
  return $scope.login = function() {
    console.log("" + $scope.login.username + ":" + $scope.login.password);
    return auth.login({
      username: $scope.login.username,
      password: $scope.login.password
    });
  };
});
