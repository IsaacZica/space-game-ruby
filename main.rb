require 'gosu'
require_relative 'player'
require_relative 'projectile'
require_relative 'star'
require_relative 'asteroid'
require_relative 'enemy'

WIDTH, HEIGHT = 1280, 720


class Tutorial < Gosu::Window
  attr_accessor :projectiles
  def initialize
    super WIDTH, HEIGHT
    self.caption = "Jogo da navinha"

    #CursoRubyTestes\gosu\jogo_navinha\media\space.png

    $enemies = []
    $asteroids = []

    @background_image = Gosu::Image.new("media\\background2.png", :tileable => true)
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
      $enemies.delete(e) if e.dead
      e.update
    end

    @stars.each { |s| s.update($player.vel_x, $player.vel_y) }

    $asteroids.each do |a|
      $asteroids.delete(a) if a.dead
      a.update
    end
  end

  def draw
    # ...
    @background_image.draw(0, 0, 0, 1, 1)

    $player.draw
    #########################################################
    $enemies.each { |e| e.draw }

    @stars.each { |s| s.draw }

    for i in 0..$asteroids.size-1 do
      $asteroids[i].draw
    end


  end
end

Tutorial.new.show
