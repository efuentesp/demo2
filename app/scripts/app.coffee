angular.module('demo2App', ['ui.router'])
  .config ($stateProvider, $urlRouterProvider, $locationProvider) ->

    $urlRouterProvider.otherwise('/404');

    $stateProvider
      .state 'main',
        url: "/"
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'

      .state 'login',
        url: "/login"
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'

      .state 'school',
        url: "/school"
        templateUrl: 'views/school.html'
        controller: 'SchoolCtrl'

      .state 'not_found',
        url: "/404"
        templateUrl: '404.html'

    $locationProvider.html5Mode true