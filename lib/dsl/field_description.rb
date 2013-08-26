require_relative '../field'

class FieldDescription < LanguageDescription

  chains :across, :and
  configure :road_type, [:forked]
  configure :field_type, [:rock, :grass]
  collect :decals, [:rocks, :trees]

  word_chain :connected_to

  def initialize(properties)
    @properties = convert_properties properties
    super()
  end

  def connected_to(connector)
    object = connector.find
    @properties[:start_position] = object.configuration[:end]
    @properties[:start_direction] = object.configuration[:end_direction]
    self
  end

  def road
    @properties[:road] = true
    self
  end

  def create(world)
    Field.create(world, @properties.merge(@capture_properties))
  end

  private
  def convert_properties properties
    p = {}
    p[:size] = 6 + rand(10) if properties[:size] == :small
    p[:size] = 15 + rand(20) if properties[:size] == :large
    p[:field_type] = properties[:terrain_type]
    p
  end
end
