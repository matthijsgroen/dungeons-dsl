require './map_object'

class FieldDescription < LanguageDescription

  chains :across
  configure :road_type, [:forked]
  configure :field_type, [:rock, :grass]

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
    p = {}
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
    @roads = []

    @area = []
  end

  def create
    field_type = configuration[:field_type] || :grass
    direction = configuration[:start_direction]
    size = configuration[:size]
    area = Area.new(world, configuration[:start_position], size, direction)
    area.fill field_type

    if configuration[:road]
      road_configuration = {
        start: configuration[:start_position],
        length: size/4,
        twist_factor: 4,
        direction_bound: size/4,
        general_direction: direction,
        bank: {
          width: :narrow,
          type: field_type
        }
      }

      road = Road.create(world, road_configuration)
      road = Road.create(world, road_configuration.merge(
        start: road.configuration[:end],
        general_direction: direction,
        direction_bound: 0
      ))

      road_direction = pick_direction(direction)

      @roads << Road.create(world, road_configuration.merge(
        start: road.configuration[:end],
        length: nil,
        area_bound: area,
        direction_bound: size/4,
        general_direction: road_direction
      ))

      if configuration[:road_type] == :forked && false
        new_direction = ([:north, :south, :east, :west] - [road_direction, opposite_direction(direction)]).sample

        @roads << Road.create(world, road_configuration.merge(
          start: road.configuration[:end],
          length: size/2,
          direction_bound: size/4,
          general_direction: new_direction
        ))
      end

      configuration[:end] = @roads.last.configuration[:end]
      configuration[:end_direction] = @roads.last.configuration[:end_direction]
    end
    self
  end

  attr_reader :configuration

  private

  class Area < MapObject

    def initialize world, start_position, size, direction
      super(world)
      @area = []
      define_space start_position, size, direction
    end

    def fill field_type
      @area.each do |part|
        place_tiles(part[:start], part[:direction], part[:distance], field_type)
      end
    end

    private
    def define_space start_position, size, direction
      side_a = rotate_direction(direction, 90)
      side_b = rotate_direction(direction, -90)

      size.times.each do |index|
        pos = move_direction(start_position, direction, 1 + index)
        base = (size/2) - (index - (size/2)).abs + 1

        length_a = base + rand(size/4)
        start = move_direction(pos, side_a, length_a)
        length_b = base + rand(size/4)

        @area << { start: start, direction: side_b, distance: length_a + length_b }
      end
    end

  end

end
