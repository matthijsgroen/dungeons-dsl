
def world name, &block
  World.new.tap do |world|
    WorldDSL.new(world).instance_eval(&block)
  end
end

class WorldDSL

  def initialize(world)
    @world = world
    @objects = []
  end

  def there(object_description)
    @objects << object_description.create(world)
  end

  def is
    ObjectDescription.new
  end

  def to
    ObjectConnector.new @objects
  end

  private
  attr_reader :world
end

class World

  def initialize
    @tiles = []
    @decals = []
    @boundaries = nil
  end

  def place_tile(position, type)
    return if find_tile(position)
    tiles << { position: position, type: type }
    update_boundaries position
  end

  def place_tile!(position, type)
    clear_decal(position)
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

  DECAL_TYPES = {
    tree1: '^',
    tree2: '*',
    rock1: 'C',
    rock2: 'c',
    rock3: 'o'
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
        decal = find_decal([x, y])

        if decal
          line.concat DECAL_TYPES[decal[:type]]
        elsif tile
          line.concat TILE_TYPES[tile[:type]]
        else
          line.concat " "
        end
      end
      puts line
    end
  end

  def place_decal(position, ground_type, decal_type = nil)
    world_tile = find_tile(position)
    return unless world_tile
    return if world_tile[:type] != ground_type

    trees = [:tree1, :tree2]
    rocks = [:rock1, :rock2, :rock3]

    decal_type ||= case ground_type
                 when :grass then (trees + rocks).sample
                 end
    return unless decal_type

    decals << { position: position, type: decal_type }
  end

  private
  attr_reader :boundaries, :tiles, :decals

  def find_tile(position)
    tiles.find { |t| t[:position] == position }
  end

  def find_decal(position)
    decals.find { |t| t[:position] == position }
  end

  def clear_decal(position)
    decals.reject! { |t| t[:position] == position }
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
