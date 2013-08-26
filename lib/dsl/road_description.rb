require_relative './language_description'
require_relative '../road'

class RoadDescription < LanguageDescription

  configure :width, [:wide, :narrow]
  collect :decals, [:trees, :rocks]
  chains :in, :and

  word_chain :connected_to

  def initialize(properties)
    @properties = convert_properties properties
    super()
  end

  def create(world)
    Road.create(world, @properties)
  end

  def connected_to(connector)
    object = connector.find
    @properties[:start] = object.configuration[:end]
    @properties[:general_direction] = object.configuration[:end_direction]
    self
  end

  def bank
    @properties[:bank] = {
      width: :narrow
    }.merge capture_properties
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

