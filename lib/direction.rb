
class Symbol

  def rotate(degrees)
    directions = [:east, :south, :west, :north]
    start = directions.index self
    compass = {
      0 => directions[start],
      90 => directions[(start + 1) % 4],
      180 => directions[(start + 2) % 4],
      270 => directions[(start + 3) % 4]
    }

    compass[(360 + degrees) % 360]
  end

  def opposite
    rotate(180)
  end

end
