local bank = require("aliensignal.bank")
local MachineScreen = require("aliensignal.screen.machine")
local Navigator = require("navigator")

local state = {
  navigator = Navigator(
    {
      machine = MachineScreen
    }
  ),
  ready = false
}

function love.load()
  bank:load()
end

function love.update(dt)
  if not bank:isLoaded() and bank:update() then
    state.navigator:navigate("machine")
    state.ready = true
  elseif state.ready then
    state.navigator:update(dt)
  end
end

function love.mousemoved(x, y, dx, dy)
  if state.ready then
    state.navigator:mousemoved(x, y, dx, dy)
  end
end

function love.mousepressed(x, y, button, istouch)
  if state.ready then
    state.navigator:mousepressed(x, y, button, istouch)
  end
end

function love.mousereleased(x, y, button, istouch)
  if state.ready then
    state.navigator:mousereleased(x, y, button, istouch)
  end
end

function love.draw()
  if state.ready then
    state.navigator:draw()
  end
end
