require_relative './special'

class Lightpost < Special

  def initialize world, configuration
    super
  end

  def create
    # TODO: Determine position along the road
    puts "creating #{self.class.name} along a #{object.class.name}"
    object.position_along(rand, [:left, :right].sample)
  end

end
