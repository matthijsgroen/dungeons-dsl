require './map_object'

class RoadDescription < LanguageDescription

  configure :width, [:wide, :narrow]

  def initialize(properties)
    @properties = convert_properties properties
    super()
  end

  def create(world)
    Road.create(world, @properties)
  end

  def connected(connector)
    object = connector.find
    @properties[:start] = object.configuration[:end]
    @properties[:general_direction] = object.configuration[:end_direction]
    self
  end

  def bank
    @properties[:bank] = {
      width: :narrow
    }.merge capture_properties
    @capture_properties = {}
    self
  end

  private

  def convert_properties properties
    p = {}
    p[:length] = 5 + rand(10) if properties[:length] == :short
    p[:length] = 25 + rand(20) if properties[:length] == :long
    p
  end
end

class Road < MapObject

  def initialize world, configuration
    super(world)
    @configuration = {
      start: [rand(500), rand(500)],
      length: 10 + rand(30),
      general_direction: [:north, :east, :south, :west].sample
    }.merge configuration
    @configuration[:twist_factor] ||= 4 + rand(@configuration[:length] / 4)
    if @configuration[:bank]
      @configuration[:bank][:type] ||= :grass
    end
  end

  def create
    start_position = configuration[:start]
    position = start_position
    general_direction = configuration[:general_direction]
    direction = general_direction
    world.place_tile(position, :road)
    index = 0

    until end_of_road?(position, configuration)
      index += 1

      old_direction = direction
      direction = pick_direction(general_direction, direction) if (index % configuration[:twist_factor]) == 0

      if (old_direction != direction) and configuration[:bank]
        place_bank_around(position, direction)
        corner_position = move_direction(move_direction(position, old_direction), rotate_direction(direction, 180))
        world.place_tile!(corner_position, configuration[:bank][:type]) if rand > 0.2
      end

      new_position = move_direction(position, direction)
      unless in_bounds?(new_position, general_direction, start_position, configuration[:direction_bound])
        direction = general_direction
        new_position = move_direction(position, direction)
      end
      position = new_position

      place_bank_around position, direction

      world.place_tile!(position, :road)
    end
    configuration[:end] = position
    configuration[:end_direction] = direction
    self
  end

  attr_reader :configuration

  private
  def end_of_road?(position, configuration)
    if configuration[:length]
      distance_in_direction = movement_in_direction(configuration[:start], position, configuration[:general_direction])
      distance_in_direction >= configuration[:length]
    elsif configuration[:area_bound]
      # TODO: Test if current positon is within area
      #movement_in_direction(configuration[:start], position, configuration[:general_direction]) >= 20
      true
    end
  end

  def pick_bank_width
    {
      narrow: 1 + rand(3),
      wide: 2 + rand(4)
    }[configuration[:bank][:width]]
  end

  def place_bank_around(position, direction)
    return unless configuration[:bank]
    place_tiles(position, rotate_direction(direction, 90), pick_bank_width, configuration[:bank][:type])
    place_tiles(position, rotate_direction(direction, -90), pick_bank_width, configuration[:bank][:type])
  end

end
