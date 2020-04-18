local bank = require("aliensignal.bank")
local peachy = require("peachy")
local Craftable = require("aliensignal.craftable")

local Module = Craftable:extend()

function Module:new(name, slot, modules)
  self.name = name
  self.scale = 4
  self.sprite = peachy.new(bank.modules.spritesheet, bank.modules.image, name)

  if slot and modules then
    self.modules = modules
    self.slot = slot
    self:updatePosition()
  end
end

function Module:clone()
  return Module(self.name, self.slot, self.module)
end

function Module:updatePosition()
  self.position = {
    x = (self.slot.x - 1) * 128,
    y = (self.slot.y - 1) * 128
  }
end

function Module:update(dt)
  self.sprite:update(dt)
end

function Module:draw()
  Craftable.draw(self)
  self.sprite:draw(self.position.x, self.position.y, 0, self.scale, self.scale)
end

function Module:getInput(dx, dy)
  return self.modules[self.slot.x + dx] and self.modules[self.slot.x + dx][self.slot.y + dy] or nil
end

function Module:leftInput()
  return self:getInput(-1, 0)
end

function Module:rightInput()
  return self:getInput(1, 0)
end

function Module:upInput()
  return self:getInput(0, -1)
end

function Module:downInput()
  return self:getInput(0, 1)
end

function Module:renderText()
end

function Module:computeRightOutput(time, increment)
  return 0
end

function Module:computeLeftOutput(time, increment)
  return 0
end

function Module:computeUpOutput(time, increment)
  return 0
end

function Module:computeDownOutput(time, increment)
  return 0
end

return Module
