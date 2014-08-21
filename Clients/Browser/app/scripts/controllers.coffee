"use strict"



angular.module("thinkLinkApp").controller "NavCtrl", ($scope, AuthManager, $state)->
  $scope.logButton = if AuthManager.loggedIn() then "Log out" else "Log in"
  $scope.log = ()->
    if AuthManager.loggedIn() then AuthManager.logout(); $scope.logButton = "Log in"
    else $state.go('login')



angular.module("thinkLinkApp").controller "SignupCtrl", ($scope, AuthManager, thinkLinkApi)->
  $scope.newAssembly = false
  $scope.register = ()->
    AuthManager.register($scope.user).then (user)->
      if $scope.assembly? then thinkLinkApi.assemblies().post($scope.assembly).then (assembly)->
        thinkLinkApi.addAssembly(user.id, assembly.id)



angular.module("thinkLinkApp").controller "LoginCtrl", ($scope, AuthManager, $cookies)->
  $scope.credentials = {email:"", password:""}
  $scope.login = (credentials)-> AuthManager.login(credentials)



angular.module("thinkLinkApp").controller "DashCtrl", ($scope, AuthManager, thinkLinkApi)->
  user = AuthManager.currentUser()
  thinkLinkApi.userAssemblies(user.id).get().then (asm)-> $scope.assemblies = asm
  thinkLinkApi.userHomeworks(user.id).get().then (hws)-> $scope.homeworks = hws



angular.module("thinkLinkApp").controller "BookCtrl", ($scope, $stateParams, AuthManager, thinkLinkApi)->
  [$scope.exams, $scope.units, $scope.showUnitForm, $scope.showExamForm, $scope.isTeacher, $scope.examQuestions] =
  [[],[],false,false,true,[{content:"",a: "",b: "",c: "",d: "",answer:""}]]
  thinkLinkApi.bookUnits($stateParams.bookId).get().then (data)->
    for dat in data
      if dat.exam == true then $scope.exams.push(dat) else $scope.units.push(dat)
    $scope.examsStatement = unless $scope.exams.length != 0 then "None for now!"
  $scope.newQuestion = ($event)-> $scope.examQuestions.push({content:"",a: "",b: "",c: "",d: "",answer:""}); $event.preventDefault()
  $scope.wipeUnit = ()-> [$scope.showUnitForm,$scope.unt] = [false,{}]
  $scope.wipeExam = ()-> [$scope.showExamForm,$scope.ex,$scope.examQuestions] = [false,{},[{content:"",a: "",b: "",c: "",d: "",answer:""}]]
  $scope.addUnit = (unt)->
    unt.teacher_id = AuthManager.currentUser().id
    unt.book_id = $stateParams.bookId
    thinkLinkApi.units().post({unit: unt}).then (data)->
      place = if data.exam == true then "exams" else $scope.wipeUnit(); "units"
      $scope[place].push(data); data
  $scope.addExam = (ex)->
    ex.exam = true
    $scope.addUnit(ex).then (data)->
      for eq in $scope.examQuestions
        eq.unit_id = data.id
        thinkLinkApi.questions().post(eq)
      $scope.wipeExam()



angular.module("thinkLinkApp").controller "UnitCtrl", ($scope, $stateParams, AuthManager, thinkLinkApi)->
  [$scope.quizzes, $scope.chapters, $scope.showChapterForm, $scope.showQuizForm, $scope.isTeacher, $scope.quizQuestions] =
  [[],[],false,false,true,[{content:"",a: "",b: "",c: "",d: "",answer:""}]]
  thinkLinkApi.unitChapters($stateParams.unitId).get().then (data)->
    for dat in data
      if dat.quiz == true then $scope.quizzes.push(dat) else $scope.chapters.push(dat)
    $scope.quizzesStatement = unless $scope.quizzes.length != 0 then "None for now!"
  $scope.newQuestion = ($event)-> $scope.quizQuestions.push({content:"",a: "",b: "",c: "",d: "",answer:""}); $event.preventDefault()
  $scope.wipeChapter = ()-> [$scope.showChapterForm, $scope.chp] = [false,{}]
  $scope.wipeQuiz = ()-> [$scope.showQuizForm, $scope.qz, $scope.quizQuestions] = [false,{},[{content:"",a: "",b: "",c: "",d: "",answer:""}]]
  $scope.addChapter = (chp)->
    chp.teacher_id = AuthManager.currentUser().id
    chp.unit_id = $stateParams.unitId
    thinkLinkApi.chapters().post(chapter: chp).then (data)->
      place = if data.quiz == true then "quizzes" else $scope.wipeChapter(); "chapters"
      $scope[place].push(data); data
  $scope.addQuiz = (qz)->
    qz.quiz = true
    $scope.addChapter(qz).then (data)->
      for qq in $scope.quizQuestions
        qq.chapter_id = data.id
        thinkLinkApi.questions().post(qq)
      $scope.wipeQuiz()



angular.module("thinkLinkApp").controller "QuizCtrl", ($scope, $stateParams, AuthManager, thinkLinkApi)->
  [$scope.answers, $scope.correctIds, $scope.done] = [[], [], false]
  thinkLinkApi.quizAndQuestions($stateParams.quizId).get().then (data)->
    [$scope.quiz, $scope.questions] = [data.quiz, data.questions]
    $scope.submitQuiz = ()->
      for question in $scope.questions
        if $scope.answers[$scope.questions.indexOf(question)] == question.answer then $scope.correctIds.push(question.id)
      $scope.done = true
      ae = thinkLinkApi.answerQuiz(AuthManager.currentUser().id)
      ae.questions = {quiz_id: $scope.quiz.id, answers: $scope.correctIds}
      ae.post()
      $scope.score = parseFloat($scope.correctIds.length/$scope.questions.length.toFixed(2))*100.0



angular.module("thinkLinkApp").controller "ExamCtrl", ($scope, $stateParams, AuthManager, thinkLinkApi)->
  [$scope.answers, $scope.correctIds, $scope.done] = [[], [], false]
  thinkLinkApi.examAndQuestions($stateParams.examId).get().then (data)->
    [$scope.exam, $scope.questions] = [data.exam, data.questions]
    $scope.submitExam = ()->
      for question in $scope.questions
        if $scope.answers[$scope.questions.indexOf(question)] == question.answer then $scope.correctIds.push(question.id)
      $scope.done = true
      ae = thinkLinkApi.answerExam(AuthManager.currentUser().id)
      ae.questions = {exam_id: $scope.exam.id, answers: $scope.correctIds}
      ae.post()
      $scope.score = parseFloat($scope.correctIds.length/$scope.questions.length.toFixed(2))*100.0



angular.module("thinkLinkApp").controller "AssemblyCtrl", ($scope, $stateParams, AuthManager, thinkLinkApi)->
  [$scope.showBkForm, $scope.isTeacher] = [false, false]
  thinkLinkApi.assemblyTeacherIds($stateParams.assemblyId).get().then (ids)->
    $scope.isTeacher = if AuthManager.currentUser().id in ids then true else false
  thinkLinkApi.assembly($stateParams.assemblyId).get().then (data)->
    $scope.assembly = data
  thinkLinkApi.assemblyBooks($stateParams.assemblyId).get().then (data)->
    $scope.books = data
  $scope.addBook = (bk)-> 
    bk.assembly_id = $scope.assembly.id
    thinkLinkApi.books().post(bk).then (data)->
      $scope.books.push(data)
