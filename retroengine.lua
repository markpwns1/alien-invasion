require "header"

retroEngine.canvas = nil
retroEngine.font = nil

retroEngine.gameWidth = 196
retroEngine.gameHeight = 128

retroEngine.windowWidth = retroEngine.gameWidth * 4
retroEngine.windowHeight = retroEngine.gameHeight * 4
retroEngine.windowTitle = "ALIEN INVASION - BY MARK KALDAS"

function retroEngine.init()
  love.graphics.setDefaultFilter("nearest", "nearest", 1)
  retroEngine.canvas = love.graphics.newCanvas(retroEngine.gameWidth, retroEngine.gameHeight)

  retroEngine.font = love.graphics.newImageFont("assets/font.png", " abcdefghijklmnopqrstuvwxyz" .. "ABCDEFGHIJKLMNOPQRSTUVWXYZ" .. "0123456789" .. ".,!?-+/*_<>\"'[]=|\\@`~{}#$%^&():;")
  love.graphics.setFont(retroEngine.font)
end

function retroEngine.draw()
  love.graphics.draw(retroEngine.canvas, 0, 0, 0, (retroEngine.windowWidth / retroEngine.gameWidth), (retroEngine.windowHeight / retroEngine.gameHeight), 0, 0)
end

function retroEngine.windowToGameCoords(x, y)
  return x / retroEngine.windowWidth * retroEngine.gameWidth, y / retroEngine.windowHeight * retroEngine.gameHeight
end

function retroEngine.gameToWindowCoords(x, y)
  return x / retroEngine.gameWidth * retroEngine.windowWidth, y / retroEngine.gameHeight * retroEngine.windowHeight
end