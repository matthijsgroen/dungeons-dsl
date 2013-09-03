require_relative './special'

class Lightpost < Special

  def initialize world, configuration
    super
  end

  def create
    position = object.position_along(rand, [-90, 90].sample)
    world.place_decal!(position, nil, [:lamp_post])
  end

end
