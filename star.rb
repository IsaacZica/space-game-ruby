class Star
    def initialize
  
      @image = Gosu::Image.new('media\\star.png')
      @y = rand(HEIGHT)
      @x = rand(WIDTH)
      @size = rand(0.3..0.8)
      @speed = rand(0.5..2)
      @speed_x = @speed_y = 0.0
      
    end
  
    def update(player_vel_x, player_vel_y, angle)
      

      @x -= (@speed_x  + player_vel_x) * @speed
      @y -= (@speed_y  + player_vel_y) * @speed
      @y %= HEIGHT
      @x %= WIDTH
    end
  
    def draw
      case 
      when @speed > 1
        @image.draw(@x, @y, 4, @size, @size)
      when @speed > 0.7
        @image.draw(@x, @y, 2, @size, @size)
      else
        @image.draw(@x, @y, 1, @size, @size)
      end 
      
    end
  end