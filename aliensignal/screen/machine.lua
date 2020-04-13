local bank = require("aliensignal.bank")
local peachy = require("peachy")
local AndGate = require("aliensignal.module.andgate")
local OrGate = require("aliensignal.module.orgate")
local Booster = require("aliensignal.module.booster")
local Decreaser = require("aliensignal.module.decreaser")
local Color = require("aliensignal.color")
local Coupler = require("aliensignal.module.coupler")
local InventoryBag = require("aliensignal.inventorybag")
local Generator = require("aliensignal.module.generator")
local Navigator = require("navigator")
local Sampler = require("aliensignal.module.sampler")
local Wire = require("aliensignal.module.wire")
local Output = require("aliensignal.module.output")
local DownLeftShoulder = require("aliensignal.module.downleftshoulder")
local DownRightShoulder = require("aliensignal.module.downrightshoulder")
local UpLeftShoulder = require("aliensignal.module.upleftshoulder")
local UpRightShoulder = require("aliensignal.module.uprightshoulder")

local MachineScreen = Navigator.Screen:extend()

MachineScreen.Size = 20

MachineScreen.Wave = {
  Top = 0,
  Left = 32,
  Length = 800,
  Height = 24,
  LeftPadding = 40,
  TopPadding = 3,
  Duration = 8
}

local pixelcode =
  [[
    #define COLOR1 vec4(153 / 256.0, 229 / 256.0, 80 / 256.0, 1)
    #define COLOR2 vec4(205 / 256.0, 244 / 256.0, 102 / 256.0, 1)

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

function MachineScreen.Load()
  MachineScreen.Shader = love.graphics.newShader(pixelcode, vertexcode)
  InventoryBag.Load()
end

function MachineScreen:new(...)
  Navigator.Screen.new(self, ...)

  self.transform = love.math.newTransform()

  self.modules = {}

  self:addModule({x = 1, y = 4}, Generator)
  self:addModule({x = 2, y = 4}, Sampler)
  self:addModule({x = 3, y = 4}, Booster)
  self:addModule({x = 4, y = 4}, Booster)
  self:addModule({x = 6, y = 4}, Output)
  self:addModule({x = 1, y = 5}, UpLeftShoulder)
  self:addModule({x = 2, y = 5}, UpRightShoulder)
  self:addModule({x = 3, y = 5}, DownLeftShoulder)
  self:addModule({x = 4, y = 5}, DownRightShoulder)
  self:addModule({x = 5, y = 5}, AndGate)
  self:addModule({x = 6, y = 5}, Coupler)
  self:addModule({x = 1, y = 6}, UpLeftShoulder)
  self:addModule({x = 2, y = 6}, UpRightShoulder)
  self:addModule({x = 3, y = 6}, DownLeftShoulder)
  self:addModule({x = 4, y = 6}, Decreaser)
  self:addModule({x = 5, y = 6}, OrGate)
  self:addModule({x = 6, y = 6}, Coupler)
  self:addModule({x = 7, y = 6}, Wire)

  self.inventoryBag = InventoryBag(self.navigator)
  self.sprites = {
    signalScreenLeft = peachy.new(bank.signalscreen.spritesheet, bank.signalscreen.image, "left"),
    signalScreenRight = peachy.new(bank.signalscreen.spritesheet, bank.signalscreen.image, "right"),
    signalScreenMiddle = peachy.new(bank.signalscreen.spritesheet, bank.signalscreen.image, "middle")
  }
end

function MachineScreen:addModule(slot, ModuleType)
  if not self.modules[slot.x] then
    self.modules[slot.x] = {}
  end

  self.modules[slot.x][slot.y] = ModuleType(slot, self.modules)
end

function MachineScreen:update(dt)
  self.points = {}

  local output = nil

  for x, module_col in pairs(self.modules) do
    for y, mod in pairs(module_col) do
      if mod:is(Output) then
        output = mod
        break
      end
    end
  end

  if output then
    for i = 0, MachineScreen.Wave.Length + MachineScreen.Wave.LeftPadding, 1 do
      local time = i * MachineScreen.Wave.Duration / MachineScreen.Wave.Length
      local y = output:computeRightOutput(time)

      table.insert(self.points, MachineScreen.Wave.Left + i + MachineScreen.Wave.LeftPadding)
      table.insert(
        self.points,
        MachineScreen.Wave.Top + MachineScreen.Wave.TopPadding + self.sprites.signalScreenMiddle:getHeight() * 2 -
          y * MachineScreen.Wave.Height / 2
      )
    end
  end

  for x, module_col in pairs(self.modules) do
    for y, mod in pairs(module_col) do
      mod:update(dt)
    end
  end

  self.inventoryBag:update(dt)

  for index, sprite in pairs(self.sprites) do
    sprite:update(dt)
  end
end

function MachineScreen:mousemoved(x, y, dx, dy)
  if self.sliding then
    self.transform:translate(dx, dy)
  elseif self.movingModule then
    self.movingModule.position.x = self.movingModule.position.x + dx
    self.movingModule.position.y = self.movingModule.position.y + dy
  end
end

function MachineScreen:mousepressed(x, y, button, istouch)
  if self.inventoryBag:mousepressed(x, y, button, istouch) then
    return
  end

  if button == 2 then
    self.sliding = true
  elseif button == 1 then
    self.movingModule =
      self.modules[math.floor(x / 128) + 1] and self.modules[math.floor(x / 128) + 1][math.floor(y / 128) + 1]
  end
end

function MachineScreen:mousereleased(x, y, button, istouch)
  if button == 2 then
    self.sliding = false
  elseif self.movingModule and button == 1 then
    local newSlot = {
      x = math.floor(x / 128) + 1,
      y = math.floor(y / 128) + 1
    }

    if not self.modules[newSlot.x] then
      self.modules[newSlot.x] = {}
    end

    if not self.modules[newSlot.x][newSlot.y] then
      self.modules[self.movingModule.slot.x][self.movingModule.slot.y] = nil
      self.modules[newSlot.x][newSlot.y] = self.movingModule
    else
      newSlot = self.movingModule.slot
    end

    self.movingModule.slot = newSlot
    self.movingModule:updatePosition()
    self.movingModule = nil
  end
end

function MachineScreen:draw()
  love.graphics.push()
  love.graphics.applyTransform(self.transform)

  love.graphics.setShader(MachineScreen.Shader)
  love.graphics.rectangle("fill", 0, 0, 1024 * 100, 768 * 100)
  love.graphics.setShader()

  for x, module_col in pairs(self.modules) do
    for y, mod in pairs(module_col) do
      mod:draw()
    end
  end

  love.graphics.pop()

  self.sprites.signalScreenLeft:draw(MachineScreen.Wave.Left, MachineScreen.Wave.Top, 0, 4, 4)
  self.sprites.signalScreenMiddle:draw(
    MachineScreen.Wave.Left + self.sprites.signalScreenLeft:getWidth() * 4,
    MachineScreen.Wave.Top,
    0,
    MachineScreen.Wave.Length / self.sprites.signalScreenMiddle:getWidth(),
    4
  )
  self.sprites.signalScreenRight:draw(
    MachineScreen.Wave.Left + self.sprites.signalScreenLeft:getWidth() * 4 + MachineScreen.Wave.Length,
    MachineScreen.Wave.Top,
    0,
    4,
    4
  )

  Color.Signal:use()

  if self.points and table.getn(self.points) > 1 then
    love.graphics.line(unpack(self.points))
  end

  Color.White:use()

  self.inventoryBag:draw()
end

return MachineScreen
