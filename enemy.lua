require "retroengine"
require "util"
require "header"

Enemy.static.active = { }

-- STATIC
Enemy.static.sprite = love.graphics.newImage("assets/enemy.png")
Enemy.static.width = Enemy.sprite:getWidth()
Enemy.static.height = Enemy.sprite:getHeight()
Enemy.static.explosionSound = love.audio.newSource("assets/boom_1.wav", "static")

Enemy.static.minShootDelay = 1
Enemy.static.maxShootDelay = 3

Enemy.static.minSpeed = 10
Enemy.static.maxSpeed = 30

Enemy.static.spawnTimer = Timer:new(1, function() Enemy.spawn() return false end)
Enemy.spawnTimer:start()

function Enemy.static.spawn()
  local inst = StrafingEnemy:new()
  table.insert(Enemy.active, inst)
end

function Enemy.static.createShootTimer(instance)
  local callback = function()
    instance:shoot()
    instance.shootTimer = Enemy.createShootTimer(instance)
    instance.shootTimer:start()
    return false
  end
  
  local delay = math.random(Enemy.minShootDelay, Enemy.maxShootDelay)
  return Timer:new(delay, callback)
end

function Enemy.static.drawAll()
  foreach(Enemy.active, function(i) Enemy.active[i]:draw() end)
end

function Enemy.static.updateAll(dt)
  Enemy.spawnTimer:update(dt)
  foreach(Enemy.active, function(i) Enemy.active[i]:update(dt) end)
end

-- INSTANCE
function Enemy:initialize()
  self.x = math.random(0, retroEngine.gameWidth - Enemy.width)
  self.y = -Enemy.height
  self.speed = math.random(Enemy.minSpeed, Enemy.maxSpeed)
  
  self.exhaustEffect = love.graphics.newParticleSystem(love.graphics.newImage("assets/pixel.png"), 32)
  self.exhaustEffect:setDirection(1.5 * math.pi)
  self.exhaustEffect:setSpread(0.25 * math.pi)
  self.exhaustEffect:setSpeed(Enemy.minSpeed, Enemy.maxSpeed)
  self.exhaustEffect:setEmissionRate(50)
  self.exhaustEffect:setParticleLifetime(0.1, 0.3)
  
  local callback = function()
    self:shoot()
    self.shootTimer.originalDelay = randomf(Enemy.minShootDelay, Enemy.maxShootDelay)
    return false
  end
  
  self.shootTimer = Timer:new(math.random(Enemy.minShootDelay, Enemy.maxShootDelay), callback)--Enemy.createShootTimer(self)
  self.shootTimer:start()
end

function Enemy:draw()
  love.graphics.draw(Enemy.sprite, self.x, self.y)
  love.graphics.draw(self.exhaustEffect, 0, 0)
end

function Enemy:update(dt)
  self.y = self.y + self.speed * dt
  self.shootTimer:update(dt)
  self.exhaustEffect:update(dt)
  self.exhaustEffect:moveTo(self.x + Enemy.width / 2, self.y)
  
  if not intersects(self.x, self.y, Enemy.width, Enemy.height, 0, 0, retroEngine.gameWidth, retroEngine.gameHeight) then
    self:destroy()
  end
end

function Enemy:shoot()
  Projectile.spawn(self.x + Enemy.width / 2, self.y, false)
end

function Enemy:destroy()
  for i, v in ipairs(Enemy.active) do
    if v == self then
      table.remove(Enemy.active, i)
    end
  end
end

function Enemy:kill()
  self:destroy()
  ShakeEffect.add(5, 0.2)
  
  local particles = ParticleEffect.spawn(self.x + Enemy.width / 2, self.y + Enemy.height / 2, "assets/pixel.png", 0.5)
  
  particles.psys:setParticleLifetime(0.2, 0.5) -- Particles live at least 2s and at most 5s.
  particles.psys:setSpread(2 * math.pi)

  particles.psys:setSpeed(60, 80)
	--particles.psys:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
	particles.psys:setColors(255, 183, 15, 255, 255, 183, 15, 255)
	particles.psys:emit(64)
	--particles.psys:setSizeVariation(0)
  
  PlayingState.instance.score = math.floor(PlayingState.instance.score + self.y)
  love.audio.play(Enemy.explosionSound)
end
