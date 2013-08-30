
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

  def populate_with_decals density, field_type, allowed_decal_types
    return if allowed_decal_types.nil? or allowed_decal_types.empty?
    positions.each do |position|
      world.place_decal(position, field_type, allowed_decal_types) if rand < density
    end
  end

  def contains? position
    positions.include? position
  end

  def positions
    return @positions if @positions
    @positions = []
    @area.each_with_index do |part|
      start_point = part[:start]
      @positions << start_point
      part[:distance].times do |distance|
        @positions << move_direction(start_point, part[:direction], distance)
      end
    end
    @positions.uniq!
    @positions
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
    side_a = direction.rotate 90
    side_b = direction.rotate(-90)

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
