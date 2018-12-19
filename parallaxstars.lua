require "header"

-- STATIC
BackgroundStar.static.active = { }

BackgroundStar.static.sprite = love.graphics.newImage("assets/star.png")
BackgroundStar.static.width = BackgroundStar.sprite:getWidth()
BackgroundStar.static.height = BackgroundStar.sprite:getHeight()

function BackgroundStar.static.updateAll(dt)
  for i, v in ipairs(BackgroundStar.active) do
    v:update(dt)
  end
end

function BackgroundStar.static.drawAll()
  for i, v in ipairs(BackgroundStar.active) do
    v:draw()
  end
end

-- INSTANCE
function BackgroundStar:initialize(x, y, speed)
  self.x = x
  self.y = y
  self.speed = speed
end

function BackgroundStar:update(dt)
  self.y = self.y + self.speed * dt
  if self.y > retroEngine.gameHeight then
    self.y = -BackgroundStar.height
  end
end

function BackgroundStar:draw()
  love.graphics.draw(BackgroundStar.sprite, self.x, self.y)
end

BackgroundStar.active = { }

-- ON LOAD
for i = 0, 100, 1 do
  local x = math.random(0, retroEngine.gameWidth)
  local y = math.random(0, retroEngine.gameHeight)
  local speed = math.random(1, 30)
  local inst = BackgroundStar:new(x, y, speed)
  table.insert(BackgroundStar.active, inst)
end
