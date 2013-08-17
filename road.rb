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

  def bank
    @properties[:bank] = {
      width: :small
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
      vertical_direction: [:south, :north].sample,
      horizontal_direction: [:east, :west].sample
    }.merge configuration
    @configuration[:twist_factor] ||= 1 + rand(@configuration[:length])
  end

  def create
    position = configuration[:start]
    direction = pick_direction
    world.place_tile(position, :road)

    configuration[:length].times do |index|
      old_direction = direction
      direction = pick_direction if index % configuration[:twist_factor] == 0

      if old_direction != direction
        place_bank_around(position, direction)

        corner_position = move_direction(move_direction(position, old_direction), rotate_direction(direction, 180))
        world.place_tile!(corner_position, :bank) if rand > 0.2
      end

      position = move_direction(position, direction)

      place_bank_around position, direction

      world.place_tile!(position, :road)
    end
    configuration[:end] = position
    configuration[:end_direction] = direction
    self
  end

  attr_reader :configuration

  private
  def pick_direction
    [
      configuration[:vertical_direction],
      configuration[:horizontal_direction]
    ].sample
  end

  def pick_bank_width
    {
      small: rand(3),
      wide: 2 + rand(4)
    }[configuration[:bank][:width]]
  end

  def place_bank_around(position, direction)
    return unless configuration[:bank]
    place_tiles(position, rotate_direction(direction, 90), pick_bank_width, :bank)
    place_tiles(position, rotate_direction(direction, -90), pick_bank_width, :bank)
  end

end
