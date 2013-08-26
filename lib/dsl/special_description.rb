require_relative './language_description'

class SpecialDescription < LanguageDescription

  word_chain :at_the_side_of

  def initialize special_type, properties
    super()
    @properties = properties
    @special_type = special_type
  end

  def at_the_side_of(connector)
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
