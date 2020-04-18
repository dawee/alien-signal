local Craftable = require("aliensignal.craftable")

local Junk = Craftable:extend()

function Junk:new(name, position)
  self.name = name
  self.position = position or {x = 0, y = 0}
  self.scale = 4
end

function Junk:update(dt)
end

function Junk:draw()
  Craftable.draw(self)
end

function Junk:drawTempSprite(r, g, b)
  if not (self.visible == false) then
    love.graphics.setColor(r, g, b, 1)
    love.graphics.rectangle("fill", self.position.x, self.position.y, 32 * self.scale, 32 * self.scale)
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

Junk.GameBoy = Junk:extend()

function Junk.GameBoy:new(...)
  Junk.new(self, "gameboy", ...)
  self.displayableName = "GameBoy"
end

function Junk.GameBoy:draw()
  Junk.draw(self)
  self:drawTempSprite(1, 0, 1)
end

Junk.LlamaChampionshipMedal = Junk:extend()

function Junk.LlamaChampionshipMedal:new(...)
  Junk.new(self, "llamachampionshipMedal", ...)
  self.displayableName = "Llama Medal"
end

function Junk.LlamaChampionshipMedal:draw()
  Junk.draw(self)
  self:drawTempSprite(1, 0, 1)
end

Junk.BatteryCells = Junk:extend()

function Junk.BatteryCells:new(...)
  Junk.new(self, "batterycells", ...)
  self.displayableName = "Battery Cells"
end

function Junk.BatteryCells:draw()
  Junk.draw(self)
  self:drawTempSprite(1, 0, 1)
end

Junk.Fork = Junk:extend()

function Junk.Fork:new(...)
  Junk.new(self, "fork", ...)
  self.displayableName = "Fork"
end

function Junk.Fork:draw()
  Junk.draw(self)
  self:drawTempSprite(1, 0, 1)
end

Junk.Coin = Junk:extend()

function Junk.Coin:new(...)
  Junk.new(self, "coin", ...)
  self.displayableName = "Coin"
end

function Junk.Coin:draw()
  Junk.draw(self)
  self:drawTempSprite(1, 0, 1)
end

Junk.Hanger = Junk:extend()

function Junk.Hanger:new(...)
  Junk.new(self, "hanger", ...)
  self.displayableName = "Hanger"
end

function Junk.Hanger:draw()
  Junk.draw(self)
  self:drawTempSprite(1, 0, 1)
end

Junk.Boombox = Junk:extend()

function Junk.Boombox:new(...)
  Junk.new(self, "boombox", ...)
  self.displayableName = "Boombox"
end

function Junk.Boombox:draw()
  Junk.draw(self)
  self:drawTempSprite(1, 0, 1)
end

Junk.Keys = Junk:extend()

function Junk.Keys:new(...)
  Junk.new(self, "Keys", ...)
  self.displayableName = "Keys"
end

function Junk.Keys:draw()
  Junk.draw(self)
  self:drawTempSprite(1, 0, 1)
end

return Junk
