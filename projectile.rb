require_relative 'utils'

class Projectile
    attr_reader :x, :y, :damage, :dead

    def initialize(x, y, angle)
        @image = Gosu::Image.new("media\\bullet.png")
        @speed_x = @speed_y = 0.0
        @x = x + Utils.get_x_by_angle(angle, 40)
        @y = y + Utils.get_y_by_angle(angle, 40)
        @angle = angle

        @damage = 15
        @dead = false
    end

    def draw
        @image.draw_rot(@x, @y, 2, @angle, 0.5, 0.5, 0.2, 0.2)
    end

    def is_dead
        if @x < -1000 or @x > WIDTH + 1000 or @y < -1000 or @y > HEIGHT + 1000
            @dead = true
        end
    end

    def update

        @speed_x += Gosu.offset_x(@angle, 1.3)
        @speed_y += Gosu.offset_y(@angle, 1.3)
        @x += @speed_x 
        @y += @speed_y 

        @speed_x *= 0.99
        @speed_y *= 0.99

    end
end
