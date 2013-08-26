require './map_object'

class Special < MapObject

  def initialize(world, configuration)
    super(world)
    @object = configuration[:connected_to_side_of]
  end

  protected
  attr_reader :object

end
