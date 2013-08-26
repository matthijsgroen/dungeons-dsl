require_relative './object_finder'

class ObjectConnector < LanguageDescription

  include ObjectFinder

  configure :position, [:last, :first]
  chains :the, :of

  def initialize objects
    super()
    @objects = objects
    @nesting = []
  end

  def road
    nesting << capture_properties.merge(type: Road)
    reset_capture_properties
    self
  end

  def field
    nesting << capture_properties.merge(type: Field)
    reset_capture_properties
    self
  end

  def find
    find_object nesting
  end

  private
  attr_reader :objects, :nesting
end
