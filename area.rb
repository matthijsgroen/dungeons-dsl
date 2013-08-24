
class Area < MapObject

  def initialize world, start_position, size, direction
    super(world)
    @area = []
    define_space start_position, size, direction
    @direction, @start_position, @size = direction, start_position, size
  end

  def fill field_type
    @area.each do |part|
      place_tiles(part[:start], part[:direction], part[:distance], field_type)
    end
  end

  def contains? position
    @area.each_with_index do |part|
      start_point = part[:start]
      end_point = move_direction(start_point, part[:direction], part[:distance])

      return true if between_points? start_point, end_point, position
    end
    false
  end

  private
  attr_reader :direction

  def between_points? start_point, end_point, position
    [0, 1].each do |axis|
      range = [start_point[axis], end_point[axis]]
      return false unless (range.min .. range.max).include? position[axis]
    end
    true
  end

  def define_space start_position, size, direction
    side_a = rotate_direction(direction, 90)
    side_b = rotate_direction(direction, -90)

    size.times.each do |index|
      pos = move_direction(start_position, direction, 1 + index)
      base = (size/2) - (index - (size/2)).abs + 1

      length_a = base + rand(size/4)
      start = move_direction(pos, side_a, length_a)
      length_b = base + rand(size/4)

      @area << { start: start, direction: side_b, distance: length_a + length_b }
    end
  end

end
