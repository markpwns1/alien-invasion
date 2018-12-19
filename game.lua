local deadTime = 0

PlayingState.score = 0

function PlayingState:onEnter()
  love.audio.play(Player.engineLoop)
end

function PlayingState:load()
  require "projectile"
  require "player"
  require "enemy"
  require "enemy_strafing"
  require "timerutil"
  require "ui"
  require "screenshake"
  require "particlemanager"
end

function PlayingState:draw()
  love.graphics.clear()

  BackgroundStar.drawAll()

  ShakeEffect.apply()

  Player.draw()
  Enemy.drawAll()
  Projectile.drawAll()
  ParticleEffect.drawAll()
  UI.draw()
end

function PlayingState:update(dt)
  BackgroundStar.updateAll(dt)
  ShakeEffect.updateAll(dt)
  Timer.updateAll(dt)
  Player.update(dt)
  Enemy.updateAll(dt)
  Projectile.updateAll(dt)
  ParticleEffect.updateAll(dt)
  UI.update(dt)
  
  if Player.isDead then
    deadTime = deadTime + dt
  end
  
  if deadTime > 5 then
    GameState.enter(GameOverState.instance)
    deadTime = 0
  end
end