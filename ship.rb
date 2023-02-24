require_relative 'projectile'

class Ship
  attr_reader :angle, :vel_x, :vel_y, :x, :y

  def initialize
    @x = 0.0
    @y = 0.0
    @vel_x = 0.0
    @vel_y = 0.0
    @angle = 0.0
    @projectiles = []
    @health = @max_health = 150
    @width = @height = 50
    @dead = false
  end

  def warp(x, y)
    @x = x
    @y = y
  end

  def take_damage(damage)
    @health -= damage
  end

  def shot
    @projectile.push(Projectile.new(@x + @vel_x, @y + @vel_y, @angle))
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

  def move
    @x += @vel_x
    @y += @vel_y

    @vel_x *= 0.99
    @vel_y *= 0.99
  end

  def is_dead
    if @health <= 0
        @dead = true
    end
  end

  def stunned
      
  end

  def update
    is_dead
  end

  def draw

  end

end
