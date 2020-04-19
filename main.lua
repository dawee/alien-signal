local bank = require("aliensignal.bank")
local input = require("aliensignal.input")
local Event = require("event")
local MachineScreen = require("aliensignal.screen.machine")
local MainScreen = require("aliensignal.screen.main")
local Navigator = require("navigator")

local AndGate = require("aliensignal.module.andgate")
local OrGate = require("aliensignal.module.orgate")
local Booster = require("aliensignal.module.booster")
local Decreaser = require("aliensignal.module.decreaser")
local Coupler = require("aliensignal.module.coupler")
local NotGate = require("aliensignal.module.notgate")
local Phaser = require("aliensignal.module.phaser")
local Wire = require("aliensignal.module.wire")
local DownLeftShoulder = require("aliensignal.module.downleftshoulder")
local DownRightShoulder = require("aliensignal.module.downrightshoulder")
local UpLeftShoulder = require("aliensignal.module.upleftshoulder")
local UpRightShoulder = require("aliensignal.module.uprightshoulder")

local Junk = require("aliensignal.junk")

local state = {
  navigator = Navigator(
    {
      main = MainScreen,
      machine = MachineScreen
    }
  ),
  inventory = {
    junk = {},
    modules = {}
  },
  ready = false
}

function love.load()
  bank:load()
  love.graphics.setDefaultFilter("nearest", "nearest")
end

function love.update(dt)
  input:update(dt)

  if not bank:isLoaded() and bank:update() then
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
