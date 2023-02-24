require_relative 'projectile'
class Missile < Projectile
    def initialize(x, y, angle, right)
        @image = Gosu::Image.new("media\\beam.png")
        @speed_x = @speed_y = 0.0
        @right = right
        @x = x
        @y = y
        if @right
            @x_wing = Utils.get_x_by_angle(angle + 90, 30)
            @y_wing = Utils.get_y_by_angle(angle + 90, 30)
        else
            @x_wing = Utils.get_x_by_angle(angle - 90, 30)
            @y_wing = Utils.get_y_by_angle(angle - 90, 30)
        end
        @x += @x_wing
        @y += @y_wing

        @angle = angle

        @damage = 30
    end

    def update
        @speed_x += Gosu.offset_x(@angle, 0.5)
        @speed_y += Gosu.offset_y(@angle, 0.5)
        @x += @speed_x - $player.vel_x/3
        @y += @speed_y - $player.vel_y/3

        @speed_x *= 1.02
        @speed_y *= 1.02

    end

    def draw
        @image.draw_rot(@x, @y, 0, @angle, 0.5, 0.5, 0.18, 0.18)
    end

end
