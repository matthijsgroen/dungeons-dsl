
def world
  @world ||= World.new
end

class World

  def initialize
    @tiles = []
    @boundaries = nil
  end

  def place_tile(x, y, type)
    tiles << { x: x, y: y, type: type }
    update_boundaries x, y
  end

  TILE_TYPES = {
    road: '#'
  }

  def render
    unless boundaries
      puts 'The world is empty'
      return
    end

    for y in boundaries[:top]..boundaries[:bottom]
      line = ""
      for x in boundaries[:left]..boundaries[:right]
        tile = tiles.find { |t| t[:x] == x && t[:y] == y }

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

  def update_boundaries x, y
    @boundaries = { top: y, bottom: y, left: x, right: x } unless boundaries
    boundaries[:left] = [x, boundaries[:left]].min
    boundaries[:right] = [x, boundaries[:right]].max
    boundaries[:top] = [y, boundaries[:top]].min
    boundaries[:bottom] = [y, boundaries[:bottom]].max
  end
end
