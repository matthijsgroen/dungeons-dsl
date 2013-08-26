require_relative './language_description'
require_relative './road_description'
require_relative './field_description'
require_relative './special_description'

# TODO Find a cleaner solution to inject 'specials'
require_relative '../lightpost'

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
