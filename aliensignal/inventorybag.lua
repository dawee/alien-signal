local bank = require("aliensignal.bank")
local peachy = require("peachy")
local Color = require("aliensignal.color")
local Object = require("classic")

local InventoryBag = Object:extend()

InventoryBag.Height = 256
InventoryBag.Margin = 32
InventoryBag.Border = 4

local pixelcode =
  [[
    #define COLOR1 vec4(217.0 / 256.0, 160.0 / 256.0, 102.0 / 256.0, 1)
    #define COLOR2 vec4(238.0 / 256.0, 195.0 / 256.0, 154.0 / 256.0, 1)

    vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
    {
      return mix(COLOR1, COLOR2, 1 - abs(mod(floor(screen_coords.x / 128), 2) - mod(floor(screen_coords.y / 128), 2)));
    }
]]

local vertexcode =
  [[
    vec4 position(mat4 transform_projection, vec4 vertex_position)
    {
        return transform_projection * vertex_position;
    }
]]

function InventoryBag.Load()
  InventoryBag.Shader = love.graphics.newShader(pixelcode, vertexcode)
end

function InventoryBag:new(navigator)
  self.sprite = peachy.new(bank.misc.spritesheet, bank.misc.image, "inventorybag")
  self.navigator = navigator
  self.transform = love.math.newTransform()
  self.opened = false
  self.position = {
    x = 0,
    y = 768 - self.sprite:getHeight() * 4
  }
end

function InventoryBag:open()
  if not self.opened then
    self.transform:translate(0, -InventoryBag.Height)
    self.opened = true
  end
end

function InventoryBag:close()
  if self.opened then
    self.transform:translate(0, InventoryBag.Height)
    self.opened = false
  end
end

function InventoryBag:mousepressed(x, y, button)
  if
    button == 1 and x >= self.position.x and x <= self.position.x + self.sprite:getWidth() * 4 and y >= self.position.y and
      y <= self.position.y + self.sprite:getHeight() * 4
   then
    self:open()
    return true
  elseif
    self.opened and x < InventoryBag.Margin or
      x > self.position.x + InventoryBag.Margin + 1024 - InventoryBag.Margin * 2 or
      y < 768 - InventoryBag.Height
   then
    self:close()
  end
end

function InventoryBag:update(dt)
  self.sprite:update(dt)
end

function InventoryBag:draw()
  love.graphics.applyTransform(self.transform)
  Color.InventoryBorder:use()
  love.graphics.rectangle(
    "fill",
    self.position.x + InventoryBag.Margin,
    self.position.y + 128 - InventoryBag.Border,
    1024 - InventoryBag.Margin * 2,
    768
  )
  Color.White:use()

  love.graphics.setShader(InventoryBag.Shader)
  love.graphics.rectangle(
    "fill",
    self.position.x + InventoryBag.Margin + InventoryBag.Border,
    self.position.y + 128,
    1024 - InventoryBag.Margin * 2 - InventoryBag.Border * 2,
    768
  )
  love.graphics.setShader()

  self.sprite:draw(self.position.x, self.position.y, 0, 4, 4)
end

return InventoryBag
