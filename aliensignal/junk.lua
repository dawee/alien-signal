local Object = require("classic")

local Junk = Object:extend()

function Junk:new(position)
  self.position = position or {x = 0, y = 0}
end

function Junk:update(dt)
end

function Junk:draw()
end

function Junk:drawTempSprite(r, g, b)
  love.graphics.setColor(r, g, b, 1)
  love.graphics.rectangle("fill", self.position.x + 16, self.position.y + 16, 128 - 16 * 2, 128 - 16 * 2)
  love.graphics.setColor(1, 1, 1, 1)
end

Junk.MappleSirupCan = Junk:extend()

function Junk.MappleSirupCan:new(...)
  Junk.new(self, ...)
  self.name = "Mapple Sirup Can"
end

function Junk.MappleSirupCan:draw()
  self:drawTempSprite(1, 0, 0)
end

Junk.WateringCan = Junk:extend()

function Junk.WateringCan:new(...)
  Junk.new(self, ...)
  self.name = "Watering Can"
end

function Junk.WateringCan:draw()
  self:drawTempSprite(0, 1, 0)
end

Junk.LightBulb = Junk:extend()

function Junk.LightBulb:new(...)
  Junk.new(self, ...)
  self.name = "Light Bulb"
end

function Junk.LightBulb:draw()
  self:drawTempSprite(0, 0, 1)
end

Junk.Headset = Junk:extend()

function Junk.Headset:new(...)
  Junk.new(self, ...)
  self.name = "Headset"
end

function Junk.Headset:draw()
  self:drawTempSprite(1, 0, 1)
end

return Junk
