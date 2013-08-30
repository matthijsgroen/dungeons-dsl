require_relative './direction'

class Vector

  def initialize position, direction, amount = 1
    @position, @direction, @amount = position, direction, amount
  end

  def move amount = 1
    x, y = *position
    case direction.name
    when :east then x += amount
    when :west then x -= amount
    when :south then y += amount
    when :north then y -= amount
    end
    self.class.new [x, y], direction
  end

  def rotate(degrees)
    change_direction direction.rotate(degrees)
  end

  def change_direction(new_direction)
    self.class.new position, new_direction
  end

  def opposite
    change_direction direction.opposite
  end

  attr_reader :position, :direction
end

