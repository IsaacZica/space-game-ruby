require_relative 'utils'
ASTEROID_VARIATION = 24
MAX_ASTEROIDS = 8
MAX_SPEED = 5

class Asteroid
    attr_accessor :health, :dead, :x, :y, :width, :height, :vel_x, :vel_y
       
     def initialize(id)
        @big_asteroids = Gosu::Image.load_tiles('media\\big_asteroids.png', 125, 125)
        @mid_asteroids = Gosu::Image.load_tiles('media\\mid_asteroids.png', 85, 85)
        @small_asteroids = Gosu::Image.load_tiles('media\\small_asteroids.png', 48, 48)
        @asteroids = @big_asteroids + @mid_asteroids + @small_asteroids
        @center_x = WIDTH / 2
        @center_y = HEIGHT / 2
        @angle = rand(360)
        @raio = WIDTH * 2.6
        @x = @center_x + Utils.get_x_by_angle(@angle, @raio)
        @y =  @center_y + Utils.get_y_by_angle(@angle, @raio)
        @id = id
        @rotation = 0.0
        @color = Gosu::Color::YELLOW
        @dot = @x * @center_x + @y * @center_y
        @det = @center_x * @y - @center_y * @x
        @speed_variability = rand(3.0..4.0)
        #@angle = Math.atan2(@det, @dot) * 180 / Math::PI


        @vel_x = 0
        @vel_y = 0
        
        @orientation = 0.0
        @dead = false
        @rot_speed = rand(-5..5)
        @rot_speed += 1 if @rot_speed == 0

        if @id <= 7
            size = 125 
            @health = @max_health = 100
        elsif @id <= 15
            size =  85 
            @health = @max_health = 40
        else
            size = 48 
            @health = @max_health= 10
        end

        @width = @height = size
       
    end

    def is_dead
        if @health <= 0
            @dead = true
            $player.score = $player.score + 25 
        end
    end

    def is_colliding_with_something
        $asteroids.each do |a|
            if Utils.is_colliding(@x, @y, $player.x, $player.y, ($player.width + @width)/2, ($player.height + @height)/2)
                $player.stun
            end

            if Utils.is_colliding(@x,@y,a.x,a.y,a.width/2 + @width/2, a.height/2 + @height/2)
                if self != a
                    if @vel_x >= a.vel_x
                        a.vel_x = @vel_x
                        @vel_x *= -1
                    else
                        @vel_x = a.vel_x
                        a.vel_x *= -1
                    end

                    if @vel_y >= a.vel_y
                        a.vel_y = @vel_y
                        @vel_y *= -1
                    else
                        @vel_y = a.vel_y
                        a.vel_y *= -1
                    end
                end
            end

            $enemies.each do |e|
                if Utils.is_colliding(e.x,e.y,@x,@y,@width,@height)
                    
                end
            end
        end
        return false
    end

    def update
        is_colliding_with_something
        @orientation += @rot_speed
        is_dead
        @vel_x -= Gosu.offset_x(@angle, 0.1) if @vel_x.abs < (MAX_SPEED - @speed_variability)
        @vel_y -= Gosu.offset_y(@angle, 0.1) if @vel_y.abs < (MAX_SPEED - @speed_variability) 

        @x += @vel_x - $player.vel_x
        @y += @vel_y - $player.vel_y
        
        @dead = true if (@x %= WIDTH * 1.5) == 0
        @dead = true if (@y %= HEIGHT * 1.5) == 0

        
    end

    def take_damage(damage)
        @health -= damage
    end

    def draw
        @asteroids[@id].draw_rot(@x, @y, 2, @orientation)
        Gosu.draw_rect(@x - @max_health/2, @y + @height/2 + 10 , @max_health, 10, Gosu::Color::GRAY, 2)
        Gosu.draw_rect(@x - @health/2, @y + @height/2 + 10 , @health, 10, Gosu::Color::RED, 2)
    end
end
