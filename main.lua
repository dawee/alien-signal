local bank = require("aliensignal.bank")
local input = require("aliensignal.input")
local Event = require("event")
local MachineScreen = require("aliensignal.screen.machine")
local MainScreen = require("aliensignal.screen.main")
local Navigator = require("navigator")

local Generator = require("aliensignal.module.generator")
local Sampler = require("aliensignal.module.sampler")
local Output = require("aliensignal.module.output")

local Junk = require("aliensignal.junk")

local DEBUG = false

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
  modules = {
    antenna = {},
    spacegun = {}
  },
  ready = false
}

local function addModule(outputType, slot, ModuleType, ...)
  if not state.modules[outputType][slot.x] then
    state.modules[outputType][slot.x] = {}
  end

  state.modules[outputType][slot.x][slot.y] = ModuleType(slot, state.modules[outputType], ...)
end

function love.load()
  bank:load()
  love.graphics.setDefaultFilter("nearest", "nearest")
end

function love.update(dt)
  input:update(dt)

  if not bank:isLoaded() and bank:update() then
    addModule("spacegun", {x = 1, y = 4}, Generator)
    addModule("spacegun", {x = 2, y = 3}, Sampler)
    addModule("spacegun", {x = 6, y = 4}, Output, "spacegun")

    addModule("antenna", {x = 1, y = 4}, Generator)
    addModule("antenna", {x = 2, y = 3}, Sampler)
    addModule("antenna", {x = 6, y = 4}, Output, "antenna")

    if DEBUG then
      local types = {
        Junk.MapleSyrupCan,
        Junk.SonicScrewdriver,
        Junk.LightBulb,
        Junk.Shield,
        Junk.GameBoy,
        Junk.Trophy,
        Junk.Battery,
        Junk.Fork,
        Junk.Coin,
        Junk.Microphone,
        Junk.Boombox,
        Junk.FloppyDisk
      }

      for index, junkType in ipairs(types) do
        for n = 1, 100, 1 do
          table.insert(state.inventory.junk, junkType())
        end
      end
    end

    state.navigator:navigate("main", {inventory = state.inventory, modules = state.modules})
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
