local bank = require("aliensignal.bank")
local peachy = require("peachy")
local Object = require("classic")

local Slot = Object:extend()

function Slot:new(position)
  self.sprite = peachy.new(bank.slot.spritesheet, bank.slot.image, "idle")
  self.position = position
end

function Slot:update(dt)
  self.sprite:update(dt)
end

function Slot:draw()
  self.sprite:draw(self.position.x, self.position.y)
end

return Slot
