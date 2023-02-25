require 'gosu'
require_relative 'projectile'
require_relative 'collision'
require_relative 'missile'
require_relative 'utils'
require_relative 'ship'
require_relative 'enemy'

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
        super
        Gosu.draw_rect(@x - @max_health/2+@max_health/3, @y + @height/2 + 10 , @max_health/3, 10, Gosu::Color::GRAY, 2)
        Gosu.draw_rect(@x - @health/2 +@health/3, @y + @height/2 + 10 , @health/3, 10, Gosu::Color::GREEN, 2)
    end

    def controller
        turn_left if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
        turn_right if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
        accelerate if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
        shot if Gosu.button_down? Gosu::KB_SPACE and @shot_cooldown <= 0
    end

    def collision_update
        @projectiles.each_with_index do |p, i|
            if p.border_collided == true
                #puts "#{p.class} Colidiu na borda..."
                @projectiles.delete_at(i)
                next
            end

            $asteroids.each do |a|
                if Collision.colliding_obj?(p, a)
                    a.take_damage(p.damage)
                    @projectiles.delete(p)
                end
            end

            $enemies.each do |e|
                if Collision.colliding_obj?(p, e)
                    e.take_damage(p.damage)
                    @projectiles.delete(p)
                end
            end
            p.update
        end
      end

    def update
        super
        @has_accelerated = false

        #is_colliding_with_asteroid

        controller

        @shot_cooldown -= 1
        @missile_cooldown -= 1
    end
end
