
class Direction

  CARDINAL_DIRECTIONS = [:north, :east, :south, :west]

  def self.pick
    new CARDINAL_DIRECTIONS.sample
  end

  def self.pick_except(directions)
    directions_taken = [directions].flatten.map(&:name)
    new (CARDINAL_DIRECTIONS - directions_taken).sample
  end

  def initialize(name)
    @name = name
  end

  def rotate(degrees)
    start = CARDINAL_DIRECTIONS.index name
    compass = {
      0 => CARDINAL_DIRECTIONS[start],
      90 => CARDINAL_DIRECTIONS[(start + 1) % 4],
      180 => CARDINAL_DIRECTIONS[(start + 2) % 4],
      270 => CARDINAL_DIRECTIONS[(start + 3) % 4]
    }

    self.class.new compass[(360 + degrees) % 360]
  end

  def opposite
    rotate(180)
  end

  def == other
    self.name == other.name
  end

  def factor
    case name
    when :north, :west then -1
    when :south, :east then 1
    end
  end

  def vertical?
    case name
    when :north, :south then true
    else false
    end
  end

  def horizontal?
    !vertical?
  end

  attr_reader :name
  def to_s; name.to_s; end
  def inspect; "<#{self.class.name} #{to_s}>"; end

end
