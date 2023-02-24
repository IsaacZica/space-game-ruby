class Utils
    def self.get_x_by_angle(angle, range)
      gosu_to_rad = (angle - 90) * Math::PI / 180
      return Math.cos(gosu_to_rad) * range
    end
  
    def self.get_y_by_angle(angle, range)
      gosu_to_rad = (angle - 90) * Math::PI / 180
      return Math.sin(gosu_to_rad) * range
    end

    def self.is_colliding(x1,y1,x2,y2,col_size_x,col_size_y)
      x_dif = (x1-x2).abs
      y_dif = (y1-y2).abs
      return true if x_dif < col_size_x && y_dif < col_size_y
    end

    def self.gosu_to_rad(angle)
      (angle - 90) * Math::PI / 180.0
    end
end