chai = require('chai')
expect = chai.expect
should = chai.should()

Road = require '../lib/road.js.coffee'

describe 'Road', ->

  beforeEach ->
    @road = new Road

  afterEach ->
    @road = null

  it 'has a length', ->
    @road.length.should.equal 4
