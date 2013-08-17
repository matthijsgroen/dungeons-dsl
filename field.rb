require './map_object'

class FieldDescription < LanguageDescription

  configure :road_type, [:across]

  def initialize(properties)
    @properties = convert_properties properties
    super()
  end

  def connected(connector)
    object = connector.find
    @properties[:start_position] = object.configuration[:end]
    @properties[:start_direction] = object.configuration[:end_direction]
    self
  end

  def road
    @properties[:road] = true
    self
  end

  def create(world)
    Field.create(world, @properties.merge(@capture_properties))
  end

  private

  def convert_properties properties
    p = {
      edges: []
    }
    p[:size] = 6 + rand(10) if properties[:size] == :small
    p[:size] = 15 + rand(20) if properties[:size] == :large
    p
  end
end

class Field < MapObject

  def initialize world, configuration
    super world
    @configuration = configuration
  end

  def create
    pos = configuration[:start_position]
    direction = configuration[:start_direction]

    f = configuration[:size]

    f.times.each do |index|
      pos = move_direction(pos, direction)

      base = (f/2) - (index - (f/2)).abs

      place_tiles(pos, rotate_direction(direction, 90), base + rand(f/4), :field)
      place_tiles(pos, rotate_direction(direction, -90), base + rand(f/4), :field)
    end
    self
  end

  private

  attr_reader :configuration

end
