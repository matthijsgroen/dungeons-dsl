require_relative './direction'

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
    delta = amount * direction.factor
    if direction.vertical?
      y += delta
    else
      x += delta
    end
    [x, y]
  end

  def place_tiles(position, direction, amount, type)
    amount.times do |index|
      world.place_tile(move_direction(position, direction, index), type)
    end
  end

  def pick_direction(general_direction = nil, direction = nil)
    if direction
      suggested_direction = direction.rotate [0, 90, -90].sample
      if suggested_direction == general_direction.opposite
        general_direction
      else
        suggested_direction
      end
    else
      Direction.pick_except general_direction.opposite
    end
  end

  def in_bounds?(position, general_direction, start, limit)
    return true unless limit
    diff = movement_in_direction(start, position, general_direction.rotate(90))
    diff.abs < limit
  end

  def movement_in_direction(position1, position2, direction)
    x1, y1 = position1
    x2, y2 = position2
    if direction.vertical?
     (y2 - y1) * direction.factor
    else
     (x2 - x1) * direction.factor
    end
  end
end
