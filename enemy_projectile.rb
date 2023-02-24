require_relative 'projectile'

class EnemyProjectiles < Projectile

    def initialize(x,y,angle)
        super(x, y, angle)
        @image = Gosu::Image.new("media\\enemy_bullet.png")
        @damage = 5
    end

    def draw
        @image.draw_rot(@x, @y, 2, @angle, 0.5, 0.5, 0.6, 0.6)
    end

    def update
        @speed_x += Gosu.offset_x(@angle, 0.8)
        @speed_y += Gosu.offset_y(@angle, 0.8)
        @x += @speed_x - $player.vel_x
        @y += @speed_y - $player.vel_y

        @speed_x *= 0.99
        @speed_y *= 0.99
    end
end
