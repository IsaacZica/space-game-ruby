class Star
  def initialize
    @image = Gosu::Image.new('media\\star.png')
    @y = rand(HEIGHT)
    @x = rand(WIDTH)
    @layer = rand(1..5)
    @size = 0.18 * @layer
    @speed = 0.4 * @layer
  end

  def update(player_vel_x, player_vel_y)
    @x -= player_vel_x * @speed
    @y -= player_vel_y * @speed
    @y %= HEIGHT
    @x %= WIDTH
  end

  def draw
    @image.draw(@x, @y, 0, @size, @size)
  end
end

