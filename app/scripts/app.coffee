angular.module('demo2App', ['ui.router', 'ngCookies', 'ngBase64'])
  .config ($stateProvider, $urlRouterProvider, $locationProvider) ->

    $urlRouterProvider.otherwise('/404');

    $stateProvider
      .state 'main',
        url: "/"
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        access: '*:*'

      .state 'school',
        url: "/school"
        templateUrl: 'views/school.html'
        controller: 'SchoolCtrl'
        access: 'schools:*'

      .state 'login',
        url: "/login"
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'
        access: '*:*'

      .state 'logout',
        url: "/logout"
        controller: 'LoginCtrl'
        access: '*:*'

      .state 'not_found',
        url: "/404"
        templateUrl: '404.html'
        access: '*:*'

    $locationProvider.html5Mode true

  .run ($state, $rootScope, auth) ->
    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      #console.log toState
      console.log "StateChangeStart from: " + fromState.url + " to: " + toState.url
      #$rootScope.doingResolve = true
      $rootScope.error = null
      if toState.access isnt '*:*' and not auth.isLoggedIn()
        event.preventDefault()
        $rootScope.toState = toState.name
        $state.transitionTo 'login'

      ###
      if toState.name is not 'login'
        if not auth.authorize toState.access
          if auth.isLoggedIn()
            $state.go 'main'
          else
            console.log ">> Login"
            $state.go 'login'
      ###

    $rootScope.$on '$stateChangeSuccess', ->
      $rootScope.doingResolve = false
      #console.log 'StateChangeSuccess'