local Object = require("classic")
local Color = require("aliensignal.color")

local Button = Object:extend()

Button.Border = 2
Button.Shadow = 2

function Button:new(title, font, position, size, transform)
  self.text = love.graphics.newText(font, title)
  self.position = position
  self.size = size
  self.innerWidth = self.size.width - 2 * Button.Border
  self.innerHeight = self.size.height - 2 * Button.Border - Button.Shadow
  self.transform = transform
end

function Button:mousepressed(localX, localY, button)
  local x, y = self.transform:inverseTransformPoint(localX, localY)

  if
    x >= self.position.x and x <= self.position.x + self.size.width and y >= self.position.y and
      y <= self.position.y + self.size.height
   then
    self.pressed = true
    return true
  end
end

function Button:mousereleased(x, y, button)
  self.pressed = false
end

function Button:draw()
  local offset = self.pressed and Button.Shadow or 0

  Color.ButtonShadow:use()
  love.graphics.rectangle("fill", self.position.x, self.position.y + offset, self.size.width, self.size.height - offset)
  Color.ButtonBorder:use()
  love.graphics.rectangle(
    "fill",
    self.position.x + Button.Border,
    self.position.y + Button.Border + offset,
    self.size.width - Button.Border * 2,
    self.size.height - Button.Border * 2 - Button.Shadow
  )
  Color.ButtonBackground:use()
  love.graphics.rectangle(
    "fill",
    self.position.x + Button.Border * 2,
    self.position.y + Button.Border * 2 + offset,
    self.size.width - Button.Border * 4,
    self.size.height - Button.Border * 4 - Button.Shadow
  )
  Color.ButtonTitle:use()

  love.graphics.draw(
    self.text,
    self.position.x + Button.Border * 2 + self.innerWidth * 0.5 - self.text:getWidth() * 0.5,
    self.position.y + Button.Border * 2 + self.innerHeight * 0.5 - self.text:getHeight() * 0.5 + offset
  )

  Color.White:use()
end

return Button
