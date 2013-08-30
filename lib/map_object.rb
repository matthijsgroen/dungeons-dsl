require_relative './vector'
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
    case direction
    when :east then x += amount
    when :west then x -= amount
    when :south then y += amount
    when :north then y -= amount
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
      ([:north, :east, :south, :west] - [general_direction.opposite]).sample
    end
  end

  def in_bounds?(position, general_direction, start, limit)
    return true unless limit
    diff = movement_in_direction start, position, general_direction.rotate(90)
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
