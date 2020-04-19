function love.conf(t)
  t.console = true
  t.window.width = 1024
  t.window.height = 768
  t.window.title = "Ryker Skies"
  love.filesystem.setRequirePath("?.lua;?/init.lua;lib/?.lua")
end
