local Object = require("classic")

local Color = Object:extend()

function Color:new(r, g, b, a)
  self.r = r
  self.g = g
  self.b = b
  self.a = a or 1
end

function Color:use(alpha)
  love.graphics.setColor(self.r / 256, self.g / 256, self.b / 256, alpha == nil and self.a or alpha)
end

Color.Text = Object:extend()

function Color.Text:new()
  self.series = {}
end

function Color.Text:concat(color, text)
  table.insert(self.series, {color.r, color.g, color.b, color.a})
  table.insert(self.series, text)

  return self
end

function Color.Text:dump()
  return self.series
end

Color.ButtonBackground = Color(217, 97, 89)
Color.ButtonShadow = Color(102, 57, 49)
Color.ButtonBorder = Color(238, 195, 154)
Color.ButtonTitle = Color(255, 255, 255)

Color.ButtonDisabledBackground = Color(132, 126, 135)
Color.ButtonDisabledShadow = Color(89, 86, 82)
Color.ButtonDisabledBorder = Color(155, 173, 183)
Color.ButtonDisabledTitle = Color(155, 173, 183)

Color.DescriptionEnlight = Color(172, 50, 50)
Color.Description = Color(0, 0, 0)

Color.CraftListItemSelected = Color(143, 86, 59)
Color.CraftListItemEven = Color(238, 195, 154)
Color.CraftListItemOdd = Color(217, 160, 102)

Color.Black = Color(0, 0, 0)
Color.White = Color(255, 255, 255)
Color.River = Color(52, 152, 219)
Color.Clouds = Color(236, 240, 241)

Color.Guide = Color(255, 255, 255, 0.2)

Color.TargetSignal = Color(255, 64, 64, 0.8)
Color.Signal = Color(106, 190, 48)
Color.InventoryBorder = Color(143, 86, 59)

Color.CreditsText = Color(118, 66, 138)

return Color
