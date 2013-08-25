
class Lightpost < Special

  def initialize world, configuration
    super
  end

  def create
    # TODO: Determine position along the road
    puts "creating #{self.class.name} along a #{object.class.name}"
  end

end
