class Utils
  def self.get_x_by_angle(angle, range)
    Math.cos(gosu_to_rad(angle)) * range
  end

  def self.get_y_by_angle(angle, range)
    Math.sin(gosu_to_rad(angle)) * range
  end

  def self.gosu_to_rad(angle)
    (angle - 90) * Math::PI / 180.0
  end

  def self.rad_do_gosu(angle)
    angle * 180.0 / Math::PI + 90.0
  end

  def self.get_angle(x1, y1, x2, y2)
    angle = rad_do_gosu(Math.atan2(y2 - y1, x2 - x1))
    angle += 360 if angle.negative?
    angle
  end
end
