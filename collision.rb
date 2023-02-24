
class Collision

  def self.border_collision(x, y)
    return true if x > WIDTH + 1000 || x < -1000 || y > HEIGHT + 1000 || y < -1000
  end
end
