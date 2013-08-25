require './map_object'

class SpecialDescription < LanguageDescription

  chains :at, :the

  def initialize special_type, properties
    @properties = properties
    @special_type = special_type
  end

  def side(connector)
    object = connector.find
    @properties[:connected_to_side_of] = object
    self
  end

  def create(world)
    amount = 1
    if @properties[:amount]
      amount = case @properties[:amount]
               when :several then 2 + rand(3)
               end
    end
    amount.times do
      @special_type.create(world, @properties)
    end
  end
end

class Special < MapObject

  def initialize(world, configuration)
    super(world)
    @object = configuration[:connected_to_side_of]
  end

  protected
  attr_reader :object

end
