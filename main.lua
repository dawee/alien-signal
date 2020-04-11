local bank = require("aliensignal.bank")
local peachy = require("peachy")
local Booster = require("aliensignal.booster")
local Color = require("color")
local Generator = require("aliensignal.generator")
local Object = require("classic")
local Sampler = require("aliensignal.sampler")
local Slot = require("aliensignal.slot")
local Output = require("aliensignal.output")
local DownLeftShoulder = require("aliensignal.downleftshoulder")
local DownRightShoulder = require("aliensignal.downrightshoulder")
local UpLeftShoulder = require("aliensignal.upleftshoulder")
local UpRightShoulder = require("aliensignal.uprightshoulder")

local wave = {
  top = 0,
  left = 1024 - 800,
  length = 800,
  height = 50,
  padding = 20,
  duration = 8
}

-- local AndComparison = Module:extend()

-- function AndComparison:new(input1, input2)
--   self.input1 = input1
--   self.input2 = input2
-- end

-- function AndComparison:computeRightOutput(time)
--   local y1 = self.input1:computeRightOutput(time)
--   local y2 = self.input2:computeRightOutput(time)

--   return y1 == 1 and y2 == 1 and 1 or 0
-- end

local state = {
  ready = false,
  sliding = false,
  transform = love.math.newTransform(),
  transformReset = love.math.newTransform()
}

function love.load()
  bank:load()
end

function love.update(dt)
  if not bank:isLoaded() and bank:update() then
    state.slots = {}

    for xi = 0, 20, 1 do
      for yi = 0, 10, 1 do
        table.insert(state.slots, Slot({x = xi * 124, y = yi * 124}))
      end
    end

    state.modules = {}
    state.modules[1] = {}
    state.modules[2] = {}
    state.modules[3] = {}
    state.modules[4] = {}
    state.modules[6] = {}

    state.modules[1][3] = Generator({x = 1, y = 3}, state.modules)
    state.modules[2][3] = Sampler({x = 2, y = 3}, state.modules)
    state.modules[3][3] = Booster({x = 3, y = 3}, state.modules)
    state.modules[4][3] = Booster({x = 4, y = 3}, state.modules)
    state.modules[6][3] = Output({x = 6, y = 3}, state.modules)

    state.modules[1][6] = UpLeftShoulder({x = 1, y = 6}, state.modules)
    state.modules[2][6] = UpRightShoulder({x = 2, y = 6}, state.modules)
    state.modules[3][6] = DownLeftShoulder({x = 3, y = 6}, state.modules)
    state.modules[4][6] = DownRightShoulder({x = 4, y = 6}, state.modules)

    state.ready = true
  elseif state.ready then
    state.points = {}

    local output = nil

    for x, module_col in pairs(state.modules) do
      for y, mod in pairs(module_col) do
        if mod:is(Output) then
          output = mod
          break
        end
      end
    end

    if output then
      for i = 0, wave.length, 1 do
        local time = i * wave.duration / wave.length
        local y = output:computeRightOutput(time)

        table.insert(state.points, wave.left + i)
        table.insert(state.points, wave.top + wave.padding + wave.height / 2 - y * wave.height / 2)
      end
    end

    for index, slot in pairs(state.slots) do
      slot:update(dt)
    end

    for x, module_col in pairs(state.modules) do
      for y, mod in pairs(module_col) do
        mod:update(dt)
      end
    end
  end
end

function love.mousemoved(x, y, dx, dy)
  if state.sliding then
    state.transform:translate(dx, dy)
  elseif state.movingModule then
    state.movingModule.position.x = state.movingModule.position.x + dx
    state.movingModule.position.y = state.movingModule.position.y + dy
  end
end

function love.mousepressed(x, y, button, istouch)
  if state.ready and button == 2 then
    state.sliding = true
  elseif state.ready and button == 1 then
    state.movingModule =
      state.modules[math.floor(x / 128) + 1] and state.modules[math.floor(x / 128) + 1][math.floor(y / 128) + 1]
  end
end

function love.mousereleased(x, y, button, istouch)
  if state.ready and button == 2 then
    state.sliding = false
  elseif state.movingModule and button == 1 then
    local newSlot = {
      x = math.floor(x / 128) + 1,
      y = math.floor(y / 128) + 1
    }

    if not state.modules[newSlot.x] then
      state.modules[newSlot.x] = {}
    end

    if not state.modules[newSlot.x][newSlot.y] then
      state.modules[state.movingModule.slot.x][state.movingModule.slot.y] = nil
      state.modules[newSlot.x][newSlot.y] = state.movingModule
    else
      newSlot = state.movingModule.slot
    end

    state.movingModule.slot = newSlot
    state.movingModule:updatePosition()
    state.movingModule = nil
  end
end

function love.draw()
  if state.ready then
    love.graphics.push()
    love.graphics.applyTransform(state.transform)

    for index, slot in pairs(state.slots) do
      slot:draw()
    end

    for x, module_col in pairs(state.modules) do
      for y, mod in pairs(module_col) do
        mod:draw()
      end
    end

    love.graphics.pop()

    Color.Clouds:use()
    love.graphics.rectangle("fill", wave.left, wave.top, wave.length, wave.height + 2 * wave.padding)
    Color.River:use()
    love.graphics.setColor(52 / 256, 152 / 256, 219 / 256, 1)

    if state.points and table.getn(state.points) > 1 then
      love.graphics.line(unpack(state.points))
    end

    Color.White:use()
  end
end
