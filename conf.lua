function love.conf(t)
  t.console = true
  t.window.width = 1024
  t.window.height = 768
  t.window.title = "Alien signal"
  love.filesystem.setRequirePath("?.lua;?/init.lua;lib/?.lua")
end
