local bank = require("aliensignal.bank")
local peachy = require("peachy")
local Object = require("classic")

local InventoryBag = Object:extend()

InventoryBag.Margin = 16

function InventoryBag:new(navigator)
  self.sprite = peachy.new(bank.inventorybag.spritesheet, bank.inventorybag.image, "idle")
  self.navigator = navigator
  self.position = {
    x = InventoryBag.Margin,
    y = 768 - InventoryBag.Margin - self.sprite:getHeight()
  }
end

function InventoryBag:mousepressed(x, y, button)
  if
    button == 1 and x >= self.position.x and x <= self.position.x + self.sprite:getWidth() and y >= self.position.y and
      y <= self.position.y + self.sprite:getHeight()
   then
    self.navigator:push("inventory")
  end
end

function InventoryBag:update(dt)
  self.sprite:update(dt)
end

function InventoryBag:draw()
  self.sprite:draw(self.position.x, self.position.y)
end

return InventoryBag
