local bank = require("aliensignal.bank")
local input = require("aliensignal.input")
local peachy = require("peachy")
local Color = require("aliensignal.color")
local InventoryBag = require("aliensignal.inventorybag")
local Generator = require("aliensignal.module.generator")
local Sampler = require("aliensignal.module.sampler")
local Navigator = require("navigator")
local Output = require("aliensignal.module.output")
local SignalScreen = require("aliensignal.signalscreen")

local waves = {
  sine = require("aliensignal.wave.sine"),
  width3gate = require("aliensignal.wave.width3gate")
}

local MachineScreen = Navigator.Screen:extend()

MachineScreen.Size = 20

MachineScreen.Wave = {
  Top = 0,
  Left = 90,
  Length = 760,
  Height = 24,
  LeftPadding = 40,
  TopPadding = 3,
  Duration = 8,
  GuidePeriod = 0.125,
  Precision = 0.0125,
  GuideHeight = 40
}

function MachineScreen.Load()
  InventoryBag.Load()
end

MachineScreen.SignalScreen = SignalScreen:extend()

function MachineScreen.SignalScreen:new(machine, ...)
  SignalScreen.new(self, ...)
  self.machine = machine
end

function MachineScreen.SignalScreen:computeSignalAtTime(time, signalName)
  if signalName == "target" then
    return self.machine.targetSignal and self.machine.targetSignal[math.floor(time * self.exportTimeCoef)] or nil
  end

  local output = nil

  for x, module_col in pairs(self.machine.modules) do
    for y, mod in pairs(module_col) do
      if mod:is(Output) then
        output = mod
        break
      end
    end
  end

  return output:computeRightOutput(time, self.precision)
end

function MachineScreen:new(...)
  Navigator.Screen.new(self, ...)

  self.shader =
    love.graphics.newShader(
    [[
    #define COLOR1 vec4(153 / 256.0, 229 / 256.0, 80 / 256.0, 1)
    #define COLOR2 vec4(205 / 256.0, 244 / 256.0, 102 / 256.0, 1)

    uniform vec2 drag;

    vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
    {
      vec2 coords = drag + screen_coords;

      return mix(COLOR1, COLOR2, 1 - abs(mod(floor(coords.x / 128), 2) - mod(floor(coords.y / 128), 2)));
    }
  ]]
  )

  self.drag = {dx = 0, dy = 0}

  self.transform = love.math.newTransform()
  self.modules = {}

  self:addModule({x = 1, y = 4}, Generator)
  self:addModule({x = 2, y = 3}, Sampler)
  self:addModule({x = 6, y = 4}, Output)

  self.inventoryBag = InventoryBag(self.navigator)

  self.inventoryBag.onDrop:subscribe(
    function(props)
      local x = props.x + self.drag.dx
      local y = props.y + self.drag.dy

      local newSlot = {
        x = math.floor(x / 128) + 1,
        y = math.floor(y / 128) + 1
      }

      if not self.modules[newSlot.x] then
        self.modules[newSlot.x] = {}
      end

      if not self.modules[newSlot.x][newSlot.y] then
        self.modules[newSlot.x][newSlot.y] = props.item
        props.item.slot = newSlot
        props.item.modules = self.modules
        props.item:updatePosition()
        self.inventoryBag:pop(props.item)
      else
        self.inventoryBag:store("modules", props.item)
      end
    end
  )

  self.inventoryBag.onSetSignal:subscribe(
    function(signal)
      self.targetSignal = signal
    end
  )

  self.signalScreen =
    MachineScreen.SignalScreen(
    self,
    {x = MachineScreen.Wave.Left, y = MachineScreen.Wave.Top},
    MachineScreen.Wave.LeftPadding * 2 + MachineScreen.Wave.Length
  )
end

function MachineScreen:transformWavePoints(wave)
  local points = {}

  for index, pointData in pairs(wave) do
    local point = self:computeWavePoint(pointData.i, pointData.y)

    table.insert(points, point.x)
    table.insert(points, point.y)
  end

  return points
end

function MachineScreen:computeWavePoint(i, y)
  return {
    x = MachineScreen.Wave.Left + i + MachineScreen.Wave.LeftPadding,
    y = MachineScreen.Wave.Top + MachineScreen.Wave.TopPadding + self.signalScreen:getHeight() * 2 -
      y * MachineScreen.Wave.Height / 2
  }
end

function MachineScreen:open(props)
  self.inventoryBag:fill(props.inventory)
end

function MachineScreen:addModule(slot, ModuleType)
  if not self.modules[slot.x] then
    self.modules[slot.x] = {}
  end

  self.modules[slot.x][slot.y] = ModuleType(slot, self.modules)
end

function MachineScreen:computeTime(i)
  return i * MachineScreen.Wave.Duration / (MachineScreen.Wave.Length + MachineScreen.Wave.LeftPadding)
end

function MachineScreen:update(dt)
  for x, module_col in pairs(self.modules) do
    for y, mod in pairs(module_col) do
      mod:update(dt)
    end
  end

  self.inventoryBag:update(dt)
  self.signalScreen:update(dt)
end

function MachineScreen:mousemoved(x, y, dx, dy)
  if self.inventoryBag:mousemoved(x, y, dx, dy) then
    return
  end

  if self.sliding then
    local normalizedDrag = {
      dx = math.min(math.max(0, self.drag.dx - dx), 1024 * 100),
      dy = math.min(math.max(0, self.drag.dy - dy), 768 * 100)
    }

    self.transform:translate(self.drag.dx - normalizedDrag.dx, self.drag.dy - normalizedDrag.dy)
    self.drag = normalizedDrag
    self.shader:send("drag", {self.drag.dx, self.drag.dy})
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
    local draggedx = x + self.drag.dx
    local draggedy = y + self.drag.dy

    self.movingModule =
      self.modules[math.floor(draggedx / 128) + 1] and
      self.modules[math.floor(draggedx / 128) + 1][math.floor(draggedy / 128) + 1]
  end
end

function MachineScreen:mousereleased(x, y, button, istouch)
  if self.inventoryBag:mousereleased(x, y, button, istouch) then
    return
  end

  if button == 2 then
    self.sliding = false
  elseif self.movingModule and button == 1 then
    local draggedx = x + self.drag.dx
    local draggedy = y + self.drag.dy

    local newSlot = {
      x = math.floor(draggedx / 128) + 1,
      y = math.floor(draggedy / 128) + 1
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

  love.graphics.setShader(self.shader)
  love.graphics.rectangle("fill", 0, 0, 1024 * 100, 768 * 100)
  love.graphics.setShader()

  for x, module_col in pairs(self.modules) do
    for y, mod in pairs(module_col) do
      mod:draw()
    end
  end

  love.graphics.pop()

  self.signalScreen:draw()
  self.inventoryBag:draw()
end

return MachineScreen
