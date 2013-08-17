require './world'
require './language'
require './road'
require './field'

def there(object_description)
  @objects ||= []
  @objects << object_description.create(world)
end

def is
  ObjectDescription.new
end

def to
  ObjectConnector.new @objects
end

class ObjectDescription < LanguageDescription

  configure :length, [:short, :long]
  configure :size, [:large, :small]
  configure :width, [:wide, :narrow]

  def road
    RoadDescription.new capture_properties
  end

  def field
    FieldDescription.new capture_properties
  end
end

class ObjectConnector

  def initialize objects
    @objects = objects
    @properties = {}
  end

  def this
    properties[:position] = :last
    self
  end

  def road
    properties[:type] = Road
    self
  end


  def find
    selection = objects
    selection = selection.select { |i| i.is_a? properties[:type] } if properties[:type]

    case properties[:position]
    when :last then return selection.last
    end
  end

  private
  attr_reader :properties, :objects
end
