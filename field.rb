require './map_object'

class FieldDescription < LanguageDescription

  configure :road_type, [:across]
  configure :field_type, [:rocky, :grassy]

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
    p[:field_type] = properties[:terrain_type]
    p
  end
end

class Field < MapObject

  def initialize world, configuration
    super world
    @configuration = configuration
  end

  def create
    field_type = configuration[:field_type] || :grassy
    pos = configuration[:start_position]
    direction = configuration[:start_direction]

    f = configuration[:size]

    f.times.each do |index|
      pos = move_direction(pos, direction)
      base = (f/2) - (index - (f/2)).abs + 1
      place_tiles(pos, rotate_direction(direction, 90), base + rand(f/4), field_type)
      place_tiles(pos, rotate_direction(direction, -90), base + rand(f/4), field_type)
    end

    ## Add road if indicated
    road_configuration = {
      start: configuration[:start_position],
      length: f,
      twist_factor: 2
    }
    case direction
    when :north, :south then road_configuration[:vertical_direction] = direction
    when :east, :west then road_configuration[:horizontal_direction] = direction
    end

    road = Road.create world, road_configuration
    configuration[:end] = road.configuration[:end]
    configuration[:end_direction] = road.configuration[:end_direction]
    self
  end

  attr_reader :configuration

end
