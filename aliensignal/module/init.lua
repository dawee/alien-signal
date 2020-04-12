local bank = require("aliensignal.bank")
local peachy = require("peachy")
local Object = require("classic")

local Module = Object:extend()

function Module:new(name, slot, modules)
  self.sprite = peachy.new(bank[name].spritesheet, bank[name].image, "active")

  if slot and modules then
    self.modules = modules
    self.slot = slot
    self:updatePosition()
  end
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
  self.sprite:draw(self.position.x, self.position.y)
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

function Module:computeRightOutput(time)
  return 0
end

function Module:computeLeftOutput(time)
  return 0
end

function Module:computeUpOutput(time)
  return 0
end

function Module:computeDownOutput(time)
  return 0
end

return Module
