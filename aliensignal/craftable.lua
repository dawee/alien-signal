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
    font = font,
    text = self.displayableName,
    position = position
  }
end

function Craftable:renderDescription(font, color, position)
  if not self.texts then
    self.texts = {}
  end

  if not self.description then
    error(self.name .. " has no description")
  end

  self.texts.description = {
    color = color,
    font = font,
    text = self.description,
    position = position
  }
end

function Craftable:drawDescription()
  if self.texts and self.texts.description then
    self.texts.description.color:use()
    love.graphics.printf(
      self.texts.description.text,
      self.texts.description.font,
      self.texts.description.position.x,
      self.texts.description.position.y,
      512
    )
    love.graphics.setColor(1, 1, 1, 1)
  end
end

function Craftable:draw()
  if self.texts and self.texts.displayableName then
    self.texts.displayableName.color:use()
    love.graphics.printf(
      self.texts.displayableName.text,
      self.texts.displayableName.font,
      self.texts.displayableName.position.x,
      self.texts.displayableName.position.y,
      512
    )
    love.graphics.setColor(1, 1, 1, 1)
  end
end

return Craftable
