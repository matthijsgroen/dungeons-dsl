
class LanguageDescription

  def initialize
    @capture_properties = {}
  end

  class << self

    def chains(*words)
      words.each do |word|
        define_method(word) do
          self
        end
      end
    end

    def configure(property, values)
      values.each do |value|
        define_method(value) do
          capture_properties[property] = value
          self
        end
      end
    end
  end

  chains :a, :an, :with

  protected
  attr_reader :capture_properties

end
