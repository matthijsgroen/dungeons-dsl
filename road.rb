class RoadDescription < LanguageDescription

  def initialize(properties)
    @properties = convert_properties properties
    @capture_properties = {}
  end

  def create(world)
    Road.create(world, @properties)
  end

  def bank
    @properties[:bank] = @capture_properties
    @capture_properties = {}
    self
  end

  private

  def convert_properties properties
    p = {}
    p[:length] = 5 + rand(10) if properties[:length] == :short
    p[:length] = 25 + rand(20) if properties[:length] == :long
    p
  end
end

class Road

  def self.create(world, configuration)
    new(world, configuration).create
  end

  def initialize world, configuration
    @world = world
    @configuration = {
      start: [rand(500), rand(500)],
      length: 10 + rand(30),
      vertical_direction: [1, -1].sample,
      horizontal_direction: [1, -1].sample
    }.merge configuration
    @configuration[:twist_factor] ||= 1 + rand(@configuration[:length])
  end

  def surrounded
    self
  end

  def by
    self
  end

  def a
    self
  end

  def bank
    puts "Create a bank with properties captured"
  end

  def create
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

  private
  attr_reader :world, :configuration

end
