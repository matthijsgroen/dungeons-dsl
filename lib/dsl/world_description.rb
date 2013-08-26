require_relative './object_description'
require_relative './object_connector'

class WorldDescription

  def initialize(world)
    @world = world
    @objects = []
  end

  def there(object_description)
    @objects << object_description.create(world)
  end

  def is
    ObjectDescription.new
  end
  alias :are :is

  def the
    ObjectConnector.new @objects
  end

  private
  attr_reader :world
end

