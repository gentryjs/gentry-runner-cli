readline = require 'readline'
async = require 'async'
color = require 'cli-color'
Model = require 'mongoose-schema-model'
  
module.exports = (questions, done) ->

  # cli reading setup
  rl = readline.createInterface
    input: process.stdin
    output: process.stdout

  answers = {}

  # TODO: async map/reduce over objects

  async.eachSeries Object.keys(questions), (k, next) ->

    question = questions[k]
    prompt   = question.prompt 

    # ask question
    ask = ->
      rl.question "#{prompt}: ", (answer) ->      
        # validate schema
        model = Model question: question.input
        model = model.set 'question', answer        
        if !model.error?
          answers[k] = model.value
          next()
        # trigger default
        else if question.input.default? and answer is ''
          answers[k] = question.input.default
          next()
        # invalid
        else
          console.log color.red.bold "Invalid Selection"
          ask()

    # if 'enum' is a function, 
    # run it to get resulting enum array
    if typeof(question.input.enum) is 'function'
      fn = question.input.enum.bind(answers)
      question.input.enum = fn()
        
    # if it's an enum, build prompt options 
    if question.input.type is String and question.input.enum?
      prompt += " [" 
      for q in question.input.enum
        if q is question.input.default
          prompt += color.green(q) + ", "
        else
          prompt += "#{q}, "
      prompt = prompt.substr 0, prompt.length-2
      prompt += "]\n"

    # initial ask 
    ask()

  , ->

    # close cli reading 
    rl.close()
    # just return answers
    done answers
