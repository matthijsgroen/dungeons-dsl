require './world'
require './language'
require './road'
require './field'

class ObjectDescription < LanguageDescription

  configure :length, [:short, :long]
  configure :size, [:large, :small]
  configure :width, [:wide, :narrow]
  configure :terrain_type, [:rock, :grass, :dirt]

  def road
    RoadDescription.new capture_properties
  end

  def field
    FieldDescription.new capture_properties
  end
end

class ObjectConnector < LanguageDescription

  include ObjectFinder

  configure :position, [:this, :last, :first]
  chains :the, :of

  def initialize objects
    super()
    @objects = objects
    @nesting = []
  end

  def road
    nesting << capture_properties.merge(type: Road)
    reset_capture_properties
    self
  end

  def field
    nesting << capture_properties.merge(type: Field)
    reset_capture_properties
    self
  end

  def find
    find_object nesting
  end

  private
  attr_reader :objects, :nesting
end
