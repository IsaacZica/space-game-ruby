require_relative 'utils'
require_relative 'enemy_projectile'
require_relative 'ship'

MAX_ENEMIES = 2
class Enemy < Ship
    attr_reader :x, :y, :height, :width, :dead
    def initialize
        super
        @upgrade = 0
        @amount = 0
        @fire_rate = 60
        @shot_cooldown = 0
        @image = Gosu::Image.new("media\\starfighter.bmp")

        @x = $player.x + rand(-1000..1000)
        @y =  $player.y + rand(-1000..1000)
        @has_accelerated = false

        @font = Gosu::Font.new(20)

        #array enemies
        #array enemy_projectiles

        @y_dif = @x_dif = 0.0
        @mul = 0
        @right_side = (rand(2) == 1 ? true : false)
        @switch_time = 300

        @health = @max_health = 70
    end

    def shot
        @shot_cooldown = 15
        for i in 0..@amount do
            @projectiles.push(EnemyProjectiles.new(@x+@vel_x, @y+@vel_y, @angle + rand(-4+i..4+i)))
        end
    end

    def warp (screen_x,screen_y)
        @screen_x, @screen_y = screen_x,screen_y
    end

    def turn_left
        @angle -= 1.5 * @mul
        @angle += 360 if @angle < 0
    end

    def turn_right
        @angle += 1.5 * @mul
        @angle -= 360 if @angle >= 360
    end

    def accelerate
        @vel_x += Gosu.offset_x(@angle, 0.15)
        @vel_y += Gosu.offset_y(@angle, 0.15)
        @has_accelerated = true
    end

    def move
        @x += @vel_x - $player.vel_x
        @y += @vel_y - $player.vel_y

        if @has_accelerated
            @vel_x *= 0.9909
            @vel_y *= 0.9909
            @vel_y = 10 if @vel_y > 10
            @vel_y = -10 if @vel_y < -10
            @vel_x = 15 if @vel_x > 15
            @vel_x = -15 if @vel_x < -15
        else
            @vel_x *= 0.980009
            @vel_y *= 0.980009
        end
    end

    def draw
        @image.draw_rot(@x, @y, 2, @angle)
        Gosu.draw_rect(@x - @max_health/2, @y + @height/2 + 10 , @max_health, 10, Gosu::Color::GRAY, 2)
        Gosu.draw_rect(@x - @health/2, @y + @height/2 + 10 , @health, 10, Gosu::Color::RED, 2)

        @projectiles.each do |p|
            p.draw
        end
    end
    def update_angles
        @calc_angle = -(Math.atan2(@x - $player.x, @y - $player.y))*180 /Math::PI
        @calc_angle += 360 if @calc_angle <0
    end

    def update
        # ...
        super

        has_turned = false
        @mul = 1
        update_angles
        hyp = Math.hypot(@x - $player.x, @y - $player.y)
        if hyp > 455
            accelerate
            @mul = 1.5
        else
            @mul = 3.5

            ran = (@calc_angle-70.0..@calc_angle+70.0)
            if ran.include?(@angle)
                @vel_x *=0.975
                @vel_y *=0.975
                if @right_side
                    turn_right
                else
                    turn_left
                end
            end
            accelerate
            has_turned = true
        end

        if @calc_angle > 180 && @angle < 180 && has_turned == false
            turn_left

        elsif has_turned == false
            turn_right if @angle < @calc_angle
            turn_left if @angle > @calc_angle
        end

        range = (@calc_angle-10..@calc_angle+10)
        if range.include?(@angle)
            shot if @shot_cooldown <= 0
        end

        #move
        @shot_cooldown -= 1

        @projectiles.each do |p|
            if p.border_collided
                @projectiles.delete(p)
                next
            end

            p.update

            if Utils.is_colliding(p.x, p.y, $player.x, $player.y, 25, 25)
                $player.take_damage(p.damage)
                @projectiles.delete(p)
            end
            $asteroids.each do |a|
                if Utils.is_colliding(p.x, p.y, a.x, a.y, a.width / 2, a.height / 2)
                    a.take_damage(p.damage)
                    @projectiles.delete(p)
                end
            end
        end
    end
end
