
def world
  @world ||= World.new
end

class World

  def initialize
    @tiles = []
    @boundaries = nil
  end

  def place_tile(position, type)
    return if find_tile(position)
    tiles << { position: position, type: type }
    update_boundaries position
  end

  def place_tile!(position, type)
    if tile = find_tile(position)
      tile[:type] = type
    else
      tiles << { position: position, type: type }
    end
    update_boundaries position
  end

  TILE_TYPES = {
    road: '#',
    grass: '.',
    rock: ';',
    marker: '$'
  }

  def render
    unless boundaries
      puts 'The world is empty'
      return
    end

    for y in boundaries[:top]..boundaries[:bottom]
      line = ""
      for x in boundaries[:left]..boundaries[:right]
        tile = find_tile([x, y])

        if tile
          line.concat TILE_TYPES[tile[:type]]
        else
          line.concat " "
        end
      end
      puts line
    end
  end

  private

  attr_reader :boundaries, :tiles
  def find_tile(position)
    tiles.find { |t| t[:position] == position }
  end

  def update_boundaries position
    x, y = *position
    @boundaries = { top: y, bottom: y, left: x, right: x } unless boundaries
    boundaries[:left] = [x, boundaries[:left]].min
    boundaries[:right] = [x, boundaries[:right]].max
    boundaries[:top] = [y, boundaries[:top]].min
    boundaries[:bottom] = [y, boundaries[:bottom]].max
  end
end
