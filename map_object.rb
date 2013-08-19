class MapObject

  def self.create(world, configuration)
    new(world, configuration).create
  end

  def initialize(world)
    @world = world
  end

  protected
  attr_reader :world

  def move_direction position, direction, amount = 1
    x, y = *position
    case direction
    when :east then x += amount
    when :west then x -= amount
    when :south then y += amount
    when :north then y -= amount
    end
    [x, y]
  end

  def rotate_direction(direction, degrees)
    directions = [:east, :south, :west, :north]
    start = directions.index direction
    compass = {
      0 => directions[start],
      90 => directions[(start + 1) % 4],
      180 => directions[(start + 2) % 4],
      270 => directions[(start + 3) % 4]
    }

    compass[(360 + degrees) % 360]
  end

  def opposite_direction direction
    return nil unless direction
    rotate_direction(direction, 180)
  end

  def place_tiles(position, direction, amount, type)
    amount.times do |index|
      world.place_tile(move_direction(position, direction, index), type)
    end
  end

  def pick_direction(general_direction = nil, direction = nil)
    if direction
      suggested_direction = rotate_direction(direction, [0, 90, -90].sample)
      if suggested_direction == opposite_direction(general_direction)
        general_direction
      else
        suggested_direction
      end
    else
      ([:north, :east, :south, :west] - [opposite_direction(general_direction)]).sample
    end
  end

  def in_bounds?(position, general_direction, start, limit)
    return true unless limit
    diff = movement_in_direction start, position, rotate_direction(general_direction, 90)
    diff.abs < limit
  end

  def movement_in_direction(position1, position2, direction)
    factor = case direction
             when :north, :west then 1
             when :south, :east then -1
             end
    case direction
    when :north, :south then (position1[1] - position2[1]) * factor
    when :west, :east then (position1[0] - position2[0]) * factor
    end
  end
end
