require "retroengine"

function love.conf(t)
	t.title = retroEngine.windowTitle 
	t.version = "11.2"         
	t.window.width = retroEngine.windowWidth
	t.window.height = retroEngine.windowHeight
	t.console = true
  t.window.vsync = false
end