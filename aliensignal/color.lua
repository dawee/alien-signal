local Object = require("classic")

local Color = Object:extend()

function Color:new(r, g, b, a)
  self.r = r
  self.g = g
  self.b = b
  self.a = a or 1
end

function Color:use()
  love.graphics.setColor(self.r / 256, self.g / 256, self.b / 256, self.a)
end

Color.Black = Color(0, 0, 0)
Color.White = Color(255, 255, 255)
Color.River = Color(52, 152, 219)
Color.Clouds = Color(236, 240, 241)

Color.Guide = Color(255, 255, 255, 0.3)

Color.TargetSignal = Color(200, 200, 200, 0.8)
Color.Signal = Color(106, 190, 48)
Color.InventoryBorder = Color(143, 86, 59)

return Color
