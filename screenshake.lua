require "util"

-- STATIC
ShakeEffect.static.stack = { }

function ShakeEffect.add(mag, dur)
  local inst = ShakeEffect:new(mag, dur)
  table.insert(ShakeEffect.stack, inst)
end

function ShakeEffect.updateAll(dt)
  for i, v in ipairs(ShakeEffect.stack) do v:update(dt) end
end

function ShakeEffect.apply()
  local mag = 0
  for i, v in ipairs(ShakeEffect.stack) do
    mag = mag + v.magnitude
  end
  local dx = love.math.random(-mag, mag)
  local dy = love.math.random(-mag, mag)
  love.graphics.translate(dx, dy)
end

-- INSTANCE
function ShakeEffect:initialize(magnitude, duration)
  self.magnitude = magnitude
  self.decay = self.magnitude / duration
end

function ShakeEffect:update(dt)
  self.magnitude = self.magnitude - self.decay * dt
  
  if self.magnitude <= 0 then
    self:delete()
  end
end

function ShakeEffect:delete()
  for i, v in ipairs(ShakeEffect.stack) do
    if v == self then
      table.remove(ShakeEffect.stack, i)
    end
  end
end