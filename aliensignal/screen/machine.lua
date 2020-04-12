local bank = require("aliensignal.bank")
local AndComparison = require("aliensignal.andcomparison")
local Booster = require("aliensignal.booster")
local Color = require("aliensignal.color")
local Coupler = require("aliensignal.coupler")
local Navigator = require("navigator")
local Generator = require("aliensignal.generator")
local Sampler = require("aliensignal.sampler")
local Slot = require("aliensignal.slot")
local Output = require("aliensignal.output")
local DownLeftShoulder = require("aliensignal.downleftshoulder")
local DownRightShoulder = require("aliensignal.downrightshoulder")
local UpLeftShoulder = require("aliensignal.upleftshoulder")
local UpRightShoulder = require("aliensignal.uprightshoulder")

local MachineScreen = Navigator.Screen:extend()

MachineScreen.Wave = {
  Top = 0,
  Left = 1024 - 800,
  Length = 800,
  Height = 50,
  Padding = 20,
  Duration = 8
}

function MachineScreen:new()
  self.transform = love.math.newTransform()

  self.slots = {}

  for xi = 0, 20, 1 do
    for yi = 0, 10, 1 do
      table.insert(self.slots, Slot({x = xi * 124, y = yi * 124}))
    end
  end

  self.modules = {}
  self.modules[1] = {}
  self.modules[2] = {}
  self.modules[3] = {}
  self.modules[4] = {}
  self.modules[5] = {}
  self.modules[6] = {}
  self.modules[7] = {}

  self.modules[1][4] = Generator({x = 1, y = 4}, self.modules)
  self.modules[2][4] = Sampler({x = 2, y = 4}, self.modules)
  self.modules[3][4] = Booster({x = 3, y = 4}, self.modules)
  self.modules[4][4] = Booster({x = 4, y = 4}, self.modules)
  self.modules[6][4] = Output({x = 6, y = 4}, self.modules)

  self.modules[1][5] = UpLeftShoulder({x = 1, y = 5}, self.modules)
  self.modules[2][5] = UpRightShoulder({x = 2, y = 5}, self.modules)
  self.modules[3][5] = DownLeftShoulder({x = 3, y = 5}, self.modules)
  self.modules[4][5] = DownRightShoulder({x = 4, y = 5}, self.modules)
  self.modules[5][5] = AndComparison({x = 5, y = 5}, self.modules)
  self.modules[6][5] = Coupler({x = 6, y = 5}, self.modules)

  self.modules[1][6] = UpLeftShoulder({x = 1, y = 6}, self.modules)
  self.modules[2][6] = UpRightShoulder({x = 2, y = 6}, self.modules)
  self.modules[3][6] = DownLeftShoulder({x = 3, y = 6}, self.modules)
  self.modules[4][6] = DownRightShoulder({x = 4, y = 6}, self.modules)
  self.modules[5][6] = AndComparison({x = 5, y = 6}, self.modules)
  self.modules[6][6] = Coupler({x = 6, y = 6}, self.modules)
end

function MachineScreen:update(dt)
  self.points = {}

  local output = nil

  for x, module_col in pairs(self.modules) do
    for y, mod in pairs(module_col) do
      if mod:is(Output) then
        output = mod
        break
      end
    end
  end

  if output then
    for i = 0, MachineScreen.Wave.Length, 1 do
      local time = i * MachineScreen.Wave.Duration / MachineScreen.Wave.Length
      local y = output:computeRightOutput(time)

      table.insert(self.points, MachineScreen.Wave.Left + i)
      table.insert(
        self.points,
        MachineScreen.Wave.Top + MachineScreen.Wave.Padding + MachineScreen.Wave.Height / 2 -
          y * MachineScreen.Wave.Height / 2
      )
    end
  end

  for index, slot in pairs(self.slots) do
    slot:update(dt)
  end

  for x, module_col in pairs(self.modules) do
    for y, mod in pairs(module_col) do
      mod:update(dt)
    end
  end
end

function MachineScreen:mousemoved(x, y, dx, dy)
  if self.sliding then
    self.transform:translate(dx, dy)
  elseif self.movingModule then
    self.movingModule.position.x = self.movingModule.position.x + dx
    self.movingModule.position.y = self.movingModule.position.y + dy
  end
end

function MachineScreen:mousepressed(x, y, button, istouch)
  if button == 2 then
    self.sliding = true
  elseif button == 1 then
    self.movingModule =
      self.modules[math.floor(x / 128) + 1] and self.modules[math.floor(x / 128) + 1][math.floor(y / 128) + 1]
  end
end

function MachineScreen:mousereleased(x, y, button, istouch)
  if button == 2 then
    self.sliding = false
  elseif self.movingModule and button == 1 then
    local newSlot = {
      x = math.floor(x / 128) + 1,
      y = math.floor(y / 128) + 1
    }

    if not self.modules[newSlot.x] then
      self.modules[newSlot.x] = {}
    end

    if not self.modules[newSlot.x][newSlot.y] then
      self.modules[self.movingModule.slot.x][self.movingModule.slot.y] = nil
      self.modules[newSlot.x][newSlot.y] = self.movingModule
    else
      newSlot = self.movingModule.slot
    end

    self.movingModule.slot = newSlot
    self.movingModule:updatePosition()
    self.movingModule = nil
  end
end

function MachineScreen:draw()
  love.graphics.push()
  love.graphics.applyTransform(self.transform)

  for index, slot in pairs(self.slots) do
    slot:draw()
  end

  for x, module_col in pairs(self.modules) do
    for y, mod in pairs(module_col) do
      mod:draw()
    end
  end

  love.graphics.pop()

  Color.Clouds:use()
  love.graphics.rectangle(
    "fill",
    MachineScreen.Wave.Left,
    MachineScreen.Wave.Top,
    MachineScreen.Wave.Length,
    MachineScreen.Wave.Height + 2 * MachineScreen.Wave.Padding
  )
  Color.River:use()
  love.graphics.setColor(52 / 256, 152 / 256, 219 / 256, 1)

  if self.points and table.getn(self.points) > 1 then
    love.graphics.line(unpack(self.points))
  end

  Color.White:use()
end

return MachineScreen
