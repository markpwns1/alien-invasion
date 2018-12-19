function MainMenuState:load()
  require "parallaxstars"
end

local t = 0
local keyPressLastFrame = false

function MainMenuState:draw()
  love.graphics.clear()
  BackgroundStar.drawAll()
  love.graphics.printf("ALIEN INVASION\n\nBY MARK KALDAS", 0, 40, retroEngine.gameWidth, "center")
  if t < 1 then
    love.graphics.printf("PRESS SPACE TO PLAY", 0, 80, retroEngine.gameWidth, "center")
  end
end

function MainMenuState:update(dt)
  BackgroundStar.updateAll(dt)
  t = t + dt
  if t >= 2 then t = 0 end
  
  if keyPressLastFrame and not key("space") then 
    GameState.enter(PlayingState.instance)
  end
  
  keyPressLastFrame = key("space")
end