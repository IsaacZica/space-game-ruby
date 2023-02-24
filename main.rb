require 'gosu'
require_relative 'player'
require_relative 'projectile'
require_relative 'star'
require_relative 'asteroid'
require_relative 'enemy'

WIDTH = 1280
HEIGHT = 720

class Tutorial < Gosu::Window
  attr_accessor :projectiles

  def initialize
    super WIDTH, HEIGHT
    @background_image = Gosu::Image.new("media\\background2.png", :tileable => true)
    self.caption = "Jogo da navinha"

    $enemies = []
    $asteroids = []

    $player = Player.new

    $player.warp(WIDTH / 2 , HEIGHT / 2)
    @stars = Array.new(100).map { Star.new }
  end

  def update
    # ...
    if $asteroids.size < MAX_ASTEROIDS
      $asteroids.push(Asteroid.new(rand(ASTEROID_VARIATION)))
    end

    if $enemies.size < MAX_ENEMIES
      $enemies.push(Enemy.new)
    end

    $player.update
    ####################################################
    $enemies.each do |e|
      if e.dead
        $enemies.delete(e)
        next
      end
      e.update
    end

    @stars.each { |s| s.update($player.vel_x, $player.vel_y) }

    $asteroids.each do |a|
      if a.dead
        $asteroids.delete(a)
        next
      end
      a.update
    end
  end

  def draw
    @background_image.draw(0, 0, 0, 1, 1)
    $player.draw
    $enemies.each { |e| e.draw }
    @stars.each { |s| s.draw }
    $asteroids.each { |s| s.draw }
  end
end

Tutorial.new.show
