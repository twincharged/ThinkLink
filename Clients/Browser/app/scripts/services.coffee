"use strict"

angular.module("thinkLinkApp").factory "AuthManager", ($rootScope, $cookies, Auth)->
  storeSession = (user)-> $cookies.user = JSON.stringify(user)
  deleteSession = ()-> delete $cookies.user
  currentUser: ()-> JSON.parse($cookies.user)
  loggedIn: ()-> $cookies.user != undefined
  register: (credentials)-> Auth.register(credentials).then (user)-> storeSession(user); return user
  login: (credentials)-> Auth.login(credentials).then (user)-> storeSession(user)
  logout: ()-> deleteSession(); if Auth.isAuthenticated() then Auth.logout() else $rootScope.$broadcast("devise:logout")

angular.module("thinkLinkApp").factory "thinkLinkApi", (Restangular, $cookies)->
  if $cookies.user?
    reqs = JSON.parse($cookies.user)
    Restangular.setDefaultRequestParams({reqs_token: reqs.auth_token, reqs_id: reqs.id, reqs_email: reqs.email})


  oneRt = (base, id)-> Restangular.one(base, id)
  oneRtTo = (base, id, relation)-> Restangular.one(base, id).one(relation)

# users

  user: (userId)->
    oneRt("users", userId)
  userAssemblies: (userId)->
    oneRtTo("users", userId, "assemblies")
  userHomeworks: (userId)->
    oneRtTo("users", userId, "homeworks")
  userComments: (userId)->
    oneRtTo("users", userId, "comments")
  updateUser: (userId, params)->
    oneRt("users", userId).put(params)
  addAssembly: (userId, assemblyId)->
    oneRtTo("users", userId, "add_assembly").put({assembly_id: assemblyId})
  answerExam: (userId)->
    oneRtTo("users", userId, "answer_exam")
  answerQuiz: (userId, quizId, answers)->
    oneRtTo("users", userId, "answer_quiz").put({quiz_id: quizId, answers: answers})

# assemblies
  assemblies: ()-> Restangular.all("assemblies")
  assembly: (assemblyId)->
    oneRt("assemblies", assemblyId)
  assemblyUsers: (assemblyId)->
    oneRtTo("assemblies", assemblyId, "users")
  assemblyTeachers: (assemblyId)->
    oneRtTo("assemblies", assemblyId, "teachers")
  assemblyBooks: (assemblyId)->
    oneRtTo("assemblies", assemblyId, "books")
  assemblyTeacherIds: (assemblyId)->
    oneRtTo("assemblies", assemblyId, "teacher_ids")

# books

  books: ()-> Restangular.all("books")
  book: (bookId)->
    oneRt("books", bookId)
  bookUsers: (bookId)->
    oneRtTo("books", bookId, "users")
  bookUnits: (bookId)->
    oneRtTo("books", bookId, "units")
  bookAssembly: (bookId)->
    oneRtTo("books", bookId, "assembly")

# units

  units: ()-> Restangular.all("units")
  unit: (unitId)->
    oneRt("units", unitId)
  unitTeacher: (unitId)->
    oneRtTo("units", unitId, "teacher")
  unitUsers: (unitId)->
    oneRtTo("units", unitId, "users")
  unitChapters: (unitId)->
    oneRtTo("units", unitId, "chapters")
  unitBook: (unitId)->
    oneRtTo("units", unitId, "book")
  examAndQuestions: (unitId)->
    oneRtTo("units", unitId, "questions")

# chapters
  chapters: ()-> Restangular.all("chapters")
  chapter: (chapterId)->
    oneRt("chapters", chapterId)
  chapterUnit: (chapterId)->
    oneRtTo("chapters", chapterId, "unit")
  chapterComments: (chapterId)->
    oneRtTo("chapters", chapterId, "comments")
  quizAndQuestions: (chapterId)->
    oneRtTo("chapters", chapterId, "questions")

# comments

  comment: (commentId)->
    oneRt("comments", commentId)
  commentUser: (commentId)->
    oneRtTo("comments", commentId, "user")
  commentChapter: (commentId)->
    oneRtTo("comments", commentId, "chapter")

# questions
  questions: ()-> Restangular.all("questions")
  question: (questionId)->
    oneRt("questions", questionId)

# homeworks

  homework: (homeworkId)->
    oneRt("homeworks", homeworkId)
  homeworkUser: (homeworkId)->
    oneRtTo("homeworks", homeworkId, "user")
  homeworkBook: (homeworkId)->
    oneRtTo("homeworks", homeworkId, "book")
