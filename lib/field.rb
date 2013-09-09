require_relative './map_object'
require_relative './area'
require_relative './dsl/object_finder'

class Field < MapObject
  include ObjectFinder

  def initialize world, configuration
    super world
    @configuration = {
      field_type: :grass,
      start_direction: Direction.pick,
      start_position: [rand(500), rand(500)],
      size: 6 + rand(20)
    }.merge configuration

    @objects = []

    @area = []
  end

  def create
    field_type = configuration[:field_type]
    direction = configuration[:start_direction]
    start_position = configuration[:start_position]
    size = configuration[:size]

    area = Area.new(world, start_position, size, direction)
    area.fill field_type
    area.populate_with_decals 0.1, field_type, configuration[:decals]

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
          direction.opposite
        ]
        new_direction = Direction.pick_except directions_taken

        objects << Road.create(world, road_configuration.merge(
          start: road.configuration[:end],
          length: size/2,
          direction_bound: size/4,
          general_direction: new_direction
        ))
      end

      configuration[:end] = objects.last.configuration[:end]
      configuration[:end_direction] = objects.last.configuration[:end_direction]
    else
      configuration[:end] = move_direction(configuration[:start_position], configuration[:start_direction], configuration[:size])
      configuration[:end_direction] = configuration[:start_direction]
    end
    self
  end

  attr_reader :configuration, :objects

end
