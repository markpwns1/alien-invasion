require "header"

UI.redDecay = 1
UI.redness = 0

local screenVertices = {
  0, 0,
  0, retroEngine.gameHeight,
  retroEngine.gameWidth, retroEngine.gameHeight,
  retroEngine.gameWidth, 0
}

function UI.redden()
  UI.redness = 1
end

UI.draw = function()
  love.graphics.print("PLAYER 1\n" .. Player.health .. "% SHIELD", 1, 1)
  love.graphics.printf("SCORE: " .. PlayingState.instance.score, 0, 1, retroEngine.gameWidth, "center")
  
  love.graphics.setColor(255, 0, 0, UI.redness)
  love.graphics.polygon("fill", screenVertices)
  love.graphics.setColor(255, 255, 255, 255)
end

function UI.update(dt)
  UI.redness = UI.redness - 1 / UI.redDecay * dt
end