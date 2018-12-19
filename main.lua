--if arg[#arg] == "-debug" then require("mobdebug").start() end

require "slam"
require "util"
require "header"
require "retroengine"
require "gamestates"
require "game"
require "mainmenu"
require "gameover"

function love.load()
  retroEngine.init()
  
  MainMenuState.instance = MainMenuState:new()
  PlayingState.instance = PlayingState:new()
  GameOverState.instance = GameOverState:new()
  
  GameState.enter(MainMenuState.instance)
  
  
  local backgroundMusic = love.audio.newSource("assets/music.wav", "static")
  backgroundMusic:setLooping(true)
  backgroundMusic:setVolume(5)
  love.audio.play(backgroundMusic)
end

function love.draw()
  retroEngine.canvas:renderTo(GameState.current.draw)
  retroEngine.draw()
end

function love.update(dt)
  love.timer.sleep(1/60 - dt)
  
  GameState.current:update(dt)
end

