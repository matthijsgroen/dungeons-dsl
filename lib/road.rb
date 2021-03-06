require_relative './map_object'

class Road < MapObject

  def initialize world, configuration
    super(world)
    @configuration = {
      start: [rand(500), rand(500)],
      length: 10 + rand(30),
      general_direction: Direction.pick
    }.merge configuration
    @configuration[:twist_factor] ||= 2 + rand((3 + (@configuration[:length] || 5)) / 3)
    if @configuration[:bank]
      @configuration[:bank][:type] ||= :grass
    end
    @vectors = []
  end

  def create
    start_position = configuration[:start]
    position = start_position
    general_direction = configuration[:general_direction]
    direction = general_direction

    add_position(position, direction)
    index = 0

    until end_of_road?(position, configuration)
      index += 1

      old_direction = direction
      direction = pick_direction(general_direction, direction) if (index % configuration[:twist_factor]) == 0

      if (old_direction != direction) and configuration[:bank]
        place_bank_around(position, direction)
        corner_position = move_direction(move_direction(position, old_direction), direction.opposite)
        world.place_tile!(corner_position, configuration[:bank][:type]) if rand > 0.2
      end

      new_position = move_direction(position, direction)
      unless in_bounds?(new_position, general_direction, start_position, configuration[:direction_bound])
        direction = general_direction
        new_position = move_direction(position, direction)
      end
      position = new_position

      place_bank_around position, direction

      add_position(position, direction)
    end

    place_road

    configuration[:end] = position
    configuration[:end_direction] = direction
    self
  end

  def position_along(percentage, side_of_road)
    vector = vectors[(vectors.length * percentage).round]
    move_direction(vector[:position], vector[:direction].rotate(side_of_road))
  end

  attr_reader :configuration

  private
  attr_reader :vectors

  def add_position(position, direction)
    vectors << { position: position, direction: direction }
  end

  def place_road
    vectors.each do |vector|
      world.place_tile!(vector[:position], :road)
    end
  end

  def end_of_road?(position, configuration)
    if configuration[:length]
      distance_in_direction = movement_in_direction(configuration[:start], position, configuration[:general_direction])
      distance_in_direction >= configuration[:length]
    elsif area = configuration[:area_bound]
      !area.contains? position
    end
  end

  def pick_bank_width
    {
      narrow: 2 + rand(2),
      wide: 4 + rand(4)
    }[configuration[:bank][:width]]
  end

  def place_bank_around(position, direction)
    return unless configuration[:bank]
    bank_type = configuration[:bank][:type]
    decal_types = configuration[:bank][:decals] || []

    bank_width1 = pick_bank_width
    dir1 = direction.rotate 90
    place_tiles(position, dir1, bank_width1, bank_type)
    world.place_decal(move_direction(position, dir1, 1 + rand(bank_width1 - 1)), bank_type, decal_types) if rand < 0.2

    bank_width2 = pick_bank_width
    dir2 = direction.rotate(-90)
    place_tiles(position, dir2, bank_width2, bank_type)
    world.place_decal(move_direction(position, dir2, 1 + rand(bank_width2 - 1)), bank_type, decal_types) if rand < 0.2
  end

end
