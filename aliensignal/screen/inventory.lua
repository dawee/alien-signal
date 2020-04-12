local Color = require("aliensignal.color")
local Navigator = require("navigator")

local InventoryScreen = Navigator.Screen:extend()

InventoryScreen.Border = 2
InventoryScreen.Margin = 32

function InventoryScreen:new(...)
  Navigator.Screen.new(self, ...)
end

function InventoryScreen:mousepressed(x, y)
  if
    x < InventoryScreen.Margin or x > 1024 - InventoryScreen.Margin or y < InventoryScreen.Margin or
      y > 768 - InventoryScreen.Margin
   then
    self.navigator:pop()
  end
end

function InventoryScreen:draw()
  Color.River:use()
  love.graphics.rectangle(
    "fill",
    InventoryScreen.Margin,
    InventoryScreen.Margin,
    1024 - InventoryScreen.Margin * 2,
    768 - InventoryScreen.Margin * 2
  )

  Color.Clouds:use()
  love.graphics.rectangle(
    "fill",
    InventoryScreen.Margin + InventoryScreen.Border,
    InventoryScreen.Margin + InventoryScreen.Border,
    1024 - InventoryScreen.Margin * 2 - InventoryScreen.Border * 2,
    768 - InventoryScreen.Margin * 2 - InventoryScreen.Border * 2
  )

  Color.White:use()
end

return InventoryScreen
