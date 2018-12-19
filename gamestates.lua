-- STATIC
GameState.current = nil

function GameState.enter(state)
  state:load()
  state:onEnter()
  GameState.current = state
end

function GameState:initialize()
  
end

function GameState:load()
  
end

function GameState:onPop()
  
end

function GameState:onPush()
  
end

function GameState:draw()
  
end

function GameState:update(dt)
  
end

function GameState:onEnter()
  
end