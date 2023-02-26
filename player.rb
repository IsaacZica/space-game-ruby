require 'gosu'
require_relative 'projectile'
require_relative 'missile'
require_relative 'utils'
require_relative 'ship'

class Player < Ship
    attr_reader :x, :y, :projectiles
    attr_accessor :score

    def initialize
        super
        @image = Gosu::Image.new("media\\starfighter.bmp")

        @upgrade = 0
        @amount = 0
        @shot_cooldown = 0
        @missile_cooldown = 0

        @x = @y = 0.0

        @health = @max_health = 200
        @score = 0

        @has_accelerated = false
    end

    def shot
        @shot_cooldown = 10
        for i in 0..@amount do
            @projectiles.push(Projectile.new(@x, @y, @angle + rand(-4+i..4+i)))
        end
        if @missile_cooldown <= 0
            @projectiles.push(Missile.new(@x, @y, @angle, true))
            @projectiles.push(Missile.new(@x, @y, @angle, false))
            @missile_cooldown = 120
        end

    end

    def warp (x,y)
        @x, @y = x, y
    end

    def turn_left
        @angle -= 3.5
        @angle += 360 if @angle < 0
    end

    def turn_right
        @angle += 3.5
        @angle -= 360 if @angle >= 360
    end

    def accelerate
        @vel_x += Gosu.offset_x(@angle, 0.2)
        @vel_y += Gosu.offset_y(@angle, 0.2)
        @vel_x *= 0.9909
        @vel_y *= 0.9909

        @vel_y = 20 if @vel_y > 20
        @vel_y = -20 if @vel_y < -20
        @vel_x = 35 if @vel_x > 35
        @vel_x = -35 if @vel_x < -35
        @has_accelerated = true
    end

    def move
        @x += @vel_x
        @y += @vel_y

        unless @has_accelerated
            @vel_x *= 0.980009
            @vel_y *= 0.980009
        end

        @x = WIDTH/2 - vel_x*9
        @y = HEIGHT/2 - vel_y*9
    end

    def draw
        @image.draw_rot(@x, @y, 2, @angle)
        Gosu.draw_rect(@x - @max_health/2+@max_health/3, @y + @height/2 + 10 , @max_health/3, 10, Gosu::Color::GRAY, 2)
        Gosu.draw_rect(@x - @health/2 +@health/3, @y + @height/2 + 10 , @health/3, 10, Gosu::Color::GREEN, 2)

        @projectiles.each do |p|
            p.draw
        end
    end

    def controller
        turn_left if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT and !@stunned
        turn_right if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT and !@stunned
        accelerate if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0 and !@stunned
        shot if Gosu.button_down? Gosu::KB_SPACE and @shot_cooldown <= 0 and !@stunned
    end

    def update
        # ...
        @has_accelerated = false

        #is_colliding_with_asteroid


        controller
        move
        @shot_cooldown -= 1
        @missile_cooldown -= 1
        if @stunned
            turn_right
            @stun_time -= 1
            @stunned = false if @stun_time <= 0
        end

        @projectiles.each do |p|
            @projectiles.delete(p) if p.is_dead
            p.update

            $asteroids.each do |a|
                if Utils.is_colliding(p.x,p.y,a.x,a.y,a.width/2,a.height/2)
                    a.take_damage(p.damage)
                    @projectiles.delete(p)
                end
            end
            $enemies.each do |e|
                if Utils.is_colliding(p.x,p.y,e.x,e.y,e.width/2,e.height/2)
                    e.take_damage(p.damage)
                    @projectiles.delete(p)
                end
            end
        end
    end
end
