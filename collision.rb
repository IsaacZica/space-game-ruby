BORDER_RANGE = 1500

class Collision
  def self.border_collision?(x, y, start_x, start_y)
    return true if (x - start_x).abs > BORDER_RANGE || (y - start_y).abs > BORDER_RANGE
  end

  def self.colliding?(x1, y1, x2, y2, col_size_x, col_size_y)
    x_dif = (x1 - x2).abs
    y_dif = (y1 - y2).abs
    return true if x_dif < col_size_x && y_dif < col_size_y
  end
end
