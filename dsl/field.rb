require './map_object'
require './area'
require './object_finder'

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
  include ObjectFinder

  def initialize world, configuration
    super world
    @configuration = configuration
    @objects = []

    @area = []
  end

  def create
    field_type = configuration[:field_type] || :grass
    direction = configuration[:start_direction]
    size = configuration[:size] || 6 + rand(20)
    area = Area.new(world, configuration[:start_position], size, direction)
    area.fill field_type
    area.populate_with_decals 0.2, field_type

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

      road = Road.create(world, road_configuration.merge(
        direction_bound: 0
      ))
      road = Road.create(world, road_configuration.merge(
        start: road.configuration[:end]
      ))

      road_direction = pick_direction(direction)

      objects << Road.create(world, road_configuration.merge(
        start: road.configuration[:end],
        length: nil,
        area_bound: area,
        direction_bound: size/4,
        general_direction: road_direction
      ))

      if configuration[:road_type] == :forked
        directions_taken = [
          road_direction,
          opposite_direction(direction)
        ]
        directions_left = [:north, :south, :east, :west] - directions_taken
        new_direction = directions_left.sample

        objects << Road.create(world, road_configuration.merge(
          start: road.configuration[:end],
          length: size/2,
          direction_bound: size/4,
          general_direction: new_direction
        ))
      end

      configuration[:end] = objects.last.configuration[:end]
      configuration[:end_direction] = objects.last.configuration[:end_direction]
    end
    self
  end

  attr_reader :configuration, :objects

end
