require "header"

StrafingEnemy.static.sprite = love.graphics.newImage("assets/enemy_strafing.png")

function StrafingEnemy.static.spawn()
  local inst = StrafingEnemy:new()
  table.insert(Enemy.active, inst)
end

function StrafingEnemy:initialize()
  Enemy.initialize(self)
  
  self.xVel = math.random(-10, 10)
end

function StrafingEnemy:draw()
  love.graphics.draw(StrafingEnemy.sprite, self.x, self.y)
  love.graphics.draw(self.exhaustEffect, 0, 0)
end

function StrafingEnemy:update(dt)
  Enemy.update(self, dt)
  
  self.x = self.x + self.xVel * dt
end