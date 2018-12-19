require "header"

-- STATIC
ParticleEffect.static.active = { }

function ParticleEffect.spawn(x, y, filename, lifetime)
  local inst = ParticleEffect:new(x, y, filename, lifetime)
  table.insert(ParticleEffect.active, inst)
  return inst
end

function ParticleEffect.drawAll()
  for i, v in ipairs(ParticleEffect.active) do
    v:draw()
  end
end

function ParticleEffect.updateAll(dt)
  for i, v in ipairs(ParticleEffect.active) do
    v:update(dt)
  end
end

-- INSTANCE
function ParticleEffect:initialize(x, y, particleFileName, lifetime)
  self.x = x
  self.y = y
  self.lifetime = lifetime
  self.lifeRemaining = lifetime
  self.psys = love.graphics.newParticleSystem(love.graphics.newImage(particleFileName), 64)
end

function ParticleEffect:draw()
  love.graphics.draw(self.psys, self.x, self.y)
end

function ParticleEffect:update(dt)
  self.lifeRemaining = self.lifeRemaining - dt
  self.psys:update(dt)
  
  if self.lifeRemaining <= 0 then self:destroy() end
end

function ParticleEffect:destroy()
  for i, v in ipairs(ParticleEffect.active) do
    if v == self then table.remove(ParticleEffect.active, i) end
  end
end