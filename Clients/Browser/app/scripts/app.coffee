"use strict"
serverUrl = "http://127.0.0.1:3000/"


angular.module("thinkLinkApp", [
  "ngCookies",
  "ngSanitize",
  "ui.router",
  "restangular",
  "Devise"
])


.config ($stateProvider, $urlRouterProvider)->
  $urlRouterProvider.otherwise "/"
  $stateProvider

    .state "main",
      url: "/"
      templateUrl: "views/initial/main.html"

    .state "signup",
      url: "/signup"
      templateUrl: "views/initial/signup.html"
      controller: "SignupCtrl"

    .state "login",
      url: "/login"
      templateUrl: "views/initial/login.html"
      controller: "LoginCtrl"

    .state "dash",
      url: "/dash"
      templateUrl: "views/dash/dash.html"
      abstract: true

    .state "dash.main",
      url: "/main"
      templateUrl: "views/dash/dash.main.html"
      controller: "DashCtrl"

    .state "dash.books",
      url: "/books"
      templateUrl: "views/books/dash.books.html"
      abstract: true

    .state "dash.books.detail",
      url: "/:bookId"
      templateUrl: "views/books/dash.books.detail.html"
      controller: "BookCtrl"

    .state "dash.units",
      url: "/units"
      templateUrl: "views/units/dash.units.html"
      abstract: true

    .state "dash.units.detail",
      url: "/:unitId"
      templateUrl: "views/units/dash.units.detail.html"
      controller: "UnitCtrl"

    .state "dash.quizzes",
      url: "/quizzes"
      templateUrl: "views/quizzes/dash.quizzes.html"
      abstract: true

    .state "dash.quizzes.detail",
      url: "/:quizId"
      templateUrl: "views/quizzes/dash.quizzes.detail.html"
      controller: "QuizCtrl"

    .state "dash.exams",
      url: "/exams"
      templateUrl: "views/exams/dash.exams.html"
      abstract: true

    .state "dash.exams.detail",
      url: "/:examId"
      templateUrl: "views/exams/dash.exams.detail.html"
      controller: "ExamCtrl"

    .state "dash.assembly",
      url: "/:assemblyId"
      templateUrl: "views/assemblies/dash.assembly.html"
      controller: "AssemblyCtrl"


.config (AuthProvider)->
  AuthProvider.loginPath("#{serverUrl}users/sign_in.json")
  AuthProvider.logoutPath("#{serverUrl}users/sign_out.json")
  AuthProvider.registerPath("#{serverUrl}users.json")
  AuthProvider.ignoreAuth(true)

.config (RestangularProvider)->
  RestangularProvider.setBaseUrl(serverUrl)
  RestangularProvider.setRequestSuffix('.json')

.run ($rootScope, $state)->
  $rootScope.$on "devise:login", ()->
    $state.go("dash.main")
.run ($rootScope)->
  $rootScope.$on "devise:unauthorized", ()->
    alert("Incorrect email/password")
.run ($rootScope, $state)->
  $rootScope.$on "devise:new-registration", ()->
    $state.go("dash.main")
.run ($rootScope, $state)->
  $rootScope.$on "devise:logout", ()->
    $state.go("main")

.run ($state, $cookies)->
  if $cookies.user == undefined then $state.go("main")
