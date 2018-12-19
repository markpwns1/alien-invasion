function GameOverState:load()
  require "parallaxstars"
  
  Player.reset()
  love.audio.stop(Player.engineLoop)
  
  while #Enemy.active > 0 do
    table.remove(Enemy.active, 1)
  end
  
  while #Projectile.active > 0 do
    table.remove(Projectile.active, 1)
  end
  
end

local t = 0
local keyPressLastFrame = false

function GameOverState:draw()
  love.graphics.clear()
  BackgroundStar.drawAll()
  love.graphics.printf("GAME OVER", 0, 40, retroEngine.gameWidth, "center")
  love.graphics.printf("SCORE: " .. PlayingState.instance.score, 0, 60, retroEngine.gameWidth, "center")
  if t < 1 then
    love.graphics.printf("PRESS SPACE TO RETURN\nTO THE MAIN MENU", 0, 80, retroEngine.gameWidth, "center")
  end
end

function GameOverState:update(dt)
  BackgroundStar.updateAll(dt)
  t = t + dt
  if t >= 2 then t = 0 end
  
  if keyPressLastFrame and not key("space") then 
    PlayingState.instance.score = 0
    GameState.enter(MainMenuState.instance)
  end
  
  keyPressLastFrame = key("space")
end