require_relative '../lib/direction'

describe Direction do

  describe '.pick' do
    it 'instantiates with a random direction' do
      described_class.pick.should be_a Direction
    end
  end

  describe '.pick_except' do
    it 'does not point to the provided direction' do
      direction = described_class.new :east
      result = described_class.pick_except direction
      result.name.should_not eql direction.name
    end
  end

end

