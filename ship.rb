require_relative 'projectile'
#require_relative 'player'

class Ship
  attr_reader :angle, :vel_x, :vel_y, :x, :y, :projectiles

  def initialize
    @image = ''
    @propulsion_img = Gosu::Image.new('media\\propulsion.png')
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @projectiles = []
    @health = @max_health = 150
    @width = @height = 50

    @is_dead = false

    @prop_x = @prop_y = 0.0
    @prop_min = 20
    @prop_max = 35
    @prop_increase = 0.8
    @prop_calc = @prop_min

    @is_accelerate = false
  end

  def warp(x, y)
    @x = x
    @y = y
  end

  def take_damage(damage)
    @health -= damage
  end

  def shot
    @projectile.push(Projectile.new(@x, @y, @angle))
  end

  def turn_left
    @angle -= 3.5
  end

  def turn_right
    @angle += 3.5
  end

  def accelerate
    @vel_x += Gosu.offset_x(@angle, 0.3)
    @vel_y += Gosu.offset_y(@angle, 0.3)
    @vel_x *= 0.9909
    @vel_y *= 0.9909
  end

  def propulsion_calc
    if @is_accelerate
      @prop_calc += @prop_increase unless @prop_calc >= @prop_max
    else
      @prop_calc -= @prop_increase unless @prop_calc <= @prop_min
    end

    @prop_x = Utils.get_x_by_angle(@angle + 180, @prop_calc)
    @prop_y = Utils.get_y_by_angle(@angle + 180, @prop_calc)
  end

  def move
    @x += @vel_x
    @y += @vel_y

    @vel_x *= 0.99
    @vel_y *= 0.99
  end

  def collision_update
    @projectiles.each_with_index do |p, i|
      if p.border_collided == true
        # puts "#{p.class} Colidiu na borda..."
        @projectiles.delete_at(i)
        next
      end
      p.update
    end
  end

  def is_dead
    @is_dead = true if @health <= 0
  end

  def stunned

  end

  def update
    move
    propulsion_calc
    collision_update
    is_dead
  end

  def draw
    @propulsion_img.draw_rot(@x + @prop_x, @y + @prop_y, 1, @angle, 0.5, 0.5, 1.2, 1.2)
    @image.draw_rot(@x, @y, 1, @angle)
    @projectiles.each { |p| p.draw }
  end
end
