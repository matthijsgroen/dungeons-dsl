require './world'
require './language'
require './object_finder'
require './special'
require './road'
require './field'

# specials
require './lightpost'

class ObjectDescription < LanguageDescription

  class << self
    def special(klass)
      name = klass.name.downcase
      define_method(name) do
        SpecialDescription.new(klass, capture_properties)
      end
      plural = "#{name}s"
      define_method(plural) do
        SpecialDescription.new(klass, capture_properties)
      end
    end
  end

  configure :length, [:short, :long]
  configure :size, [:large, :small]
  configure :width, [:wide, :narrow]
  configure :terrain_type, [:rock, :grass, :dirt]
  configure :amount, [:several]
  special Lightpost

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
