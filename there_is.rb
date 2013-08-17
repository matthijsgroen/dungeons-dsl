require './world'

def there
  MapItemCreator.new world
end

class MapItemCreator

  def initialize world
    @world = world
    @configuration = {}
  end

  def is
    self
  end

  def a
    self
  end

  def short
    @configuration[:length] = 5 + rand(10)
    self
  end

  def long
    @configuration[:length] = 25 + rand(20)
    self
  end

  def road
    Road.new(@world, @configuration)
  end

end

class Road

  def initialize world, configuration
    @world = world
    @configuration = {
      start: [rand(500), rand(500)],
      length: 10 + rand(30),
      vertical_direction: [1, -1].sample,
      horizontal_direction: [1, -1].sample
    }.merge configuration
    @configuration[:twist_factor] ||= 1 + rand(@configuration[:length])
    draw_road
  end

  private
  attr_reader :world, :configuration
  def draw_road
    x = configuration[:start][0]
    y = configuration[:start][1]
    direction = [:x, :y].sample
    world.place_tile(x, y, :road)
    configuration[:length].times do |index|
      if direction == :x
        x += configuration[:horizontal_direction]
      else
        y += configuration[:vertical_direction]
      end
      direction = [:x, :y].sample if index % configuration[:twist_factor] == 0

      world.place_tile(x, y, :road)
    end
  end

end
