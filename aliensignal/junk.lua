local Craftable = require("aliensignal.craftable")

local Junk = Craftable:extend()

function Junk:new(name, position)
  self.name = name
  self.position = position or {x = 0, y = 0}
end

function Junk:update(dt)
end

function Junk:draw()
  Craftable.draw(self)
end

function Junk:drawTempSprite(r, g, b)
  if not (self.visible == false) then
    love.graphics.setColor(r, g, b, 1)
    love.graphics.rectangle("fill", self.position.x + 16, self.position.y + 16, 128 - 16 * 2, 128 - 16 * 2)
    love.graphics.setColor(1, 1, 1, 1)
  end
end

Junk.MappleSirupCan = Junk:extend()

function Junk.MappleSirupCan:new(...)
  Junk.new(self, "mapplesirup", ...)
  self.displayableName = "Mapple Sirup Can"
end

function Junk.MappleSirupCan:draw()
  Junk.draw(self)
  self:drawTempSprite(1, 0, 0)
end

Junk.WateringCan = Junk:extend()

function Junk.WateringCan:new(...)
  Junk.new(self, "wateringcan", ...)
  self.displayableName = "Watering Can"
end

function Junk.WateringCan:draw()
  Junk.draw(self)

  self:drawTempSprite(0, 1, 0)
end

Junk.LightBulb = Junk:extend()

function Junk.LightBulb:new(...)
  Junk.new(self, "lightbulb", ...)
  self.displayableName = "Light Bulb"
end

function Junk.LightBulb:draw()
  Junk.draw(self)
  self:drawTempSprite(0, 0, 1)
end

Junk.Headset = Junk:extend()

function Junk.Headset:new(...)
  Junk.new(self, "headset", ...)
  self.displayableName = "Headset"
end

function Junk.Headset:draw()
  Junk.draw(self)
  self:drawTempSprite(1, 0, 1)
end

return Junk
