questionUser = require './questionUser'  

module.exports = (questions, done) ->

  # add package questions 
  pkgQuestions = 
    name:
      prompt: 'Project name'
      input:
        type: String
    description:
      prompt: 'Description'
      input:
        type: String
    org:
      prompt: 'Github user/organization'
      input: 
        type: String
    author:
      prompt: 'Author'
      input:
        type: String



  answers = {}

  questionUser pkgQuestions, (pkg) ->
    questionUser questions, (answers) ->
      answers = 
        package: pkg
        answers: answers

      done answers