require "util"
require "retroengine"
require "timerutil"
require "header"

Player.x = retroEngine.gameWidth / 2
Player.y = retroEngine.gameHeight * 4/5

-- all speed is in pixels per second
Player.vel = {
  x = 0,
  y = 0
}
Player.acceleration = {
  x = 10,
  y = 10
}
Player.topSpeed = {
  x = 75,
  y = 75
}

-- % of top speed per second
Player.velocityDecay = 200

-- rounds per minute
Player.fireRate = 300
Player.shootTimer = nil
Player.canShoot = true

Player.damageSound = love.audio.newSource("assets/hurt.wav", "static")
Player.deathSound = love.audio.newSource("assets/player_death.wav", "static")

Player.engineLoop = love.audio.newSource("assets/engine_loop.wav", "static")
Player.engineLoop:setLooping(true)
Player.engineLoop:setVolume(0.05)

Player.health = 100

function Player.reset()
  Player.health = 100
  Player.x = retroEngine.gameWidth / 2
  Player.y = retroEngine.gameHeight * 4/5
  Player.vel = {
    x = 0,
    y = 0
  }
  Player.isDead = false
  Player.shootTimer = nil
  Player.canShoot = true
end

Player.sprite = love.graphics.newImage("assets/player.png")
Player.width = Player.sprite:getWidth()
Player.height = Player.sprite:getHeight()

Player.exhaustEffect = love.graphics.newParticleSystem(love.graphics.newImage("assets/pixel.png"), 32)
Player.exhaustEffect:setDirection(0.5 * math.pi)
Player.exhaustEffect:setSpread(0.25 * math.pi)
Player.exhaustEffect:setSpeed(30, 40)
Player.exhaustEffect:setEmissionRate(50)
Player.exhaustEffect:setParticleLifetime(0.1, 0.3)

Player.isDead = false

function Player.draw()
  if Player.isDead then
    return
  end
  
  love.graphics.draw(Player.sprite, Player.x, Player.y)
  love.graphics.draw(Player.exhaustEffect, 0, 0)
end

function Player.move(x, y)
  Player.x = Player.x + x
  Player.y = Player.y + y
end

function Player.dampenMovement(dt)
  local dampX = 0.01 * Player.topSpeed.x * Player.velocityDecay * dt
  local dampY = 0.01 * Player.topSpeed.y * Player.velocityDecay * dt
  
  if Player.vel.x > 0 then
    Player.vel.x = lowerLimit(Player.vel.x - dampX, 0)
  elseif Player.vel.x < 0 then
    Player.vel.x = upperLimit(Player.vel.x + dampX, 0)
  end
  
  if Player.vel.y > 0 then
    Player.vel.y = lowerLimit(Player.vel.y - dampY, 0)
  elseif Player.vel.y < 0 then
    Player.vel.y = upperLimit(Player.vel.y + dampY, 0)
  end
end

function Player.maintainTopSpeed(dt)
  Player.vel.x = limit(Player.vel.x, -Player.topSpeed.x, Player.topSpeed.x)
  Player.vel.y = limit(Player.vel.y, -Player.topSpeed.y, Player.topSpeed.y)
end

function Player.collideWithScreenBounds()
  if Player.x < 0 then
    Player.x = 0
    Player.vel.x = 0
  end
  if Player.y < 0 then
    Player.y = 0 
    Player.vel.y = 0
  end
  if Player.x + Player.width > retroEngine.gameWidth then 
    Player.x = retroEngine.gameWidth - Player.width 
    Player.vel.x = 0
  end
  if Player.y + Player.height > retroEngine.gameHeight then 
    Player.y = retroEngine.gameHeight - Player.height 
    Player.vel.y = 0
  end
end

function Player.verticalAxis()
  if key("up") then return 1 end
  if key("down") then return -1 end
  return 0
end

function Player.horizontalAxis()
  if key("right") then return 1 end
  if key("left") then return -1 end
  return 0
end

local left = true

function Player.update(dt)
  if Player.isDead then
    return
  end
  
  Player.maintainTopSpeed(dt)
  Player.move(Player.vel.x * dt, Player.vel.y * dt)
  Player.collideWithScreenBounds()
  Player.dampenMovement(dt)
  Player.exhaustEffect:update(dt)
  Player.exhaustEffect:moveTo(Player.x + Player.width / 2, Player.y + Player.height)
  
  if Player.shootTimer ~= nil then
    Player.shootTimer:update(dt)
  end
  
  local xAcc = Player.horizontalAxis() * Player.acceleration.x
  local yAcc = -Player.verticalAxis() * Player.acceleration.y
  
  Player.vel.x = Player.vel.x + xAcc--ternary(xAcc == 0, player.vel.x, xAcc)
  Player.vel.y = Player.vel.y + yAcc--ternary(yAcc == 0, player.vel.y, yAcc)
  
  if key("z") and Player.canShoot then
    Projectile.spawn(Player.x + ternary(left, 0, Player.width), Player.y, true)
    left = not left 
    
    --ShakeEffect.add(1, 0)
    
    Player.canShoot = false
    
    Player.shootTimer = Timer:new(60 / Player.fireRate, function()
      Player.canShoot = true
      return false
    end)
  
    Player.shootTimer:start()
    
  end
  
  for i, v in ipairs(Enemy.active) do
    if intersects(Player.x, Player.y, Player.width, Player.height, v.x, v.y, Enemy.width, Enemy.height) and not Player.isDead then
      v:kill()
      Player.damage(20)
    end
  end
  
  if Player.health <= 0 then
    Player.isDead = true
    
    local particles = ParticleEffect.spawn(Player.x + Player.width / 2, Player.y + Player.height / 2, "assets/pixel.png", 0.5)
  
    particles.psys:setParticleLifetime(0.2, 0.5) -- Particles live at least 2s and at most 5s.
    particles.psys:setSpread(2 * math.pi)

    particles.psys:setSpeed(60, 80)
    --particles.psys:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
    particles.psys:setColors(255, 183, 15, 255, 255, 183, 15, 255)
    particles.psys:emit(64)
    
    love.audio.play(Player.deathSound)
    ShakeEffect.add(5, 4)
  end
end

function Player.damage(amount)
  if not Player.isDead then
    Player.health = Player.health - amount
    ShakeEffect.add(5, 0.2)
    UI.redden()
    love.audio.play(Player.damageSound)
  end
end