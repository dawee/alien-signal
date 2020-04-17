local Object = require("classic")

local Craftable = Object:extend()

function Craftable:renderDisplayableName(font, color, position)
  if not self.texts then
    self.texts = {}
  end

  if not self.displayableName then
    error(self.name .. " has no displayableName")
  end

  self.texts.displayableName = {
    color = color,
    text = love.graphics.newText(font, self.displayableName),
    position = position
  }
end

function Craftable:draw()
  if self.texts then
    for index, item in pairs(self.texts) do
      item.color:use()
      love.graphics.draw(item.text, item.position.x, item.position.y)
      love.graphics.setColor(1, 1, 1, 1)
    end
  end
end

return Craftable
