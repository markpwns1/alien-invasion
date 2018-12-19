local class = require "middleclass"
require "header"

-- STATIC
Projectile.static.active = { }

Projectile.static.sprite = love.graphics.newImage("assets/projectile.png")
Projectile.static.width = Projectile.sprite:getWidth()
Projectile.static.height = Projectile.sprite:getHeight()

Projectile.static.shootSound = love.audio.newSource("assets/pew_1.wav", "static")
Projectile.shootSound:setVolume(0.5)

Projectile.static.speed = 200

function Projectile.static.drawAll()
  foreach(Projectile.active, function(i) 
    Projectile.active[i]:draw() 
  end)
end

function Projectile.static.updateAll(dt)
  for i, v in ipairs(Projectile.active) do
    if v:update(dt) then break end
  end
  --foreach(Projectile.active, function(i) Projectile.active[i]:update(dt) end)
end

function Projectile.static.spawn(x, y, friendly)
  local proj = Projectile:new(x, y, friendly)
  table.insert(Projectile.active, proj)
  love.audio.play(Projectile.shootSound)
end

-- INSTANCE
function Projectile:initialize(x, y, friendly)
  self.x = x
  self.y = y
  self.friendly = friendly
end

function Projectile:draw()
  love.graphics.draw(Projectile.sprite, self.x, self.y)
end

function Projectile:intersects(x2, y2, w2, h2)
  return intersects(self.x, self.y, Projectile.width, Projectile.height, x2, y2, w2, h2)
end

-- Returns true if projectile is destroyed this frame
function Projectile:update(dt)
  self.y = self.y + Projectile.speed * dt * ternary(self.friendly, -1, 1)
  
  if (self.y < 0) or (self.y > retroEngine.gameHeight) then
    self:destroy()
  end
  
  for i, v in ipairs(Enemy.active) do
    if self:intersects(v.x, v.y, Enemy.width, Enemy.height) and self.friendly then
      v:kill()
      self:destroy()
    end
  end
  
  if self:intersects(Player.x, Player.y, Player.width, Player.height) and not self.friendly and not Player.isDead then
    Player.damage(10)
    self:destroy()
  end
end

function Projectile:destroy()
  for i, v in ipairs(Projectile.active) do
    if v == self then
      table.remove(Projectile.active, i)
    end
  end
end