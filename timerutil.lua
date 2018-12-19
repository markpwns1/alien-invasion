require "util"
local class = require "middleclass"

Timer = class("Timer")

Timer.static.active = { }

function Timer.static.updateAll(dt)
  for i, t in ipairs(Timer.active) do
    t.update(dt)
  end
end

function Timer.static.register(timer)
  table.insert(Timer.active, timer)
end

function Timer:initialize(delay, callback)
  self.originalDelay = delay
  self.timeLeft = delay
  self.callback = callback
  self.isRunning = false
end

function Timer:update(dt)
  if not self.isRunning then
    return
  end
  
  self.timeLeft = self.timeLeft - dt
  if self.timeLeft <= 0 then
    if self.callback() then
      self:delete()
    else
      self:reset()
    end
  end
end

function Timer:start()
  self.isRunning = true
end

function Timer:stop()
  self.isRunning = false
end

function Timer:reset()
  self.timeLeft = self.originalDelay
end

function Timer:delete()
  for i, v in ipairs(Timer.active) do
    if v == self then
      table.remove(i)
    end
  end
end