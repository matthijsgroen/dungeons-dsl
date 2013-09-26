class WorldDSL

  constructor: (@world) ->
    @_defineWord 'there', ->
    @_defineWord 'is', ->
    @_defineWord 'a', ->
    @_defineWord 'road', -> @world.objects.push 'a'

  evaluate: (description) ->
    description.call this

  _defineWord: (word, method) ->
    Object.defineProperty this, word,
      get: =>
        method.call(this)
        this

module.exports = WorldDSL
