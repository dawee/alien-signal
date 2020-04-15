local bank = require("aliensignal.bank")
local input = require("aliensignal.input")
local BookScreen = require("aliensignal.screen.book")
local Event = require("event")
local MachineScreen = require("aliensignal.screen.machine")
local Navigator = require("navigator")

local AndGate = require("aliensignal.module.andgate")
local OrGate = require("aliensignal.module.orgate")
local Booster = require("aliensignal.module.booster")
local Decreaser = require("aliensignal.module.decreaser")
local Coupler = require("aliensignal.module.coupler")
local Sampler = require("aliensignal.module.sampler")
local Wire = require("aliensignal.module.wire")
local DownLeftShoulder = require("aliensignal.module.downleftshoulder")
local DownRightShoulder = require("aliensignal.module.downrightshoulder")
local UpLeftShoulder = require("aliensignal.module.upleftshoulder")
local UpRightShoulder = require("aliensignal.module.uprightshoulder")

local state = {
  navigator = Navigator(
    {
      book = BookScreen,
      machine = MachineScreen
    }
  ),
  inventory = {},
  ready = false
}

function love.load()
  bank:load()
  love.graphics.setDefaultFilter("nearest", "nearest")
end

function love.update(dt)
  input:update(dt)

  if not bank:isLoaded() and bank:update() then
    local moduleTypes = {
      AndGate,
      OrGate,
      Booster,
      Decreaser,
      Coupler,
      Sampler,
      Wire,
      DownLeftShoulder,
      DownRightShoulder,
      UpLeftShoulder,
      UpRightShoulder
    }

    for index, moduleType in pairs(moduleTypes) do
      for i = 1, 100, 1 do
        table.insert(state.inventory, moduleType())
      end
    end

    state.navigator:navigate("machine", {inventory = state.inventory})
    state.ready = true
  elseif state.ready then
    state.navigator:update(dt)
    Event.scheduler:update()
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
