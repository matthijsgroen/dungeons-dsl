chai = require('chai')
expect = chai.expect
should = chai.should()

World = require '../lib/world.js.coffee'

describe 'World', ->

  describe '::create', ->

    it 'creates a world instance', ->
      result = World.create 'field', ->
      result.should.be.an.instanceof World

    it 'assigns the name of the world', ->
      result = World.create 'field', ->
      result.name.should.equal 'field'

    it 'executes a DSL', ->
      result = World.create 'field', ->
        @there.is.a.road

      result.objects.should.have.length 1



