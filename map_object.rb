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

  def place_tiles(position, direction, amount, type)
    amount.times do |index|
      world.place_tile(move_direction(position, direction, index), type)
    end
  end

end
