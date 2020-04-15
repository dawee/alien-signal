local bank = require("aliensignal.bank")
local peachy = require("peachy")
local Color = require("aliensignal.color")
local Event = require("event")
local Object = require("classic")

local InventoryBag = Object:extend()

InventoryBag.Height = 256
InventoryBag.Margin = 32
InventoryBag.Border = 4
InventoryBag.ColsCount = 6
InventoryBag.ColsMargin = 64
InventoryBag.ItemSize = 128

InventoryBag.Slot = Object:extend()

function InventoryBag.Slot:new(item, index)
  self.index = index
  self.name = item.name
  self.items = {item}
  self.text = love.graphics.newText(InventoryBag.Font, "1")
  self.countTransform = love.math.newTransform()
  self.onDrop = Event()

  self:initItemPosition(item)
  self.countTransform:translate(item.position.x + 127, item.position.y + 127)
end

function InventoryBag.Slot:initItemPosition(item)
  local col = (self.index - 1) % InventoryBag.ColsCount + 1
  local row = math.floor((self.index - 1) / InventoryBag.ColsCount)

  item.position = {
    x = col * InventoryBag.ItemSize,
    y = 768 + row * InventoryBag.ItemSize
  }
end

function InventoryBag.Slot:add(item)
  if item.name == self.name then
    table.insert(self.items, item)
    self:initItemPosition(item)
    return true
  end

  return false
end

function InventoryBag.Slot:update(dt)
  for index, item in pairs(self.items) do
    item:update(dt)
  end

  if self.movingItem then
    self.movingItem:update(dt)
  end

  self.text:set(tostring(table.getn(self.items)))
end

function InventoryBag.Slot:mousemoved(x, y, dx, dy)
  if self.movingItem then
    self.movingItem.position.x = self.movingItem.position.x + dx
    self.movingItem.position.y = self.movingItem.position.y + dy
  end
end

function InventoryBag.Slot:mousereleased(x, y, button, istouch)
  if self.movingItem then
    self.onDrop:trigger({item = self.movingItem, x = x, y = y})
    self.movingItem = nil
  end
end

function InventoryBag.Slot:mousepressed(x, y, button)
  local item = self.items[table.getn(self.items)]

  if
    item and x > item.position.x and x < item.position.x + InventoryBag.ItemSize and
      y > item.position.y - InventoryBag.Height and
      y < item.position.y - InventoryBag.Height + InventoryBag.ItemSize
   then
    self.movingItem = table.remove(self.items, table.getn(self.items))
    return true
  end
end

function InventoryBag.Slot:draw()
  for index, item in pairs(self.items) do
    item:draw()
  end

  if self.movingItem then
    self.movingItem:draw()
  end

  love.graphics.push()
  love.graphics.applyTransform(self.countTransform)
  love.graphics.polygon("fill", -8, -4, -40, -4, -44, -8, -44, -16, -40, -20, -8, -20, -4, -16, -4, -8)
  Color.Black:use()
  love.graphics.draw(self.text, -44 + (36 - self.text:getWidth()) / 2, -20)
  love.graphics.setColor(1, 1, 1, 0.5)

  love.graphics.rectangle(
    "line",
    -InventoryBag.ItemSize + 1,
    -InventoryBag.ItemSize + 1,
    InventoryBag.ItemSize,
    InventoryBag.ItemSize
  )

  Color.White:use()
  love.graphics.pop()
end

function InventoryBag.Load()
  InventoryBag.Shader =
    love.graphics.newShader(
    [[
    #define COLOR1 vec4(217.0 / 256.0, 160.0 / 256.0, 102.0 / 256.0, 1)
    #define COLOR2 vec4(238.0 / 256.0, 195.0 / 256.0, 154.0 / 256.0, 1)

    vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
    {
      return mix(COLOR1, COLOR2, 1 - abs(mod(floor(screen_coords.x / 128), 2) - mod(floor(screen_coords.y / 128), 2)));
    }
  ]]
  )

  InventoryBag.Font = love.graphics.newFont("assets/fonts/emulogic.ttf", 12)
end

function InventoryBag:new(navigator)
  self.sprite = peachy.new(bank.misc.spritesheet, bank.misc.image, "inventorybag")
  self.navigator = navigator
  self.transform = love.math.newTransform()
  self.opened = false
  self.onDrop = Event()
  self.slots = {}
  self.inventory = {}
  self.position = {
    x = 0,
    y = 768 - self.sprite:getHeight() * 4
  }
end

function InventoryBag:fill(inventory)
  self.inventory = inventory
end

function InventoryBag:prepareSlots()
  self.slots = {}

  for index, item in ipairs(self.inventory) do
    local itemAdded = false

    for slotIndex, slot in ipairs(self.slots) do
      if slot:add(item) then
        itemAdded = true
        break
      end
    end

    if not itemAdded then
      local newSlot = InventoryBag.Slot(item, table.getn(self.slots) + 1)

      newSlot.onDrop:subscribe(
        function(data)
          self.onDrop:trigger(data)
        end
      )

      table.insert(self.slots, newSlot)
    end
  end
end

function InventoryBag:pop(itemToPop)
  local newInventory = {}

  for index, item in pairs(self.inventory) do
    if not (item == itemToPop) then
      table.insert(newInventory, item)
    end
  end

  self.inventory = newInventory
end

function InventoryBag:store(item)
  for index, slot in pairs(self.slots) do
    if slot:add(item) then
      break
    end
  end
end

function InventoryBag:open()
  if not self.opened then
    self:prepareSlots()
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

function InventoryBag:mousemoved(x, y, dx, dy)
  if self.opened then
    for index, slot in pairs(self.slots) do
      slot:mousemoved(x, y, dx, dy)
    end
  end
end

function InventoryBag:mousepressed(x, y, button)
  if
    self.opened and x < InventoryBag.Margin or
      x > self.position.x + InventoryBag.Margin + 1024 - InventoryBag.Margin * 2 or
      y < 768 - InventoryBag.Height
   then
    self:close()
  elseif self.opened then
    for index, slot in pairs(self.slots) do
      if slot:mousepressed(x, y, button) then
        break
      end
    end

    return true
  elseif
    button == 1 and x >= self.position.x + InventoryBag.Margin and x <= self.position.x + self.sprite:getWidth() * 4 and
      y >= self.position.y + InventoryBag.Margin and
      y <= self.position.y + self.sprite:getHeight() * 4
   then
    self:open()
    return true
  end
end

function InventoryBag:mousereleased(x, y, button, istouch)
  if self.opened then
    for index, slot in pairs(self.slots) do
      slot:mousereleased(x, y, button, istouch)
    end
  end
end

function InventoryBag:update(dt)
  self.sprite:update(dt)

  for index, slot in pairs(self.slots) do
    slot:update(dt)
  end
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

  for index, slot in pairs(self.slots) do
    slot:draw()
  end
end

return InventoryBag
