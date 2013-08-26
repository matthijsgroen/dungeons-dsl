
class LanguageDescription

  def initialize
    @capture_properties = {}
    @words_used = []
  end

  class << self
    def chains(*words)
      words.each do |word|
        define_method(word) do |*args|
          add_word_used word, args
          self
        end
      end
    end

    def configure(property, values)
      values.each do |value|
        define_method(value) do
          add_word_used(value, value)
          capture_properties[property] = value
          self
        end
      end
    end

    def collect(property, values)
      values.each do |value|
        define_method(value) do
          add_word_used(value, value)
          capture_properties[property] ||= []
          capture_properties[property] << value
          self
        end
      end
    end

    def word_chain(*links)
      links.each do |link|
        words = link.to_s.split('_')

        word_chains << words
        chains(*words)
      end
    end

    def word_chains
      @word_chains ||= []
    end

  end

  chains :a, :an, :with

  protected
  attr_reader :capture_properties, :words_used

  def reset_capture_properties
    @capture_properties = {}
  end

  private

  def add_word_used(word, args)
    words_used << word

    self.class.word_chains.each do |chain|
      last_words_used = words_used[-chain.length, chain.length]
      send(chain.join('_').to_sym, *args) if last_words_used == chain
    end

  end

end
