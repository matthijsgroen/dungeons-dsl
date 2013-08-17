require './world'
require './language'
require './road'

def there(object_description)
  object_description.create world
end

def is
  ObjectDescription.new
end

class ObjectDescription < LanguageDescription

  attr_reader :properties

  def initialize
    @properties = {}
  end

  def short
    @properties[:length] = :short
    self
  end

  def long
    @properties[:length] = :long
    self
  end

  def road
    RoadDescription.new properties
  end
end
