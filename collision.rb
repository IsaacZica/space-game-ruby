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

  def self.colliding_obj?(object_a, object_b)
    x_dif = (object_a.x - object_b.x).abs
    y_dif = (object_a.y - object_b.y).abs
    size_x = object_b.width / 2
    size_y = object_b.height / 2
    return true if x_dif < size_x && y_dif < size_y
  end
end
