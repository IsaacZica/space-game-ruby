require_relative 'utils'
require_relative 'collision'

class Projectile
  attr_reader :x, :y, :damage, :dead, :border_collided

  def initialize(x, y, angle)
    @image = Gosu::Image.new('media\\bullet.png')
    @speed_x = @speed_y = 0.0
    @x = x + Utils.get_x_by_angle(angle, 40)
    @y = y + Utils.get_y_by_angle(angle, 40)
    @start_x, @start_y = @x, @y
    @angle = angle

    @damage = 15
    @border_collided = false
  end

  def update
    @speed_x += Gosu.offset_x(@angle, 1.3)
    @speed_y += Gosu.offset_y(@angle, 1.3)
    @x += @speed_x
    @y += @speed_y

    @speed_x *= 0.99
    @speed_y *= 0.99

    @border_collided = Collision.border_collision?(@x, @y, @start_x, @start_y)
  end

  def draw
    @image.draw_rot(@x, @y, 2, @angle, 0.5, 0.5, 0.2, 0.2)
  end
end
