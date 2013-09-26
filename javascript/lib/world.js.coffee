WorldDSL = require('./dsl/world.js.coffee')

class World

  @create: (name, description) ->
    instance = new this(name)
    new WorldDSL(instance).evaluate description
    instance

  constructor: (@name) ->
    @objects = []

module.exports = World
